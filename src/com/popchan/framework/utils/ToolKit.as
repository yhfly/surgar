
package com.popchan.framework.utils
{
    import starling.display.Image;
    import starling.display.DisplayObjectContainer;
    import starling.textures.Texture;
    import starling.display.CMovieClip;
    import __AS3__.vec.Vector;
    import starling.display.TextSprite;
    import starling.text.TextField;
    import starling.display.Button;
    import starling.events.Event;
    import com.popchan.sugar.modules.menu.view.HProgressBar;

    public class ToolKit 
    {


        public static function createImage(_arg1:DisplayObjectContainer, _arg2:Texture, _arg3:int=0, _arg4:int=0, _arg5:Boolean=false, _arg6:Boolean=true):Image
        {
            var _local7:Image = new Image(_arg2);
            _local7.x = _arg3;
            _local7.y = _arg4;
            _local7.touchable = _arg6;
            _arg1.addChild(_local7);
            if (_arg5)
            {
                _local7.pivotX = (_local7.width >> 1);
                _local7.pivotY = (_local7.height >> 1);
            };
            return (_local7);
        }

        public static function createMovieClip(_arg1:DisplayObjectContainer, _arg2:Vector.<Texture>, _arg3:int=0, _arg4:int=0):CMovieClip
        {
            var _local5:CMovieClip = new CMovieClip(_arg2);
            _local5.x = _arg3;
            _local5.y = _arg4;
            _arg1.addChild(_local5);
            _local5.gotoAndStop(1);
            return (_local5);
        }

        public static function createTextSprite(_arg1:DisplayObjectContainer, _arg2:Vector.<Texture>, _arg3:int=0, _arg4:int=0, _arg5:int=10, _arg6:String="0123456789", _arg7:int=10):TextSprite
        {
            var _local8:TextSprite = new TextSprite(_arg2, _arg5, _arg6, _arg7);
            _arg1.addChild(_local8);
            _local8.x = _arg3;
            _local8.y = _arg4;
            return (_local8);
        }

        public static function createTextField(_arg1:DisplayObjectContainer, _arg2:int=50, _arg3:int=30, _arg4:int=0, _arg5:int=0, _arg6:int=30, _arg7:int=0xFFFFFF, _arg8:String="", _arg9:String="center", _arg10:String="center"):TextField
        {
            var _local11:TextField = new TextField(_arg2, _arg3, "", _arg8);
            _local11.x = _arg4;
            _local11.y = _arg5;
            _local11.fontSize = _arg6;
            _local11.hAlign = _arg9;
            _local11.vAlign = _arg10;
            _local11.color = _arg7;
            _arg1.addChild(_local11);
            _local11.touchable = false;
            return (_local11);
        }

        public static function createButton(continer:DisplayObjectContainer, posX:Texture, posY:int, _arg4:int, trigFunc:Function=null):Button
        {
            var button:Button = new Button(posX);
            button.x = posY;
            button.y = _arg4;
            if (trigFunc != null)
            {
                button.addEventListener(Event.TRIGGERED, trigFunc);
            };
            continer.addChild(button);
            return button;
        }

        public static function createProgressBar(_arg1:DisplayObjectContainer, _arg2:Texture, _arg3:Texture, _arg4:int, _arg5:int, _arg6:int=0, _arg7:int=0, _arg8:Boolean=true):HProgressBar
        {
            var _local9:HProgressBar = new HProgressBar(_arg2, _arg3, _arg6, _arg7, _arg8);
            _local9.x = _arg4;
            _local9.y = _arg5;
            _arg1.addChild(_local9);
            return (_local9);
        }
    }
}
