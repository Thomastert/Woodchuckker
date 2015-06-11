package Entities 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Thomas
	 */
	public class Bullet extends GameSprite 
	{
		
		private var BulletArt:Class;
		private var speed:Point;
		private var max_speed:Number;
		public var life:Number;
		[Embed(source="../../sounds/Shoot.mp3")]
		private var pew:Class;
		private var sound:Sound;
		
		
		public function Bullet(x:int, y:int, life:Number, angle:Number = 0) 
		
		{
			super(x, y, 10, 10, angle);
			max_speed = 15;
			image = new BitmapData(width, height, false, 0x000000);
			this.speed = new Point(max_speed*Math.sin(angle), -max_speed*Math.cos(angle));
			this.life = life;
			this.angle = angle;
			
			sound = new pew;
			sound.play();
		}
		override public function Render():void 
		{
			
			Game.Renderer.copyPixels(image, new Rectangle(0, 0, width, height), new Point(x, y));
			super.Render();			
		}
		override public function Update():void 
		{
			
			x += speed.x;
			y += speed.y;	
			
			if (x + width <= 0)
				x = Game.Renderer.width - width;
			else if(x >= Game.Renderer.width)
				x = 0;
				
			if (y + height <= 0)
				y = Game.Renderer.height - height;
			else if(y >= Game.Renderer.height)
				y = 0;
			
			super.Update();
			
		}
		
	}

}