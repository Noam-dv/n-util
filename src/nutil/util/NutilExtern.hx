package nutil;


// future Util Thing for my Utility package
// https://github.com/Noam-dv/n-util
enum SET_TYPE(String) {
    SET,
    SET_DYNAMICS,
    SET_STRINGS,
    SET_INTS,
    SET_FLOATS,
    SET_ARRAYS,
}

interface NutilExtern {
    public var utilType(get,default):Null<String>;
    public function get_utilType():Null<String>;

    public function new(_:Null<T>);

    public function call(_func:String, params:Array<Dynamic>):Any;
    public function destroy(params:Array<Dynamic>):String; /// returns 'successful' or 'failed'

    public function validateInput(params:Array<Dynamic>):Bool;

    public function loadConfig(key:NutilConf, value:SET_TYPE):Void;
    public function getConfig(key:NutilConf):Null<Dynamic>;
    
    public function log(message:String):Void;
    public function debug(message:String, data:Dynamic):Void;
}
