
package starling.extensions
{
    import starling.textures.Texture;
    import flash.display3D.Context3DBlendFactor;
    import starling.utils.deg2rad;

    public class PDParticleSystem extends ParticleSystem 
    {

        private const EMITTER_TYPE_GRAVITY:int = 0;
        private const EMITTER_TYPE_RADIAL:int = 1;

        private var mEmitterType:int;
        private var mEmitterXVariance:Number;
        private var mEmitterYVariance:Number;
        private var mMaxNumParticles:int;
        private var mLifespan:Number;
        private var mLifespanVariance:Number;
        private var mStartSize:Number;
        private var mStartSizeVariance:Number;
        private var mEndSize:Number;
        private var mEndSizeVariance:Number;
        private var mEmitAngle:Number;
        private var mEmitAngleVariance:Number;
        private var mStartRotation:Number;
        private var mStartRotationVariance:Number;
        private var mEndRotation:Number;
        private var mEndRotationVariance:Number;
        private var mSpeed:Number;
        private var mSpeedVariance:Number;
        private var mGravityX:Number;
        private var mGravityY:Number;
        private var mRadialAcceleration:Number;
        private var mRadialAccelerationVariance:Number;
        private var mTangentialAcceleration:Number;
        private var mTangentialAccelerationVariance:Number;
        private var mMaxRadius:Number;
        private var mMaxRadiusVariance:Number;
        private var mMinRadius:Number;
        private var mRotatePerSecond:Number;
        private var mRotatePerSecondVariance:Number;
        private var mStartColor:ColorArgb;
        private var mStartColorVariance:ColorArgb;
        private var mEndColor:ColorArgb;
        private var mEndColorVariance:ColorArgb;
        public var tag:int;

        public function PDParticleSystem(_arg1:XML, _arg2:Texture)
        {
            this.parseConfig(_arg1);
            var _local3:Number = (this.mMaxNumParticles / this.mLifespan);
            super(_arg2, _local3, this.mMaxNumParticles, this.mMaxNumParticles, mBlendFactorSource, mBlendFactorDestination);
            mPremultipliedAlpha = false;
        }

        override protected function createParticle():Particle
        {
            return (new PDParticle());
        }

        override protected function initParticle(_arg1:Particle):void
        {
            var _local8:ColorArgb;
            var _local9:ColorArgb;
            var _local2:PDParticle = (_arg1 as PDParticle);
            var _local3:Number = (this.mLifespan + (this.mLifespanVariance * ((Math.random() * 2) - 1)));
            _local2.currentTime = 0;
            _local2.totalTime = (((_local3 > 0)) ? _local3 : 0);
            if (_local3 <= 0)
            {
                return;
            };
            _local2.x = (mEmitterX + (this.mEmitterXVariance * ((Math.random() * 2) - 1)));
            _local2.y = (mEmitterY + (this.mEmitterYVariance * ((Math.random() * 2) - 1)));
            _local2.startX = mEmitterX;
            _local2.startY = mEmitterY;
            var _local4:Number = (this.mEmitAngle + (this.mEmitAngleVariance * ((Math.random() * 2) - 1)));
            var _local5:Number = (this.mSpeed + (this.mSpeedVariance * ((Math.random() * 2) - 1)));
            _local2.velocityX = (_local5 * Math.cos(_local4));
            _local2.velocityY = (_local5 * Math.sin(_local4));
            _local2.emitRadius = (this.mMaxRadius + (this.mMaxRadiusVariance * ((Math.random() * 2) - 1)));
            _local2.emitRadiusDelta = ((this.mMaxRadius - this.mMinRadius) / _local3);
            _local2.emitRotation = (this.mEmitAngle + (this.mEmitAngleVariance * ((Math.random() * 2) - 1)));
            _local2.emitRotationDelta = (this.mRotatePerSecond + (this.mRotatePerSecondVariance * ((Math.random() * 2) - 1)));
            _local2.radialAcceleration = (this.mRadialAcceleration + (this.mRadialAccelerationVariance * ((Math.random() * 2) - 1)));
            _local2.tangentialAcceleration = (this.mTangentialAcceleration + (this.mTangentialAccelerationVariance * ((Math.random() * 2) - 1)));
            var _local6:Number = (this.mStartSize + (this.mStartSizeVariance * ((Math.random() * 2) - 1)));
            var _local7:Number = (this.mEndSize + (this.mEndSizeVariance * ((Math.random() * 2) - 1)));
            if (_local6 < 0.1)
            {
                _local6 = 0.1;
            };
            if (_local7 < 0.1)
            {
                _local7 = 0.1;
            };
            _local2.scale = (_local6 / texture.width);
            _local2.scaleDelta = (((_local7 - _local6) / _local3) / texture.width);
            _local8 = _local2.colorArgb;
            _local9 = _local2.colorArgbDelta;
            _local8.red = this.mStartColor.red;
            _local8.green = this.mStartColor.green;
            _local8.blue = this.mStartColor.blue;
            _local8.alpha = this.mStartColor.alpha;
            if (this.mStartColorVariance.red != 0)
            {
                _local8.red = (_local8.red + (this.mStartColorVariance.red * ((Math.random() * 2) - 1)));
            };
            if (this.mStartColorVariance.green != 0)
            {
                _local8.green = (_local8.green + (this.mStartColorVariance.green * ((Math.random() * 2) - 1)));
            };
            if (this.mStartColorVariance.blue != 0)
            {
                _local8.blue = (_local8.blue + (this.mStartColorVariance.blue * ((Math.random() * 2) - 1)));
            };
            if (this.mStartColorVariance.alpha != 0)
            {
                _local8.alpha = (_local8.alpha + (this.mStartColorVariance.alpha * ((Math.random() * 2) - 1)));
            };
            var _local10:Number = this.mEndColor.red;
            var _local11:Number = this.mEndColor.green;
            var _local12:Number = this.mEndColor.blue;
            var _local13:Number = this.mEndColor.alpha;
            if (this.mEndColorVariance.red != 0)
            {
                _local10 = (_local10 + (this.mEndColorVariance.red * ((Math.random() * 2) - 1)));
            };
            if (this.mEndColorVariance.green != 0)
            {
                _local11 = (_local11 + (this.mEndColorVariance.green * ((Math.random() * 2) - 1)));
            };
            if (this.mEndColorVariance.blue != 0)
            {
                _local12 = (_local12 + (this.mEndColorVariance.blue * ((Math.random() * 2) - 1)));
            };
            if (this.mEndColorVariance.alpha != 0)
            {
                _local13 = (_local13 + (this.mEndColorVariance.alpha * ((Math.random() * 2) - 1)));
            };
            _local9.red = ((_local10 - _local8.red) / _local3);
            _local9.green = ((_local11 - _local8.green) / _local3);
            _local9.blue = ((_local12 - _local8.blue) / _local3);
            _local9.alpha = ((_local13 - _local8.alpha) / _local3);
            var _local14:Number = (this.mStartRotation + (this.mStartRotationVariance * ((Math.random() * 2) - 1)));
            var _local15:Number = (this.mEndRotation + (this.mEndRotationVariance * ((Math.random() * 2) - 1)));
            _local2.rotation = _local14;
            _local2.rotationDelta = ((_local15 - _local14) / _local3);
        }

        override protected function advanceParticle(_arg1:Particle, _arg2:Number):void
        {
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            var _local10:Number;
            var _local11:Number;
            var _local12:Number;
            var _local3:PDParticle = (_arg1 as PDParticle);
            var _local4:Number = (_local3.totalTime - _local3.currentTime);
            _arg2 = (((_local4 > _arg2)) ? _arg2 : _local4);
            _local3.currentTime = (_local3.currentTime + _arg2);
            if (this.mEmitterType == this.EMITTER_TYPE_RADIAL)
            {
                _local3.emitRotation = (_local3.emitRotation + (_local3.emitRotationDelta * _arg2));
                _local3.emitRadius = (_local3.emitRadius - (_local3.emitRadiusDelta * _arg2));
                _local3.x = (mEmitterX - (Math.cos(_local3.emitRotation) * _local3.emitRadius));
                _local3.y = (mEmitterY - (Math.sin(_local3.emitRotation) * _local3.emitRadius));
                if (_local3.emitRadius < this.mMinRadius)
                {
                    _local3.currentTime = _local3.totalTime;
                };
            }
            else
            {
                _local5 = (_local3.x - _local3.startX);
                _local6 = (_local3.y - _local3.startY);
                _local7 = Math.sqrt(((_local5 * _local5) + (_local6 * _local6)));
                if (_local7 < 0.01)
                {
                    _local7 = 0.01;
                };
                _local8 = (_local5 / _local7);
                _local9 = (_local6 / _local7);
                _local10 = _local8;
                _local11 = _local9;
                _local8 = (_local8 * _local3.radialAcceleration);
                _local9 = (_local9 * _local3.radialAcceleration);
                _local12 = _local10;
                _local10 = (-(_local11) * _local3.tangentialAcceleration);
                _local11 = (_local12 * _local3.tangentialAcceleration);
                _local3.velocityX = (_local3.velocityX + (_arg2 * ((this.mGravityX + _local8) + _local10)));
                _local3.velocityY = (_local3.velocityY + (_arg2 * ((this.mGravityY + _local9) + _local11)));
                _local3.x = (_local3.x + (_local3.velocityX * _arg2));
                _local3.y = (_local3.y + (_local3.velocityY * _arg2));
            };
            _local3.scale = (_local3.scale + (_local3.scaleDelta * _arg2));
            _local3.rotation = (_local3.rotation + (_local3.rotationDelta * _arg2));
            _local3.colorArgb.red = (_local3.colorArgb.red + (_local3.colorArgbDelta.red * _arg2));
            _local3.colorArgb.green = (_local3.colorArgb.green + (_local3.colorArgbDelta.green * _arg2));
            _local3.colorArgb.blue = (_local3.colorArgb.blue + (_local3.colorArgbDelta.blue * _arg2));
            _local3.colorArgb.alpha = (_local3.colorArgb.alpha + (_local3.colorArgbDelta.alpha * _arg2));
            _local3.color = _local3.colorArgb.toRgb();
            _local3.alpha = _local3.colorArgb.alpha;
        }

        private function updateEmissionRate():void
        {
            emissionRate = (this.mMaxNumParticles / this.mLifespan);
        }

        private function parseConfig(config:XML):void
        {
            var getIntValue:Function = function (_arg1:XMLList):int
            {
                return (parseInt(_arg1.attribute("value")));
            };
            var getFloatValue:Function = function (_arg1:XMLList):Number
            {
                return (parseFloat(_arg1.attribute("value")));
            };
            var getColor:Function = function (_arg1:XMLList):ColorArgb
            {
                var _local2:ColorArgb = new ColorArgb();
                _local2.red = parseFloat(_arg1.attribute("red"));
                _local2.green = parseFloat(_arg1.attribute("green"));
                _local2.blue = parseFloat(_arg1.attribute("blue"));
                _local2.alpha = parseFloat(_arg1.attribute("alpha"));
                return (_local2);
            };
            var getBlendFunc:Function = function (_arg1:XMLList):String
            {
                var _local2:int = getIntValue(_arg1);
                switch (_local2)
                {
                    case 0:
                        return (Context3DBlendFactor.ZERO);
                    case 1:
                        return (Context3DBlendFactor.ONE);
                    case 0x0300:
                        return (Context3DBlendFactor.SOURCE_COLOR);
                    case 769:
                        return (Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
                    case 770:
                        return (Context3DBlendFactor.SOURCE_ALPHA);
                    case 0x0303:
                        return (Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                    case 772:
                        return (Context3DBlendFactor.DESTINATION_ALPHA);
                    case 773:
                        return (Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA);
                    case 774:
                        return (Context3DBlendFactor.DESTINATION_COLOR);
                    case 775:
                        return (Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR);
                    default:
                        throw (new ArgumentError(("unsupported blending function: " + _local2)));
                };
            };
            this.mEmitterXVariance = parseFloat(config.sourcePositionVariance.attribute("x"));
            this.mEmitterYVariance = parseFloat(config.sourcePositionVariance.attribute("y"));
            this.mGravityX = parseFloat(config.gravity.attribute("x"));
            this.mGravityY = parseFloat(config.gravity.attribute("y"));
            this.mEmitterType = getIntValue(config.emitterType);
            this.mMaxNumParticles = getIntValue(config.maxParticles);
            this.mLifespan = Math.max(0.01, getFloatValue(config.particleLifeSpan));
            this.mLifespanVariance = getFloatValue(config.particleLifespanVariance);
            this.mStartSize = getFloatValue(config.startParticleSize);
            this.mStartSizeVariance = getFloatValue(config.startParticleSizeVariance);
            this.mEndSize = getFloatValue(config.finishParticleSize);
            this.mEndSizeVariance = getFloatValue(config.FinishParticleSizeVariance);
            this.mEmitAngle = deg2rad(getFloatValue(config.angle));
            this.mEmitAngleVariance = deg2rad(getFloatValue(config.angleVariance));
            this.mStartRotation = deg2rad(getFloatValue(config.rotationStart));
            this.mStartRotationVariance = deg2rad(getFloatValue(config.rotationStartVariance));
            this.mEndRotation = deg2rad(getFloatValue(config.rotationEnd));
            this.mEndRotationVariance = deg2rad(getFloatValue(config.rotationEndVariance));
            this.mSpeed = getFloatValue(config.speed);
            this.mSpeedVariance = getFloatValue(config.speedVariance);
            this.mRadialAcceleration = getFloatValue(config.radialAcceleration);
            this.mRadialAccelerationVariance = getFloatValue(config.radialAccelVariance);
            this.mTangentialAcceleration = getFloatValue(config.tangentialAcceleration);
            this.mTangentialAccelerationVariance = getFloatValue(config.tangentialAccelVariance);
            this.mMaxRadius = getFloatValue(config.maxRadius);
            this.mMaxRadiusVariance = getFloatValue(config.maxRadiusVariance);
            this.mMinRadius = getFloatValue(config.minRadius);
            this.mRotatePerSecond = deg2rad(getFloatValue(config.rotatePerSecond));
            this.mRotatePerSecondVariance = deg2rad(getFloatValue(config.rotatePerSecondVariance));
            this.mStartColor = getColor(config.startColor);
            this.mStartColorVariance = getColor(config.startColorVariance);
            this.mEndColor = getColor(config.finishColor);
            this.mEndColorVariance = getColor(config.finishColorVariance);
            mBlendFactorSource = getBlendFunc(config.blendFuncSource);
            mBlendFactorDestination = getBlendFunc(config.blendFuncDestination);
            if (isNaN(this.mEndSizeVariance))
            {
                this.mEndSizeVariance = getFloatValue(config.finishParticleSizeVariance);
            };
            if (isNaN(this.mLifespan))
            {
                this.mLifespan = Math.max(0.01, getFloatValue(config.particleLifespan));
            };
            if (isNaN(this.mLifespanVariance))
            {
                this.mLifespanVariance = getFloatValue(config.particleLifeSpanVariance);
            };
        }

        public function get emitterType():int
        {
            return (this.mEmitterType);
        }

        public function set emitterType(_arg1:int):void
        {
            this.mEmitterType = _arg1;
        }

        public function get emitterXVariance():Number
        {
            return (this.mEmitterXVariance);
        }

        public function set emitterXVariance(_arg1:Number):void
        {
            this.mEmitterXVariance = _arg1;
        }

        public function get emitterYVariance():Number
        {
            return (this.mEmitterYVariance);
        }

        public function set emitterYVariance(_arg1:Number):void
        {
            this.mEmitterYVariance = _arg1;
        }

        public function get maxNumParticles():int
        {
            return (this.mMaxNumParticles);
        }

        public function set maxNumParticles(_arg1:int):void
        {
            maxCapacity = _arg1;
            this.mMaxNumParticles = maxCapacity;
            this.updateEmissionRate();
        }

        public function get lifespan():Number
        {
            return (this.mLifespan);
        }

        public function set lifespan(_arg1:Number):void
        {
            this.mLifespan = Math.max(0.01, _arg1);
            this.updateEmissionRate();
        }

        public function get lifespanVariance():Number
        {
            return (this.mLifespanVariance);
        }

        public function set lifespanVariance(_arg1:Number):void
        {
            this.mLifespanVariance = _arg1;
        }

        public function get startSize():Number
        {
            return (this.mStartSize);
        }

        public function set startSize(_arg1:Number):void
        {
            this.mStartSize = _arg1;
        }

        public function get startSizeVariance():Number
        {
            return (this.mStartSizeVariance);
        }

        public function set startSizeVariance(_arg1:Number):void
        {
            this.mStartSizeVariance = _arg1;
        }

        public function get endSize():Number
        {
            return (this.mEndSize);
        }

        public function set endSize(_arg1:Number):void
        {
            this.mEndSize = _arg1;
        }

        public function get endSizeVariance():Number
        {
            return (this.mEndSizeVariance);
        }

        public function set endSizeVariance(_arg1:Number):void
        {
            this.mEndSizeVariance = _arg1;
        }

        public function get emitAngle():Number
        {
            return (this.mEmitAngle);
        }

        public function set emitAngle(_arg1:Number):void
        {
            this.mEmitAngle = _arg1;
        }

        public function get emitAngleVariance():Number
        {
            return (this.mEmitAngleVariance);
        }

        public function set emitAngleVariance(_arg1:Number):void
        {
            this.mEmitAngleVariance = _arg1;
        }

        public function get startRotation():Number
        {
            return (this.mStartRotation);
        }

        public function set startRotation(_arg1:Number):void
        {
            this.mStartRotation = _arg1;
        }

        public function get startRotationVariance():Number
        {
            return (this.mStartRotationVariance);
        }

        public function set startRotationVariance(_arg1:Number):void
        {
            this.mStartRotationVariance = _arg1;
        }

        public function get endRotation():Number
        {
            return (this.mEndRotation);
        }

        public function set endRotation(_arg1:Number):void
        {
            this.mEndRotation = _arg1;
        }

        public function get endRotationVariance():Number
        {
            return (this.mEndRotationVariance);
        }

        public function set endRotationVariance(_arg1:Number):void
        {
            this.mEndRotationVariance = _arg1;
        }

        public function get speed():Number
        {
            return (this.mSpeed);
        }

        public function set speed(_arg1:Number):void
        {
            this.mSpeed = _arg1;
        }

        public function get speedVariance():Number
        {
            return (this.mSpeedVariance);
        }

        public function set speedVariance(_arg1:Number):void
        {
            this.mSpeedVariance = _arg1;
        }

        public function get gravityX():Number
        {
            return (this.mGravityX);
        }

        public function set gravityX(_arg1:Number):void
        {
            this.mGravityX = _arg1;
        }

        public function get gravityY():Number
        {
            return (this.mGravityY);
        }

        public function set gravityY(_arg1:Number):void
        {
            this.mGravityY = _arg1;
        }

        public function get radialAcceleration():Number
        {
            return (this.mRadialAcceleration);
        }

        public function set radialAcceleration(_arg1:Number):void
        {
            this.mRadialAcceleration = _arg1;
        }

        public function get radialAccelerationVariance():Number
        {
            return (this.mRadialAccelerationVariance);
        }

        public function set radialAccelerationVariance(_arg1:Number):void
        {
            this.mRadialAccelerationVariance = _arg1;
        }

        public function get tangentialAcceleration():Number
        {
            return (this.mTangentialAcceleration);
        }

        public function set tangentialAcceleration(_arg1:Number):void
        {
            this.mTangentialAcceleration = _arg1;
        }

        public function get tangentialAccelerationVariance():Number
        {
            return (this.mTangentialAccelerationVariance);
        }

        public function set tangentialAccelerationVariance(_arg1:Number):void
        {
            this.mTangentialAccelerationVariance = _arg1;
        }

        public function get maxRadius():Number
        {
            return (this.mMaxRadius);
        }

        public function set maxRadius(_arg1:Number):void
        {
            this.mMaxRadius = _arg1;
        }

        public function get maxRadiusVariance():Number
        {
            return (this.mMaxRadiusVariance);
        }

        public function set maxRadiusVariance(_arg1:Number):void
        {
            this.mMaxRadiusVariance = _arg1;
        }

        public function get minRadius():Number
        {
            return (this.mMinRadius);
        }

        public function set minRadius(_arg1:Number):void
        {
            this.mMinRadius = _arg1;
        }

        public function get rotatePerSecond():Number
        {
            return (this.mRotatePerSecond);
        }

        public function set rotatePerSecond(_arg1:Number):void
        {
            this.mRotatePerSecond = _arg1;
        }

        public function get rotatePerSecondVariance():Number
        {
            return (this.mRotatePerSecondVariance);
        }

        public function set rotatePerSecondVariance(_arg1:Number):void
        {
            this.mRotatePerSecondVariance = _arg1;
        }

        public function get startColor():ColorArgb
        {
            return (this.mStartColor);
        }

        public function set startColor(_arg1:ColorArgb):void
        {
            this.mStartColor = _arg1;
        }

        public function get startColorVariance():ColorArgb
        {
            return (this.mStartColorVariance);
        }

        public function set startColorVariance(_arg1:ColorArgb):void
        {
            this.mStartColorVariance = _arg1;
        }

        public function get endColor():ColorArgb
        {
            return (this.mEndColor);
        }

        public function set endColor(_arg1:ColorArgb):void
        {
            this.mEndColor = _arg1;
        }

        public function get endColorVariance():ColorArgb
        {
            return (this.mEndColorVariance);
        }

        public function set endColorVariance(_arg1:ColorArgb):void
        {
            this.mEndColorVariance = _arg1;
        }


    }
}//package starling.extensions
