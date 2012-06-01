package components
{
	import events.MorseCaptureEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import model.Alphabet;

	final public class MorseCapture extends EventDispatcher
	{
		public static const SWIPE:String = '«';
		
		private const MAX_INPUT_DELAY:Number 	= 1;
		private const MAX_DASH_LENGTH:Number	= 2;
		private const MIN_DASH_LENGTH:Number 	= .4;
		private const MIN_SWIPE_LENGTH:Number 	= 150;
		
		private var input:Vector.<String>;
		private var tapStartTime:Number;
		private var tapStartX:Number;
		
		private var inputTimer:Timer;
		
		public function MorseCapture()
		{
			init();
		}
		
		private function init():void
		{
			input = new Vector.<String>();
			inputTimer = new Timer( MAX_INPUT_DELAY*1000,1 );
			inputTimer.addEventListener( TimerEvent.TIMER_COMPLETE,onInputTimerComplete,false,0,true );
		}
		
		public function clear():void
		{
			input.length = 0;
		}
		
		public function tapStart( event:MouseEvent ):void
		{
			//trace( 'tapStart( ' + event.target + ' )' );
			tapStartTime = getTimer();
			tapStartX = event.localX;
		}
		
		public function tapEnd( event:MouseEvent ):void
		{
			var duration:Number = (getTimer()-tapStartTime)/1000;
			var distance:Number = tapStartX-event.localX;
			//trace( 'tapEnd(): duration: ' + duration + ',distance: ' + distance );
			
			// Check for left swipe //
			if( distance > 0 && distance >= MIN_SWIPE_LENGTH ){
				dispatchEvent( new MorseCaptureEvent( MorseCaptureEvent.INPUT,SWIPE ) );
				return;
			}
			
			// Held down for too long - ignore //
			if( duration >= MAX_DASH_LENGTH ){
				evalInput();
				return;
			}
			
			// Dash Entered //
			else if( duration >= MIN_DASH_LENGTH ){
				input.push( Alphabet.DASH );
				dispatchEvent( new MorseCaptureEvent( MorseCaptureEvent.INPUT,Alphabet.DASH ) );
			} 
			
			// Dot Entered //
			else {
				input.push( Alphabet.DOT );
				dispatchEvent( new MorseCaptureEvent( MorseCaptureEvent.INPUT,Alphabet.DOT ) );
			}
			
			// Have we completed a word? //
			if( input.length == Alphabet.MAX_CODE_LENGTH ){
				evalInput();
				return;
			}
			
			// Start timer for next input //
			startInputTimer();
		}
		
		private function onInputTimerComplete( e:TimerEvent ):void
		{
			evalInput();
		}
		
		private function evalInput():void
		{
			clearInputTimer();
			
			var content:String = input.join('');
			dispatchEvent( new MorseCaptureEvent( MorseCaptureEvent.COMPLETE,content ) );
			
			clear();
		}
		
		private function startInputTimer():void
		{
			clearInputTimer();
			inputTimer.start();
		}
		
		private function clearInputTimer():void
		{
			inputTimer.reset();
		}
		
	}
}