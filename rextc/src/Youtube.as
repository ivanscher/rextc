package
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.Security;
	import gs.TweenMax;
	import gs.easing.Quart;
	
	public class Youtube extends MovieClip
	{
		private var player:Object;
		private var link:String;
		private var loader:Loader = new Loader();
		private var target_mc:Sprite;
		public var preload:PreloaderBar = new PreloaderBar();
		public function Youtube()
		{			
			target_mc = new Sprite();
			target_mc.alpha = 0;			
			target_mc.graphics.beginFill(0xffffff);
			target_mc.graphics.drawRect(0, 0, 680, 415);
			addChild(target_mc);
			
			if(player != null) player.destroy();
			
			Security.allowDomain("www.youtube.com");
			Security.allowDomain('youtube.com');
			Security.allowDomain('s.ytimg.com');
			Security.allowDomain('i.ytimg.com');
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, OnRemoved);
			
			loader.contentLoaderInfo.addEventListener(Event.INIT,onLoaderInit);
			loader.load(new URLRequest("http://www.youtube.com/v/elLVNNtArIE?version=3"));
		}
		/**
		 * Destroi o player assim que remove o movie do stage
		 * @param	event
		 */
		protected function OnRemoved(event:Event):void
		{
			player.destroy();
		}
		/**
		 * Inicia o loader
		 * @param	event
		 */
		private function onLoaderInit(event:Event):void {
			target_mc.addChild(loader);			
			loader.content.addEventListener("onReady",onPlayerReady);
		}
		/**
		 * Chamada ao ler o player
		 * @param	e
		 */
		private function onPlayerReady(e:Event):void {
			trace("player ready:",Object(e).data);
			player=loader.content;
			player.setSize(670, 400);
			player.x = 5;
			player.y = 5;
			player.cueVideoByUrl(link, 0);
			TweenMax.to(target_mc, .5, { alpha:1, delay:.5, ease:Quart.easeOut } );
		//	player.playVideo();
		}
		
	}
}