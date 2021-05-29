package mods {
	import Main;

	public class BetterFusion {
		public const MOD_NAME:String = "BetterFusion";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function BetterFusion() {}
		
		private function PnlSkills(fileContents:String) : void {
			function populateSkillsMetaData(functionContents:String) : void {
				result = main.regex('\
(getlocal0\n\
getproperty QName(PackageNamespace(""),"skillEffectiveValuesPerLevel")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"FUSION")\n\
pushdouble 0.01\n)\
(pushdouble 0.03\n)\
newarray 2\n\
setproperty MultinameL()\n\
').exec(functionContents);
				main.applyPatch(result.index + result[1].length, result[2].length, '\
pushdouble 0.04\
');
				result = main.regex('\
pushstring "-#0% gem combination cost"\n\
').exec(functionContents);
				main.applyPatch(result.index, result[0].length, '\
pushstring "-#0,1% gem combination cost"\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"populateSkillsMetaData")', populateSkillsMetaData);
		}
		
		private function IngameInitializer(fileContents:String) : void {
			function setScene2(functionContents:String) : void {
				result = main.regex('\
(getlex QName(PackageNamespace(""),"Math")\n)\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"MANACOST_COMBINEGEMS")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"FUSION")\n\
getproperty MultinameL()\n\
pushbyte 1\n\
getproperty MultinameL()\n\
callproperty Multiname("g"), 0\n\
subtract\n\
multiply\n\
(callproperty QName(PackageNamespace(""),"round"), 1\n)\
').exec(functionContents);
				main.applyPatch(result.index, result[1].length);
				main.applyPatch(result.index + result[0].length, -result[2].length);
				result = main.regex('\
(getlex QName(PackageNamespace(""),"Math")\n\
getlex QName(PackageNamespace(""),"Math")\n)\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"MANACOST_FIRSTGRADEGEM")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
pushbyte 1\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"skillEffectiveValues")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.constants"),"SkillId")\n\
getproperty QName(PackageNamespace(""),"FUSION")\n\
getproperty MultinameL()\n\
pushbyte 0\n\
getproperty MultinameL()\n\
callproperty Multiname("g"), 0\n\
subtract\n\
multiply\n\
(callproperty QName(PackageNamespace(""),"round"), 1\n\
callproperty QName(PackageNamespace(""),"floor"), 1\n)\
').exec(functionContents);
				main.applyPatch(result.index, result[1].length);
				main.applyPatch(result.index + result[0].length, -result[2].length);
				result = main.regex('\
(getlex QName(PackageNamespace(""),"Math")\n)\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"gemCreatingBaseManaCosts")\n\
getlocal i\n\
getproperty MultinameL()\n\
pushbyte 2\n\
multiply\n\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"gemCombiningManaCost")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
add\n\
(callproperty QName(PackageNamespace(""),"floor"), 1\n)\
').exec(functionContents);
				main.applyPatch(result.index, result[1].length);
				main.applyPatch(result.index + result[0].length, -result[2].length);
			}
			main.modifyFunction('QName(PackageNamespace(""),"setScene2")', setScene2);
		}
		
		private function IngameInfoPanelRenderer(fileContents:String) : void {
			function renderInfoPanel(functionContents:String) : void {
				result = main.regex('\
getlocal0\n\
getproperty QName(PackageNamespace(""),"core")\n\
getproperty QName(PackageNamespace(""),"gemCombiningManaCost")\n\
callproperty QName(PackageNamespace(""),"g"), 0\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, '\
getlex QName(PackageNamespace(""),"Math")\
');
				main.applyPatch(result.index + result[0].length, 0, '\
callproperty QName(PackageNamespace(""),"round"), 1\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"renderInfoPanel")', renderInfoPanel);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInitializer.class.asasm", IngameInitializer);
			main.modifyFile("com/giab/games/gcfw/ingame/IngameInfoPanelRenderer.class.asasm", IngameInfoPanelRenderer);
		}
	}
}