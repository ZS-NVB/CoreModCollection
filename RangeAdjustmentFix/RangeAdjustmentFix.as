package {
	import flash.display.MovieClip;
	
	public class RangeAdjustmentFix extends MovieClip {
		public const VERSION:String = "1.0";
		public const GAME_VERSION:String = "1.2.1a";
		public const BEZEL_VERSION:String = "0.3.1";
		public const MOD_NAME:String = "RangeAdjustmentFix";
		public const COREMOD_VERSION:String = "1";
		
		private var lattice:Object;
		private var filename:String;
		private var fileContents:String;
		private var functionOffset:int;
		private var functionContents:String;
		private var functionLocals:Object;
		private var functionNamespaces:String;
		private var regex:RegExp;
		private var result:Object;
		
		public function RangeAdjustmentFix() {
			super();
		}
		
		private function modifyFile(filename:String, f:Function): void {
			this.filename = filename;
			fileContents = lattice.retrievePattern(filename, /.+/s);
			f();
		}
		
		private function modifyFunction(identifier:String, f:Function): void {
			var regex:RegExp;
			if (identifier == "iinit" || identifier == "cinit") {
				regex = new RegExp("^" + identifier + "$.+?^end ; method$", "ms");
			} else {
				regex = new RegExp("^trait method " + identifier.replace(/[()]/g, "\\$&") + "$.+?^end ; trait$", "ms");
			}
			var result:Object = regex.exec(fileContents);
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
			f();
			functionOffset = 0;
			functionLocals = null;
		}
		
		private function applyPatch(offset:int, replace:int, add:String): void {
			offset += functionOffset;
			var lineOffset:int = fileContents.substr(0, offset).split('\n').length - 1;
			var replaceLines:int = fileContents.substr(offset, replace).split('\n').length - 1;
			lattice.patchFile(filename, lineOffset, replaceLines, add);
		}
		
		private function format(input:String, jumpTargets:Object = null): String {
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
		
		private function getJumpTargets(...args:*): Object {
			var jumpTargets:Object = new Object();
			for (var i:* in args) {
				jumpTargets[args[i]] = Math.random().toString();
			}
			return jumpTargets;
		}
		
		private function IngameInputHandler(): void {
			function ehWheel(): void {
				regex = new RegExp(format('\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd4_IntensityMod"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal ?{vRange4}\n\
getlocal ?{vOldRatio}\n\
divide\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
debugline \\d+\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal ?{vRange5}\n\
getlocal ?{vOldRatio}\n\
divide\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
'), "g");
				result = regex.exec(functionContents);
				while (result != null) {
					applyPatch(result.index, result[0].length, format('\
getlocal {vGem}\n\
pushtrue\n\
callpropvoid QName(PackageNamespace(""), "recalculateSds"), 1\
'));
					result = regex.exec(functionContents);
				}
			}
			modifyFunction('QName(PackageNamespace(""), "ehWheel")', ehWheel);
		}
		
		private function IngameInputHandler2(): void {
			function ehKeyDown(): void {
				regex = new RegExp(format('\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd4_IntensityMod"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal ?{vRange4}\n\
getlocal ?{vOldRatio}\n\
divide\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
debugline \\d+\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal ?{vRange5}\n\
getlocal ?{vOldRatio}\n\
divide\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
'), "g");
				result = regex.exec(functionContents);
				while (result != null) {
					applyPatch(result.index, result[0].length, format('\
getlocal {vGem}\n\
pushtrue\n\
callpropvoid QName(PackageNamespace(""), "recalculateSds"), 1\
'));
					result = regex.exec(functionContents);
				}
			}
			modifyFunction('QName(PackageNamespace(""), "ehKeyDown")', ehKeyDown);
		}
		
		private function IngameController(): void {
			function upgradeGemUnderPointer(): void {
				regex = new RegExp(format('\
debugline \\d+\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd4_IntensityMod"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal ?{vRange4}\n\
getlocal ?{vRangeRatio}\n\
divide\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
debugline \\d+\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal ?{vRange5}\n\
getlocal ?{vRangeRatio}\n\
divide\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
'), "g");
				result = regex.exec(functionContents);
				applyPatch(result.index, result[0].length, '');
				regex = new RegExp(format('\
debugline \\d+\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd4_IntensityMod"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal ?{vRange4}\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
debugline \\d+\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal ?{vRange5}\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
'), "");
				result = regex.exec(functionContents);
				applyPatch(result.index, result[0].length, '');
			}
			modifyFunction('QName(PackageNamespace(""), "upgradeGemUnderPointer")', upgradeGemUnderPointer);
		}
		
		private function IngameSpellCaster(): void {
			function combineGems(): void {
				regex = new RegExp(format('\
debugline \\d+\n\
getlocal ?{vRetGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd4_IntensityMod"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal ?{vRetGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd4_IntensityMod"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlocal ?{vRetGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
debugline \\d+\n\
getlocal ?{vRetGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal ?{vRetGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlocal ?{vRetGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
'), "");
				result = regex.exec(functionContents);
				applyPatch(result.index, result[0].length, '');
			}
			modifyFunction('QName(PackageNamespace(""), "combineGems")', combineGems);
		}
		
		private function Gem(): void {
			function addIntensity(): void {
				regex = new RegExp('\
getlocal0\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd3_Amplified"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "clone"\\), 0\n\
initproperty QName\\(PackageNamespace\\(""\\), "sd4_IntensityMod"\\)\n\
', "");
				result = regex.exec(functionContents);
				applyPatch(result.index + result[0].length, 0, '\
getlocal0\n\
getproperty QName(PackageNamespace(""), "sd4_IntensityMod")\n\
getproperty QName(PackageNamespace(""), "range")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "sd4_IntensityMod")\n\
getproperty QName(PackageNamespace(""), "range")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "rangeRatio")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
multiply\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\
');
			}
			function updateShotDataEnhancedOrTrapOrLantern(): void {
				regex = new RegExp('\
debugline \\d+\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd4_IntensityMod"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd4_IntensityMod"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
debugline \\d+\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "rangeRatio"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
', "");
				result = regex.exec(functionContents);
				applyPatch(result.index, result[0].length, '');
			}
			modifyFunction('QName(PrivateNamespace("com.giab.games.gcfw.entity:Gem"), "addIntensity")', addIntensity);
			modifyFunction('QName(PrivateNamespace("com.giab.games.gcfw.entity:Gem"), "updateShotDataEnhancedOrTrapOrLantern")', updateShotDataEnhancedOrTrapOrLantern);
		}
		
		public function loadCoreMod(lattice:Object): void {
			this.lattice = lattice;
			modifyFile("com/giab/games/gcfw/ingame/IngameInputHandler.class.asasm", IngameInputHandler);
			modifyFile("com/giab/games/gcfw/ingame/IngameInputHandler2.class.asasm", IngameInputHandler2);
			modifyFile("com/giab/games/gcfw/ingame/IngameController.class.asasm", IngameController);
			modifyFile("com/giab/games/gcfw/ingame/IngameSpellCaster.class.asasm", IngameSpellCaster);
			modifyFile("com/giab/games/gcfw/entity/Gem.class.asasm", Gem);
		}
		
		public function bind(modLoader:Object, gameObjects:Object) : RangeAdjustmentFix {
			return this;
		}
		
		public function unload(): void {}
	}
}