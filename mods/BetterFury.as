package mods {
	import Main;

	public class BetterFury {
		public const MOD_NAME:String = "BetterFury";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function BetterFury() {}
		
		private function PnlSkills(fileContents:String) : void {
			function populateSkillsMetaData(functionContents:String) : void {
				result = main.regex('\
(getlocal0\n\
getproperty QName(PackageNamespace(""),"skillEffectiveValuesPerLevel")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"FURY")\n\
pushdouble 0.01\n)\
(pushdouble 0.03\n)\
newarray 2\n\
setproperty MultinameL()\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, '\
pushdouble 0.04\
');
				result = main.regex('\
pushstring "-#0% enraging monster hit points and armor penalty"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushstring "-#0,1% enraging monster hit points and armor penalty"\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"populateSkillsMetaData")', populateSkillsMetaData);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
		}
	}
}