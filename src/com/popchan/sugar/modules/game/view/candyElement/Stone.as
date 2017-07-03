
package com.popchan.sugar.modules.game.view.candyElement
{
    import starling.display.Sprite;
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import com.popchan.sugar.modules.game.view.effect.IceBombEffect;

    public class Stone extends Sprite 
    {

        public static var pool:BasePool = new BasePool(Stone, 20);

        public var row:int;
        public var col:int;
        private var stone1:Image;
//        private var stone2:Image;
        private var _life:int;
        private var _tileID:int;

        public function Stone()
        {
//            stone2 = ToolKit.createImage(this, Core.texturesManager.getTexture("stone1"), 0, 0, true);
            stone1 = ToolKit.createImage(this, Core.texturesManager.getTexture("stone2"), 0, 0, true);
        }

        public function get tileID():int
        {
            return (_tileID);
        }

        public function set tileID(_arg1:int):void
        {
            _tileID = _arg1;
            setLife(2);
        }

        public function get life():int
        {
            return (_life);
        }

        public function setLife($life:int, isShowEffect:Boolean=false):void
        {
            var iceBombEffect:IceBombEffect;
            _life = $life;
            if (_life == 2)
            {
//                stone1.visible = false;
//                stone2.visible = true;
				stone1.texture  = Core.texturesManager.getTexture("stone1")
            }
            else  if (_life == 1)
			{
//				stone1.visible = true;
//				stone2.visible = false;
				stone1.texture  = Core.texturesManager.getTexture("stone2")
			}
			
            if (isShowEffect)
            {
                iceBombEffect = new IceBombEffect();
                iceBombEffect.play();
                parent.addChild(iceBombEffect);
                iceBombEffect.x = x;
                iceBombEffect.y = y;
            }
        }


    }
}