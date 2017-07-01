
package starling.extensions
{
    public class Particle 
    {

        public var x:Number;
        public var y:Number;
        public var scale:Number;
        public var rotation:Number;
        public var color:uint;
        public var alpha:Number;
        public var currentTime:Number;
        public var totalTime:Number;

        public function Particle()
        {
            this.x = (this.y = (this.rotation = (this.currentTime = 0)));
            this.totalTime = (this.alpha = (this.scale = 1));
            this.color = 0xFFFFFF;
        }

    }
}//package starling.extensions
