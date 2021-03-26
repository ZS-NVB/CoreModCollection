package mods {
	import Main;
	
	public class BetterResonance {
		public const MOD_NAME:String = "BetterResonance";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function BetterResonance() {}
		
		private function IngameCreator(fileContents:String) : void {
			function createGem(functionContents:String) : void {
				result = new RegExp(main.format('\
debugline \\d+\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd1_Raw"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd1_Raw"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "range"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "skillEffectiveValues"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "SkillId"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "RESONANCE"\\)\n\
getproperty MultinameL[^\n]+\n\
pushbyte 1\n\
getproperty MultinameL[^\n]+\n\
callproperty Multiname\\("g", [^\n]+\n\
add\n\
multiply\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
')).exec(functionContents);
			main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('QName(PackageNamespace(""), "createGem")', createGem);
		}
		
		private function Gem(fileContents:String) : void {
			function calculateSd2_ComponentsNum(functionContents:String) : void {
				result = new RegExp(main.format('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd1_Raw"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "clone"\\), 0\n\
coerce QName\\(PackageNamespace\\("com.giab.games.gcfw.struct"\\), "ShotData"\\)\n\
setlocal ?{vSdOut}\n\
')).exec(functionContents);
				main.applyPatch(result.index + result[0].length, 0, main.format('\
getlocal0\n\
getproperty QName(PackageNamespace(""), "grade")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushbyte 6\n\
iflt {jumpTarget1}\n\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "damageMin")\n\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "damageMin")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushbyte 1\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "SkillId")\n\
getproperty QName(PackageNamespace(""), "RESONANCE")\n\
getproperty MultinameL({namespaces})\n\
pushbyte 1\n\
getproperty MultinameL({namespaces})\n\
callproperty Multiname("g", {namespaces}), 0\n\
add\n\
multiply\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\n\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "damageMax")\n\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "damageMax")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushbyte 1\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "SkillId")\n\
getproperty QName(PackageNamespace(""), "RESONANCE")\n\
getproperty MultinameL({namespaces})\n\
pushbyte 1\n\
getproperty MultinameL({namespaces})\n\
callproperty Multiname("g", {namespaces}), 0\n\
add\n\
multiply\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\n\
{jumpTarget1}:\
', main.getJumpTargets("jumpTarget1")));
				main.requireMaxStack(5);
			}
			main.modifyFunction('QName(PackageNamespace(""), "calculateSd2_ComponentsNum")', calculateSd2_ComponentsNum);
		}
		
		private function PnlSkills(fileContents:String) : void {
			function populateSkillsMetaData(functionContents:String) : void {
				result = new RegExp('\
pushstring "\\+#0,1% gem range"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushstring "additional +#0% gem damage for grade 7+ gems"\
');
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "skillEffectiveValuesPerLevel"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "SkillId"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "RESONANCE"\\)\n)\
(pushdouble 0.03\n\
pushdouble 0.005\n)\
newarray 2\n\
setproperty MultinameL[^\n]+\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, '\
pushdouble 0.04\n\
pushdouble 0.04\
');
			}
			main.modifyFunction('QName(PackageNamespace(""), "populateSkillsMetaData")', populateSkillsMetaData);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameCreator.class.asasm", IngameCreator);
			main.modifyFile("com/giab/games/gcfw/entity/Gem.class.asasm", Gem);
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
		}
	}
}