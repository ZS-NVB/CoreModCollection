package mods {
	import Main
	
	public class BleedingMultiplierDisplay {
		public const MOD_NAME:String = "BleedingMultiplierDisplay";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function BleedingMultiplierDisplay() {}
		
		private function IngameInfoPanelRenderer2(fileContents:String) : void {
			function renderInfoPanelGem(functionContents:String) : void {
				result = new RegExp(main.format('\
pushstring "Target takes "\n\
getlex QName\\(PackageNamespace\\("com.giab.common.utils"\\), "NumberFormatter"\\)\n\
getlocal ?{vSdf}\n\
getproperty QName\\(PackageNamespace\\(""\\), "bleedingIncDamageMultiplier"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
pushbyte 100\n\
multiply\n\
pushbyte 1\n\
callproperty QName\\(PackageNamespace\\(""\\), "format"\\), 2\n\
pushstring "% increased damage for "\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length, main.format('\
pushstring "Target takes x"\n\
getlex QName(PackageNamespace("com.giab.common.utils"), "NumberFormatter")\n\
pushbyte 1\n\
getlocal {vSdf}\n\
getproperty QName(PackageNamespace(""), "bleedingIncDamageMultiplier")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
add\n\
pushbyte 2\n\
callproperty QName(PackageNamespace(""),"format"), 2\n\
pushstring " increased damage for "\
'));
				result = new RegExp(main.format('\
getlex QName\\(PackageNamespace\\("com.giab.common.utils"\\), "NumberFormatter"\\)\n\
getlocal ?{vSda}\n\
getproperty QName\\(PackageNamespace\\(""\\), "bleedingIncDamageMultiplier"\\)\n\
callproperty QName\\(PackageNamespace\\(""\\), "g"\\), 0\n\
pushbyte 100\n\
multiply\n\
pushbyte 1\n\
callproperty QName\\(PackageNamespace\\(""\\), "format"\\), 2\n\
add\n\
pushstring "% target increased damage"\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length, main.format('\
getlex QName(PackageNamespace("com.giab.common.utils"), "NumberFormatter")\n\
getlocal {vSda}\n\
getproperty QName(PackageNamespace(""), "bleedingIncDamageMultiplier")\n\
callproperty QName(PackageNamespace(""), "g"), 0\n\
pushbyte 2\n\
callproperty QName(PackageNamespace(""),"format"), 2\n\
add\n\
pushstring " to bleeding damage multiplier"\
'));
			}
			main.modifyFunction('QName(PackageNamespace(""), "renderInfoPanelGem")', renderInfoPanelGem);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInfoPanelRenderer2.class.asasm", IngameInfoPanelRenderer2);
		}
	}
}