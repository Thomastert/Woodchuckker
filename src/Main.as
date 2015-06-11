package 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.display.MovieClip;


	/**
	 * ...
	 * @author Thomas
	 *
	 */
	
	public class Main extends Sprite 
	{
		private var game:Game;
		[Embed(source="../sounds/NotAsItSeems.mp3")]
		private var music:Class;
		private var sound:Sound;
		
		
		public function Main():void 
		{
			if (stage) init();
		}
		
		
		private function init(e:Event = null):void 
		{
			
			sound = new music;
			sound.play(50000, 9999);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point

			game = new Game(stage.stageWidth, stage.stageHeight);
			addChild(game.bitmap);
			addEventListener(Event.ENTER_FRAME, Run);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, game.KeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, game.KeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, game.MouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, game.MouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, game.MoveMouse);
			
		}
		private function Run(e:Event):void
		{
		   game.Update();
		   game.Render();            
		}	
	}	
}