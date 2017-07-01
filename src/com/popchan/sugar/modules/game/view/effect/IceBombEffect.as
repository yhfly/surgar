
package com.popchan.sugar.modules.game.view.effect
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.CMovieClip;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import starling.events.Event;
    import com.popchan.sugar.modules.game.view.Element;

	/**
	 * 冰块破裂 
	 * @author admin
	 * 
	 */	
    public class IceBombEffect extends Element 
    {

        public static var pool:BasePool = new BasePool(IceBombEffect, 10);
        private var animation:CMovieClip;

        public function IceBombEffect()
        {
            animation = ToolKit.createMovieClip(this, Core.texturesManager.getTextures("iceboom_"));
            animation.frameRate = 10;
            animation.loops = 1;
            animation.scaleX = (animation.scaleY = 1.5);
        }

        public function play():void
        {
            animation.addEventListener(Event.COMPLETE, onAnimationEnd);
            animation.gotoAndPlay(1);
        }

        private function onAnimationEnd(_arg1:Event):void
        {
            animation.removeEventListener(Event.COMPLETE, onAnimationEnd);
            removeFromParent();
            pool.put(this);
        }
    }
} 