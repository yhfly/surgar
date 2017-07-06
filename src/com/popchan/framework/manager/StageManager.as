
package com.popchan.framework.manager
{
    import flash.display.Stage;
    import flash.display.Sprite;
    import flash.display.Shape;
    import flash.geom.Rectangle;
    import flash.events.Event;

    public class StageManager 
    {

        public static const GAME_MIN_WEIGHT:int = 1000;
        public static const GAME_MIN_HEIGHT:int = 620;
        public static const GAME_MAX_WEIGHT:int = 1800;
        public static const GAME_MAX_HEIGHT:int = 900;

        private var _stage:Stage;
        private var _canvas:Sprite;
        private var _mask:Shape;
        private var _canvasRect:Rectangle;
        private var _resizeRect:Rectangle;

        public function StageManager()
        {
            super();
            _canvas = new Sprite();
            _mask = new Shape();
            _canvasRect = new Rectangle();
            _mask.graphics.beginFill(0);
            _mask.graphics.drawRect(0, 0, 100, 100);
            _mask.graphics.endFill();
            _canvas.mask = _mask;
        }

        public function setup(stage:Stage, rect:Rectangle=null):void
        {
            _stage = stage;
            _stage.addChildAt(_canvas, 0);
            _stage.addEventListener(Event.RESIZE, onResize);
            if (rect)
            {
                _resizeRect = rect;
            }
            resize();
        }

        private function onResize(event:Event):void
        {
            resize();
        }

        private function resize():void
        {
            var _local1:int;
            var _local2:int;
            if (stageWidth >= _resizeRect.width)
            {
                _local1 = _resizeRect.width;
            }
            else
            {
                if (stageWidth <= _resizeRect.x)
                {
                    _local1 = _resizeRect.x;
                }
                else
                {
                    _local1 = stageWidth;
                }
            }
            if (stageHeight >= _resizeRect.height)
            {
                _local2 = _resizeRect.height;
            }
            else
            {
                if (stageHeight <= _resizeRect.y)
                {
                    _local2 = _resizeRect.y;
                }
                else
                {
                    _local2 = stageHeight;
                }
            }
            if (_canvasRect.width != _local1)
            {
                _canvasRect.width = _local1;
            }
            if (_canvasRect.height != _local2)
            {
                _canvasRect.height = _local2;
            }
            if (stageWidth > _local1)
            {
                _canvasRect.x = ((stageWidth - _local1) >> 1);
            }
            else
            {
                _canvasRect.x = 0;
            }
            if (stageHeight > _local2)
            {
                _canvasRect.y = ((stageHeight - _local2) >> 1);
            }
            else
            {
                _canvasRect.y = 0;
            }
            _canvas.x = _canvasRect.x;
            _canvas.y = _canvasRect.y;
            _mask.x = _canvasRect.x;
            _mask.y = _canvasRect.y;
            _mask.graphics.clear();
            _mask.graphics.beginFill(0);
            _mask.graphics.drawRect(0, 0, _canvasRect.width, _canvasRect.height);
            _mask.graphics.endFill();
            _canvas.dispatchEvent(new Event(Event.RESIZE));
        }

        public function get stage():Stage
        {
            return (_stage);
        }

        public function get stageWidth():int
        {
            return (_stage.stageWidth);
        }

        public function get stageHeight():int
        {
            return (_stage.stageHeight);
        }

        public function get canvas():Sprite
        {
            return (_canvas);
        }

        public function get canvasRect():Rectangle
        {
            return (_canvasRect);
        }

        public function get canvasX():Number
        {
            return (_canvasRect.x);
        }

        public function get canvasY():Number
        {
            return (_canvasRect.y);
        }

        public function get canvasWidth():Number
        {
            return (_canvasRect.width);
        }

        public function get canvasHeight():Number
        {
            return (_canvasRect.height);
        }


    }
} 