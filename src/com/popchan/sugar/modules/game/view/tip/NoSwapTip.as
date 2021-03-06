﻿
package com.popchan.sugar.modules.game.view.tip
{
    import starling.display.Sprite;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import com.popchan.framework.manager.SoundManager;
    import caurina.transitions.Tweener;

	/**
	 * 没有可交换的了 
	 * @author admin
	 * 
	 */	
    public class NoSwapTip extends Sprite 
    {

        private var end:Function;

        public function NoSwapTip()
        {
            ToolKit.createImage(this, Core.texturesManager.getTexture("nomatch"), 0, 0, true);
        }

        public function doAniamtion(callBack:Function):void
        {
            var ins:NoSwapTip;
            this.end = callBack;
            y = ((Core.stage3DManager.canvasHeight >> 1) + 40);
            x = (Core.stage3DManager.canvasWidth + 100);
            ins = this;
            SoundManager.instance.playSound("nomatch");
            Tweener.addTween(ins, {
                "x":(Core.stage3DManager.canvasWidth >> 1),
                "time":0.4,
                "transition":"easeOutBack",
                "onComplete":omComplete
            });
        }

		private function omComplete():void
		{
			Tweener.addTween(this, {
				"x":-100,
				"time":0.4,
				"delay":0.4,
				"transition":"easeInBack",
				"onComplete":onAllComplete
			});
		}
		
		private function onAllComplete():void
		{
			removeFromParent(true);
			if (end != null)
			{
				end();
			}
		}

    }
} 