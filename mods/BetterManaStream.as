package mods {
	import Main;

	public class BetterManaStream {
		public const MOD_NAME:String = "BetterManaStream";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function BetterManaStream() {}
		
		private function IngameSpellCaster(fileContents:String) : void {
			function castRiseMaxMana(functionContents:String) : void {
				result = new RegExp('\
pushdouble 1.41\n\
pushdouble 0.035\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "manaPoolLevel"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
add\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, main.format('\
pushbyte 1\n\
pushdouble 0.41\n\
pushdouble 0.035\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "core")\n\
getproperty QName(PackageNamespace(""), "manaPoolLevel")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
multiply\n\
add\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "core")\n\
getproperty QName(PackageNamespace(""), "skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "SkillId")\n\
getproperty QName(PackageNamespace(""), "MANA_STREAM")\n\
getproperty MultinameL({namespaces})\n\
pushbyte 1\n\
getproperty MultinameL({namespaces})\n\
callproperty Multiname("g", {namespaces}), 0\n\
subtract\n\
multiply\n\
add\
'));
				main.requireMaxStack(8);
			}
			main.modifyFunction('QName(PackageNamespace(""), "castRiseMaxMana")', castRiseMaxMana);
		}
		
		private function PnlSkills(fileContents:String) : void {
			function populateSkillsMetaData(functionContents:String) : void {
				result = new RegExp('\
pushstring "-#0% lower mana pool milestones"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushstring "-#0% lower mana pool milestone increments"\
');
			}
			main.modifyFunction('QName(PackageNamespace(""), "populateSkillsMetaData")', populateSkillsMetaData);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameSpellCaster.class.asasm", IngameSpellCaster);
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
		}
	}
}