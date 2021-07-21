package mods {
	import Main;

	public class BetterManaStream {
		public const MOD_NAME:String = "BetterManaStream";
		public const COREMOD_VERSION:String = "3";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function BetterManaStream() {}
		
		private function IngameSpellCaster(fileContents:String) : void {
			function castRiseMaxMana(functionContents:String) : void {
				result = main.regex('\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"maxMana")\n\
getlex QName(PackageNamespace(""),"Math")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"maxMana")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
pushdouble 1.41\n\
pushdouble 0.035\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"manaPoolLevel")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
multiply\n\
add\n\
multiply\n\
callproperty QName(PackageNamespace(""),"round"), 1\n\
callpropvoid QName(PackageNamespace(""),"s"), 1\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"maxMana")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"maxMana")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
pushbyte 1\n\
pushdouble 0.41\n\
pushdouble 0.035\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"manaPoolLevel")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
multiply\n\
add\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"MANA_STREAM")\n\
getproperty MultinameL()\n\
pushbyte 1\n\
getproperty MultinameL()\n\
callproperty Multiname("g"), 0\n\
subtract\n\
multiply\n\
add\n\
multiply\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\
');
				main.requireMaxStack(7);
			}
			main.modifyFunction('QName(PackageNamespace(""),"castRiseMaxMana")', castRiseMaxMana);
		}
		
		private function PnlSkills(fileContents:String) : void {
			function populateSkillsMetaData(functionContents:String) : void {
				result = main.regex('\
pushstring "-#0% lower mana pool milestones"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushstring "-#0,1% lower mana pool milestone increments"\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"populateSkillsMetaData")', populateSkillsMetaData);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameSpellCaster.class.asasm", IngameSpellCaster);
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
		}
	}
}