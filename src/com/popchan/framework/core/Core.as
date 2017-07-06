
package com.popchan.framework.core
{
    import com.popchan.framework.manager.Layer3DManager;
    import com.popchan.framework.manager.LayerManager;
    import com.popchan.framework.manager.Stage3DManager;
    import com.popchan.framework.manager.StageManager;
    import com.popchan.framework.manager.TimerManager;
    
    import flash.display.Stage;
    import flash.geom.Rectangle;
    
    import starling.utils.AssetManager;

    public class Core 
    {

        public static var timerManager:TimerManager = new TimerManager();
        public static var layerManager:LayerManager = new LayerManager();
        public static var layer3DManager:Layer3DManager = new Layer3DManager();
        public static var stageManager:StageManager = new StageManager();
        public static var stage3DManager:Stage3DManager = new Stage3DManager();
        public static var texturesManager:AssetManager = new AssetManager();


        public static function init(stage:Stage):void
        {
            stageManager.setup(stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
            stage3DManager.setup(stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
            layerManager.setup();
            layer3DManager.setup();
        }


    }
} 