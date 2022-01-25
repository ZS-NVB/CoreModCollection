package {
	import flash.display.MovieClip;
	import flash.filesystem.*;
	import mods.*;
	import Bezel.BezelCoreMod;
	import Bezel.Lattice.Lattice;
	import Bezel.Utils.SettingManager;
	import Bezel.Bezel;
	
	public class Main extends MovieClip implements BezelCoreMod {
		public function get VERSION():String { return "1.6.0"; }
		public function get GAME_VERSION():String { return "1.2.1a"; }
		public function get BEZEL_VERSION():String { return "1.1.1"; }
		public function get MOD_NAME():String { return "CoreModCollection"; }
		
		private var _COREMOD_VERSION:String;
		public function get COREMOD_VERSION():String {return _COREMOD_VERSION; };
		
		private var modArray:Array;
		private var settings:SettingManager;
		private var currentMod:String;
		private var files:Object;
		private var functions:Object;
		private var filename:String;
		private var fileContents:String;
		private var functionIdentifier:String;
		private var functionContents:String;
		private var functionOffset:int;
		private var functionLocals:Object;
		private var functionNamespaces:String;
		private var patches:Object;
		
		public function Main() {
			super();
			settings = Bezel.Bezel.instance.getSettingManager(MOD_NAME);
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
			modArray.push(new DamageEstimationFix());
			modArray.push(new FreezeCritDamageFix());
			modArray.push(new BarrageTargetLimitRemover());
			modArray.push(new ManaLeechFixes());
			modArray.push(new IndividualBeamHits());
			modArray.push(new ConstantSkillPointCost());
			modArray.push(new MultiplicativeBoundModifiers());
			modArray.push(new NoRitualWizardHunters());
			modArray.push(new BetterGemBombs());
			modArray.push(new UncappedSkills());
			modArray.push(new LinearSkillEffects());
			modArray.push(new IceShardsChange());
			modArray.push(new StatFixes());
			modArray.push(new FreezeDiminishingReturns());
			modArray.push(new FreezeCooldownReversion());
			modArray.push(new BetterFusion());
			modArray.push(new BetterOrb());
			modArray.push(new BetterFury());
			modArray.push(new WhiteoutOrbKillsReversion());
			modArray.push(new LevelCapRemover());
			modArray.sortOn("MOD_NAME");
			var coreModVersions:Array = new Array();
			for each (var mod:Object in modArray) {
				settings.registerBoolean(mod.MOD_NAME, null, true, "Restart required on change");
				coreModVersions.push(settings.retrieveBoolean(mod.MOD_NAME) ? mod.COREMOD_VERSION : "0");
			}
			_COREMOD_VERSION = coreModVersions.join();
			//_COREMOD_VERSION = Math.random().toString();
		}
		
		public function modifyFile(filename:String, f:Function, ...args:*) : void {
			if (!(filename in files)) {
				files[filename] = new Array();
			}
			files[filename].push({f: f, mod: currentMod, args: args});
		}
		
		public function modifyFunction(identifier:String, f:Function, ...args:*) : void {
			identifier = identifier.replace(',"', ', "');
			if (!(identifier in functions)) {
				functions[identifier] = new Array();
			}
			functions[identifier].push({f: f, mod: currentMod, args: args});
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
		
		public function formatLocals(matchedSubstring:String, instruction:String, local:String, index:int, str:String) : String {
			if (!local.match(/^\w+$/)) {
				return matchedSubstring;
			}
			if (functionLocals != null) {
				if (local in functionLocals) {
					local = functionLocals[local];
				} else if (int(local) == 0 && local != "0") {
					throw new Error("local " + local + " not found in function " + functionIdentifier + " in file " + filename);
				}
			}
			var result:String = instruction;
			if ((instruction != "getlocal" && instruction != "setlocal") || int(local) > 3) {
				result += " ";
			}
			return result + local;
		}
		
		public function regex(pattern:String, options:String = null ) : RegExp {
			pattern = pattern.replace(/([gs]etlocal|(?:in|de)clocal(?:_i)?|kill) (.+)$/gm, formatLocals);
			pattern = pattern.replace(/QName\((\w+)\("([^"]*)"\), ?"([^"]+)"\)/g, 'QName\\($1\\("$2"\\), "$3"\\)');
			pattern = pattern.replace(/MultinameL\(\)/g, 'MultinameL\\(\\[[^\\]]+\\]\\)');
			pattern = pattern.replace(/Multiname\("(\w+)"\)/g, 'Multiname\\("$1", \\[[^\\]]+\\]\\)');
			return new RegExp(pattern, options);
		}
		
		public function applyPatch(offset:int, replace:int, add:String = "", jumpTargets:Object = null) : void {
			function formatJump(matchedSubstring:String, instruction:String, jumpTarget:String, index:int, str:String) : String {
				if (jumpTargets != null && jumpTarget in jumpTargets) {
					return instruction + " " + jumpTargets[jumpTarget];
				} else if (!jumpTarget.match(/^L\d+$/) && !jumpTarget.match(/^0\.\d+$/)) {
					throw new Error("Jump target " + jumpTarget + " not found");
				}
				return matchedSubstring;
			}
			function formatJumpTarget(matchedSubstring:String, jumpTarget:String, index:int, str:String) : String {
				if (jumpTargets != null && jumpTarget in jumpTargets) {
					return jumpTargets[jumpTarget] + ":";
				} else if (!jumpTarget.match(/^L\d+$/) && !jumpTarget.match(/^0\.\d+$/)) {
					throw new Error("Jump target " + jumpTarget + " not found");
				}
				return matchedSubstring;
			}
			add = add.replace(/^(if\w+|jump) (\w+)$/gm, formatJump);
			add = add.replace(/^(\w+):$/gm, formatJumpTarget);
			add = add.replace(/^([gs]etlocal|(?:in|de)clocal(?:_i)?|kill) (\w+)$/gm, formatLocals);
			add = add.replace(/MultinameL\(\)/g, 'MultinameL(' + functionNamespaces + ')');
			add = add.replace(/Multiname\("(\w+)"\)/g, 'Multiname("$1", ' + functionNamespaces + ')');
			offset += functionOffset;
			if (replace < 0) {
				replace = -replace;
				offset -= replace;
			}
			var lineOffset:int = fileContents.substr(0, offset).split('\n').length - 1;
			var replaceLines:int = fileContents.substr(offset, replace).split('\n').length - 1;
			if (!(currentMod in patches)) {
				patches[currentMod] = new Array();
			}
			patches[currentMod].push([filename, lineOffset, replaceLines, add]);
		}
		
		public function loadCoreMod(lattice:Lattice) : void {
			var failedMods:Object = {};
			patches = new Object();
			files = new Object();
			for (var i:* in modArray) {
				var mod:Object = modArray[i];
				if (settings.retrieveBoolean(mod.MOD_NAME)) {
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
				functionLocals = null;
				functionNamespaces = '[PackageNamespace("")]'
				functions = new Object();
				for (var j:* in files[filename]) {
					currentMod = files[filename][j].mod;
					try {
						files[filename][j].args.insertAt(0, fileContents);
						files[filename][j].f.apply(null, files[filename][j].args);
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
						functionIdentifier = identifier;
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
						} else {
							functionNamespaces = '[PackageNamespace("")]'
						}
					}
					for (var k:* in functions[identifier]) {
						currentMod = functions[identifier][k].mod;
						try {
							if (functionNotFound) {
								throw new Error("function identifier " + identifier + " not found in " + filename);
							}
							functions[identifier][k].args.insertAt(0, functionContents);
							functions[identifier][k].f.apply(null, functions[identifier][k].args);
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
					stream.writeUTFBytes(modName + " failed:" + failedMods[modName] + "\n");
				}
			}
			stream.close();
		}
		
		public function bind(modLoader:Bezel, gameObjects:Object) : void {}
		
		public function unload() : void {}
	}
}
