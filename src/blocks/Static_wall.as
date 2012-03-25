package blocks {
	import org.flixel.*;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class Static_wall extends Base_block {
		
		public function Static_wall(x:Number, y:Number, w:Number, h:Number, world:b2World) {
			super(x, y);
			this.width = w;
			this.height = h;
			this.world = world;
			
			create_body();
			make_graphic();
		}
		
		private function create_body() {			
			fixture_def = new b2FixtureDef;
			fixture_def.density = get_fixture_params().density;
			fixture_def.restitution = get_fixture_params().restitution;
			fixture_def.friction = get_fixture_params().friction;
			fixture_def.shape = get_shape();
			
			body_def = new b2BodyDef();
			body_def.position.Set(Common.p2m(x + (width/2)), Common.p2m(y + (height/2)));
			body_def.angle = Common.d2r(angle);
			body_def.type = get_body_type();
			
			body = world.CreateBody(body_def);
			body.CreateFixture(fixture_def);
		}
		
		protected function get_shape():b2Shape {
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(Common.p2m(width / 2), Common.p2m(height / 2));
			return shape;
		}
		
		protected function make_graphic() {
			this.makeGraphic(width, height, 0xff0000ff);
		}
		
		public override function update():void {
			x = Common.m2p(body.GetPosition().x) - width/2 ;
			y = Common.m2p(body.GetPosition().y) - height/2;
			angle = Common.r2d(body.GetAngle());
			super.update();
		}
		
		public function get_body_type():uint {
			return b2Body.b2_staticBody;
		}
		
		public function get_fixture_params():Object {
			return { friction:0.5 , restitution:0 , density:1 };
		}
		
	}

}