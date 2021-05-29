package mods {
	import Main;

	public class FreezeCooldownReversion {
		public const MOD_NAME:String = "FreezeCooldownReversion";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function FreezeCooldownReversion() {}
		
		private function PnlSkills(fileContents:String) : void {
			function populateSkillsMetaData(functionContents:String) : void {
				result = main.regex('\
(getlocal0\n\
getproperty QName(PackageNamespace(""),"skillEffectiveValuesPerLevel")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"FREEZE")\n)\
(pushdouble 0.005\n)\
pushdouble 0.03\n\
newarray 2\n\
setproperty MultinameL()\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, '\
pushdouble 0.01\
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