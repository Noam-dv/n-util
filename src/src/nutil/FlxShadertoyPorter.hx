package nom.shaders;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.addons.effects.FlxRuntimeShader;
import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import openfl.geom.Vector2;
import haxe.ds.Map;
import haxe.ds.StringMap;

@:enum abstract ShaderUniform(String) {
    var iTime = "iTime";
    var iResolution = "iResolution";
    var customUniform1 = "customUniform1";
    var customUniform2 = "customUniform2";
}

typedef ShaderUniforms = Map<ShaderUniform, Dynamic>;

class ShadertoyUtil {

    static public var shader:FlxRuntimeShader;

    static public function portShader(shaderSource:String, ?uniforms:ShaderUniforms):FlxRuntimeShader {
        shaderSource = addHeader(shaderSource);
        shaderSource = removeShaderParams(shaderSource);

        shader = new FlxRuntimeShader(shaderSource);
        return shader;
    }

    static private function addHeader(shader:String):String {
        var header:String = "#pragma header\n" +
            "vec2 uv = openfl_TextureCoordv.xy;\n" +
            "vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;\n" +
            "vec2 iResolution = openfl_TextureSize;\n" +
            "uniform float iTime;\n" +
            "#define iChannel0 bitmap\n" +
            "#define texture flixel_texture2D\n" +
            "#define fragColor gl_FragColor\n" +
            "#define mainImage() void mainImage() {";

        return header + shader.split("void mainImage(")[1];
    }

    private function removeShaderParams(shader:String):String {
        return shader.split("void mainImage(out vec4 fragColor, in vec2 fragCoord) {").join("void mainImage() {");
    }

    static public function applyShaderToCamera(camera:FlxCamera) {
        camera.filters = [new ShaderFilter(shader)];
    }

    static public function applyShaderToSprite(sprite:FlxSprite) {
        sprite.shader = shader;
    }

    static public function removeShaderFromCamera(camera:FlxCamera) {
        camera.filters = [];
    }

    static public function removeShaderFromSprite(sprite:FlxSprite) {
        sprite.shader = null;
    }
}