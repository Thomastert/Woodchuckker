package Entities 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Thomas
	 */
	public class Asteroid extends GameSprite 
	{
		
		public static const Directions:Array = [Math.PI / 4, 3 * Math.PI / 4, 5 * Math.PI / 4, 7 * Math.PI / 4];
		public static const Sizes:Array = [40, 20, 15];
		public static const Speeds:Array = [1, 2, 4];
		public static const Types:Array = [0, 1];
		public static const Scores:Array = [20, 50, 100];
		
		private var type:int;
		private var direction:Number;
		private var speed:Point;
		public var size:int;
		
		[Embed(source = '../resources/images/asteroid1.png')]
		private var tex_asteroid1:Class;
		
		[Embed(source = '../resources/images/asteroid2.png')]
		private var tex_asteroid2:Class;
		
		public function Asteroid(x:int, y:int, size:Number, direction:Number, type:int)
		{
			super(x, y, Sizes[size], Sizes[size], 0);
			this.size = size;
			this.type = type;
			this.direction = direction = Directions[direction];
			this.speed = new Point( -Speeds[size] * Math.cos(direction), -Speeds[size] * Math.sin(direction));
			trace("speed asteroid, x, y = "+(-Speeds[size] * Math.cos(direction))+", "+(-Speeds[size] * Math.sin(direction))+", direction = "+direction );
			
			image_sprite = new Sprite();
			this.type = type;
			
			if (type == 0)
			{
				var temp_bitmap:Bitmap = new tex_asteroid1();
				temp_bitmap.width = temp_bitmap.height = Sizes[size];
				image_sprite.addChild(temp_bitmap);
				
			}
			else if (type == 1)
			{
				var temp_bitmap2:Bitmap = new tex_asteroid2();
				temp_bitmap2.width = temp_bitmap2.height = Sizes[size];
				image_sprite.addChild(temp_bitmap2);			
			}
			trace("size = "+Sizes[size]);
		}
		override public function Render():void 
		{
			
			
			var matrix:Matrix = new Matrix();
			matrix.translate(x, y);
			Game.Renderer.draw(image_sprite, matrix);
			
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