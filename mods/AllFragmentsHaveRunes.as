package mods {
	import Main;

	public class AllFragmentsHaveRunes {
		public const MOD_NAME:String = "AllFragmentsHaveRunes";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function AllFragmentsHaveRunes() {}
		
		private function TalismanFragment(fileContents:String) : void {
			function calculateProperties(functionContents:String) : void {
				result = new RegExp('\
initproperty QName\\(PackageNamespace\\(""\\), "runeId"\\)\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, '\
pushbyte 5\n\
modulo\
');
			}
			main.modifyFunction('QName(PackageNamespace(""), "calculateProperties")', calculateProperties);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/TalismanFragment.class.asasm", TalismanFragment);
		}
	}
}