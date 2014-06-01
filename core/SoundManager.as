﻿package core {	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;	import a24.tween.Tween24;	import flash.events.Event;		public class SoundManager {				//private static var ch:SoundChannel;		//private static var tf:SoundTransform;				[Embed(source = "../assets/sounds/opening.mp3")]		private var OpeningSnd:Class;		[Embed(source = "../assets/sounds/ending.mp3")]		private var EndingSnd:Class;		[Embed(source = "../assets/sounds/Grab.mp3")]		private var Grab:Class;		[Embed(source = "../assets/sounds/Select.mp3")]		private var Select:Class;		[Embed(source = "../assets/sounds/Club_of_the_universe.mp3")]		private var Universe:Class;		[Embed(source = "../assets/sounds/Bustling_space2.mp3")]		private var Bustling:Class;		[Embed(source = "../assets/sounds/Pass3.mp3")]		private var Kira:Class;				/*[Embed(source = "../assets/sounds/shine1.mp3")]		private var Shine:Class;		[Embed(source = "../assets/sounds/se_maoudamashii_onepoint28.mp3")]		private var Damaged:Class;		[Embed(source = "../assets/sounds/se_maoudamashii_onepoint07.mp3")]		private var Combo:Class;*/				private static var Sounds:Vector.<Sound>;				private static var soundList:Object = {			"opening": 0,			"ending": 1,			"grab": 2,			"select": 3,			"uni": 4,			"bustling": 5,			"kira": 6,			"shine": 7,			"damaged": 8,			"combo": 9					}				private static var channelList:Vector.<SoundChannel>;				public function SoundManager() {			Sounds = new Vector.<Sound>();			Sounds.push(new OpeningSnd());			Sounds.push(new EndingSnd());			Sounds.push(new Grab());			Sounds.push(new Select());			Sounds.push(new Universe());			Sounds.push(new Bustling());			Sounds.push(new Kira());			//Sounds.push(new Shine());			//Sounds.push(new Damaged());			//Sounds.push(new Combo());						channelList = new Vector.<SoundChannel>(10);		}				public static function play(name:String, loop:Boolean = false, vol:Number = 1):void {			var loopNum:int = 0;			if(loop){				loopNum = 100;			}			var ch = Sounds[soundList[name]].play(0, loopNum);			var tf = ch.soundTransform;			tf.volume = vol;			ch.soundTransform = tf;						channelList[soundList[name]] = ch;						/*if(loop){				ch.addEventListener(Event.SOUND_COMPLETE, restartSound);			}*/					}				public static function fadeOut(name:String):void {			var ch = channelList[soundList[name]];			var tf = ch.soundTransform;			Tween24.tween(tf, 1, Tween24.ease.CircOut, { volume: 0 }).onUpdate(updateTransform).play();			function updateTransform():void {				ch.soundTransform = tf;			}		}				/*private function restartSound(e:Event):void {			ch = snd.play(0, 100);			tf = ch.soundTransform;			tf.volume = 0.1;			ch.soundTransform = tf;		}*/	}	}