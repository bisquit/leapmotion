﻿package objects{	import flash.display.Bitmap;	import flash.display.Sprite;	import flash.events.Event;		public class Star04 extends Sprite	{		public var vx:Number;		public var vy:Number;		public var acceleration:Number;		public var point:Number = 10;		public var delete_flag:Boolean = false;		public var rot:Number;		private var accelerationArr:Array = [0.25,0.2,0.15];		public var isCollided:Boolean = false;				[Embed(source="../assets/images/star01.png")]		private var StarImg01:Class;		[Embed(source="../assets/images/star02.png")]		private var StarImg02:Class;		[Embed(source="../assets/images/star03.png")]		private var StarImg03:Class;				/*[Embed(source="../assets/images/star_shadow.png")]		private var StarShadowImg:Class;		*/		public var sp_star:Sprite;		public var sp_shadow:Sprite;		private var star_img:Bitmap;				public function Star04(W:Number, H:Number)		{			// 初期化			sp_star = new Sprite();			sp_shadow = new Sprite();			addChild(sp_shadow);			addChild(sp_star);						var rnd:Number = Math.random();			if(rnd < 0.3){				star_img = new StarImg01();			} else if(rnd < 0.7){				star_img = new StarImg02();			} else {				star_img = new StarImg03();			}						star_img.scaleX = star_img.scaleY = 1.2;			star_img.x = -star_img.width/2;			star_img.y = -star_img.height/2			sp_star.addChild(star_img);						/*var shadow_img:Bitmap = new StarShadowImg();			shadow_img.scaleX = shadow_img.scaleY = 1;			shadow_img.x = -shadow_img.width / 2;			shadow_img.y = -shadow_img.height / 2;			sp_shadow.addChild(shadow_img);			sp_shadow.x = sp_star.x + 10;			sp_shadow.y = sp_star.y + 10;			*/			var num_max:Number = accelerationArr.length - 1;			var num_min:Number = 0;			var num:Number = int( Math.random() * (num_max - num_min + 1) ) + num_min;			acceleration = accelerationArr[num];						var x_min:Number = W / 3 + star_img.width/2;			var x_max:Number = W - star_img.width/2;			var y_min:Number = 0;			var y_max:Number = 0;						this.x = int( Math.random() * (x_max - x_min + 1) ) + x_min;			this.y = int( Math.random() * (y_max - y_min + 1) ) + y_min;						var vx_min:Number = -3;			var vx_max:Number = -1;			var vy_min:Number = 3;			var vy_max:Number = 3;						this.vx = int( Math.random() * (vx_max - vx_min + 1) ) + vx_min;			this.vy = int( Math.random() * (vy_max - vy_min + 1) ) + vy_min;						// 回転			rot = 6.0 * Math.random() - 3.0;						this.name = "star";						addEventListener(Event.ENTER_FRAME, onEnterFrame);		}				private function onEnterFrame(e:Event):void {			sp_star.rotation += rot;			//sp_shadow.rotation += rot;		}				public function destroy():void {			removeEventListener(Event.ENTER_FRAME, onEnterFrame);			//removeChild(sp_shadow);			removeChild(sp_star);			//sp_shadow = null;			sp_star = null;		}	}}