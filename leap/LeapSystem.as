﻿/*  * LeapMotionの起動とフレームイベントの設定  * 座標情報とキャッチ動作を判定する*/package  leap {	import com.leapmotion.leap.Controller;	import flash.display.Stage;	import objects.Player;	import core.Mediator;	import com.leapmotion.leap.events.LeapEvent;	import com.leapmotion.leap.Hand;		public class LeapSystem {				private static var controller:Controller;				private static var _stage:Stage;		private static var stageWidth:Number;		private static var stageHeight:Number;		private static var xScale:Number; // リープ仮想スクリーンと現実のスクリーンとの横比率		private static var yScale:Number; // リープ仮想スクリーンと現実のスクリーンとの縦比率				private static var palmPositionX:Number = 0;		private static var palmPositionY:Number = 0;		private static var palmPositionZ:Number = 0;				private static var lastXPos:Number = 0;		private static var lastYPos:Number = 0;		private static var lastZPos:Number = 0;		private static const SENSITIVITY:Number = 0.5; // 手の動きにどれくらい敏感に反応するか(0~1.0)				private static var _player:Player;		private static var playerWidth:Number;		private static var playerHeight:Number;				public static function setup(s:Stage):void{						_stage = s;			stageWidth = _stage.stageWidth;			stageHeight = _stage.stageHeight;			xScale = LeapScreen.xScale(stageWidth);			yScale = LeapScreen.yScale(stageHeight);						_player = Mediator._player;			playerWidth = _player.width;			playerHeight = _player.height;						// リープ起動			controller = new Controller();			controller.addEventListener(LeapEvent.LEAPMOTION_CONNECTED, onLeapConnect);					}				private static function onLeapConnect(e:LeapEvent):void{			controller.addEventListener(LeapEvent.LEAPMOTION_FRAME, onLeapFrame);		}				private static function onLeapFrame(e:LeapEvent):void{						var hands:Vector.<Hand> = e.frame.hands;			if(hands.length === 1){								var hand:Hand = hands[0];								palmPositionX = hand.palmPosition.x;				palmPositionY = hand.palmPosition.y;				palmPositionZ = hand.palmPosition.z;								// 一定の閾値を超えたら除外				// x座標について				if(palmPositionX > LeapScreen.halfWidth + LeapScreen.padding ||				    palmPositionX < - LeapScreen.halfWidth - LeapScreen.padding){						Mediator._player.visible = false;						return;				}				// y座標について				if(palmPositionY > LeapScreen.top || palmPositionY < LeapScreen.marginBottom){					Mediator._player.visible = false;					return;				}				// z座標について				if(palmPositionZ > LeapScreen.halfDepth + LeapScreen.padding ||				    palmPositionZ < - LeapScreen.halfDepth - LeapScreen.padding){						Mediator._player.visible = false;						return;				}								// 一定の回転によっても除外				if(hand.palmNormal.y > - 0.7){					Mediator._player.visible = false;					return;				}								Mediator._player.visible = true;									// 手が開かれていない時				if( Mediator.isCatching ){					// 指を2本以上認識したら手が開いた状態と評価する					if(hand.fingers.length >= 2){						Mediator.isCatching = false;						Mediator._player.defaultState();					}									// 手が開かれた時				}else if( ! Mediator.isCatching ){										// 指が１本以下になったら手を握った状態と評価する					if(hand.fingers.length <= 1){						Mediator.isCatching = true;						Mediator._player.catchState();												// さらに衝突発生時であれば、星をキャッチしたと判定						if(Mediator.isCollide){							Mediator.collideStar.delete_flag = true;							Mediator.endCollision();							Mediator.changeScore();						}					}				}												/*				  * 座標の更新				  * １フレーム前の座標(lastXpos)と現在フレームの座標の加重平均を取る				  * SENSITIVITYが1.0に近いほど現在フレームへの重みが増す=>より敏感に反応する				  * SENSITIVITYが0に近いほど現在フレームの影響が減る=>鈍くなるが滑らかに動く				  */								//リープを上向きにおく場合				if(Math.abs(palmPositionX - lastXPos) > 30){					lastXPos = palmPositionX * xScale  +  stageWidth / 2;				}				if(palmPositionX > LeapScreen.width / 2 - playerWidth /(2 * xScale)){					palmPositionX = LeapScreen.width / 2 - playerWidth /(2 * xScale);				}else if(palmPositionX < -LeapScreen.width / 2 + playerWidth /(2 * xScale)){					palmPositionX = -LeapScreen.width / 2 + playerWidth /(2 * xScale);				}				Mediator.Sx =  lastXPos * (1-SENSITIVITY) + (palmPositionX * xScale  +  stageWidth / 2) * SENSITIVITY;				lastXPos = Mediator.Sx;				if(Mediator.Sx > stageWidth - playerWidth / 2){					Mediator.Sx = stageWidth - playerWidth / 2;				}else if(Mediator.Sx < playerWidth /2){					Mediator.Sx = playerWidth /2;				}								if(Math.abs(palmPositionY - lastYPos) > 30){					lastYPos = stageHeight  -  ( palmPositionY - LeapScreen.marginBottom - LeapScreen.padding ) * yScale;				}				if(palmPositionY < LeapScreen.marginBottom + LeapScreen.padding + playerHeight/(2 * yScale)){					palmPositionY = LeapScreen.marginBottom + LeapScreen.padding + playerHeight/(2 * yScale);				}else if(palmPositionY > LeapScreen.top - LeapScreen.padding - playerHeight/(2 * yScale)){					palmPositionY = LeapScreen.top - LeapScreen.padding - playerHeight/(2 * yScale);				}				Mediator.Sy = lastYPos * (1-SENSITIVITY) + 					(stageHeight  -  ( palmPositionY - LeapScreen.marginBottom - LeapScreen.padding ) * yScale) * SENSITIVITY;				lastYPos = Mediator.Sy;				if(Mediator.Sy > stageHeight - playerHeight / 2){					Mediator.Sy = stageHeight - playerHeight / 2;				}else if(Mediator.Sy < playerHeight / 2){					Mediator.Sy = playerHeight / 2;				}							} // if ( hands.length > 0 )					} // onLeapFrame	}	}