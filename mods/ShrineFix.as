package mods {
	import Main;

	public class ShrineFix {
		public const MOD_NAME:String = "ShrineFix";
		public const COREMOD_VERSION:String = "2";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function ShrineFix() {}
		
		private function Shrine(fileContents:String) : void {
			function doEnterFrame(functionContents:String) : void {
				result = main.regex('\
pushbyte 15\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"hpRatioToShred")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
pushdouble 0.1\n\
add\n\
pushdouble 0.025\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, result[0].replace("pushbyte 15", "pushbyte 30").replace("pushdouble 0.1", "pushdouble 0.2").replace("pushdouble 0.025", "pushdouble 0.05"));
				result = main.regex('\
(getlocal0\n\
getproperty QName(PackageNamespace(""),"damageToDeal")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n)\
(getlocal vHpOriginal\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"hpRatioToShred")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
multiply\n\
pushdouble 0.01\n\
multiply\n\
add\n)\
convert_d\n\
setlocal vDamageToDeal\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length);
				result = main.regex('\
getlocal vM\n\
getproperty Multiname("hp")\n\
callproperty Multiname("g"), 0\n\
convert_d\n\
setlocal vHpOriginal\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, '\
getlocal vM\n\
getproperty Multiname("hp")\n\
getlocal vM\n\
getproperty Multiname("hp")\n\
callproperty Multiname("g"), 0\n\
getlocal vM\n\
getproperty Multiname("hpMax")\n\
callproperty Multiname("g"), 0\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"hpRatioToShred")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
multiply\n\
pushdouble 0.01\n\
multiply\n\
subtract\n\
callpropvoid Multiname("s"), 1\n\
getlocal vM\n\
getproperty Multiname("hpMax")\n\
getlocal vM\n\
getproperty Multiname("hpMax")\n\
callproperty Multiname("g"), 0\n\
getlocal vM\n\
getproperty Multiname("hpMax")\n\
callproperty Multiname("g"), 0\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"hpRatioToShred")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
multiply\n\
pushdouble 0.01\n\
multiply\n\
subtract\n\
callpropvoid Multiname("s"), 1\n\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"doEnterFrame")', doEnterFrame);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/Shrine.class.asasm", Shrine);
		}
	}
}