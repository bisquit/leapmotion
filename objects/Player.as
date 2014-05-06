﻿package  objects{	import flash.display.Sprite;	import leap.HandState;	import flash.display.Loader;	import flash.events.Event;	import flash.net.URLRequest;	import flash.display.BitmapData;	import flash.display.Bitmap;	import flash.utils.setTimeout;		public class Player extends Sprite{				public var state:int;		public var realWidth:int;		public var realHeight:int;				private var damage_count:uint = 0;		public var isDamaged:Boolean = false;				private var debug:Boolean = false;				[Embed(source="../assets/images/glove-open.png")]		private var OpenImg:Class;		[Embed(source="../assets/images/glove-close.png")]		private var CloseImg:Class;		[Embed(source="../assets/images/glove-open_on.png")]		private var OpenOnImg:Class;		[Embed(source="../assets/images/glove-close_on.png")]		private var CloseOnImg:Class;				public function Player() {						//debug = true;						realWidth = 80;			realHeight = 80;						if(debug){			this.state = HandState.DEFAULT;			this.graphics.lineStyle( 3, 0xffffff );			this.graphics.drawRect(-realWidth/2, -realHeight/2, realWidth, realHeight);			this.alpha = 0.95;			}						var img_open:Bitmap = new OpenImg();			img_open.name = "open";			addChild(img_open);						var img_close:Bitmap = new CloseImg();			img_close.name = "close";			addChild(img_close);						var img_collide:Bitmap = new OpenOnImg();			img_collide.name = "collide";			addChild(img_collide);						img_open.scaleX = img_open.scaleY = 				img_close.scaleX = img_close.scaleY = 					img_collide.scaleX = img_collide.scaleY = 0.5;			img_open.x = img_collide.x = -75;			img_open.y = img_collide.y = -95;						/* 100%の大きさの時にオープンとクローズで左16px,上86pxのずれがあるから			  * 調整して画像切り替えの違和感をなくす */			img_close.x = img_open.x + 16 * img_open.scaleX; 			img_close.y = img_open.y + 86 * img_open.scaleY; 						defaultState();		}						// 通常の状態 = 手が開かれている状態		public function defaultState():void {						if(debug){			this.graphics.clear();			this.graphics.lineStyle( 3, 0xffffff );			this.graphics.drawRect(-realWidth/2, -realHeight/2, realWidth, realHeight);			}						this.getChildByName("open").visible = true;			this.getChildByName("close").visible = false;			this.getChildByName("collide").visible = false;						this.state = HandState.DEFAULT;		}				// 手が握られている状態		public function catchState():void {						if(debug){			this.graphics.clear();			this.graphics.lineStyle( 3, 0xffffff );			this.graphics.drawRect(-realWidth/2, -realHeight/2, realWidth, realHeight);			}						this.getChildByName("open").visible = false;			this.getChildByName("close").visible = true;			this.getChildByName("collide").visible = false;			this.state = HandState.CATCH;		}				// 衝突した状態		public function collideState():void {						if(debug){			this.graphics.clear();			this.graphics.lineStyle( 3, 0xF39700 );			this.graphics.drawRect(-realWidth/2, -realHeight/2, realWidth, realHeight);			}						this.getChildByName("open").visible = false;			this.getChildByName("close").visible = false;			this.getChildByName("collide").visible = true;			this.state = HandState.COLLIDE;		}				// ダメージを受けた時		public function damage():void {			addEventListener(Event.ENTER_FRAME, onFrame);			setTimeout(stopDamage, 600);			isDamaged = true;		}				private function stopDamage():void {			removeEventListener(Event.ENTER_FRAME, onFrame);			damage_count = 0;			isDamaged = false;			this.alpha = 1;		}				private function onFrame(e:Event):void {						if(damage_count % 10 === 0){				this.alpha = 0.4;			} else if(damage_count % 5 === 0){				this.alpha = 1;			}			damage_count++;		}	}}