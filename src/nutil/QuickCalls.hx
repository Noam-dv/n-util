package nutil;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.effects.particles.FlxEmitter;

#if !flash
import flixel.addons.display.FlxRuntimeShader;
import nutil.shaders.ShadertoyUtil;
#end
import nutil.tilemap.TilemapLayer;
class QuickCalls {
    #if !flash

    /**
     * Create and configure a custom shader for use in your game.
     *
     * @param source The shader source code.
     * @param uniformSets An array of uniform settings for the shader.
     * @return A configured FlxRuntimeShader instance.
     */
    public static function quickShader(source:String, uniformSets:Array<Dynamic>):FlxRuntimeShader {
        var shader = new FlxRuntimeShader(source);

        var type_to_set = [
            'bool' => shader.setBool,
            'int' => shader.setInt,
            'float' => shader.setFloat,
            'string' => shader.setString
        ];

        for (arg in uniformSets) {
            var uniformType:String = arg[0];
            var uniformName:String = arg[1];
            var uniformValue:Dynamic = arg[2];

            var setUniform = type_to_set.get(uniformType.toLowerCase(), function(lol) {
                trace('unsupported uniform type at the moment :(\nplease report to the GitHub!!');
            });

            setUniform(uniformName, uniformValue);
        }
        return shader;
    }

    /**
     * Create and configure a shader ported from Shadertoy for use in your game.
     *
     * @param source The shader source code.
     * @param uniformSets An array of uniform settings for the shader.
     * @return A configured FlxRuntimeShader instance.
     */
    public static function quickPortShader(source:String, uniformSets:Array<Dynamic>):FlxRuntimeShader {
        var shader = ShadertoyUtil.portShader(source);

        var type_to_set = [
            'bool' => shader.setBool,
            'int' => shader.setInt,
            'float' => shader.setFloat,
            'string' => shader.setString
        ];

        for (arg in uniformSets) {
            var uniformType:String = arg[0];
            var uniformName:String = arg[1];
            var uniformValue:Dynamic = arg[2];

            var setUniform = type_to_set.get(uniformType.toLowerCase(), function(lol) {
                trace('unsupported uniform type at the moment :(\nplease report to the GitHub!!');
            });

            setUniform(uniformName, uniformValue);
        }
        return shader;
    }
    #end

    /**
     * Create a FlxText instance with optional additional parameters.
     *
     * @param x The x position of the text.
     * @param y The y position of the text.
     * @param text The text content.
     * @param size The font size.
     * @param width Optional width of the text.
     * @param extraParams An array of additional parameters for the FlxText.
     * @return A configured FlxText instance.
     */
    public static function quickText(x:Float, y:Float, text:String, size:Int, ?width:Int = 0, ?extraParams:Array<Dynamic>):FlxText {
        var flxText:FlxText = new FlxText(x, y, width, text, size);

        if (extraParams != null) {
            for (arg in extraParams) {
                if (arg.length >= 2) {
                    Reflect.setProperty(flxText, Std.string(arg[0]), arg[1]);
                }
            }
        }

        return flxText;
    }

    /**
     * Create and configure a FlxSprite instance with additional options.
     *
     * @param x The x position of the sprite.
     * @param y The y position of the sprite.
     * @param graphicPath The path to the sprite's graphic.
     * @param parent The FlxGroup to add the sprite to.
     * @param scale An array of x and y scale values.
     * @param scrollFactor Optional scroll factor for the sprite.
     * @return A configured FlxSprite instance.
     */
    public static function quickSprite(x:Float, y:Float, graphicPath:Dynamic, parent:FlxGroup, scale:Array<Float>, ?scrollFactor:FlxPoint = null):FlxSprite {
        var sprite:FlxSprite = new FlxSprite(x, y, graphicPath).scale.set(scale[0], scale[1]);
        if (scrollFactor != null) {
            sprite.scrollFactor = scrollFactor;
        }
        if (parent != null) parent.add(sprite);
        return sprite;
    }

