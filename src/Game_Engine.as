package {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.flixel.*;
	import Box2D.Dynamics.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.*;
	
	public class Game_Engine extends FlxState {
		
		var world:b2World;
		var player_ball:B2Circle;
		var contact_listener:Contact_listener;
		var cur_rad:Number = 10;
		
		public override function create():void {
			super.create();
			FlxG.mouse.show();
			FlxG.bgColor = FlxG.WHITE;
			var gravity:b2Vec2 = new b2Vec2(0, 5);
			world = new b2World(gravity, true);
			
			player_ball = new B2Circle(FlxG.width/2, FlxG.height/2, cur_rad, world);
			
			world.SetContactListener(contact_listener = new Contact_listener);
			
			this.add(player_ball);
			this.add(new B2FlxTileblock(0, 550, 650, 100, world));
			
			debug_draw();
		}
		
		private function debug_draw() {
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			
			dbgDraw.SetSprite(Main.DEBUG_SPRITE);
			
			dbgDraw.SetDrawScale(30);
			dbgDraw.SetAlpha(1);
			dbgDraw.SetFillAlpha(0.5);
			dbgDraw.SetLineThickness(1);
			//dbgDraw.m_drawFlags=b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit|b2DebugDraw.e_coreShapeBit|b2DebugDraw.e_aabbBit|b2DebugDraw.e_obbBit|b2DebugDraw.e_pairBit|b2DebugDraw.e_centerOfMassBit;
			dbgDraw.AppendFlags(b2DebugDraw.e_shapeBit);
			dbgDraw.AppendFlags(b2DebugDraw.e_jointBit);
			//dbgDraw.AppendFlags(b2DebugDraw.e_aabbBit);
			dbgDraw.AppendFlags(b2DebugDraw.e_centerOfMassBit);
			world.SetDebugDraw(dbgDraw);
			
			
			Main.DEBUG_SPRITE.graphics.beginFill(0x000000);
			Main.DEBUG_SPRITE.graphics.drawRect(0, 0, 20, 20);
			//Main.main_ref.stage.addChild(m_sprite);
		}
		
		var mouse_down:Boolean = false;
		var pt_1:Point;
		
		public override function update():void {
			super.update();
			Main.DEBUG_SPRITE.graphics.clear();
			world.DrawDebugData();
			
			world.Step(0.025, 10, 10);
			
			if (FlxG.keys.justReleased("SPACE")) {
				Main.DEBUG_SPRITE.visible = !Main.DEBUG_SPRITE.visible;
			}
			
			if (FlxG.mouse.pressed() && !mouse_down) {
				mouse_down = true;
				pt_1 = new Point(FlxG.mouse.x, FlxG.mouse.y);
			} else if (!FlxG.mouse.pressed() && mouse_down && pt_1) {
				mouse_down = false;
				if (pt_1.x < FlxG.mouse.x && pt_1.y < FlxG.mouse.y) {
					this.add(new B2FlxTileblock(pt_1.x, pt_1.y, FlxG.mouse.x - pt_1.x, FlxG.mouse.y - pt_1.y, world));
				}
				pt_1 = null;
			}
			
			var pos:b2Vec2 = player_ball._obj.GetPosition();
			var av:Number = player_ball._obj.GetAngularVelocity();
			var lv:b2Vec2 = player_ball._obj.GetLinearVelocity();
			
			if (FlxG.keys.D) {
				player_ball._obj.SetAwake(true);
				player_ball._obj.SetAngularVelocity(Math.max(0, av + d2r(10)));
				lv.x = Math.max(lv.x+0.05,lv.x*.95);
				player_ball._obj.SetLinearVelocity(lv);
			} else if (FlxG.keys.A) {
				player_ball._obj.SetAwake(true);
				lv.x = Math.min(lv.x-0.05,lv.x*.95);
				player_ball._obj.SetAngularVelocity(Math.min(0, av - d2r(10)));
				player_ball._obj.SetLinearVelocity(lv);
			} else {
				player_ball._obj.SetAngularVelocity(av * 0.95);
			}
			
			if (FlxG.keys.W && contact_listener.contact) {
				player_ball._obj.SetAwake(true);
				player_ball._obj.SetLinearVelocity(new b2Vec2(lv.x, -6));
			}
			
			if (FlxG.keys.E || FlxG.keys.Q ) {
				this.remove(player_ball);
				world.DestroyBody(player_ball._obj);
				
				if (FlxG.keys.E && cur_rad != 1) {
					cur_rad -= 1;
				} else {
					cur_rad += 1;
				}
				player_ball = new B2Circle(FlxG.width/2, FlxG.height/2, cur_rad, world);
				this.add(player_ball);
			}
			
			if (m2p(pos.x) < 0 || m2p(pos.x) > FlxG.width || m2p(pos.y) < 0 || m2p(pos.y) > FlxG.height) {
				player_ball._obj.SetPosition(new b2Vec2(p2m(FlxG.width/2), p2m(FlxG.height/2)));
				player_ball._obj.SetAngularVelocity(0);
				player_ball._obj.SetLinearVelocity(new b2Vec2(0, 0));
			}
		}
		
		public static function d2r(d:Number):Number {
			return d * (Math.PI / 180);
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