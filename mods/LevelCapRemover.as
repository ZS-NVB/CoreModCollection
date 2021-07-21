package mods {
	import Main;

	public class LevelCapRemover {
		public const MOD_NAME:String = "LevelCapRemover";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function LevelCapRemover() {}
		
		private function Calculator(fileContents:String) : void {
			function calculateLevelFromXp(functionContents:String) : void {
				result = main.regex('\
getlocal vLevelGuessLow\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"wizLevelMax")\n\
lessequals\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushtrue\
');
				result = main.regex('\
getlocal vLevelGuessMid\n\
convert_d\n\
setlocal vLevelGuessLow\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, '\
getlocal vLevelGuessMid\n\
getlocal vLevelGuessLow\n\
ifne jumpTarget1\n\
getlocal vLevelGuessLow\n\
convert_d\n\
setlocal vLevelGuessHigh\n\
jumpTarget1:\
', main.getJumpTargets("jumpTarget1"));
				result = main.regex('\
getlocal vLevelGuessMid\n\
convert_d\n\
setlocal vLevelGuessHigh\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, '\
getlocal vLevelGuessMid\n\
getlocal vLevelGuessHigh\n\
ifne jumpTarget1\n\
getlocal vLevelGuessLow\n\
convert_d\n\
setlocal vLevelGuessMid\n\
jumpTarget1:\
', main.getJumpTargets("jumpTarget1"));
				result = main.regex('\
getlocal vLevelGuessLow\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"wizLevelMax")\n\
ifngt (\\w+)\n\
debugline \\d+\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"wizLevelMax")\n\
convert_d\n\
setlocal vLevelGuessLow\n\
\\1:\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PackageNamespace(""),"calculateLevelFromXp")', calculateLevelFromXp);
		}
		
		private function SelectorRenderer(fileContents:String) : void {
			function renderXpBar(functionContents:String) : void {
				result = main.regex('\
(convert_i\n)\
setlocal vCurrentLevel\n\
').exec(functionContents);
				main.applyPatch(result.index, result[1].length, '\
convert_d\
');
				result = main.regex('\
getlocal vCurrentLevel\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"wizLevelMax")\n\
equals\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushfalse\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"renderXpBar")', renderXpBar);
		}
		
		private function SelectorInputHandler(fileContents:String) : void {
			function ehXpBarOver(functionContents:String) : void {
				result = main.regex('\
findpropstrict QName(PackageNamespace(""),"int")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"ppd")\n\
callproperty QName(PackageNamespace(""),"getWizLevel"), 0\n\
callproperty QName(PackageNamespace(""),"int"), 1\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"wizLevelMax")\n\
ifnge (\\w+)\n\
').exec(functionContents);
				main.applyPatch(result.index, result[1].length, '\
jump jumpTarget1\
', {jumpTarget1 : result[1]});
			}
			main.modifyFunction('QName(PackageNamespace(""),"ehXpBarOver")', ehXpBarOver);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/utils/Calculator.class.asasm", Calculator);
			main.modifyFile("com/giab/games/gcfw/selector/SelectorRenderer.class.asasm", SelectorRenderer);
			main.modifyFile("com/giab/games/gcfw/selector/SelectorInputHandler.class.asasm", SelectorInputHandler);
		}
	}
}