package mods {
	import Main
	
	public class JourneyGems {
		public const MOD_NAME:String = "JourneyGems";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function JourneyGems() {}
		
		private function IngameInitializer2(fileContents:String) : void {
			function runInitScript(functionContents:String) : void {
				result = new RegExp('\
(getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ppd"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "stageHighestXpsJourney"\\)\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "stageMeta"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "id"\\)\n\
getproperty MultinameL[^\n]+\n\
callproperty Multiname\\("g",[^\n]+\n)\
(pushbyte 0\n)\
ifngt \\w+\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, "pushbyte -1");
			}
			main.modifyFunction('QName(PackageNamespace(""), "runInitScript")', runInitScript);
		}
		
		private function SelectorRenderer(fileContents:String) : void {
			function renderInfoPanelStage(functionContents:String) : void {
				result = new RegExp('\
(getlocal2\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "BattleMode"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "TRIAL"\\)\n\
equals\n\
not\n\
dup\n\
iffalse (\\w+)\n\
pop\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ppd"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "stageHighestXpsJourney"\\)\n\
getlocal1\n\
getproperty MultinameL[^\n]+\n\
callproperty Multiname\\("g",[^\n]+\n)\
(pushbyte 0\n)\
greaterthan\n\
\\2:\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, "pushbyte -1");
			}
			main.modifyFunction('QName(PackageNamespace(""), "renderInfoPanelStage")', renderInfoPanelStage);
		}
		
		private function PnlSkills(fileContents:String) : void {
			function renderInfoPanelSkill(functionContents:String) : void {
				result = new RegExp('\
debugline \\d+\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "mcInfoPanel"\\)\n\
pushint 10545103\n\
pushstring "Unlocks the corresponding gem type if the field has been beaten at least once"\n\
pushtrue\n\
pushbyte 11\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "addTextfield"\\), 4\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PackageNamespace(""), "renderInfoPanelSkill")', renderInfoPanelSkill);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInitializer2.class.asasm", IngameInitializer2);
			main.modifyFile("com/giab/games/gcfw/selector/SelectorRenderer.class.asasm", SelectorRenderer);
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
		}
	}
}