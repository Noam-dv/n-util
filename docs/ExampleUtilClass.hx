package;
 // for the future, doesnt work yet.
class ExampleUtilClass extends nutil.util.NdefaultUtil implements nutil.util.NutilExtern {

    public var utilType(get,default) = "example_util";
    public function get_utilType():String {
        return utilType.toLowerCase();
    }

    public function new(_:Null<T>) {
        super();
    }

    public function call(_func:String,params:Array<Dynamic>):Any {
        switch(_func){
            case "pow": return Math.pow(Std.parseFloat(params[0]));
            case "print":
                trace(params[0]);
                return;
            case "idk":
                Sys.exit(0); 
        }
    }

    public function destroy(params:Array<Dynamic>):String
    {
        super.destroy();
        return "successful";
    }

    // etc....
}