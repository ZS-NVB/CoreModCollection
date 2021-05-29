package mods {
	import Main;

	public class MultiplicativeBoundModifiers {
		public const MOD_NAME:String = "MultiplicativeBoundModifiers";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function MultiplicativeBoundModifiers() {}
		
		private function Gem(fileContents:String) : void {
			function addIntensity(functionContents:String) : void {
				result = main.regex('\
getlocal0\n\
getproperty QName(PackageNamespace(""),"dmgMultByPool")\n\
add\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, '\
pushbyte 1\
');
				main.applyPatch(result.index + result[0].length, 0, '\
multiply\
');
			}
			main.modifyFunction('QName(PrivateNamespace("com.giab.games.gcfw.entity:Gem"),"addIntensity")', addIntensity);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/Gem.class.asasm", Gem);
		}
	}
}