package Entities
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas
	 */

	public class GameSprite
	{
	   
		public var x:Number;
		public var y:Number;
		public var width:int;
		public var height:int;
		public var angle:Number;
		public var rotate_offset:Point;
		public var visible:Boolean;

		protected var image:BitmapData;
		public var image_sprite:Sprite;
		
		public var collis_points:Array;

		public function GameSprite(x:Number, y:Number, width:int, height:int, angle:int=0)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.angle = angle;
			visible = true;
			collis_points = new Array(
			new Point(0, 0),
			new Point(width, 0),
			new Point(width, height),
			new Point(0, height)
			);
			rotate_offset = new Point(0, 0);
		}
		public function Render():void
		{            
		}
		public function Update():void
		{
			if (angle == 0)
			{
				collis_points = [
					new Point(x, y),
					new Point(x+width, y),
					new Point(x+width, y+height),
					new Point(x, y+height)			
				];
			}

			/*
			if (angle != 0)
			{
				//have to find the 4 corners of the collision box, and we'll subtract the rotate point so that the points will rotate around that instead of the top left/ origin
				var points:Array = [
					new Point(0-rotate_offset.x, 0-rotate_offset.y),
					new Point(width-rotate_offset.x, 0-rotate_offset.y),
					new Point(width-rotate_offset.x, height-rotate_offset.y),
					new Point(0-rotate_offset.x, height-rotate_offset.y)			
				];
				var points_trans:Array = new Array();
				//using the formula: x' = x*cos(angle)-y*sin(angle); y' = x*sin(angle)+y*cos(angle)  from: http://en.wikipedia.org/wiki/Rotation_(mathematics)
				for (var i:int = 0; i < points.length;i++ )
				{
					var x_trans:Number = points[i].x * Math.cos(angle) - points[i].y * Math.sin(angle);
					var y_trans:Number = points[i].x * Math.sin(angle) + points[i].y * Math.cos(angle);
					//have to add back in the location of the ship, and add back in the rotational offset from having to take it away earlier
					points_trans.push(new Point(x_trans+x+rotate_offset.x, y_trans+y+rotate_offset.y));
				}
				collis_points = points_trans;
			}
			else
			{
				collis_points = [
					new Point(x, y),
					new Point(x+width, y),
					new Point(x+width, y+height),
					new Point(x, y+height),					
				];
			}*/
		}     
		public function CheckIfInNonRotatedRect(obj2:GameSprite):Boolean
		{
			//we'll make sure that this object is a rentangle with no angle
			var intersecting:Boolean = false;
			if (obj2.angle == 0)
			{
				//first we check the top left point
				if (x >= obj2.x && x <= obj2.x + obj2.width)
					if (y >= obj2.y && y <= obj2.y + obj2.height)
						return true;
						
				//now we'll check the top right point
				if (x+width >= obj2.x && x+width <= obj2.x + obj2.width)
					if (y >= obj2.y && y <= obj2.y + obj2.height)
						return true;
				
				//now we check the bottom right point
				if (x+width >= obj2.x && x+width <= obj2.x + obj2.width)
					if (y+height >= obj2.y && y+height <= obj2.y + obj2.height)
						return true;
						
				//And check the bottom left point
				if (x >= obj2.x && x <= obj2.x + obj2.width)
					if (y+height >= obj2.y && y+height <= obj2.y + obj2.height)
						return true;						
			}
			
			return intersecting;
		}
		/*public function CheckRectIntersect(obj2:GameSprite):Boolean
		{
			var answer:Boolean = false;
			//http://stackoverflow.com/questions/115426/algorithm-to-detect-intersection-of-two-rectangles
			//we'll check if the object is intersecting the current object using the seperating axis theorem
			
			//first we need to get the vectors of the points making up the object- and performing rotations to find where the points are			
			//first step is we get all the edges by using the formula: edge = v(n) - v(n-1)
			var edges1:Array = new Array();
			for (var i:int = 0; i < collis_points.length; i++)
			{
				if(i!=collis_points.length-1)
					edges1.push(new Point(collis_points[i + 1].x - collis_points[i].x, collis_points[i + 1].y - collis_points[i].y));
				else
					edges1.push(new Point(collis_points[0].x - collis_points[i].x, collis_points[0].y - collis_points[i].y));					
			}
			
			
			var edges2:Array = new Array();
			for (var j:int = 0; j < obj2.collis_points.length; j++)
			{
				if(j!=obj2.collis_points.length-1)
					edges1.push(new Point(obj2.collis_points[j + 1].x - obj2.collis_points[j].x, obj2.collis_points[j + 1].y - obj2.collis_points[j].y));
				else
					edges1.push(new Point(obj2.collis_points[0].x - obj2.collis_points[j].x, obj2.collis_points[0].y - obj2.collis_points[j].y));					
			}
			
			//now we find the perpendicular of these edges using:
			//rotated.x = -unrotated.y; rotated.y =  unrotated.x
			var rotated1:Array = new Array();
			for (var k:int; k < edges1.length; k++)
				rotated1.push( -edges1[k].y, edges1[k].x);
			
			var rotated2:Array = new Array();
			for (var m:int; m < edges2.length; m++)
				rotated2.push( -edges2[m].y, edges2[m].x);
				
			//need to finish- now we need to do dot product to see what sign is on object	


			
			
			return answer;
		}*/
	}
}