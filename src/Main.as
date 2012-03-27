package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import org.flixel.FlxGame;
	import org.flixel.FlxG
	
	[SWF(backgroundColor = "#FFFFFF", frameRate = "60", width = "650", height = "600")]
	
	public class Main extends FlxGame {
		
		//mutually exclusive settings, all use the DEBUG_SPRITE
		public static var B2_DEBUG_DRAW:Boolean = false;
		public static var CONTACT_DEBUG_DRAW:Boolean = true;
		
		public static var DEBUG_SPRITE:Sprite = new Sprite;
		
		public function Main():void {
			super(650, 600, Game_Engine);
			addEventListener(Event.ADDED_TO_STAGE, init_debug_sprite);
		}
		
		public function init_debug_sprite(e:Event) {
			 FlxG.stage.addChild(DEBUG_SPRITE);
			 DEBUG_SPRITE.scrollRect = new Rectangle(0, 0, 650, 600);
			 if (B2_DEBUG_DRAW || CONTACT_DEBUG_DRAW) {
				DEBUG_SPRITE.visible = true;
			 }
		}
		
	}
	
}