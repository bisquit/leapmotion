﻿package phase {	import flash.display.Sprite;	import flash.geom.Point;	import core.Mediator;	import leap.LeapSystem;	import objects.Catchable;	import core.SoundManager;	import flash.display.MovieClip;	import flash.events.Event;	import core.PhaseManager;	import flash.utils.setTimeout;	import ranking.Camera_Ranking;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;	import flash.utils.clearInterval;	import flash.utils.setInterval;		public class EndPhase extends Sprite implements IPhase{				private var omb:Catchable;		private var RANK_TIMER:Number;		public var interval_time:uint;				public function EndPhase() {		}				public function start():void {						RANK_TIMER = 3000;						omb = new Catchable("omb", 0.7);			//omb.scaleX = omb.scaleY = 0.7;			omb.x = Mediator.stageWidth - 220;			omb.y = Mediator.stageHeight - 210;			addChild(omb);						trace("end start");			Mediator._stage.addChild(this);			Mediator._stage.setChildIndex(Mediator._player, Mediator._stage.numChildren - 1);			Mediator._stage.setChildIndex(Mediator._black, Mediator._stage.numChildren - 1);						LeapSystem.initialize();			Mediator.initialize();						Mediator._black.fadeLight();						SoundManager.play("ending", true, 1);						Mediator.cr.takeRanking();						rank_timer();										// もう一回ボタンを掴める対象とする			 Mediator.debArr.push(omb);			 addEventListener(Event.ENTER_FRAME, onFrame);		}				private function rank_timer():void {						// 制限時間を表示			var tf_time:TextField = new TextField();			var format_time:TextFormat = new TextFormat();			var myFont:Shinagino = new Shinagino();			format_time.color = 0x8aff0c;			format_time.size = 60;			format_time.kerning = true;			format_time.letterSpacing = -2;			format_time.font = myFont.fontName;			tf_time.autoSize = TextFieldAutoSize.RIGHT;			tf_time.defaultTextFormat = format_time;			tf_time.embedFonts = true;			tf_time.x = Mediator.stageWidth - 150;			tf_time.y = Mediator.stageHeight - 350;			tf_time.text = RANK_TIMER.toString();			addChild(tf_time);						interval_time = setInterval( function():void {								if(RANK_TIMER == 0){					clearInterval( interval_time );										// ここに終了後をかく					Mediator._black.fadeDark(Mediator._black.fadeLight);					setTimeout(PhaseManager.restart, 600);										/* BGMをフェードアウト */					SoundManager.fadeOut("ending");									} else {					RANK_TIMER--;					tf_time.text = RANK_TIMER.toString();				}							}, 1000 );		}				// 制限時間をクリア		private function clear_interval():void{			RANK_TIMER = 30;			clearInterval( interval_time );		}				private function onFrame(e:Event):void {			if (omb.isCollided) {				omb.scaleX = omb.scaleY = 1;			} else {					omb.scaleX = omb.scaleY = 1;			}		}				public function afterCatch(info:Object = null):void {						SoundManager.play("select", false, 0.5);						/* 画面を暗くする */			Mediator._black.fadeDark(Mediator._black.fadeLight);			setTimeout(PhaseManager.retry, 600);						clear_interval();						/* BGMをフェードアウト */			SoundManager.fadeOut("ending");					}				public function destroy():void {			trace("end destroy");			removeEventListener(Event.ENTER_FRAME, onFrame);			removeChildren();			omb.destroy();			omb = null;			Mediator._score.reset();			Mediator._stage.removeChild(this);		}	}	}