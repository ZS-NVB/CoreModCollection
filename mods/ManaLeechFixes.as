package mods {
	import Main;

	public class ManaLeechFixes {
		public const MOD_NAME:String = "ManaLeechFixes";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function ManaLeechFixes() {}
		
		private function fixLeech(functionContents:String) : void {
			result = new RegExp('\
(getproperty QName\\(PackageNamespace\\(""\\), "manaFromManaGainGems"\\)\n)\
((?:getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n|\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ingameCore"\\)\n)\
getlocal ?(\\d+)\n\
pushtrue\n\
pushfalse\n\
callproperty QName\\(PackageNamespace\\(""\\), "changeMana"\\), 3\n)\
add\n\
setproperty QName\\(PackageNamespace\\(""\\), "manaFromManaGainGems"\\)\n\
').exec(functionContents);
			var changeMana:String = result[2];
			var manaGain:String = result[3];
			main.applyPatch(result.index + result[1].length, changeMana.length, "getlocal " + manaGain);
			result = new RegExp(main.format('\
convert_d\n\
setlocal ?' + manaGain +'\n\
')).exec(functionContents);
			main.applyPatch(result.index + result[0].length, 0, changeMana + result[0]);
			regex = new RegExp('\
(getproperty QName\\(PackageNamespace\\(""\\), "manaLeeched"\\)\n\
pushshort \\d+\n\
ifngt (\\w+)\n\
.+)\
(jump (\\w+)\n)\
\\2:\n\
', "gs");
			result = regex.exec(functionContents);
			var jumpTarget:String = result[4];
			while (result != null) {
				main.applyPatch(result.index + result[1].length, result[3].length);
				result = regex.exec(functionContents);
			}
			result = new RegExp('\
getproperty QName\\(PackageNamespace\\(""\\), "manaLeeched"\\)\n\
pushshort 899\n\
greaterthan\n\
\\w+:\n\
(iffalse (\\w+)\n)\
').exec(functionContents);
			if (jumpTarget != result[2]) {
				main.applyPatch(result.index + result[0].length, -result[1].length, "iffalse " + jumpTarget);
			}
			result = new RegExp('\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ingameStatus"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.constants"\\), "IngameStatus"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "PLAYING"\\)\n\
ifne (\\w+)\n\
.+?\
iftrue (\\w+)\n\
pop\n\
(.+?)\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw.entity"\\), "[^"]+"\\)\n\
istypelate\n\
\\3:)\n\
iffalse \\2\n\
(.+?\
\\2:\n)\
', "s").exec(functionContents);
			if (result) {
				var patch:String = "";
				var creatures:Array = ["Spire", "SwarmQueen", "GateKeeper", "GateKeeperFang"];
				for (var i:* in creatures) {
					patch += main.format('\
dup\n\
iftrue {jumpTarget1}\n\
pop\n\
' + result[4] + '\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.entity"), "' + creatures[i] + '")\n\
istypelate\n\
{jumpTarget1}:\n\
', main.getJumpTargets("jumpTarget1"));
				}
				main.applyPatch(result.index + result[1].length, 0, patch);
				main.applyPatch(result.index + result[0].length - result[5].length, 0, result[4] + main.format('\
getproperty Multiname("isDestroyed", {namespaces})\n\
iftrue ' + result[2]));
			}
		}
		
		private function IngameController(functionContents:String) : void {
			main.modifyFunction('QName(PackageNamespace(""), "towerShotHitsTarget")', fixLeech);
			main.modifyFunction('QName(PackageNamespace(""), "boltHitsTarget")', fixLeech);
		}
		
		private function IngameCreator(functionContents:String) : void {
			main.modifyFunction('QName(PackageNamespace(""), "createBeam")', fixLeech);
		}
		
		private function Trap(functionContents:String) : void {
			main.modifyFunction('QName(PackageNamespace(""), "doEnterFrame")', fixLeech);
		}
		
		private function Lantern(functionContents:String) : void {
			main.modifyFunction('QName(PackageNamespace(""), "doEnterFrame")', fixLeech);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameController.class.asasm", IngameController);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameCreator.class.asasm", IngameCreator);
			main.modifyFile("com/giab/games/gcfw/entity/Trap.class.asasm", Trap);
			main.modifyFile("com/giab/games/gcfw/entity/Lantern.class.asasm", Lantern);
		}
	}
}