﻿package  phase {	import flash.display.Sprite;	import flash.display.Bitmap;	import core.Mediator;	import flash.utils.setTimeout;	import core.PhaseManager;	import flash.events.Event;	import a24.tween.Tween24;	import objects.StartButton;		public class StartPhase extends Sprite implements IPhase{				private var container:Sprite;		private var start_btn:StartButton;				[Embed(source="../assets/images/manual.png")]		private var ManualImg:Class;		[Embed(source="../assets/images/icon-open.png")]		private var IconOpenImg:Class;		[Embed(source="../assets/images/icon-close.png")]		private var IconCloseImg:Class;				public function StartPhase() {			container = new Sprite;						var manual = new ManualImg();			manual.scaleX = manual.scaleY = 0.8;			manual.x = - manual.width/2;			manual.y = -manual.height/2;			container.addChild(manual);						var icon_open:Bitmap = new IconOpenImg();			icon_open.scaleX = icon_open.scaleY = 0.7;			icon_open.x = 50;			icon_open.y = 210;			container.addChild(icon_open);						var icon_close:Bitmap = new IconCloseImg();			icon_close.scaleX = icon_close.scaleY = 0.7;			icon_close.x = 50;			icon_close.y = 210;			container.addChild(icon_close);						container.x = Mediator.stageWidth/2;			container.y = Mediator.stageHeight/2;			addChild(container);						/* 衝突判定でステージからのx,y座標が必要のため			  * コンテナとは別にする */			start_btn = new StartButton();			start_btn.x = Mediator.stageWidth - 300;			start_btn.y = Mediator.stageHeight - 100;			addChild(start_btn);					}				public function start():void {			trace("start start");			Mediator._stage.addChild(this);			Mediator._stage.setChildIndex(Mediator._player, Mediator._stage.numChildren - 1);			Mediator.currentPhase = "start";						Tween24.serial(				Tween24.prop(container).fadeOut().$y(200),				Tween24.parallel(					Tween24.tween(container, 2, Tween24.ease.BackOut).fadeIn(),					Tween24.tween(container, 0.5, Tween24.ease.BackOut).$y(0)				)			).play();			Tween24.serial(				Tween24.prop(start_btn).fadeOut().$y(-100),				Tween24.parallel(					Tween24.tween(start_btn, 3, Tween24.ease.BackOut).fadeIn().$y(0)				)			).play();						Mediator.debArr.push(start_btn);						//setTimeout(afterCatch, 3000);		}				public function afterCatch():void {			Tween24.serial(				Tween24.parallel(					Tween24.tween(container, 0.8, Tween24.ease.BackIn).fadeOut(),					Tween24.tween(container, 0.8, Tween24.ease.BackIn).$y(500)				)			).onComplete(PhaseManager.nextPhase).play();		}				private function nextPhase():void {			Tween24.serial(				Tween24.parallel(					Tween24.tween(container, 0.8, Tween24.ease.BackIn).fadeOut(),					Tween24.tween(container, 0.8, Tween24.ease.BackIn).$y(500)				)			).onComplete(PhaseManager.nextPhase).play();						//PhaseManager.nextPhase();		}				public function destroy():void {			trace("start destroy");			Mediator._stage.removeChild(this);		}	}	}