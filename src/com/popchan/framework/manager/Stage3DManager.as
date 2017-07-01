
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
            this._canvas = new Sprite();
            this._canvasRect = new Rectangle();
            super();
        }

        public function setup(_arg1:Stage, _arg2:Rectangle=null):void
        {
            this._stage = _arg1;
            if (((Starling.current) && (Starling.current.stage)))
            {
                Starling.current.stage.addChildAt(this._canvas, 0);
                Starling.current.stage.addEventListener(Event.RESIZE, this.resize);
                if (_arg2)
                {
                    this._resizeRect = _arg2;
                };
                this.resize();
            };
        }

        private function onResize(_arg1:Event):void
        {
            this.resize();
        }

        private function resize():void
        {
            var _local1:int;
            var _local2:int;
            if (this.stageWidth >= this._resizeRect.width)
            {
                _local1 = this._resizeRect.width;
            }
            else
            {
                if (this.stageWidth <= this._resizeRect.x)
                {
                    _local1 = this._resizeRect.x;
                }
                else
                {
                    _local1 = this.stageWidth;
                };
            };
            if (this.stageHeight >= this._resizeRect.height)
            {
                _local2 = this._resizeRect.height;
            }
            else
            {
                if (this.stageHeight <= this._resizeRect.y)
                {
                    _local2 = this._resizeRect.y;
                }
                else
                {
                    _local2 = this.stageHeight;
                };
            };
            if (this._canvasRect.width != _local1)
            {
                this._canvasRect.width = _local1;
            };
            if (this._canvasRect.height != _local2)
            {
                this._canvasRect.height = _local2;
            };
            if (this.stageWidth > _local1)
            {
                this._canvasRect.x = ((this.stageWidth - _local1) >> 1);
            }
            else
            {
                this._canvasRect.x = 0;
            };
            if (this.stageHeight > _local2)
            {
                this._canvasRect.y = ((this.stageHeight - _local2) >> 1);
            }
            else
            {
                this._canvasRect.y = 0;
            };
            Starling.current.viewPort.x = this._canvasRect.x;
            Starling.current.viewPort.y = this._canvasRect.y;
            Starling.current.viewPort.width = Core.stage3DManager.canvasWidth;
            Starling.current.viewPort.height = Core.stage3DManager.canvasHeight;
            Starling.current.stage.stageWidth = Starling.current.viewPort.width;
            Starling.current.stage.stageHeight = Starling.current.viewPort.height;
            Debug.log("Starling.current.stage.width；", Starling.current.stage.width);
            Debug.log("Starling.current.stage.width；", Starling.current.stage.height);
            Debug.log("Starling.current.stage.x", Starling.current.stage.x, this._canvas.x, this._canvas.width);
            Debug.log("Starling.current.stage.y", Starling.current.stage.y, this._canvas.y, this._canvas.height);
        }

        public function get stage():Stage
        {
            return (this._stage);
        }

        public function get stageWidth():int
        {
            return (this._stage.stageWidth);
        }

        public function get stageHeight():int
        {
            return (this._stage.stageHeight);
        }

        public function get canvas():Sprite
        {
            return (this._canvas);
        }

        public function get canvasRect():Rectangle
        {
            return (this._canvasRect);
        }

        public function get canvasX():Number
        {
            return (this._canvasRect.x);
        }

        public function get canvasY():Number
        {
            return (this._canvasRect.y);
        }

        public function get canvasWidth():Number
        {
            return (this._canvasRect.width);
        }

        public function get canvasHeight():Number
        {
            return (this._canvasRect.height);
        }


    }
}//package com.popchan.framework.manager
