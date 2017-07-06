
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import starling.display.Image;

    public class RayEffect extends Element 
    {

        public static var pool:BasePool = new BasePool(RayEffect, 20);

        public function RayEffect()
        {
            var image:Image = ToolKit.createImage(this, Core.texturesManager.getTexture("sun"), 0, 0, true);
        }

    }
} 