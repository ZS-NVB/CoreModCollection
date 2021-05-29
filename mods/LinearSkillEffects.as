package mods {
	import Main;

	public class LinearSkillEffects {
		public const MOD_NAME:String = "LinearSkillEffects";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function LinearSkillEffects() {}
		
		private function PnlSkills(fileContents:String) : void {
			function getSkillEffectiveValue(functionContents:String) : void {
				result = main.regex('\
getlocal pLevel\n\
pushbyte 1\n\
ifnlt (\\w+)\n\
debugline \\d+\n\
pushbyte 0\n\
returnvalue\n\
\\1:\n\
').exec(functionContents);
				main.applyPatch(result.index + result[0].length, 0, '\
getlocal pSkillId\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"MANA_STREAM")\n\
equals\n\
dup\n\
iffalse jumpTarget1\n\
pop\n\
getlocal pId\n\
pushbyte 1\n\
equals\n\
jumpTarget1:\n\
dup\n\
iftrue jumpTarget2\n\
pop\n\
getlocal pSkillId\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"FUSION")\n\
equals\n\
jumpTarget2:\n\
dup\n\
iftrue jumpTarget3\n\
pop\n\
getlocal pSkillId\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"ORB_OF_PRESENCE")\n\
equals\n\
dup\n\
iffalse jumpTarget3\n\
pop\n\
getlocal pId\n\
pushbyte 0\n\
equals\n\
jumpTarget3:\n\
dup\n\
iftrue jumpTarget4\n\
pop\n\
getlocal pSkillId\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"FREEZE")\n\
equals\n\
dup\n\
iffalse jumpTarget4\n\
pop\n\
getlocal pId\n\
pushbyte 0\n\
equals\n\
jumpTarget4:\n\
dup\n\
iftrue jumpTarget5\n\
pop\n\
getlocal pSkillId\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"WHITEOUT")\n\
equals\n\
dup\n\
iffalse jumpTarget5\n\
pop\n\
getlocal pId\n\
pushbyte 0\n\
equals\n\
jumpTarget5:\n\
dup\n\
iftrue jumpTarget6\n\
pop\n\
getlocal pSkillId\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"ICESHARDS")\n\
equals\n\
dup\n\
iffalse jumpTarget6\n\
pop\n\
getlocal pId\n\
pushbyte 0\n\
equals\n\
jumpTarget6:\n\
dup\n\
iftrue jumpTarget7\n\
pop\n\
getlocal pSkillId\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"BOLT")\n\
equals\n\
dup\n\
iffalse jumpTarget7\n\
pop\n\
getlocal pId\n\
pushbyte 0\n\
equals\n\
jumpTarget7:\n\
dup\n\
iftrue jumpTarget8\n\
pop\n\
getlocal pSkillId\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"BEAM")\n\
equals\n\
dup\n\
iffalse jumpTarget8\n\
pop\n\
getlocal pId\n\
pushbyte 0\n\
equals\n\
jumpTarget8:\n\
dup\n\
iftrue jumpTarget9\n\
pop\n\
getlocal pSkillId\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"BARRAGE")\n\
equals\n\
dup\n\
iffalse jumpTarget9\n\
pop\n\
getlocal pId\n\
pushbyte 0\n\
equals\n\
jumpTarget9:\n\
dup\n\
iftrue jumpTarget10\n\
pop\n\
getlocal pSkillId\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"FURY")\n\
equals\n\
dup\n\
iffalse jumpTarget10\n\
pop\n\
getlocal pId\n\
pushbyte 1\n\
equals\n\
jumpTarget10:\n\
iffalse jumpTarget11\n\
pushbyte 1\n\
dup\n\
dup\n\
getlocal pLevel\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"skillEffectiveValuesPerLevel")\n\
getlocal pSkillId\n\
getproperty MultinameL()\n\
getlocal pId\n\
getproperty MultinameL()\n\
divide\n\
getlocal pId\n\
pushbyte 0\n\
ifne jumpTarget12\n\
pushbyte 75\n\
jump jumpTarget13\n\
jumpTarget12:\n\
pushbyte 15\n\
jumpTarget13:\n\
subtract\n\
divide\n\
add\n\
divide\n\
subtract\n\
returnvalue\n\
jumpTarget11:\
', main.getJumpTargets("jumpTarget1", "jumpTarget2", "jumpTarget3", "jumpTarget4", "jumpTarget5", "jumpTarget6", "jumpTarget7", "jumpTarget8", "jumpTarget9", "jumpTarget10", "jumpTarget11", "jumpTarget12", "jumpTarget13"));
				main.requireMaxStack(7);
			}
			main.modifyFunction('QName(PackageNamespace(""),"getSkillEffectiveValue")', getSkillEffectiveValue);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
		}
	}
}