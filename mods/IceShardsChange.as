package mods {
	import Main;
	
	public class IceShardsChange {
		public const MOD_NAME:String = "IceShardsChange";
		public const COREMOD_VERSION:String = "2";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function IceShardsChange() {}
		
		private function StrikeSpell(fileContents:String) : void {
			function iinit(functionContents:String) : void {
				result = main.regex('\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
pushtrue\n\
setproperty Multiname("isAfterIceshards")\n\
').exec(functionContents);
				main.applyPatch(result.index + result[0].length, 0, '\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.entity"),"Monster")\n\
istypelate\n\
not\n\
dup\n\
iffalse jumpTarget1\n\
pop\n\
pushstring "timesIceSharded"\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
in\n\
jumpTarget1:\n\
iffalse jumpTarget2\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getproperty Multiname("timesIceSharded")\n\
increment_i\n\
setproperty Multiname("timesIceSharded")\n\
jumpTarget2:\
', main.getJumpTargets("jumpTarget1", "jumpTarget2"));
				result = main.regex('\
(getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getproperty Multiname("hp")\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getproperty Multiname("hp")\n\
callproperty Multiname("g"), 0\n)\
(pushbyte 100\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"ingameCore")\n\
getproperty QName(PackageNamespace(""),"spIsHpShredPct")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
subtract\n\
multiply\n\
pushbyte 100\n\
divide\n)\
callpropvoid Multiname("s"), 1\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, '\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getproperty Multiname("hpMax")\n\
callproperty Multiname("g"), 0\n\
pushbyte 100\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"ingameCore")\n\
getproperty QName(PackageNamespace(""),"spIsHpShredPct")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
divide\n\
pushstring "timesIceSharded"\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
in\n\
iffalse jumpTarget1\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getproperty Multiname("timesIceSharded")\n\
pushbyte 1\n\
subtract\n\
jump jumpTarget2\n\
jumpTarget1:\n\
pushbyte 0\n\
jumpTarget2:\n\
add\n\
divide\n\
subtract\n\
', main.getJumpTargets("jumpTarget1", "jumpTarget2"));
				main.applyPatch(result.index + result[0].length, 0, '\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getproperty Multiname("hpMax")\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getproperty Multiname("hpMax")\n\
callproperty Multiname("g"), 0\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getproperty Multiname("hpMax")\n\
callproperty Multiname("g"), 0\n\
pushbyte 100\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"ingameCore")\n\
getproperty QName(PackageNamespace(""),"spIsHpShredPct")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
divide\n\
pushstring "timesIceSharded"\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
in\n\
iffalse jumpTarget1\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getproperty Multiname("timesIceSharded")\n\
pushbyte 1\n\
subtract\n\
jump jumpTarget2\n\
jumpTarget1:\n\
pushbyte 0\n\
jumpTarget2:\n\
add\n\
divide\n\
subtract\n\
callpropvoid Multiname("s"), 1\
', main.getJumpTargets("jumpTarget1", "jumpTarget2"));
			}
			main.modifyFunction('iinit', iinit);
		}
		
		private function NonMonster(fileContents:String) : void {
			function iinit(functionContents:String) : void {
				result = /^returnvoid$/m.exec(functionContents);
				main.applyPatch(result.index, 0, '\
getlocal0\n\
pushbyte 0\n\
initproperty QName(PackageNamespace(""),"timesIceSharded")\
');
			}
			main.modifyFunction('iinit', iinit);
			result = /^end ; instance$/m.exec(fileContents);
			main.applyPatch(result.index, 0, 'trait slot QName(PackageNamespace(""),"timesIceSharded") type QName(PackageNamespace(""),"int") end');
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/StrikeSpell.class.asasm", StrikeSpell);
			main.modifyFile("com/giab/games/gcfw/entity/Apparition.class.asasm", NonMonster);
			main.modifyFile("com/giab/games/gcfw/entity/GateKeeper.class.asasm", NonMonster);
			main.modifyFile("com/giab/games/gcfw/entity/GateKeeperFang.class.asasm", NonMonster);
			main.modifyFile("com/giab/games/gcfw/entity/Guardian.class.asasm", NonMonster);
			main.modifyFile("com/giab/games/gcfw/entity/Shadow.class.asasm", NonMonster);
			main.modifyFile("com/giab/games/gcfw/entity/Specter.class.asasm", NonMonster);
			main.modifyFile("com/giab/games/gcfw/entity/Spire.class.asasm", NonMonster);
			main.modifyFile("com/giab/games/gcfw/entity/SwarmQueen.class.asasm", NonMonster);
			main.modifyFile("com/giab/games/gcfw/entity/WallBreaker.class.asasm", NonMonster);
			main.modifyFile("com/giab/games/gcfw/entity/WizardHunter.class.asasm", NonMonster);
			main.modifyFile("com/giab/games/gcfw/entity/Wraith.class.asasm", NonMonster);
		}
	}
}