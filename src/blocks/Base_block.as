package blocks {
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import org.flixel.FlxSprite;
	
	public class Base_block extends FlxSprite {
		
		public function Base_block(x:Number, y:Number) {
			super(x, y);
		}
		
		public var fixture_def:b2FixtureDef;
		public var body_def:b2BodyDef;
		public var body:b2Body;
		public var world:b2World;
		
		public var params:Object = new Object;
		
		public var controlled:Boolean=false;
	
	}

}