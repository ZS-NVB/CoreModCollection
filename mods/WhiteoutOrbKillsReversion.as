package mods {
	import Main;

	public class WhiteoutOrbKillsReversion {
		public const MOD_NAME:String = "WhiteoutOrbKillsReversion";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function WhiteoutOrbKillsReversion() {}
		
		private function IngameController(fileContents:String) : void {
			function monsterAttacksOrb(functionContents:String) : void {
				result = main.regex('\
dup\n\
iffalse (\\w+)\n\
pop\n\
getlocal pMonster\n\
getproperty QName(PackageNamespace(""),"hp")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
pushshort 1000\n\
lessthan\n\
\\1:\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PackageNamespace(""),"monsterAttacksOrb")', monsterAttacksOrb);
		}
		
		private function IngameInfoPanelRenderer(fileContents:String) : void {
			function renderInfoPanel(functionContents:String) : void {
				result = main.regex('\
pushstring "Monsters reaching the Orb in whiteout and below 10% health as well as below 1.000 health are killed by the Orb"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushstring "Monsters reaching the Orb in whiteout and below 10% health are killed by the Orb"\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"renderInfoPanel")', renderInfoPanel);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameController.class.asasm", IngameController);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInfoPanelRenderer.class.asasm", IngameInfoPanelRenderer);
		}
	}
}