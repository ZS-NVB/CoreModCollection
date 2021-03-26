package mods {
	import Main;

	public class ShrineFix {
		public const MOD_NAME:String = "ShrineFix";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function ShrineFix() {}
		
		private function Shrine(fileContents:String) : void {
			function doEnterFrame(functionContents:String) : void {
				result = new RegExp('\
pushbyte 15\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "hpRatioToShred"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
pushdouble 0.1\n\
add\n\
pushdouble 0.025\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, result[0].replace("pushbyte 15", "pushbyte 30").replace("pushdouble 0.1", "pushdouble 0.2").replace("pushdouble 0.025", "pushdouble 0.05"));
				result = new RegExp(main.format('\
(getlocal ?{vHpOriginal}\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "hpRatioToShred"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
multiply\n\
pushdouble 0.01\n\
multiply\n\
add\n)\
convert_d\n\
setlocal ?{vDamageToDeal}\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[1].length);
				main.applyPatch(result.index + result[0].length, 0, main.format('\
getlocal {vM}\n\
getproperty Multiname("hp", {namespaces})\n\
getlocal {vHpOriginal}\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "hpRatioToShred")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushdouble 0.01\n\
multiply\n\
subtract\n\
multiply\n\
callpropvoid Multiname("s", {namespaces}), 1\
'));
			}
			main.modifyFunction('QName(PackageNamespace(""), "doEnterFrame")', doEnterFrame);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/Shrine.class.asasm", Shrine);
		}
	}
}