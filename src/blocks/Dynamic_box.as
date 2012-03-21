package blocks {
	import org.flixel.*;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class Dynamic_box extends Static_wall {

		public function Dynamic_box(x:Number, y:Number, w:Number, h:Number, world:b2World) {
			super(x, y, w, h, world);
		}
		
		protected override function make_graphic() {
			this.makeGraphic(width, height, 0xff0000ff);
		}
		
		public override function update():void {
			super.update();
		}
		
		public override function get_body_type():uint {
			return b2Body.b2_dynamicBody;
		}
		
	}

}