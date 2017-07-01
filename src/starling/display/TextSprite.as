
package starling.display
{
    import __AS3__.vec.Vector;
    import starling.textures.Texture;

    public class TextSprite extends Sprite 
    {

        private var _txt:String;
        private var _textures:Vector.<Texture>;
        private var _offset:int;
        private var _queue:String;
        private var _hAlign:String = "left";
        private var _charW:int;

        public function TextSprite(_arg1:Vector.<Texture>, _arg2:int=0, _arg3:String="0123456789", _arg4:int=10)
        {
            this._textures = _arg1;
            this._offset = _arg2;
            this._queue = _arg3;
            this._charW = _arg4;
            touchable = false;
        }

        public function get hAlign():String
        {
            return (this._hAlign);
        }

        public function set hAlign(_arg1:String):void
        {
            this._hAlign = _arg1;
        }

        public function get text():String
        {
            return (this._txt);
        }

        public function set text(_arg1:String):void
        {
            var _local5:int;
            var _local6:Image;
            this._txt = _arg1;
            while (this.numChildren > 0)
            {
                this.removeChildAt(0, true);
            };
            var _local2:int = _arg1.length;
            var _local3:Number = ((_local2 * this._charW) + ((_local2 - 1) * (this._offset - this._charW)));
            var _local4:int;
            while (_local4 < _local2)
            {
                _local5 = this._queue.indexOf(_arg1.charAt(_local4));
                _local6 = new Image(this._textures[_local5]);
                if (this._hAlign == "center")
                {
                    _local6.x = ((_local4 * this._offset) - (_local3 * 0.5));
                }
                else
                {
                    _local6.x = (_local4 * this._offset);
                };
                addChild(_local6);
                _local4++;
            };
        }

        public function easeToTarget(_arg1:Number, _arg2:Number):void
        {
        }


    }
}//package starling.display
