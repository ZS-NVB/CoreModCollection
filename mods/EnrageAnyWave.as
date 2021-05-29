package mods {
	import Main;

	public class EnrageAnyWave {
		public const MOD_NAME:String = "EnrageAnyWave";
		public const COREMOD_VERSION:String = "2";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function EnrageAnyWave() {}
		
		private function IngameEnrager(fileContents:String) : void {
			function checkEnrageGemStatus(functionContents:String) : void {
				result = main.regex('\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"currentWave")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
pushbyte -1\n\
(greaterthan\n)\
').exec(functionContents);
				main.applyPatch(result.index + result[0].length, -result[1].length, '\
lessthan\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"checkEnrageGemStatus")', checkEnrageGemStatus);
		}
		
		private function IngameInfoPanelRenderer(fileContents:String) : void {
			function renderInfoPanel(functionContents:String) : void {
				result = main.regex('\
pushstring "Insert gem to enrage all incoming waves\\\\n\\(except the next "\n\
findpropstrict QName(PackageNamespace("com.giab.games.gcfw.entity"),"Wave")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"waves")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"currentWave")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
pushbyte 1\n\
add\n\
getproperty MultinameL()\n\
callproperty QName(PackageNamespace("com.giab.games.gcfw.entity"),"Wave"), 1\n\
getproperty QName(PackageNamespace(""),"isLinkedToNext")\n\
iffalse (\\w+)\n\
pushstring "ones"\n\
coerce_a\n\
jump (\\w+)\n\
\\1:\n\
pushstring "one"\n\
coerce_a\n\
\\2:\n\
add\n\
pushstring "\\)\\\\n\\\\nEnraged waves bring stronger monsters that give more XP when killed.\\\\n\\\\nHigher grade gems cause more rage."\n\
add\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushstring "Insert gem to enrage all incoming waves.\\n\\nEnraged waves bring stronger monsters that give more XP when killed.\\n\\nHigher grade gems cause more rage."\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"renderInfoPanel")', renderInfoPanel);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameEnrager.class.asasm", IngameEnrager);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInfoPanelRenderer.class.asasm", IngameInfoPanelRenderer);
		}
	}
}