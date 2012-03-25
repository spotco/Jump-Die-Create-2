package player {
	import blocks.Base_block;
	import blocks.*;
	import Box2D.Collision.b2ManifoldPoint;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Point;
	import Box2D.Dynamics.*;
	import org.flixel.FlxG;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.*;
	
	public class Player_Common {
		
		private static var MOVE_LEFT = ["A","LEFT"];
		private static var MOVE_RIGHT = ["D","RIGHT"];
		private static var JUMP = ["W","UP","SPACE"];
				
		public static function player_control(p:Base_block, world:b2World) {
			var lv:b2Vec2 = p.body.GetLinearVelocity();
			var contact_count:int = Common.contact_count(p.body.GetContactList());
			var move:Number;
			var gravity:b2Vec2 = world.GetGravity();
			if ( Math.abs(gravity.x) < Math.abs(gravity.y)) {
				move = lv.x;
			} else {
				move = lv.y;
			}
			if (is_key(MOVE_LEFT)) { //control movement based on direction of gravity
				move = Math.min(move*.9, Math.max(move - 0.5,-7));
			} else if (is_key(MOVE_RIGHT)) {
				move = Math.max(move*.9, Math.min(move + 0.5,7));
			} else if (contact_count > 0) {
				move = move * 0.95;
				
			}
			if (Math.abs(gravity.x) < Math.abs(gravity.y)) {
				lv.x = move;
			} else {
				lv.y = move;
			}
			p.body.SetLinearVelocity(lv);
			if (is_key(JUMP,true) && contact_count != 0) {
				
				var jdir:b2Vec2 = new b2Vec2(0, 0);
				var pos:b2Vec2 = p.body.GetWorldCenter();
				var cur:b2ContactEdge = p.body.GetContactList();
				
				//Main.DEBUG_SPRITE.graphics.clear();
				//Main.DEBUG_SPRITE.graphics.beginFill(0xFF0000);
				
				while (cur != null) { //avg of vector between center and every point of contact
					var wmf:b2WorldManifold = new b2WorldManifold;
					cur.contact.GetWorldManifold(wmf);
					for (var i:int = 0; i < wmf.m_points.length; i++) {
						if (wmf.m_points[i].x == 0 && wmf.m_points[i].y == 0) {
							continue;
						}
						//Main.DEBUG_SPRITE.graphics.drawCircle(Common.m2p(wmf.m_points[i].x) , Common.m2p(wmf.m_points[i].y) , 2);
						jdir.x -= (wmf.m_points[i].x - pos.x);
						jdir.y -= (wmf.m_points[i].y - pos.y);
					}
					cur = cur.next;
				}					
				jdir.Normalize();
				
				var nlv:b2Vec2 = lv.Copy();
				if (Math.abs(gravity.x) < Math.abs(gravity.y)) { //reduce momentum effect
					nlv.y = 0;
				} else {
					nlv.x = 0;
				}
				
				var x = "x";
				var y = "y";
				if (Math.abs(gravity.x) < Math.abs(gravity.y)) { //rotate jump dir vector +45 if slide
					if (gravity.y > 0) {
						jdir_rotate(jdir, x, y, -1, 1);
					} else {
						jdir_rotate(jdir, x, y, 1, -1);
					}
				} else {
					if (gravity.x > 0) {
						jdir_rotate(jdir, y, x, 1, -1);
					} else {
						jdir_rotate(jdir, y, x, -1, 1);
					}
				}
				
				jdir.x *= (p.params.jump_force);
				jdir.y *= (p.params.jump_force);
				if (jdir.x != 0 || jdir.y != 0) { //if has contact points, apply jump
					p.body.SetAngularVelocity(p.body.GetAngularVelocity() * 0.8);
					p.body.SetLinearVelocity(nlv);
					p.body.ApplyImpulse(jdir, p.body.GetWorldCenter());
				}
			}
		}
		
		private static function is_key(k:Array,jp:Boolean=false):Boolean {
			for each (var i in k) {
				if (jp) {
					if (FlxG.keys.justPressed(i)) {
						return true;
					}
				} else {
					if (FlxG.keys[i]) {
						return true;
					}
				}
			}
			return false;
		}
		
		private static function jdir_rotate(jdir:b2Vec2, high:String, low:String, sig_pos:Number, sig_neg:Number) {
			if (Math.round(jdir[high]) == 1 && Math.round(jdir[low]) == 0) {
				Common.rotate_vector(jdir, 45*sig_pos);
				jdir.Multiply(1.2);
			} else if (Math.round(jdir[high]) == -1 && Math.round(jdir[low]) == 0) {
				Common.rotate_vector(jdir, 45*sig_neg);
				jdir.Multiply(1.2);
			}
		}
		
		public static function swap_gravity_test(world:b2World,key:String = "P") {
			if (FlxG.keys.justPressed(key)) {
				if (world.GetGravity().y == 14) {
					world.SetGravity(new b2Vec2(14, 0));
				} else if (world.GetGravity().x == 14) {
					world.SetGravity(new b2Vec2(0, -14));
				} else if (world.GetGravity().y == -14) {
					world.SetGravity(new b2Vec2(-14, 0));
				} else {
					world.SetGravity(new b2Vec2(0, 14));
				}
				
			}
		}
		
	}//

}