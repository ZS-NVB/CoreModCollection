package mods {
	import Main
	
	public class JourneyTraits {
		public const MOD_NAME:String = "JourneyTraits";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function JourneyTraits() {}
		
		private function SelectorInputHandler(fileContents:String) : void {
			function ehStageIconClicked(functionContents:String) : void {
				result = new RegExp('\
(getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ppd"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "stageHighestXpsJourney"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ingameCore"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "stageMeta"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "id"\\)\n\
getproperty MultinameL[^\n]+\n\
callproperty Multiname\\("g",[^\n]+\n\
pushbyte 1\n\
ifnlt (\\w+)\n)\
(.+\n\
jump \\w+\n)\
\\2:\n\
', "s").exec(functionContents);
				main.applyPatch(result.index, 0, '\
getlocal0\n\
getproperty QName(PackageNamespace(""), "mc")\n\
getproperty QName(PackageNamespace(""), "mcStageSettings")\n\
getproperty QName(PackageNamespace(""), "btnEndurance")\n\
pushtrue\n\
setproperty QName(PackageNamespace(""), "visible")\
');
				main.applyPatch(result.index + result[1].length, result[3].length, '\
getlocal0\n\
getproperty QName(PackageNamespace(""), "mc")\n\
getproperty QName(PackageNamespace(""), "mcStageSettings")\n\
getproperty QName(PackageNamespace(""), "btnEndurance")\n\
pushfalse\n\
setproperty QName(PackageNamespace(""), "visible")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "mc")\n\
getproperty QName(PackageNamespace(""), "mcStageSettings")\n\
getproperty QName(PackageNamespace(""), "btnTrial")\n\
pushfalse\n\
setproperty QName(PackageNamespace(""), "visible")\
');
			}
			main.modifyFunction('QName(PackageNamespace(""), "ehStageIconClicked")', ehStageIconClicked);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/SelectorInputHandler.class.asasm", SelectorInputHandler);
		}
	}
}