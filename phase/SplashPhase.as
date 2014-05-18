﻿package phase{	import flash.display.Sprite;	import flash.display.Bitmap;	import core.Mediator;	import flash.utils.setTimeout;	import core.PhaseManager;	import flash.events.Event;	import leap.HandState;	import a24.tween.Tween24;	import flash.display.MovieClip;	import flash.geom.Point;	import objects.Catchable;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;	import core.SoundManager;	public class SplashPhase extends Sprite implements IPhase {		private var logo:Catchable;		private var black_screen:Sprite;		private var mc_icon:MovieClip;				private var snd:Sound;		private var ch:SoundChannel;		private var tf:SoundTransform;				private var frame:int = 0;		private var tween:Tween24;		[Embed(source = "../assets/images/nigitte-blue.png")]		private var NigitteImage:Class;		[Embed(source = "../assets/images/icon-open.png")]		private var IconOpenImage:Class;		[Embed(source = "../assets/images/icon-close.png")]		private var IconCloseImage:Class;		[Embed(source = "../assets/swf/icon.swf")]		private var IconSwf:Class;						public function SplashPhase() {			logo = new Catchable("logo");			logo.x = Mediator.stageWidth / 2;			logo.y = Mediator.stageHeight / 2;			addChild(logo);			var txt_start:Bitmap = new NigitteImage();			txt_start.scaleX = txt_start.scaleY = 0.5;			txt_start.x = Mediator.stageWidth / 2 - txt_start.width / 2 + 150;			txt_start.y = Mediator.stageHeight / 2 - txt_start.height / 2 + logo.height / 1.5;			addChild(txt_start);			/*var icon_close:Bitmap = new IconCloseImage();			icon_close.scaleX = icon_close.scaleY = 0.5;			icon_close.x = Mediator.stageWidth/2 + 160 + txt_start.width/2;			icon_close.y = Mediator.stageHeight/2 - icon_close.height/2 + logo.height/1.5;			addChild(icon_close);*/			var icon_open:Bitmap = new IconOpenImage();			icon_open.scaleX = icon_open.scaleY = 0.5;			icon_open.x = Mediator.stageWidth / 2 + 160 + txt_start.width / 2;			icon_open.y = Mediator.stageHeight / 2 - icon_open.height / 2 + logo.height / 1.5;			addChild(icon_open);			mc_icon = new IconSwf();			mc_icon.scaleX = mc_icon.scaleY = 0.5;			mc_icon.x = Mediator.stageWidth / 2 + 160 + txt_start.width / 2 + mc_icon.width / 4;			mc_icon.y = Mediator.stageHeight / 2 - icon_open.height / 2 + logo.height / 1.5 + mc_icon.height / 4;						//snd = new OpeningSnd();						/*tween = Tween24.loop(3,						Tween24.tween(logo, 0.01).$x(6),						Tween24.tween(logo, 0.01).$x(0),						Tween24.tween(logo, 0.01).$x(-6),						Tween24.tween(logo, 0.01).$x(0)					);*/			 tween = Tween24.loop(0,								 Tween24.tween(logo, 0.6, Tween24.ease.CircOut).$y(-30),								 Tween24.tween(logo, 0.6, Tween24.ease.CircIn).$y(0)								 );		}		public function start():void {			trace("splash start");			Mediator._stage.addChild(this);			Mediator._player.visible = false;			Mediator._stage.addChild(Mediator._player);			Mediator._stage.addChild(Mediator._black);			Mediator._black.fadeLight();			Mediator.currentPhase = "splash";			Mediator.initialize();						SoundManager.play("opening", true, 0.1);			/*ch = snd.play(0, 100);			tf = ch.soundTransform;			tf.volume = 0.1;			ch.soundTransform = tf;						ch.addEventListener(Event.SOUND_COMPLETE, restartSound);*/						/* タイトルロゴも掴める対象にする */			Mediator.debArr.push(logo);			addEventListener(Event.ENTER_FRAME, onFrame);						//setTimeout(afterCatch, 2000);		}		private function onFrame(e:Event):void {			if (logo.isCollided) {				if (frame === 0) {					addChild(mc_icon);					logo.scaleX = logo.scaleY = 1;					tween.play();				}				frame++;			} else {				if (frame > 0) {					mc_icon.parent.removeChild(mc_icon);					logo.scaleX = logo.scaleY = 1;					tween.stop();				}				frame = 0;			}		}		public function afterCatch(info:Object = null):void {			/* 画面を暗くする */			Mediator._black.fadeDark(PhaseManager.nextPhase);						//Mediator.debArr.pop();						/* BGMをフェードアウト */			SoundManager.fadeOut();		}		public function destroy():void {			trace("splash destroy");			removeEventListener(Event.ENTER_FRAME, onFrame);			removeChildren();			logo.destroy();			logo = null;			mc_icon = null;		    tween = null;			Mediator._stage.removeChild(this);		}	}}