package mods {
	import Main;

	public class TrapRangeDisplay {
		public const MOD_NAME:String = "TrapRangeDisplay";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;

		public function TrapRangeDisplay() {}
		
		private function IngameInfoPanelRenderer(fileContents:String) : void {
			function renderInfoPanel(functionContents:String) : void {
				result = new RegExp(main.format('\
getlocal0\n\
getproperty QName\\(PackageNamespace\\(""\\), "core"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "infoPanelRenderer2"\\)\n\
getlocal ?{vTrap}\n\
getproperty QName\\(PackageNamespace\\(""\\), "insertedGem"\\)\n\
getlocal ?{vTrap}\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "renderInfoPanelGem"\\), 2\n\
')).exec(functionContents);
				var insert:String = '\
getlocal0\n\
getproperty QName(PackageNamespace(""), "cnt")\n\
getproperty QName(PackageNamespace(""), "cntRetinaHud")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "cnt")\n\
getproperty QName(PackageNamespace(""), "mcRange")\n\
callpropvoid QName(PackageNamespace(""), "addChild"), 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "cnt")\n\
getproperty QName(PackageNamespace(""), "mcRange")\n\
getproperty QName(PackageNamespace(""), "circle")\n\
pushtrue\n\
setproperty QName(PackageNamespace(""), "visible")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "cnt")\n\
getproperty QName(PackageNamespace(""), "mcRange")\n\
getproperty QName(PackageNamespace(""), "circleEnh")\n\
pushfalse\n\
setproperty QName(PackageNamespace(""), "visible")\n\
'
				for (var i:int = 0; i < 8; i++) {
					insert += '\
getlocal0\n\
getproperty QName(PackageNamespace(""), "cnt")\n\
getproperty QName(PackageNamespace(""), "mcRange")\n\
getproperty QName(PackageNamespace(""), "shrineLine' + i.toString() + '")\n\
pushfalse\n\
setproperty QName(PackageNamespace(""), "visible")\n\
';
				}
				insert += '\
getlocal {vTrap}\n\
getproperty QName(PackageNamespace(""), "range")\n\
pushbyte 2\n\
multiply\n\
dup\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "cnt")\n\
getproperty QName(PackageNamespace(""), "mcRange")\n\
getproperty QName(PackageNamespace(""), "circle")\n\
swap\n\
setproperty QName(PackageNamespace(""), "height")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "cnt")\n\
getproperty QName(PackageNamespace(""), "mcRange")\n\
getproperty QName(PackageNamespace(""), "circle")\n\
swap\n\
setproperty QName(PackageNamespace(""), "width")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "cnt")\n\
getproperty QName(PackageNamespace(""), "mcRange")\n\
getproperty QName(PackageNamespace(""), "circle")\n\
getlocal {vTrap}\n\
getproperty QName(PackageNamespace(""), "x")\n\
setproperty QName(PackageNamespace(""), "x")\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "cnt")\n\
getproperty QName(PackageNamespace(""), "mcRange")\n\
getproperty QName(PackageNamespace(""), "circle")\n\
getlocal {vTrap}\n\
getproperty QName(PackageNamespace(""), "y")\n\
setproperty QName(PackageNamespace(""), "y")\
';
				main.applyPatch(result.index, 0, main.format(insert));
			}
			main.modifyFunction('QName(PackageNamespace(""), "renderInfoPanel")', renderInfoPanel);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInfoPanelRenderer.class.asasm", IngameInfoPanelRenderer);
		}
	}
}