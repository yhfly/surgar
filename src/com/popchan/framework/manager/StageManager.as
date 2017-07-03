
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
            this._canvas = new Sprite();
            this._mask = new Shape();
            this._canvasRect = new Rectangle();
            super();
            this._mask.graphics.beginFill(0);
            this._mask.graphics.drawRect(0, 0, 100, 100);
            this._mask.graphics.endFill();
            this._canvas.mask = this._mask;
        }

        public function setup(_arg1:Stage, _arg2:Rectangle=null):void
        {
            this._stage = _arg1;
            this._stage.addChildAt(this._canvas, 0);
            this._stage.addEventListener(Event.RESIZE, this.onResize);
            if (_arg2)
            {
                this._resizeRect = _arg2;
            }
            this.resize();
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
                }
            }
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
                }
            }
            if (this._canvasRect.width != _local1)
            {
                this._canvasRect.width = _local1;
            }
            if (this._canvasRect.height != _local2)
            {
                this._canvasRect.height = _local2;
            }
            if (this.stageWidth > _local1)
            {
                this._canvasRect.x = ((this.stageWidth - _local1) >> 1);
            }
            else
            {
                this._canvasRect.x = 0;
            }
            if (this.stageHeight > _local2)
            {
                this._canvasRect.y = ((this.stageHeight - _local2) >> 1);
            }
            else
            {
                this._canvasRect.y = 0;
            }
            this._canvas.x = this._canvasRect.x;
            this._canvas.y = this._canvasRect.y;
            this._mask.x = this._canvasRect.x;
            this._mask.y = this._canvasRect.y;
            this._mask.graphics.clear();
            this._mask.graphics.beginFill(0);
            this._mask.graphics.drawRect(0, 0, this._canvasRect.width, this._canvasRect.height);
            this._mask.graphics.endFill();
            this._canvas.dispatchEvent(new Event(Event.RESIZE));
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
