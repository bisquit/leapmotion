package
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	[SWF(width = 1000, height = 750, frameRate = "60", backgroundColor = "#000000")]
	public class LeapMotionGame_Starling extends MovieClip
	{
		
		public function LeapMotionGame_Starling()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Starling.handleLostContext = true;
			var starling:Starling = new Starling(MainView, stage, null, null);
			starling.enableErrorChecking = false;
			starling.start();
		}
	}
}

import flash.geom.Rectangle;
import flash.utils.setTimeout;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.ResizeEvent;
import starling.extensions.PDParticleSystem;
import starling.textures.Texture;

internal class MainView extends Sprite
{
	private var starArr:Array = new Array();
	// 星が出現する間隔
	private var sec_star:Number = 2000;
	
	public function MainView()
	{
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	private function addedToStageHandler(event:Event):void
	{
		// sec_starおきに星を生成する関数を呼ぶ
		setTimeout(createStar, sec_star);
		
		stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
	}
	
	private function createStar():void{
		var star:Star = new Star();
		starArr.push(star);
		addChild(star);
		// 星の出現する間隔を徐々に短くする処理
		sec_star -= 50;
		setTimeout(createStar, sec_star);
	}
	
	private function stage_resizeHandler(event:ResizeEvent):void
	{
		Starling.current.viewPort = new Rectangle(0, 0, event.width, event.height);
		stage.stageWidth = event.width;
		stage.stageHeight = event.height;
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
			if(s.x < -10 || s.x > stage.stageWidth + 10 || s.y < -10 || s.y > stage.stageHeight + 10){
				starArr.splice(i, 1);
				removeChild(s);
			}
			
		}
	}
}

internal class Star extends Sprite{
	
	public var vx:Number;
	public var vy:Number;
	public var point:Number;
	public var acceleration:Number;
	public var click_flag:Boolean = false;
	public var move_flag:Boolean = false;
	
	private var pexArr:Array = ["particle/particle.pex", "particle/particle.pex", "particle/particle.pex"];
	private var pointArr:Array = [50, 10, -10];
	private var accelerationArr:Array = [0.25, 0.2, 0.15];
	
	[Embed(source = "particle/particle.pex", mimeType = "application/octet-stream")]
	private static var ParticleData:Class;
	
	[Embed(source = "particle/texture.png")]
	private static var ParticleImage:Class;
	
	private var star:PDParticleSystem;
	
	public function Star():void{
		
		var num_max:Number = pexArr.length - 1;
		var num_min:Number = 0;
		var num:Number = int( Math.random() * (num_max - num_min + 1) ) + num_min;
		
		star = new PDParticleSystem(
			XML(new ParticleData()),
			Texture.fromBitmap(new ParticleImage())
		);
		
		// ----------------------------------------
		// 星がなるべく画面内を交差するようにvx,vyを調整
		// 今回はstageWidth=700,stageHeigh=500で実装
		var x_min:Number = 50;
		var x_max:Number = 1000 - 50;
		var y_min:Number = 50;
		var y_max:Number = 750 / 2 - 50;
		
		this.x = int( Math.random() * (x_max - x_min + 1) ) + x_min;
		this.y = int( Math.random() * (y_max - y_min + 1) ) + y_min;
		
		var vx_min:Number;
		var vx_max:Number;
		var vy_min:Number = 3;
		var vy_max:Number = 2;
		
		if(this.x <= 1000 / 2){
			vx_min = 1;
			vx_max = 3;
		} else{
			vx_min = -3;
			vx_max = -1;
		}
		
		this.vx = int( Math.random() * (vx_max - vx_min + 1) ) + vx_min;
		this.vy = int( Math.random() * (vy_max - vy_min + 1) ) + vy_min;
		// ----------------------------------------
		
		this.acceleration = accelerationArr[num];
		this.point = pointArr[num];
		star.start();
		Starling.juggler.add(star);
		addChild(star);
		
		// 星が生成されてから1秒後に動き始めるようにする
		setTimeout(starMove, 1000);
		
		// 星を動き始めるようにする関数
		function starMove():void {
			move_flag = true;
		}
	}
}