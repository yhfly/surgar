
package com.popchan.framework.utils
{
    import flash.events.MouseEvent;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    import flash.display.PixelSnapping;
    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.display.Graphics;
    import flash.filters.ColorMatrixFilter;

    public class DisplayUtil 
    {

        private static const MOUSE_EVENT_LIST:Array = [MouseEvent.CLICK, MouseEvent.DOUBLE_CLICK, MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_OUT, MouseEvent.MOUSE_OVER, MouseEvent.MOUSE_UP, MouseEvent.MOUSE_WHEEL, MouseEvent.ROLL_OUT, MouseEvent.ROLL_OVER];

        private var indexNum:int = 0;


        public static function stopAllMovieClip(_arg1:DisplayObjectContainer, _arg2:uint=0):void
        {
            var _local3:DisplayObjectContainer;
            var _local4:MovieClip = (_arg1 as MovieClip);
            if (_local4 != null)
            {
                if (_arg2 != 0)
                {
                    _local4.gotoAndStop(_arg2);
                }
                else
                {
                    _local4.gotoAndStop(1);
                }
                _local4 = null;
            }
            var _local5:int = (_arg1.numChildren - 1);
            if (_local5 < 0)
            {
                return;
            }
            var _local6:int = _local5;
            while (_local6 >= 0)
            {
                _local3 = (_arg1.getChildAt(_local6) as DisplayObjectContainer);
                if (_local3 != null)
                {
                    stopAllMovieClip(_local3, _arg2);
                }
                _local6--;
            }
        }

        public static function playAllMovieClip(_arg1:DisplayObjectContainer):void
        {
            var _local2:DisplayObjectContainer;
            var _local3:MovieClip = (_arg1 as MovieClip);
            if (_local3 != null)
            {
                _local3.gotoAndPlay(1);
                _local3 = null;
            }
            var _local4:int = (_arg1.numChildren - 1);
            if (_local4 < 0)
            {
                return;
            }
            var _local5:int = _local4;
            while (_local5 >= 0)
            {
                _local2 = (_arg1.getChildAt(_local5) as DisplayObjectContainer);
                if (_local2 != null)
                {
                    playAllMovieClip(_local2);
                }
                _local5--;
            }
        }

        public static function removeAllChild(_arg1:DisplayObjectContainer):void
        {
            var _local2:DisplayObjectContainer;
            if (_arg1 == null)
            {
                return;
            }
            while (_arg1.numChildren > 0)
            {
                _local2 = (_arg1.removeChildAt(0) as DisplayObjectContainer);
                if (_local2 != null)
                {
                    stopAllMovieClip(_local2);
                    _local2 = null;
                }
            }
        }

        public static function removeForParent(_arg1:DisplayObject, _arg2:Boolean=false):void
        {
            var _local3:DisplayObjectContainer;
            var _local4:Bitmap;
            if (_arg1 == null)
            {
                return;
            }
            if (_arg1.parent == null)
            {
                return;
            }
            if (!_arg1.parent.contains(_arg1))
            {
                return;
            }
            if (_arg2)
            {
                _local3 = (_arg1 as DisplayObjectContainer);
                if (_local3)
                {
                    stopAllMovieClip(_local3, 1);
                    _local3 = null;
                }
                _local4 = (_arg1 as Bitmap);
                if (_local4)
                {
                    if (_local4.bitmapData)
                    {
                        _local4.bitmapData.dispose();
                    }
                }
            }
            _arg1.parent.removeChild(_arg1);
        }

        public static function removeBitampFormParent(_arg1:Bitmap, _arg2:Boolean=true):void
        {
            if (_arg1 == null)
            {
                return;
            }
            if (_arg1.parent == null)
            {
                return;
            }
            if (!_arg1.parent.contains(_arg1))
            {
                return;
            }
            if (_arg2)
            {
                if (_arg1.bitmapData)
                {
                    _arg1.bitmapData.dispose();
                }
                _arg1 = null;
            }
        }

        public static function disposeBitamp(_arg1:Bitmap):void
        {
            if (((_arg1) && (_arg1.bitmapData)))
            {
                _arg1.bitmapData.dispose();
            }
            _arg1 = null;
        }

        public static function hasParent(_arg1:DisplayObject):Boolean
        {
            if (_arg1.parent == null)
            {
                return false;
            }
            return (_arg1.parent.contains(_arg1));
        }

        public static function localToLocal(_arg1:DisplayObject, _arg2:DisplayObject, _arg3:Point=null):Point
        {
            if (_arg3 == null)
            {
                _arg3 = new Point(0, 0);
            }
            _arg3 = _arg1.localToGlobal(_arg3);
            return (_arg2.globalToLocal(_arg3));
        }

        public static function FillColor(_arg1:DisplayObject, _arg2:uint):void
        {
            var _local3:ColorTransform = new ColorTransform();
            _local3.color = _arg2;
            _arg1.transform.colorTransform = _local3;
        }

        public static function getColor(_arg1:DisplayObject, _arg2:uint=0, _arg3:uint=0, _arg4:Boolean=false):uint
        {
            var _local5:BitmapData = new BitmapData(_arg1.width, _arg1.height);
            _local5.draw(_arg1);
            var _local6:uint = ((_arg4) ? _local5.getPixel32(int(_arg2), int(_arg3)) : _local5.getPixel(int(_arg2), int(_arg3)));
            _local5.dispose();
            return (_local6);
        }

        public static function uniformScale(_arg1:DisplayObject, _arg2:Number):void
        {
            if (_arg1.width >= _arg1.height)
            {
                _arg1.width = _arg2;
                _arg1.scaleY = _arg1.scaleX;
            }
            else
            {
                _arg1.height = _arg2;
                _arg1.scaleX = _arg1.scaleY;
            }
        }

        public static function copyDisplayAsBmp(_arg1:DisplayObject, _arg2:Boolean=true):Bitmap
        {
            var _local3:Number;
            var _local4:Number;
            _local4 = _arg1.scaleY;
            _local3 = _arg1.scaleX;
            var _local5:BitmapData = new BitmapData(_arg1.width, _arg1.height, true, 0);
            var _local6:Rectangle = _arg1.getRect(_arg1);
            var _local7:Matrix = new Matrix();
            if (_local3 < 0)
            {
                _arg1.scaleX = -(_arg1.scaleX);
            }
            if (_local4 < 0)
            {
                _arg1.scaleY = -(_arg1.scaleY);
            }
            _local7.createBox(_arg1.scaleX, _arg1.scaleY, 0, (-(_local6.x) * _arg1.scaleX), (-(_local6.y) * _arg1.scaleY));
            _local5.draw(_arg1, _local7);
            _arg1.scaleX = _local3;
            _arg1.scaleY = _local4;
            var _local8:Bitmap = new Bitmap(_local5, PixelSnapping.AUTO, _arg2);
            if (_local3 < 0)
            {
                _local8.scaleX = -1;
            }
            if (_local4 < 0)
            {
                _local8.scaleY = -1;
            }
            _local8.x = (_local6.x * _arg1.scaleX);
            _local8.y = (_local6.y * _arg1.scaleY);
            return (_local8);
        }

        public static function mouseEnabledAll(target:InteractiveObject, isAll:Boolean=false):void
        {
            var i:int;
            var child:InteractiveObject;
            var b:Boolean = MOUSE_EVENT_LIST.some(function (_arg1:String, _arg2:int, _arg3:Array):Boolean
            {
                if (target.hasEventListener(_arg1))
                {
                    return true;
                }
                return false;
            });
            if (!b)
            {
                if (target.name.indexOf("instance") != -1)
                {
                    target.mouseEnabled = false;
                }
            }
            var container:DisplayObjectContainer = (target as DisplayObjectContainer);
            if (container)
            {
                i = (container.numChildren - 1);
                while (i >= 0)
                {
                    child = (container.getChildAt(i) as InteractiveObject);
                    if (child)
                    {
                        mouseEnabledAll(child);
                    }
                    i--;
                }
            }
        }

        public static function makeRectangle(_arg1:Number, _arg2:Number, _arg3:uint=0, _arg4:uint=0, _arg5:Number=1):Sprite
        {
            var _local6:Sprite = new Sprite();
            _local6.graphics.lineStyle(1, _arg3);
            _local6.graphics.beginFill(_arg4);
            _local6.graphics.drawRect(0, 0, _arg1, _arg2);
            _local6.graphics.endFill();
            _local6.alpha = _arg5;
            return (_local6);
        }

        public static function makeCircle(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:uint=0, _arg5:uint=0, _arg6:Number=1):Sprite
        {
            var _local7:Sprite = new Sprite();
            _local7.graphics.lineStyle(1, _arg4);
            _local7.graphics.beginFill(_arg5);
            _local7.graphics.drawCircle(_arg1, _arg2, _arg3);
            _local7.graphics.endFill();
            _local7.alpha = _arg6;
            return (_local7);
        }

        public static function cutBitmap(_arg1:uint, _arg2:uint, _arg3:BitmapData):Array
        {
            var _local4:int;
            var _local5:BitmapData;
            var _local6:Bitmap;
            var _local10:int;
            var _local7:uint = Math.ceil((_arg3.width / _arg1));
            var _local8:uint = Math.ceil((_arg3.height / _arg2));
            var _local9:Array = new Array();
            while (_local10 < _arg1)
            {
                _local4 = 0;
                while (_local4 < _arg2)
                {
                    _local5 = new BitmapData(_local7, _local8);
                    _local5.copyPixels(_arg3, new Rectangle((_local10 * _local7), (_local4 * _local8), _local7, _local8), new Point());
                    _local6 = new Bitmap(_local5);
                    _local6.x = (_local10 * _local7);
                    _local6.y = (_local4 * _local8);
                    _local9.push(_local6);
                    _local4++;
                }
                _local10++;
            }
            return (_local9);
        }

        public static function cutBitmapByWH(_arg1:uint, _arg2:uint, _arg3:BitmapData):Array
        {
            var _local4:int;
            var _local5:BitmapData;
            var _local6:Bitmap;
            var _local10:int;
            var _local7:uint = Math.ceil((_arg3.width / _arg1));
            if (_arg1 == 0)
            {
                _arg1 = _arg3.width;
                _local7 = 1;
            }
            var _local8:uint = Math.ceil((_arg3.height / _arg2));
            if (_arg2 == 0)
            {
                _arg2 = _arg3.height;
                _local8 = 1;
            }
            var _local9:Array = new Array();
            while (_local10 < _local7)
            {
                _local4 = 0;
                while (_local4 < _local8)
                {
                    _local5 = new BitmapData(_arg1, _arg2);
                    _local5.copyPixels(_arg3, new Rectangle((_local10 * _arg1), (_local4 * _arg2), _arg1, _arg2), new Point());
                    _local6 = new Bitmap(_local5);
                    _local6.x = _local10;
                    _local6.y = _local4;
                    _local9.push(_local6);
                    _local4++;
                }
                _local10++;
            }
            return (_local9);
        }

        public static function getBezier(_arg1:Point, _arg2:Point, _arg3:Point, _arg4:uint):Array
        {
            var _local5:Number;
            var _local6:Number;
            var _local7:Number = 0;
            var _local8:Number = (1 / _arg4);
            var _local9:Number = 0;
            var _local10:Array = new Array();
            var _local11:Number = 0;
            while (_local11 < 1)
            {
                _local9 = (1 - _local7);
                _local5 = ((((_local9 * _local9) * _arg1.x) + (((2 * _local7) * _local9) * _arg3.x)) + ((_local7 * _local7) * _arg2.x));
                _local6 = ((((_local9 * _local9) * _arg1.y) + (((2 * _local7) * _local9) * _arg3.y)) + ((_local7 * _local7) * _arg2.y));
                _local7 = _local11;
                _local10.push(new Point(uint(_local5), uint(_local6)));
                _local11 = (_local11 + _local8);
            }
            _local10.push(new Point(uint(_arg2.x), uint(_arg2.y)));
            return (_local10);
        }

        public static function getLine(_arg1:Point, _arg2:Point, _arg3:uint):Array
        {
            var _local4:Boolean;
            var _local5:Boolean;
            var _local6:Number;
            var _local7:Number;
            var _local11:int;
            var _local8:Array = new Array();
            var _local9:uint = Math.abs((_arg1.x - _arg2.x));
            var _local10:uint = Math.abs((_arg1.y - _arg2.y));
            if (_arg1.x < _arg2.x)
            {
                _local4 = true;
            }
            if (_arg1.y < _arg2.y)
            {
                _local5 = true;
            }
            while (_local11 < _arg3)
            {
                if (_local4)
                {
                    _local6 = (_arg1.x + ((_local11 / _arg3) * _local9));
                }
                else
                {
                    _local6 = (_arg1.x - ((_local11 / _arg3) * _local9));
                }
                if (_local5)
                {
                    _local7 = (_arg1.y + ((_local11 / _arg3) * _local10));
                }
                else
                {
                    _local7 = (_arg1.y - ((_local11 / _arg3) * _local10));
                }
                _local8.push(new Point(uint(_local6), uint(_local7)));
                _local11++;
            }
            _local8.push(new Point(uint(_arg2.x), uint(_arg2.y)));
            return (_local8);
        }

        public static function drawDashedLine(_arg1:Graphics, _arg2:int, _arg3:int, _arg4:int, _arg5:int, _arg6:int=5):void
        {
            var _local14:Number;
            var _local15:Number;
            var _local16:Number;
            var _local17:Number;
            var _local7:Number = (_arg4 - _arg2);
            var _local8:Number = (_arg5 - _arg3);
            var _local9:Number = Math.sqrt(((_local7 * _local7) + (_local8 * _local8)));
            var _local10:int = Math.round((((_local9 / _arg6) + 1) / 2));
            var _local11:Number = (_local7 / _local10);
            var _local12:Number = (_local8 / _local10);
            var _local13:uint;
            while (_local13 < _local10)
            {
                _local14 = (_arg2 + (_local13 * _local11));
                _local15 = (_arg3 + (_local13 * _local12));
                _local16 = (_local14 + (_local11 * 0.5));
                _local17 = (_local15 + (_local12 * 0.5));
                _arg1.moveTo(Math.round(_local14), Math.round(_local15));
                _arg1.lineTo(Math.round(_local16), Math.round(_local17));
                _local13++;
            }
        }

        public static function drawSector(_arg1:Sprite, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:Number, _arg7:Number, _arg8:Number, _arg9:Number):void
        {
            _arg1.graphics.clear();
            _arg1.graphics.lineStyle(0, _arg8);
            _arg1.graphics.beginFill(_arg9);
            var _local10:Number = (Math.PI / 180);
            _arg2 = (_arg2 * _local10);
            _arg3 = (_arg3 * _local10);
            _arg7 = (_arg7 * _local10);
            _arg1.graphics.moveTo(_arg5, _arg6);
            var _local11:Number = _arg2;
            while (_local11 < _arg3)
            {
                _arg1.graphics.lineTo((_arg5 + (_arg4 * Math.cos(_local11))), (_arg6 + (_arg4 * Math.sin(_local11))));
                _local11 = (_local11 + Math.min(_arg7, (_arg3 - _local11)));
            }
            _arg1.graphics.lineTo((_arg5 + (_arg4 * Math.cos(_arg3))), (_arg6 + (_arg4 * Math.sin(_arg3))));
            _arg1.graphics.lineTo(_arg5, _arg6);
        }

        public static function isMouseInSpt(_arg1:DisplayObject, _arg2:DisplayObjectContainer=null):Boolean
        {
            if (!_arg2)
            {
                _arg2 = _arg1.parent;
            }
            if (!_arg1.parent)
            {
                return false;
            }
            var _local3:BitmapData = new BitmapData(_arg1.width, _arg1.height, true, 0);
            var _local4:Matrix = new Matrix();
            var _local5:Rectangle = _arg1.getBounds(_arg2);
            _local4.tx = -((_local5.x - _arg1.x));
            _local4.ty = -((_local5.y - _arg1.y));
            _local3.draw(_arg1, _local4);
            var _local6:uint = _local3.getPixel32((_local4.tx + _arg1.mouseX), (_local4.ty + _arg1.mouseY));
            return (!((_local6 == 0)));
        }

        public static function setBrightness(_arg1:DisplayObject, _arg2:Number):void
        {
            var _local3:ColorTransform = _arg1.transform.colorTransform;
            var _local4:* = _arg1.filters;
            if (_arg2 >= 0)
            {
                _local3.blueMultiplier = (1 - _arg2);
                _local3.redMultiplier = (1 - _arg2);
                _local3.greenMultiplier = (1 - _arg2);
                _local3.redOffset = (0xFF * _arg2);
                _local3.greenOffset = (0xFF * _arg2);
                _local3.blueOffset = (0xFF * _arg2);
            }
            else
            {
                _arg2 = Math.abs(_arg2);
                _local3.blueMultiplier = (1 - _arg2);
                _local3.redMultiplier = (1 - _arg2);
                _local3.greenMultiplier = (1 - _arg2);
                _local3.redOffset = 0;
                _local3.greenOffset = 0;
                _local3.blueOffset = 0;
            }
            _arg1.transform.colorTransform = _local3;
            _arg1.filters = _local4;
        }

        public static function createSaturationFilter(_arg1:Number):ColorMatrixFilter
        {
            return (new ColorMatrixFilter([((0.3086 * (1 - _arg1)) + _arg1), (0.6094 * (1 - _arg1)), (0.082 * (1 - _arg1)), 0, 0, (0.3086 * (1 - _arg1)), ((0.6094 * (1 - _arg1)) + _arg1), (0.082 * (1 - _arg1)), 0, 0, (0.3086 * (1 - _arg1)), (0.6094 * (1 - _arg1)), ((0.082 * (1 - _arg1)) + _arg1), 0, 0, 0, 0, 0, 1, 0]));
        }

        public static function createContrastFilter(_arg1:Number):ColorMatrixFilter
        {
            return (new ColorMatrixFilter([_arg1, 0, 0, 0, (128 * (1 - _arg1)), 0, _arg1, 0, 0, (128 * (1 - _arg1)), 0, 0, _arg1, 0, (128 * (1 - _arg1)), 0, 0, 0, 1, 0]));
        }

        public static function createBrightnessFilter(_arg1:Number):ColorMatrixFilter
        {
            return (new ColorMatrixFilter([1, 0, 0, 0, _arg1, 0, 1, 0, 0, _arg1, 0, 0, 1, 0, _arg1, 0, 0, 0, 1, 0]));
        }

        public static function createInversionFilter():ColorMatrixFilter
        {
            return (new ColorMatrixFilter([-1, 0, 0, 0, 0xFF, 0, -1, 0, 0, 0xFF, 0, 0, -1, 0, 0xFF, 0, 0, 0, 1, 0]));
        }

        public static function createHueFilter(_arg1:Number):ColorMatrixFilter
        {
            var _local2:Number = Math.cos(((_arg1 * Math.PI) / 180));
            var _local3:Number = Math.sin(((_arg1 * Math.PI) / 180));
            var _local4:Number = 0.213;
            var _local5:Number = 0.715;
            var _local6:Number = 0.072;
            return (new ColorMatrixFilter([((_local4 + (_local2 * (1 - _local4))) + (_local3 * (0 - _local4))), ((_local5 + (_local2 * (0 - _local5))) + (_local3 * (0 - _local5))), ((_local6 + (_local2 * (0 - _local6))) + (_local3 * (1 - _local6))), 0, 0, ((_local4 + (_local2 * (0 - _local4))) + (_local3 * 0.143)), ((_local5 + (_local2 * (1 - _local5))) + (_local3 * 0.14)), ((_local6 + (_local2 * (0 - _local6))) + (_local3 * -0.283)), 0, 0, ((_local4 + (_local2 * (0 - _local4))) + (_local3 * (0 - (1 - _local4)))), ((_local5 + (_local2 * (0 - _local5))) + (_local3 * _local5)), ((_local6 + (_local2 * (1 - _local6))) + (_local3 * _local6)), 0, 0, 0, 0, 0, 1, 0]));
        }

        public static function createThresholdFilter(_arg1:Number):ColorMatrixFilter
        {
            return (new ColorMatrixFilter([(0.3086 * 0x0100), (0.6094 * 0x0100), (0.082 * 0x0100), 0, (-256 * _arg1), (0.3086 * 0x0100), (0.6094 * 0x0100), (0.082 * 0x0100), 0, (-256 * _arg1), (0.3086 * 0x0100), (0.6094 * 0x0100), (0.082 * 0x0100), 0, (-256 * _arg1), 0, 0, 0, 1, 0]));
        }

        public static function setLithification(_arg1:DisplayObject):void
        {
            _arg1.filters = [DisplayUtil.createBrightnessFilter(-10), DisplayUtil.createContrastFilter(0.8), DisplayUtil.createSaturationFilter(0)];
        }

        public static function setPoison(_arg1:DisplayObject):void
        {
            var _local2:ColorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, 0, 85, 0, 0);
            _arg1.transform.colorTransform = _local2;
        }


        public function getTotalChildNumber(tar:DisplayObjectContainer):void
        {
            var child:DisplayObjectContainer;
            var len:int = tar.numChildren;
            this.indexNum = (this.indexNum + tar.numChildren);
            while (len > 0)
            {
                try
                {
                    child = (tar.getChildAt((len - 1)) as DisplayObjectContainer);
                }
                catch(e:Error)
                {
                    child = null;
                }
                if (((child) && (child.numChildren)))
                {
                    this.getTotalChildNumber(child);
                }
                len = (len - 1);
            }
        }

        public function getTotalChildren(_arg1:DisplayObjectContainer):int
        {
            var _local3:int;
            var _local5:DisplayObjectContainer;
            var _local2:int;
            var _local4:Array = [_arg1];
            while (_local4.length)
            {
                _arg1 = _local4.pop();
                _local3 = _arg1.numChildren;
                _local2 = (_local2 + _local3);
                while (_local3--)
                {
                    try
                    {
                        _local5 = (_arg1.getChildAt(_local3) as DisplayObjectContainer);
                        ((_local5) && (_local4.push(_local5)));
                    }
                    catch(e:Error)
                    {
                    }
                }
            }
            return (_local2);
        }


    }
}//package com.popchan.framework.utils
