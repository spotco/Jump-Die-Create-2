package {
	import flash.display.*;
	import flash.events.*;
	import org.flixel.FlxGame;
	import org.flixel.FlxG
	
	[SWF(backgroundColor = "#FFFFFF", frameRate = "60", width = "650", height = "600")]
	
	public class Main extends FlxGame {
		public static var DEBUG_SPRITE:Sprite;
		
		public function Main():void {
			super(650, 600, Game_Engine);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function addedToStage(e:Event) {
			 DEBUG_SPRITE = new Sprite;
			 FlxG.stage.addChild(DEBUG_SPRITE);
		}
		
	}
	
}