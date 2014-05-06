﻿package  phase {	import flash.display.Bitmap;	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Point;	import flash.text.TextField;	import flash.utils.getQualifiedClassName;	import flash.utils.setTimeout;		import a24.tween.Tween24;		import core.Mediator;	import core.PhaseManager;		import objects.Comet;	import objects.Dust;	import objects.MultiText;	import objects.PopupText;	import objects.Star;	import objects.Star04;	import objects.TimerField;	import objects.UFO;		import phase.IPhase;	import leap.LeapSystem;		public class GamePhase extends Sprite implements IPhase{				private var count:int;		private var stageWidth:int;		private var stageHeight:int;		private var star_R:int;				private var timer:TimerField;		private var lastMulti:int = 1;		private var multiplier:int = 1;				private var samp:Bitmap;				private var div:Number;				[Embed(source="../assets/images/sample.png")]		private var SampleImg:Class;				public function GamePhase() {			count = 0;			stageWidth = Mediator._stage.stageWidth;			stageHeight = Mediator._stage.stageHeight;			star_R = 20;		}				public function start():void {			trace("game start");			Mediator._stage.addChild(this);			Mediator._stage.setChildIndex(Mediator._player, Mediator._stage.numChildren - 1);			Mediator.currentPhase = "game";						/* オブジェクトの生成と初期配置 */			samp = new SampleImg();			samp.x = -samp.width;			samp.y = Mediator.stageHeight - samp.height;						timer = new TimerField();			timer.x = Mediator.stageWidth - 400;			timer.y = 50;						Mediator._score.x = 120;			Mediator._score.y = 50;						/* オブジェクトの追加　重なり順に注意する*/			addChild(Mediator._score);			addChild(timer);			addChild(samp);						timerStart();						/* オブジェクトのトゥイーン　終了と同時にタイマーをスタートさせる */			/*Tween24.serial(				Tween24.tween(samp, 2).x(80)   			).play();*/		}				private function timerStart():void {			timer.start(30);			addEventListener(Event.ENTER_FRAME, onFrame);		}				private function onFrame(e:Event):void {						// 残り時間に応じて星の出現数を制限			if(timer.time > 10){				div = 50;			} else{				div = 10;			}						if(count %div === 0){				var random_value:Number = Math.random();				if(random_value > 0.8) {					createComet();				} else if(random_value < 0.2) {					createUFO();				} else {					createStar();					}			}						count++;						// dustのアニメーション			for(var i:uint=0; i < Mediator.dustArr.length; i++){								var d:Dust = Mediator.dustArr[i];								// dustの拡大縮小				if(d.scaleX >= 1) {					d.scale_v = -0.2;				} else if(d.scaleX <= 0) {					d.scale_v = 0.2;				}				d.scaleX += d.scale_v;				d.scaleY += d.scale_v;								d.counter++;				d.bezier_trace();								if(d.counter == d.divNum) {					removeChild(d);					Mediator.dustArr.splice(i, 1);					d = null;					if(i === 0){						Mediator._score.changeScore(); // 複数回呼ばれてしまうしUFOの時にも呼ばないと　あとで直す					}									}			}					}				public function afterCatch(info:Object = null):void {			createDust(info);			popupMulti(info.combo);			popupPoint(info.totalPoint);		}				private function createStar():void {			var star:Star04 = new Star04(stageWidth, stageHeight);			Mediator.debArr.push(star);			addChild(star);		}				private function createComet():void {			var comet:Comet = new Comet(stageWidth, stageHeight);			Mediator.debArr.push(comet);			addChild(comet);		}				private function createUFO():void {			var ufo:UFO = new UFO(stageWidth, stageHeight);			Mediator.debArr.push(ufo);			addChild(ufo);		}				public function createDust(info):void {						var colStarClass:String = info.name as String;			var dust_num:Number = 0;						if(colStarClass == "star"){				dust_num = 10;			} else if(colStarClass == "comet"){				dust_num = 50;			}						for(var i:uint = 0; i < dust_num; i++){				var d:Dust = new Dust(info.x, info.y);				Mediator.dustArr.push(d);				addChild(d);			}		}				private function popupMulti(_combo:int):void {			multiplier = Math.floor(_combo * 0.2) + 1;			if(lastMulti < multiplier){				var popup:MultiText = new MultiText(multiplier);				popup.x = Mediator.stageWidth / 2;				popup.y = Mediator.stageHeight - 500;				addChild(popup);				popup.animate();								lastMulti = multiplier;			} else if (lastMulti > multiplier){				lastMulti = 1;			}		}				private function popupPoint(_point:int):void {			var popup:PopupText = new PopupText(_point * multiplier);			popup.x = Mediator._player.x + 75;			popup.y = Mediator._player.y - 40;			addChild(popup);			popup.animate();		}				public function end():void {			trace("time over");			/* いったんループを止める */			LeapSystem.dispose();			Mediator.dispose();						PhaseManager.nextPhase();		}				public function destroy():void {			trace("game destroy");			removeEventListener(Event.ENTER_FRAME, onFrame);			removeChildren();			timer.destroy();			timer = null;			Mediator._stage.removeChild(this);		}	}	}