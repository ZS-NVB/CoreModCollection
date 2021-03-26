package mods {
	import Main;
	
	public class RangeAdjustmentFix {
		public const MOD_NAME:String = "RangeAdjustmentFix";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function RangeAdjustmentFix() {}
		
		private function IngameInputHandler(fileContents:String) : void {
			function ehWheel(functionContents:String): void {
				regex = new RegExp(main.format('\
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
					main.applyPatch(result.index, result[0].length, main.format('\
getlocal {vGem}\n\
pushtrue\n\
callpropvoid QName(PackageNamespace(""), "recalculateSds"), 1\
'));
					result = regex.exec(functionContents);
				}
			}
			main.modifyFunction('QName(PackageNamespace(""), "ehWheel")', ehWheel);
		}
		
		private function IngameInputHandler2(fileContents:String) : void {
			function ehKeyDown(functionContents:String) : void {
				regex = new RegExp(main.format('\
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
					main.applyPatch(result.index, result[0].length, main.format('\
getlocal {vGem}\n\
pushtrue\n\
callpropvoid QName(PackageNamespace(""), "recalculateSds"), 1\
'));
					result = regex.exec(functionContents);
				}
			}
			main.modifyFunction('QName(PackageNamespace(""), "ehKeyDown")', ehKeyDown);
		}
		
		private function IngameController(fileContents:String) : void {
			function upgradeGemUnderPointer(functionContents:String) : void {
				result = new RegExp(main.format('\
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
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length);
				result = new RegExp(main.format('\
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
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PackageNamespace(""), "upgradeGemUnderPointer")', upgradeGemUnderPointer);
		}
		
		private function IngameSpellCaster(fileContents:String) : void {
			function combineGems(functionContents:String) : void {
				result = new RegExp(main.format('\
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
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PackageNamespace(""), "combineGems")', combineGems);
		}
		
		private function Gem(fileContents:String) : void {
			function addIntensity(functionContents:String) : void {
				result = new RegExp('\
getlocal0\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd3_Amplified"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "clone"\\), 0\n\
initproperty QName\\(PackageNamespace\\(""\\), "sd4_IntensityMod"\\)\n\
').exec(functionContents);
				main.applyPatch(result.index + result[0].length, 0, '\
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
				main.requireMaxStack(3);
			}
			function updateShotDataEnhancedOrTrapOrLantern(functionContents:String) : void {
				result = new RegExp('\
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
').exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PrivateNamespace("com.giab.games.gcfw.entity:Gem"), "addIntensity")', addIntensity);
			main.modifyFunction('QName(PrivateNamespace("com.giab.games.gcfw.entity:Gem"), "updateShotDataEnhancedOrTrapOrLantern")', updateShotDataEnhancedOrTrapOrLantern);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInputHandler.class.asasm", IngameInputHandler);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInputHandler2.class.asasm", IngameInputHandler2);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameController.class.asasm", IngameController);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameSpellCaster.class.asasm", IngameSpellCaster);
			main.modifyFile("com/giab/games/gcfw/entity/Gem.class.asasm", Gem);
		}
	}
}