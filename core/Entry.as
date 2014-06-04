﻿/*  * ゲームのエントリーポイント  * 全体で共通の処理とリープの起動を行う  */package core{	import flash.display.Bitmap;	import flash.display.Sprite;	import flash.display.Stage;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;		import leap.LeapSystem;		import objects.Player;	import ranking.Camera_Ranking;	import leap.MouseSystem;		public class Entry extends Sprite {				private var _stage:Stage;				public function Entry(s:Stage = null) {						if(s){				_stage = s;			}else {				_stage = stage;			}						/* ステージのセットアップ */			if(!_stage){				addEventListener(Event.ADDED_TO_STAGE, init);			} else {				init();			}		}				private function init(e:Event = null):void {						if(e !== null){				removeEventListener(Event.ADDED_TO_STAGE, init);			}						_stage.align = StageAlign.TOP_LEFT;			_stage.scaleMode = StageScaleMode.NO_SCALE;						// オブジェクトのセットアップ			new Mediator(_stage);						// リープモーションのセットアップ(プレイヤーへのアクセスが必要のため、この位置)			LeapSystem.setup(_stage);			//new MouseSystem(_stage);						// サウンドのセットアップ			new SoundManager();						// カメラのセットアップ			Mediator.cr = new Camera_Ranking();						// 次のフェイズへ進む			new PhaseManager();					}	}}