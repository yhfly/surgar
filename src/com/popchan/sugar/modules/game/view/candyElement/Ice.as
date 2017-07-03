
package com.popchan.sugar.modules.game.view.candyElement
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import com.popchan.sugar.core.data.TileConst;
    import com.popchan.sugar.modules.game.view.effect.IceBombEffect;
    import com.popchan.sugar.modules.game.view.Element;

    public class Ice extends Element 
    {

        public static var pool:BasePool = new BasePool(Ice, 20);

        public var row:int;
        public var col:int;
        private var ice1:Image;
        private var _life:int;
        private var _tileID:int;

        public function Ice()
        {
           ice1 = ToolKit.createImage(this, Core.texturesManager.getTexture("sprite2"), 0, 0, true);
           ice1.scaleX = (this.ice1.scaleY = 1.2);
        }

        public function get tileID():int
        {
            return _tileID;
        }

        public function set tileID($tileId:int):void
        {
           _tileID = $tileId;
            if ($tileId == TileConst.ICE1)
            {
               setLife(1);
            }
            else if ($tileId == TileConst.ICE2)
			{
				setLife(2);
			}
            else if ($tileId == TileConst.ICE3)
			{
				setLife(3);
			}
        }

		public function subLife(isShowBombEffecr:Boolean):void
		{
			if(!isDie())
			{
				setLife(_life - 1, isShowBombEffecr);
			}
		}
		
		public function isDie():Boolean
		{
			return _life <= 0;
		}
		
        private function setLife($life:int, isShowBombEffecr:Boolean=false):void
        {
            var iceBombEffect:IceBombEffect;
           _life = $life;
            if (this._life == 3)
            {
				ice1.texture =  Core.texturesManager.getTexture("sprite1");
            }
            else  if (this._life == 2)
			{
				ice1.texture =  Core.texturesManager.getTexture("spritemid");
			}
            else if (this._life == 1)
			{
				ice1.texture =  Core.texturesManager.getTexture("sprite2");
			}
            if (isShowBombEffecr)
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