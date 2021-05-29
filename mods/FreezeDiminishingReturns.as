package mods {
	import Main;

	public class FreezeDiminishingReturns {
		public const MOD_NAME:String = "FreezeDiminishingReturns";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function FreezeDiminishingReturns() {}
		
		private function StrikeSpell(fileContents:String) : void {
			function iinit(functionContents:String) : void {
				result = main.regex('\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
pushtrue\n\
setproperty Multiname("isFrozen")\n\
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
pushstring "timesFrozen"\n\
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
getproperty Multiname("timesFrozen")\n\
increment_i\n\
setproperty Multiname("timesFrozen")\n\
jumpTarget2:\
', main.getJumpTargets("jumpTarget1", "jumpTarget2"));
				regex = main.regex('\
add\n\
setproperty Multiname("freezeTimeLeft")\n\
', "g");
				result = regex.exec(functionContents);
				while (result) {
					main.applyPatch(result.index, 0, '\
pushstring "timesFrozen"\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
in\n\
iffalse jumpTarget1\n\
getlex QName(PackageNamespace(""),"Math")\n\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getproperty Multiname("timesFrozen")\n\
callproperty QName(PackageNamespace(""),"sqrt"), 1\n\
jump jumpTarget2\n\
jumpTarget1:\n\
pushbyte 1\n\
jumpTarget2:\n\
divide\
', main.getJumpTargets("jumpTarget1", "jumpTarget2"));
					result = regex.exec(functionContents);
				}
			}
			main.modifyFunction('iinit', iinit);
		}
		
		private function NonMonster(fileContents:String) : void {
			function iinit(functionContents:String) : void {
				result = /^returnvoid$/m.exec(functionContents);
				main.applyPatch(result.index, 0, '\
getlocal0\n\
pushbyte 0\n\
initproperty QName(PackageNamespace(""),"timesFrozen")\
');
			}
			main.modifyFunction('iinit', iinit);
			result = /^end ; instance$/m.exec(fileContents);
			main.applyPatch(result.index, 0, 'trait slot QName(PackageNamespace(""),"timesFrozen") type QName(PackageNamespace(""),"int") end');
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