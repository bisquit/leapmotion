package objects
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Star04 extends Sprite
	{
		public var vx:Number;
		public var vy:Number;
		public var acceleration:Number;
		public var point:Number = 10;
		public var delete_flag:Boolean = false;
		public var rot:Number;
		private var accelerationArr:Array = [0.25,0.2,0.15];
		
		[Embed(source="../assets/images/star.png")]
		private var StarImg:Class;
		
		[Embed(source="../assets/images/star_shadow.png")]
		private var StarShadowImg:Class;
		
		public var sp_star:Sprite;
		public var sp_shadow:Sprite;
		
		public function Star04(W:Number, H:Number)
		{
			// 初期化
			sp_star = new Sprite();
			sp_shadow = new Sprite();
			addChild(sp_shadow);
			addChild(sp_star);
			
			var star_img:Bitmap = new StarImg();
			star_img.scaleX = star_img.scaleY = 0.3;
			star_img.x = -star_img.width/2;
			star_img.y = -star_img.height/2
			sp_star.addChild(star_img);
			
			var shadow_img:Bitmap = new StarShadowImg();
			shadow_img.scaleX = shadow_img.scaleY = 0.3;
			shadow_img.x = -shadow_img.width / 2;
			shadow_img.y = -shadow_img.height / 2;
			sp_shadow.addChild(shadow_img);
			sp_shadow.x = sp_star.x + 10;
			sp_shadow.y = sp_star.y + 10;
			
			var num_max:Number = accelerationArr.length - 1;
			var num_min:Number = 0;
			var num:Number = int( Math.random() * (num_max - num_min + 1) ) + num_min;
			acceleration = accelerationArr[num];
			
			var x_min:Number = W / 3 + star_img.width/2;
			var x_max:Number = W - star_img.width/2;
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
			
			// 回転
			rot = 6.0 * Math.random() - 3.0;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			sp_star.rotation += rot;
			sp_shadow.rotation += rot;
		}
	}
}