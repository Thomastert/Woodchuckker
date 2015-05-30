package UI 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas
	 */
	public class ImageButton extends UI_element 
	{
		private var bg_image:BitmapData;
		private var bg_image_over:BitmapData;
		
		public var hovered:Boolean;
		public var clicked:Boolean;
		public var func:Function;
		
		public function ImageButton(x:Number = 0, y:Number = 0, bg_image:BitmapData=null, bg_image_over:BitmapData = null, func:Function=null):void
		{
			super(x, y, bg_image.width, bg_image.height);
			
			this.bg_image = bg_image;
			this.bg_image_over = bg_image_over;
			
			hovered = false;
			clicked = false;
			this.func = func;
		}
		override public function Render(Renderer:BitmapData):void 
		{
			if (!visible)
				return;
			if(!hovered||bg_image_over==null)
				Renderer.copyPixels(bg_image, new Rectangle(0, 0, width, height), new Point(x, y));
			else
				Renderer.copyPixels(bg_image_over, new Rectangle(0, 0, width, height), new Point(x, y));
		}
		override public function Update():void 
		{
			if (clicked)
			{
				trace("button Clicked!");
				if (func != null)
					func();
				clicked = false;
			}
			hovered = false;
		}
		
	}

}