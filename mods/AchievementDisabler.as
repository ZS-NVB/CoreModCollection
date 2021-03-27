package mods {
	import Main;

	public class AchievementDisabler {
		public const MOD_NAME:String = "AchievementDisabler";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function AchievementDisabler() {}
		
		private function SelectorCore(fileContents:String) : void {
			function doEnterFrameStagesAppearing(functionContents:String) : void {
				result = new RegExp(main.format('\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "Main"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "steamworks"\\)\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "achisToSendToSteam"\\)\n\
getlocal ?{i}\n\
getproperty MultinameL[^\n]+\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "setAchievement"\\), 1\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PrivateNamespace("com.giab.games.gcfw.selector:SelectorCore"), "doEnterFrameStagesAppearing")', doEnterFrameStagesAppearing);
		}
		
		private function PnlAchievements(fileContents:String) : void {
			function setAchiLockStatusesOnLoad(functionContents:String) : void {
				result = new RegExp(main.format('\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "Main"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "steamworks"\\)\n\
pushstring "GCFW_"\n\
getlocal ?{vStrXy}\n\
add\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "setAchievement"\\), 1\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PackageNamespace(""), "setAchiLockStatusesOnLoad")', setAchiLockStatusesOnLoad);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/SelectorCore.class.asasm", SelectorCore);
			main.modifyFile("com/giab/games/gcfw/selector/PnlAchievements.class.asasm", PnlAchievements);
		}
	}
}