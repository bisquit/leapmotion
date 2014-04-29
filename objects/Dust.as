package objects
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Dust extends Sprite
	{
		[Embed(source="../assets/images/dust01.png")]
		private var Dust01Img:Class;
		
		[Embed(source="../assets/images/dust02.png")]
		private var Dust02Img:Class;
		
		[Embed(source="../assets/images/dust03.png")]
		private var Dust03Img:Class;
		
		[Embed(source="../assets/images/dust04.png")]
		private var Dust04Img:Class;
		
		[Embed(source="../assets/images/dust05.png")]
		private var Dust05Img:Class;
		
		public var counter:Number;
		
		private var u:Number;
		public var divNum:Number;
		private var p0:Object = {x: 0, y: 0};
		private var p1:Object = {x: 0, y: 0};
		private var p2:Object = {x: 0, y: 0};
		private var p01:Object = {x: 0, y: 0};
		private var p12:Object = {x: 0, y: 0};
		private var p02:Object = {x: 0, y: 0};
		
		public function Dust()
		{	
			init();
			bezier_init();
		}
		
		public function init():void {
			
			var rand_id:Number = Math.random();
			var dustBmp:Bitmap;
			
			if(rand_id <= 0.2){
				dustBmp = new Dust01Img();
			} else if(rand_id <= 0.4){
				dustBmp = new Dust02Img();
			} else if(rand_id <= 0.6){
				dustBmp = new Dust03Img();
			} else if(rand_id <= 0.8){
				dustBmp = new Dust04Img();
			} else {
				dustBmp = new Dust05Img();
			}
			
//			dustBmp.scaleX = 0.1;
//			dustBmp.scaleY = 0.1;
			dustBmp.x = - dustBmp.width / 2;
			dustBmp.y = - dustBmp.height / 2;
			addChild(dustBmp);
		}
		
		// ベジェ曲線の初期化
		public function bezier_init():void {
			u = 0;
			counter = 0;
			divNum = 50;
			p0.x = this.x;
			p0.y = this.y;
			
			// ここいじって色々試してみて！動きが変わるよ！
			p1.x = Math.floor(this.x - 200 + 700 * Math.random());
			p1.y = Math.floor(this.y - 200 + 700 * Math.random());
			
			p2.x = 0;
			p2.y = 0;
		}
		
		// ベジェ曲線の軌跡算出
		public function bezier_trace():void {
			u = ( 1.0 / divNum ) * counter;
			p01.x = ( 1.0 - u ) * p0.x + u * p1.x;
			p01.y = ( 1.0 - u ) * p0.y + u * p1.y;
			p12.x = ( 1.0 - u ) * p1.x + u * p2.x;
			p12.y = ( 1.0 - u ) * p1.y + u * p2.y;
			p02.x = ( 1.0 - u ) * p01.x + u * p12.x;
			p02.y = ( 1.0 - u ) * p01.y + u * p12.y;
			
			this.x = Math.floor( p02.x );
			this.y = Math.floor( p02.y );
		}
	}
}