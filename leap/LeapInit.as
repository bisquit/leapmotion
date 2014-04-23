﻿package  leap{	import com.leapmotion.leap.Controller;	import com.leapmotion.leap.events.LeapEvent;	import flash.display.Sprite;	import com.leapmotion.leap.Hand;	import objects.Player;	import flash.display.Stage;	import core.Mediator;	import objects.ScoreField;	import core.MainView;		public class LeapInit extends Sprite{		private var controller:Controller;				private var catchReady:Boolean; // 手のひらが開いているかどうか				private var _stage:Stage;		private var stageWidth:Number;		private var stageHeight:Number;		private var xScale:Number; // リープ仮想スクリーンと現実のスクリーンとの横比率		private var yScale:Number; // リープ仮想スクリーンと現実のスクリーンとの縦比率				private var palmPositionX:Number = 0;		private var palmPositionY:Number = 0;		private var palmPositionZ:Number = 0;				private var lastXPos:Number = 0;		private var lastYPos:Number = 0;		private var lastZPos:Number = 0;		private const SENSITIVITY:Number = 0.5; // 手の動きにどれくらい敏感に反応するか(0~1.0)				private var player:Player;		private var playerWidth:Number;		private var playerHeight:Number;		private var score:ScoreField;				public function LeapInit(s:Stage) {						_stage = s;			stageWidth = _stage.stageWidth;			stageHeight = _stage.stageHeight;			xScale = LeapScreen.xScale(stageWidth);			yScale = LeapScreen.yScale(stageHeight);						player = Mediator.player;			playerWidth = player.width;			playerHeight = player.height;			catchReady = false;						// リープ起動			controller = new Controller();			controller.addEventListener(LeapEvent.LEAPMOTION_CONNECTED, onLeapConnect);		}				private function onLeapConnect(e:LeapEvent):void{			controller.addEventListener(LeapEvent.LEAPMOTION_FRAME, onLeapFrame);		}				private function onLeapFrame(e:LeapEvent):void{						var hands:Vector.<Hand> = e.frame.hands;			if(hands.length === 1){								var hand:Hand = hands[0];								palmPositionX = hand.palmPosition.x;				palmPositionY = hand.palmPosition.y;				palmPositionZ = hand.palmPosition.z;								// 一定の閾値を超えたら除外				// x座標について				if(palmPositionX > LeapScreen.halfWidth + LeapScreen.padding ||				    palmPositionX < - LeapScreen.halfWidth - LeapScreen.padding){						return;				}				// y座標について				if(palmPositionY > LeapScreen.top || palmPositionY < LeapScreen.marginBottom){					return;				}				// z座標について				if(palmPositionZ > LeapScreen.halfDepth + LeapScreen.padding ||				    palmPositionZ < - LeapScreen.halfDepth - LeapScreen.padding){						return;				}				trace(palmPositionZ);								// 一定の回転によっても除外				if(hand.palmNormal.y > - 0.7){					catchReady = false;					return;				}									// 手が開かれていない時				if( !catchReady ){					// 指を2本以上認識したら手が開いた状態と評価する					if(hand.fingers.length >= 2){						catchReady = true;						Mediator.changeHandState(HandState.DEFAULT);					}									// 手が開かれた時				}else if( catchReady ){										// 指が１本以下になったら手を握った状態と評価する					if(hand.fingers.length <= 1){						catchReady = false;						Mediator.changeHandState(HandState.CATCH);												// さらに衝突発生時であれば、星をキャッチしたと判定						if(Mediator.isCollide){							if(Mediator.collideStar.isStartStar){								Mediator.startGame();							}							Mediator.collideStar.delete_flag = true;							Mediator.endCollision(true);							Mediator.changeScore();						}					}				}												/*				  * 座標の更新				  * １フレーム前の座標(lastXpos)と現在フレームの座標の加重平均を取る				  * SENSITIVITYが1.0に近いほど現在フレームへの重みが増す=>より敏感に反応する				  * SENSITIVITYが0に近いほど現在フレームの影響が減る=>鈍くなるが滑らかに動く				  */								//リープを上向きにおく場合				if(Math.abs(palmPositionX - lastXPos) > 30){					lastXPos = palmPositionX * xScale  +  stageWidth / 2;				}				if(palmPositionX > LeapScreen.width / 2 - playerWidth /(2 * xScale)){					palmPositionX = LeapScreen.width / 2 - playerWidth /(2 * xScale);				}else if(palmPositionX < -LeapScreen.width / 2 + playerWidth /(2 * xScale)){					palmPositionX = -LeapScreen.width / 2 + playerWidth /(2 * xScale);				}				Mediator.Sx =  lastXPos * (1-SENSITIVITY) + (palmPositionX * xScale  +  stageWidth / 2) * SENSITIVITY;				lastXPos = Mediator.Sx;				if(Mediator.Sx > stageWidth - playerWidth / 2){					Mediator.Sx = stageWidth - playerWidth / 2;				}else if(Mediator.Sx < playerWidth /2){					Mediator.Sx = playerWidth /2;				}								if(Math.abs(palmPositionY - lastYPos) > 30){					lastYPos = stageHeight  -  ( palmPositionY - LeapScreen.marginBottom - LeapScreen.padding ) * yScale;				}				if(palmPositionY < LeapScreen.marginBottom + LeapScreen.padding + playerHeight/(2 * yScale)){					palmPositionY = LeapScreen.marginBottom + LeapScreen.padding + playerHeight/(2 * yScale);				}else if(palmPositionY > LeapScreen.top - LeapScreen.padding - playerHeight/(2 * yScale)){					palmPositionY = LeapScreen.top - LeapScreen.padding - playerHeight/(2 * yScale);				}				Mediator.Sy = lastYPos * (1-SENSITIVITY) + 					(stageHeight  -  ( palmPositionY - LeapScreen.marginBottom - LeapScreen.padding ) * yScale) * SENSITIVITY;				lastYPos = Mediator.Sy;				if(Mediator.Sy > stageHeight - playerHeight / 2){					Mediator.Sy = stageHeight - playerHeight / 2;				}else if(Mediator.Sy < playerHeight / 2){					Mediator.Sy = playerHeight / 2;				}								// リープを手前向きにおく場合				/*var palmPositionX:Number = palmPositionX;				if(Math.abs(palmPositionX - lastXPos) > 30){					lastXPos = palmPositionX * xScale  +  stageWidth / 2;				}				if(palmPositionX > LeapScreen.width / 2 - playerWidth /(2 * xScale)){					palmPositionX = LeapScreen.width / 2 - playerWidth /(2 * xScale);				}else if(palmPositionX < -LeapScreen.width / 2 + playerWidth /(2 * xScale)){					palmPositionX = -LeapScreen.width / 2 + playerWidth /(2 * xScale);				}				Mediator.Sx =  lastXPos * (1-SENSITIVITY) + (palmPositionX * xScale  +  stageWidth / 2) * SENSITIVITY;				lastXPos = Mediator.Sx;				if(Mediator.Sx > stageWidth - playerWidth / 2){					Mediator.Sx = stageWidth - playerWidth / 2;				}else if(Mediator.Sx < playerWidth /2){					Mediator.Sx = playerWidth /2;				}								var palmPositionZ:Number = palmPositionZ;				if(Math.abs(palmPositionZ - lastZPos) > 30){					lastZPos = palmPositionZ * yScale;				}				if(palmPositionZ < LeapScreen.bottom + playerHeight/(2 * yScale)){					palmPositionZ = LeapScreen.bottom + playerHeight/(2 * yScale);				}else if(palmPositionZ > LeapScreen.top - playerHeight/(2 * yScale)){					palmPositionZ = LeapScreen.top - playerHeight/(2 * yScale);				}				Mediator.Sy = lastZPos * (1-SENSITIVITY) + (palmPositionZ * yScale) * SENSITIVITY;				lastZPos = Mediator.Sy;				if(Mediator.Sy > stageHeight - playerHeight / 2){					Mediator.Sy = stageHeight - playerHeight / 2;				}else if(Mediator.Sy < playerHeight / 2){					Mediator.Sy = playerHeight / 2;				}*/											} // if ( hands.length > 0 )					} // onLeapFrame	}	}