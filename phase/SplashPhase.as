﻿package  phase {	import flash.display.Sprite;	import flash.display.Bitmap;	import core.Mediator;	import flash.utils.setTimeout;	import core.PhaseManager;	import flash.events.Event;	import leap.HandState;		public class SplashPhase extends Sprite implements IPhase{				private var logo_container:Sprite;				[Embed(source="../assets/images/logo.png")]		private var LogoImage:Class;		[Embed(source="../assets/images/nigitte-blue.png")]		private var NigitteImage:Class;		[Embed(source="../assets/images/icon-open.png")]		private var IconOpenImage:Class;		[Embed(source="../assets/images/icon-close.png")]		private var IconCloseImage:Class;				public function SplashPhase() {						logo_container = new Sprite();						var logo:Bitmap = new LogoImage();			logo.scaleX = logo.scaleY = 0.5;			logo.x = - logo.width/2;			logo.y = - logo.height/2;			logo_container.addChild(logo);						logo_container.x = Mediator.stageWidth/2;			logo_container.y = Mediator.stageHeight/2;			addChild(logo_container);						var txt_start:Bitmap = new NigitteImage();			txt_start.scaleX = txt_start.scaleY = 0.5;			txt_start.x = Mediator.stageWidth/2 - txt_start.width/2 + 150;			txt_start.y = Mediator.stageHeight/2 - txt_start.height/2 + logo.height/1.5;			addChild(txt_start);						var icon_open:Bitmap = new IconOpenImage();			icon_open.scaleX = icon_open.scaleY = 0.5;			icon_open.x = Mediator.stageWidth/2 + 160 + txt_start.width/2;			icon_open.y = Mediator.stageHeight/2 - icon_open.height/2 + logo.height/1.5;			addChild(icon_open);						var icon_close:Bitmap = new IconCloseImage();			icon_close.scaleX = icon_close.scaleY = 0.5;			icon_close.x = Mediator.stageWidth/2 + 160 + txt_start.width/2;			icon_close.y = Mediator.stageHeight/2 - icon_close.height/2 + logo.height/1.5;			addChild(icon_close);					}				public function start():void {			trace("splash start");			Mediator._stage.addChild(this);			Mediator._player.visible = false;			Mediator._stage.addChild(Mediator._player);						Mediator._stage.addEventListener(Event.ENTER_FRAME, Mediator.update);			//addEventListener(Event.ENTER_FRAME, detectHand);			setTimeout(nextPhase, 2000);			//addEventListener(Event.ENTER_FRAME, onFrame);		}				/*private function detectHand(e:Event):void {			if(Mediator._player.visible){				removeEventListener(Event.ENTER_FRAME, detectHand);				PhaseManager.nextPhase();			}		}*/		private function onFrame(e:Event):void {						if(Mediator._player.state === HandState.DEFAULT){				if (Math.abs(logo_container.x - Mediator.Sx) < Mediator._player.realWidth / 2 + logo_container.width / 2) {					if (Math.abs(logo_container.y - Mediator.Sy) < Mediator._player.realHeight / 2 + logo_container.height / 2) {						occurCollision();					}				}			} else if (Mediator._player.state === HandState.COLLIDE){				endCollision();			}		}				private function occurCollision():void {			Mediator._player.collideState();		}				private function endCollision():void {						if (Math.abs(logo_container.x - Mediator.Sx) < Mediator._player.realWidth / 2 + logo_container.width / 2) {				if (Math.abs(logo_container.y - Mediator.Sy) < Mediator._player.realHeight / 2 + logo_container.height / 2) {					occurCollision();					return;				}			}						if(Mediator._player.state === HandState.CATCH){				Mediator._player.catchState();			}else{				Mediator._player.defaultState();			}		}				private function nextPhase():void {						PhaseManager.nextPhase();		}				public function destroy():void {			trace("splash destroy");			removeEventListener(Event.ENTER_FRAME, onFrame);			Mediator._stage.removeChild(this);		}	}	}