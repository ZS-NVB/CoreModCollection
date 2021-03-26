package mods {
	import Main;

	public class TrapTargetFix {
		public const MOD_NAME:String = "TrapTargetFix";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function TrapTargetFix() {}
		
		private function Trap(fileContents:String) : void {
			function doEnterFrame(functionContents:String) : void {
				result = new RegExp('\
jump (\\w+)\n\
\\w+:\n\
label\n\
.+\
jump (\\w+)\n\
jump \\w+\n\
\\1:\n\
debugline \\d+\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "insertedGem"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "targetPriority"\\)\n\
.+\
lookupswitch [^\n]+\n\
\\2:\n\
', "s").exec(functionContents);
				main.applyPatch(result.index, result[0].length);
				var newString:String = result[0].replace('\
getlex QName(PackageNamespace(""), "Array")\n\
getproperty QName(PackageNamespace(""), "NUMERIC")\n\
newarray 1\n\
', '\
getlex QName(PackageNamespace(""), "Array")\n\
getproperty QName(PackageNamespace(""), "NUMERIC")\n\
getlex QName(PackageNamespace(""), "Array")\n\
getproperty QName(PackageNamespace(""), "DESCENDING")\n\
bitor\n\
') + main.format('\
getlocal0\n\
getproperty QName(PackageNamespace(""), "insertedGem")\n\
getproperty QName(PackageNamespace(""), "targetPriority")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "TargetPriorityId")\n\
getproperty QName(PackageNamespace(""), "RANDOM")\n\
ifne {jumpTarget1}\n\
getlex QName(PackageNamespace(""), "Math")\n\
getlex QName(PackageNamespace(""), "Math")\n\
callproperty QName(PackageNamespace(""), "random"), 0\n\
getlocal {vPossibleTargets}\n\
getproperty QName(PackageNamespace(""), "length")\n\
multiply\n\
callproperty QName(PackageNamespace(""), "floor"), 1\n\
jump {jumpTarget2}\n\
{jumpTarget1}:\n\
pushbyte 0\n\
{jumpTarget2}:\n\
convert_d\n\
setlocal {vIdToShoot}\n\
', main.getJumpTargets("jumpTarget1", "jumpTarget2"));
				result = new RegExp(main.format('\
getlocal ?{i}\n\
getlocal ?{vPossibleTargets}\n\
getproperty QName\\(PackageNamespace\\(""\\), "length"\\)\n\
modulo\n\
convert_d\n\
setlocal ?{vIdToShoot}\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length, newString);
				result = new RegExp(main.format('\
getlocal ?{vShotsLeftForTarget}\n\
getlocal ?{vIdToShoot}\n\
getproperty MultinameL[^\n]+\n\
pushbyte 1\n\
ifnlt (\\w+)\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length, main.format('\
getlocal {vM}\n\
getproperty Multiname("isDestroyed", {namespaces})\n\
iffalse {jumpTarget1}\
', {jumpTarget1: result[1]}));
			}
			main.modifyFunction('QName(PackageNamespace(""), "doEnterFrame")', doEnterFrame);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/Trap.class.asasm", Trap);
		}
	}
}