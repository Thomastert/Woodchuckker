package 
{
	import flash.media.Sound;
	import Entities.Asteroid;
	import Entities.Bullet;
	import Entities.Explosion;
	import Entities.Ship;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import UI.Screen;
	
	/**
	 * ...
	 * @author Thomas
	 *
	 */

	public class Game
	{
		public var bitmap:Bitmap;
		public static var Renderer:BitmapData;
		private var ship:Ship
		private var keys_down:Array;
		private var keys_up:Array;
		private const LEFT:int = 37;
		private const UP:int = 38;
		private const RIGHT:int = 39;
		private const DOWN:int = 40;
		private const SPACE:int = 32;	
		private const P:int = 80;
		private const R:int = 82;
		private const ESC:int = 27;
		public static var current_time:Number;
		private var bullets:Array;
		private var firing_delay:Number;
		private var last_fired:Number;
		private var bullets_max_life:Number;
		private var asteroids:Array;
		
		[Embed(source="../sounds/split2.mp3")]
		private var death:Class;
		private var sound:Sound;
		[Embed(source="../sounds/death.mp3")]
		private var hitsound:Class;
		private var explosions:Array;
		private var score_txt:TextField;
		private var score:int;
		private var level_txt:TextField;
		private var level:int;
		private var game_over_txt:TextField;
		private var game_over:Boolean;
		private var lives:int;
		private var starting_lives:int;
		private var death_delay:Number;
		private var level_change_timer:Number;
		private var level_change_delay:Number;
		public var ship_start:Point;
		public var state:int;
		public const MAIN_MENU:int = 0;
		public const PLAYING:int = 3;
		public const PAUSED:int = 4;
		
		
		private var main_menu_screen:Screen;
		private var paused_screen:Screen;
		
		public static var mouse_down:Boolean;
		public static var mouse_click:Boolean;
		public static var mouse_pos:Point;		
		
		
		[Embed(source="resources/images/Background.png")]
		private var tex_background:Class;
		private var background:Bitmap;
		
		[Embed(source="resources/images/lumberjack.jpg")]
		private var tex_menu_bg:Class;
		
		[Embed(source="resources/images/button2.png")]
		private var tex_btn_start_game1:Class;
		
		[Embed(source = 'resources/images/button1.png')]
		private var tex_btn_start_game2:Class;
		

		public function Game(stageWidth:int, stageHeight:int)
		{
			trace("Kappa");
			current_time = getTimer();
			Renderer = new BitmapData(stageWidth, stageHeight, false, 0x000000);
			bitmap = new Bitmap(Renderer);

			ship_start = new Point(Renderer.width / 2 - 10, Renderer.height / 2 - 15);
			ship = new Ship(ship_start.x, ship_start.y, 20, 30);
			
			keys_down = new Array();
			keys_up = new Array();
			bullets = new Array();
			firing_delay = 125;
			last_fired = 0;
			bullets_max_life = 1000;
			
			asteroids = new Array();
			explosions = new Array();
			
			score_txt = new TextField();
			score_txt.width = 700;
			var format:TextFormat = new TextFormat("Courier", 40, 0x000000, true);
			score_txt.x = 20;
			score_txt.y = 10;
			score_txt.defaultTextFormat = format;
			score = 0;
			score_txt.text = String(score);
			
			game_over_txt = new TextField();
			game_over_txt.width = Renderer.width;
			var format2:TextFormat = new TextFormat("Courier", 40, 0x000000, true);
			format2.align = "center";
			game_over_txt.x = 0;
			game_over_txt.y = Renderer.height / 2 - 20;
			game_over_txt.defaultTextFormat = format2;
			game_over_txt.text = "Game Over, Press R to restart";
			game_over = false;
			
			starting_lives = 4;
			lives = starting_lives;
			death_delay = 2000;
			
			level_change_delay = 500;
			level_change_timer = 0;
			
			level_txt = new TextField();
			level_txt.width = 700;
			level_txt.defaultTextFormat = format;
			level_txt.x = 20;
			level_txt.y = 65;
			level_txt.text = "Lvl " + level;
			
			level = 1;
			
			
			var temp_menu_bg:Bitmap = new tex_menu_bg();
			var temp_bitmap1:Bitmap = new tex_btn_start_game1();
			var temp_bitmap2:Bitmap = new tex_btn_start_game2();
			
			main_menu_screen = new Screen(0, 0, Renderer.width, Renderer.height,false, 0x000000, true, temp_menu_bg.bitmapData);
			
			main_menu_screen.AddImageButton(
			Renderer.width / 2 - -90, 70, 
			temp_bitmap1.bitmapData, temp_bitmap2.bitmapData,
			StartGame);
			
			var format3:TextFormat = new TextFormat("Courier", 20, 0xFFFFFF, true);
			format3.align = "center";
			
			
			
			mouse_down = false;
			mouse_click = false;
			mouse_pos = new Point(0, 0);
			
			state = MAIN_MENU;
			
			background = new tex_background();
		}
		public function ShowMainMenu():void
		{
			state = MAIN_MENU;
		}
		public function StartGame():void
		{
			state = PLAYING;
			LoadLevel(1);
		}
		public function LoadLevel(num:int):void
		{
			if (num == 1)
			{
				score = 0;
				score_txt.text = String(score);
				lives = starting_lives;				
			}
			
			game_over = false;
			ResetShip();
			asteroids = new Array();
			bullets = new Array();
			explosions = new Array();
			level = num;
			//level_txt.text = "Lvl " + level;
			asteroids.push(new Asteroid(Renderer.width / 5, 2 * Renderer.height / 3, 0, 0, 1));
			
		}
		public function Render():void
		{
			
			Renderer.lock();
			Renderer.fillRect(new Rectangle(0, 0, Renderer.width, Renderer.height), 0x000000);
			Renderer.copyPixels(background.bitmapData, new Rectangle(0, 0, background.width, background.height), new Point(0, 0));

			if (state == PLAYING || state == PAUSED)
			{

				if(state!=PAUSED)
					ship.Render();
					
				for (var i:int = 0; i < bullets.length; i++)
					bullets[i].Render();
					
				for (var j:int = 0; j < asteroids.length; j++)
					asteroids[j].Render();

				for (var k:int = 0; k < explosions.length; k++)
					explosions[k].Render();

				Renderer.draw(score_txt, new Matrix(1, 0, 0, 1, score_txt.x , score_txt.y ));
				//Renderer.draw(level_txt, new Matrix(1, 0, 0, 1, level_txt.x , level_txt.y ));
				
				for (var p:int = 0; p < lives; p++)
					Game.Renderer.draw(ship.image_sprite, new Matrix(1,0,0,1,score_txt.x+(ship.width+2)*p, 35));
				if (game_over)
					Renderer.draw(game_over_txt, new Matrix(1, 0, 0, 1, game_over_txt.x , game_over_txt.y ));

				if (state == PAUSED)
					paused_screen.Render(Renderer);
			}
			else if (state == MAIN_MENU)
				main_menu_screen.Render(Renderer);
			Renderer.unlock();
		}

		public function Update():void
		{
			current_time = getTimer();
			
			if (state == PLAYING)
			{
				if (CheckKeyUp(ESC))
					state = MAIN_MENU;
				if (CheckKeyUp(P))
					state = PAUSED;
				if (CheckKeyUp(R))
				{
					LoadLevel(1);
					keys_up = new Array();
					return;
				}
			
				if (ship.visible)
				{			
					if (CheckKeyDown(LEFT))			
						ship.RotateLeft();
					
					if (CheckKeyDown(RIGHT))
						ship.RotateRight();
						
					if (CheckKeyDown(UP))
						ship.Thrust(1);
					if (CheckKeyDown(DOWN))
						ship.Thrust( -1);				
						
					if (CheckKeyDown(SPACE) && current_time-last_fired > firing_delay)
					{
						var x:int = 0 * Math.cos(ship.angle) + ship.rotate_offset.y * Math.sin(ship.angle)+ship.x+ship.rotate_offset.x;
						var y:int = 0 * Math.sin(ship.angle) - ship.rotate_offset.y * Math.cos(ship.angle)+ship.y+ship.rotate_offset.y;
						
						bullets.push(new Bullet(x, y, current_time, ship.angle));
						last_fired = current_time;
					}					
					ship.Update();
				}
				else if (CheckKeyDown(R))
				{					
					LoadLevel(1);
				}
				

				var bullets_to_delete:Array = new Array();
				for (var i:int = 0; i < bullets.length; i++)
				{
					bullets[i].Update();
					if (current_time-bullets[i].life > bullets_max_life)
					{
						bullets_to_delete.push(i);
						continue;
					}
						
					var asteroid_hit:int = -1;
					for (var i2:int = 0; i2 < asteroids.length;i2++)
						if (bullets[i].CheckIfInNonRotatedRect(asteroids[i2]))
						{
							asteroid_hit = i2;
							break;
						}
					if (asteroid_hit != -1)
					{
						DestroyAsteroid(asteroid_hit);
						bullets_to_delete.push(i);
						
						sound = new death;
						sound.play();
					}
				}
				for (var j:int = 0; j < bullets_to_delete.length;j++ )
				{
					bullets.splice(bullets_to_delete[j], 1);
				}		
				var asteroid_ship_hit:int = -1;
				for (var k:int = 0; k < asteroids.length; k++ )
				{
					asteroids[k].Update();
					if (ship.CheckIfInNonRotatedRect(asteroids[k]))
					{
						asteroid_ship_hit = k;
						break;
					}				
				}
				if (asteroid_ship_hit != -1)
				{
					lives--;
					ship.visible = false;
					explosions.push(new Explosion(ship.x, ship.y, 1500,2));
					explosions.push(new Explosion(ship.x, ship.y, 500));
					DestroyAsteroid(asteroid_ship_hit);
					
						sound = new hitsound;
						sound.play();
					
					if (lives > 0)
						ship.ship_death_time = current_time;
					else
					{
						game_over = true;
					}
				}
					
				var explosions_to_delete:Array = new Array();
				for (var m:int = 0; m < explosions.length;m++ )
					if (current_time-explosions[m].life > explosions[m].max_life)
						explosions_to_delete.push(m);
				for (var n:int = 0; n < explosions_to_delete.length; n++)
					explosions.splice(explosions_to_delete[n], 1);
					
				if (ship.ship_death_time != 0)
					if (current_time-ship.ship_death_time > death_delay)
					{
						ResetShip();					
					}
				if (asteroids.length == 0 && !game_over&&level_change_timer==0)
					level_change_timer = current_time;
					
				if(level_change_timer!=0)
					if (current_time-level_change_timer > level_change_delay)
					{
						
						level++;
						LoadLevel(level);
						level_change_timer = 0;
						trace("loading level " + level);
					}
			}
			else if (state == MAIN_MENU)			
				main_menu_screen.Update();
			
			else if (state == PAUSED)
			{
				if (CheckKeyUp(P))
					state = PLAYING;
			}
			
			mouse_click = false;		
			keys_up = new Array();
		}
		public function ResetShip():void
		{
			ship.visible = true;
			ship.angle = 0;
			ship.x = ship_start.x;
			ship.y = ship_start.y;
			ship.speed.x = 0;
			ship.speed.y = 0;
			ship.ship_death_time = 0;
			ship.width = 0.1;
		}
		public function DestroyAsteroid(asteroid_hit:int):void
		{
			score += Asteroid.Scores[asteroids[asteroid_hit].size];
			score_txt.text = String(score);
			explosions.push(new Explosion(
			asteroids[asteroid_hit].x + asteroids[asteroid_hit].width / 2,
			asteroids[asteroid_hit].y + asteroids[asteroid_hit].height / 2, 1000, asteroids[asteroid_hit].width/4));	
			
			var old_asteroid:Asteroid = asteroids[asteroid_hit];
			if (old_asteroid.size != Asteroid.Sizes.length - 1)
			{
				
				var rand_dir:int = Math.floor(Math.random() * (1 + Asteroid.Directions.length - 1 ));
				
				var rand_dir2:int = rand_dir - 2;
				if (rand_dir - 2 < 0)
					rand_dir2 = rand_dir + 2;
				
				var rand_type:int = Math.floor(Math.random() * (1 + Asteroid.Types.length - 1 ));
				var rand_type2:int = Math.floor(Math.random() * (1 + Asteroid.Types.length - 1 ));
				
				asteroids.push(new Asteroid(
				old_asteroid.x, 
				old_asteroid.y, 
				old_asteroid.size + 1, 
				rand_dir, 
				rand_type));
				
				asteroids.push(new Asteroid(
				old_asteroid.x, 
				old_asteroid.y, 
				old_asteroid.size + 1, 
				rand_dir2, 
				rand_type2));
			}
			asteroids.splice(asteroid_hit, 1);
		}
		public function KeyUp(e:KeyboardEvent):void
		{
			trace(e.keyCode);
			var key_pos:int = -1;
			for (var i:int = 0; i < keys_down.length; i++)
				if (e.keyCode == keys_down[i])
				{
					key_pos = i;
					break;
				}
			if(key_pos!=-1)
				keys_down.splice(key_pos, 1);		
				
			keys_up.push(e.keyCode);
		}
		
		public function KeyDown(e:KeyboardEvent):void
		{
			var key_down:Boolean = false;
			for (var i:int = 0; i < keys_down.length; i++)
				if (keys_down[i] == e.keyCode)
					key_down = true;
			

			if (!key_down)
				keys_down.push(e.keyCode);			
		}
		
		public function CheckKeyDown(keycode:int):Boolean
		{
			var answer:Boolean = false;
			for (var i:int = 0; i < keys_down.length; i++)
				if (keys_down[i] == keycode)
				{
					answer = true;
					break;
				}
			return answer;
		}
		public function CheckKeyUp(keycode:int):Boolean
		{
			var answer:Boolean = false;
			for (var i:int = 0; i < keys_up.length; i++)
				if (keys_up[i] == keycode)
				{
					answer = true;
					break;
				}
			return answer;
		}
		public function MoveMouse(e:MouseEvent):void 
		{
			mouse_pos.x = e.stageX;
			mouse_pos.y = e.stageY;
		}
		public function MouseDown(e:MouseEvent):void
		{
			mouse_down = true;
		}
		public function MouseUp(e:MouseEvent):void
		{
			mouse_down = false;
			mouse_click = true;
		}
	}
}