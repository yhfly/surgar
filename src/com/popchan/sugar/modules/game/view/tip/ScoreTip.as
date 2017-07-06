
package com.popchan.sugar.modules.game.view.tip
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.TextSprite;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import caurina.transitions.Tweener;
    import com.popchan.sugar.modules.game.view.Element;

    public class ScoreTip extends Element 
    {

        public static var pool:BasePool = new BasePool(ScoreTip, 10);

        private var scoreLabel:TextSprite;
        private var scoreLabels:Array;

		/**
		 * 得分飘字动画 
		 * 
		 */		
        public function ScoreTip()
        {
            var textSprite:TextSprite;
            scoreLabels = [];
            super();
            var _local1:int = 1;
            while (_local1 <= 5)
            {
                textSprite = ToolKit.createTextSprite(this, Core.texturesManager.getTextures((("numtip" + _local1) + "_")), 0, 31, 13);
                scoreLabels.push(textSprite);
                _local1++;
            }
        }

        public function setData(score:int, color:int=0):void
        {
            var textSprite:TextSprite;
            for each (textSprite in scoreLabels)
            {
                textSprite.visible = false;
            }
            if ((color - 1) < 0)
            {
                color = 3;
            }
            else
            {
                if (color > 5)
                {
                    color = 5;
                }
            }
            scoreLabel = scoreLabels[(color - 1)];
            scoreLabel.visible = true;
            scoreLabel.text = (score + "");
            scoreLabel.x = (-(scoreLabel.width) >> 1);
            scoreLabel.y = (-(scoreLabel.height) >> 1);
            doAction();
        }

        private function doAction():void
        {
            scaleX = (scaleY = 0);
            Tweener.addTween(this, {
                "time":0.1,
                "scaleX":1,
                "scaleY":1,
                "transition":"easeBackout"
            });
            Tweener.addTween(this, {
                "time":0.5,
                "delay":0.2,
                "onComplete":onActionEnd,
                "transition":"linear"
            });
            Tweener.addTween(this, {
                "time":0.5,
                "delay":0.1,
                "y":(y - 40),
                "transition":"linear"
            });
        }

        private function onActionEnd():void
        {
            reset();
            Tweener.removeTweens(this);
            pool.put(this);
            removeFromParent();
        }

        override public function reset():void
        {
            alpha = 1;
        }


    }
} 