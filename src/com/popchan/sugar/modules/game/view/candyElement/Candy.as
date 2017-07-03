
package com.popchan.sugar.modules.game.view.candyElement
{
    import com.popchan.framework.core.Core;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.framework.ds.BasePool;
    import com.popchan.framework.manager.SoundManager;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.sugar.core.Model;
    import com.popchan.sugar.core.data.CandySpecialStatus;
    import com.popchan.sugar.core.data.ColorType;
    import com.popchan.sugar.core.events.GameEvents;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import caurina.transitions.Tweener;
    
    import starling.display.Image;
    import starling.display.TextSprite;
    import starling.textures.Texture;
    import com.popchan.sugar.modules.game.view.Element;

	/**
	 * 糖果显示对象 
	 * @author admin
	 * 
	 */	
    public class Candy extends Element 
    {

        public static var pool:BasePool = new BasePool(Candy, 81);

        public var row:int;
        public var col:int;
        private var _color:int;
        private var _status:int;
        private var img:Image;
        public var mark:Boolean = false;
        public var remove:Boolean = false;
        private var _bombLeftCount:int = 0;
        public var path:Array;
        private var queue:Array;
        private var bomb_txt:TextSprite;
        private var r:Number = 0;
        private var rspeed:Number = 0.2;
        private var _isShake:Boolean;
        private var _nextStatus:int;

        public function Candy()
        {
			img = new Image(Core.texturesManager.getTexture("candy1"));
            path = [];
            queue = [];
            super();
        }

        public function get isShake():Boolean
        {
            return (_isShake);
        }

        public function isFruit():Boolean
        {
            if (_color == ColorType.FRUIT1 || _color == ColorType.FRUIT2 || _color == ColorType.FRUIT3)
            {
                return true;
            }
            return false;
        }

        public function get color():int
        {
            return (_color);
        }

        public function set color($color:int):void
        {
            _color = $color;
//            if (img != null)
//            {
//                img.removeFromParent(true);
//                img.dispose();
//                img = null;
//            }
            var imgResName:String = ("candy" + (color - 1));
            if (color == 7)
            {
                imgResName = "fruit1";
            }
            else  if (color == 8)
			{
				imgResName = "fruit2";
			}
            else if (color == 9)
			{
				imgResName = "fruit3";
			}
            img.texture = Core.texturesManager.getTexture(imgResName);
            img.pivotX = (img.width >> 1);
            img.pivotY = (img.height >> 1);
            addChild(img);
        }

        public function collidePoint(point:Point):Boolean
        {
            var rect:Rectangle = new Rectangle((-32 + x), (-32 + y), 64, 64);
            if (rect.containsPoint(point))
            {
                return true;
            }
            return false;
        }

        public function get status():int
        {
            return (_status);
        }

        public function runMoveAction(_arg1:Object):void
        {
            Tweener.addTween(this, _arg1);
        }

        public function addPath(_arg1:Object):void
        {
            path.push(_arg1);
        }

        public function stopAllActions():void
        {
            img.scaleX = (img.scaleY = 1);
            Tweener.removeTweens(img);
            Tweener.removeTweens(this);
        }

        public function runAsPath():void
        {
            var _local2:Object;
            var _local6:Object;
            var _local7:Object;
            stopAllActions();
            queue = [];
            var _local1:Object = path[0];
            if (_local1.type == 1)
            {
                _local2 = getCandyMoveAction(new Point(x, y), _local1.pos);
            }
            else
            {
                if (_local1.type == 2)
                {
                    _local2 = setCandMoveAction(_local1.pos);
                }
            }
            queue.push(_local2);
            var _local3:int = 1;
            while (_local3 < path.length)
            {
                _local6 = path[_local3];
                if (_local6.type == 1)
                {
                    _local7 = getCandyMoveAction(path[(_local3 - 1)].pos, path[_local3].pos);
                }
                else
                {
                    if (_local6.type == 2)
                    {
                        _local7 = setCandMoveAction(path[_local3].pos);
                    }
                }
                queue.push(_local7);
                _local3++;
            }
            var _local4:Object = {
                "time":0.1,
                "y":(path[(_local3 - 1)].pos.y - 3),
                "transition":"easeOutSine"
            }
            var _local5:Object = {
                "time":0.1,
                "y":(path[(_local3 - 1)].pos.y + 3),
                "transition":"easeOutSine"
            }
            queue.push(_local4);
            queue.push(_local5);
            path = [];
            runMoveQueueAction();
        }

        private function runMoveQueueAction():void
        {
            var param:Object;
            if (queue.length > 0)
            {
                param = queue.shift();
                param.onComplete = function ():void
                {
                    runMoveQueueAction();
                }
                Tweener.addTween(this, param);
            }
        }

        private function getCandyMoveAction(_arg1:Point, _arg2:Point):Object
        {
            var _local3:int = Math.abs((_arg2.y - _arg1.y));
            var _local4:int = Math.abs((_arg2.x - _arg1.x));
            var _local5:int = Math.sqrt(((_local4 * _local4) + (_local3 * _local3)));
            var _local6:Number = ((_local5 / 80) * 0.12);
            var _local7:Object = {
                "x":_arg2.x,
                "y":_arg2.y,
                "time":_local6,
                "transition":"linear"
            }
            return (_local7);
        }

        private function setCandMoveAction(_arg1:Point):Object
        {
            return ({
                "x":_arg1.x,
                "y":_arg1.y,
                "time":1E-7,
                "transition":"linear"
            });
        }

        public function setSpecialStatus($status:int, _arg2:Boolean=false, _arg3:Boolean=false):void
        {
            if (img != null)
            {
                img.removeFromParent(true);
                img.dispose();
                img = null;
            }
            _status = $status;
            if ($status == CandySpecialStatus.HORIZ)
            {
                img = new Image(Texture.fromTexture(Core.texturesManager.getTexture((("candy" + (color - 1)) + "a"))));
            }
            else   if ($status == CandySpecialStatus.VERT)
			{
				img = new Image(Texture.fromTexture(Core.texturesManager.getTexture((("candy" + (color - 1)) + "b"))));
			}
            else  if ($status == CandySpecialStatus.BOMB)
			{
				img = new Image(Texture.fromTexture(Core.texturesManager.getTexture(("candybomb" + (color - 1)))));
			}
            else if ($status == CandySpecialStatus.COLORFUL)
			{
				img = new Image(Texture.fromTexture(Core.texturesManager.getTexture("candyking")));
			}else
			{
	            img = new Image(Texture.fromTexture(Core.texturesManager.getTexture(("candy" + (color - 1)))));
			}
                    
			img = new Image(Texture.fromTexture(Core.texturesManager.getTexture(("candy" + (color - 1)))));
            img.pivotX = (img.width >> 1);
            img.pivotY = (img.height >> 1);
            addChild(img);
            img.scaleX = (img.scaleY = 1);
            if (_arg2)
            {
                img.scaleX = (img.scaleY = 0);
                Tweener.addTween(img, {
                    "time":0.25,
                    "scaleX":1,
                    "scaleY":1
                });
                SoundManager.instance.playSound("candyspgrow1", false, 0, 1, 1, true);
            }
        }

        public function setBomb(_arg1:int):void
        {
            if (img != null)
            {
                img.removeFromParent(true);
                img.dispose();
                img = null;
            }
            img = new Image(Texture.fromTexture(Core.texturesManager.getTexture(("candytimer" + (color - 1)))));
            img.pivotX = (img.width >> 1);
            img.pivotY = (img.height >> 1);
            addChild(img);
            _bombLeftCount = _arg1;
            if (!bomb_txt)
            {
                bomb_txt = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("bombtxt_"), -22, 0, 8, "0123456789/x+-", 24);
            }
            bomb_txt.text = (_arg1 + "");
        }

        public function bombCountUpdate():void
        {
            _bombLeftCount--;
            if (_bombLeftCount <= 0)
            {
                _bombLeftCount = 0;
                Model.gameModel.isSuccess = false;
                MsgDispatcher.execute(GameEvents.OPEN_GAME_END_UI);
            }
            bomb_txt.text = (_bombLeftCount + "");
        }

        public function getBombCount():int
        {
            return (_bombLeftCount);
        }

        override public function reset():void
        {
            Tweener.removeTweens(this);
            stopShake();
            _bombLeftCount = 0;
            _status = 0;
            mark = false;
            remove = false;
            scaleX = (scaleY = 1);
            if (img != null)
            {
                img.scaleX = (img.scaleY = 1);
            }
        }

        public function shake():void
        {
            Tweener.removeTweens(img);
            _isShake = true;
            Tweener.addTween(img, {
                "time":100,
                "transition":"linear",
                "onUpdate":function ():void
                {
                    var _local1:* = (Math.sin(r) * 10);
                    r = (r + rspeed);
                    img.rotation = ((Math.PI * _local1) / 180);
                },
                "onComplete":function ():void
                {
                    stopShake();
                }
            });
        }

        public function stopShake():void
        {
            _isShake = false;
            if (img)
            {
                Tweener.removeTweens(img);
                img.rotation = 0;
            }
            r = 0;
        }

        public function setNextStatus(_arg1:int):void
        {
            _nextStatus = _arg1;
        }

        public function getNextStatus():int
        {
            return (_nextStatus);
        }


    }
}//package com.popchan.sugar.modules.game.view
