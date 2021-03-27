package mods {
	import Main;

	public class ProportionateFragmentDrops {
		public const MOD_NAME:String = "ProportionateFragmentDrops";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function ProportionateFragmentDrops() {}
		
		private function IngamePopulator(fileContents:String) : void {
			function buildMonsterWaveDescs(functionContents:String) : void {
				result = new RegExp(main.format('\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "random"\\), 0\n\
pushdouble 2.99\n\
multiply\n\
callproperty QName\\(PackageNamespace\\(""\\), "floor"\\), 1\n\
convert_i\n\
setlocal ?{vFragType}\n\
debugline \\d+\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ppd"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "getWizLevel"\\), 0\n\
pushbyte 70\n\
lessthan\n\
dup\n\
iffalse (\\w+)\n\
pop\n\
getlocal ?{vFragType}\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "TalismanFragmentType"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "CORNER"\\)\n\
equals\n\
\\1:\n\
iffalse (\\w+)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "TalismanFragmentType"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "EDGE"\\)\n\
convert_i\n\
setlocal ?{vFragType}\n\
\\2:\n\
debugline \\d+\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ppd"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "getWizLevel"\\), 0\n\
pushbyte 35\n\
lessthan\n\
dup\n\
iffalse (\\w+)\n\
pop\n\
getlocal ?{vFragType}\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "TalismanFragmentType"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "EDGE"\\)\n\
equals\n\
\\3:\n\
iffalse (\\w+)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "TalismanFragmentType"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "INNER"\\)\n\
convert_i\n\
setlocal ?{vFragType}\n\
\\4:\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length, main.format('\
getlex QName(PackageNamespace(""), "Math")\n\
callproperty QName(PackageNamespace(""), "random"), 0\n\
pushdouble 0.36\n\
ifnlt {jumpTarget1}\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "TalismanFragmentType")\n\
getproperty QName(PackageNamespace(""), "INNER")\n\
jump {jumpTarget2}\n\
{jumpTarget1}:\n\
getlex QName(PackageNamespace(""), "Math")\n\
callproperty QName(PackageNamespace(""),"random"), 0\n\
pushdouble 0.25\n\
ifnlt {jumpTarget3}\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "TalismanFragmentType")\n\
getproperty QName(PackageNamespace(""), "CORNER")\n\
jump {jumpTarget2}\n\
{jumpTarget3}:\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "TalismanFragmentType")\n\
getproperty QName(PackageNamespace(""), "EDGE")\n\
{jumpTarget2}:\
convert_i\n\
setlocal {vFragType}\n\
', main.getJumpTargets("jumpTarget1", "jumpTarget2", "jumpTarget3")));
			}
			main.modifyFunction('QName(PackageNamespace(""), "buildMonsterWaveDescs")', buildMonsterWaveDescs);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngamePopulator.class.asasm", IngamePopulator);
		}
	}
}