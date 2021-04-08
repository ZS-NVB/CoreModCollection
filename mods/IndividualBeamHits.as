package mods {
	import Main;

	public class IndividualBeamHits {
		public const MOD_NAME:String = "IndividualBeamHits";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function IndividualBeamHits() {}
		
		private function Tower(fileContents:String) : void {
			function doEnterFrame(functionContents:String) : void {
				result = new RegExp('\
(getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ingameCreator"\\)\n\
getlocal0\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "target"\\)\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "createBeam"\\), 2\n)\
.+?\
(getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "insertedGem"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "e_ammoLeft"\\)\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "insertedGem"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "e_ammoLeft"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ingameCore"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "speedMultiplier"\\)\n\
subtract\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n)\
', "s").exec(functionContents);
				main.applyPatch(result.index, result[1].length);
				main.applyPatch(result.index + result[0].length, -result[2].length, main.format('\
getlocal0\n\
pushfalse\n\
initproperty QName(PackageNamespace(""), "isBeamCreated")\n\
pushbyte 0\n\
setlocal {i}\n\
{jumpTarget1}:\n\
label\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCreator")\n\
getlocal0\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "target")\n\
callpropvoid QName(PackageNamespace(""), "createBeam"), 2\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "insertedGem")\n\
getproperty QName(PackageNamespace(""), "e_ammoLeft")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "insertedGem")\n\
getproperty QName(PackageNamespace(""), "e_ammoLeft")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushbyte 1\n\
subtract\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\n\
inclocal_i {i}\n\
getlocal {i}\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ingameCore")\n\
getproperty QName(PackageNamespace(""), "speedMultiplier")\n\
lessthan\n\
not\n\
dup\n\
iftrue {jumpTarget2}\n\
pop\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "insertedGem")\n\
getproperty QName(PackageNamespace(""), "e_ammoLeft")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushbyte 1\n\
lessthan\n\
{jumpTarget2}:\n\
iftrue {jumpTarget3}\n\
getlocal0\n\
pushtrue\n\
callpropvoid QName(PackageNamespace(""), "acquireNewTarget"), 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "target")\n\
pushnull\n\
ifeq {jumpTarget3}\n\
jump {jumpTarget1}\n\
{jumpTarget3}:\n\
', main.getJumpTargets("jumpTarget1", "jumpTarget2", "jumpTarget3")));
			}
			main.modifyFunction('QName(PackageNamespace(""), "doEnterFrame")', doEnterFrame);
			result = /^end ; instance/m.exec(fileContents);
			main.applyPatch(result.index, 0, 'trait slot QName(PackageNamespace(""), "isBeamCreated") type QName(PackageNamespace(""), "Boolean") end');
		}
		
		private function IngameCreator(fileContents:String) : void {
			function createBeam(functionContents:String) : void {
				regex = new RegExp('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "speedMultiplier"\\)\n\
', "g");
				result = regex.exec(functionContents);
				while (result != null) {
					main.applyPatch(result.index, result[0].length, "pushbyte 1");
					result = regex.exec(functionContents);
				}
				result = new RegExp(main.format('\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ingameRenderer2"\\)\n\
getlocal ?{pTower}\n\
getlocal ?{pTarget}\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "renderBeam"\\), 2\n\
')).exec(functionContents);
				var jumpTargets:Object = main.getJumpTargets("jumpTarget1");
				main.applyPatch(result.index, 0, main.format('\
getlocal {pTower}\n\
getproperty QName(PackageNamespace(""), "isBeamCreated")\n\
iftrue {jumpTarget1}\
', jumpTargets));
				main.applyPatch(result.index + result[0].length, 0, main.format('\
getlocal {pTower}\n\
pushtrue\n\
setproperty QName(PackageNamespace(""), "isBeamCreated")\n\
{jumpTarget1}:\
', jumpTargets));
			}
			main.modifyFunction('QName(PackageNamespace(""), "createBeam")', createBeam);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/Tower.class.asasm", Tower);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameCreator.class.asasm", IngameCreator);
		}
	}
}