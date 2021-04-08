package mods {
	import Main;

	public class BetterCritChance {
		public const MOD_NAME:String = "BetterCritChance";
		public const COREMOD_VERSION:String = "2";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function BetterCritChance() {}
		
		private function Gem(fileContents:String) : void {
			function calculateRealValues(functionContents:String) : void {
				result = new RegExp('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "isInLantern"\\)\n\
iffalse (\\w+)\n\
.+\
jump (\\w+)\n\
\\1:\n\
.+\
\\2:\n\
', "s").exec(functionContents);
				main.applyPatch(result.index, result[0].length, main.format('\
getlocal {pSd}\n\
getproperty QName(PackageNamespace(""), "calcCritChance")\n\
pushbyte 1\n\
dup\n\
pushdouble 0.889\n\
getlocal {pSd}\n\
getproperty QName(PackageNamespace(""), "critHitChance")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
divide\n\
add\n\
divide\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\
'));
			}
			function updateShotDataEnhancedOrTrapOrLantern(functionContents:String) : void {
				result = new RegExp(main.format('\
getlocal ?{vSd}\n\
getproperty QName\\(PackageNamespace\\(""\\), "critHitMultiplier"\\)\n\
')).exec(functionContents);
				main.applyPatch(result.index, 0, main.format('\
getlocal {vSd}\n\
getproperty QName(PackageNamespace(""), "critHitChance")\n\
getlocal {vSd}\n\
getproperty QName(PackageNamespace(""), "critHitChance")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
getlocal {vSpecMult}\n\
multiply\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\
'));
			}
			main.modifyFunction('QName(PackageNamespace(""), "calculateRealValues")', calculateRealValues);
			main.modifyFunction('QName(PrivateNamespace("com.giab.games.gcfw.entity:Gem"), "updateShotDataEnhancedOrTrapOrLantern")', updateShotDataEnhancedOrTrapOrLantern);
		}
		
		private function IngameCalculator(fileContents:String) : void {
			function amplifyGem(functionContents:String) : void {
				result = new RegExp(main.format('\
(getlocal ?{pGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd3x_AmpModsOnly"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "critHitChance"\\)\n)\
(pushbyte 0\n)\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
')).exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, main.format('\
getlocal {pGem}\n\
getproperty QName(PackageNamespace(""), "sd3x_AmpModsOnly")\n\
getproperty QName(PackageNamespace(""), "critHitChance")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
getlocal {vSd}\n\
getproperty QName(PackageNamespace(""), "critHitChance")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
getlocal {vPowerSpec}\n\
multiply\n\
add\
'));
			}
			main.modifyFunction('QName(PackageNamespace(""), "amplifyGem")', amplifyGem);
		}
		
		private function ShotData(fileContents:String) : void {
			function clone(functionContents:String) : void {
				result = new RegExp(main.format('\
getlocal ?{vRetVal}\n\
getproperty QName\\(PackageNamespace\\(""\\), "critHitChance"\\)\n\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "critHitChance"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
')).exec(functionContents);
				main.applyPatch(result.index + result[0].length, 0, main.format('\
getlocal {vRetVal}\n\
getproperty QName(PackageNamespace(""), "calcCritChance")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "calcCritChance")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
callpropvoid QName(PackageNamespace(""), "s"), 1\
'));
			}
			main.modifyFunction('QName(PackageNamespace(""), "clone")', clone);
		}
		
		private function GemWasp(fileContents:String) : void {
			function iinit(functionContents:String) : void {
				result = new RegExp(main.format('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "shotData"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "calcCritChance"\\)\n\
getlocal ?{pGem}\n\
getproperty QName\\(PackageNamespace\\(""\\), "sd2_CompNumMod"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "critHitChance"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "s"\\), 1\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length);
			}
			main.modifyFunction('iinit', iinit);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/Gem.class.asasm", Gem);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameCalculator.class.asasm", IngameCalculator);
			main.modifyFile("com/giab/games/gcfw/struct/ShotData.class.asasm", ShotData);
			main.modifyFile("com/giab/games/gcfw/entity/GemWasp.class.asasm", GemWasp);
		}
	}
}