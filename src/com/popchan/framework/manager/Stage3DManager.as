
package com.popchan.framework.manager
{
    import flash.display.Stage;
    import starling.display.Sprite;
    import flash.geom.Rectangle;
    import starling.core.Starling;
    import starling.events.Event;
    import com.popchan.framework.core.Core;

    public class Stage3DManager 
    {

        private var _stage:Stage;
        private var _canvas:Sprite;
        private var _canvasRect:Rectangle;
        private var _resizeRect:Rectangle;

        public function Stage3DManager()
        {
            _canvas = new Sprite();
            _canvasRect = new Rectangle();
            super();
        }

        public function setup(stage:Stage, rect:Rectangle=null):void
        {
            _stage = stage;
            if (Starling.current && Starling.current.stage)
            {
                Starling.current.stage.addChildAt(_canvas, 0);
                Starling.current.stage.addEventListener(Event.RESIZE, resize);
                if (rect)
                {
                    _resizeRect = rect;
                }
                resize();
            }
        }

        private function onResize(event:Event):void
        {
            resize();
        }

        private function resize():void
        {
            var width:int;
            var heigh:int;
            if (stageWidth >= _resizeRect.width)
            {
                width = _resizeRect.width;
            }
            else
            {
                if (stageWidth <= _resizeRect.x)
                {
                    width = _resizeRect.x;
                }
                else
                {
                    width = stageWidth;
                }
            }
            if (stageHeight >= _resizeRect.height)
            {
                heigh = _resizeRect.height;
            }
            else
            {
                if (stageHeight <= _resizeRect.y)
                {
                    heigh = _resizeRect.y;
                }
                else
                {
                    heigh = stageHeight;
                }
            }
            if (_canvasRect.width != width)
            {
                _canvasRect.width = width;
            }
            if (_canvasRect.height != heigh)
            {
                _canvasRect.height = heigh;
            }
            if (stageWidth > width)
            {
                _canvasRect.x = ((stageWidth - width) >> 1);
            }
            else
            {
                _canvasRect.x = 0;
            }
            if (stageHeight > heigh)
            {
                _canvasRect.y = ((stageHeight - heigh) >> 1);
            }
            else
            {
                _canvasRect.y = 0;
            }
            Starling.current.viewPort.x = _canvasRect.x;
            Starling.current.viewPort.y = _canvasRect.y;
            Starling.current.viewPort.width = Core.stage3DManager.canvasWidth;
            Starling.current.viewPort.height = Core.stage3DManager.canvasHeight;
            Starling.current.stage.stageWidth = Starling.current.viewPort.width;
            Starling.current.stage.stageHeight = Starling.current.viewPort.height;
            Debug.log("Starling.current.stage.width；", Starling.current.stage.width);
            Debug.log("Starling.current.stage.width；", Starling.current.stage.height);
            Debug.log("Starling.current.stage.x", Starling.current.stage.x, _canvas.x, _canvas.width);
            Debug.log("Starling.current.stage.y", Starling.current.stage.y, _canvas.y, _canvas.height);
        }

        public function get stage():Stage
        {
            return _stage;
        }

        public function get stageWidth():int
        {
            return _stage.stageWidth;
        }

        public function get stageHeight():int
        {
            return _stage.stageHeight;
        }

        public function get canvas():Sprite
        {
            return _canvas;
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