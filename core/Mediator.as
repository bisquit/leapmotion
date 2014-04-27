﻿/*  * ゲーム開始時に必要なオブジェクトを生成し参照を保持する  *  * すべてのオブジェクトにアクセスできる唯一のクラスであり  * クラス間の処理(衝突判定も含む)はMediatorが仲介する  *  */package core{	import flash.display.Bitmap;	import flash.display.Stage;	import flash.utils.setTimeout;	import leap.HandState;	import objects.Player;	import objects.ScoreField;	import objects.Star03;	import objects.StarShadow;	import flash.events.Event;		public class Mediator {		public static var _stage:Stage;		public static var stageWidth:int;		public static var stageHeight:int;		public static var _player:Player;		public static var _score:ScoreField;		public static var _isCatching:Boolean;		public static var isCollide:Boolean;		public static var collideStar:Star03;		public static var starArr:Vector.<Star03>;		public static var shadowArr:Vector.<StarShadow>;		private static var sx:Number;		private static var sy:Number;		[Embed(source="../assets/images/bg.png")]		private var BgImg:Class;		public function Mediator(s:Stage) {			_stage = s;			stageWidth = _stage.stageWidth;			stageHeight = _stage.stageHeight;			_isCatching = false;			var bg:Bitmap = new BgImg();			_stage.addChild(bg);			_player = new Player();			_score = new ScoreField();			starArr = new Vector.<Star03>();			shadowArr = new Vector.<StarShadow>();		}		// プレイヤー、星座標を更新し、衝突判定を行う		public static function update(e:Event = null):void {			// _player 座標の更新			_player.x = sx;			_player.y = sy;			// すべての星座標の更新//			for (var i:uint = 0, len = starArr.length; i < len; i++) {			for (var i:uint = 0; i < starArr.length; i++) {				var star:Star03 = starArr[i];				var shadow:StarShadow = shadowArr[i];				if (star.delete_flag) {					starArr.splice(i, 1);					star.parent.removeChild(star);					shadowArr.splice(i, 1);					shadow.parent.removeChild(shadow);					continue;				}				if (star.move_flag) {					// 加速度を速度に加算					if (star.vx > 0) {						star.vx +=  star.acceleration;					} else {						star.vx -=  star.acceleration;					}					star.vy +=  star.acceleration;					star.x +=  star.vx;					star.y +=  star.vy;					star.rotation += 2;					shadow.x = star.x + 10;					shadow.y = star.y + 10;					shadow.rotation += 2;				}				// 画面外に出たら消す処理				if (star.x < -star.width / 2 || star.x > stageWidth + star.width / 2 || star.y < -star.height / 2 || star.y > stageHeight + star.height / 2) {					starArr.splice(i, 1);					star.parent.removeChild(star);					shadowArr.splice(i, 1);					shadow.parent.removeChild(shadow);				}				// プレイヤーとの衝突判定(手が開かれている時のみ)				if(_player.state === HandState.DEFAULT){					if (Math.abs(star.x - sx) < Mediator._player.realWidth / 2 + star.width / 2) {						if (Math.abs(star.y - sy) < Mediator._player.realHeight / 2 + star.height / 2) {							occurCollision(star);						}					}				}			}		}		public static function occurCollision(star:Star03):void {			_player.collideState();			isCollide = true;			collideStar = star;			// 衝突後200msは(仮に衝突していなくても)衝突しているとみなす			setTimeout(endCollision, 200);		}		public static function endCollision():void {			// 衝突後200ms後にまだ衝突範囲内にあり、かつ星が生存していれば再び200msの衝突判定を与える			if ( !collideStar.delete_flag) {				if (Math.abs(collideStar.x - _player.x) < Mediator._player.realWidth / 2 + collideStar.width / 2) {					if (Math.abs(collideStar.y - _player.y) < Mediator._player.realHeight / 2 + collideStar.height / 2) {						occurCollision(collideStar);						return;					}				}			}			if(_player.state === HandState.CATCH){				_player.catchState();			}else{				_player.defaultState();			}			isCollide = false;		}		public static function changeScore():void {			_score.changeScore(collideStar.point);		}		// 外部から手の状態を変更するための関数		/*public static function changeHandState(handState:int):void {			switch(handState){				case HandState.DEFAULT:					_player.defaultState();					break;				case HandState.CATCH:					_player.catchState();			}		}*/		// ゲーム開始時の処理		/*public static function startGame():void {			mainView = collideStar.parent as MainView;			mainView.terminate = false;			mainView.createStar();			start.visible = false;			end.visible = false;			timer.start(20);		}*/		// ゲーム終了時の処理		/*public static function endGame():void {			mainView.terminate = true; // 星を生成しているクラスで終了フラグを立てる			// 画面に残っている星がすべて消えたら終了画面を表示する			setTimeout(wait, 1000);			function wait():void {				if(starArr.length === 0){					end.visible = true;					mainView.createStartStar();					return;				}				setTimeout(wait, 1000);			}		}*/		/*public static function registerStage(s:Stage):void {			_stage = s;		}		public static function registerObject(name:String, obj):void {			Mediator[name] = obj;		}*/		public static function get Sx():Number {			return sx;		}		public static function set Sx(value:Number):void {			sx = value;		}		public static function get Sy():Number {			return sy;		}		public static function set Sy(value:Number):void {			sy = value;		}		public static function get isCatching():Boolean {			return _isCatching;		}		public static function set isCatching(value:Boolean):void {			_isCatching = value;		}	}}