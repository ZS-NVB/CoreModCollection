package mods {
	import Main;
	
	public class IceShardsDamageReversion {
		public const MOD_NAME:String = "IceShardsDamageReversion";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function IceShardsDamageReversion() {}
		
		private function IngameInitializer2(fileContents:String) : void {
			function resetIngameParameters(functionContents:String) : void {
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "spIsHpShredPct"\\)\n)\
(pushbyte 10\n)\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "talismanEffectiveValues"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "TalismanPropertyId"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ICESHARDS_HPLOSS_PCT"\\)\n\
getproperty MultinameL[^\n]+\n\
callproperty Multiname\\("g", [^\n]+\n\
add\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, "pushbyte 20");
			}
			main.modifyFunction('QName(PackageNamespace(""), "resetIngameParameters")', resetIngameParameters);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInitializer2.class.asasm", IngameInitializer2);
		}
	}
}