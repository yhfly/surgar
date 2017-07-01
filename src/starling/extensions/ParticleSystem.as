
package starling.extensions
{
    import starling.display.DisplayObject;
    import starling.animation.IAnimatable;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import starling.textures.Texture;
    import flash.display3D.Program3D;
    import starling.utils.VertexData;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.IndexBuffer3D;
    import starling.textures.TextureSmoothing;
    import flash.display3D.Context3DBlendFactor;
    import starling.core.Starling;
    import starling.events.Event;
    import flash.display3D.Context3D;
    import starling.errors.MissingContextError;
    import flash.geom.Rectangle;
    import starling.utils.MatrixUtil;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;
    import starling.core.RenderSupport;
    import com.adobe.utils.AGALMiniAssembler;
    import __AS3__.vec.*;

    public class ParticleSystem extends DisplayObject implements IAnimatable 
    {

        public static const MAX_NUM_PARTICLES:int = 16383;

        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sHelperPoint:Point = new Point();
        private static var sRenderAlpha:Vector.<Number> = new <Number>[1, 1, 1, 1];

        private var mTexture:Texture;
        private var mParticles:Vector.<Particle>;
        private var mFrameTime:Number;
        private var mProgram:Program3D;
        private var mVertexData:VertexData;
        private var mVertexBuffer:VertexBuffer3D;
        private var mIndices:Vector.<uint>;
        private var mIndexBuffer:IndexBuffer3D;
        private var mNumParticles:int;
        private var mMaxCapacity:int;
        private var mEmissionRate:Number;
        private var mEmissionTime:Number;
        protected var mEmitterX:Number;
        protected var mEmitterY:Number;
        protected var mPremultipliedAlpha:Boolean;
        protected var mBlendFactorSource:String;
        protected var mBlendFactorDestination:String;
        protected var mSmoothing:String;

        public function ParticleSystem(_arg1:Texture, _arg2:Number, _arg3:int=128, _arg4:int=16383, _arg5:String=null, _arg6:String=null)
        {
            if (_arg1 == null)
            {
                throw (new ArgumentError("texture must not be null"));
            };
            this.mTexture = _arg1;
            this.mPremultipliedAlpha = _arg1.premultipliedAlpha;
            this.mParticles = new Vector.<Particle>(0, false);
            this.mVertexData = new VertexData(0);
            this.mIndices = new <uint>[];
            this.mEmissionRate = _arg2;
            this.mEmissionTime = 0;
            this.mFrameTime = 0;
            this.mEmitterX = (this.mEmitterY = 0);
            this.mMaxCapacity = Math.min(MAX_NUM_PARTICLES, _arg4);
            this.mSmoothing = TextureSmoothing.BILINEAR;
            this.mBlendFactorDestination = ((_arg6) || (Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA));
            this.mBlendFactorSource = ((_arg5) || (((this.mPremultipliedAlpha) ? Context3DBlendFactor.ONE : Context3DBlendFactor.SOURCE_ALPHA)));
            this.createProgram();
            this.raiseCapacity(_arg3);
            Starling.current.stage3D.addEventListener(Event.CONTEXT3D_CREATE, this.onContextCreated, false, 0, true);
        }

        override public function dispose():void
        {
            Starling.current.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, this.onContextCreated);
            if (this.mVertexBuffer)
            {
                this.mVertexBuffer.dispose();
            };
            if (this.mIndexBuffer)
            {
                this.mIndexBuffer.dispose();
            };
            super.dispose();
        }

        private function onContextCreated(_arg1:Object):void
        {
            this.createProgram();
            this.raiseCapacity(0);
        }

        protected function createParticle():Particle
        {
            return (new Particle());
        }

        protected function initParticle(_arg1:Particle):void
        {
            _arg1.x = this.mEmitterX;
            _arg1.y = this.mEmitterY;
            _arg1.currentTime = 0;
            _arg1.totalTime = 1;
            _arg1.color = (Math.random() * 0xFFFFFF);
        }

        protected function advanceParticle(_arg1:Particle, _arg2:Number):void
        {
            _arg1.y = (_arg1.y + (_arg2 * 250));
            _arg1.alpha = (1 - (_arg1.currentTime / _arg1.totalTime));
            _arg1.scale = (1 - _arg1.alpha);
            _arg1.currentTime = (_arg1.currentTime + _arg2);
        }

        private function raiseCapacity(_arg1:int):void
        {
            var _local7:int;
            var _local8:int;
            var _local2:int = this.capacity;
            var _local3:int = Math.min(this.mMaxCapacity, (this.capacity + _arg1));
            var _local4:Context3D = Starling.context;
            if (_local4 == null)
            {
                throw (new MissingContextError());
            };
            var _local5:VertexData = new VertexData(4);
            _local5.setTexCoords(0, 0, 0);
            _local5.setTexCoords(1, 1, 0);
            _local5.setTexCoords(2, 0, 1);
            _local5.setTexCoords(3, 1, 1);
            this.mTexture.adjustVertexData(_local5, 0, 4);
            this.mParticles.fixed = false;
            this.mIndices.fixed = false;
            var _local6:int = _local2;
            while (_local6 < _local3)
            {
                _local7 = (_local6 * 4);
                _local8 = (_local6 * 6);
                this.mParticles[_local6] = this.createParticle();
                this.mVertexData.append(_local5);
                this.mIndices[_local8] = _local7;
                this.mIndices[int((_local8 + 1))] = (_local7 + 1);
                this.mIndices[int((_local8 + 2))] = (_local7 + 2);
                this.mIndices[int((_local8 + 3))] = (_local7 + 1);
                this.mIndices[int((_local8 + 4))] = (_local7 + 3);
                this.mIndices[int((_local8 + 5))] = (_local7 + 2);
                _local6++;
            };
            this.mParticles.fixed = true;
            this.mIndices.fixed = true;
            if (this.mVertexBuffer)
            {
                this.mVertexBuffer.dispose();
            };
            if (this.mIndexBuffer)
            {
                this.mIndexBuffer.dispose();
            };
            this.mVertexBuffer = _local4.createVertexBuffer((_local3 * 4), VertexData.ELEMENTS_PER_VERTEX);
            this.mVertexBuffer.uploadFromVector(this.mVertexData.rawData, 0, (_local3 * 4));
            this.mIndexBuffer = _local4.createIndexBuffer((_local3 * 6));
            this.mIndexBuffer.uploadFromVector(this.mIndices, 0, (_local3 * 6));
        }

        public function start(_arg1:Number=1.79769313486232E308):void
        {
            if (this.mEmissionRate != 0)
            {
                this.mEmissionTime = _arg1;
            };
        }

        public function stop(_arg1:Boolean=false):void
        {
            this.mEmissionTime = 0;
            if (_arg1)
            {
                this.clear();
            };
        }

        public function clear():void
        {
            this.mNumParticles = 0;
        }

        override public function getBounds(_arg1:DisplayObject, _arg2:Rectangle=null):Rectangle
        {
            if (_arg2 == null)
            {
                _arg2 = new Rectangle();
            };
            getTransformationMatrix(_arg1, sHelperMatrix);
            MatrixUtil.transformCoords(sHelperMatrix, 0, 0, sHelperPoint);
            _arg2.x = sHelperPoint.x;
            _arg2.y = sHelperPoint.y;
            _arg2.width = (_arg2.height = 0);
            return (_arg2);
        }

        public function advanceTime(_arg1:Number):void
        {
            var _local3:Particle;
            var _local5:uint;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            var _local10:Number;
            var _local11:Number;
            var _local15:Particle;
            var _local16:Number;
            var _local17:int;
            var _local18:Number;
            var _local19:Number;
            var _local20:Number;
            var _local21:Number;
            var _local22:Number;
            var _local23:Number;
            var _local2:int;
            while (_local2 < this.mNumParticles)
            {
                _local3 = (this.mParticles[_local2] as Particle);
                if (_local3.currentTime < _local3.totalTime)
                {
                    this.advanceParticle(_local3, _arg1);
                    _local2++;
                }
                else
                {
                    if (_local2 != (this.mNumParticles - 1))
                    {
                        _local15 = (this.mParticles[int((this.mNumParticles - 1))] as Particle);
                        this.mParticles[int((this.mNumParticles - 1))] = _local3;
                        this.mParticles[_local2] = _local15;
                    };
                    this.mNumParticles--;
                    if ((((this.mNumParticles == 0)) && ((this.mEmissionTime == 0))))
                    {
                        dispatchEvent(new Event(Event.COMPLETE));
                    };
                };
            };
            if (this.mEmissionTime > 0)
            {
                _local16 = (1 / this.mEmissionRate);
                this.mFrameTime = (this.mFrameTime + _arg1);
                while (this.mFrameTime > 0)
                {
                    if (this.mNumParticles < this.mMaxCapacity)
                    {
                        if (this.mNumParticles == this.capacity)
                        {
                            this.raiseCapacity(this.capacity);
                        };
                        _local3 = (this.mParticles[this.mNumParticles] as Particle);
                        this.initParticle(_local3);
                        if (_local3.totalTime > 0)
                        {
                            this.advanceParticle(_local3, this.mFrameTime);
                            this.mNumParticles++;
                        };
                    };
                    this.mFrameTime = (this.mFrameTime - _local16);
                };
                if (this.mEmissionTime != Number.MAX_VALUE)
                {
                    this.mEmissionTime = Math.max(0, (this.mEmissionTime - _arg1));
                };
            };
            var _local4:int;
            var _local12:Number = this.mTexture.width;
            var _local13:Number = this.mTexture.height;
            var _local14:int;
            while (_local14 < this.mNumParticles)
            {
                _local4 = (_local14 << 2);
                _local3 = (this.mParticles[_local14] as Particle);
                _local5 = _local3.color;
                _local6 = _local3.alpha;
                _local7 = _local3.rotation;
                _local8 = _local3.x;
                _local9 = _local3.y;
                _local10 = ((_local12 * _local3.scale) >> 1);
                _local11 = ((_local13 * _local3.scale) >> 1);
                _local17 = 0;
                while (_local17 < 4)
                {
                    this.mVertexData.setColorAndAlpha((_local4 + _local17), _local5, _local6);
                    _local17++;
                };
                if (_local7)
                {
                    _local18 = Math.cos(_local7);
                    _local19 = Math.sin(_local7);
                    _local20 = (_local18 * _local10);
                    _local21 = (_local18 * _local11);
                    _local22 = (_local19 * _local10);
                    _local23 = (_local19 * _local11);
                    this.mVertexData.setPosition(_local4, ((_local8 - _local20) + _local23), ((_local9 - _local22) - _local21));
                    this.mVertexData.setPosition((_local4 + 1), ((_local8 + _local20) + _local23), ((_local9 + _local22) - _local21));
                    this.mVertexData.setPosition((_local4 + 2), ((_local8 - _local20) - _local23), ((_local9 - _local22) + _local21));
                    this.mVertexData.setPosition((_local4 + 3), ((_local8 + _local20) - _local23), ((_local9 + _local22) + _local21));
                }
                else
                {
                    this.mVertexData.setPosition(_local4, (_local8 - _local10), (_local9 - _local11));
                    this.mVertexData.setPosition((_local4 + 1), (_local8 + _local10), (_local9 - _local11));
                    this.mVertexData.setPosition((_local4 + 2), (_local8 - _local10), (_local9 + _local11));
                    this.mVertexData.setPosition((_local4 + 3), (_local8 + _local10), (_local9 + _local11));
                };
                _local14++;
            };
        }

        override public function render(_arg1:RenderSupport, _arg2:Number):void
        {
            if (this.mNumParticles == 0)
            {
                return;
            };
            _arg1.finishQuadBatch();
            if (_arg1.hasOwnProperty("raiseDrawCount"))
            {
                _arg1.raiseDrawCount();
            };
            _arg2 = (_arg2 * this.alpha);
            var _local3:Context3D = Starling.context;
            var _local4:Boolean = this.texture.premultipliedAlpha;
            sRenderAlpha[0] = (sRenderAlpha[1] = (sRenderAlpha[2] = ((_local4) ? _arg2 : 1)));
            sRenderAlpha[3] = _arg2;
            if (_local3 == null)
            {
                throw (new MissingContextError());
            };
            this.mVertexBuffer.uploadFromVector(this.mVertexData.rawData, 0, (this.mNumParticles * 4));
            this.mIndexBuffer.uploadFromVector(this.mIndices, 0, (this.mNumParticles * 6));
            _local3.setBlendFactors(this.mBlendFactorSource, this.mBlendFactorDestination);
            _local3.setTextureAt(0, this.mTexture.base);
            _local3.setProgram(this.mProgram);
            _local3.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _arg1.mvpMatrix3D, true);
            _local3.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, sRenderAlpha, 1);
            _local3.setVertexBufferAt(0, this.mVertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2);
            _local3.setVertexBufferAt(1, this.mVertexBuffer, VertexData.COLOR_OFFSET, Context3DVertexBufferFormat.FLOAT_4);
            _local3.setVertexBufferAt(2, this.mVertexBuffer, VertexData.TEXCOORD_OFFSET, Context3DVertexBufferFormat.FLOAT_2);
            _local3.drawTriangles(this.mIndexBuffer, 0, (this.mNumParticles * 2));
            _local3.setTextureAt(0, null);
            _local3.setVertexBufferAt(0, null);
            _local3.setVertexBufferAt(1, null);
            _local3.setVertexBufferAt(2, null);
        }

        public function populate(_arg1:int):void
        {
            var _local2:Particle;
            _arg1 = Math.min(_arg1, (this.mMaxCapacity - this.mNumParticles));
            if ((this.mNumParticles + _arg1) > this.capacity)
            {
                this.raiseCapacity(((this.mNumParticles + _arg1) - this.capacity));
            };
            var _local3:int;
            while (_local3 < _arg1)
            {
                _local2 = this.mParticles[(this.mNumParticles + _local3)];
                this.initParticle(_local2);
                this.advanceParticle(_local2, (Math.random() * _local2.totalTime));
                _local3++;
            };
            this.mNumParticles = (this.mNumParticles + _arg1);
        }

        private function createProgram():void
        {
            var _local4:String;
            var _local5:String;
            var _local6:String;
            var _local7:AGALMiniAssembler;
            var _local1:Boolean = this.mTexture.mipMapping;
            var _local2:String = this.mTexture.format;
            var _local3:String = (((("ext.ParticleSystem." + _local2) + "/") + this.mSmoothing.charAt(0)) + ((_local1) ? "+mm" : ""));
            this.mProgram = Starling.current.getProgram(_local3);
            if (this.mProgram == null)
            {
                _local4 = RenderSupport.getTextureLookupFlags(_local2, _local1, false, this.mSmoothing);
                _local5 = (("m44 op, va0, vc0 \n" + "mul v0, va1, vc4 \n") + "mov v1, va2      \n");
                _local6 = ((("tex ft1, v1, fs0 " + _local4) + "\n") + "mul oc, ft1, v0");
                _local7 = new AGALMiniAssembler();
                Starling.current.registerProgram(_local3, _local7.assemble(Context3DProgramType.VERTEX, _local5), _local7.assemble(Context3DProgramType.FRAGMENT, _local6));
                this.mProgram = Starling.current.getProgram(_local3);
            };
        }

        public function get isEmitting():Boolean
        {
            return ((((this.mEmissionTime > 0)) && ((this.mEmissionRate > 0))));
        }

        public function get capacity():int
        {
            return ((this.mVertexData.numVertices / 4));
        }

        public function get numParticles():int
        {
            return (this.mNumParticles);
        }

        public function get maxCapacity():int
        {
            return (this.mMaxCapacity);
        }

        public function set maxCapacity(_arg1:int):void
        {
            this.mMaxCapacity = Math.min(MAX_NUM_PARTICLES, _arg1);
        }

        public function get emissionRate():Number
        {
            return (this.mEmissionRate);
        }

        public function set emissionRate(_arg1:Number):void
        {
            this.mEmissionRate = _arg1;
        }

        public function get emitterX():Number
        {
            return (this.mEmitterX);
        }

        public function set emitterX(_arg1:Number):void
        {
            this.mEmitterX = _arg1;
        }

        public function get emitterY():Number
        {
            return (this.mEmitterY);
        }

        public function set emitterY(_arg1:Number):void
        {
            this.mEmitterY = _arg1;
        }

        public function get blendFactorSource():String
        {
            return (this.mBlendFactorSource);
        }

        public function set blendFactorSource(_arg1:String):void
        {
            this.mBlendFactorSource = _arg1;
        }

        public function get blendFactorDestination():String
        {
            return (this.mBlendFactorDestination);
        }

        public function set blendFactorDestination(_arg1:String):void
        {
            this.mBlendFactorDestination = _arg1;
        }

        public function get texture():Texture
        {
            return (this.mTexture);
        }

        public function set texture(_arg1:Texture):void
        {
            this.mTexture = _arg1;
            this.createProgram();
        }

        public function get smoothing():String
        {
            return (this.mSmoothing);
        }

        public function set smoothing(_arg1:String):void
        {
            this.mSmoothing = _arg1;
        }


    }
}//package starling.extensions
