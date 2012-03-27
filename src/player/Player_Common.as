package player {
	import blocks.Base_block;
	import blocks.*;
	import Box2D.Collision.b2ManifoldPoint;
	import Box2D.Collision.b2Point;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Point;
	import Box2D.Dynamics.*;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.*;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	public class Player_Common {
		
		public static var MOVE_LEFT = ["A","LEFT"];
		public static var MOVE_RIGHT = ["D","RIGHT"];
		public static var JUMP = ["W","UP","SPACE"];
		
		public static function player_control(p:Base_block, world:b2World) {
			var lv:b2Vec2 = p.body.GetLinearVelocity();
			var contact_count:int = Common.contact_count(p.body.GetContactList());
			var move:Number;
			var gravity:b2Vec2 = world.GetGravity();
			if ( Math.abs(gravity.x) < Math.abs(gravity.y)) { //change applied dir based on gravity dir
				move = lv.x;
			} else {
				move = lv.y;
			}
			if (is_key(MOVE_LEFT)) { //control L/R movement based on direction of gravity
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
			
			if (is_key(JUMP,true) && contact_count != 0) { //enter if player jump success
				var jdir:b2Vec2 = new b2Vec2(0, 0);
				var pos:b2Vec2 = p.body.GetWorldCenter();
				var cur:b2ContactEdge = p.body.GetContactList();
				
				if (Main.CONTACT_DEBUG_DRAW) {
					Main.DEBUG_SPRITE.graphics.clear();
					Main.DEBUG_SPRITE.graphics.beginFill(0x000000);
					Main.DEBUG_SPRITE.graphics.drawCircle(Common.m2p(pos.x), Common.m2p(pos.y), 2);
					Main.DEBUG_SPRITE.graphics.beginFill(0xFF0000);
				}
				
				var r_contact_p_count:int = 0;
				var wmf:b2WorldManifold = new b2WorldManifold;
				
				while (cur != null) { //avg of vector between center and every point of contact
					cur.contact.GetWorldManifold(wmf);
					for (var i:int = 0; i < wmf.m_points.length; i++) {
						if (wmf.m_points[i].x == 0 && wmf.m_points[i].y == 0) {
							continue;
						}
						if (Main.CONTACT_DEBUG_DRAW) {
							trace("draw");
							Main.DEBUG_SPRITE.graphics.drawCircle(Common.m2p(wmf.m_points[i].x) , Common.m2p(wmf.m_points[i].y) , 2);
						}
						r_contact_p_count++;
						jdir.x -= (wmf.m_points[i].x - pos.x);
						jdir.y -= (wmf.m_points[i].y - pos.y);
					}
					cur = cur.next;
				}
				trace("\n\n\n");
				if (r_contact_p_count == 2) { //if 2pt collision, do alt pt/line mindist calc instead
					jdir = try_2pt_n_vector_test(jdir, p.body.GetContactList());
				}
				jdir.Normalize();
				
				jdir.x = Common.round_dec(jdir.x, 2);
				jdir.y = Common.round_dec(jdir.y, 2);
				
				var nlv:b2Vec2 = lv.Copy();
				if (Math.abs(gravity.x) < Math.abs(gravity.y)) { //reduce momentum effect
					nlv.y = 0;
				} else {
					nlv.x = 0;
				}				
				
				var x = "x"; var y = "y";
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
				Common.round_vec(jdir);
				if (jdir.x != 0 || jdir.y != 0) { //if has contact points, apply jump
					p.body.SetAngularVelocity(p.body.GetAngularVelocity() * 0.8);
					p.body.SetLinearVelocity(nlv);
					p.body.ApplyImpulse(jdir, p.body.GetWorldCenter());
				}
			}
			
		}
		
		//if 2pt collision, do instead pt/line min dist orth vector THEN x/y comp sign of prev jdir
		private static var pts:Array = new Array;
		private static function try_2pt_n_vector_test(jdir:b2Vec2, cur:b2ContactEdge):b2Vec2 {
			while (pts.length != 0) {
				pts.pop();
			}
			var wmf:b2WorldManifold = new b2WorldManifold;
			while (cur) {
				cur.contact.GetWorldManifold(wmf);
				for (var i:int = 0; i < wmf.m_points.length; i++) {
					if (wmf.m_points[i].x != 0 && wmf.m_points[i].y != 0) {
						pts.push(wmf.m_points[i].Copy());
					}
				}
				cur = cur.next;
			}
			if (pts.length == 2) {
				var pt2:b2Vec2 = pts.pop();
				var pt1:b2Vec2 = pts.pop();
				//TODO!!--remove similar points (multiple surfaces on same level contact)
				if (pt1.x == pt2.x && pt1.y == pt2.y) {
					return jdir;
				}
				Common.round_vec(pt1, 5);
				Common.round_vec(pt2, 5);
				trace(Common.print_vec(pt1)+" "+Common.print_vec(pt2));
				pt2.Subtract(pt1);
				var n_angle:Number = Math.atan2(pt2.y, pt2.x) + Math.PI / 2;
				jdir.x = Common.sig_n(jdir.x) * Math.abs(Math.cos(n_angle));
				jdir.y = Common.sig_n(jdir.y) * Math.abs(Math.sin(n_angle));
				Common.round_vec(jdir);
				
				
			}
			return jdir;
		}
		
		/* UNOPTIMIZED
		var v_12:b2Vec2 = pt2.Copy();
		v_12.Subtract(pt1);
		var n_angle:Number = Math.atan2(v_12.y, v_12.x)+Math.PI/2;
		var new_v:b2Vec2 = new b2Vec2(Common.sig_n(jdir.x)*Math.abs(Math.cos(n_angle)),Common.sig_n(jdir.y)*Math.abs(Math.sin(n_angle)));
		new_v.x = Common.round_dec(new_v.x, 1); new_v.y = Common.round_dec(new_v.y, 1);
		return new_v;
		*/
		
		private static function get_vec_angle(jdir:b2Vec2):String {
			return Math.round(Common.r2d(Math.atan2(jdir.y, jdir.x))) + "";
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
		
		//if approx sliding on side wall, angle jdir 45deg towards up
		private static function jdir_rotate(jdir:b2Vec2, high:String, low:String, sig_pos:Number, sig_neg:Number) {
			if (Math.abs(jdir[high]) > Math.abs(jdir[low])+0.9 && jdir[high] > 0) {
				Common.rotate_vector(jdir, 45 * sig_pos);
				jdir.Multiply(1.2);
			} else if (Math.abs(jdir[high]) > Math.abs(jdir[low])+0.9 && jdir[high] < 0) {
				Common.rotate_vector(jdir, 45 * sig_neg);
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
		
		public static function swap_controlled_test(player_obj:FlxGroup, cam:FlxCamera, old_follow:FlxSprite, key:String = "O"):FlxSprite {
			if (FlxG.keys.justPressed(key)) {
				var ind:int = 0;
				for (var i:int = 0; i < player_obj.length; i++) {
					if (player_obj.members[i].controlled) {
						ind = i;
					}
					player_obj.members[i].controlled = false;
				}
				ind++;
				if (ind > player_obj.length-1) {
					ind = 0;
				}
				player_obj.members[ind].controlled = true;
				cam.follow(player_obj.members[ind]);
				return player_obj.members[ind];
			} else {
				return old_follow;
			}
		}
		
		
		
	}

}