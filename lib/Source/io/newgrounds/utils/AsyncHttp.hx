package io.newgrounds.utils;

import io.newgrounds.NGLite;
import openfl.events.Event;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLVariables;

/**
 * Uses Threading to turn hxcpp's synchronous http requests into asynchronous processes
 * 
 * @author GeoKureli
 */
class AsyncNGCall {
	
	inline static var PATH:String = "https://newgrounds.io/gateway_v3.php";
	
	static public function send
	( core:NGLite
	, data:String
	, onData:String->Void
	, onError:String->Void
	, onStatus:Int->Void
	) {

		core.logVerbose('sending: $data');

		AsyncHttp.send(PATH, data, onData, onError, onStatus);
	}
}

/**
 * Uses Threading to turn hxcpp's synchronous http requests into asynchronous processes
 * 
 * @author GeoKureli
 */
@:allow(io.newgrounds.utils.AsyncNGCall)
class AsyncHttp {
	
	/** Loads a remote url */
	inline static public function getText(path, onData, onError, ?onStatus) {
		
		send(path, null, onData, onError, onStatus);
	}
	
	static public function send
	( path:String
	, data:String
	, onData:String->Void
	, onError:String->Void
	, ?onStatus:Int->Void
	) {
		
		// core.logVerbose('sending: $data');

		var loader = new URLLoader();

		loader.addEventListener(Event.COMPLETE, function(e:Event):Void {
			onData(Std.string(cast(e.target, URLLoader).data));
		});

		loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent) {
			onError(e.text);
		});

		if (onStatus != null) {
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e:HTTPStatusEvent) {
				onStatus(e.status);
			});
		}

		var request = new URLRequest(path);

		if (data != null) {
			var variables = new URLVariables();
			variables['input'] = data;
			request.data = variables;

			request.method = URLRequestMethod.POST;
		}

		loader.load(request);
	}
}
