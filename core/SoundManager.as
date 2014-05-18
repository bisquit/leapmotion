﻿package core {	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;	import a24.tween.Tween24;	import flash.events.Event;		public class SoundManager {				private static var ch:SoundChannel;		private static var tf:SoundTransform;				[Embed(source = "../assets/sounds/opening.mp3")]		private var OpeningSnd:Class;		[Embed(source = "../assets/sounds/ending.mp3")]		private var EndingSnd:Class;		[Embed(source = "../assets/sounds/Grab.mp3")]		private var Grab:Class;				private static var Sounds:Vector.<Sound>;				private static var soundList:Object = {			"opening": 0,			"ending": 1,			"grab": 2		}				public function SoundManager() {			Sounds = new Vector.<Sound>();			Sounds.push(new OpeningSnd());			Sounds.push(new EndingSnd());			Sounds.push(new Grab());		}				public static function play(name:String, loop:Boolean = false, vol:Number = 1):void {			var loopNum:int = 0;			if(loop){				loopNum = 100;			}			ch = Sounds[soundList[name]].play(0, loopNum);			tf = ch.soundTransform;			tf.volume = vol;			ch.soundTransform = tf;						/*if(loop){				ch.addEventListener(Event.SOUND_COMPLETE, restartSound);			}*/					}				public static function fadeOut():void {			Tween24.tween(tf, 1, Tween24.ease.CircOut, { volume: 0 }).onUpdate(updateTransform).play();			function updateTransform():void {				ch.soundTransform = tf;			}		}				/*private function restartSound(e:Event):void {			ch = snd.play(0, 100);			tf = ch.soundTransform;			tf.volume = 0.1;			ch.soundTransform = tf;		}*/	}	}