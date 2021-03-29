package mods {
	import Main;

	public class TrapRangeIncrease {
		public const MOD_NAME:String = "TrapRangeIncrease";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function TrapRangeIncrease() {}
		
		private function Trap(fileContents:String) : void {
			function iinit(functionContents:String) : void {
				result = new RegExp('\
(getlocal0\n\
pushbyte 30\n)\
initproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
', "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, 0, '\
pushbyte 28\n\
multiply\n\
pushbyte 17\n\
divide\
');
			}
			main.modifyFunction('iinit', iinit);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/Trap.class.asasm", Trap);
		}
	}
}