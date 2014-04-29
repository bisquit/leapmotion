package objects
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Comet extends Sprite
	{
		
		[Embed(source="../assets/images/comet.png")]
		private var CometImg:Class;
		
		public var vx:Number;
		public var vy:Number;
		public var acceleration:Number = 0.3;
		public var point:Number = 50;
		public var delete_flag:Boolean = false;
		
		public function Comet(W:Number, H:Number)
		{
			var comet_img:Bitmap = new CometImg();
			comet_img.scaleX = comet_img.scaleY = 0.3;
			comet_img.x = -comet_img.width/2;
			comet_img.y = -comet_img.height/2;
			addChild(comet_img);
			
			var x_min:Number = W / 3 + comet_img.width / 2;
			var x_max:Number = W - comet_img.width / 2;
			var y_min:Number = 0;
			var y_max:Number = 0;
			
			this.x = int( Math.random() * (x_max - x_min + 1) ) + x_min;
			this.y = int( Math.random() * (y_max - y_min + 1) ) + y_min;
			
			var vx_min:Number = -3;
			var vx_max:Number = -1;
			var vy_min:Number = 3;
			var vy_max:Number = 3;
			
			this.vx = int( Math.random() * (vx_max - vx_min + 1) ) + vx_min;
			this.vy = int( Math.random() * (vy_max - vy_min + 1) ) + vy_min;
		}
	}
}