package UI 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas
	 */
	public class UI_element 
	{
		public var x:Number;
		public var y:Number;
		public var width:int;
		public var height:int;
		
		public var background:Boolean = false;
		public var bg_color:uint;
		
		public var visible:Boolean;
		
		public var image:BitmapData;
		
		public function UI_element(x:Number=0, y:Number=0, width:int=10, height:int=10, background:Boolean=true, bg_color:uint=0x888888) 
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.background = background;
			this.bg_color = bg_color;
			this.visible = true;
			if(background)
				image = new BitmapData(width, height, false, bg_color);
			else
				image = new BitmapData(width, height, true, bg_color);

		}
		public function Render(Renderer:BitmapData):void
		{
			if (!visible)
				return;
			
			if (background)
				image.fillRect(new Rectangle(0, 0, width, height), bg_color);
				
			Renderer.copyPixels(image, new Rectangle(0, 0, width, height), new Point(x, y));
			
		}
		public function Update():void
		{
			
		}
		
	}

}