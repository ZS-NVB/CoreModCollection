package mods {
	import Main;

	public class NoTalismanLocks {
		public const MOD_NAME:String = "NoTalismanLocks";
		public const COREMOD_VERSION:String = "3";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function NoTalismanLocks() {}
		
		private function PnlTalisman(fileContents:String) : void {
			function removeSlotUnlockedCheck(functionContents:String) : void {
				result = main.regex('\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"ppd")\n\
getproperty QName(PackageNamespace(""),"talSlotUnlockStatuses")\n\
getlocal ?\\d+\n\
getproperty MultinameL()\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushtrue\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"renderInfoPanel")', removeSlotUnlockedCheck);
			main.modifyFunction('QName(PackageNamespace(""),"canFragmentFitIntoTalismanSlot")', removeSlotUnlockedCheck);
			main.modifyFunction('QName(PackageNamespace(""),"selectTalSlot")', removeSlotUnlockedCheck);
			main.modifyFunction('QName(PackageNamespace(""),"setTalLockMcs")', removeSlotUnlockedCheck);
		}
		
		private function SelectorInputHandler(fileContents:String) : void {
			function ehScCounterOver(functionContents:String) : void {
				result = main.regex('\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"mcInfoPanel")\n\
pushint 12628041\n\
pushstring " - Unlock talisman slots"\n\
pushtrue\n\
pushbyte 12\n\
callpropvoid QName(PackageNamespace(""),"addTextfield"), 4\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PackageNamespace(""),"ehScCounterOver")', ehScCounterOver);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/PnlTalisman.class.asasm", PnlTalisman);
			main.modifyFile("com/giab/games/gcfw/selector/SelectorInputHandler.class.asasm", SelectorInputHandler);
		}
	}
}