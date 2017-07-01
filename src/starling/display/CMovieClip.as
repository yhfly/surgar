
package starling.display
{
    import com.popchan.framework.ds.BasePool;
    import __AS3__.vec.Vector;
    import starling.textures.Texture;
    import com.popchan.framework.core.Core;
    import flash.utils.clearTimeout;
    import starling.events.Event;
    import flash.utils.setTimeout;

    public class CMovieClip extends Sprite 
    {

        public static const UPDATE:String = "update";
        public static const COMPLETE:String = "complete";

        public static var pool:BasePool = new BasePool(CMovieClip, 20);

        protected var _sequences:Object;
        protected var _currentSequence:Sequence;
        protected var _frameRate:int;
        protected var _isPlaying:Boolean;
        protected var _currentFrame:int;
        protected var _startFrame:int;
        protected var _endFrame:int;
        protected var _totalFrames:int;
        protected var _loopCount:int;
        protected var _loops:int;
        public var image:Image;
        protected var textures:Vector.<Texture>;
        private var timeOutID:int;

        public function CMovieClip(_arg1:Vector.<Texture>, _arg2:Number=12)
        {
            if (_arg1.length > 0)
            {
                this._sequences = {};
                this.init(_arg1, _arg2);
            }
            else
            {
                throw (new ArgumentError("Empty texture array"));
            };
        }

        private function init(_arg1:Vector.<Texture>, _arg2:Number):void
        {
            this.image = new Image(_arg1[0]);
            addChild(this.image);
            this.image.x = (-(width) >> 1);
            this.image.y = (-(height) >> 1);
            this.textures = _arg1.concat();
            if (_arg2 <= 0)
            {
                throw (new ArgumentError(("Invalid fps: " + _arg2)));
            };
            var _local3:int = _arg1.length;
            this.frameRate = _arg2;
            this.addSequence("all", 1, _local3);
            this.currentSequence = "all";
            this._totalFrames = _local3;
        }

        public function play():void
        {
            if (!this._isPlaying)
            {
                this._isPlaying = true;
                Core.timerManager.add(this, this.onTimer, (1000 / this._frameRate));
            };
        }

        public function stop():void
        {
            if (this._isPlaying)
            {
                this._isPlaying = false;
                Core.timerManager.remove(this, this.onTimer);
                this._loopCount = 0;
                clearTimeout(this.timeOutID);
            };
        }

        public function gotoAndPlay(_arg1:Object):void
        {
            this.gotoP(_arg1);
            this.play();
        }

        public function gotoAndStop(_arg1:Object):void
        {
            this.gotoP(_arg1);
            this.stop();
        }

        protected function gotoP(_arg1:Object):void
        {
            var _local2:int = parseInt(String(_arg1));
            if (_local2 < this._startFrame)
            {
                _local2 = this._startFrame;
            }
            else
            {
                if (_local2 > this._endFrame)
                {
                    _local2 = this._endFrame;
                };
            };
            this._currentFrame = _local2;
            this.animate();
        }

        protected function animate():void
        {
            if (((this.textures) && (!((this.image.texture == this.textures[(this._currentFrame - 1)])))))
            {
                this.image.texture = this.textures[(this._currentFrame - 1)];
                dispatchEvent(new Event(UPDATE));
            };
        }

        public function nextFrame():void
        {
            this.stop();
            this.gotoP((this._currentFrame + 1));
        }

        public function prevFrame():void
        {
            this.stop();
            this.gotoP((this._currentFrame - 1));
        }

        public function onTimer():void
        {
            this._currentFrame++;
            if (this._currentFrame > this._endFrame)
            {
                this._loopCount++;
                if (this._loopCount == this._loops)
                {
                    this._currentFrame--;
                    this._currentSequence;
                    this.stop();
                    this.setNextSequence();
                    return;
                };
                this._currentFrame = this._startFrame;
            };
            this.animate();
        }

        protected function setNextSequence():void
        {
            if (this._currentSequence.nextSequence)
            {
                if (this._currentSequence.nextSequenceDelay <= 0)
                {
                    this.currentSequence = this._currentSequence.nextSequence;
                    this.play();
                }
                else
                {
                    this.timeOutID = setTimeout(function ():void
                    {
                        currentSequence = _currentSequence.nextSequence;
                        play();
                    }, this._currentSequence.nextSequenceDelay);
                };
            }
            else
            {
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }

        public function get totalFrames():int
        {
            return (this._totalFrames);
        }

        public function get currentFrame():int
        {
            return (this._currentFrame);
        }

        public function get isPlaying():Boolean
        {
            return (this._isPlaying);
        }

        public function get playMode():int
        {
            return (this._currentSequence.playMode);
        }

        public function get frameRate():int
        {
            return (this._frameRate);
        }

        public function set frameRate(_arg1:int):void
        {
            if (_arg1 > 0)
            {
                this._frameRate = _arg1;
                Core.timerManager.remove(this, this.onTimer);
                Core.timerManager.add(this, this.onTimer, (1000 / _arg1));
            };
        }

        public function set loops(_arg1:int):void
        {
            this._loops = _arg1;
        }

        public function get loops():int
        {
            return (this._loops);
        }

        public function addSequence(_arg1:String, _arg2:int, _arg3:int, _arg4:int=0, _arg5:int=0, _arg6:String=null, _arg7:int=0):void
        {
            this._sequences[_arg1] = new Sequence(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7);
        }

        public function removeSequence(_arg1:String):void
        {
            if (this._sequences[_arg1] != null)
            {
                delete this._sequences[_arg1];
            };
        }

        public function get currentSequence():String
        {
            if (this._currentSequence)
            {
                return (this._currentSequence.name);
            };
            return (null);
        }

        public function set currentSequence(_arg1:String):void
        {
            this._currentSequence = this._sequences[_arg1];
            if (this._currentSequence)
            {
                this._currentFrame = (this._startFrame = this._currentSequence.startFrame);
                this._endFrame = this._currentSequence.endFrame;
                this._loopCount = 0;
                this._loops = this._currentSequence.loops;
                this.gotoAndPlay(this._currentFrame);
            }
            else
            {
                throw (new Error((_arg1 + "序列不存在，请先调用addSequence()")));
            };
        }

        public function destory():void
        {
            var _local1:Texture;
            this.stop();
            this._currentSequence = null;
            for each (_local1 in this.textures)
            {
                _local1.dispose();
            };
            clearTimeout(this.timeOutID);
            this.textures = null;
            removeChildren(0, -1, true);
        }

        override public function dispose():void
        {
            this.destory();
            super.dispose();
        }


    }
}//package starling.display

class Sequence 
{

    public var name:String;
    public var startFrame:int;
    public var endFrame:int;
    public var loops:int;
    public var playMode:int;
    public var nextSequence:String;
    public var nextSequenceDelay:int;

    public function Sequence(_arg1:String, _arg2:int, _arg3:int, _arg4:int=0, _arg5:int=0, _arg6:String=null, _arg7:int=0)
    {
        this.name = _arg1;
        this.startFrame = _arg2;
        this.endFrame = _arg3;
        this.loops = _arg4;
        this.playMode = _arg5;
        this.nextSequence = _arg6;
        this.nextSequenceDelay = _arg7;
    }

}
