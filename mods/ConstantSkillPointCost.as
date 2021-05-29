package mods {
	import Main;

	public class ConstantSkillPointCost {
		public const MOD_NAME:String = "ConstantSkillPointCost";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function ConstantSkillPointCost() {}
		
		private function PnlSkills(fileContents:String) : void {
			function ehBtnSpendScUp(functionContents:String) : void {
				result = main.regex('\
localcount (\\d+)\n\
').exec(functionContents);
				var vSkillPointsToBuy:String = result[1];
				main.applyPatch(result.index, result[0].length, '\
localcount ' + (int(vSkillPointsToBuy) + 1).toString() + '\
');
				result = main.regex('\
(pushshort 1000\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"ppd")\n\
getproperty QName(PackageNamespace(""),"skillPtsBought")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
pushbyte 100\n\
multiply\n\
add\n)\
convert_d\n\
setlocal vCost\n\
').exec(functionContents);
				main.applyPatch(result.index, result[1].length, '\
pushbyte 100\
');
				main.applyPatch(result.index + result[0].length, 0, '\
getlex QName(PackageNamespace(""),"Math")\n\
getlex QName(PackageNamespace(""),"Math")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"ppd")\n\
getproperty QName(PackageNamespace(""),"shadowCoreAmount")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
getlocal vCost\n\
divide\n\
callproperty QName(PackageNamespace(""),"floor"), 1\n\
getlocal pE\n\
getproperty QName(PackageNamespace(""),"shiftKey")\n\
iffalse jumpTarget1\n\
pushbyte 10\n\
jump jumpTarget2\n\
jumpTarget1:\n\
pushbyte 1\n\
jumpTarget2:\n\
callproperty QName(PackageNamespace(""),"min"), 2\n\
convert_d\n\
setlocal ' + vSkillPointsToBuy + '\
', main.getJumpTargets("jumpTarget1", "jumpTarget2"));
				regex = main.regex('\
(callproperty QName(PackageNamespace(""),"g"), 0\n)\
(pushbyte 1\n)\
add\n\
callpropvoid QName(PackageNamespace(""),"s"), 1\n\
', "g");
				result = regex.exec(functionContents);
				while (result != null) {
					main.applyPatch(result.index + result[1].length, result[2].length, '\
getlocal ' + vSkillPointsToBuy + '\
');
					result = regex.exec(functionContents);
				}
				result = main.regex('\
(callproperty QName(PackageNamespace(""),"g"), 0\n\
getlocal vCost\n)\
subtract\n\
callpropvoid QName(PackageNamespace(""),"s"), 1\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, 0, '\
getlocal ' + vSkillPointsToBuy + '\n\
multiply\
');
				result = main.regex('\
pushstring "\\+1"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushstring "+"\n\
getlocal ' + vSkillPointsToBuy + '\n\
add\
');
			}
			function renderInfoPanelSpendSc(functionContents:String) : void {
				regex = main.regex('\
pushshort 1000\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"ppd")\n\
getproperty QName(PackageNamespace(""),"skillPtsBought")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
pushbyte 100\n\
multiply\n\
add\n\
', "g");
				result = regex.exec(functionContents);
				while (result != null) {
					main.applyPatch(result.index, result[0].length, '\
pushbyte 100\
');
					result = regex.exec(functionContents);
				}
				result = main.regex('\
pushstring "Cost increases with every skill point bought"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushstring "Hold shift to buy 10 skill points"\
');
				result = main.regex('\
pushstring "Current cost: "\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushstring "Cost: "\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"ehBtnSpendScUp")', ehBtnSpendScUp);
			main.modifyFunction('QName(PackageNamespace(""),"renderInfoPanelSpendSc")', renderInfoPanelSpendSc);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
		}
	}
}