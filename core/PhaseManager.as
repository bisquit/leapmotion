﻿/*  * ゲームの進行段階を管理する  * 追加で必要な段階があれば、このクラスの配列Phasesに追加する  */package  core {		import phase.IPhase;	import phase.SplashPhase;	import phase.StartPhase;	import phase.GamePhase;	import phase.EndPhase;		public class PhaseManager{				public static var Phases:Vector.<IPhase> = new Vector.<IPhase>();		public static var level:int;		private static var maxLevel:int;				public function PhaseManager(){						Phases.push(new SplashPhase());			Phases.push(new StartPhase());			Phases.push(new GamePhase());			Phases.push(new EndPhase());			level = 0;			maxLevel = Phases.length;						nextPhase();		}				public static function nextPhase():void {						if( level == 0 ){				Phases[level++].start();			} else if ( level == maxLevel ){				Phases[level - 1].destroy();				// end			} else {				Phases[level - 1].destroy();				Phases[level++].start();			}					}				public static function retry():void {
			
			// ゲーム中の音楽を流す
			SoundManager.play("bustling", true, 0.8);
						level = 2;						Phases[level + 1].destroy();			Phases[level++].start();						}
		
		public static function restart():void {
			Phases[3].destroy();
			
			level = 0;
			Phases[level++].start();
		}	}	}