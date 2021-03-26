package mods {
	import Main;
	
	public class BetterBleeding {
		public const MOD_NAME:String = "BetterBleeding";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function BetterBleeding() {}
		
		private function IngameCreator(fileContents:String) : void {
			function createGem(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd1_Raw"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "bleedingIncDamageMultiplier"\\)\n\
pushdouble 0.15\n)\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
')).exec(functionContents);
			main.applyPatch(result.index + result[1].length, 0, main.format('\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "core")\n\
getproperty QName(PackageNamespace(""), "skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "SkillId")\n\
getproperty QName(PackageNamespace(""), "BLEEDING")\n\
getproperty MultinameL({namespaces})\n\
pushbyte 0\n\
getproperty MultinameL({namespaces})\n\
callproperty Multiname("g", {namespaces}), 0\n\
add\n\
multiply\
'));
			}
			main.modifyFunction('QName(PackageNamespace(""), "createGem")', createGem);
		}
		
		private function PnlSkills(fileContents:String) : void {
			function populateSkillsMetaData(functionContents:String) : void {
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "skillEffectiveValuesPerLevel"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "SkillId"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "BLEEDING"\\)\n\
pushdouble 0.04\n\
pushdouble 0.04\n)\
(newarray 2\n)\
setproperty MultinameL[^\n]+\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, main.format('\
getlocal0\n\
getproperty QName(PackageNamespace(""), "skillDescriptions")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "SkillId")\n\
getproperty QName(PackageNamespace(""), "BLEEDING")\n\
getproperty MultinameL({namespaces})\n\
pushbyte 2\n\
pushstring "#0% longer bleeding gem effect"\n\
setproperty MultinameL({namespaces})\
'));
				main.applyPatch(result.index + result[1].length, result[2].length, '\
pushdouble 0.2\n\
newarray 3\
');
			}
			function renderInfoPanelSkill(functionContents:String) : void {
				regex = new RegExp(main.format('\
getlocal ?{pId}\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "SkillId"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "DEMOLITION"\\)\n\
ifne (\\w+)\n\
.+\
\\1:\
'), "gs");
				result = regex.exec(functionContents);
				while (result != null) {
					var newString:String = result[0];
					newString = newString.replace("DEMOLITION", "BLEEDING");
					var jumpTargets:Object = main.getJumpTargets("jumpTarget1");
					newString = newString.replace(new RegExp(result[1], "g"), jumpTargets["jumpTarget1"]);
					main.applyPatch(result.index, 0, newString);
					result = regex.exec(functionContents);
				}
			}
			main.modifyFunction('QName(PackageNamespace(""), "populateSkillsMetaData")', populateSkillsMetaData);
			main.modifyFunction('QName(PackageNamespace(""), "renderInfoPanelSkill")', renderInfoPanelSkill);
		}
		
		private function IngameInitializer2(fileContents:String) : void {
			function populateSkillEffectiveValues(functionContents:String) : void {
				regex = new RegExp(main.format('\
getlocal ?{i}\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "SkillId"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "DEMOLITION"\\)\n\
ifne (\\w+)\n\
.+\
\\1:\
'), "gs");
				result = regex.exec(functionContents);
				while (result != null) {
					var newString:String = result[0];
					newString = newString.replace("DEMOLITION", "BLEEDING");
					var jumpTargets:Object = main.getJumpTargets("jumpTarget1");
					newString = newString.replace(new RegExp(result[1], "g"), jumpTargets["jumpTarget1"]);
					main.applyPatch(result.index, 0, newString);
					result = regex.exec(functionContents);
				}
			}
			main.modifyFunction('QName(PackageNamespace(""), "populateSkillEffectiveValues")', populateSkillEffectiveValues);
		}
		
		private function Gem(fileContents:String) : void {
			function calculateSd2_ComponentsNum(functionContents:String) : void {
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "elderComponents"\\)\n\
getlocal1\n\
getproperty MultinameL[^\n]+\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "GemComponentType"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "BLEEDING"\\)\n\
ifne (\\w+)\n)\
(.+)\
jump \\w+\n\
\\2:\n\
', "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, main.format('\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "bleedingIncDamageMultiplier")\n\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "bleedingIncDamageMultiplier")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
getlocal {vMultComponents}\n\
multiply\n\
getlocal {vMultTrueColors}\n\
multiply\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "grade")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushbyte 6\n\
iflt {jumpTarget1}\n\
pushbyte 1\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "SkillId")\n\
getproperty QName(PackageNamespace(""), "BLEEDING")\n\
getproperty MultinameL({namespaces})\n\
pushbyte 1\n\
getproperty MultinameL({namespaces})\n\
callproperty Multiname("g", {namespaces}), 0\n\
add\n\
jump {jumpTarget2}\n\
{jumpTarget1}:\n\
pushbyte 1\n\
{jumpTarget2}:\n\
multiply\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\n\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "bleedingIncDamageDuration")\n\
pushbyte 90\n\
pushbyte 1\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "SkillId")\n\
getproperty QName(PackageNamespace(""), "BLEEDING")\n\
getproperty MultinameL({namespaces})\n\
pushbyte 2\n\
getproperty MultinameL({namespaces})\n\
callproperty Multiname("g", {namespaces}), 0\n\
add\n\
multiply\n\
callpropvoid QName(PackageNamespace(""),"s"), 1\
', main.getJumpTargets("jumpTarget1", "jumpTarget2")));
			}
			main.modifyFunction('QName(PackageNamespace(""), "calculateSd2_ComponentsNum")', calculateSd2_ComponentsNum);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameCreator.class.asasm", IngameCreator);
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInitializer2.class.asasm", IngameInitializer2);
			main.modifyFile("com/giab/games/gcfw/entity/Gem.class.asasm", Gem);
		}
	}
}