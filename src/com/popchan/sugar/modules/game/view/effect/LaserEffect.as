
package com.popchan.sugar.modules.game.view.effect
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import com.popchan.sugar.modules.game.view.Element;

    public class LaserEffect extends Element 
    {

        public static var pool:BasePool = new BasePool(LaserEffect, 20);

        private var suns:Array;

        public function LaserEffect()
        {
            var _local2:Image;
            super();
            this.suns = [];
            var _local1:int;
            while (_local1 < 6)
            {
                _local2 = ToolKit.createImage(this, Core.texturesManager.getTexture("sun"));
                addChild(_local2);
                this.suns.push(_local2);
                _local1++;
            };
        }

        public function setData(_arg1:Number):void
        {
            var _local3:Image;
            var _local4:Number;
            var _local5:Number;
            var _local2:int;
            while (_local2 < 6)
            {
                _local3 = this.suns[_local2];
                _local3.scaleX = (0.6 - (_local2 * 0.05));
                _local3.scaleY = (0.6 - (_local2 * 0.05));
                _local3.pivotX = (_local3.width >> 1);
                _local3.pivotY = (_local3.height >> 1);
                _local4 = ((Math.cos((Math.PI + _arg1)) * _local2) * 20);
                _local5 = ((Math.sin((Math.PI + _arg1)) * _local2) * 20);
                _local3.x = _local4;
                _local3.y = _local5;
                this.suns.push(_local3);
                _local2++;
            };
        }


    }
}//package com.popchan.sugar.modules.game.view
