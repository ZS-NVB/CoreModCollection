package mods {
	import Main;

	public class BetterGemBombs {
		public const MOD_NAME:String = "BetterGemBombs";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function BetterGemBombs() {}
		
		private function ShotData(fileContents:String) : void {
			function iinit(functionContents:String) : void {
				result = main.regex('\
returnvoid\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, '\
getlocal0\n\
pushfalse\n\
initproperty QName(PackageNamespace(""),"isFromGemBomb")\n\
getlocal0\n\
pushbyte 1\n\
initproperty QName(PackageNamespace(""),"targetsHit")\
');
			}
			function clone(functionContents:String) : void {
				result = main.regex('\
getlocal vRetVal\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"isFromGemBomb")\n\
setproperty QName(PackageNamespace(""),"isFromGemBomb")\n\
').exec(functionContents);
				main.applyPatch(result.index + result[0].length, 0, '\
getlocal vRetVal\n\
getlocal 0\n\
getproperty QName(PackageNamespace(""),"targetsHit")\n\
setproperty QName(PackageNamespace(""),"targetsHit")\
')
			}
			main.modifyFunction('iinit', iinit);
			main.modifyFunction('QName(PackageNamespace(""),"clone")', clone);
			result = /^end ; instance$/m.exec(fileContents);
			main.applyPatch(result.index, 0, 'trait slot QName(PackageNamespace(""),"targetsHit") type QName(PackageNamespace(""),"Number") end');
		}
		
		private function IngameSpellCaster(fileContents:String) : void {
			function castGemBomb(functionContents:String) : void {
				result = main.regex('\
(getlocal vBombShotData\n\
getproperty QName(PackageNamespace(""),"damageMax")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n)\
(getlocal vTargetsToHit\n\
getproperty QName(PackageNamespace(""),"length")\n\
divide\n)\
convert_d\n\
setlocal vDamagePerMonster\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length);
				main.applyPatch(result.index + result[0].length, 0, '\
getlocal vBombShotData\n\
getlocal vTargetsToHit\n\
getproperty QName(PackageNamespace(""),"length")\n\
setproperty QName(PackageNamespace(""),"targetsHit")\n\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"castGemBomb")', castGemBomb);
		}
		
		private function Monster(fileContents:String) : void {
			function sufferShotDamage(functionContents:String) : void {
				result = main.regex('\
getlocal0\n\
getproperty QName(PackageNamespace(""),"dmgDiv")\n\
pushbyte 0\n\
ifngt \\w+\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, '\
getlocal pShotData\n\
getproperty QName(PackageNamespace(""),"isFromGemBomb")\n\
iffalse jumpTarget1\n\
getlex QName(PackageNamespace(""),"Math")\n\
getlocal pDamage\n\
getlocal pShotData\n\
getproperty QName(PackageNamespace(""),"targetsHit")\n\
divide\n\
pushbyte 1\n\
callproperty QName(PackageNamespace(""),"max"), 2\n\
convert_d\n\
setlocal pDamage\n\
jumpTarget1:\
', main.getJumpTargets("jumpTarget1"));
			}
			main.modifyFunction('QName(PackageNamespace(""),"sufferShotDamage")', sufferShotDamage);
		}
		
		private function Spire(fileContents:String) : void {
			function sufferShotDamage(functionContents:String) : void {
				result = main.regex('\
debugline \\d+\n\
getlex QName(PackageNamespace(""),"Math")\n\
getlocal pDamage\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"dmgLim")\n\
callproperty QName(PackageNamespace(""),"min"), 2\n\
convert_d\n\
setlocal pDamage\n\
debugline \\d+\n\
getlocal pDamage\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"bleedingDamageMultBonus")\n\
pushbyte 1\n\
add\n\
multiply\n\
convert_d\n\
setlocal pDamage\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, '\
getlocal pShotData\n\
getproperty QName(PackageNamespace(""),"isFromGemBomb")\n\
iffalse jumpTarget1\n\
getlocal pDamage\n\
getlocal pShotData\n\
getproperty QName(PackageNamespace(""),"targetsHit")\n\
divide\n\
convert_d\n\
setlocal pDamage\n\
jumpTarget1:\
', main.getJumpTargets("jumpTarget1"));
				main.applyPatch(result.index + result[0].length, 0, '\
getlex QName(PackageNamespace(""),"Math")\n\
pushbyte 1\n\
getlocal pDamage\n\
callproperty QName(PackageNamespace(""),"max"), 2\n\
convert_d\n\
setlocal pDamage\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"sufferShotDamage")', sufferShotDamage);
		}
		
		private function NonMonsterNonSpire(fileContents:String) : void {
			function sufferShotDamage(functionContents:String) : void {
				result = main.regex('\
getlocal pDamage\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"bleedingDamageMultBonus")\n\
pushbyte 1\n\
add\n\
multiply\n\
convert_d\n\
setlocal pDamage\n\
').exec(functionContents);
				main.applyPatch(result.index + result[0].length, 0, '\
getlocal pShotData\n\
getproperty QName(PackageNamespace(""),"isFromGemBomb")\n\
iffalse jumpTarget1\n\
getlex QName(PackageNamespace(""),"Math")\n\
getlocal pDamage\n\
getlocal pShotData\n\
getproperty QName(PackageNamespace(""),"targetsHit")\n\
divide\n\
pushbyte 1\n\
callproperty QName(PackageNamespace(""),"max"), 2\n\
convert_d\n\
setlocal pDamage\n\
jumpTarget1:\
', main.getJumpTargets("jumpTarget1"));
			}
			main.modifyFunction('QName(PackageNamespace(""),"sufferShotDamage")', sufferShotDamage);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/struct/ShotData.class.asasm", ShotData);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameSpellCaster.class.asasm", IngameSpellCaster);
			main.modifyFile("com/giab/games/gcfw/entity/Monster.class.asasm", Monster);
			main.modifyFile("com/giab/games/gcfw/entity/Spire.class.asasm", Spire);
			main.modifyFile("com/giab/games/gcfw/entity/Apparition.class.asasm", NonMonsterNonSpire);
			main.modifyFile("com/giab/games/gcfw/entity/GateKeeper.class.asasm", NonMonsterNonSpire);
			main.modifyFile("com/giab/games/gcfw/entity/GateKeeperFang.class.asasm", NonMonsterNonSpire);
			main.modifyFile("com/giab/games/gcfw/entity/Guardian.class.asasm", NonMonsterNonSpire);
			main.modifyFile("com/giab/games/gcfw/entity/Shadow.class.asasm", NonMonsterNonSpire);
			main.modifyFile("com/giab/games/gcfw/entity/Specter.class.asasm", NonMonsterNonSpire);
			main.modifyFile("com/giab/games/gcfw/entity/SwarmQueen.class.asasm", NonMonsterNonSpire);
			main.modifyFile("com/giab/games/gcfw/entity/WallBreaker.class.asasm", NonMonsterNonSpire);
			main.modifyFile("com/giab/games/gcfw/entity/WizardHunter.class.asasm", NonMonsterNonSpire);
			main.modifyFile("com/giab/games/gcfw/entity/Wraith.class.asasm", NonMonsterNonSpire);
		}
	}
}