package mods {
	import Main;

	public class NoTalismanLocks {
		public const MOD_NAME:String = "NoTalismanLocks";
		public const COREMOD_VERSION:String = "2";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function NoTalismanLocks() {}
		
		private function PnlTalisman(fileContents:String) : void {
			function removeSlotUnlockedCheck(functionContents:String, variableName:String) : void {
				result = new RegExp(main.format('\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ppd"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "talSlotUnlockStatuses"\\)\n\
getlocal ?{variableName}\n\
getproperty MultinameL[^\n]+\n\
'.replace("variableName", variableName))).exec(functionContents);
				main.applyPatch(result.index, result[0].length, "pushtrue");
			}
			function renderInfoPanel(functionContents:String) : void {
				removeSlotUnlockedCheck(functionContents, "vSlotNum");
			}
			function canFragmentFitIntoTalismanSlot(functionContents:String) : void {
				removeSlotUnlockedCheck(functionContents, "pTalSlotNum");
			}
			function selectTalSlot(functionContents:String) : void {
				removeSlotUnlockedCheck(functionContents, "pSlotNum");
			}
			function setTalLockMcs(functionContents:String) : void {
				removeSlotUnlockedCheck(functionContents, "i");
			}
			main.modifyFunction('QName(PackageNamespace(""), "renderInfoPanel")', renderInfoPanel);
			main.modifyFunction('QName(PackageNamespace(""), "canFragmentFitIntoTalismanSlot")', canFragmentFitIntoTalismanSlot);
			main.modifyFunction('QName(PackageNamespace(""), "selectTalSlot")', selectTalSlot);
			main.modifyFunction('QName(PackageNamespace(""), "setTalLockMcs")', setTalLockMcs);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/PnlTalisman.class.asasm", PnlTalisman);
		}
	}
}