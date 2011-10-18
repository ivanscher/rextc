package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	public class Preloader
	{
		public var loader:Loader;
		public var preload_mc:PreloaderBar;
		public var target:MovieClip;
		
		public function Preloader()
		{
			
		}
		/**
		 * Inicializa o loader
		 * @param	url
		 * @param	_target
		 */
		public function Initialize(url:String,_target:MovieClip):void
		{			
			target = _target;
			preload_mc = new PreloaderBar();
			preload_mc.x = 320;
			preload_mc.y = 100;
			target.addChild(preload_mc);
			loader = new Loader();
			loader.load(new URLRequest(url));	
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, ShowURL);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, ShowProgress);
		}
		/**
		 * progresso do loader
		 * @param	event
		 */
		
		public function ShowProgress(event:ProgressEvent):void {
			preload_mc.bar_mc.scaleX = Math.round((event.bytesLoaded / event.bytesTotal ));
		}
		/**
		 * complete do loader
		 * @param	event
		 */
		public function ShowURL(event:Event):void {
			target.removeChild(preload_mc);
			target.addChild(event.currentTarget.content);			
		}
	}
}