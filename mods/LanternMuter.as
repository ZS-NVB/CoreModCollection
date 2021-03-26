package mods {
	import Main
	
	public class LanternMuter {
		public const MOD_NAME:String = "LanternMuter";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function LanternMuter() {}
		
		private function Lantern(fileContents:String) : void {
			function doEnterFrame(functionContents:String) : void {
				result = new RegExp('\
debugline \\d+\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "SB"\\)\n\
pushstring "sndtowerfirebolt"\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "playSound"\\), 1\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PackageNamespace(""), "doEnterFrame")', doEnterFrame);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/Lantern.class.asasm", Lantern);
		}
	}
}