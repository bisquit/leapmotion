﻿/*  * ゲーム開始時に必要なオブジェクトを生成し参照を保持する  *  * すべてのオブジェクトにアクセスできる唯一のクラスであり  * クラス間の処理(衝突判定も含む)はMediatorが仲介する  *  */package core{	import flash.display.Bitmap;	import flash.display.Stage;	import flash.events.Event;	import flash.utils.getQualifiedClassName;	import flash.utils.setTimeout;	import leap.HandState;	import objects.Dust;	import objects.Player;	import objects.ScoreField;	import phase.GamePhase;	import flash.utils.clearTimeout;	import objects.BlackScreen;	import flash.geom.Point;	import ranking.Camera_Ranking;	public class Mediator {		public static var _stage:Stage;		public static var stageWidth:int;		public static var stageHeight:int;		public static var _player:Player;		public static var _score:ScoreField;		public static var _black:BlackScreen;		public static var currentPhase:String;		public static var _isCatching:Boolean;		public static var isCollide:Boolean;		public static var collideStarArr:Array;		public static var collideStar:Object;		public static var debArr:Array;		public static var dustArr:Vector.<Dust >;				public static var cr:Camera_Ranking;		private static var stopper:uint;		private static var sx:Number;		private static var sy:Number;		private static var count:Number;		private static var starInfo:Object;				[Embed(source = "../assets/images/bg.png")]		private var BgImg:Class;		public function Mediator(s:Stage) {			_stage = s;			stageWidth = _stage.stageWidth;			stageHeight = _stage.stageHeight;			_isCatching = false;			var bg:Bitmap = new BgImg();			_stage.addChild(bg);			_player = new Player();			_score = new ScoreField();						_black = new BlackScreen();			count = 0;			starInfo = {				x: 0, y: 0, totalPoint: 0, combo:0			}		}		// プレイヤー、星座標を更新し、衝突判定を行う		public static function update(e:Event = null):void {			// _player 座標の更新			_player.x = sx;			_player.y = sy;			// すべての星座標の更新			for (var i:uint = 0; i < debArr.length; i++) {								var deb:Object = debArr[i];				if (deb.delete_flag) {					debArr.splice(i, 1);					deb.parent.removeChild(deb);					deb.destroy();					deb = null;					continue;				}				var className:String = deb.name;				// UFOの軌跡変更				if (className == "ufo" && count % 30 == 0) {					deb.vx = int( Math.random() * (deb.vx_max - deb.vx_min + 1) ) + deb.vx_min;					deb.vy = int( Math.random() * (deb.vy_max - deb.vy_min + 1) ) + deb.vy_min;				}				// 加速度を速度に加算				if (deb.vx > 0) {					deb.vx +=  deb.acceleration;				} else {					deb.vx -=  deb.acceleration;				}				deb.vy +=  deb.acceleration;				deb.x +=  deb.vx;				deb.y +=  deb.vy;				// 画面外に出たら消す処理				if (deb.x <  -  deb.width / 2 || deb.x > stageWidth + deb.width / 2 || deb.y <  -  deb.height / 2 || deb.y > stageHeight + deb.height / 2) {										deb.delete_flag = true;					if(deb.name !== "ufo"){						starInfo.combo = 0;					}				}				// プレイヤーとの衝突判定(手が開いていて且つダメージを受けていない時)				if (_player.state !== HandState.CATCH && ! _player.isDamaged) {					if (Math.abs(deb.x - sx) < Mediator._player.realWidth / 2 + deb.width / 2) {						if (Math.abs(deb.y - sy) < Mediator._player.realHeight / 2 + deb.height / 2) {							if (_player.state === HandState.DEFAULT) {								occurCollision(deb);							} else {								/* すでに衝突していたら衝突リストにだけ追加 */								pushCollideList(deb);							}						}					}				}			}// すべての星座標の更新ここまで						// dustのアニメーション			for(i=0; i < Mediator.dustArr.length; i++){								var d:Dust = Mediator.dustArr[i];								// dustの拡大縮小				if(d.scaleX >= 1) {					d.scale_v = -0.2;				} else if(d.scaleX <= 0) {					d.scale_v = 0.2;				}				d.scaleX += d.scale_v;				d.scaleY += d.scale_v;								d.counter++;				d.bezier_trace();								if(d.counter == d.divNum) {					d.parent.removeChild(d);					Mediator.dustArr.splice(i, 1);					d = null;					if(i === 0){						Mediator._score.changeScore(); // 複数回呼ばれてしまうしUFOの時にも呼ばないと　あとで直す					}									}			}// dustのアニメーションここまで			count++;		}		public static function occurCollision(deb):void {						isCollide = true;			_player.collideState();						/* collideStarを最新にして、更に衝突リストに追加 */			collideStar = deb;			pushCollideList(deb);						/* collideStarに衝突時のエフェクトが用意されている場合のスイッチ */			collideStar.isCollided = true;			/* 衝突後200ms後に再判定を行う			  * したがって200ms間は(仮に衝突していなくても)衝突しているとみなされる */			stopper = setTimeout(endCollision,200);		}		public static function endCollision(catched:Boolean = false):void {			// 衝突後200ms後にまだ衝突範囲内にあり、かつキャッチ判定がなければ再び200msの衝突判定を与える			if (! catched) {				if (Math.abs(collideStar.x - _player.x) < Mediator._player.realWidth / 2 + collideStar.width / 2) {					if (Math.abs(collideStar.y - _player.y) < Mediator._player.realHeight / 2 + collideStar.height / 2) {						occurCollision(collideStar);						return;					}				}			}			/* キャッチされた時および衝突判定から外れたとき以下を実行 */			clearTimeout(stopper);			isCollide = false;			collideStar.isCollided = false;			/* キャッチ後の手の状態はCATCHに、それ以外はDEFAULTに戻す */			if (_player.state === HandState.CATCH) {				_player.catchState();			} else {				_player.defaultState();			}			/* キャッチ時であれば更に以下を実行 */			if (catched) {								/* 個別の処理が必要なものはループの中に */				for (var n:uint = 0; n < collideStarArr.length; n++) {					collideStar = collideStarArr[n];										starInfo.x = collideStar.x;					starInfo.y = collideStar.y;					starInfo.name = collideStar.name;					starInfo.totalPoint += collideStar.point;										if(starInfo.name === "star" || starInfo.name === "comet"){						starInfo.combo++;						_player.charge();					}else if(starInfo.name === "ufo"){						starInfo.combo = 0;						_player.damage();					}else{						starInfo.combo = 0;					}										/* 用済みになった衝突オブジェクトを削除 */					collideStar.delete_flag = true;				}								/* まとめて処理する必要があるものはこちらに */				PhaseManager.Phases[PhaseManager.level - 1].afterCatch(starInfo);				_score.holdScore(starInfo.totalPoint, starInfo.combo);			}			collideStarArr.length = 0;			starInfo.totalPoint = 0;					}		private static function pushCollideList(object:Object):void {			for (var j:uint = 0; j < collideStarArr.length; j++) {				if (collideStarArr[j] === object) {					return;				}			}			collideStarArr.push(object);		}				public static function initialize():void {			debArr = new Array();			dustArr = new Vector.<Dust>();			collideStarArr = new Array();			_stage.addEventListener(Event.ENTER_FRAME, Mediator.update);		}				public static function dispose():void {			_stage.removeEventListener(Event.ENTER_FRAME, Mediator.update);			clearTimeout(stopper);			debArr = null;			dustArr = null;			collideStarArr = null;		}		public static function get Sx():Number {			return sx;		}		public static function set Sx(value:Number):void {			sx = value;		}		public static function get Sy():Number {			return sy;		}		public static function set Sy(value:Number):void {			sy = value;		}		public static function get isCatching():Boolean {			return _isCatching;		}		public static function set isCatching(value:Boolean):void {			_isCatching = value;		}	}}