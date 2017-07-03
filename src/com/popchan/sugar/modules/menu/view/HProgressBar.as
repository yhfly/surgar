
package com.popchan.sugar.modules.menu.view
{
    import starling.display.Sprite;
    import flash.geom.Rectangle;
    import starling.display.Image;
    import starling.textures.Texture;

    public class HProgressBar extends Sprite 
    {

        private var mBar:Sprite;
        private var rect:Rectangle;
        private var barOffsetX:int;

        public function HProgressBar(_arg1:Texture, _arg2:Texture, _arg3:int=0, _arg4:int=0, _arg5:Boolean=true)
        {
            var _local7:Image;
            super();
            this.barOffsetX = _arg3;
            if (_arg1)
            {
                _local7 = new Image(_arg1);
                addChild(_local7);
            }
            this.mBar = new Sprite();
            var _local6:Image = new Image(_arg2);
            this.mBar.x = _arg3;
            this.mBar.y = _arg4;
            this.mBar.addChild(_local6);
            if (_arg5)
            {
                addChildAt(this.mBar, 0);
            }
            else
            {
                addChild(this.mBar);
            }
            this.rect = new Rectangle(0, 0, _arg2.width, (_arg2.height + 50));
        }

        public function get ratio():Number
        {
            return (this.mBar.scaleX);
        }

        public function set ratio(_arg1:Number):void
        {
            if (_arg1 > 1)
            {
                _arg1 = 1;
            }
            this.rect.x = (((_arg1 - 1) * this.rect.width) + 0);
            this.mBar.clipRect = this.rect;
        }

        override public function dispose():void
        {
            this.mBar.dispose();
            this.mBar = null;
            this.rect = null;
            removeChildren(0, -1, true);
            super.dispose();
        }


    }
}//package com.popchan.sugar.modules.menu.view
