package mods {
	import Main;

	public class MapLimitsRemover {
		public const MOD_NAME:String = "MapLimitsRemover";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function MapLimitsRemover() {}
		
		private function SelectorCore(fileContents:String) : void {
			function setVpLimits(functionContents:String) : void {
				result = new RegExp(main.format('\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ppd"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "gainedMapTiles"\\)\n\
getlocal ?{i}\n\
getproperty MultinameL[^\n]+\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length, "pushtrue");
				result = new RegExp('\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ppd"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "stageHighestXpsJourney"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
pushstring "W4"\n\
callproperty QName\\(PackageNamespace\\(""\\), "getFieldId"\\), 1\n\
getproperty MultinameL[^\n]+\n\
callproperty Multiname\\("g",[^\n]+\n\
pushbyte 1\n\
ifnlt (\\w+)\n\
.+\
\\1:\n\
', "s").exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PackageNamespace(""), "setVpLimits")', setVpLimits);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/SelectorCore.class.asasm", SelectorCore);
		}
	}
}