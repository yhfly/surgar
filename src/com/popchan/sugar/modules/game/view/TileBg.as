
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import starling.textures.Texture;
    import com.popchan.framework.core.Core;

	/**
	 * 背景格子 
	 * @author admin
	 * 
	 */	
    public class TileBg extends Element 
    {

        public static var pool:BasePool = new BasePool(TileBg, 81);

        public function TileBg()
        {
            var image:Image = new Image(Texture.fromTexture(Core.texturesManager.getTexture("cube")));
            image.pivotX = (image.width >> 1);
            image.pivotY = (image.height >> 1);
            addChild(image);
        }

        override public function reset():void
        {
        }
    }
}