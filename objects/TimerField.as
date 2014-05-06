﻿package objects{	import flash.display.Sprite;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.text.TextFormatAlign;	import flash.text.TextFieldType;	import flash.text.AntiAliasType;	import flash.utils.setTimeout;	import core.Mediator;	import phase.GamePhase;	public class TimerField extends Sprite {		public var time:Number;		private var time_text:TextField; // 時間表示部分		private var unit_text:TextField; // 単位(sec)表示部分		private var tf:TextFormat;		//		[Embed(source="../assets/fonts/Fonts.swf", fontName="shinagino")]//		private var embedFont:Class;				public function TimerField() {			time = 0;			time_text = new TextField();			unit_text = new TextField();			tf = new TextFormat();			tf.align = TextFormatAlign.CENTER;			tf.size = 80;			tf.font = "shinagino";			time_text.type = TextFieldType.DYNAMIC;			time_text.defaultTextFormat = tf;			time_text.embedFonts = true;			time_text.width = 250;			time_text.height = 100;			time_text.x = - time_text.width/2;			time_text.y = - time_text.height/2;			time_text.textColor = 0xb4e2da;			time_text.text = time.toFixed(2);						addChild(time_text);		}				public function start(limit:Number = 30):void {			this.time = limit;			update();		}				private function update():void {			this.time -= 0.07;			if(this.time <= 0){				this.time = 0;				time_text.text = this.time.toFixed(2);				(parent as GamePhase).end();				return;			}			time_text.text = this.time.toFixed(2);						setTimeout(update, 70);		}				public function destroy():void {			removeChild(time_text);			time_text = null;		}	}}