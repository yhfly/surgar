
package com.popchan.sugar.modules.guide
{
    import starling.display.Sprite;
    import flash.geom.Point;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import caurina.transitions.Tweener;

    public class GuideArrow extends Sprite 
    {

        private var p1:Point;
        private var p2:Point;

        public function GuideArrow()
        {
            touchable = false;
            ToolKit.createImage(this, Core.texturesManager.getTexture("shouzhi"));
        }

        public function moveBetween(_arg1:Point, _arg2:Point):void
        {
            this.p1 = _arg1;
            this.p2 = _arg2;
            this.x = _arg1.x;
            this.y = _arg1.y;
            this.moveToP2();
        }

        private function moveToP2():void
        {
            var disX:Number = (this.p2.x - this.p1.x);
            var disY:Number = (this.p2.y - this.p1.y);
            var dis:Number = Math.sqrt(((disX * disX) + (disY * disY)));
            var t:Number = (dis / 80);
            Tweener.addTween(this, {
                "x":this.p2.x,
                "y":this.p2.y,
                "time":t,
                "transition":"linear",
                "onComplete":function ():void
                {
                    moveToP1();
                }
            });
        }

        private function moveToP1():void
        {
            var disX:Number = (this.p2.x - this.p1.x);
            var disY:Number = (this.p2.y - this.p1.y);
            var dis:Number = Math.sqrt(((disX * disX) + (disY * disY)));
            var t:Number = (dis / 80);
            Tweener.addTween(this, {
                "x":this.p1.x,
                "y":this.p1.y,
                "time":t,
                "transition":"linear",
                "onComplete":function ():void
                {
                    moveToP2();
                }
            });
        }


    }
}//package com.popchan.sugar.modules.guide
