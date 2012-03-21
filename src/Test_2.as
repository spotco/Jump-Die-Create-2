package {
	import blocks.*;
	import Box2D.Collision.b2ManifoldPoint;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.flixel.*;
	import Box2D.Dynamics.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.*;
	
	public class Test_2 extends FlxState {
		
		protected var world:b2World;
		protected var game_obj:FlxGroup = new FlxGroup;
		protected var player_obj:FlxGroup = new FlxGroup;
		
		public override function create():void {
			super.create();
			init_game_sys();
			init_game_obj();
		}
		
		public override function update():void {
			super.update();
			//Main.DEBUG_SPRITE.graphics.clear();
			//world.DrawDebugData();
			world.Step(0.025, 10, 10);
			player_control();
		}
		
		private function player_control() {
			for each(var p:Base_block in player_obj.members) {
				var lv:b2Vec2 = p.body.GetLinearVelocity();
				var contact_count:int = Common.contact_count(p.body.GetContactList());
				if (FlxG.keys.A) {
					lv.x = Math.min(lv.x*.95, Math.max(lv.x - 0.25,-7));
				} else if (FlxG.keys.D) {
					lv.x = Math.max(lv.x*.95, Math.min(lv.x + 0.25,7));
				} else {
					if (contact_count != 0) {
						lv.x = lv.x * 0.95;
					}
					
				}
				p.body.SetLinearVelocity(lv);
				if (FlxG.keys.justPressed("W") && contact_count != 0) {
					
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
					
					jdir.x *= (p.params.mass);
					jdir.y *= (p.params.mass);
					p.body.ApplyImpulse(jdir, p.body.GetWorldCenter());
				}
			}
		}
		
		private function init_game_obj() {
			init_player();
			init_world_obj();
		}
		
		private function init_player() {
			var p1:Dynamic_box = new Dynamic_box(400, 20, 50, 50, world);
			p1.body.SetSleepingAllowed(false);
			p1.params.mass = 20;
			player_obj.add(p1);
			this.add(p1);
			
			var p2:Dynamic_ball = new Dynamic_ball(100, 50, 10, world);
			p2.body.SetSleepingAllowed(false);
			p2.params.mass = 3;
			player_obj.add(p2);
			this.add(p2);
			
		}
		
		private function init_world_obj() {
			var floor:Static_wall = new Static_wall(0, 590, FlxG.width, 10, world);
			game_obj.add(floor);
			this.add(floor);
			
			var ceil:Static_wall = new Static_wall(0, 0, FlxG.width, 10, world);
			game_obj.add(ceil);
			this.add(ceil);
			
			var left_wall:Static_wall = new Static_wall(0, 0, 10, FlxG.height, world);
			game_obj.add(left_wall);
			this.add(left_wall);
			
			var right_wall:Static_wall = new Static_wall(640, 0, 10, FlxG.height, world);
			game_obj.add(right_wall);
			this.add(right_wall);
			
			var t:Static_wall = new Static_wall(250, 450, 100, 500, world);
			game_obj.add(t);
			this.add(t);
			
			var b:Dynamic_ball = new Dynamic_ball(300, 300, 30, world);
			game_obj.add(b);
			this.add(b);
		}
		
		private function init_game_sys() {
			FlxG.mouse.show();
			FlxG.bgColor = FlxG.WHITE;
			
			var gravity:b2Vec2 = new b2Vec2(0, 9);
			world = new b2World(gravity, true);
			
			Common.init_debug_draw(Main.DEBUG_SPRITE, world);
		}

		
	}
	
}