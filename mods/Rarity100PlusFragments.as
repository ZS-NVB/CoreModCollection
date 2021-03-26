package mods {
	import Main;

	public class Rarity100PlusFragments {
		public const MOD_NAME:String = "Rarity100PlusFragments";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function Rarity100PlusFragments() {}
		
		private function IngamePopulator(fileContents:String) : void {
			function calcRarityMin(functionContents:String) : void {
				result = new RegExp('\
((getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
pushbyte 85\n)\
pushbyte 0\n\
pushbyte 64\n\
getlocal0\n\
callproperty QName\\(PackageNamespace\\(""\\), "calcDropPower"\\), 0\n\
multiply\n\
add\n)\
(callproperty QName\\(PackageNamespace\\(""\\), "min"\\), 2\n\
getlocal0\n\
callproperty QName\\(PackageNamespace\\(""\\), "calcRarityMax"\\), 0\n\
pushbyte 15\n\
subtract\n\
callproperty QName\\(PackageNamespace\\(""\\), "min"\\), 2\n)\
').exec(functionContents);
				main.applyPatch(result.index, result[2].length);
				main.applyPatch(result.index + result[1].length, result[3].length);
			}
			function calcRarityMax(functionContents:String) : void {
				result = new RegExp('\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
pushbyte 100\n\
pushbyte 20\n\
pushbyte 105\n\
getlocal0\n\
callproperty QName\\(PackageNamespace\\(""\\), "calcDropPower"\\), 0\n\
multiply\n\
add\n\
callproperty QName\\(PackageNamespace\\(""\\), "min"\\), 2\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, 'getlex QName(PackageNamespace(""), "Math")');
				main.applyPatch(result.index + result[0].length, 0, '\
getlocal0\n\
callproperty QName(PackageNamespace(""), "calcRarityMin"), 0\n\
callproperty QName(PackageNamespace(""), "max"), 2\
');
				main.requireMaxStack(7);
			}
			function buildMonsterWaveDescs(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "wavesToDropTalFragsTo"\\)\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n)\
getlocal ?{vTotalNumOfWaves}\n\
')).exec(functionContents);
				main.applyPatch(result.index + result[1].length, 0, 'getlex QName(PackageNamespace(""), "Math")');
				main.applyPatch(result.index + result[0].length, 0, '\
pushshort 500\n\
callproperty QName(PackageNamespace(""), "min"), 2\
');
			}
			main.modifyFunction('QName(PackageNamespace(""), "calcRarityMin")', calcRarityMin);
			main.modifyFunction('QName(PackageNamespace(""), "calcRarityMax")', calcRarityMax);
			main.modifyFunction('QName(PackageNamespace(""), "buildMonsterWaveDescs")', buildMonsterWaveDescs);
		}
		
		private function IngameEnding(fileContents:String) : void {
			function prepareDropIcons(functionContents:String) : void {
				result = new RegExp(main.format('\
((getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
pushbyte 100\n)\
findpropstrict QName\\(PackageNamespace\\("com.giab.games.gcfw.entity"\\), "TalismanFragment"\\)\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ocLootTalFrags"\\)\n\
getlocal ?{i}\n\
getproperty MultinameL[^\n]+\n\
callproperty QName\\(PackageNamespace\\("com.giab.games.gcfw.entity"\\), "TalismanFragment"\\), 1\n\
getproperty QName\\(PackageNamespace\\(""\\), "rarity"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
pushbyte 10\n\
add\n)\
(callproperty QName\\(PackageNamespace\\(""\\), "min"\\), 2\n)\
')).exec(functionContents);
				main.applyPatch(result.index, result[2].length);
				main.applyPatch(result.index + result[1].length, result[3].length);
			}
			main.modifyFunction('QName(PackageNamespace(""), "prepareDropIcons")', prepareDropIcons);
		}
		
		private function capRarity(functionContents:String) : void {
				regex = new RegExp('\
getproperty QName\\(PackageNamespace\\(""\\), "rarity"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
', "g");
				result = regex.exec(functionContents);
				while (result != null) {
					main.applyPatch(result.index + result[0].length, 0, '\
getlex QName(PackageNamespace(""), "Math")\n\
swap\n\
pushbyte 100\n\
callproperty QName(PackageNamespace(""), "min"), 2\
');
					result = regex.exec(functionContents);
				}
		}
		
		private function TalFragBitmapCreator(fileContents:String) : void {
			main.modifyFunction('QName(PackageNamespace(""), "giveTalFragBitmaps")', capRarity);
		}
		
		private function PnlTalisman(fileContents:String) : void {
			function getShapeChangeCost(functionContents:String) : void {
				capRarity(functionContents);
				main.requireMaxStack(7);
			}
			main.modifyFunction('QName(PackageNamespace(""), "renderInfoPanelFragment")', capRarity);
			main.modifyFunction('QName(PackageNamespace(""), "calculateStarterManaMult")', capRarity);
			main.modifyFunction('QName(PackageNamespace(""), "calculateExtraManaPerWave")', capRarity);
			main.modifyFunction('QName(PackageNamespace(""), "renderRarityUpgPlates")', capRarity);
			main.modifyFunction('QName(PackageNamespace(""), "getShapeChangeCost")', getShapeChangeCost);
		}
		
		private function TalismanFragment(fileContents:String) : void {
			function iinit(functionContents:String) : void {
				result = new RegExp(main.format('\
((getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
pushbyte 100\n)\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
pushbyte 1\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
getlocal2\n\
callproperty QName\\(PackageNamespace\\(""\\), "round"\\), 1\n\
callproperty QName\\(PackageNamespace\\(""\\), "max"\\), 2\n)\
(callproperty QName\\(PackageNamespace\\(""\\), "min"\\), 2\n)\
')).exec(functionContents);
				main.applyPatch(result.index, result[2].length);
				main.applyPatch(result.index + result[1].length, result[3].length);
			}
			function calculateProperties(functionContents:String) : void {
				result = new RegExp('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "rarity"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
pushbyte 100\n\
lessequals\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, "pushtrue");
				result = new RegExp(main.format('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "rarity"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
pushbyte 100\n\
ifnlt (\\w+)\n\
.+\
jump (\\w+)\n\
\\2:\n\
debugline \\d+\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "upgradeLevelMax"\\)\n\
.+?\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
debugline \\d+\n)\
(getlocal ?{vPropertyIds}\n\
.+?\
callpropvoid QName\\(Namespace\\("http://adobe.com/AS3/2006/builtin"\\), "splice"\\), 2\n)\
.+\
\\3:\n\
'), "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[4].length, main.format('\
getlocal0\n\
getproperty QName(PackageNamespace(""), "upgradeLevelMax")\n\
getlex QName(PackageNamespace(""), "Math")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "upgradeLevelMax")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
getlex QName(PackageNamespace(""), "Math")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "rarity")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushbyte 100\n\
subtract\n\
pushbyte 10\n\
divide\n\
callproperty QName(PackageNamespace(""), "floor"), 1\n\
add\n\
getlocal {vPropertyIds}\n\
getproperty QName(PackageNamespace(""), "length")\n\
pushbyte 2\n\
add\n\
callproperty QName(PackageNamespace(""), "min"), 2\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\n\
getlocal {vPropertyIds}\n\
pushbyte 0\n\
getlocal {vPropertyIds}\n\
getproperty QName(PackageNamespace(""), "length")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "upgradeLevelMax")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "rarity")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushbyte 100\n\
ifgt {jumpTarget1}\n\
pushbyte 1\n\
jump {jumpTarget2}\n\
{jumpTarget1}:\n\
pushbyte 2\n\
{jumpTarget2}:\n\
subtract\n\
subtract\n\
callpropvoid QName(Namespace("http://adobe.com/AS3/2006/builtin"), "splice"), 2\
', main.getJumpTargets("jumpTarget1", "jumpTarget2")));
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "propertyIds"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "length"\\)\n)\
(decrement\n)\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, main.format('\
getlocal0\n\
getproperty QName(PackageNamespace(""), "rarity")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushbyte 100\n\
ifgt {jumpTarget1}\n\
pushbyte 1\n\
jump {jumpTarget2}\n\
{jumpTarget1}:\n\
pushbyte 0\n\
{jumpTarget2}:\n\
subtract\
', main.getJumpTargets("jumpTarget1", "jumpTarget2")));
				result = new RegExp('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "sellValue"\\)\n\
.+?\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
', "s").exec(functionContents);
				var offset:int = result.index;
				var sellValue:String = result[0];
				regex = new RegExp('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "rarity"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
', "g");
				result = regex.exec(sellValue);
				while (result != null) {
					main.applyPatch(offset + result.index, 0, 'getlex QName(PackageNamespace(""),"Math")');
					main.applyPatch(offset + result.index + result[0].length, 0, '\
pushbyte 100\n\
callproperty QName(PackageNamespace(""), "min"), 2\
');
					result = regex.exec(sellValue);
				}
			}
			main.modifyFunction('QName(PackageNamespace(""), "calculateProperties")', calculateProperties);
			main.modifyFunction('iinit', iinit);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngamePopulator.class.asasm", IngamePopulator);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameEnding.class.asasm", IngameEnding);
			main.modifyFile("com/giab/games/gcfw/utils/TalFragBitmapCreator.class.asasm", TalFragBitmapCreator);
			main.modifyFile("com/giab/games/gcfw/selector/PnlTalisman.class.asasm", PnlTalisman);
			main.modifyFile("com/giab/games/gcfw/entity/TalismanFragment.class.asasm", TalismanFragment);
		}
	}
}