
package starling.extensions
{
    public class ColorArgb 
    {

        public var red:Number;
        public var green:Number;
        public var blue:Number;
        public var alpha:Number;

        public function ColorArgb(_arg1:Number=0, _arg2:Number=0, _arg3:Number=0, _arg4:Number=0)
        {
            this.red = _arg1;
            this.green = _arg2;
            this.blue = _arg3;
            this.alpha = _arg4;
        }

        public static function fromRgb(_arg1:uint):ColorArgb
        {
            var _local2:ColorArgb = new (ColorArgb)();
            _local2.fromRgb(_arg1);
            return (_local2);
        }

        public static function fromArgb(_arg1:uint):ColorArgb
        {
            var _local2:ColorArgb = new (ColorArgb)();
            _local2.fromArgb(_arg1);
            return (_local2);
        }


        public function toRgb():uint
        {
            var _local1:Number = this.red;
            if (_local1 < 0)
            {
                _local1 = 0;
            }
            else
            {
                if (_local1 > 1)
                {
                    _local1 = 1;
                };
            };
            var _local2:Number = this.green;
            if (_local2 < 0)
            {
                _local2 = 0;
            }
            else
            {
                if (_local2 > 1)
                {
                    _local2 = 1;
                };
            };
            var _local3:Number = this.blue;
            if (_local3 < 0)
            {
                _local3 = 0;
            }
            else
            {
                if (_local3 > 1)
                {
                    _local3 = 1;
                };
            };
            return ((((int((_local1 * 0xFF)) << 16) | (int((_local2 * 0xFF)) << 8)) | int((_local3 * 0xFF))));
        }

        public function toArgb():uint
        {
            var _local1:Number = this.alpha;
            if (_local1 < 0)
            {
                _local1 = 0;
            }
            else
            {
                if (_local1 > 1)
                {
                    _local1 = 1;
                };
            };
            var _local2:Number = this.red;
            if (_local2 < 0)
            {
                _local2 = 0;
            }
            else
            {
                if (_local2 > 1)
                {
                    _local2 = 1;
                };
            };
            var _local3:Number = this.green;
            if (_local3 < 0)
            {
                _local3 = 0;
            }
            else
            {
                if (_local3 > 1)
                {
                    _local3 = 1;
                };
            };
            var _local4:Number = this.blue;
            if (_local4 < 0)
            {
                _local4 = 0;
            }
            else
            {
                if (_local4 > 1)
                {
                    _local4 = 1;
                };
            };
            return (((((int((_local1 * 0xFF)) << 24) | (int((_local2 * 0xFF)) << 16)) | (int((_local3 * 0xFF)) << 8)) | int((_local4 * 0xFF))));
        }

        public function fromRgb(_arg1:uint):void
        {
            this.red = (((_arg1 >> 16) & 0xFF) / 0xFF);
            this.green = (((_arg1 >> 8) & 0xFF) / 0xFF);
            this.blue = ((_arg1 & 0xFF) / 0xFF);
        }

        public function fromArgb(_arg1:uint):void
        {
            this.red = (((_arg1 >> 16) & 0xFF) / 0xFF);
            this.green = (((_arg1 >> 8) & 0xFF) / 0xFF);
            this.blue = ((_arg1 & 0xFF) / 0xFF);
            this.alpha = (((_arg1 >> 24) & 0xFF) / 0xFF);
        }

        public function copyFrom(_arg1:ColorArgb):void
        {
            this.red = _arg1.red;
            this.green = _arg1.green;
            this.blue = _arg1.blue;
            this.alpha = _arg1.alpha;
        }


    }
}//package starling.extensions
