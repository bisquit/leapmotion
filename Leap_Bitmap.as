package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(frameRate = "60", backgroundColor = "#000000")]
	public class Leap_Bitmap extends Sprite
	{		
		private var starArr:Array = new Array();
		
		public function Leap_Bitmap()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			for(var i:uint = 0; i<10; i++){
				var s:Star = new Star();
				starArr.push(s);
				addChild(s);
			}
		}
		
		private function onEnterFrame(e:Event):void{
			for(var i:uint=0; i < starArr.length; i++){
				var s:Star = starArr[i];
				s.counter++;
				s.bezier_trace();
				
				if(s.x < 0 && s.y < 0) {
					removeChild(s);
					starArr.splice(i, 1);
				}
			}
		}
	}
}

import flash.display.Bitmap;
import flash.display.Sprite;

class Star extends Sprite {
	
	[Embed(source='20100125-6.jpg', mimeType="image/jpeg")]
	private static const StarImg:Class;
	
	public var counter:Number;
	
	private var u:Number;
	private var divNum:Number;
	private var p0:Object = {x: 0, y: 0};
	private var p1:Object = {x: 0, y: 0};
	private var p2:Object = {x: 0, y: 0};
	private var p01:Object = {x: 0, y: 0};
	private var p12:Object = {x: 0, y: 0};
	private var p02:Object = {x: 0, y: 0};
	
	public function Star():void {
		init();
		bezier_init();
	}
	
	public function init():void {
		var starBmp:Bitmap = new StarImg();
		starBmp.scaleX = 0.1;
		starBmp.scaleY = 0.1;
		starBmp.x = - starBmp.width / 2;
		starBmp.y = - starBmp.height / 2;
		addChild(starBmp);
		
		this.x = mouseX;
		this.y = mouseY;
	}
	
	// ベジェ曲線の初期化
	public function bezier_init():void {
		u = 0;
		counter = 0;
		divNum = 50;
		p0.x = this.x;
		p0.y = this.y;
		
		// ここいじって色々試してみて！動きが変わるよ！
		p1.x = Math.floor(1800 * Math.random());
		p1.y = 1200;
		
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