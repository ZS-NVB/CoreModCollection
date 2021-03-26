package mods {
	import Main;
	
	public class BetterTrueColors {
		public const MOD_NAME:String = "BetterTrueColors";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function BetterTrueColors() {}
		
		private function IngameCreator(fileContents:String) : void {
			function createGem(functionContents:String) : void {
				regex = new RegExp('\
pushbyte 1\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "skillEffectiveValues"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "SkillId"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "RESONANCE"\\)\n\
getproperty MultinameL[^\n]+\n\
pushbyte 0\n\
getproperty MultinameL[^\n]+\n\
callproperty Multiname\\("g", [^\n]+\n\
add\n\
multiply\n\
', "g");
				result = regex.exec(functionContents);
				while (result != null) {
					main.applyPatch(result.index + result[0].length, 0, result[0].replace("RESONANCE", "TRUE_COLORS").replace("pushbyte 0", "pushbyte 1"));
					result = regex.exec(functionContents);
				}
			}
			main.modifyFunction('QName(PackageNamespace(""), "createGem")', createGem);
		}
		
		private function Gem(fileContents:String) : void {
			function calculateSd2_ComponentsNum(functionContents:String) : void {
				result = new RegExp(main.format('\
debugline \\d+\n\
getlocal ?3\n\
pushbyte 1\n\
ifne (\\w+)\n\
.+\
jump (\\w+)\n\
\\1:\n\
debugline \\d+\n\
getlocal ?3\n\
pushbyte 5\n\
ifnlt \\2\n\
.+\
\\2:\n\
'), "s").exec(functionContents);
				main.applyPatch(result.index, result[0].length, main.format('\
getlocal {iLim}\n\
pushbyte 2\n\
ifnge {jumpTarget1}\n\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "damageMin")\n\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "damageMin")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushdouble 1.2\n\
multiply\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\n\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "damageMax")\n\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "damageMax")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushdouble 1.2\n\
multiply\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\n\
{jumpTarget1}:\n\
pushbyte 1\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "SkillId")\n\
getproperty QName(PackageNamespace(""), "TRUE_COLORS")\n\
getproperty MultinameL({namespaces})\n\
pushbyte 0\n\
getproperty MultinameL({namespaces})\n\
callproperty Multiname("g", {namespaces}), 0\n\
add\n\
convert_d\n\
setlocal {vMultTrueColors}\n\
', main.getJumpTargets("jumpTarget1")));
				main.requireMaxStack(5);
			}
			main.modifyFunction('QName(PackageNamespace(""), "calculateSd2_ComponentsNum")', calculateSd2_ComponentsNum);
		}
		
		private function PnlSkills(fileContents:String) : void {
			function populateSkillsMetaData(functionContents:String) : void {
				result = new RegExp('\
pushstring "\\+#0% damage and specials multiplier to pure gems"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, 'pushstring "+#0% gem specials"');
				result = new RegExp('\
pushstring "\\+#0% damage and specials multiplier to dual, triple and quad gems"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, 'pushstring "+#0% gem damage"');
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "skillEffectiveValuesPerLevel"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "SkillId"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "TRUE_COLORS"\\)\n)\
(pushdouble 0.03\n\
pushdouble 0.18\n)\
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
		
		private function IngameInfoPanelRenderer2(fileContents:String) : void {
			function renderInfoPanelGem(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal ?{pGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "elderComponents"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "length"\\)\n)\
(pushbyte 8\n)\
ifne \\w+\n\
')).exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, "pushbyte 6");
				result = new RegExp(main.format('\
(getlocal ?{pGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "elderComponents"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "length"\\)\n)\
(pushbyte 5\n)\
ifnlt \\w+\n\
')).exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, "pushbyte 7");
				result = new RegExp(main.format('\
((jump (\\w+)\n\
\\w+:\n)\
debugline \\d+\n\
getlocal ?{vT3}\n\
pushstring "Quad gem modifiers:\\\\n"\n\
add\n\
setlocal ?{vT3}\n)\
\\3:\n\
')).exec(functionContents);
				var jumpTargets:Object = main.getJumpTargets("jumpTarget1", "jumpTarget2");
				jumpTargets["jumpTarget3"] = result[3];
				main.applyPatch(result.index + result[2].length, 0, main.format('\
getlocal {pGem}\n\
getproperty QName(PackageNamespace(""), "elderComponents")\n\
getproperty QName(PackageNamespace(""), "length")\n\
pushbyte 4\n\
ifne {jumpTarget1}\
', jumpTargets));
				main.applyPatch(result.index + result[1].length, 0, main.format('\
jump {jumpTarget3}\n\
{jumpTarget1}:\n\
getlocal {pGem}\n\
getproperty QName(PackageNamespace(""), "elderComponents")\n\
getproperty QName(PackageNamespace(""), "length")\n\
pushbyte 5\n\
ifne {jumpTarget2}\n\
getlocal {vT3}\n\
pushstring "Quint gem modifiers:\n"\n\
add\n\
setlocal {vT3}\n\
jump {jumpTarget3}\n\
{jumpTarget2}:\n\
getlocal {vT3}\n\
pushstring "Prismatic gem modifiers:\n"\n\
add\n\
setlocal {vT3}\n\
', jumpTargets));
				regex = new RegExp('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "skillEffectiveValues"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "SkillId"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "TRUE_COLORS"\\)\n\
getproperty MultinameL[^\n]+\n\
pushbyte \\d\n\
getproperty MultinameL[^\n]+\n\
callproperty Multiname\\("g", [^\n]+\n\
', "g");
				result = regex.exec(functionContents);
				while (result != null) {
					main.applyPatch(result.index, result[0].length, "pushbyte 0");
					result = regex.exec(functionContents);
				}
			}
			main.modifyFunction('QName(PackageNamespace(""), "renderInfoPanelGem")', renderInfoPanelGem);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameCreator.class.asasm", IngameCreator);
			main.modifyFile("com/giab/games/gcfw/entity/Gem.class.asasm", Gem);
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInfoPanelRenderer2.class.asasm", IngameInfoPanelRenderer2);
		}
	}
}