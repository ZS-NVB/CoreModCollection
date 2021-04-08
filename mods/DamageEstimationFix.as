package mods {
	import Main;

	public class DamageEstimationFix {
		public const MOD_NAME:String = "DamageEstimationFix";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function DamageEstimationFix() {}
		
		private function getIncomingDamageIncrease(ignoreArmor:Boolean = false) : String {
			var damageEstimation:String = "";
			if (!ignoreArmor) {
				damageEstimation += main.format('\
getlocal {vTarget}\n\
getproperty Multiname("isInWhiteout", {namespaces})\n\
iftrue {jumpTarget1}\n\
getlocal {vActualDamage}\n\
getlocal {vTarget}\n\
getproperty Multiname("armorLevel", {namespaces})\n\
callproperty Multiname("g", {namespaces}), 0\n\
subtract\n\
convert_d\n\
setlocal {vActualDamage}\n\
getlocal {vTarget}\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster")\n\
istypelate\n\
iffalse {jumpTarget2}\n\
getlocal {vActualDamage}\n\
findpropstrict QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster")\n\
getlocal {vTarget}\n\
callproperty QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster"), 1\n\
getproperty QName(PackageNamespace(""), "strInNum")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "monstersOnScene")\n\
getproperty QName(PackageNamespace(""), "length")\n\
pushbyte 1\n\
subtract\n\
multiply\n\
subtract\n\
convert_d\n\
setlocal {vActualDamage}\n\
{jumpTarget2}:\n\
getlex QName(PackageNamespace(""), "Math")\n\
pushbyte 1\n\
getlocal {vActualDamage}\n\
callproperty QName(PackageNamespace(""), "max"), 2\n\
convert_d\n\
setlocal {vActualDamage}\n\
{jumpTarget1}:\n\
', main.getJumpTargets("jumpTarget1", "jumpTarget2"));
			}
			damageEstimation += main.format('\
pushstring "bleedingDamageMultBonus"\n\
getlocal {vTarget}\n\
in\n\
iffalse {jumpTarget1}\n\
getlocal {vActualDamage}\n\
pushbyte 1\n\
getlocal {vTarget}\n\
getproperty Multiname("bleedingDamageMultBonus", {namespaces})\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vActualDamage}\n\
{jumpTarget1}:\n\
pushstring "talismanDmgMult"\n\
getlocal {vTarget}\n\
in\n\
iffalse {jumpTarget2}\n\
getlocal {vActualDamage}\n\
getlocal {vTarget}\n\
getproperty Multiname("talismanDmgMult", {namespaces})\n\
multiply\n\
convert_d\n\
setlocal {vActualDamage}\n\
{jumpTarget2}:\n\
getlocal {vTarget}\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster")\n\
istypelate\n\
iffalse {jumpTarget3}\n\
getlocal {vActualDamage}\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "wraithDmgMult")\n\
multiply\n\
findpropstrict QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster")\n\
getlocal {vTarget}\n\
callproperty QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster"), 1\n\
getproperty QName(PackageNamespace(""), "rainDamageMult")\n\
multiply\n\
getlex QName(PackageNamespace(""), "Math")\n\
findpropstrict QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster")\n\
getlocal {vTarget}\n\
callproperty QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster"), 1\n\
getproperty QName(PackageNamespace(""), "dmgReductionMin")\n\
pushbyte 1\n\
findpropstrict QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster")\n\
getlocal {vTarget}\n\
callproperty QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster"), 1\n\
getproperty QName(PackageNamespace(""), "hitsTaken")\n\
findpropstrict QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster")\n\
getlocal {vTarget}\n\
callproperty QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster"), 1\n\
getproperty QName(PackageNamespace(""), "dmgReductionPerHitsTaken")\n\
multiply\n\
subtract\n\
callproperty QName(PackageNamespace(""),"max"), 2\n\
multiply\n\
convert_d\n\
setlocal {vActualDamage}\n\
findpropstrict QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster")\n\
getlocal {vTarget}\n\
callproperty QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster"), 1\n\
getproperty QName(PackageNamespace(""), "dmgDiv")\n\
pushbyte 0\n\
ifngt {jumpTarget4}\n\
getlex QName(PackageNamespace(""), "Math")\n\
getlocal {vActualDamage}\n\
findpropstrict QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster")\n\
getlocal {vTarget}\n\
callproperty QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster"), 1\n\
getproperty QName(PackageNamespace(""), "hpMax")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
findpropstrict QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster")\n\
getlocal {vTarget}\n\
callproperty QName(PackageNamespace("com.giab.games.gcfw.entity"), "Monster"), 1\n\
getproperty QName(PackageNamespace(""), "dmgDiv")\n\
divide\n\
callproperty QName(PackageNamespace(""), "min"), 2\n\
convert_d\n\
setlocal {vActualDamage}\n\
{jumpTarget4}:\n\
getlex QName(PackageNamespace(""), "Math")\n\
pushbyte 1\n\
getlocal {vActualDamage}\n\
callproperty QName(PackageNamespace(""), "max"), 2\n\
convert_d\n\
setlocal {vActualDamage}\n\
jump {jumpTarget5}\n\
{jumpTarget3}:\n\
getlocal {vTarget}\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.entity"), "Spire")\n\
istypelate\n\
iffalse {jumpTarget5}\n\
getlex QName(PackageNamespace(""), "Math")\n\
findpropstrict QName(PackageNamespace("com.giab.games.gcfw.entity"), "Spire")\n\
getlocal {vTarget}\n\
callproperty QName(PackageNamespace("com.giab.games.gcfw.entity"), "Spire"), 1\n\
getproperty QName(PackageNamespace(""), "dmgLim")\n\
getlocal {vActualDamage}\n\
callproperty QName(PackageNamespace(""), "min"), 2\n\
convert_d\n\
setlocal {vActualDamage}\n\
{jumpTarget5}:\
', main.getJumpTargets("jumpTarget1", "jumpTarget2", "jumpTarget3", "jumpTarget4", "jumpTarget5"));
			return main.format('\
getlocal {vTarget}\n\
getproperty Multiname("shield", {namespaces})\n\
getlocal {vTarget}\n\
getproperty Multiname("incomingShotsOnShield", {namespaces})\n\
ifngt {jumpTarget1}\n\
pushbyte 0\n\
convert_d\n\
setlocal {vActualDamage}\n\
getlocal {vTarget}\n\
getlocal {vTarget}\n\
getproperty Multiname("incomingShotsOnShield", {namespaces})\n\
increment\n\
setproperty Multiname("incomingShotsOnShield", {namespaces})\n\
jump {jumpTarget2}\n\
{jumpTarget1}:\n\
' + damageEstimation + '\n\
getlocal {vTarget}\n\
getlocal {vTarget}\n\
getproperty Multiname("incomingDamage", {namespaces})\n\
getlocal {vActualDamage}\n\
add\n\
setproperty Multiname("incomingDamage", {namespaces})\n\
{jumpTarget2}:\
', main.getJumpTargets("jumpTarget1", "jumpTarget2"));
		}
		
		private function getIncomingDamageDecrease(variableName:String) : String {
			return main.format('\
getlocal {variableName}\n\
getproperty QName(PackageNamespace(""), "estimatedDamage")\n\
pushbyte 0\n\
ifgt {jumpTarget1}\n\
getlocal {variableName}\n\
getproperty QName(PackageNamespace(""), "target")\n\
getlocal {variableName}\n\
getproperty QName(PackageNamespace(""), "target")\n\
getproperty Multiname("incomingShotsOnShield", {namespaces})\n\
decrement\n\
setproperty Multiname("incomingShotsOnShield", {namespaces})\n\
jump {jumpTarget2}\n\
{jumpTarget1}:\n\
getlocal {variableName}\n\
getproperty QName(PackageNamespace(""), "target")\n\
getlocal {variableName}\n\
getproperty QName(PackageNamespace(""), "target")\n\
getproperty Multiname("incomingDamage", {namespaces})\n\
getlocal {variableName}\n\
getproperty QName(PackageNamespace(""), "estimatedDamage")\n\
subtract\n\
setproperty Multiname("incomingDamage", {namespaces})\n\
{jumpTarget2}:\
'.replace(/variableName/g, variableName), main.getJumpTargets("jumpTarget1", "jumpTarget2"));
		}
		
		private function Tower(fileContents:String) : void {
			function doEnterFrame(functionContents:String) : void {
				result = new RegExp('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "target"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.entity"\\), "Monster"\\)\n\
istypelate\n\
iffalse (\\w+)\n\
.+\
\\1:\n\
', "s").exec(functionContents);
				main.applyPatch(result.index, result[0].length);
				regex = new RegExp('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "target"\\)\n\
getproperty Multiname\\("shield", [^\n]+\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "target"\\)\n\
getproperty Multiname\\("incomingShotsOnShield", [^\n]+\n\
ifngt (\\w+)\n\
.+\
jump (\\w+)\n\
\\1:\n\
.+\
\\2:\n\
', "gs");
				result = regex.exec(functionContents);
				main.applyPatch(result.index, result[0].length, getIncomingDamageIncrease());
				result = regex.exec(functionContents);
				main.applyPatch(result.index, result[0].length, getIncomingDamageIncrease(true));
				regex = new RegExp(main.format('\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ingameCreator"\\)\n\
getlocal0\n\
getlocal ?{vTarget}\n\
getlocal ?{vActualDamageRaw}\n\
'), "g");
				result = regex.exec(functionContents);
				while (result != null) {
					main.applyPatch(result.index + result[0].length, 0, main.format('\
getlocal {vActualDamage}\n\
newarray 2\
'));
					result = regex.exec(functionContents);
				}
			}
			main.modifyFunction('QName(PackageNamespace(""), "doEnterFrame")', doEnterFrame);
		}
		
		private function Pylon(fileContents:String) : void {
			function doEnterFrame(functionContents:String) : void {
				result = new RegExp('\
localcount (\\d+)\n\
').exec(functionContents);
				var vActualDamageRaw:String = result[1].toString();
				main.applyPatch(result.index, result[0].length, "localcount " + (int(vActualDamageRaw) + 1).toString());
				result = new RegExp('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "target"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.entity"\\), "Monster"\\)\n\
istypelate\n\
iffalse (\\w+)\n\
.+\
\\1:\n\
', "s").exec(functionContents);
				main.applyPatch(result.index, result[0].length, main.format('\
getlocal {vActualDamage}\n\
convert_d\n\
setlocal ' + vActualDamageRaw + '\n\
'));
				result = new RegExp('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "target"\\)\n\
getproperty Multiname\\("shield", [^\n]+\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "target"\\)\n\
getproperty Multiname\\("incomingShotsOnShield", [^\n]+\n\
ifngt (\\w+)\n\
.+\
jump (\\w+)\n\
\\1:\n\
.+\
\\2:\n\
', "s").exec(functionContents);
				main.applyPatch(result.index, result[0].length, getIncomingDamageIncrease(true));
				result = new RegExp(main.format('\
(getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ingameCreator"\\)\n\
getlocal0\n\
getlocal ?{vTarget}\n)\
(getlocal ?{vActualDamage}\n)\
')).exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, main.format('\
getlocal ' + vActualDamageRaw + '\n\
getlocal {vActualDamage}\n\
newarray 2\
'));
			}
			main.modifyFunction('QName(PackageNamespace(""), "doEnterFrame")', doEnterFrame);
		}
		
		private function IngameCreator(fileContents:String) : void {
			function createShot(functionContents:String) : void {
				result = new RegExp('\
param QName\\(PackageNamespace\\(""\\), "Number"\\)\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, 'param QName(PackageNamespace(""), "Array")');
			}
			main.modifyFunction('QName(PackageNamespace(""), "createTowerShot")', createShot);
			main.modifyFunction('QName(PackageNamespace(""), "createTowerBolt")', createShot);
			main.modifyFunction('QName(PackageNamespace(""), "createPylonShot")', createShot);
		}
		
		private function Shot(fileContents:String) : void {
			function iinit(functionContents:String) : void {
				result = new RegExp('\
param QName\\(PackageNamespace\\(""\\), "Number"\\)\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, 'param QName(PackageNamespace(""), "Array")');
				result = new RegExp(main.format('\
getlocal0\n\
getlocal ?{pDamage}\n\
initproperty QName\\(PackageNamespace\\(""\\), "damage"\\)\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length, main.format('\
getlocal0\n\
getlocal {pDamage}\n\
pushbyte 0\n\
getproperty MultinameL({namespaces})\n\
initproperty QName(PackageNamespace(""), "damage")\n\
getlocal0\n\
getlocal {pDamage}\n\
pushbyte 1\n\
getproperty MultinameL({namespaces})\n\
initproperty QName(PackageNamespace(""), "estimatedDamage")\
'));
			}
			main.modifyFunction('iinit', iinit);
			result = /^end ; instance/m.exec(fileContents);
			main.applyPatch(result.index, 0, 'trait slot QName(PackageNamespace(""), "estimatedDamage") type QName(PackageNamespace(""), "Number") end');
		}
		
		private function IngameController(fileContents:String) : void {
			function towerShotHitsTarget(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal ?{pShot}\n\
getproperty QName\\(PackageNamespace\\(""\\), "isTargetMarkableForDeath"\\)\n\
iffalse (\\w+)\n)\
(.+)\
\\2\n\
'), "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, getIncomingDamageDecrease("pShot"));
			}
			function boltHitsTarget(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal ?{pBolt}\n\
getproperty QName\\(PackageNamespace\\(""\\), "isTargetMarkableForDeath"\\)\n\
iffalse (\\w+)\n)\
(.+)\
\\2\n\
'), "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, getIncomingDamageDecrease("pBolt"));
			}
			function pylonShotHitsTarget(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal ?{pShot}\n\
getproperty QName\\(PackageNamespace\\(""\\), "isTargetMarkableForDeath"\\)\n\
iffalse (\\w+)\n)\
(.+)\
\\2\n\
'), "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, main.format('\
getlocal {pShot}\n\
getproperty QName(PackageNamespace(""), "targetsHitSoFar")\n\
pushbyte 0\n\
ifne {jumpTarget1}\n\
' + getIncomingDamageDecrease("pShot") + '\
', {jumpTarget1: result[2]}));
			}
			main.modifyFunction('QName(PackageNamespace(""), "towerShotHitsTarget")', towerShotHitsTarget);
			main.modifyFunction('QName(PackageNamespace(""), "boltHitsTarget")', boltHitsTarget);
			main.modifyFunction('QName(PackageNamespace(""), "pylonShotHitsTarget")', pylonShotHitsTarget);
		}
		
		private function Monster(fileContents:String) : void {
			function sufferShotDamage(functionContents:String) : void {
				result = new RegExp(main.format('\
getlocal ?{pDamage}\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "talismanDmgMult"\\)\n\
multiply\n\
convert_d\n\
setlocal ?{pDamage}\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length);
				var talismanDamage:String = result[0];
				result = new RegExp('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "dmgDiv"\\)\n\
pushbyte 0\n\
ifngt \\w+\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, talismanDamage + main.format('\
getlex QName(PackageNamespace(""), "Math")\n\
pushbyte 1\n\
getlocal {pDamage}\n\
callproperty QName(PackageNamespace(""), "max"), 2\n\
convert_d\n\
setlocal {pDamage}\
'));
			}
			main.modifyFunction('QName(PackageNamespace(""), "sufferShotDamage")', sufferShotDamage);
		}
		
		private function Spire(fileContents:String) : void {
			function sufferShotDamage(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
getlocal ?{pDamage}\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "dmgLim"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "min"\\), 2\n\
convert_d\n\
setlocal ?{pDamage}\n)\
debugline \\d+\n\
(getlocal ?{pDamage}\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "bleedingDamageMultBonus"\\)\n\
pushbyte 1\n\
add\n\
multiply\n\
convert_d\n\
setlocal ?{pDamage}\n)\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length, result[2] + result[1]);
			}
			main.modifyFunction('QName(PackageNamespace(""), "sufferShotDamage")', sufferShotDamage);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/Tower.class.asasm", Tower);
			main.modifyFile("com/giab/games/gcfw/entity/Pylon.class.asasm", Pylon);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameCreator.class.asasm", IngameCreator);
			main.modifyFile("com/giab/games/gcfw/entity/TowerShot.class.asasm", Shot);
			main.modifyFile("com/giab/games/gcfw/entity/TowerBolt.class.asasm", Shot);
			main.modifyFile("com/giab/games/gcfw/entity/PylonShot.class.asasm", Shot);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameController.class.asasm", IngameController);
			main.modifyFile("com/giab/games/gcfw/entity/Monster.class.asasm", Monster);
			main.modifyFile("com/giab/games/gcfw/entity/Spire.class.asasm", Spire);
		}
	}
}