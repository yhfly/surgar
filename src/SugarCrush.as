package 
{
    import com.popchan.framework.core.Core;
    
    import flash.display.Sprite;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    import starling.core.Starling;
    import starling.events.Event;

	[SWF(width = "640", height = "800", backgroundColor = "0x000000", frameRate = "60")]
    public class SugarCrush extends Sprite 
    {

        private static var _instance:SugarCrush;

        public function SugarCrush()
        {
            if (stage)
            {
                init();
            }
            else
            {
                addEventListener(flash.events.Event.ADDED_TO_STAGE, init);
            }
        }

        public static function getInstance():SugarCrush
        {
            return (_instance);
        }


        private function init(_arg1:flash.events.Event=null):void
        {
            _instance = this;
            removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);
            stage.scaleMode = StageScaleMode.NO_SCALE;
            var starling:Starling = new Starling(GameEntry, stage, null, null, "auto", "baseline");
            starling.addEventListener(starling.events.Event.ROOT_CREATED, onCreate);
        }

        private function onCreate(starling:starling.events.Event):void
        {
            Core.init(stage);
            var gameEntry:GameEntry = (starling.data as GameEntry);
            gameEntry.init();
            Starling.current.start();
        }


    }
}
