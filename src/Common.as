package  {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Sprite;
	import Box2D.Dynamics.b2DebugDraw;
	
	public class Common {
		
		public static function rotate_vector(vec1:b2Vec2, deg:Number) {
			var mag:Number = vec1.Length();
			var angle:Number = Math.atan2(vec1.y, vec1.x);
			angle += d2r(deg);
			
			vec1.x = mag * Math.cos(angle);
			vec1.y = mag * Math.sin(angle);
		}
		
		public static function init_debug_draw(tar:Sprite,src:b2World) {
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.SetSprite(tar);
			dbgDraw.SetDrawScale(30);
			dbgDraw.SetAlpha(1);
			dbgDraw.SetFillAlpha(0.5);
			dbgDraw.SetLineThickness(1);
			dbgDraw.AppendFlags(b2DebugDraw.e_shapeBit);
			dbgDraw.AppendFlags(b2DebugDraw.e_jointBit);
			dbgDraw.AppendFlags(b2DebugDraw.e_centerOfMassBit);
			src.SetDebugDraw(dbgDraw);
		}
		
		public static function contact_count(front:b2ContactEdge):Number {
			var count:int = 0;
			while (front != null) {
				front = front.next;
				count++;
			}
			return count;
		}
		
		public static function d2r(d:Number):Number {
			return d * (Math.PI / 180);
		}
		
		public static function r2d(r:Number):Number {
			return r * (180 / Math.PI);
		}
		
		public static function p2m(p:Number):Number {
			return p / pixel_meter_ratio;
		}
		
		public static function m2p(m:Number):Number {
			return m * pixel_meter_ratio;
		}
		
		public static var pixel_meter_ratio:Number = 30;
		
	}

}