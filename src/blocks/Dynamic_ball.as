package blocks {
	import org.flixel.*;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class Dynamic_ball extends Static_wall {
		
		public var radius:Number;
		
		public function Dynamic_ball(x:Number, y:Number, r:Number, world:b2World) {
			this.radius = r;
			super(x, y, 0, 0, world);
			
			this.scale.x = radius / 10;
			this.scale.y = radius / 10;
		}
		
		protected override function get_shape():b2Shape {
			return new b2CircleShape(Common.p2m(radius));
		}
		
		protected override function make_graphic() {
			this.loadGraphic(ImgLib.ball_img_bmp, false, false, 20, 20);
		}
		
		public override function get_body_type():uint {
			return b2Body.b2_dynamicBody;
		}
		
	}

}