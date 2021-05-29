package mods {
	import Main;

	public class BetterOrb {
		public const MOD_NAME:String = "BetterOrb";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function BetterOrb() {}
		
		private function PnlSkills(fileContents:String) : void {
			function populateSkillsMetaData(functionContents:String) : void {
				result = main.regex('\
(getlocal0\n\
getproperty QName(PackageNamespace(""),"skillEffectiveValuesPerLevel")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"ORB_OF_PRESENCE")\n)\
(pushdouble 0.005\n)\
pushbyte 1\n\
newarray 2\n\
setproperty MultinameL()\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, '\
pushdouble 0.008\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"populateSkillsMetaData")', populateSkillsMetaData);
		}
		
		private function Orb(fileContents:String) : void {
			function refreshValues(functionContents:String) : void {
				result = main.regex('\
getlocal0\n\
getproperty QName(PackageNamespace(""),"banishmentCostDiscountTotalCalculated")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"banishmentCostDiscountFromSkill")\n\
add\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushbyte 1\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"banishmentCostDiscountTotalCalculated")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
pushbyte 100\n\
divide\n\
subtract\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"banishmentCostDiscountFromSkill")\n\
pushbyte 100\n\
divide\n\
subtract\n\
multiply\n\
subtract\n\
pushbyte 100\n\
multiply\n\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"refreshValues")', refreshValues);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
			main.modifyFile("com/giab/games/gcfw/entity/Orb.class.asasm", Orb);
		}
	}
}