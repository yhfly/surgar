
package com.popchan.sugar.modules.game.view.effect
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import caurina.transitions.Tweener;
    import com.popchan.sugar.modules.game.view.Element;

    public class LineBombEffect extends Element 
    {

        public static var pool:BasePool = new BasePool(LineBombEffect, 10);

        private var img1:Image;
        private var img2:Image;

        public function LineBombEffect()
        {
            img1 = ToolKit.createImage(this, Core.texturesManager.getTexture("hengshu"));
            img1.pivotX = (img1.width >> 1);
            img1.pivotY = (img1.height >> 1);
            img2 = ToolKit.createImage(this, Core.texturesManager.getTexture("hengshu"));
            img2.pivotX = (img2.width >> 1);
            img2.pivotY = (img2.height >> 1);
        }

        public function play(type:int):void
        {
            var t1:Number;
            var t2:Number;
            var t:Number;
            img1.x = (img2.x = 0);
            img1.y = (img2.y = 0);
            img1.visible = (img2.visible = true);
            img1.scaleX = (img1.scaleY = 1);
            if (type == 1)
            {
                img1.rotation = 0;
                img1.pivotX = img1.width;
                img2.rotation = 0;
                img2.pivotX = 0;
                img1.scaleX = (img2.scaleX = 0.2);
                img1.scaleY = (img2.scaleY = 0.7);
                t1 = Math.abs(((-(x) - img1.width) * 0.001));
                Tweener.addTween(img1, {
                    "time":t1,
                    "scaleX":2.5,
                    "transition":"linear",
                    "onComplete":function ():void
                    {
                        img1.visible = false;
                    }
                });
                t2 = Math.abs((((Core.stage3DManager.canvasWidth + 100) - x) * 0.001));
                Tweener.addTween(img2, {
                    "time":t2,
                    "scaleX":2.5,
                    "transition":"linear",
                    "onComplete":function ():void
                    {
                        img2.visible = false;
                    }
                });
                t = Math.max(t1, t2);
                Tweener.addCaller(this, {
                    "count":1,
                    "time":t,
                    "onComplete":onActionEnd
                });
            }
            else
            {
                img1.rotation = (-(Math.PI) / 2);
                img1.pivotX = 0;
                img2.rotation = (Math.PI / 2);
                img2.pivotX = 0;
                img1.scaleX = (img2.scaleX = 0.2);
                img1.scaleY = (img2.scaleY = 0.7);
                t1 = (Math.abs((0 - y)) * 0.001);
                Tweener.addTween(img1, {
                    "time":(t1 * 0.5),
                    "scaleX":2.5,
                    "transition":"linear",
                    "onComplete":function ():void
                    {
                        img1.visible = false;
                    }
                });
                t2 = ((Core.stage3DManager.canvasHeight - y) * 0.001);
                Tweener.addTween(img2, {
                    "time":(t2 * 0.5),
                    "scaleX":2.5,
                    "transition":"linear",
                    "onComplete":function ():void
                    {
                        img2.visible = false;
                    }
                });
                t = Math.max(t1, t2);
                Tweener.addCaller(this, {
                    "count":1,
                    "time":t,
                    "onComplete":onActionEnd
                });
            }
        }

        private function onActionEnd():void
        {
            removeFromParent();
            pool.put(this);
        }


    }
} 