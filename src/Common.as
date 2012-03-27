package  {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.Sprite;
	import Box2D.Dynamics.b2DebugDraw;
	import org.flixel.FlxGroup;
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	
	public class Common {
		
		public static function get_bounds(game_obj:FlxGroup):Rectangle {
			var o:Object;
			for each (var s:FlxSprite in game_obj.members) {
				if (!o) {
					o = new Object;
					o.min_x = s.x;
					o.min_y = s.y;
					o.max_x = s.x + s.width;
					o.max_y = s.y + s.height;
				} else {
					o.min_x = Math.min(s.x,o.min_x);
					o.min_y = Math.min(s.y,o.min_y);
					o.max_x = Math.max(s.x + s.width,o.max_x);
					o.max_y = Math.max(s.y + s.height,o.max_y);
				}
			}
			return new Rectangle(o.min_x, o.min_y, o.max_x - o.min_x, o.max_y - o.min_y);
		}
		
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
		
		public static function round_dec(numIn:Number, decimalPlaces:int):Number {
			var nExp:int = Math.pow(10,decimalPlaces) ;
			var nRetVal:Number = Math.round(numIn * nExp) / nExp
			return nRetVal;
		}
		
		public static function sig_n(chk:Number,val:Number=1):Number {
			if (chk < 0) {
				return -val;
			} else if (chk > 0) {
				return val;
			} else {
				return val;
			}
		}
		
		public static function round_vec(v:b2Vec2, dec:Number=1) {
			v.x = round_dec(v.x, dec);
			v.y = round_dec(v.y, dec);
		}
		
		public static function print_vec(v:b2Vec2):String {
			return "(" + v.x + "," + v.y + ")";
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
		
		private static var pixel_meter_ratio:Number = 30;
		
	}

}