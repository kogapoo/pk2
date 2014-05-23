package pk2 {
	import flash.net.*;
	import jp.progression.casts.*;
	import jp.progression.commands.display.*;
	import jp.progression.commands.lists.*;
	import jp.progression.commands.managers.*;
	import jp.progression.commands.media.*;
	import jp.progression.commands.net.*;
	import jp.progression.commands.tweens.*;
	import jp.progression.commands.*;
	import jp.progression.data.*;
	import jp.progression.events.*;
	import jp.progression.executors.*;
	
	import pk2.ui.LoaderContainer;
	import flash.display.StageAlign;
	import flash.system.Security;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Preloader extends CastPreloader {
		
		private var loading:LoaderContainer;
		
		/**
		 * 新しい Preloader インスタンスを作成します。
		 */
		public function Preloader() {
			
			var config:Configuration = Configuration.instance;
			var url:String = loaderInfo.url;
			var num:Number = url.lastIndexOf ( "/" );
			Configuration.BASE_PATH = url.substr ( 0, num + 1 );
			
			var flashVars:Object = loaderInfo.parameters;
			Configuration.LOGIN = ( flashVars[ "login" ] == "2" ) ? true : false;
			
			/*
			for (var name_str:String in flashVars) {
			  ExternalInterface.call ( "console.log", "flashVars.islogin " + name_str + " : " + flashVars[ name_str ] );
			}
			if ( url.indexOf ( "www.kyoraku.co.jp" ) != -1 ) {
				Configuration.BASE_PATH = "http://d3in86ewjp8wu6.cloudfront.net/www/";
			}
			if ( url.indexOf ( "test.kyoraku.co.jp" ) != -1 ) {
				Configuration.BASE_PATH = "http://ec2-54-178-162-93.ap-northeast-1.compute.amazonaws.com/test/";
			}
			if ( url.indexOf ( "robot.co.jp" ) != -1 ) {
				Configuration.BASE_PATH = "";
			}
			*/
			// プリローダーが読み込むファイルと、実行形式を指定します。
			super( new URLRequest( Configuration.BASE_PATH + "index.swf" ), false, CommandExecutor );
			Security.allowDomain("*");
			//Configuration.stage = stage;
			stage.align = "";
			stage.stageFocusRect = false;
			loading = new LoaderContainer ();
			//loading.addEventListener ( LoaderContainer.LOAD_INIT, atCastLoadInit );
			//addChild ( loading );
		}
		
		/**
		 * SWF ファイルの読み込みが完了し、stage 及び loaderInfo にアクセス可能になった場合に送出されます。
		 */
		override protected function atReady():void {
		}
		
		/**
		 * オブジェクトが読み込みを開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastLoadStart():void {
			addCommand(
				new AddChild ( stage, loading ),
				new Func ( loading.open )
			);
			
		}
		
		/**
		 * ダウンロード処理を実行中にデータを受信したときに送出されます。
		 */
		override protected function atProgress():void {
			loading.loaded = this.bytesLoaded;
			loading.loadTotal = this.bytesTotal;
		}
		
		/**
		 * オブジェクトが読み込みを完了した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastLoadComplete():void {
			addCommand(
				new Listen ( loading,  LoaderContainer.LOAD_INIT ),
				new RemoveChild ( stage, loading )
			);
		}
	}
}
