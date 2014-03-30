﻿package objects{	import starling.display.Quad;	import flash.utils.setTimeout;	import starling.display.Sprite;	public class Star02 extends Sprite {		public var vx:Number;		public var vy:Number;		public var acceleration:Number;		public var point:Number;		public var click_flag:Boolean = false;		public var move_flag:Boolean = false;		public var delete_flag:Boolean = false;		// 赤:50点 緑:10点 青:-10点		private var colorArr:Array = [0xFF0000,0x00FF00,0x0000FF];		private var pointArr:Array = [50,10,-10];		private var accelerationArr:Array = [0.25,0.2,0.15];		public function Star02(W:Number, H:Number, star_R:Number):void {			var num_max:Number = colorArr.length - 1;			var num_min:Number = 0;			var num:Number = int( Math.random() * (num_max - num_min + 1) ) + num_min;			// 四角形を生成			var quad:Quad = new Quad(40,40,colorArr[num]);			addChild(quad);			acceleration = accelerationArr[num];			point = pointArr[num];			// ----------------------------------------			// 星がなるべく画面内を交差するようにvx,vyを調整			var x_min:Number = star_R;			var x_max:Number = W - star_R;			var y_min:Number = star_R;			var y_max:Number = H / 2 - star_R;			this.x = int( Math.random() * (x_max - x_min + 1) ) + x_min;			this.y = int( Math.random() * (y_max - y_min + 1) ) + y_min;			var vx_min:Number;			var vx_max:Number;			var vy_min:Number = 3;			var vy_max:Number = 2;			if (this.x <= W / 2) {				vx_min = 1;				vx_max = 3;			} else {				vx_min = -3;				vx_max = -1;			}			this.vx = int( Math.random() * (vx_max - vx_min + 1) ) + vx_min;			this.vy = int( Math.random() * (vy_max - vy_min + 1) ) + vy_min;			// ----------------------------------------			// 星が生成されてから1秒後に動き始めるようにする			setTimeout(starMove, 1000);			// 星を動き始めるようにする関数			function starMove():void {				move_flag = true;			}		}	}}