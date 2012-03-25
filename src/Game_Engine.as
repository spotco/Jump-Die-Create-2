package {
	import blocks.*;
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
		
		public override function create():void {
			super.create();
			init_game_sys();
			init_game_obj();
		}
		
		public override function update():void {
			super.update();
			Main.DEBUG_SPRITE.graphics.clear();
			world.DrawDebugData();
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
			var p1:Dynamic_box = new Dynamic_box(400, 20, 20, 20, world);
			p1.body.SetSleepingAllowed(false);
			p1.params.jump_force = 6;
			player_obj.add(p1);
			this.add(p1);
			
			var p2:Dynamic_ball = new Dynamic_ball(100, 50, 20, world);
			p2.body.SetSleepingAllowed(false);
			p2.params.jump_force = 17;
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
			
			var t:Static_wall = new Static_wall(250, 0, 100, 500, world);
			game_obj.add(t);
			this.add(t);
			
			var b:Dynamic_ball = new Dynamic_ball(450, 300, 60, world);
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

		
	}
	
}