    /**
     * Create and configure an animated FlxSprite object.
     *
     * @param x The x position of the sprite.
     * @param y The y position of the sprite.
     * @param graphicPath The path to the sprite's graphic.
     * @param parent The parent FlxGroup to add the sprite to.
     * @param scale An array of x and y scale values.
     * @param frames An array of frame indices for the animation.
     * @param frameRate The animation frame rate.
     * @param animName The name of the animation.
     * @param scrollFactor Optional scroll factor for the sprite.
     * @return a configured animated FlxSprite instance.
     */

    // only for like square sprites that all have the same frame-size
    public static function quickAnimatedSprite(x:Float, y:Float, graphicPath:Dynamic, parent:FlxGroup, scale:Array<Float>, frames:Array<Int>, frameRate:Float, ?animName:String = "animation1", ?scrollFactor:FlxPoint = null):FlxSprite {
        var sprite:FlxSprite = new FlxSprite(x, y, graphicPath).scale.set(scale[0], scale[1]);
        sprite.animation.add(animName, frames, frameRate, true);
        sprite.play(animName);
        if (scrollFactor != null) {
            sprite.scrollFactor = scrollFactor;
        }
        if (parent != null) parent.add(sprite);
        return sprite;
    }
}
/*   WORK - IN - PROGRESS

   
    public static function quickParticleEmitter(
        x:Float = 0,
        y:Float = 0,
        width:Float = 1280,
        height:Float = 720,
        particleClass:Dynamic,
        maxParticles:Int = 10,
        particleLifespan:Float = 3,
        autoBuffer:Bool = false,
        frequency:Float = 0.1,
        ?gravity:FlxPoint = null,
        ?blend:BlendMode = null
    ):FlxEmitter {
        var emitter:FlxEmitter = new FlxEmitter(x, y, maxParticles);

        emitter.width = width;
        emitter.height = height;
        emitter.particleClass = particleClass;
        emitter.lifespan = particleLifespan;
        emitter.frequency = frequency;

        if (gravity != null) emitter.gravity = gravity;
        if (blend != null) emitter.blend = blend;

        emitter.autoBuffer = autoBuffer;

        return emitter;
    }

    public static function quickTilemap(
        mapData:Array<Array<Int>,
        tilesetPath:String,
        tileSize:Int,
        mapWidth:Int,
        mapHeight:Int,
        collisionData:Array<Array<Int>,
        ?layers:Array<TilemapLayer>,
        ?scrollFactorX:Float = 1.0,
        ?scrollFactorY:Float = 1.0,
        ?parent:FlxGroup = null
    ):FlxTilemap {
        var tileset:FlxTilemapGraphicAsset = loadGraphic(tilesetPath, tileSize, tileSize, 0, false);
        var tilemap:FlxTilemap = new FlxTilemap();

        tilemap.widthInTiles = mapWidth;
        tilemap.heightInTiles = mapHeight;
        tilemap.totalTiles = mapWidth * mapHeight;
        tilemap._data = mapData;
        tilemap.allowCollisions = FlxTilemap.TILE;
        tilemap.customTileRemap = customTileRemap;

        if (collisionData != null) {
            tilemap.setTileProperties(1, FlxObject.ANY, null, null, 1);
            for (i in 0...collisionData.length) {
                for (j in 0...collisionData[i].length) {
                    if (collisionData[i][j] == 1) {
                        tilemap.setTileProperties(
                            mapData[i][j],
                            FlxObject.ANY,
                            function(o:FlxObject, t:FlxTilemap, tx:Int, ty:Int):Void {
                            },
                            null,
                            1
                        );
                    }
                }
            }
        }

        for (layerData in layers) {
            var layerName:String = layerData.name;
            var layerDataArray:Array<Array<Int>> = layerData.data;
            tilemap.addLayer(layerDataArray, layerName);
        }

        tilemap.scrollFactor.set(scrollFactorX, scrollFactorY);

        if (parent != null) {
            parent.add(tilemap);
        }

        return tilemap;
    }
}
*/