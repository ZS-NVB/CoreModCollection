package mods {
	import Main;
	
	public class RotatableFragments {
		public const MOD_NAME:String = "RotatableFragments";
		public const COREMOD_VERSION:String = "1";
		
		private var main:Main;
		private var regex:RegExp;
		private var result:Object;
		
		public function RotatableFragments() {}
		
		private function TalismanFragment(fileContents:String) : void {
			result = /^end ; class$/m.exec(fileContents);
			main.applyPatch(result.index, 0, main.format('\
trait method QName(PackageNamespace(""), "shapeIdsRotations") dispid 0\n\
method\n\
name "com.giab.games.gcfw.entity:TalismanFragment/shapeIdsRotations"\n\
refid "com.giab.games.gcfw.entity:TalismanFragment/class/shapeIdsRotations"\n\
param QName(PackageNamespace(""), "int")\n\
param QName(PackageNamespace(""), "int")\n\
returns QName(PackageNamespace(""), "Boolean")\n\
\n\
body\n\
maxstack 3\n\
localcount 9\n\
initscopedepth 1\n\
maxscopedepth 2\n\
\n\
code\n\
getlocal0\n\
pushscope\n\
pushbyte 0\n\
setlocal3\n\
getlex QName(PackageNamespace(""), "LINKS_UP")\n\
getlocal1\n\
getproperty MultinameL([PackageNamespace("")])\n\
convert_i\n\
setlocal 4\n\
getlex QName(PackageNamespace(""), "LINKS_RIGHT")\n\
getlocal1\n\
getproperty MultinameL([PackageNamespace("")])\n\
convert_i\n\
setlocal 5\n\
getlex QName(PackageNamespace(""), "LINKS_DOWN")\n\
getlocal1\n\
getproperty MultinameL([PackageNamespace("")])\n\
convert_i\n\
setlocal 6\n\
getlex QName(PackageNamespace(""), "LINKS_LEFT")\n\
getlocal1\n\
getproperty MultinameL([PackageNamespace("")])\n\
convert_i\n\
setlocal 7\n\
jump {jumpTarget1}\n\
{jumpTarget2}:\n\
label\n\
getlocal 4\n\
convert_i\n\
setlocal 8\n\
getlocal 5\n\
convert_i\n\
setlocal 4\n\
getlocal 6\n\
convert_i\n\
setlocal 5\n\
getlocal 7\n\
convert_i\n\
setlocal 6\n\
getlocal 8\n\
convert_i\n\
setlocal 7\n\
getlocal 4\n\
getlex QName(PackageNamespace(""), "LINKS_UP")\n\
getlocal2\n\
getproperty MultinameL([PackageNamespace("")])\n\
equals\n\
dup\n\
iffalse {jumpTarget3}\n\
pop\n\
getlocal 5\n\
getlex QName(PackageNamespace(""), "LINKS_RIGHT")\n\
getlocal2\n\
getproperty MultinameL([PackageNamespace("")])\n\
equals\n\
{jumpTarget3}:\n\
dup\n\
iffalse {jumpTarget4}\n\
pop\n\
getlocal 6\n\
getlex QName(PackageNamespace(""), "LINKS_DOWN")\n\
getlocal2\n\
getproperty MultinameL([PackageNamespace("")])\n\
equals\n\
{jumpTarget4}:\n\
dup\n\
iffalse {jumpTarget5}\n\
pop\n\
getlocal 7\n\
getlex QName(PackageNamespace(""), "LINKS_LEFT")\n\
getlocal2\n\
getproperty MultinameL([PackageNamespace("")])\n\
equals\n\
{jumpTarget5}:\n\
iffalse {jumpTarget6}\n\
pushtrue\n\
returnvalue\n\
{jumpTarget6}:\n\
inclocal_i 3\n\
{jumpTarget1}:\n\
getlocal3\n\
pushbyte 4\n\
iflt {jumpTarget2}\n\
pushfalse\n\
returnvalue\n\
end ; code\n\
end ; body\n\
end ; method\n\
end ; trait\
', main.getJumpTargets("jumpTarget1", "jumpTarget2", "jumpTarget3", "jumpTarget4", "jumpTarget5", "jumpTarget6")));
		}
		
		private function PnlTalisman(fileContents:String) : void {
			function ehKeyDown(functionContents:String) : void {
				result = new RegExp(main.format('\
getlocal ?{pE}\n\
getproperty QName\\(PackageNamespace\\(""\\), "keyCode"\\)\n\
getlex QName\\(PackageNamespace\\("com.giab.common.constants"\\), "KeyCode"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "U"\\)\n\
ifne (\\w+)\n\
debugline \\d+\n\
getlocal0\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "upgradeFragmentUnderPointer"\\), 0\n\
jump (\\w+)\n\
\\1:\n\
')).exec(functionContents);
				var jumpTargets:Object = main.getJumpTargets("jumpTarget1");
				jumpTargets["jumpTarget2"] = result[2];
				main.applyPatch(result.index, 0, main.format('\
getlocal {pE}\n\
getproperty QName(PackageNamespace(""), "keyCode")\n\
getlex QName(PackageNamespace("com.giab.common.constants"), "KeyCode")\n\
getproperty QName(PackageNamespace(""), "R")\n\
ifne {jumpTarget1}\n\
getlocal0\n\
pushstring "rotate"\n\
callpropvoid QName(PackageNamespace(""), "changeFragmentShapeUnderPointer"), 1\n\
jump {jumpTarget2}\n\
{jumpTarget1}:\
', jumpTargets));
			}
			function changeFragmentShape(functionContents:String) : void {
				result = new RegExp(main.format('\
getlocal ?{pFrag}\n\
callproperty QName\\(PackageNamespace\\(""\\), "clone"\\), 0\n\
coerce QName\\(PackageNamespace\\("com.giab.games.gcfw.entity"\\), "TalismanFragment"\\)\n\
setlocal ?{vClone}\n\
')).exec(functionContents);
				main.applyPatch(result.index + result[0].length, 0, main.format('\
getlocal {pDirection}\n\
pushstring "rotate"\n\
ifne {jumpTarget1}\n\
getlocal {pFrag}\n\
getlocal {vClone}\n\
getproperty QName(PackageNamespace(""), "linkLeft")\n\
setproperty QName(PackageNamespace(""), "linkUp")\n\
getlocal {pFrag}\n\
getlocal {vClone}\n\
getproperty QName(PackageNamespace(""), "linkUp")\n\
setproperty QName(PackageNamespace(""), "linkRight")\n\
getlocal {pFrag}\n\
getlocal {vClone}\n\
getproperty QName(PackageNamespace(""), "linkRight")\n\
setproperty QName(PackageNamespace(""), "linkDown")\n\
getlocal {pFrag}\n\
getlocal {vClone}\n\
getproperty QName(PackageNamespace(""), "linkDown")\n\
setproperty QName(PackageNamespace(""), "linkLeft")\n\
getlocal0\n\
pushtrue\n\
initproperty QName(PackageNamespace(""), "dirtyFlag")\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "talFragBitmapCreator")\n\
getlocal {pFrag}\n\
callpropvoid QName(PackageNamespace(""), "giveTalFragBitmaps"), 1\n\
returnvoid\n\
{jumpTarget1}:\
', main.getJumpTargets("jumpTarget1")));
				regex = new RegExp(main.format('\
(getlocal ?{pFrag}\n\
callproperty QName\\(PackageNamespace\\(""\\), "getOriginalShapeId"\\), 0\n\
getlocal ?{vClone}\n\
callproperty QName\\(PackageNamespace\\(""\\), "getShapeId"\\), 0\n)\
(equals\n)\
'), "g")
				result = regex.exec(functionContents);
				while (result != null) {
					main.applyPatch(result.index, 0, 'getlex QName(PackageNamespace("com.giab.games.gcfw.entity"), "TalismanFragment")');
					main.applyPatch(result.index + result[1].length, result[2].length, 'callproperty QName(PackageNamespace(""), "shapeIdsRotations"), 2');
					result = regex.exec(functionContents);
				}	
			}
			function addFragmentToShapeCollection(functionContents:String) : void {
				result = new RegExp(main.format('\
debugline \\d+\n\
getlex QName\\(PackageNamespace\\("com.giab.games.gcfw"\\), "GV"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "ppd"\\)\n\
getproperty QName\\(PackageNamespace\\(""\\), "talFragShapeCollection"\\)\n\
getlocal ?{vShapeId}\n\
pushtrue\n\
setproperty MultinameL[^\n]+\n\
debugline \\d+\n\
getlocal0\n\
getlocal ?{vShapeId}\n\
callpropvoid QName\\(PackageNamespace\\(""\\), "updateShapeCollection"\\), 1\n\
')).exec(functionContents);
				main.applyPatch(result.index, result[0].length, main.format('\
pushbyte 0\n\
setlocal {i}\n\
jump {jumpTarget1}\n\
{jumpTarget2}:\n\
label\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.entity"), "TalismanFragment")\n\
getlocal {vShapeId}\n\
getlocal {i}\n\
callproperty QName(PackageNamespace(""), "shapeIdsRotations"), 2\n\
iffalse {jumpTarget3}\n\
getlex QName(PackageNamespace("com.giab.games.gcfw"), "GV")\n\
getproperty QName(PackageNamespace(""), "ppd")\n\
getproperty QName(PackageNamespace(""), "talFragShapeCollection")\n\
getlocal {i}\n\
pushtrue\n\
setproperty MultinameL({namespaces})\n\
getlocal0\n\
getlocal {i}\n\
callpropvoid QName(PackageNamespace(""), "updateShapeCollection"), 1\n\
{jumpTarget3}:\n\
inclocal_i {i}\n\
{jumpTarget1}:\n\
getlocal {i}\n\
pushbyte 64\n\
iflt {jumpTarget2}\n\
', main.getJumpTargets("jumpTarget1", "jumpTarget2", "jumpTarget3")));
			}
			main.modifyFunction('QName(PackageNamespace(""), "ehKeyDown")', ehKeyDown);
			main.modifyFunction('QName(PackageNamespace(""), "changeFragmentShape")', changeFragmentShape);
			main.modifyFunction('QName(PackageNamespace(""), "addFragmentToShapeCollection")', addFragmentToShapeCollection);
		}
		
		private function PlayerProgressData(fileContents:String) : void {
			function populateFromString01(functionContents:String) : void {
				result = new RegExp('\
returnvoid\n\
end ; code\n\
').exec(functionContents);
				main.applyPatch(result.index, 0, main.format('\
pushbyte 0\n\
setlocal {i}\n\
jump {jumpTarget1}\n\
{jumpTarget2}:\n\
label\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "talFragShapeCollection")\n\
getlocal {i}\n\
getproperty MultinameL({namespaces})\n\
iffalse {jumpTarget3}\n\
pushbyte 0\n\
setlocal {j}\n\
jump {jumpTarget4}\n\
{jumpTarget5}:\n\
label\n\
getlex QName(PackageNamespace("com.giab.games.gcfw.entity"), "TalismanFragment")\n\
getlocal {i}\n\
getlocal {j}\n\
callproperty QName(PackageNamespace(""), "shapeIdsRotations"), 2\n\
iffalse {jumpTarget6}\n\
getlocal0\n\
getproperty QName(PackageNamespace(""), "talFragShapeCollection")\n\
getlocal {j}\n\
pushtrue\n\
setproperty MultinameL({namespaces})\n\
{jumpTarget6}:\n\
inclocal_i {j}\n\
{jumpTarget4}:\n\
getlocal {j}\n\
pushbyte 64\n\
iflt {jumpTarget5}\n\
{jumpTarget3}:\n\
inclocal_i {i}\n\
{jumpTarget1}:\n\
getlocal {i}\n\
pushbyte 64\n\
iflt {jumpTarget2}\
', main.getJumpTargets("jumpTarget1", "jumpTarget2", "jumpTarget3", "jumpTarget4", "jumpTarget5", "jumpTarget6")));
			}
			main.modifyFunction('QName(PrivateNamespace("com.giab.games.gcfw.struct:PlayerProgressData"), "populateFromString01")', populateFromString01);
		}
		
		public function loadCoreMod(main:Main) : void {
			this.main = main;
			main.modifyFile("com/giab/games/gcfw/entity/TalismanFragment.class.asasm", TalismanFragment);
			main.modifyFile("com/giab/games/gcfw/selector/PnlTalisman.class.asasm", PnlTalisman);
			main.modifyFile("com/giab/games/gcfw/struct/PlayerProgressData.class.asasm", PlayerProgressData);
		}
	}
}