
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import starling.textures.Texture;
    import com.popchan.sugar.core.data.TileConst;
    import com.popchan.framework.core.Core;

    public class Brick extends Element 
    {

        public static var pool:BasePool = new BasePool(Brick, 50);

        private var _brickID:int;
        private var img:Image;
        private var _life:int;
        public var row:int;
        public var col:int;


		public function Brick()
		{
			img = new Image(Core.texturesManager.getTexture("brick1"));
		}
		
        public function get life():int
        {
            return (_life);
        }

        public function get brickID():int
        {
            return (_brickID);
        }

        public function set brickID(id:int):void
        {
            var _local2:Texture;
            _brickID = id;
            if (id == TileConst.BRICK)
            {
                img.texture = Core.texturesManager.getTexture("brick1");
                _life = 1;
            }
            else if (id == TileConst.BRICK2)
            {
                
                img.texture =  Texture.fromTexture(Core.texturesManager.getTexture("brick2"));;
                _life = 2;
            }
            addChild(img);
            img.pivotX = (img.width >> 1);
            img.pivotY = (img.height >> 1);
        }

        public function loseLife():void
        {
            var _local2:BrickExp;
            var _local1:int = -1;
            if (col >= 4)
            {
                _local1 = 1;
            }
            if (_life == 2)
            {
                img.texture = Texture.fromTexture(Core.texturesManager.getTexture("brick1"));
                _local2 = (BrickExp.pool.take() as BrickExp);
                _local2.setInfo(2, _local1);
                _local2.x = x;
                _local2.y = y;
                parent.parent.addChild(_local2);
            }
            else if (_life == 1)
			{
				_local2 = (BrickExp.pool.take() as BrickExp);
				_local2.setInfo(1, _local1);
				_local2.x = x;
				_local2.y = y;
				parent.parent.addChild(_local2);
			}
            _life = (_life - 1);
        }
    }
}