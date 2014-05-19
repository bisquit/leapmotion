﻿package ranking{	import com.adobe.images.JPGEncoder;		import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Loader;	import flash.display.Sprite;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.media.Camera;	import flash.media.Video;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.net.URLRequestMethod;	import flash.net.URLVariables;	import flash.profiler.Telemetry;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;	import flash.utils.ByteArray;		import core.PhaseManager;		import phase.EndPhase;
		public class Camera_Ranking extends Sprite	{		private var camera:Camera;		private var video:Video;		private var bm_cap:Bitmap;		private var bmd_cap:BitmapData;		private var score:int;		private var tf_score:TextField;				private var parse:Object;		private var loader_arr:Array = new Array();		private var tf_arr:Array = new Array();		private var count:uint;				private var IMG_W:Number;		private var IMG_H:Number;				private var rank:Number;				[Embed(source = "../assets/images/your_score.png")]		private var yourScoreImg:Class;		[Embed(source = "../assets/images/ten_big.png")]		private var tenBigImg:Class;		[Embed(source = "../assets/images/ten_small.png")]		private var tenSmallImg:Class;		[Embed(source = "../assets/images/comment_1.png")]		private var comment1Img:Class;		[Embed(source = "../assets/images/comment_2.png")]		private var comment2Img:Class;		[Embed(source = "../assets/images/comment_3.png")]		private var comment3Img:Class;		[Embed(source = "../assets/images/comment_4.png")]		private var comment4Img:Class;		[Embed(source = "../assets/images/frame_big.png")]		private var frameBigImg:Class;		[Embed(source = "../assets/images/frame_1st.png")]		private var frame1stImg:Class;		[Embed(source = "../assets/images/frame_2nd.png")]		private var frame2ndImg:Class;		[Embed(source = "../assets/images/frame_3rd.png")]		private var frame3rdImg:Class;		[Embed(source = "../assets/images/frame_small_1.png")]		private var frameSmallImg_1:Class;		[Embed(source = "../assets/images/frame_small_1.png")]		private var frameSmallImg_2:Class;		[Embed(source = "../assets/images/frame_small_1.png")]		private var frameSmallImg_3:Class;		[Embed(source = "../assets/images/frame_small_1.png")]		private var frameSmallImg_4:Class;		[Embed(source = "../assets/images/frame_small_1.png")]		private var frameSmallImg_5:Class;				public function Camera_Ranking()		{			arr_init();						// デフォルトのカメラオブジェクトを取得			camera = Camera.getCamera();						// カメラが利用可能			if(camera){				setupCamera();				setupBitmap();			}		}				private function arr_init():void {			loader_arr = new Array();			tf_arr = new Array();		}				private function setupCamera():void {						// 画像の大きさの設定			IMG_W = 220;			IMG_H = 168;						// videoの設定			video = new Video(IMG_W, IMG_H);			// videoとcameraを接続			video.attachCamera(camera);//			video.x = 320;//			video.scaleX *= -1;			//addChild(video);			// cameraの設定			camera.setMode(IMG_W, IMG_H, 60);		}				private function setupBitmap():void {						// キャプチャ用のBitmapの設定			bmd_cap = new BitmapData(IMG_W, IMG_H);			bm_cap = new Bitmap(bmd_cap);//			bm_cap.x = 320;//			bm_cap.y = 250;//			bm_cap.scaleX *= -1;//			addChild(bm_cap);					}				public function takePicture(){			bmd_cap.draw(video);			bm_cap = new Bitmap(bmd_cap);		}				// DBにスコアのみを保存する関数		public function insertScore(_score:int):void {						//bmd_cap.draw(video);			//bm_cap = new Bitmap(bmd_cap);						// スコアを設定			score = _score;			//tf_score.text = score.toString();						var urlRequest_score:URLRequest = new URLRequest("http://localhost/ScoreRanking/insert_score.php");			urlRequest_score.method = URLRequestMethod.POST;			var variables:URLVariables = new URLVariables();			variables.score = score;			urlRequest_score.data = variables;			var urlLoader_score:URLLoader = new URLLoader();			urlLoader_score.addEventListener(Event.COMPLETE, saveImg)			urlLoader_score.load(urlRequest_score);					}				// 画像を保存する関数		private function saveImg(e:Event):void {						// bmd -> jpg			var jpgE:JPGEncoder = new JPGEncoder(100);			var byteArr:ByteArray = jpgE.encode(bmd_cap);						// phpにPOST			var urlRequest_img:URLRequest = new URLRequest("http://localhost/ScoreRanking/save_img.php");			urlRequest_img.contentType = "application/octet-stream";			urlRequest_img.method = URLRequestMethod.POST;			urlRequest_img.data = byteArr;			var urlLoader_img:URLLoader = new URLLoader();			//			urlLoader_img.addEventListener(Event.COMPLETE, takeRanking);  			urlLoader_img.addEventListener(Event.COMPLETE, nextPhase); 			urlLoader_img.load(urlRequest_img);		}				private function nextPhase(e:Event = null):void {			PhaseManager.nextPhase();		}				// ランキング上位をとってくる関数		public function takeRanking(e:Event = null):void {						var urlRequest_rank:URLRequest = new URLRequest("http://localhost/ScoreRanking/take_rank.php");			var urlLoader_rank:URLLoader = new URLLoader();//			urlLoader_rank.addEventListener(Event.COMPLETE, takeComp);			urlLoader_rank.addEventListener(Event.COMPLETE, takeRank_self);			urlLoader_rank.load(urlRequest_rank);					}				private function takeRank_self(e:Event):void {						var vars:URLVariables = new URLVariables( e.target.data );			parse = JSON.parse(vars.result_arr);						var urlRequest_rank_self:URLRequest = new URLRequest("http://localhost/ScoreRanking/take_rank_self.php");			var urlLoader_rank_self:URLLoader = new URLLoader();			urlLoader_rank_self.addEventListener(Event.COMPLETE, takeComp);			urlLoader_rank_self.load(urlRequest_rank_self);		}				// とってきたスコアや画像を表示させる		private function takeComp(e:Event):void {						var vars:URLVariables = new URLVariables(e.target.data);			rank = vars.rank;			//			var vars:URLVariables = new URLVariables( e.target.data );//			parse = JSON.parse(vars.result_arr);									trace("loader_arr:" + loader_arr.length);			for(var i:uint = 0; i < loader_arr.length; i++){				if(loader_arr[i].parent){					loader_arr[i].parent.removeChild(loader_arr[i]);				}				if(tf_arr[i].parent){					tf_arr[i].parent.removeChild(tf_arr[i]);				}				loader_arr[i].unload();			}						count = 0;			loader_arr = new Array();			tf_arr = new Array();						loader_load();		}				private function loader_load():void {			var loader:Loader = new Loader();			loader.load(new URLRequest(parse[count].img_path));			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);		}				private function loadComplete(e:Event):void {			var loader:Loader = Loader(e.target.loader);			loader_arr.push(loader);			tf_arr.push(new TextField());			count++;						if(count < parse.length){				loader_load();			} else {				loader_add();			}		}				private function loader_add():void {						var yourScore = new yourScoreImg();			yourScore.scaleX = yourScore.scaleY = 0.8;			yourScore.x = 50;			yourScore.y = 50;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(yourScore);						var tenBig = new tenBigImg();			tenBig.scaleX = tenBig.scaleY = 0.8;			tenBig.x = 500;			tenBig.y = 130;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tenBig);						if( score > 0 ){				var comment = new comment1Img();				comment.scaleX = comment.scaleY = 0.8				comment.x = 170;			} else if( score > 0 ){				var comment = new comment2Img();				comment.scaleX = comment.scaleY = 0.8				comment.x = 320;			} else if( score > 0 ){				var comment = new comment3Img();				comment.scaleX = comment.scaleY = 0.8				comment.x = 150;			} else {				var comment = new comment4Img();				comment.scaleX = comment.scaleY = 0.8				comment.x = 220;			}			comment.y = 250;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(comment);						var frame_big = new frameBigImg();			frame_big.scaleX = frame_big.scaleY = 0.8;			frame_big.x = 650;			frame_big.y = 50;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_big);						var frame_1 = new frame1stImg();			frame_1.scaleX = frame_1.scaleY = 0.8;			frame_1.x = 50;			frame_1.y = 320;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_1);						var frame_2 = new frame2ndImg();			frame_2.scaleX = frame_2.scaleY = 0.8;			frame_2.x = 280;			frame_2.y = 320;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_2);						var frame_3 = new frame3rdImg();			frame_3.scaleX = frame_3.scaleY = 0.8;			frame_3.x = 510;			frame_3.y = 320;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_3);						var frame_4 = new frameSmallImg_1();			frame_4.scaleX = frame_4.scaleY = 0.8;			frame_4.x = 750;			frame_4.y = 330;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_4);						var frame_5 = new frameSmallImg_2();			frame_5.scaleX = frame_5.scaleY = 0.8;			frame_5.x = 60;			frame_5.y = 530;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_5);						var frame_6 = new frameSmallImg_3();			frame_6.scaleX = frame_6.scaleY = 0.8;			frame_6.x = 290;			frame_6.y = 530;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_6);						var frame_7 = new frameSmallImg_4();			frame_7.scaleX = frame_7.scaleY = 0.8;			frame_7.x = 520;			frame_7.y = 530;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_7);						var frame_8 = new frameSmallImg_5();			frame_8.scaleX = frame_8.scaleY = 0.8;			frame_8.x = 750;			frame_8.y = 530;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(frame_8);						// 今回のを表示			bm_cap.x = 900;			bm_cap.y = 85;			bm_cap.scaleX *= -1;			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(bm_cap);			var tf_self:TextField = new TextField();			var format_self:TextFormat = new TextFormat();			format_self.color = 0xFFFFFF;			format_self.size = 48;			tf_self.autoSize = TextFieldAutoSize.LEFT;			tf_self.defaultTextFormat = format_self;			tf_self.x = 400;			tf_self.y = 150;			tf_self.text = score.toString();			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tf_self);						// 順位を表示			var tf_rank:TextField = new TextField();			var format_rank:TextFormat = new TextFormat();			format_rank.color = 0xFFFFFF;			format_rank.size = 48;			tf_rank.autoSize = TextFieldAutoSize.LEFT;			tf_rank.defaultTextFormat = format_rank;			tf_rank.x = 100;			tf_rank.y = 150;			tf_rank.text = rank.toString() + "位";			(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tf_rank);						var row:uint = 1;			var col:uint = 1;						// ランキングの表示			for(var i:uint = 0; i < loader_arr.length; i++){				var loader:Loader = loader_arr[i];				loader.scaleX = loader.scaleY = 0.6;				loader.scaleX *= -1;				loader.x = ( loader.width + 98 ) * col - 13;				loader.y = ( loader.height + 100 ) * row + 155;				(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(loader);				var tf:TextField = tf_arr[i];				var format:TextFormat = new TextFormat();				format.color = 0xFFFFFF;				format.size = 16;				tf.autoSize = TextFieldAutoSize.LEFT;				tf.defaultTextFormat = format;				tf.x = loader.x - ( loader.width / 2 ) - ( tf.width / 2 );				tf.y = loader.y + loader.height + 40;				tf.text = parse[i].score.toString();				(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tf);								var tenSmall = new tenSmallImg();				tenSmall.scaleX = tenSmall.scaleY = 0.8;				tenSmall.x = tf.x + tf.width + 10;				tenSmall.y = tf.y;				(PhaseManager.Phases[PhaseManager.level - 1] as EndPhase).addChild(tenSmall);								if(++col > 4){					col = 1;					row++;				}			}		}			}}