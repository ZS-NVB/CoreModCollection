package  
{
	import Bezel.Bezel;
	import Bezel.BezelCoreMod;
	import Bezel.BezelMod;
	import Bezel.GCFW.GCFWBezel;
	import Bezel.Lattice.Lattice;
	import Bezel.Logger;
	import flash.display.MovieClip;
	
	public class CoreModCollectionMod extends MovieClip implements BezelCoreMod
	{
		
		public function get VERSION():String {return "1.6.0"};
		public function get BEZEL_VERSION():String {return "1.0.0"};
		public function get COREMOD_VERSION():String {return coreModCollection.COREMOD_VERSION};
		public function get MOD_NAME():String {return coreModCollection.MOD_NAME};
		public const GAME_VERSION:String = "1.2.1a";
		
		
		private var coreModCollection:Object;
		
		internal static var bezel:Bezel;
		internal static var logger:Logger;
		internal static var instance:CoreModCollectionMod;
		
		public function CoreModCollectionMod() 
		{
			super();
			instance = this;
			coreModCollection = new Main();
		}
		
		// This method binds the class to the game's objects
		public function bind(modLoader:Bezel, gameObjects:Object):void
		{
			bezel = modLoader;
			logger = bezel.getLogger("CoreModCollection");
		}
		
		public function loadCoreMod(lattice: Lattice): void
		{
			coreModCollection.loadCoreMod(lattice);
		}
		
		public function unload():void
		{
			if (coreModCollection != null)
			{
				coreModCollection.unload();
				coreModCollection = null;
			}
		}
	}

}