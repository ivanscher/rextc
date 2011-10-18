package
{
	import com.hydrotik.queueloader.QueueLoader;
	import com.hydrotik.queueloader.QueueLoaderEvent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	
	import gs.TweenMax;
	import gs.easing.Quart;
	public class Flickr extends MovieClip
	{
		const XML_FlickrBase		:String = "http://api.flickr.com/services/rest/?api_key=4840051eef6024466714bdf6c7cb786a";
		public var myXMLRequest		:URLRequest;
		public var myXMLLoader		:URLLoader;
		public var myPhotoLoader	:Loader;
		private var iLoader			:QueueLoader = new QueueLoader();
		private var oLoader			:QueueLoader = new QueueLoader();
		private var target_mc		:MovieClip;
		private var targetBG_mc		:Sprite;
		private var imagesArr		:Array = [];
		private var linksArr		:Array = [];
		private var photoBG_mc:MovieClip;
		
		public var preload_mc:PreloaderBar;
		private var screenLock:Sprite;
		
		public function Flickr():void
		{
			var currentURL:String = XML_FlickrBase + "&method=flickr.photosets.getPhotos&photoset_id=72157627786395413&per_page=10"
			myXMLRequest = new URLRequest(currentURL + "&ienocache=" + Math.random());
			myXMLLoader = new URLLoader(myXMLRequest);			
			myXMLLoader = new URLLoader(myXMLRequest);			
			myXMLLoader.addEventListener(Event.COMPLETE, ReadFlickXml);
		}
		/**
		 * CallBack chamado assim que carrega o xml Flickr
		 * @param	event
		 */
		public function ReadFlickXml(event:Event):void
		{
			var myXML:XML = new XML(event.target.data);
			
			var results:XMLList = myXML.photoset.photo ;			
			
			for (var i:uint = 0; i < results.length(); i++)
			{				
				var thumb:String = getPhotoString(results[i], 'square');
				var photo:String = getPhotoString(results[i], 'mediumL');
				linksArr.push(photo);
				iLoader.addItem(thumb, null, {title:"Image", cacheKiller:true, smoothing:true, tabIndex:i});			
			}			
			
			iLoader.addEventListener(QueueLoaderEvent.QUEUE_START, onQueueStart,false, 0, true);
			iLoader.addEventListener(QueueLoaderEvent.QUEUE_PROGRESS, onQueueProgress, false, 0, true);
			iLoader.addEventListener(QueueLoaderEvent.ITEM_COMPLETE, onItemComplete,false, 0, true);			
			iLoader.addEventListener(QueueLoaderEvent.QUEUE_COMPLETE, onQueueComplete,false, 0, true);
			
			iLoader.execute();			
		}
		/**
		 * Out dos thumbnails
		 * @param	e
		 */
		private function ThumbOut(e:MouseEvent):void 
		{
			TweenMax.to(e.currentTarget, .5, { scaleX:1,scaleY:1,  ease:Quart.easeOut } );
			e.currentTarget.parent.setChildIndex(e.currentTarget, e.currentTarget.movieindex);			
		}
		/**
		 * Over dos thumbnails
		 * @param	e
		 */
		private function ThumbOver(e:MouseEvent):void 
		{
			e.currentTarget.parent.setChildIndex(e.currentTarget, e.currentTarget.parent.numChildren - 1);
			TweenMax.to(e.currentTarget, .5, { scaleX:1.1,scaleY:1.1,  ease:Quart.easeOut } );
		}
		/**
		 * Click dos thumbnails
		 * @param	e
		 */
		private function ThumbClicked(e:MouseEvent):void 
		{			
			screenLock = new Sprite();
			screenLock.alpha = 0;			
			screenLock.scaleY = 0;			
			screenLock.graphics.beginFill(0x000000);
			screenLock.graphics.drawRect(-166, -260, stage.stageWidth, stage.stageHeight);
		//	screenLock.x = MovieClip();
			addChild(screenLock);
			TweenMax.to(screenLock, .5, { alpha:.5,scaleY:1,  ease:Quart.easeOut } );
			
			oLoader.addItem(e.currentTarget.link, null, {title:"Image", cacheKiller:true, smoothing:true});			
			oLoader.addEventListener(QueueLoaderEvent.QUEUE_COMPLETE, onQueueCompletePhoto,false, 0, true);
			oLoader.addEventListener(QueueLoaderEvent.QUEUE_START, onQueueStart,false, 0, true);
			oLoader.addEventListener(QueueLoaderEvent.QUEUE_PROGRESS, onQueueProgress, false, 0, true);
			oLoader.execute();
			
			
		}	
		/**
		 * Fecha foto
		 * @param	e
		 */
		private function CloseFoto(e:MouseEvent):void
		{
			removeChild(screenLock);
			removeChild(photoBG_mc);	
			removeChild(preload_mc);
		}
		/**
		 * Inicia preload
		 * @param	event
		 */
		private function onQueueStart(event:QueueLoaderEvent):void
		{
			preload_mc = new PreloaderBar();
			addChild(preload_mc);
			preload_mc.x = 320;
			preload_mc.y = 100;
		}
		/**
		 * Chamada ao completar o carregamento de cada imagem
		 * @param	e
		 */
		private function onItemComplete(e:QueueLoaderEvent):void 
		{							
			imagesArr.push(e.content);			
		}
		/**
		 * Complete da foto maior
		 * @param	e
		 */
		private function onQueueCompletePhoto(e:QueueLoaderEvent):void 
		{								 
			var _w:Number = e.content.width + 10;
			var _h:Number = e.content.height+10;
			photoBG_mc = new MovieClip();				
			photoBG_mc.graphics.beginFill(0xffffff);
			photoBG_mc.graphics.drawRect(0,-50, _w, _h);
			addChild(photoBG_mc);
			
			e.content.x= 5;
			e.content.y= -45;
			photoBG_mc.addChild(e.content);
			photoBG_mc.buttonMode = true;
			photoBG_mc.mouseChildren = false;
			photoBG_mc.addEventListener(MouseEvent.CLICK, CloseFoto);	
		}
		/**
		 * Progresso do preload
		 */ 
		private function onQueueProgress(e:QueueLoaderEvent):void 
		{
			preload_mc.bar_mc.scaleX = e.queuepercentage;
		}
		/**
		 * Complete do carregamento dos thumbnails
		 * @param	e
		 */
		private function onQueueComplete(e:QueueLoaderEvent):void 
		{
			removeChild(preload_mc);
			
			for (var i:uint = 0; i < imagesArr.length; i++)
			{					
				target_mc = new MovieClip();
				target_mc.mouseChildren = false;				
				addChild(target_mc);
				target_mc.link = linksArr[i];
				
				targetBG_mc = new Sprite();				
				targetBG_mc.graphics.beginFill(0xffffff);
				targetBG_mc.graphics.drawRect(-42.5, -42.5, 85, 85);
				target_mc.addChild(targetBG_mc);			
				
				// Posição.
				target_mc.x = (i % 7) * (target_mc.width - 5) + 52.5 ;
				target_mc.y = Math.floor(i / 7) * (target_mc.height - 5) + 52.5;
				
				imagesArr[i].x = 5-42.5;
				imagesArr[i].y = 5-42.5;
				target_mc.addChild(imagesArr[i]);
				
				target_mc.alpha = 0;
				TweenMax.to(target_mc, .5, { alpha:1, delay:i * .05, ease:Quart.easeOut } );
				
				target_mc.buttonMode = true;
				target_mc.addEventListener(MouseEvent.MOUSE_OVER, ThumbOver);
				target_mc.addEventListener(MouseEvent.MOUSE_OUT, ThumbOut);
				target_mc.addEventListener(MouseEvent.CLICK, ThumbClicked);
			}
		}
		
		/**
		 * Constroi a url da imagem de acordo com os parametros enviados
		 * @param	photo
		 * @param	type
		 * @return
		 */
		public function getPhotoString(photo:XML, type:String):String
		{
			var value:String;
			switch(type)
			{
				case 'square':
					value =  "http://farm" + photo.@farm + ".static.flickr.com/" + photo.@server + "/" + photo.@id + "_" + photo.@secret + "_s.jpg";			
					break;
				case 'thumbnail':
					value =  "http://farm" + photo.@farm + ".static.flickr.com/" + photo.@server + "/" + photo.@id + "_" + photo.@secret + "_t.jpg";			
					break;
				case 'small':
					value =  "http://farm" + photo.@farm + ".static.flickr.com/" + photo.@server + "/" + photo.@id + "_" + photo.@secret + "_m.jpg";			
					break;
				case 'medium':
					value =  "http://farm" + photo.@farm + ".static.flickr.com/" + photo.@server + "/" + photo.@id + "_" + photo.@secret + ".jpg";			
					break;
				case 'mediumL':
					value =  "http://farm" + photo.@farm + ".static.flickr.com/" + photo.@server + "/" + photo.@id + "_" + photo.@secret + "_z.jpg";			
					break;
				case 'large':
					value =  "http://farm" + photo.@farm + ".static.flickr.com/" + photo.@server + "/" + photo.@id + "_" + photo.@secret + "_b.jpg";			
					break;
			}	
			return value;
		}
	}
}