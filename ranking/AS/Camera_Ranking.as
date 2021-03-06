package
{
	import com.adobe.images.JPGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	public class Camera_Ranking extends Sprite
	{
		private var camera:Camera;
		private var video:Video;
		private var bm_cap:Bitmap;
		private var bmd_cap:BitmapData;
		private var score:int;
		private var tf_score:TextField;
		
		private var parse:Object;
		private var loader_arr:Array = new Array();
		private var tf_arr:Array = new Array();
		private var count:uint;
		
		public function Camera_Ranking()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			arr_init();
			
			// デフォルトのカメラオブジェクトを取得
			camera = Camera.getCamera();
			
			// カメラが利用可能
			if(camera){
				// ボタンの作成
				setupButton();
				setupTf();
				setupCamera();
				setupBitmap();
			}
		}
		
		private function arr_init():void {
			loader_arr = new Array();
			tf_arr = new Array();
		}
		
		private function setupButton():void {
			var sp_button:Sprite = new Sprite();
			sp_button.buttonMode = true;
			sp_button.graphics.beginFill(0xFF0000);
			sp_button.graphics.drawRect(400, 100, 100, 100);
			sp_button.graphics.endFill();
			addChild(sp_button);
			
			sp_button.addEventListener(MouseEvent.CLICK, insertScore);
		}
		
		private function setupTf():void {
			// キャプチャ用のTextfieldの設定
			tf_score = new TextField();
			tf_score.x = 100;
			tf_score.y = 550;
			addChild(tf_score);
		}
		
		private function setupCamera():void {
			// videoの設定
			video = new Video(320, 240);
//			video = new Video(200, 200);
			// videoとcameraを接続
			video.attachCamera(camera);
			video.x = 320;
			video.scaleX *= -1;
			addChild(video);
			// cameraの設定
			camera.setMode(320,240,60);
//			camera.setMode(200,200,60);
		}
		
		private function setupBitmap():void {
			
			// キャプチャ用のBitmapの設定
			bmd_cap = new BitmapData(320, 240);
//			bmd_cap = new BitmapData(200, 200);
			bm_cap = new Bitmap(bmd_cap);
			bm_cap.x = 320;
			bm_cap.y = 250;
			bm_cap.scaleX *= -1;
			addChild(bm_cap);
			
		}
		
		// DBにスコアのみを保存する関数
		private function insertScore(e:MouseEvent):void {
			
			bmd_cap.draw(video);
			bm_cap = new Bitmap(bmd_cap);
			
			// スコアを決める（ランダム）
			score = int(Math.random() * 1000);
			tf_score.text = score.toString();
			
			var urlRequest_score:URLRequest = new URLRequest("http://localhost/ScoreRanking/insert_score.php");
			urlRequest_score.method = URLRequestMethod.POST;
			var variables:URLVariables = new URLVariables();
			variables.score = score;
			urlRequest_score.data = variables;
			var urlLoader_score:URLLoader = new URLLoader();
			urlLoader_score.addEventListener(Event.COMPLETE, saveImg)
			urlLoader_score.load(urlRequest_score);
			
		}
		
		// 画像を保存する関数
		private function saveImg(e:Event):void {
			
			// bmd -> jpg
			var jpgE:JPGEncoder = new JPGEncoder(100);
			var byteArr:ByteArray = jpgE.encode(bmd_cap);
			// phpにPOST
			var urlRequest_img:URLRequest = new URLRequest("http://localhost/ScoreRanking/save_img.php");
			urlRequest_img.contentType = "application/octet-stream";
			urlRequest_img.method = URLRequestMethod.POST;
			urlRequest_img.data = byteArr;
			var urlLoader_img:URLLoader = new URLLoader();
			
			urlLoader_img.addEventListener(Event.COMPLETE, takeRanking);  
			urlLoader_img.load(urlRequest_img);	
		}
		
		// ランキング上位をとってくる関数
		private function takeRanking(e:Event):void {
			
			var urlRequest_rank:URLRequest = new URLRequest("http://localhost/ScoreRanking/take_rank.php");
			var urlLoader_rank:URLLoader = new URLLoader();
			urlLoader_rank.addEventListener(Event.COMPLETE, takeComp);
			urlLoader_rank.load(urlRequest_rank);
			
		}
		
		// とってきたスコアや画像を表示させる
		private function takeComp(e:Event):void {
			var vars:URLVariables = new URLVariables( e.target.data );
			parse = JSON.parse(vars.result_arr);
			
			for(var i:uint = 0; i < loader_arr.length; i++){
				removeChild(loader_arr[i]);
				removeChild(tf_arr[i]);
				loader_arr[i].unload();
			}
			
			count = 0;
			loader_arr = new Array();
			tf_arr = new Array();
			
			loader_load();
		}
		
		private function loader_load():void {
			var loader:Loader = new Loader();
			loader.load(new URLRequest(parse[count].img_path));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		}
		
		private function loadComplete(e:Event):void {
			var loader:Loader = Loader(e.target.loader);
			loader_arr.push(loader);
			tf_arr.push(new TextField());
			count++;
			
			if(count < parse.length){
				loader_load();
			} else {
				loader_add();
			}
		}
		
		private function loader_add():void {
			for(var i:uint = 0; i < loader_arr.length; i++){
				var loader:Loader = loader_arr[i];
				loader.x = 900;
				loader.y = 280 * i;
				loader.scaleX *= -1;
				addChild(loader);
				
				var tf:TextField = tf_arr[i];
				tf.x = 950;
				tf.y = 280 * i;
				tf.text = parse[i].score.toString();
				addChild(tf);
			}
		}
		
	}
}