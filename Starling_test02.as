package
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	[SWF(width = 1000, height = 750, frameRate = "60", backgroundColor = "#000000")]
	public class Starling_test02 extends MovieClip
	{
		
		public function Starling_test02()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Starlingの初期化
//			Starling.handleLostContext = true;
			var starling:Starling = new Starling(MainView, stage, null, null);
//			starling.enableErrorChecking = false;
			starling.start();
		}
	}
}

import flash.utils.setTimeout;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;

internal class MainView extends Sprite
{
	private var W:Number = 1000;
	private var H:Number = 750;
	private var sec_star:Number = 2000;
	private var starArr:Array = new Array();
	private var star_R:Number = 10;
	
	public function MainView()
	{
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init():void{
		
		// 背景の生成
		var bg:Quad = new Quad(W, H, 0x000000);
		addChild(bg);
		
		// sec_starおきに星を生成する関数を呼ぶ
		setTimeout(createStar, sec_star);
		
		addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
	}
	
	private function createStar():void{
		// 星を生成して配列に格納、addChild
		var star:Star = new Star(W, H, star_R);
		starArr.push(star);
		addChild(star);
		setTimeout(createStar, sec_star);
	}
	
	private function onEnterFrame(e:EnterFrameEvent):void{
		
		for(var i:uint = 0; i < starArr.length; i++){
			var s:Star = starArr[i];
			
			if(s.move_flag){
				// 加速度を速度に加算
				if(s.vx > 0){
					s.vx += s.acceleration;
				} else{
					s.vx -= s.acceleration;
				}
				s.vy += s.acceleration;
				s.x += s.vx;
				s.y += s.vy;
				
			}
			
			// 画面外に出たら消す処理
			if(s.x < -star_R || s.x > W + star_R || s.y < -star_R || s.y > H + star_R){
				starArr.splice(i, 1);
				removeChild(s);
			}
			
			// クリックされた(click_flag==trueだったら)時の処理
			if(s.click_flag == true){
				starArr.splice(i, 1);
				removeChild(s);
			}
		}
		
	}
}

class Star extends Sprite{
	
	public var vx:Number;
	public var vy:Number;
	public var acceleration:Number;
	public var point:Number;
	public var click_flag:Boolean = false;
	public var move_flag:Boolean = false;
	
	// 赤:50点 緑:10点 青:-10点
	private var colorArr:Array = [0xFF0000, 0x00FF00, 0x0000FF];
	private var pointArr:Array = [50, 10, -10];
	private var accelerationArr:Array = [0.25, 0.2, 0.15];
	
	public function Star(W:Number, H:Number, star_R:Number):void{
		
		var num_max:Number = colorArr.length - 1;
		var num_min:Number = 0;
		var num:Number = int( Math.random() * (num_max - num_min + 1) ) + num_min;
		
		// 四角形を生成
		var quad:Quad = new Quad(20, 20, colorArr[num]);
		addChild(quad);
		
		acceleration = accelerationArr[num];
		point = pointArr[num];
		
		// ----------------------------------------
		// 星がなるべく画面内を交差するようにvx,vyを調整
		var x_min:Number = star_R;
		var x_max:Number = W - star_R;
		var y_min:Number = star_R;
		var y_max:Number = H / 2 - star_R;
		
		this.x = int( Math.random() * (x_max - x_min + 1) ) + x_min;
		this.y = int( Math.random() * (y_max - y_min + 1) ) + y_min;
		
		var vx_min:Number;
		var vx_max:Number;
		var vy_min:Number = 3;
		var vy_max:Number = 2;
		
		if(this.x <= W / 2){
			vx_min = 1;
			vx_max = 3;
		} else{
			vx_min = -3;
			vx_max = -1;
		}
		
		this.vx = int( Math.random() * (vx_max - vx_min + 1) ) + vx_min;
		this.vy = int( Math.random() * (vy_max - vy_min + 1) ) + vy_min;
		// ----------------------------------------
		
		// 星が生成されてから1秒後に動き始めるようにする
		setTimeout(starMove, 1000);
		
		// 星を動き始めるようにする関数
		function starMove():void {
			move_flag = true;
		}
	}
}