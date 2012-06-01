package model
{
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.utils.ArrayUtil;
	
	import qnx.ui.data.DataProvider;

	final public class Alphabet
	{
		public static const DOT:String 				= '.';
		public static const DASH:String 			= '-';
		public static const MAX_CODE_LENGTH:uint 	= 6;
		
		private static const BASE:uint 				= 44;
		private static const INDEX:Vector.<String> 	= new <String>[
			
			'.-----',
			'..----',		
			'...---',
			'....--',
			
			// Numbers //
			'-----',
			'.----',
			'..---',
			'...--',
			'....-',
			'.....',
			'-....',
			'--...',
			'---..',
			'----.',
			
			// Unused chars between numbers and letters in ASCII chart //
			'.....-','......','-.....','--....','---...','----..','-----.',			
			
			// Letters //
			'.-',
			'-...',
			'-.-.',
			'-..',
			'.',
			'..-.',
			'--.',
			'....',
			'..',
			'.---',
			'-.-',
			'.-..',
			'--',
			'-.',
			'---',
			'.--.',
			'--.-',
			'.-.',
			'...',
			'-',
			'..-',
			'...-',
			'.--',
			'-..-',
			'-.--',
			'--..'
		];
		
		private static var dataProvider:ArrayList;
		
		public static function encode( char:String ):String
		{
			var idx:uint = char.toUpperCase().charCodeAt(0);
			if( idx == 32 ) return char;
			if( idx-BASE<0 || idx-BASE>=INDEX.length ) return '';
			return INDEX[ idx - BASE ];
		}
		
		public static function decode( morse:String ):String
		{
			if( morse == ' ' ) return morse;
			if( INDEX.indexOf( morse ) == -1 ) return '';
			return String.fromCharCode( INDEX.indexOf( morse ) + BASE );
		}
		
		public static function get data():ArrayList
		{
			if( !dataProvider ){
				dataProvider = new ArrayList();
				var i:uint;
				
				// add letters //
				for( i=0;i<26;i++ ){
					dataProvider.addItem( { letter:decode(INDEX[i+21]),code:INDEX[i+21] } );
				}
				
				// add numbers //
				for( i=0;i<10;i++ ){
					dataProvider.addItem( { letter:decode(INDEX[i+4]),code:INDEX[i+4] } );
				}
				
				// add characters //
				for( i=0;i<INDEX.length;i++ ){
					if( i<4 || (i>13&&i<21) ){ 
						dataProvider.addItem( { letter:decode(INDEX[i]),code:INDEX[i] } );
					}
				}
			}
			return dataProvider;
		}
		
	}
}