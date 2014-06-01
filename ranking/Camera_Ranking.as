﻿package ranking{	import com.adobe.images.JPGEncoder;		import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Loader;	import flash.display.Sprite;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.media.Camera;	import flash.media.Video;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.net.URLRequestMethod;	import flash.net.URLVariables;	import flash.profiler.Telemetry;	import flash.system.Security;	import flash.system.SecurityPanel;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;	import flash.utils.ByteArray;	import flash.utils.clearInterval;	import flash.utils.setInterval;		import core.Mediator;	import core.PhaseManager;		import phase.EndPhase;		public class Camera_Ranking extends Sprite	{		private var camera:Camera;		private var video:Video;		private var bm_cap:Bitmap;		private var bmd_cap:BitmapData;		private var score:int;		private var tf_score:TextField;				private var parse:Object;		private var loader_arr:Array = new Array();		private var tf_arr:Array = new Array();		private var count:uint;				private var IMG_W:Number;		private var IMG_H:Number;				private var RANK_TIMER:Number;				private var rank:Number;		public var interval_time:uint;				private var myFont:Shinagino;				[Embed(source = "../assets/images/your_score.png")]		private var yourScoreImg:Class;		[Embed(source = "../assets/images/ten_big.png")]		private var tenBigImg:Class;		[Embed(source = "../assets/images/ten_small.png")]		private var tenSmallImg:Class;		[Embed(source = "../assets/images/i_big.png")]		private var iBigImg:Class;		[Embed(source = "../assets/images/comment_1.png")]		private var comment1Img:Class;		[Embed(source = "../assets/images/comment_2.png")]		private var comment2Img:Class;		[Embed(source = "../assets/images/comment_3.png")]		private var comment3Img:Class;		[Embed(source = "../assets/images/comment_4.png")]		private var comment4Img:Class;		[Embed(source = "../assets/images/frame_big.png")]		private var frameBigImg:Class;		[Embed(source = "../assets/images/frame_1st.png")]		private var frame1stImg:Class;		[Embed(source = "../assets/images/frame_2nd.png")]		private var frame2ndImg:Class;		[Embed(source = "../assets/images/frame_3rd.png")]		private var frame3rdImg:Class;		[Embed(source = "../assets/images/frame_small_1.png")]		private var frameSmallImg_1:Class;		[Embed(source = "../assets/images/frame_small_2.png")]		private var frameSmallImg_2:Class;		[Embed(source = "../assets/images/frame_small_3.png")]		private var frameSmallImg_3:Class;		[Embed(source = "../assets/images/frame_small_1.png")]		private var frameSmallImg_4:Class;		[Embed(source = "../assets/images/frame_small_2.png")]		private var frameSmallImg_5:Class;		[Embed(source = "../assets/images/frame_small_shadow.png")]		private var shadowSmallImg:Class;		[Embed(source = "../assets/images/frame_ranker_shadow.png")]		private var shadowRankerImg:Class;		[Embed(source = "../assets/images/frame_big_shadow.png")]		private var shadowBigImg:Class;				public function Camera_Ranking()		{			arr_init();						// 使うカメラを選択			Security.showSettings(SecurityPanel.CAMERA);						// デフォルトのカメラオブジェクトを取得			camera = Camera.getCamera();						// カメラが利用可能			if(camera){				setupCamera();				setupBitmap();			}		}				private function arr_init():void {			loader_arr = new Array();			tf_arr = new Array();		}				private function setupCamera():void {						// 画像の大きさの設定			IMG_W = 225;			IMG_H = 176;						// 制限時間			RANK_TIMER = 30;						// フォントの設定			myFont = new Shinagino();						// videoの設定			video = new Video(IMG_W, IMG_H);			// videoとcameraを接続			video.attachCamera(camera);//			video.x = 320;//			video.scaleX *= -1;			//addChild(video);			// cameraの設定			camera.setMode(IMG_W, IMG_H, 60);		}				private function setupBitmap():void {						// キャプチャ用のBitmapの設定			bmd_cap = new BitmapData(IMG_W, IMG_H);			bm_cap = new Bitmap(bmd_cap);//			bm_cap.x = 320;//			bm_cap.y = 250;//			bm_cap.scaleX *= -1;//			addChild(bm_cap);					}				public function takePicture(){			bmd_cap.draw(video);			bm_cap = new Bitmap(bmd_cap);		}				// DBにスコアのみを保存する関数		public function insertScore(_score:int):void {						//bmd_cap.draw(video);			//bm_cap = new Bitmap(bmd_cap);						// スコアを設定			score = _score;			//tf_score.text = score.toString();						var urlRequest_score:URLRequest = new URLRequest("http://localhost/ScoreRanking/insert_score.php");			urlRequest_score.method = URLRequestMethod.POST;			var variables:URLVariables = new URLVariables();			variables.score = score;			urlRequest_score.data = variables;			var urlLoader_score:URLLoader = new URLLoader();			urlLoader_score.addEventListener(Event.COMPLETE, saveImg)			urlLoader_score.load(urlRequest_score);					}				// 画像を保存する関数		private function saveImg(e:Event):void {						// bmd -> jpg			var jpgE:JPGEncoder = new JPGEncoder(100);			var byteArr:ByteArray = jpgE.encode(bmd_cap);						// phpにPOST			var urlRequest_img:URLRequest = new URLRequest("http://localhost/ScoreRanking/save_img.php");			urlRequest_img.contentType = "application/octet-stream";			urlRequest_img.method = URLRequestMethod.POST;			urlRequest_img.data = byteArr;			var urlLoader_img:URLLoader = new URLLoader();			//			urlLoader_img.addEventListener(Event.COMPLETE, takeRanking);  			urlLoader_img.addEventListener(Event.COMPLETE, nextPhase); 			urlLoader_img.load(urlRequest_img);		}				private function nextPhase(e:Event = null):void {			PhaseManager.nextPhase();		}				// ランキング上位をとってくる関数		public function takeRanking(e:Event = null):void {						var urlRequest_rank:URLRequest = new URLRequest("http://localhost/ScoreRanking/take_rank.php");			var urlLoader_rank:URLLoader = new URLLoader();//			urlLoader_rank.addEventListener(Event.COMPLETE, takeComp);			urlLoader_rank.addEventListener(Event.COMPLETE, takeRank_self);			urlLoader_rank.load(urlRequest_rank);					}				private function takeRank_self(e:Event):void {						var vars:URLVariables = new URLVariables( e.target.data );			parse = JSON.parse(vars.result_arr);						var urlRequest_rank_self:URLRequest = new URLRequest("http://localhost/ScoreRanking/take_rank_self.php");			var urlLoader_rank_self:URLLoader = new URLLoader();			urlLoader_rank_self.addEventListener(Event.COMPLETE, takeComp);			urlLoader_rank_self.load(urlRequest_rank_self);		}				// とってきたスコアや画像を表示させる		private function takeComp(e:Event):void {						var vars:URLVariables = new URLVariables(e.target.data);			rank = vars.rank;			//			var vars:URLVariables = new URLVariables( e.target.data );//			parse = JSON.parse(vars.result_arr);									trace("loader_arr:" + loader_arr.length);			for(var i:uint = 0; i < loader_arr.length; i++){				if(loader_arr[i].parent){					loader_arr[i].parent.removeChild(loader_arr[i]);				}				if(tf_arr[i].parent){					tf_arr[i].parent.removeChild(tf_arr[i]);				}				loader_arr[i].unload();			}						count = 0;			loader_arr = new Array();			tf_arr = new Array();						loader_load();		}				private function loader_load():void {			var loader:Loader = new Loader();			loader.load(new URLRequest(parse[count].img_path));			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);		}				private function loadComplete(e:Event):void {			var loader:Loader = Loader(e.target.loader);			loader_arr.push(loader);			tf_arr.push(new TextField());			count++;						if(count < parse.length){				loader_load();			} else {				loader_add();								// 制限時間開始				var tf_time:TextField = new TextField();				var format_time:TextFormat = new TextFormat();				format_time.color = 0x8aff0c;				format_time.size = 60;				format_time.kerning = true;				format_time.letterSpacing = -2;				format_time.font = myFont.fontName;				tf_time.autoSize = TextFieldAutoSize.RIGHT;				tf_time.defaultTextFormat = format_time;				tf_time.embedFonts = true;				tf_time.x = Mediator.stageWidth - 200;				tf_time.y = Mediator.stageHeight - 320;				tf_time.text = RANK_TIMER.toString();				(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tf_time);								interval_time = setInterval( function():void {										if(RANK_TIMER == 0){						clearInterval( interval_time );												// ここに終了後をかく											} else {						RANK_TIMER--;						tf_time.text = RANK_TIMER.toString();					}									}, 1000 );							}		}				// 制限時間をクリア		public function clear_interval():void{			RANK_TIMER = 30;			clearInterval( interval_time );		}				private function loader_add():void {						var yourScore = new yourScoreImg();			yourScore.scaleX = yourScore.scaleY = 0.8;			yourScore.x = 170;			yourScore.y = 50;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(yourScore);						var tenBig = new tenBigImg();			tenBig.scaleX = tenBig.scaleY = 0.6;			tenBig.x = 670;			tenBig.y = 155;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tenBig);						var iBig = new iBigImg();			iBig.scaleX = iBig.scaleY = 0.9;			iBig.x = 320;			iBig.y = 166;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(iBig);						if( score > 0 ){				var comment1 = new comment1Img();				comment1.scaleX = comment1.scaleY = 0.8				comment1.x = 340;				comment1.y = 240;				(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(comment1);			} else if( score > 0 ){				var comment2 = new comment2Img();				comment2.scaleX = comment2.scaleY = 0.8				comment2.x = 490;				comment2.y = 245;				(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(comment2);			} else if( score > 0 ){				var comment3 = new comment3Img();				comment3.scaleX = comment3.scaleY = 0.8				comment3.x = 320;				comment3.y = 245;				(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(comment3);			} else {				var comment4 = new comment4Img();				comment4.scaleX = comment4.scaleY = 0.8				comment4.x = 390;				comment4.y = 245;				(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(comment4);			}						// 影を表示			var shadow_big = new shadowBigImg();			shadow_big.scaleX = shadow_big.scaleY = 0.9;			shadow_big.x = 830;			shadow_big.y = 60;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(shadow_big);						var shadow_ranker1 = new shadowRankerImg();			shadow_ranker1.scaleX = shadow_ranker1.scaleY = 0.9;			shadow_ranker1.x = 230;			shadow_ranker1.y = 330;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(shadow_ranker1);						var shadow_ranker2 = new shadowRankerImg();			shadow_ranker2.scaleX = shadow_ranker2.scaleY = 0.9;			shadow_ranker2.x = 540;			shadow_ranker2.y = 330;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(shadow_ranker2);						var shadow_ranker3 = new shadowRankerImg();			shadow_ranker3.scaleX = shadow_ranker3.scaleY = 0.9;			shadow_ranker3.x = 850;			shadow_ranker3.y = 330;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(shadow_ranker3);						var shadow_small1 = new shadowSmallImg();			shadow_small1.scaleX = shadow_small1.scaleY = 0.9;			shadow_small1.x = 140;			shadow_small1.y = 590;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(shadow_small1);						var shadow_small2 = new shadowSmallImg();			shadow_small2.scaleX = shadow_small2.scaleY = 0.9;			shadow_small2.x = 340;			shadow_small2.y = 590;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(shadow_small2);			var shadow_small3 = new shadowSmallImg();			shadow_small3.scaleX = shadow_small3.scaleY = 0.9;			shadow_small3.x = 540;			shadow_small3.y = 590;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(shadow_small3);			var shadow_small4 = new shadowSmallImg();			shadow_small4.scaleX = shadow_small4.scaleY = 0.9;			shadow_small4.x = 740;			shadow_small4.y = 590;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(shadow_small4);			var shadow_small5 = new shadowSmallImg();			shadow_small5.scaleX = shadow_small5.scaleY = 0.9;			shadow_small5.x = 940;			shadow_small5.y = 590;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(shadow_small5);						// 今回の得点を表示			bm_cap.x = 1060;			bm_cap.y = 70;			bm_cap.scaleX *= -1;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(bm_cap);			var tf_self:TextField = new TextField();			var format_self:TextFormat = new TextFormat();			format_self.color = 0x31bbe8;			format_self.size = 90;			format_self.kerning = true;			format_self.letterSpacing = -2;			format_self.font = myFont.fontName;			tf_self.autoSize = TextFieldAutoSize.RIGHT;			tf_self.defaultTextFormat = format_self;			tf_self.embedFonts = true;			tf_self.x = 640;			tf_self.y = 128;			tf_self.text = score.toString();			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tf_self);						// 順位を表示			var tf_rank:TextField = new TextField();			var format_rank:TextFormat = new TextFormat();			format_rank.color = 0x31bbe8;			format_rank.size = 90;			format_rank.kerning = true;			format_rank.letterSpacing = -2;			format_rank.font = myFont.fontName;			tf_rank.autoSize = TextFieldAutoSize.RIGHT;			tf_rank.defaultTextFormat = format_rank;			tf_rank.embedFonts = true;			tf_rank.x = 290;			tf_rank.y = 125;			tf_rank.text = rank.toString();			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tf_rank);						// ランキングの表示			for(var i:uint = 0; i < loader_arr.length; i++){								var loader:Loader = loader_arr[i];				var tf:TextField = tf_arr[i];				var format:TextFormat = new TextFormat();				format.color = 0x31bbe8;				format.size = 30;				format.kerning = true;				format.letterSpacing = -2;				format.font = myFont.fontName;								tf.autoSize = TextFieldAutoSize.RIGHT;				tf.defaultTextFormat = format;				tf.embedFonts = true;								var tenSmall = new tenSmallImg();								if( i < 3 ) {									loader.scaleX = loader.scaleY = 0.72;					loader.scaleX *= -1;					loader.x = 250 + loader.width + 310 * i;					loader.y = 348;					(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(loader);						tf.x = loader.x - ( loader.width / 2 ) - ( tf.width / 2 );					tf.y = loader.y + loader.height + 25;					tf.text = parse[i].score.toString();					(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tf);										tenSmall.scaleX = tenSmall.scaleY = 0.8;					tenSmall.x = tf.x + tf.width + 10;					tenSmall.y = tf.y + 10;					(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tenSmall);								} else {										loader.scaleX = loader.scaleY = 0.55;					loader.scaleX *= -1;					loader.x = 145 + loader.width + 200 * ( i - 3 );					loader.y = 595;					(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(loader);										tf.x = loader.x - ( loader.width / 2 ) - ( tf.width / 2 );					tf.y = loader.y + loader.height + 30;					tf.text = parse[i].score.toString();					(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tf);										tenSmall.scaleX = tenSmall.scaleY = 0.8;					tenSmall.x = tf.x + tf.width + 10;					tenSmall.y = tf.y;					(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tenSmall);									}							}						// 額縁を表示			var frame_big = new frameBigImg();			frame_big.scaleX = frame_big.scaleY = 0.9;			frame_big.x = 820;			frame_big.y = 50;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_big);						var frame_1 = new frame1stImg();			frame_1.scaleX = frame_1.scaleY = 0.9;			frame_1.x = 220;			frame_1.y = 320;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_1);						var frame_2 = new frame2ndImg();			frame_2.scaleX = frame_2.scaleY = 0.9;			frame_2.x = 530;			frame_2.y = 320;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_2);						var frame_3 = new frame3rdImg();			frame_3.scaleX = frame_3.scaleY = 0.9;			frame_3.x = 840;			frame_3.y = 320;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_3);						var frame_4 = new frameSmallImg_1();			frame_4.scaleX = frame_4.scaleY = 0.9;			frame_4.x = 130;			frame_4.y = 580;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_4);						var frame_5 = new frameSmallImg_2();			frame_5.scaleX = frame_5.scaleY = 0.9;			frame_5.x = 330;			frame_5.y = 580;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_5);						var frame_6 = new frameSmallImg_3();			frame_6.scaleX = frame_6.scaleY = 0.9;			frame_6.x = 530;			frame_6.y = 580;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_6);						var frame_7 = new frameSmallImg_4();			frame_7.scaleX = frame_7.scaleY = 0.9;			frame_7.x = 730;			frame_7.y = 580;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_7);						var frame_8 = new frameSmallImg_5();			frame_8.scaleX = frame_8.scaleY = 0.9;			frame_8.x = 930;			frame_8.y = 580;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_8);					}			}}