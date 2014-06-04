﻿package  phase {	import flash.display.Sprite;	import flash.display.Bitmap;	import core.Mediator;	import flash.utils.setTimeout;	import core.PhaseManager;	import flash.events.Event;	import a24.tween.Tween24;	import flash.geom.Point;	import objects.Catchable;	import flash.display.MovieClip;	import core.SoundManager;		public class StartPhase extends Sprite implements IPhase{				private var container:Sprite;		private var start_btn:Catchable;				private var tw_fe:Tween24;				/*[Embed(source="../assets/images/manual_title.png")]		private var TitleImg:Class;		[Embed(source="../assets/images/manual_text.png")]		private var TextImg:Class;		[Embed(source="../assets/images/manual_star.png")]		private var StarImg:Class;		[Embed(source="../assets/images/manual_comet.png")]		private var CometImg:Class;		[Embed(source="../assets/images/manual_ufo.png")]		private var UfoImg:Class;*/		[Embed(source="../assets/images/manual.png")]		private var Manual:Class;				public function StartPhase() {									//var manual = new ManualImg();			//manual.scaleX = manual.scaleY = 0.8;			//manual.x = - manual.width/2;			//manual.y = -manual.height/2;			//container.addChild(manual);						/*var title:Bitmap = new TitleImg();			var text:Bitmap = new TextImg();			var star:Bitmap = new StarImg();			var comet:Bitmap = new CometImg();			var ufo:Bitmap = new UfoImg();						title.scaleX = title.scaleY = text.scaleX = text.scaleY = 			  star.scaleX = star.scaleY = comet.scaleX = comet.scaleY =			    ufo.scaleX = ufo.scaleY = 1;						container.addChild(title);			container.addChild(text);			container.addChild(star);			container.addChild(comet);			container.addChild(ufo);						text.y = title.height + 20;			star.y = comet.y = ufo.y = text.y + text.height + 30;			comet.x = 120;			ufo.x = 240;*/								}				public function start():void {			trace("start start");			Mediator._stage.addChild(this);			Mediator._stage.setChildIndex(Mediator._player, Mediator._stage.numChildren - 1);			Mediator._stage.setChildIndex(Mediator._black, Mediator._stage.numChildren - 1);			Mediator.currentPhase = "start";						Mediator._black.fadeLight();
			
			// インスタンス部分から移植
			// --------------------------------
			
			container = new Sprite;
			
			var manual:Bitmap = new Manual();
			manual.scaleX = manual.scaleY = 0.8;
			manual.x = 35;
			manual.y = -25;
			container.addChild(manual);
			
			
			container.x = Mediator.stageWidth/2 - container.width/2;
			container.y = Mediator.stageHeight/2 - container.height/2;
			addChild(container);
			
			/* 衝突判定でステージからのx,y座標が必要のため
			  * コンテナとは別にする */
			start_btn = new Catchable("startButton", 0.67);
			start_btn.x = Mediator.stageWidth - 355;
			start_btn.y = Mediator.stageHeight/2 + 235;
			addChild(start_btn);
			
			// --------------------------------						SoundManager.play("bustling", true, 0.8);						Tween24.serial(				Tween24.prop(container).fadeOut().$y(200),				Tween24.parallel(					Tween24.tween(container, 2, Tween24.ease.BackOut).fadeIn(),					Tween24.tween(container, 0.5, Tween24.ease.BackOut).$y(0)				)			 ).play();			 Tween24.serial(				Tween24.prop(start_btn).fadeOut().$y(-100),				Tween24.tween(start_btn, 1, Tween24.ease.BackOut).fadeIn().$y(0)			 ).play();			 			 // スタートボタンを掴める対象とする			 Mediator.debArr.push(start_btn);			 addEventListener(Event.ENTER_FRAME, onFrame);						//setTimeout(afterCatch, 2000);		}				private function onFrame(e:Event):void{			if (start_btn.isCollided) {				start_btn.scaleX = start_btn.scaleY = 1.3;			} else {					start_btn.scaleX = start_btn.scaleY = 1;			}		}				private function floatingEffect():void {			tw_fe = Tween24.loop(0,					Tween24.tween(start_btn, 2, Tween24.ease.SineOut).$y(-20),					Tween24.tween(start_btn, 4, Tween24.ease.SineOut).$y(20)				);			tw_fe.play();		}				public function afterCatch(info:Object = null):void {			//Mediator.debArr.pop();			if(tw_fe){				tw_fe.stop();			}						Tween24.parallel(				Tween24.tween(container, 0.8, Tween24.ease.BackIn).fadeOut().$y(30),								Tween24.tween(start_btn, 0.8, Tween24.ease.BackIn).fadeOut().$y(30)											).onComplete(PhaseManager.nextPhase).play();		}				public function destroy():void {			trace("start destroy");			removeEventListener(Event.ENTER_FRAME, onFrame);			removeChildren();			start_btn.destroy();			container = null;			start_btn = null;			Mediator._stage.removeChild(this);		}	}	}