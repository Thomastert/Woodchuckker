package UI 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Thomas
	 */
	public class TextButton extends UI_element 
	{
		public var bg_color2:uint;
		public var text:TextField;
		
		public var hovered:Boolean;
		public var clicked:Boolean;
		public var func:Function;
		
		public function TextButton(x:Number = 0, y:Number = 0, width:int = 10, height:int = 10, text_str:String="Button", format:TextFormat=null, background:Boolean = true, bg_color:uint = 0x333333, bg_color2:uint=0x666666, func:Function=null) 
		{
			super(x, y, width, height, background, bg_color);
			this.bg_color2 = bg_color2;
			
			text = new TextField();
			if (format == null)
			{
				format = new TextFormat("Arial", 20, 0x000000, true);
				format.align = "center";
			}
				
			text.width = width;
			text.height = height;
			text.defaultTextFormat = format;
			text.x = x;
			text.y = y;
			text.text = text_str
			
			hovered = false;
			clicked = false;
			this.func = func;
		}
		override public function Render(Renderer:BitmapData):void 
		{
			if (!visible)
				return;
			
			if (background)
			{
				if(!hovered)
					image.fillRect(new Rectangle(0, 0, width, height), bg_color);
				else
					image.fillRect(new Rectangle(0, 0, width, height), bg_color2);
			}
				
			image.draw(text, new Matrix(1, 0, 0, 1, 0 , 0 ));
				
			Renderer.copyPixels(image, new Rectangle(0, 0, width, height), new Point(x, y));
			//trace("button rendering");
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
			//super.Update();
		}
		
	}

}