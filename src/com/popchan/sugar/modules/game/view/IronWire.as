
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;

	/**
	 * 铁丝 
	 * @author admin
	 * 
	 */	
    public class IronWire extends Element 
    {

        public static var pool:BasePool = new BasePool(IronWire, 20);

        public var row:int;
        public var col:int;
        private var _dir:int;
        private var img1:Image;
        private var img2:Image;

        public function IronWire()
        {
           img1 = ToolKit.createImage(this, Core.texturesManager.getTexture("ironWire"), -37, -24);
           img2 = ToolKit.createImage(this, Core.texturesManager.getTexture("ironWire2"), -32, 30);
        }

        public function get dir():int
        {
            return (this._dir);
        }

        public function set dir($dir:int):void
        {
           _dir = $dir;
           img1.visible = ($dir == 1);
           img2.visible = ($dir == 2);
        }


    }
} 