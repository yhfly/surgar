
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import starling.textures.Texture;
    import com.popchan.framework.core.Core;

    public class FruitDoor extends Element 
    {
        public static var pool:BasePool = new BasePool(FruitDoor, 20);
        public function FruitDoor()
        {
            var image:Image = new Image(Texture.fromTexture(Core.texturesManager.getTexture("downP")));
            image.pivotX = (image.width >> 1);
            image.pivotY = (image.height >> 1);
            addChild(image);
        }

    }
} 