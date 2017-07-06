
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.core.Core;
    import com.popchan.framework.ds.BasePool;
    import com.popchan.framework.utils.ToolKit;
    
    import flash.utils.Dictionary;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class TileBoarder extends Element 
    {

        public static const x_border_heng_shang:int = 1;
        public static const x_border_heng_xia:int = 2;
        public static const x_border_left_down:int = 3;
        public static const x_border_left_down_x:int = 4;
        public static const x_border_left_up:int = 5;
        public static const x_border_left_up_x:int = 6;
        public static const x_border_right_down:int = 7;
        public static const x_border_right_down_x:int = 8;
        public static const x_border_right_up:int = 9;
        public static const x_border_right_up_x:int = 10;
        public static const x_border_shu_you:int = 11;
        public static const x_border_shu_zuo:int = 12;

        public static var pool:BasePool = new BasePool(TileBoarder, 100);

		private static var dic:Dictionary = new Dictionary();
		dic[x_border_heng_shang] = "x_border_heng_shang";
		dic[x_border_heng_xia] = "x_border_heng_xia";
		dic[x_border_left_down] = "x_border_left_down";
		dic[x_border_left_down_x] = "x_border_left_down_x";
		dic[x_border_left_up] = "x_border_left_up";
		dic[x_border_left_up_x] = "x_border_left_up_x";
		dic[x_border_right_down] = "x_border_right_down";
		dic[x_border_right_down_x] = "x_border_right_down_x";
		dic[x_border_right_up] = "x_border_right_up";
		dic[x_border_right_up_x] = "x_border_right_up_x";
		dic[x_border_shu_you] = "x_border_shu_you";
		dic[x_border_shu_zuo] = "x_border_shu_zuo";
		
        private var _image:Image;

		/**
		 * 格子边框 
		 * 
		 */		
        public function TileBoarder()
        {
			_image = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_heng_shang"));
			addChild(_image);
        }

        public function setType(borderType:int, _arg2:Sprite, posX:int, posY:int):void
        {
			var te:Texture = Core.texturesManager.getTexture(dic[borderType]);
			_image.width = te.width;
			_image.height = te.height;
			_image.texture = te;
            _arg2.addChild(this);
            x = posX;
            y = posY;
        }


    }
}