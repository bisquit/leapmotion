﻿package  phase {	import flash.display.Sprite;	import phase.IPhase;	import core.Mediator;	import flash.events.Event;	import objects.Star03;	import objects.TimerField;	import core.PhaseManager;	import flash.display.Bitmap;	//import a24.tween.Tween24;		public class GamePhase extends Sprite implements IPhase{				private var count:int;		private var stageWidth:int;		private var stageHeight:int;		private var star_R:int;				private var timer:TimerField;				[Embed(source="../assets/images/sample.png")]		private var SampleImg:Class;				public function GamePhase() {			count = 0;			stageWidth = Mediator._stage.stageWidth;			stageHeight = Mediator._stage.stageHeight;			star_R = 20;		}				public function start():void {			trace("game start");			Mediator._stage.addChild(this);						/* オブジェクトの生成と初期配置 */			var samp:Bitmap = new SampleImg();			samp.x = -samp.width;			samp.y = Mediator.stageHeight - samp.height;						timer = new TimerField();			timer.x = 50;						Mediator._score.x = Mediator.stageWidth - 100;						/* オブジェクトの追加　重なり順に注意する*/			addChild(Mediator._player);			addChild(Mediator._score);			addChild(timer);			addChild(samp);						timerStart();						/* オブジェクトのトゥイーン　終了と同時にタイマーをスタートさせる */			/*var tween:Tween24 = Tween24.serial(				Tween24.tween(samp, 2).x(50)   			);						tween.onComplete(timerStart);			tween.play();*/		}				private function timerStart():void {			timer.start(10);			addEventListener(Event.ENTER_FRAME, onFrame);		}				private function onFrame(e:Event):void {						if(count %50 === 0){				createStar();			}						count++;						Mediator.update();					}				private function createStar():void {			var star:Star03 = new Star03(stageWidth, stageHeight, star_R);			Mediator.starArr.push(star);			addChild(star);		}				public function end():void {			trace("time over");			PhaseManager.nextPhase();		}				public function destroy():void {			trace("game destroy");			Mediator._stage.removeChild(this);		}	}	}