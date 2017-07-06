
package com.popchan.sugar.modules.game.view.tip
{
    import starling.display.Sprite;
    import com.popchan.framework.ds.BasePool;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import com.popchan.framework.manager.SoundManager;
    import caurina.transitions.Tweener;

	/**
	 * 奖励时间 提示， 完成任务时候 
	 * @author admin
	 * 
	 */	
    public class BonusTimeTip extends Sprite 
    {

        public static var pool:BasePool = new BasePool(BonusTimeTip, 10);

        public function BonusTimeTip()
        {
            ToolKit.createImage(this, Core.texturesManager.getTexture("bonustime"), 0, 0, true);
        }

        public function doAniamtion():void
        {
            var ins:BonusTimeTip;
            y = ((Core.stage3DManager.canvasHeight >> 1) + 40);
            x = -100;
            ins = this;
            SoundManager.instance.playSound("finaltry");
            Tweener.addTween(ins, {
                "x":(Core.stage3DManager.canvasWidth >> 1),
                "time":0.4,
                "transition":"easeOutBack",
                "onComplete":onComplete });
        }

		private function onComplete():void
		{
			Tweener.addTween(this, {
				"x":(Core.stage3DManager.canvasWidth + 100),
				"time":0.4,
				"delay":0.4,
				"transition":"easeInBack",
				"onComplete":allComplete});
		}
		
		public function allComplete():void
		{
			removeFromParent();
			pool.put(this);
		}
    }
} 