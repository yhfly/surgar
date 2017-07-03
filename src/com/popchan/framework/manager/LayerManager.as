
package com.popchan.framework.manager
{
    import com.popchan.framework.ds.Dict;
    import flash.display.Sprite;
    import com.popchan.framework.core.Core;
    import flash.display.DisplayObject;
    import com.popchan.framework.utils.DisplayUtil;

    public class LayerManager 
    {

        public static const MAP_BACK:String = "MAP_BACK";
        public static const CLICK_LAYER:String = "CLICK_LAYER";
        public static const ELEMENT:String = "ELEMENT";
        public static const MAP_FRONT:String = "MAP_FRONT";
        public static const FAKE_SCENE:String = "FAKE_SCENE";
        public static const UI:String = "UI";
        public static const WINDOW:String = "WINDOW";
        public static const PUPOP:String = "PUPOP";
        public static const DIALOG:String = "DIALOG";
        public static const PROGRESS:String = "PROGRESS";
        public static const BROADCAST:String = "BROADCAST";
        public static const RIGHTLIST:String = "RIGHTLIST";
        public static const TIP:String = "TIP";
        public static const DRAG:String = "DRAG";
        public static const ALERT:String = "ALERT";
        public static const BARRAGE:String = "BARRAGE";
        public static const VERY_FRONT:String = "VERY_FRONT";
        public static const DEBUG:String = "DEBUG";
        public static const DEFAULT_ORDER:Array = [MAP_BACK, ELEMENT, MAP_FRONT, CLICK_LAYER, FAKE_SCENE, UI, WINDOW, PUPOP, DIALOG, PROGRESS, BROADCAST, RIGHTLIST, TIP, DRAG, BARRAGE, ALERT, VERY_FRONT, DEBUG];

        private var _dict:Dict;

        public function LayerManager()
        {
            this._dict = new Dict();
        }

        public function setup():void
        {
            this.setOrder(DEFAULT_ORDER);
            this.take(ELEMENT).mouseEnabled = false;
            this.take(BROADCAST).mouseChildren = false;
            this.take(BROADCAST).mouseEnabled = false;
            this.take(MAP_FRONT).mouseEnabled = false;
            this.take(MAP_FRONT).mouseChildren = false;
            this.take(UI).mouseEnabled = false;
            this.take(ALERT).mouseEnabled = false;
            this.take(BROADCAST).mouseEnabled = false;
            this.take(RIGHTLIST).mouseEnabled = false;
            this.take(PUPOP).mouseEnabled = false;
            this.take(PROGRESS).mouseEnabled = false;
        }

        public function setOrder(_arg1:Array):void
        {
            var _local2:Sprite;
            var _local3:int;
            while (_local3 < _arg1.length)
            {
                if (!this.contains(_arg1[_local3]))
                {
                    this.put(_arg1[_local3]);
                }
                _local2 = this.take(_arg1[_local3]);
                Core.stageManager.canvas.setChildIndex(_local2, _local3);
                _local3++;
            }
        }

        public function put(_arg1:String):void
        {
            var _local2:Sprite = new Sprite();
            _local2.name = _arg1;
            this._dict.put(_arg1, _local2);
            Core.stageManager.canvas.addChild(_local2);
        }

        public function take(_arg1:String):Sprite
        {
            return (this._dict.take(_arg1));
        }

        public function contains(_arg1:String):Boolean
        {
            return (this._dict.contains(_arg1));
        }

        public function addChild(_arg1:DisplayObject, _arg2:String):void
        {
            var _local3:Sprite;
            _local3 = this._dict.take(_arg2);
            _local3.addChild(_arg1);
        }

        public function removeChild(_arg1:DisplayObject, _arg2:String):void
        {
            var _local3:Sprite;
            _local3 = this._dict.take(_arg2);
            if (_local3.contains(_arg1))
            {
                _local3.removeChild(_arg1);
            }
        }

        public function removeLayer(_arg1:String):void
        {
            var _local2:Sprite;
            _local2 = this._dict.take(_arg1);
            if (this.contains(_arg1))
            {
                DisplayUtil.removeForParent(_local2, false);
            }
        }

        public function addLayer(_arg1:String):void
        {
            var _local2:Sprite;
            _local2 = this._dict.take(_arg1);
            var _local3:int = DEFAULT_ORDER.indexOf(_arg1);
            Core.stageManager.canvas.addChildAt(_local2, _local3);
        }


    }
}//package com.popchan.framework.manager
