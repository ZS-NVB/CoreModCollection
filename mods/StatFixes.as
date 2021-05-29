package mods {
	import Main;
	
	public class StatFixes {
		public const MOD_NAME:String = "StatFixes";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function StatFixes() {}
		
		private function StrikeSpell(fileContents:String) : void {
			function iinit(functionContents:String) : void {
				result = main.regex('\
callpropvoid Multiname("sufferRawDamage"), 3\n\
').exec(functionContents);
				main.applyPatch(result.index + result[0].length, 0, '\
getlocal vMonstersHit\n\
getlocal i\n\
getproperty MultinameL()\n\
getproperty Multiname("isDestroyed")\n\
iffalse jumpTarget1\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"ingameStats")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"ingameStats")\n\
getproperty QName(PackageNamespace(""),"killsByIceShards")\n\
pushbyte 1\n\
add\n\
setproperty QName(PackageNamespace(""),"killsByIceShards")\n\
jumpTarget1:\
', main.getJumpTargets("jumpTarget1"));
			}
			main.modifyFunction('iinit', iinit);
		}
		
		private function PnlStats(fileContents:String) : void {
			function populateData(functionContents:String) : void {
				result = main.regex('\
pushbyte 71\n\
pushbyte 85\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushbyte 85\n\
pushbyte 71\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"populateData")', populateData);
		}
		
		private function IngameEnding(fileContents:String) : void {
			function renderInfoKills(functionContents:String) : void {
				result = main.regex('\
getlocal0\n\
getproperty QName(PackageNamespace(""),"stats")\n\
getproperty QName(PackageNamespace(""),"killsByExplodingFrozenMonster")\n\
pushdouble 0.5\n\
ifngt (\\w+)\n\
.+?\n\
\\1:\n\
', "s").exec(functionContents);
				main.applyPatch(result.index + result[0].length, 0, '\
getlocal0\n\
getproperty QName(PackageNamespace(""),"stats")\n\
getproperty QName(PackageNamespace(""),"killsByIceShards")\n\
pushdouble 0.5\n\
ifngt jumpTarget1\n\
getlocal vIp\n\
getlex QName(PackageNamespace(""),"C_DATAROW")\n\
pushstring "Ice shards: "\n\
getlex QName(PackageNamespace("com.giab.common.utils"),"NumberFormatter")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"stats")\n\
getproperty QName(PackageNamespace(""),"killsByIceShards")\n\
callproperty QName(PackageNamespace(""),"format"), 1\n\
add\n\
pushtrue\n\
pushbyte 12\n\
pushnull\n\
pushint 16777215\n\
callpropvoid QName(PackageNamespace(""),"addTextfield"), 6\n\
jumpTarget1:\
', main.getJumpTargets("jumpTarget1"));
			}
			main.modifyFunction('QName(PackageNamespace(""),"renderInfoKills")', renderInfoKills);
		}
		
		private function IngameInfoPanelRenderer(fileContents:String) : void {
			function renderInfoPanel(functionContents:String) : void {
				result = main.regex('\
pushstring "Engared waves: "\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushstring "Enraged waves: "\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"renderInfoPanel")', renderInfoPanel);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/StrikeSpell.class.asasm", StrikeSpell);
			main.modifyFile("com/giab/games/gcfw/selector/PnlStats.class.asasm", PnlStats);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameEnding.class.asasm", IngameEnding);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInfoPanelRenderer.class.asasm", IngameInfoPanelRenderer);
		}
	}
}