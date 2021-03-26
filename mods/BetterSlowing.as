package mods {
	import Main;
	
	public class BetterSlowing {
		public const MOD_NAME:String = "BetterSlowing";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function BetterSlowing() {}
		
		private function IngameCreator(fileContents:String) : void {
			function createGem(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal ?{vGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd1_Raw"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "slowPower"\\)\n\
pushdouble 1.05\n)\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
')).exec(functionContents);
			main.applyPatch(result.index + result[1].length, 0, main.format('\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "core")\n\
getproperty QName(PackageNamespace(""), "skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "SkillId")\n\
getproperty QName(PackageNamespace(""), "SLOWING")\n\
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
pushstring "#0% longer slowing gem effect"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, 'pushstring "#0% higher slowing gem component power"');
				result = new RegExp('\
pushstring "additional #0% longer slowing gem effect for grade 7\\+ gems"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, 'pushstring "additional #0% higher slowing gem component power for grade 7+ gems"');
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "skillEffectiveValuesPerLevel"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "SkillId"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "SLOWING"\\)\n\
pushdouble 0.04\n\
pushdouble 0.04\n)\
(newarray 2\n)\
setproperty MultinameL[^\n]+\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, main.format('\
getlocal0\n\
getproperty QName(PackageNamespace(""), "skillDescriptions")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "SkillId")\n\
getproperty QName(PackageNamespace(""), "SLOWING")\n\
getproperty MultinameL({namespaces})\n\
pushbyte 2\n\
pushstring "#0% longer slowing gem effect"\n\
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
					newString = newString.replace("DEMOLITION", "SLOWING");
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
					newString = newString.replace("DEMOLITION", "SLOWING");
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
getproperty QName\\(PackageNamespace\\(""\\), "SLOWING"\\)\n\
ifne (\\w+)\n)\
(.+)\
jump \\w+\n\
\\2:\n\
', "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, main.format('\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "slowPower")\n\
getlocal {vSdOut}\n\
getproperty QName(PackageNamespace(""), "slowPower")\n\
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
getproperty QName(PackageNamespace(""), "SLOWING")\n\
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
getproperty QName(PackageNamespace(""), "slowDuration")\n\
pushbyte 90\n\
pushbyte 1\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"), "SkillId")\n\
getproperty QName(PackageNamespace(""), "SLOWING")\n\
getproperty MultinameL({namespaces})\n\
pushbyte 2\n\
getproperty MultinameL({namespaces})\n\
callproperty Multiname("g", {namespaces}), 0\n\
add\n\
multiply\n\
callpropvoid QName(PackageNamespace(""),"s"), 1\
', main.getJumpTargets("jumpTarget1", "jumpTarget2")));
			}
			function calculateRealValues(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal ?{pSd}\n\
getproperty QName\\(PackageNamespace\\(""\\), "slowPower"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
pushbyte 0\n\
ifngt (\\w+)\n)\
(.+)\
jump \\w+\n\
\\2:\
'), "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, main.format('\
getlocal {pSd}\n\
getproperty QName(PackageNamespace(""), "calcSlowRatio")\n\
pushbyte 1\n\
dup\n\
pushdouble 0.400480631651318\n\
getlex QName(PackageNamespace(""), "Math")\n\
pushbyte 1\n\
pushdouble 0.72117302934792\n\
getlocal {pSd}\n\
getproperty QName(PackageNamespace(""), "slowPower")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
multiply\n\
add\n\
callproperty QName(PackageNamespace(""), "log"), 1\n\
multiply\n\
add\n\
divide\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\
'));
			}
			main.modifyFunction('QName(PackageNamespace(""), "calculateSd2_ComponentsNum")', calculateSd2_ComponentsNum);
			main.modifyFunction('QName(PackageNamespace(""), "calculateRealValues")', calculateRealValues);
		}
		
		private function Monster(fileContents:String) : void {
			function adjustSpeedCosSin(functionContents:String) : void {
				result = new RegExp('\
getlocal0\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "speedCurrent"\\)\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "orbletCarryingSpeedMult"\\)\n\
multiply\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "snowSpeedMult"\\)\n\
multiply\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "isInWhiteout"\\)\n\
iffalse (\\w+)\n\
pushdouble 0.4\n\
coerce_a\n\
jump (\\w+)\n\
\\1:\n\
pushbyte 1\n\
coerce_a\n\
\\2:\n\
multiply\n\
initproperty QName\\(PackageNamespace\\(""\\), "speedMultiplied"\\)\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, main.format('\
getlocal0\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "speedMax")\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "slowRatio")\n\
divide\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "orbletCarryingSpeedMult")\n\
divide\n\
add\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "snowSpeedMult")\n\
divide\n\
add\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "isInWhiteout")\n\
iffalse {jumpTarget1}\n\
pushdouble 1.5\n\
jump {jumpTarget2}\n\
{jumpTarget1}:\n\
pushbyte 0\n\
{jumpTarget2}:\n\
add\n\
pushbyte 2\n\
subtract\n\
divide\n\
initproperty QName(PackageNamespace(""), "speedMultiplied")\
', main.getJumpTargets("jumpTarget1", "jumpTarget2")));
				main.requireMaxStack(5);
			}
			main.modifyFunction('QName(PackageNamespace(""), "adjustSpeedCosSin")', adjustSpeedCosSin);
		}
		
		private function adjustSpeed(functionContents:String) : void {
			result = new RegExp('\
getlocal0\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "speedMax"\\)\n\
.+\
initproperty QName\\(PackageNamespace\\(""\\), "speedCurrent"\\)\n\
', "s").exec(functionContents);
			main.applyPatch(result.index, result[0].length, main.format('\
getlocal0\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "speedMax")\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "slowRatio")\n\
divide\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "isInWhiteout")\n\
iffalse {jumpTarget1}\n\
pushdouble 1.5\n\
jump {jumpTarget2}\n\
{jumpTarget1}:\n\
pushbyte 0\n\
{jumpTarget2}:\n\
add\n\
divide\n\
initproperty QName(PackageNamespace(""), "speedCurrent")\
', main.getJumpTargets("jumpTarget1", "jumpTarget2")));
			main.requireMaxStack(4);
		}
		
		private function FlyingOne(fileContents:String) : void {
			main.modifyFunction('QName(PackageNamespace(""), "adjustSpeed")', adjustSpeed);
		}
		
		private function NonFlyingOne(fileContents:String) : void {
			main.modifyFunction('QName(PackageNamespace(""), "adjustSpeedCosSin")', adjustSpeed);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameCreator.class.asasm", IngameCreator);
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInitializer2.class.asasm", IngameInitializer2);
			main.modifyFile("com/giab/games/gcfw/entity/Gem.class.asasm", Gem);
			main.modifyFile("com/giab/games/gcfw/entity/Monster.class.asasm", Monster);
			main.modifyFile("com/giab/games/gcfw/entity/Apparition.class.asasm", FlyingOne);
			main.modifyFile("com/giab/games/gcfw/entity/Guardian.class.asasm", NonFlyingOne);
			main.modifyFile("com/giab/games/gcfw/entity/Specter.class.asasm", FlyingOne);
			main.modifyFile("com/giab/games/gcfw/entity/Spire.class.asasm", FlyingOne);
			main.modifyFile("com/giab/games/gcfw/entity/SwarmQueen.class.asasm", NonFlyingOne);
			main.modifyFile("com/giab/games/gcfw/entity/WizardHunter.class.asasm", NonFlyingOne);
			main.modifyFile("com/giab/games/gcfw/entity/Wraith.class.asasm", FlyingOne);
		}
	}
}