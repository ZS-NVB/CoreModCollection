package mods {
	import Main;

	public class BarrageTargetLimitRemover {
		public const MOD_NAME:String = "BarrageTargetLimitRemover";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function BarrageTargetLimitRemover() {}
		
		private function IngameController(fileContents:String) : void {
			function barrageShellExplodes(functionContents:String) : void {
				result = new RegExp(main.format('\
getlocal ?{vMonstersHit}\n\
pushbyte 3\n\
ifnge (\\w+)\n\
debugline \\d+\n\
jump \\w+\n\
\\1:\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PackageNamespace(""), "barrageShellExplodes")', barrageShellExplodes);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameController.class.asasm", IngameController);
		}
	}
}