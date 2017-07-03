
package com.popchan.sugar.modules.guide
{
    import starling.display.Sprite;
    import starling.display.Shape;
    import com.popchan.framework.core.Core;
    import starling.display.Quad;
    import flash.geom.Rectangle;

    public class GuideMask extends Sprite 
    {

        private var shape:Shape;

        public function GuideMask()
        {
            this.shape = new Shape();
            addChild(this.shape);
        }

        public function createMask(_arg1:Rectangle):void
        {
            while (numChildren > 0)
            {
                removeChildAt(0, true);
            }
            var _local2:Quad = this.createRect(0, 0, _arg1.left, Core.stage3DManager.canvas.height);
            addChild(_local2);
            _local2 = this.createRect(_arg1.right, 0, (Core.stage3DManager.canvas.width - _arg1.right), Core.stage3DManager.canvas.height);
            addChild(_local2);
            _local2 = this.createRect(_arg1.left, 0, _arg1.width, _arg1.top);
            addChild(_local2);
            _local2 = this.createRect(_arg1.left, _arg1.bottom, _arg1.width, (Core.stage3DManager.canvas.height - _arg1.bottom));
            addChild(_local2);
        }

        public function addMask(_arg1:Rectangle):void
        {
            var _local2:Quad = this.createRect(_arg1.x, _arg1.y, _arg1.width, _arg1.height);
            addChild(_local2);
        }

        public function createMask2(_arg1:Rectangle):void
        {
            while (numChildren > 0)
            {
                removeChildAt(0, true);
            }
            var _local2:Quad = this.createRect(_arg1.x, _arg1.y, _arg1.width, _arg1.height);
            addChild(_local2);
        }

        private function createRect(_arg1:int, _arg2:int, _arg3:int, _arg4:int):Quad
        {
            var _local5:Quad;
            if (_arg3 <= 0)
            {
                _arg3 = 1;
            }
            if (_arg4 <= 0)
            {
                _arg4 = 1;
            }
            _local5 = new Quad(_arg3, _arg4, 0);
            _local5.alpha = 0.7;
            _local5.x = _arg1;
            _local5.y = _arg2;
            return (_local5);
        }

        override public function dispose():void
        {
            removeChildren(0, -1, true);
            super.dispose();
        }


    }
}//package com.popchan.sugar.modules.guide
