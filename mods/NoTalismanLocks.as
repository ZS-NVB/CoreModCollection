package mods {
	import Main;

	public class NoTalismanLocks {
		public const MOD_NAME:String = "NoTalismanLocks";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function NoTalismanLocks() {}
		
		private function PlayerProgressData(fileContents:String) : void {
			function setInitialValues(functionContents:String) : void {
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "talSlotUnlockStatuses"\\)\n)\
(pushfalse\n)\
callpropvoid QName\\(Namespace\\("http://adobe.com/AS3/2006/builtin"\\), "push"\\), 1\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, "pushtrue");
			}
			main.modifyFunction('QName(PackageNamespace(""), "setInitialValues")', setInitialValues);
			function populateFromString01(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "talSlotUnlockStatuses"\\)\n\
getlocal ?{i}\n)\
(getlocal ?{vTpsBa}\n\
getlocal ?{i}\n\
callproperty QName\\(PackageNamespace\\(""\\), "readBit"\\), 1\n)\
setproperty MultinameL[^\n]+\n\
')).exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, "pushtrue");
			}
			main.modifyFunction('QName(PrivateNamespace("com.giab.games.gcfw.struct:PlayerProgressData"), "populateFromString01")', populateFromString01);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/struct/PlayerProgressData.class.asasm", PlayerProgressData);
		}
	}
}