package objects
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class UFO extends Sprite
	{
		[Embed(source="../assets/images/ufo.png")]
		private var UFOImg:Class;
		
		public var vx:Number;
		public var vy:Number;
		public var vx_max:Number = 5;
		public var vx_min:Number = -5;
		public var vy_max:Number = 0;
		public var vy_min:Number = -3;
		public var acceleration:Number = 0;
		public var point:Number = -10;
		public var delete_flag:Boolean = false;
		
		public function UFO(W:Number, H:Number)
		{
			var ufo_img:Bitmap = new UFOImg();
			ufo_img.scaleX = ufo_img.scaleY = 0.3;
			ufo_img.x = -ufo_img.width/2;
			ufo_img.y = -ufo_img.height/2;
			addChild(ufo_img);
			
			var x_min:Number = W / 3 + ufo_img.width / 2;
			var x_max:Number = W - ufo_img.width / 2;
			var y_min:Number = 0;
			var y_max:Number = 0;
			
			this.x = int( Math.random() * (x_max - x_min + 1) ) + x_min;
			this.y = int( Math.random() * (y_max - y_min + 1) ) + y_min;
			
			vx_min = -3;
			vx_max = -1;
			vy_min = 3;
			vy_max = 3;
			
			this.vx = int( Math.random() * (vx_max - vx_min + 1) ) + vx_min;
			this.vy = int( Math.random() * (vy_max - vy_min + 1) ) + vy_min;
		}
	}
}