package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
    import org.flixel.*;
 
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
 
    public class B2Circle extends FlxSprite
    {
        private var ratio:Number = 30;
 
        public var _fixDef:b2FixtureDef;
        public var _bodyDef:b2BodyDef
        public var _obj:b2Body;
 
        private var _radius:Number;
        private var _world:b2World;
 
        //Physics params default value
        public var _friction:Number = 0.8;
        public var _restitution:Number = 0.3;
        public var _density:Number = 0.7;
 
        //Default angle
        public var _angle:Number = 0;
        //Default body type
        public var _type:uint = b2Body.b2_dynamicBody;
 
 
        public function B2Circle(X:Number, Y:Number, Radius:Number, w:b2World):void {
            super(X,Y);
			_radius = Radius;
            _world = w;
			createBody();
			this.loadGraphic(ball_img_bmp, false, false, 20, 20);
			
			//this.setOriginToCorner();
			this.scale.x = Radius / 10;
			this.scale.y = Radius / 10;
            x = (_obj.GetPosition().x * ratio)  - 10;
            y = (_obj.GetPosition().y * ratio)  - 10;
			
        }
 
        override public function update():void {
            x = (_obj.GetPosition().x * ratio)  - 10;
            y = (_obj.GetPosition().y * ratio)  - 10;
            angle = _obj.GetAngle() * (180 / Math.PI);
            super.update();

			//trace(Game_Engine.m2p(_obj.GetPosition().x) - this.x+"  "+this._radius);
			//trace(Game_Engine.m2p(_obj.GetPosition().x) +","+Game_Engine.m2p(_obj.GetPosition().y)+"   "+this.x+","+this.y+" "+this._radius);
        }
 
        public function createBody():void {
            _fixDef = new b2FixtureDef();
            _fixDef.friction = _friction;
            _fixDef.restitution = _restitution;
            _fixDef.density = _density;
            _fixDef.shape = new b2CircleShape(_radius/ratio);
 
            _bodyDef = new b2BodyDef();
            _bodyDef.position.Set((x + (_radius/2)) / ratio, (y + (_radius / 2)) / ratio );
			
            _bodyDef.angle = _angle * (Math.PI / 180);
            _bodyDef.type = _type;
 
            _obj = _world.CreateBody(_bodyDef);
            _obj.CreateFixture(_fixDef);
        }
		
		[Embed(source = "../img/ball.png")]
		public var ball_img_bmp:Class;
		
    }
}