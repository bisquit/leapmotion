﻿package  objects{	import flash.display.Sprite;		public class Player extends Sprite{		public function Player() {			this.graphics.lineStyle( 3, 0xffffff );			this.graphics.drawCircle(0,0, 40 );		}				public function collideWith():void {			this.graphics.clear();			this.graphics.lineStyle( 3, 0xF39700 );			this.graphics.drawCircle(0,0,40);		}				public function defaultState():void {			this.graphics.clear();			this.graphics.lineStyle( 3, 0xffffff );			this.graphics.drawCircle(0,0, 40 );		}	}	}