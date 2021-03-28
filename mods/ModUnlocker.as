package mods {
	import Main;

	public class ModUnlocker {
		public const MOD_NAME:String = "ModUnlocker";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function ModUnlocker() {}
		
		private function SelectorInputHandler(fileContents:String) : void {
			function removeModUnlockedCheck(functionContents:String) : void {
				result = new RegExp('\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ppd"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "modUnlockStatuses"\\)\n\
pushbyte \\d+\n\
getproperty MultinameL[^\n]+\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, "pushtrue");
			}
			for (var i:int = 1; i <= 12; i++) {
				main.modifyFunction('QName(PackageNamespace(""), "ehBtnFrameTopUp' + i.toString() + '")', removeModUnlockedCheck);
				main.modifyFunction('QName(PackageNamespace(""), "ehBtnFrameTopOver' + i.toString() + '")', removeModUnlockedCheck);
			}
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/SelectorInputHandler.class.asasm", SelectorInputHandler);
		}
	}
}