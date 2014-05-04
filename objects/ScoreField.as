﻿package  objects{	import flash.text.TextField;	import flash.text.TextFieldType;	import flash.text.TextFormat;	import flash.text.TextFormatAlign;	import flash.display.Sprite;	import flash.events.Event;	import a24.tween.Tween24;		public class ScoreField extends Sprite{				private var score:int;		private var display_text:int;		private var holding_score:int;				private var score_text:TextField;		private var unit_text:TextField;				private var tf:TextFormat;				private var isSloting:Boolean = false;		private var frame:uint = 0;				private var multiplier:int = 1;				public function ScoreField() {			score = 0;			display_text = 0;			holding_score = 0;						score_text = new TextField();		    unit_text = new TextField();						tf = new TextFormat();			tf.align = TextFormatAlign.CENTER;			tf.size = 80;			tf.font = "shinagino";			score_text.type = TextFieldType.DYNAMIC;			score_text.defaultTextFormat = tf;			score_text.embedFonts = true;			score_text.width = 250;			score_text.height = 100;			score_text.textColor = 0xb4e2da;			score_text.text = display_text.toString();			score_text.x = - score_text.width/2;			score_text.y = - score_text.height/2;						unit_text.defaultTextFormat = tf;			unit_text.x = score_text.width;			unit_text.width = 60;			unit_text.text = "";						addChild(score_text);			addChild(unit_text);		}				/* 加算する点数を一旦保留する */		public function holdScore(_point:int, _combo:int):void {			multiplier = Math.floor(_combo * 0.2) + 1;			holding_score += _point * multiplier;		}				/* 保留されている点数を実際に反映させる */		public function changeScore():void{			//trace("ch score");			this.score += holding_score;			holding_score = 0;						if(this.score < 0){				this.score = 0;			}			if( ! isSloting ){				addEventListener(Event.ENTER_FRAME, slotScore);				isSloting = true;			}		}				/* 内部で保持するスコアと表示されているスコアに差異があればスロットをまわす */		private function slotScore(e:Event):void {						var diff:int = this.score - this.display_text;			if(diff > 0){				if(diff > 100){					display_text += 10				}else{					display_text += 1;				}				if(frame === 0){					beginEffect();				} else if(diff == 2){					endEffect();				}				frame++;							}else if(diff < 0){				display_text -= 1;			}else{				removeEventListener(Event.ENTER_FRAME, slotScore);				isSloting = false;				frame = 0;			}						score_text.text = display_text.toString();		}				private function beginEffect():void {			Tween24.tween(this, 0.3, Tween24.ease.CircOut).scale(1.1).play();		}				private function endEffect():void {			Tween24.tween(this, 0.2).scale(1).play();		}				public function comboToMulti(combo:int):int {						if(combo % 5 === 0){				multiplier = combo / 5 + 1;			}			return multiplier;		}				public function destroy():void {			removeEventListener(Event.ENTER_FRAME, slotScore);			removeChild(score_text);			score_text = null;		}	}	}