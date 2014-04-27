﻿package  objects{	import flash.display.Sprite;	import leap.HandState;	import flash.display.Loader;	import flash.events.Event;	import flash.net.URLRequest;	import flash.display.BitmapData;	import flash.display.Bitmap;		public class Player extends Sprite{				public var state:int;		public var realWidth:int;		public var realHeight:int;				/*private var loader:Loader;		private var nameArr:Array = ["open", "close"];		private var counter:Number = 0;*/				[Embed(source="../assets/images/hand_open.png")]		private var OpenImg:Class;		[Embed(source="../assets/images/hand_close.png")]		private var CloseImg:Class;				public function Player() {						realWidth = 80;			realHeight = 80;			this.state = HandState.DEFAULT;			this.graphics.lineStyle( 3, 0xffffff );			this.graphics.drawRect(-realWidth/2, -realHeight/2, realWidth, realHeight);						this.alpha = 0.95;						var img_open:Bitmap = new OpenImg();			img_open.name = "open";			addChild(img_open);						var img_close:Bitmap = new CloseImg();			img_close.name = "close";			addChild(img_close);						img_open.scaleX = img_open.scaleY = img_close.scaleX = img_close.scaleY = 0.5;			img_open.x = img_close.x = -90;			img_open.y = img_close.y = -110;						defaultState();						//loadAsset("assets/images/hand_open.png");					}						// 通常の状態 = 手が開かれている状態		public function defaultState():void {						this.graphics.clear();			this.graphics.lineStyle( 3, 0xffffff );			this.graphics.drawRect(-realWidth/2, -realHeight/2, realWidth, realHeight);						this.getChildByName("open").visible = true;			this.getChildByName("close").visible = false;			this.state = HandState.DEFAULT;		}				// 手が握られている状態		public function catchState():void {						this.graphics.clear();			this.graphics.lineStyle( 3, 0xffffff );			this.graphics.drawRect(-realWidth/2, -realHeight/2, realWidth, realHeight);						this.getChildByName("close").visible = true;			this.getChildByName("open").visible = false;			this.state = HandState.CATCH;		}				// 衝突した状態		public function collideState():void {			this.graphics.clear();			this.graphics.lineStyle( 3, 0xF39700 );			this.graphics.drawRect(-realWidth/2, -realHeight/2, realWidth, realHeight);						this.state = HandState.COLLIDE;		}				/*public function loadAsset(path):void {			loader = new Loader();			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);			loader.load(new URLRequest(path));		}		private function onComplete(e:Event):void {			var loader:Loader = e.currentTarget.loader;			var bmd:BitmapData = new BitmapData(loader.width, loader.height, true, 0x00ffffff);			bmd.draw(loader);						var hand:Sprite = new Sprite();			hand.graphics.beginBitmapFill(bmd, null, false);			hand.graphics.drawRect(0, 0, loader.width, loader.height);			hand.graphics.endFill();			hand.x = -90;			hand.y = -110;			hand.scaleX = hand.scaleY = 0.5;			hand.name = nameArr[counter++];			addChild(hand);						if(counter === 1){				loadAsset("assets/images/hand_close.png");			} else if(counter === 2){				this.defaultState();			}		}*/			}	}