package nutil;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import flash.display.BlendMode;
import haxe.Http;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLLoader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoaderDataFormat;


/* Example:



    function haxeFlixelLeaderboardPost(content:Dynamic) {
        var apiConfig = {
            baseUrl : "https://airtable/urleaderboardthing",
            apiKey : 'my api key',
            method: POST
        };
        
        var api = new N_Api(apiConfig);
        
        api.makeRequest(POST, "leaderboard1", [content.score, content.username, content.playerID], function(response:Dynamic) {
                trace("Leaderboard Updated WOOHOO!!!!");
         }
     }

*/
enum HttpMethod {
    GET;
    POST;
    PUT;
    DELETE;
}

typedef _ApiCfg = {
    baseUrl:String,
    apiKey:String,
    method:Null<HttpMethod>,
    customDataFormat:Null<URLLoaderDataFormat>, // Last 2 are for more advanced Users
    customContentType:Null<String>
};

class N_Api {
    private var config:_ApiCfg;
    private var headers:Array<URLRequestHeader>;

    public function new(config:_ApiCfg) {
        this.config = config;
        this.headers = [defaultHeaders(config.apiKey)];
    }

    public function makeRequest(endpoint:String, data:String, callback:Dynamic -> Void):Void {
        var method:HttpMethod = config.method != null ? config.method : HttpMethod.GET;
        var customDataFormat:URLLoaderDataFormat = config.customDataFormat != null ? config.customDataFormat : URLLoaderDataFormat.TEXT;
        var customContentType:String = config.customContentType != null ? config.customContentType : "application/json";
        var urlRequest = createRequest(method.toString(), endpoint, data, customContentType);
        var urlLoader = createLoader(customDataFormat);

        setupRequestListeners(urlLoader, callback);
        loadRequest(urlLoader, urlRequest);
    }
    private function defaultHeaders(apiKey:String):URLRequestHeader {
        return [new URLRequestHeader('Authorization', 'Bearer ' + apiKey), new URLRequestHeader('Content-Type', 'application/json')];
    }

    private function createRequest(method:String, endpoint:String, data:String, contentType:String):URLRequest {
        var baseUrl:String = config.baseUrl;
        var urlRequest = new URLRequest(baseUrl + endpoint);
        urlRequest.requestHeaders = headers;
        urlRequest.method = method;
        urlRequest.data = (method.toLowerCase() == HttpMethod.POST.toString()) ? data :null;
        urlRequest.requestHeaders.push(new URLRequestHeader('Content-Type', contentType));
        return urlRequest;
    }

    private function createLoader(dataFormat:URLLoaderDataFormat):URLLoader {
        var urlLoader = new URLLoader();
        urlLoader.dataFormat = dataFormat;
        return urlLoader;
    }

    private function setupRequestListeners(urlLoader:URLLoader, callback:Dynamic -> Void):Void {
        urlLoader.addEventListener(Event.COMPLETE, function(e:Event) {
            callback(urlLoader.data);
        });

        urlLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent) {
            trace('An error occurred:${e.text}');
        });
    }

    private function loadRequest(urlLoader:URLLoader, urlRequest:URLRequest):Void {
        urlLoader.load(urlRequest);
    }
}    