
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

        public function HProgressBar(_arg1:Texture, texture:Texture, posX:int=0, posY:int=0, _arg5:Boolean=true)
        {
            super();
            var image:Image;
            barOffsetX = posX;
            if (_arg1)
            {
                image = new Image(_arg1);
                addChild(image);
            }
            mBar = new Sprite();
            var _local6:Image = new Image(texture);
            mBar.x = posX;
            mBar.y = posY;
            mBar.addChild(_local6);
            if (_arg5)
            {
                addChildAt(mBar, 0);
            }
            else
            {
                addChild(mBar);
            }
            rect = new Rectangle(0, 0, texture.width, (texture.height + 50));
        }

        public function get ratio():Number
        {
            return (mBar.scaleX);
        }

        public function set ratio(_arg1:Number):void
        {
            if (_arg1 > 1)
            {
                _arg1 = 1;
            }
            rect.x = (((_arg1 - 1) * rect.width) + 0);
            mBar.clipRect = rect;
        }

        override public function dispose():void
        {
            mBar.dispose();
            mBar = null;
            rect = null;
            removeChildren(0, -1, true);
            super.dispose();
        }


    }
} 