
package com.popchan.sugar.modules.game.view
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

        public function HProgressBar(texture:Texture, _arg2:Texture, posX:int=0, posY:int=0, _arg5:Boolean=true)
        {
			var image:Image;
			super();
			barOffsetX = posX;
			if (texture)
			{
				image = new Image(texture);
				addChild(image);
			}
			mBar = new Sprite();
			var _local6:Image = new Image(_arg2);
			mBar.x = posX;
			mBar.y = posY;
			mBar.addChild(_local6);
			if (_arg5)
			{
				addChildAt(this.mBar, 0);
			}
			else
			{
				addChild(this.mBar);
			}
          	rect = new Rectangle(0, 0, _arg2.width, (_arg2.height + 50));
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
           rect.x = (((_arg1 - 1) *rect.width) + 0);
           mBar.clipRect =rect;
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