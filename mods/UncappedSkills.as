package mods {
	import Main;

	public class UncappedSkills {
		public const MOD_NAME:String = "UncappedSkills";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function UncappedSkills() {}
		
		private function PnlSkills(fileContents:String) : void {
			function renderInfoPanelSkill(functionContents:String) : void {
				result = main.regex('\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"mcInfoPanel")\n\
pushint 16099072\n\
pushstring "Wrath skill"\n\
pushstring "Focus skill"\n\
pushstring ""\n\
pushstring "Enhancement spell skill"\n\
pushstring "Strike spell skill"\n\
pushstring "Construction skill"\n\
newarray 6\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"skillTypes")\n\
getlocal pId\n\
getproperty MultinameL()\n\
getproperty MultinameL()\n\
(pushfalse\n\
pushbyte 10\n\
callpropvoid QName(PackageNamespace(""),"addTextfield"), 4\n)\
').exec(functionContents);
				main.applyPatch(result.index + result[0].length, -result[1].length, '\
pushtrue\n\
pushbyte 11\n\
callpropvoid QName(PackageNamespace(""),"addTextfield"), 4\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"),"GV")\n\
getproperty QName(PackageNamespace(""),"mcInfoPanel")\n\
pushint 16742359\n\
pushstring "No cap"\n\
pushfalse\n\
pushbyte 11\n\
callpropvoid QName(PackageNamespace(""),"addTextfield"), 4\
');
			}
			main.modifyFunction('QName(PackageNamespace(""),"renderInfoPanelSkill")', renderInfoPanelSkill);
		}
		
		private function Calculator(fileContents:String) : void {
			function getSkillCap(functionContents:String) : void {
				result = main.regex('\
ifeq (\\w+)\n\
').exec(functionContents);
				var jumpTargets:Object = {jumpTarget1: result[1]};
				main.applyPatch(result.index, result[0].length, '\
ifnge jumpTarget1\
', jumpTargets);
			}
			main.modifyFunction('QName(PackageNamespace(""),"getSkillCap")', getSkillCap);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/selector/PnlSkills.class.asasm", PnlSkills);
			main.modifyFile("com/giab/games/gcfw/utils/Calculator.class.asasm", Calculator);
		}
	}
}