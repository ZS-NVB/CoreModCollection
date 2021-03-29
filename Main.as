package {
	import flash.display.MovieClip;
	import flash.filesystem.*;
	import mods.*;
	
	public class Main extends MovieClip {
		public const VERSION:String = "1.3";
		public const GAME_VERSION:String = "1.2.1a";
		public const BEZEL_VERSION:String = "0.3.1";
		public const MOD_NAME:String = "CoreModCollection";
		public var COREMOD_VERSION:String = "";
		
		private var modArray:Array;
		private var config:Object;
		private var currentMod:String;
		private var files:Object;
		private var functions:Object;
		private var filename:String;
		private var fileContents:String;
		private var functionContents:String;
		private var functionOffset:int;
		private var functionLocals:Object;
		private var functionNamespaces:String;
		private var patches:Object;
		
		public function Main() {
			super();
			modArray = new Array();
			modArray.push(new RangeAdjustmentFix());
			modArray.push(new BetterResonance());
			modArray.push(new LanternMuter());
			modArray.push(new NoTalismanLocks());
			modArray.push(new AllFragmentsHaveRunes());
			modArray.push(new RotatableFragments());
			modArray.push(new IceShardsDamageReversion());
			modArray.push(new BetterTrueColors());
			modArray.push(new EnrageAnyWave());
			modArray.push(new JourneyTraits());
			modArray.push(new JourneyGems());
			modArray.push(new BetterBleeding());
			modArray.push(new BleedingMultiplierDisplay());
			modArray.push(new BetterSlowing());
			modArray.push(new TrapTargetFix());
			modArray.push(new Rarity100PlusFragments());
			modArray.push(new BetterCritChance());
			modArray.push(new ShrineFix());
			modArray.push(new AchievementDisabler());
			modArray.push(new ProportionateFragmentDrops());
			modArray.push(new MapLimitsRemover());
			modArray.push(new ModUnlocker());
			modArray.push(new TrapRangeIncrease());
			modArray.push(new BetterManaStream());
			modArray.push(new TrapRangeDisplay());
			modArray.sortOn("MOD_NAME");
			var folder:File = File.applicationStorageDirectory.resolvePath(MOD_NAME);
			if (!folder.isDirectory) {
				folder.createDirectory();
			}
			var file:File = folder.resolvePath("Config.txt");
			var stream:FileStream = new FileStream();
			try {
				stream.open(file, FileMode.READ);
				config = JSON.parse(stream.readUTFBytes(stream.bytesAvailable));
			} catch (error:Error) {
				config = new Object();
			}
			stream.close();
			var modNotFound:Boolean = false;
			var coreModVersions:Array = new Array();
			var output:Array = new Array();
			for (var i:* in modArray) {
				var mod:Object = modArray[i];
				if (!(mod.MOD_NAME in config)) {
					config[mod.MOD_NAME] = true;
					modNotFound = true;
				}
				coreModVersions.push(config[mod.MOD_NAME] ? mod.COREMOD_VERSION : "0");
				output.push("\"" + mod.MOD_NAME + "\":" + config[mod.MOD_NAME].toString());
			}
			COREMOD_VERSION = coreModVersions.join();
			if (modNotFound) {
				stream.open(file, FileMode.WRITE);
				stream.writeUTFBytes("{\n" + output.join(",\n") + "\n}");
				stream.close();
			}
			//COREMOD_VERSION = Math.random().toString();
		}
		
		public function modifyFile(filename:String, f:Function) : void {
			if (!(filename in files)) {
				files[filename] = new Array();
			}
			files[filename].push({f: f, mod: currentMod});
		}
		
		public function modifyFunction(identifier:String, f:Function) : void {
			if (!(identifier in functions)) {
				functions[identifier] = new Array();
			}
			functions[identifier].push({f: f, mod: currentMod});
		}
		
		public function format(input:String, jumpTargets:Object = null) : String {
			function repl(matchedSubstring:String, capturedMatch:String, index:int, str:String): String {
				if (capturedMatch == "namespaces") {
					return functionNamespaces;
				} else if (functionLocals != null && capturedMatch in functionLocals) {
					return functionLocals[capturedMatch];
				} else if (jumpTargets != null && capturedMatch in jumpTargets) {
					return jumpTargets[capturedMatch];
				} else {
					return matchedSubstring;
				}
			}
			return input.replace(/{([^}]+)}/g, repl);
		}
		
		public function getJumpTargets(...args:*) : Object {
			var jumpTargets:Object = new Object();
			for (var i:* in args) {
				jumpTargets[args[i]] = Math.random().toString();
			}
			return jumpTargets;
		}
		
		public function requireMaxStack(stackSize:int) : void {
			var result:Object = /^maxstack \d+\n/m.exec(functionContents);
			applyPatch(result.index + result[0].length, 0, "maxstack " + stackSize.toString());
		}
		
		public function applyPatch(offset:int, replace:int, add:String = "") : void {
			offset += functionOffset;
			var lineOffset:int = fileContents.substr(0, offset).split('\n').length - 1;
			var replaceLines:int = fileContents.substr(offset, replace).split('\n').length - 1;
			if (!(currentMod in patches)) {
				patches[currentMod] = new Array();
			}
			patches[currentMod].push([filename, lineOffset, replaceLines, add]);
		}
		
		public function loadCoreMod(lattice:Object) : void {
			var failedMods:Object = {};
			patches = new Object();
			files = new Object();
			for (var i:* in modArray) {
				var mod:Object = modArray[i];
				if (config[mod.MOD_NAME]) {
					currentMod = mod.MOD_NAME;
					try {
						mod.loadCoreMod(this);
					} catch (error:Error) {
						failedMods[currentMod] = error.message;
					}
				}
			}
			for (var filename:String in files) {
				this.filename = filename;
				fileContents = lattice.retrieveFile(filename);
				functionOffset = 0;
				functions = new Object();
				for (var j:* in files[filename]) {
					currentMod = files[filename][j].mod;
					try {
						files[filename][j].f(fileContents);
					} catch (error:Error) {
						failedMods[currentMod] = error.message;
					}
				}
				for (var identifier:String in functions) {
					var regex:RegExp;
					if (identifier == "iinit" || identifier == "cinit") {
						regex = new RegExp("^" + identifier + "$.+?^end ; method$", "ms");
					} else {
						regex = new RegExp("^trait method " + identifier.replace(/[()]/g, "\\$&") + "$.+?^end ; trait$", "ms");
					}
					var result:Object = regex.exec(fileContents);
					var functionNotFound:Boolean = (result == null);
					if (!functionNotFound) {
						functionOffset = result.index;
						functionContents = result[0];
						functionLocals = new Object();
						regex = /^debug 1, "([^"]+)", (\d+), \d+$/gm;
						result = regex.exec(functionContents);
						while (result != null) {
							functionLocals[result[1]] = (int(result[2]) + 1).toString();
							result = regex.exec(functionContents);
						}
						functionNamespaces = "";
						regex = /^\w+ Multiname.+?(\[[^\]]+\])/m;
						result = regex.exec(functionContents);
						if (result != null) {
							functionNamespaces = result[1];
						}
					}
					for (var k:* in functions[identifier]) {
						currentMod = functions[identifier][k].mod;
						try {
							if (functionNotFound) {
								throw new Error("function identifier " + identifier + " not found in " + filename);
							}
							functions[identifier][k].f(functionContents);
						} catch (error:Error) {
							failedMods[currentMod] = error.message;
						}
					}
				}
			}
			var folder:File = File.applicationStorageDirectory.resolvePath(MOD_NAME);
			if (!folder.isDirectory) {
				folder.createDirectory();
			}
			var file:File = folder.resolvePath("Errors.txt");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			for (var modName:String in patches) {
				if (!(modName in failedMods)) {
					for (var l:* in patches[modName]) {
						var patch:Object = patches[modName][l];
						lattice.patchFile(patch[0], patch[1], patch[2], patch[3]);
					}
				} else {
					stream.writeUTFBytes(modName + " failed:" + failedMods[modName]);
				}
			}
			stream.close();
		}
		
		public function bind(modLoader:Object, gameObjects:Object) : Main {
			return this;
		}
		
		public function unload() : void {}
	}
}