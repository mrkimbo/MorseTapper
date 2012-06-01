package events
{
	import flash.events.Event;
	
	public class MorseCaptureEvent extends Event
	{
		public static const INPUT:String 	= 'onCodeInput';
		public static const COMPLETE:String	= 'onInputComplete';
		
		private var _input:String;
		
		public function MorseCaptureEvent( type:String,input:String='' )
		{
			super( type );
			_input = input;
		}
		
		public function get input():String
		{
			return _input;
		}
	}
}