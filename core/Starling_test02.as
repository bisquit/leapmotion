﻿package core{	import flash.display.MovieClip;	import flash.display.StageAlign;	import flash.display.StageScaleMode;		import starling.core.Starling;	import flash.display.Stage;		public class Starling_test02 extends MovieClip {				public function Starling_test02(s) {						var _stage:Stage = s;						// Starlingの初期化//			Starling.handleLostContext = true;			var starling:Starling = new Starling(MainView, _stage, null, null);//			starling.enableErrorChecking = false;			starling.start();		}	}}