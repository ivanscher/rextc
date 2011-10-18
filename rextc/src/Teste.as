package
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import gs.TweenMax;
	import gs.easing.Back;
	import gs.easing.Quart;
	
	[SWF(width="1000", height="725", frameRate="31", backgroundColor="#000000")]
	
	public class Teste extends MovieClip
	{
		public var scope_mc:Scope = new Scope();		
		public var child:MovieClip;
		public var loader:Loader;
		public var preload:Preloader = new Preloader();
		
		public function Teste()
		{			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;			
			addChild(scope_mc);
			Positions();
			Animates();
			Initialize();
		}
		
		/**
		 * Seta posicionamentos iniciais
		 */
		private function Positions():void
		{
			with(scope_mc)
			{					
				title_mc.alpha = 0;				
				title_mc.x = (stage.stageWidth /2) - (title_mc.width/2);
				bg_mc.alpha = 0;				
				bg_mc.x = (stage.stageWidth /2) - (bg_mc.width/2);				
				nav_mc.x = (stage.stageWidth /2);
				nav_mc.y = (scope_mc.height / 2) - (nav_mc.height /2);
				nav_mc.youtube_mc.rotation = -40;
				nav_mc.flickr_mc.rotation = 40;
				nav_mc.flickr_mc.scaleX = 0;
				nav_mc.flickr_mc.scaleY = 0;
				nav_mc.youtube_mc.scaleX = 0;
				nav_mc.youtube_mc.scaleY = 0;				
				nav_mc.rex_mc.scaleX = 0;
				nav_mc.rex_mc.scaleY = 0;
			}			
		}
		/**
		 * Executa animacoes iniciais
		 */
		private function Animates():void
		{
			with(scope_mc)
			{	
				TweenMax.to(bg_mc, 1, { alpha:1, ease:Quart.easeOut } );
				TweenMax.to(nav_mc.rex_mc, 1, { scaleX:1,scaleY:1,delay:.5, ease:Back.easeOut } );
				TweenMax.to(nav_mc.youtube_mc, 1, { scaleX:1,scaleY:1,rotation:0,delay:.75, ease:Back.easeOut } );
				TweenMax.to(nav_mc.flickr_mc, 1, { scaleX:1,scaleY:1,rotation:0,delay:1, ease:Back.easeOut } );
				TweenMax.to(nav_mc, 1.5, { y:95,delay:.75, ease:Back.easeInOut } );
			}			
		}
		
		/**
		 * Inicializa a aplicação 
		 * adciona listeners,...
		 */
		private function Initialize():void
		{
			onResize();
			stage.addEventListener(Event.RESIZE,onResize);	
			for(var i:uint = 0; i<scope_mc.nav_mc.numChildren; i++)
			{
				var movie:MovieClip = MovieClip(scope_mc.nav_mc.getChildAt(i));
				movie.addEventListener(MouseEvent.MOUSE_OVER, MenuOver);
				movie.addEventListener(MouseEvent.MOUSE_OUT, MenuOut);
				movie.addEventListener(MouseEvent.CLICK, MenuClicked);
				movie.buttonMode = true;
				movie.mouseChildren = false;
			}			 
		}
		
		/**
		 * Evento de over no menu
		 */
		private function MenuOver(e:MouseEvent):void
		{
			TweenMax.to(e.currentTarget, .35, { scaleX:1.1,scaleY:1.1, ease:Back.easeOut } );	
		}
		/**
		 * Evento de out no menu
		 */
		private function MenuOut(e:MouseEvent):void
		{
			TweenMax.to(e.currentTarget, .35, { scaleX:1,scaleY:1, ease:Quart.easeOut} );		 
		}
		/**
		 * Evento de click no menu
		 */
		private function MenuClicked(e:MouseEvent):void
		{					
			ClearConteiner(scope_mc.title_mc.conteiner_mc);
			scope_mc.title_mc.text_txt.text = '';
			scope_mc.title_mc.alpha = 0;
			
			TweenMax.to(scope_mc.title_mc, .5, {alpha:1, ease:Quart.easeOut } );
			
			switch(e.currentTarget.name)
			{
				case 'youtube_mc':
					scope_mc.title_mc.text_txt.text = 'Youtube Video';
					InitYoutube();
				break;
				case 'flickr_mc':
					scope_mc.title_mc.text_txt.text = 'Flickr Photos';					
					InitFlickr();
				break;
			}
			
		}
		
		/**
		 * Limpa Seção
		 */
		private function ClearConteiner(movie:MovieClip):void
		{
			while(movie.numChildren > 0)
			{
				movie.removeChildAt(0);
			}
		}
		
		/**
		 * Inicializa youtube section
		 */
		private function InitYoutube():void
		{	
			preload.Initialize('Youtube.swf',scope_mc.title_mc.conteiner_mc);
		}
		
		/**
		 * Inicializa flickr section
		 */
		private function InitFlickr():void
		{
			preload.Initialize('Flickr.swf',scope_mc.title_mc.conteiner_mc);
		}
		
		/**
		 * Função de resize
		 * centraliza a aplicação sempre que há um redimencionamento do browser
		 */
		private function onResize(event:Event = null):void
		{
			with(scope_mc)
			{	
				title_mc.x = (stage.stageWidth /2) - (title_mc.width/2);
				bg_mc.x = (stage.stageWidth /2) - (bg_mc.width/2);				
				nav_mc.x = (stage.stageWidth /2);				
			}
		}
	}
}