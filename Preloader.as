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
		
		
		override protected function atCastLoadComplete():void {
			addCommand(
				new Listen ( loading,  LoaderContainer.LOAD_INIT ),
				new RemoveChild ( stage, loading )
			);
		}
	}
}
