package mods {
	import Main;

	public class FreezeCritDamageFix {
		public const MOD_NAME:String = "FreezeCritDamageFix";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function FreezeCritDamageFix() {}
		
		private function Tower(fileContents:String) : void {
			function doEnterFrame(functionContents:String) : void {
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "insertedGem"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd4_IntensityMod"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "calcCritChance"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "random"\\), 0\n\
ifngt (\\w+)\n)\
(.+)\
\\2:\
', "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, main.format('\
getlocal {vActualDamage}\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "insertedGem")\n\
getproperty QName(PackageNamespace(""), "sd4_IntensityMod")\n\
getproperty QName(PackageNamespace(""), "critHitMultiplier")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vActualDamage}\n\
getlocal {vTarget}\n\
getproperty Multiname("isFrozen", {namespaces})\n\
iffalse {jumpTarget1}\n\
getlocal {vActualDamage}\n\
pushbyte 1\n\
pushdouble 0.01\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "spFreezeCritHitDmgBoostPct")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
multiply\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vActualDamage}\
', {jumpTarget1: result[2]}));
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "insertedGem"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "calcCritChance"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "random"\\), 0\n\
ifngt (\\w+)\n)\
(.+)\
\\2:\
', "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, main.format('\
getlocal {vActualDamage}\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "insertedGem")\n\
getproperty QName(PackageNamespace(""), "sd5_EnhancedOrTrapOrLantern")\n\
getproperty QName(PackageNamespace(""), "critHitMultiplier")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vActualDamage}\n\
getlocal {vTarget}\n\
getproperty Multiname("isFrozen", {namespaces})\n\
iffalse {jumpTarget1}\n\
getlocal {vActualDamage}\n\
pushbyte 1\n\
pushdouble 0.01\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "spFreezeCritHitDmgBoostPct")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
multiply\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vActualDamage}\
', {jumpTarget1: result[2]}));
			}
			main.modifyFunction('QName(PackageNamespace(""), "doEnterFrame")', doEnterFrame);
		}
		
		private function IngameCreator(fileContents:String) : void {
			function createBeam(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal ?{pTower}\n\
getproperty QName\\(PackageNamespace\\(""\\), "insertedGem"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "calcCritChance"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "random"\\), 0\n\
ifngt (\\w+)\n)\
(.+)\
\\2:\
'), "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, main.format('\
getlocal {vDmg}\n\
pushbyte 1\n\
getlocal {pTower}\n\
getproperty QName(PackageNamespace(""), "insertedGem")\n\
getproperty QName(PackageNamespace(""), "sd5_EnhancedOrTrapOrLantern")\n\
getproperty QName(PackageNamespace(""), "critHitMultiplier")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vDmg}\n\
getlocal {pTarget}\n\
getproperty Multiname("isFrozen", {namespaces})\n\
iffalse {jumpTarget1}\n\
getlocal {vDmg}\n\
pushbyte 1\n\
pushdouble 0.01\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "spFreezeCritHitDmgBoostPct")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
multiply\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vDmg}\
', {jumpTarget1: result[2]}));
			}
			main.modifyFunction('QName(PackageNamespace(""), "createBeam")', createBeam);
		}
		
		private function IngameController(fileContents:String) : void {
			function barrageShellExplodes(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
getlocal ?{pShell}\n\
getproperty QName\\(PackageNamespace\\(""\\), "shotData"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "damageMin"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "random"\\), 0\n\
getlocal ?{pShell}\n\
getproperty QName\\(PackageNamespace\\(""\\), "shotData"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "damageMax"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlocal ?{pShell}\n\
getproperty QName\\(PackageNamespace\\(""\\), "shotData"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "damageMin"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
subtract\n\
multiply\n\
add\n\
callproperty QName\\(PackageNamespace\\(""\\), "round"\\), 1\n\
convert_d\n\
setlocal ?{vDmg}\n)\
debugline \\d+\n\
getlocal ?{pShell}\n\
getproperty QName\\(PackageNamespace\\(""\\), "shotData"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "calcCritChance"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "random"\\), 0\n\
ifngt (\\w+)\n\
.+\
\\2:\
'), "s").exec(functionContents);
				main.applyPatch(result.index, result[0].length);
				regex = new RegExp(main.format('\
getlocal ?(\\d+)\n\
getlocal ?{pShell}\n\
getproperty QName\\(PackageNamespace\\(""\\), "shotData"\\)\n\
getlocal ?{pShell}\n\
getproperty QName\\(PackageNamespace\\(""\\), "originGem"\\)\n\
pushfalse\n\
getlocal ?{vDmg}\n\
pushfalse\n\
callpropvoid .+"sufferShotDamage".+\n\
'), "g");
				var randomDamage:String = result[1];
				result = regex.exec(functionContents);
				while (result != null) {
					main.applyPatch(result.index, 0, randomDamage + main.format('\
getlocal {pShell}\n\
getproperty QName(PackageNamespace(""), "shotData")\n\
getproperty QName(PackageNamespace(""), "calcCritChance")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
getlex QName(PackageNamespace(""), "Math")\n\
callproperty QName(PackageNamespace(""), "random"), 0\n\
ifngt {jumpTarget1}\n\
getlocal {vDmg}\n\
pushbyte 1\n\
getlocal {pShell}\n\
getproperty QName(PackageNamespace(""), "shotData")\n\
getproperty QName(PackageNamespace(""), "critHitMultiplier")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vDmg}\n\
getlocal ' + result[1] + '\n\
getproperty QName(PackageNamespace(""), "isFrozen")\n\
iffalse {jumpTarget1}\n\
getlocal {vDmg}\n\
pushbyte 1\n\
pushdouble 0.01\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "spFreezeCritHitDmgBoostPct")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
multiply\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vDmg}\n\
{jumpTarget1}:\
', main.getJumpTargets("jumpTarget1")));
					result = regex.exec(functionContents);
				}
			}
			main.modifyFunction('QName(PackageNamespace(""), "barrageShellExplodes")', barrageShellExplodes);
		}
		
		private function Trap(fileContents:String) : void {
			function doEnterFrame(functionContents:String) : void {
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "insertedGem"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "calcCritChance"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "random"\\), 0\n\
ifngt (\\w+)\n)\
(.+)\
\\2:\
', "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, main.format('\
getlocal {vDmg}\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "insertedGem")\n\
getproperty QName(PackageNamespace(""), "sd5_EnhancedOrTrapOrLantern")\n\
getproperty QName(PackageNamespace(""), "critHitMultiplier")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vDmg}\n\
getlocal {vM}\n\
getproperty Multiname("isFrozen", {namespaces})\n\
iffalse {jumpTarget1}\n\
getlocal {vDmg}\n\
pushbyte 1\n\
pushdouble 0.01\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "spFreezeCritHitDmgBoostPct")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
multiply\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vDmg}\
', {jumpTarget1: result[2]}));
			}
			main.modifyFunction('QName(PackageNamespace(""), "doEnterFrame")', doEnterFrame);
		}
		
		private function Lantern(fileContents:String) : void {
			function doEnterFrame(functionContents:String) : void {
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "insertedGem"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd5_EnhancedOrTrapOrLantern"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "calcCritChance"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "random"\\), 0\n\
ifngt (\\w+)\n)\
(.+)\
\\2:\
', "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, main.format('\
getlocal {vCritMult}\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "insertedGem")\n\
getproperty QName(PackageNamespace(""), "sd5_EnhancedOrTrapOrLantern")\n\
getproperty QName(PackageNamespace(""), "critHitMultiplier")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vCritMult}\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "targets")\n\
getlocal {i}\n\
getproperty MultinameL({namespaces})\n\
getproperty Multiname("isFrozen", {namespaces})\n\
iffalse {jumpTarget1}\n\
getlocal {vCritMult}\n\
pushbyte 1\n\
pushdouble 0.01\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "spFreezeCritHitDmgBoostPct")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
multiply\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vCritMult}\
', {jumpTarget1: result[2]}));
			}
			main.modifyFunction('QName(PackageNamespace(""), "doEnterFrame")', doEnterFrame);
		}
		
		private function IngameSpellCaster(fileContents:String) : void {
			function castGemBomb(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal ?{vBombShotData}\n\
getproperty QName\\(PackageNamespace\\(""\\), "damageMax"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlocal ?{vTargetsToHit}\n\
getproperty QName\\(PackageNamespace\\(""\\), "length"\\)\n\
divide\n\
convert_d\n\
setlocal ?{vDamagePerMonster}\n\
debugline \\d+\n\
getlocal ?{vBombShotData}\n\
getproperty QName\\(PackageNamespace\\(""\\), "calcCritChance"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "random"\\), 0\n\
ifngt (\\w+)\n)\
.+\
\\2:\n\
'), "s").exec(functionContents);
				main.applyPatch(result.index, result[0].length);
				var damage:String = result[1] + main.format('\
getlocal {vDamagePerMonster}\n\
pushbyte 1\n\
getlocal {vBombShotData}\n\
getproperty QName(PackageNamespace(""), "critHitMultiplier")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vDamagePerMonster}\n\
getlocal {vTargetsToHit}\n\
getlocal {i}\n\
getproperty MultinameL({namespaces})\n\
getproperty Multiname("isFrozen", {namespaces})\n\
iffalse {jumpTarget1}\n\
getlocal {vDamagePerMonster}\n\
pushbyte 1\n\
pushdouble 0.01\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "spFreezeCritHitDmgBoostPct")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
multiply\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vDamagePerMonster}\n\
', {jumpTarget1: result[2]}) + result[2] + ':';
				result = new RegExp(main.format('\
getlocal ?{vTargetsToHit}\n\
getlocal ?{i}\n\
getproperty MultinameL[^\n]+\n\
getlocal ?{vBombShotData}\n\
pushnull\n\
pushfalse\n\
getlocal ?{vDamagePerMonster}\n\
pushfalse\n\
callpropvoid Multiname\\("sufferShotDamage", [^\n]+\n\
')).exec(functionContents);
				main.applyPatch(result.index, 0, damage);
			}
			main.modifyFunction('QName(PackageNamespace(""), "castGemBomb")', castGemBomb);
		}
		
		private function GemWasp(fileContents:String) : void {
			function attack(functionContents:String) : void {
				result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "shotData"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "calcCritChance"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlex QName\\(PackageNamespace\\(""\\), "Math"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "random"\\), 0\n\
ifngt (\\w+)\n)\
(.+)\
\\2:\
', "s").exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[3].length, main.format('\
getlocal {vDmg}\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "shotData")\n\
getproperty QName(PackageNamespace(""), "critHitMultiplier")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vDmg}\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "target")\n\
getproperty Multiname("isFrozen", {namespaces})\n\
iffalse {jumpTarget1}\n\
getlocal {vDmg}\n\
pushbyte 1\n\
pushdouble 0.01\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "spFreezeCritHitDmgBoostPct")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
multiply\n\
add\n\
multiply\n\
convert_d\n\
setlocal {vDmg}\
', {jumpTarget1: result[2]}));
			}
			main.modifyFunction('QName(PrivateNamespace("com.giab.games.gcfw.entity:GemWasp"), "attack")', attack);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/Tower.class.asasm", Tower);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameCreator.class.asasm", IngameCreator);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameController.class.asasm", IngameController);
			main.modifyFile("com/giab/games/gcfw/entity/Trap.class.asasm", Trap);
			main.modifyFile("com/giab/games/gcfw/entity/Lantern.class.asasm", Lantern);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameSpellCaster.class.asasm", IngameSpellCaster);
			main.modifyFile("com/giab/games/gcfw/entity/GemWasp.class.asasm", GemWasp);
		}
	}
}