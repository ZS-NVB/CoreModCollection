package mods {
	import Main;

	public class NoRitualWizardHunters {
		public const MOD_NAME:String = "NoRitualWizardHunters";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function NoRitualWizardHunters() {}
		
		private function IngameInitializer(fileContents:String) : void {
			function setScene3Initiate(functionContents:String) : void {
				result = main.regex('\
getlocal i\n\
pushbyte 7\n\
greaterthan\n\
dup\n\
iffalse (\\w+)\n\
pop\n\
getlex QName(PackageNamespace(""),"Math")\n\
callproperty QName(PackageNamespace(""),"random"), 0\n\
pushdouble 0.5\n\
greaterthan\n\
\\1:\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushfalse\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"setScene3Initiate")', setScene3Initiate);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInitializer.class.asasm", IngameInitializer);
		}
	}
}