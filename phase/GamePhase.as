﻿package  phase {	import flash.display.Bitmap;	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Point;	import flash.text.TextField;	import flash.utils.getQualifiedClassName;	import flash.utils.setTimeout;		import a24.tween.Tween24;		import core.Mediator;	import core.PhaseManager;		import objects.Comet;	import objects.Dust;	import objects.Star;	import objects.Star04;	import objects.TimerField;	import objects.UFO;		import phase.IPhase;	import leap.LeapSystem;	import objects.PopupText;	import leap.HandState;	import ranking.Camera_Ranking;	import core.SoundManager;		public class GamePhase extends Sprite implements IPhase{				private var count:int;		private var stageWidth:int;		private var stageHeight:int;		private var star_R:int;				private var timer:TimerField;		private var lastMulti:int = 1;		private var multiplier:int = 1;				private var samp:Bitmap;				private var div:Number;				[Embed(source="../assets/images/sample.png")]		private var SampleImg:Class;				public function GamePhase() {			count = 0;			stageWidth = Mediator._stage.stageWidth;			stageHeight = Mediator._stage.stageHeight;			star_R = 20;		}				public function start():void {			trace("game start");			Mediator._stage.addChild(this);			Mediator._stage.setChildIndex(Mediator._player, Mediator._stage.numChildren - 1);			Mediator.currentPhase = "game";						/* オブジェクトの生成と初期配置 */			samp = new SampleImg();			samp.x = -samp.width;			samp.y = Mediator.stageHeight - samp.height;						timer = new TimerField();			timer.x = Mediator.stageWidth/2;			timer.y = Mediator.stageHeight - 50;						Mediator._score.x = 100;			Mediator._score.y = 60;						/* オブジェクトの追加　重なり順に注意する*/			addChild(Mediator._score);			addChild(timer);			addChild(samp);						timerStart();						/* オブジェクトのトゥイーン　終了と同時にタイマーをスタートさせる */			/*Tween24.serial(				Tween24.tween(samp, 2).x(80)   			).play();*/		}				private function timerStart():void {			timer.start(30);			addEventListener(Event.ENTER_FRAME, onFrame);		}				private function onFrame(e:Event):void {						// 残り時間に応じて星の出現数を制限			if(timer.time >= 10){				div = 50;			} else{				div = 20;			}						if(count %div === 0){				var random_value:Number = Math.random();				if(random_value > 0.8) {					createComet();				} else if(random_value < 0.2) {					createUFO();				} else {					createStar();					}			}						count++;					}				public function afterCatch(info:Object = null):void {			createDust(info);			popupMulti(info.combo);			//SoundManager.play("shine", false);			//popupPoint(info.totalPoint);		}				private function createStar():void {			var star:Star04 = new Star04(stageWidth, stageHeight);			Mediator.debArr.push(star);			addChild(star);		}				private function createComet():void {			var comet:Comet = new Comet(stageWidth, stageHeight);			Mediator.debArr.push(comet);			addChild(comet);		}				private function createUFO():void {			var ufo:UFO = new UFO(stageWidth, stageHeight);			Mediator.debArr.push(ufo);			addChild(ufo);		}				public function createDust(info):void {						var colStarClass:String = info.name as String;			var dust_num:Number = 0;						if(colStarClass == "star"){				dust_num = 10;			} else if(colStarClass == "comet"){				dust_num = 50;			}						for(var i:uint = 0; i < dust_num; i++){				var d:Dust = new Dust(info.x, info.y);				Mediator.dustArr.push(d);				addChild(d);			}		}				private function popupMulti(_combo:int):void {			multiplier = Math.floor(_combo * 0.2) + 1;			if(lastMulti < multiplier){				var popup:PopupText = new PopupText("x" + multiplier.toString(), 90, multiplier-1);				popup.x = Mediator.stageWidth / 2;				popup.y = Mediator.stageHeight - 500;				addChild(popup);				//SoundManager.play("combo", false, 0.5);								lastMulti = multiplier;			} else if (lastMulti > multiplier){				lastMulti = 1;			}		}				/*private function popupPoint(_point:int):void {			var popup:PopupText = new PopupText(_point * multiplier);			popup.x = Mediator._player.x + 75;			popup.y = Mediator._player.y - 40;			addChild(popup);			popup.animate∂();		}*/				public function end():void {			trace("time over");						Mediator.cr.takePicture();						var timeup:PopupText = new PopupText("Time Up!!", 80, 0x1d1d1d, true);			timeup.x = Mediator.stageWidth / 2;			timeup.y = Mediator.stageHeight / 2;			addChild(timeup);						/* 星の生成はもうおしまい */			removeEventListener(Event.ENTER_FRAME, onFrame);						/* かわりに動かす星や塵が画面上からなくなったかをチェック！ */			addEventListener(Event.ENTER_FRAME, checkScreen);						/* いったんループを止める */			//LeapSystem.dispose();			//Mediator.dispose();						//PhaseManager.nextPhase();		}				private function checkScreen(e:Event):void {			trace("debarr:" + Mediator.debArr.length);			trace("dustarr:" + Mediator.dustArr.length);			if(Mediator.debArr.length === 0){				if(Mediator.dustArr.length === 0){										removeEventListener(Event.ENTER_FRAME, checkScreen);										/* いったんループを止める */					//LeapSystem.dispose();					//Mediator.dispose();										Mediator._black.fadeDark(photoAndNext);				}			}		}				private function photoAndNext(){						SoundManager.fadeOut("bustling");						// カメラを撮ってデータベースに保存			Mediator.cr.insertScore(Mediator._score.score);			//		    PhaseManager.nextPhase();		}				public function destroy():void {			trace("game destroy");			removeChildren();			timer.destroy();			timer = null;			Mediator._stage.removeChild(this);		}	}	}