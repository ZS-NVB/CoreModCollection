package mods {
	import Main;

	public class EnrageAnyWave {
		public const MOD_NAME:String = "EnrageAnyWave";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function EnrageAnyWave() {}
		
		private function IngameEnrager(fileContents:String) : void {
			function checkEnrageGemStatus(functionContents:String) : void {
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "currentWave"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
pushbyte -1\n)\
(greaterthan\n)\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, "lessthan");
			}
			main.modifyFunction('QName(PackageNamespace(""), "checkEnrageGemStatus")', checkEnrageGemStatus);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameEnrager.class.asasm", IngameEnrager);
		}
	}
}