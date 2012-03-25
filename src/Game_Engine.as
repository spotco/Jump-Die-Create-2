package {
	import blocks.*;
	import flash.geom.Rectangle;
	import player.*;
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
	
	public class Game_Engine extends FlxState {
		
		protected var world:b2World;
		protected var game_obj:FlxGroup = new FlxGroup;
		protected var player_obj:FlxGroup = new FlxGroup;
		protected var cam:FlxCamera;
		
		public override function create():void {
			super.create();
			init_game_sys();
			init_game_obj();
			
			FlxG.addCamera(cam=get_cam());
		}
		
		public override function update():void {
			super.update();
			
			draw_b2_debug();
			
			world.Step(0.025, 10, 10);
			player_control();
		}
		
		private function player_control() {
			for each(var p:Base_block in player_obj.members) {
				Player_Common.player_control(p, world);
			}
			Player_Common.swap_gravity_test(world);
		}
		
		
		private function init_game_obj() {
			init_player();
			init_world_obj();
		}
		
		private function init_player() {
			/*var p1:Dynamic_box = new Dynamic_box(400, 20, 20, 20, world);
			p1.body.SetSleepingAllowed(false);
			p1.params.jump_force = 6;
			player_obj.add(p1);
			this.add(p1);*/
			
			var p2:Dynamic_ball = new Dynamic_ball(100, 50, 20, world);
			p2.body.SetSleepingAllowed(false);
			p2.params.jump_force = 17;
			player_obj.add(p2);
			this.add(p2);
		}
		
		private function init_world_obj() {
			var world_blocks:Array = [
				new Static_wall(0, 700, FlxG.width + 300, 30, world),
				new Static_wall(0, 0, FlxG.width, 10, world),
				new Static_wall(0, 0, 10, FlxG.height + 200, world),
				new Static_wall(640, -150, 10, FlxG.height, world),
				new Static_wall(250, 0, 100, 500, world),
				new Static_wall(950, 300, 30, 500, world),
				new Dynamic_ball(450, 300, 60, world)
			];
			
			for each(var b:Base_block in world_blocks) {
				add_to_game(b);
			}
		}
		
		private function add_to_game(b:Base_block) {
			game_obj.add(b);
			this.add(b);
		}
		
		private function init_game_sys() {
			FlxG.mouse.show();
			FlxG.bgColor = FlxG.WHITE;
			
			var gravity:b2Vec2 = new b2Vec2(0, 14);
			world = new b2World(gravity, true);
			
			Common.init_debug_draw(Main.DEBUG_SPRITE, world);
		}
		
		private function get_cam():FlxCamera {
			var cam:FlxCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
			cam.follow(player_obj.members[0]);
			cam.deadzone = new FlxRect(FlxG.width / 2 - 100, FlxG.height / 2 - 100, 200, 200);
			var b_r:Rectangle = Common.get_bounds(game_obj);
			cam.setBounds(b_r.x, b_r.y, b_r.width, b_r.height);
			return cam;
		}
		
		private var debug_scroll_rect:Rectangle = new Rectangle(0, 0, 650, 600);
		
		private function draw_b2_debug() {
			Main.DEBUG_SPRITE.graphics.clear();
			world.DrawDebugData();
			debug_scroll_rect.x = cam.scroll.x;
			debug_scroll_rect.y = cam.scroll.y;
			Main.DEBUG_SPRITE.scrollRect = debug_scroll_rect;
		}

		
	}
	
}