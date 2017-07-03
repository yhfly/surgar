
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.core.Core;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.framework.ds.BasePool;
    import com.popchan.framework.manager.Debug;
    import com.popchan.framework.manager.SoundManager;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.sugar.core.Model;
    import com.popchan.sugar.core.cfg.Config;
    import com.popchan.sugar.core.cfg.levels.LevelCO;
    import com.popchan.sugar.core.data.AimType;
    import com.popchan.sugar.core.data.CandySpecialStatus;
    import com.popchan.sugar.core.data.ColorType;
    import com.popchan.sugar.core.data.GameConst;
    import com.popchan.sugar.core.data.GameMode;
    import com.popchan.sugar.core.data.TileConst;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.modules.BasePanel3D;
    import com.popchan.sugar.modules.guide.GuideManager;
    import com.popchan.sugar.modules.guide.GuideVO;
    import com.popchan.sugar.modules.guide.IGuide;
    import com.popchan.sugar.modules.map.view.LevelItem;
    
    import flash.geom.Point;
    import flash.utils.getTimer;
    import flash.utils.setTimeout;
    
    import caurina.transitions.Tweener;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import com.popchan.sugar.modules.game.view.effect.BombEffect;
    import com.popchan.sugar.modules.game.view.effect.BombNormalEffect;
    import com.popchan.sugar.modules.game.view.effect.LaserEffect;
    import com.popchan.sugar.modules.game.view.effect.LineBombEffect;
    import com.popchan.sugar.modules.game.view.candyElement.Brick;
    import com.popchan.sugar.modules.game.view.candyElement.Candy;
    import com.popchan.sugar.modules.game.view.candyElement.Eat;
    import com.popchan.sugar.modules.game.view.candyElement.Ice;
    import com.popchan.sugar.modules.game.view.candyElement.Monster;
    import com.popchan.sugar.modules.game.view.candyElement.Stone;

    public class GamePanel extends BasePanel3D implements IGuide 
    {

        private static const STATE_INIT:int = 1;
        private static const STATE_GAME:int = 2;
        private static const STATE_PAUSE:int = 3;
        private static const STATE_END:int = 4;
        private static const STATE_WAIT:int = 5;
        private static const STATE_GAME_WAIT:int = 1;
        private static const STATE_GAME_SWAP:int = 2;
        private static const STATE_GAME_REMOVE:int = 3;
        private static const STATE_GAME_WAIT_DROP:int = 4;
        private static const STATE_GAME_CHECK_DROP_COMPLETE:int = 5;
        private static const STATE_GAME_SHUFFLE:int = 6;
        private static const STATE_GAME_END:int = 7;
        private static const STATE_END_VICTORY:int = 1;
        private static const STATE_END_FAILED:int = 2;
        private static const DROP_DELAY:int = 15;

        public var currentLevel:LevelCO;
        private var offsetX:int = 0;
        private var offsetY:int = 0;
        private var contentW:int;
        private var contentH:int;
        public var tileBgs:Array;
        public var tileBoarders:Array;
        public var candys:Array;
        public var bricks:Array;
        public var locks:Array;
        public var ices:Array;
        public var eats:Array;
        public var monsters:Array;
        public var stones:Array;
        public var tDoors:Array;
        public var ironWires:Array;
        private var container:Sprite;
        private var candy_layer:Sprite;
        private var tileBg_layer:Sprite;
        private var door_layer:Sprite;
        private var brick_layer:Sprite;
        private var ice_layer:Sprite;
        private var stone_layer:Sprite;
        private var lock_layer:Sprite;
        private var eat_layer:Sprite;
        private var monster_layer:Sprite;
        private var ironWire_layer:Sprite;
        public var selectedCard:Candy;
        public var aimCard:Candy;
        private var isMoving:Boolean;
        private var infoPanel:InfoPanel;
        private var addFruitIndex:int;
        private var nextFruitId:int;
        private var colAdd:Array;
        private var tDoorAdd:Array;
        private var eatRemoved:Boolean = false;
        private var state:int;
        private var gameState:int;
        private var dropCount:int = 0;
        private var tipCount:int = 0;
        private var tipDelay:int = 400;
        private var tempScore:int;
        private var matchCountOnceSwap:int = 0;
        private var _instanceName:String = "GamePanel";


        override public function init():void
        {
            super.init();
            var _local1:Image = ToolKit.createImage(this, Core.texturesManager.getTexture("worldBg_2"));
            container = new Sprite();
            addChild(container);
            tileBg_layer = new Sprite();
            container.addChild(tileBg_layer);
            brick_layer = new Sprite();
            container.addChild(brick_layer);
            ice_layer = new Sprite();
            container.addChild(ice_layer);
            stone_layer = new Sprite();
            container.addChild(stone_layer);
            eat_layer = new Sprite();
            container.addChild(eat_layer);
            candy_layer = new Sprite();
            container.addChild(candy_layer);
            lock_layer = new Sprite();
            container.addChild(lock_layer);
            monster_layer = new Sprite();
            container.addChild(monster_layer);
            ironWire_layer = new Sprite();
            container.addChild(ironWire_layer);
            door_layer = new Sprite();
            container.addChild(door_layer);
            infoPanel = new InfoPanel();
            addChild(infoPanel);
            tDoors = getBlankMapArray();
            tileBgs = getBlankMapArray();
            candys = getBlankMapArray();
            bricks = getBlankMapArray();
            ices = getBlankMapArray();
            stones = getBlankMapArray();
            eats = getBlankMapArray();
            locks = getBlankMapArray();
            ironWires = getBlankMapArray();
            monsters = getBlankMapArray();
            tileBoarders = [];
            newGame();
        }

        private function getBlankMapArray():Array
        {
            var j:int;
            var blankMapArray:Array = [];
            var i:int;
            while (i < GameConst.ROW_COUNT)
            {
                blankMapArray[i] = [];
                j = 0;
                while (j < GameConst.COL_COUNT)
                {
                    blankMapArray[i][j] = null;
                    j++;
                }
                i++;
            }
            return blankMapArray;
        }

        private function newGame():void
        {
            addEventListener(TouchEvent.TOUCH, onTouch);
            addEventListener(EnterFrameEvent.ENTER_FRAME, update);
            currentLevel = Config.levelConfig.getLevel(Model.levelModel.selectedLevel);
            infoPanel.setInfo(currentLevel);
            Model.gameModel.score = 0;
            state = STATE_INIT;
            gameState = STATE_GAME_WAIT;
			
			
//			var level:int = 1;
//			Model.levelModel.selectedLevel = level;
//			MsgDispatcher.execute(GameEvents.OPEN_GAME_UI);
        }

        private function createElements():void
        {
            createTileBg();
            createDoor();
            createBrick();
            createBarrier();
            createCandys();
            createIronWires();
            createBombs();
            container.x = 650;
            Tweener.addTween(container, {
                "time":0.6,
                "x":0,
                "delay":0.1,
                "transition":"easeBackOut"
            });
        }

		/**
		 * 创建炸弹 
		 */		
        private function createBombs():void
        {
            var j:int;
            var tileID:int;
			//障碍格子
            var barrierArr:Array = currentLevel.barrier;
            var i:int;
            while (i < GameConst.ROW_COUNT)
            {
                j = 0;
                while (j < GameConst.COL_COUNT)
                {
                    tileID = barrierArr[i][j];
                    if (tileID == TileConst.BOMB)
                    {
                        createBomb(i, j);
                    }
                    j++;
                }
                i++;
            }
        }

		/**
		 * 创建障碍 
		 * 
		 */		
        private function createBarrier():void
        {
            var j:int;
            var tileID:int;
            var barrierArr:Array = currentLevel.barrier;
            var i:int;
            while (i < GameConst.ROW_COUNT)
            {
                j = 0;
                while (j < GameConst.COL_COUNT)
                {
                    tileID = barrierArr[i][j];
                    if (tileID > 0)
                    {
                        switch (tileID)
                        {
                            case TileConst.ICE1:
                            case TileConst.ICE2:
                            case TileConst.ICE3:
                                createIce(i, j, tileID);
                                break;
                            case TileConst.LOCK:
                                createLock(i, j);
                                break;
                            case TileConst.STONE:
                                createStones(i, j, tileID);
                                break;
                            case TileConst.EAT:
                                createEat(i, j);
                                break;
                            case TileConst.MONSTER:
                                createMonster(i, j);
                                break;
                            case TileConst.IRONWIRE:
                                createIronWire(i, j, 1);
                                break;
                            case TileConst.IRONWIRE2:
                                createIronWire(i, j, 2);
                                break;
                            case TileConst.BOMB:
                                break;
                        }
                    }
                    j++;
                }
                i++;
            }
        }

        private function createTileBg():void
        {
            var _local6:int;
            var _local7:int;
            var _local8:*;
            var _local9:*;
            var _local10:*;
            var _local11:*;
            var _local14:int;
            var _local15:TileBg;
            var _local16:Point;
            var _local17:TileBoarder;
            var _local1:Array = currentLevel.tile;
            var _local2:int;
            var _local3:int = (GameConst.ROW_COUNT - 1);
            var _local4:int;
            var _local5:int = (GameConst.COL_COUNT - 1);
            _local7 = 0;
            _loop1:
            while (_local7 < GameConst.COL_COUNT)
            {
                _local6 = 0;
                while (_local6 < GameConst.ROW_COUNT)
                {
                    if (_local1[_local6][_local7] > 0)
                    {
                        _local4 = _local7;
                        break _loop1;
                    }
                    _local6++;
                }
                _local7++;
            }
            _local7 = (GameConst.COL_COUNT - 1);
            _loop2:
            while (_local7 >= 0)
            {
                _local6 = 0;
                while (_local6 < GameConst.ROW_COUNT)
                {
                    if (_local1[_local6][_local7] > 0)
                    {
                        _local5 = _local7;
                        break _loop2;
                    }
                    _local6++;
                }
                _local7--;
            }
            _local6 = 0;
            _loop3:
            while (_local6 < GameConst.ROW_COUNT)
            {
                _local7 = 0;
                while (_local7 < GameConst.COL_COUNT)
                {
                    if (_local1[_local6][_local7] > 0)
                    {
                        _local2 = _local6;
                        break _loop3;
                    }
                    _local7++;
                }
                _local6++;
            }
            _local6 = (GameConst.ROW_COUNT - 1);
            _loop4:
            while (_local6 >= 0)
            {
                _local7 = 0;
                while (_local7 < GameConst.COL_COUNT)
                {
                    if (_local1[_local6][_local7] > 0)
                    {
                        _local3 = _local6;
                        break _loop4;
                    }
                    _local7++;
                }
                _local6--;
            }
            var _local12:int = ((GameConst.ROW_COUNT - _local3) - _local2);
            var _local13:int = ((GameConst.COL_COUNT - _local5) - _local4);
            offsetX = (((Core.stage3DManager.canvasWidth - (GameConst.COL_COUNT * GameConst.CARD_W)) >> 1) + ((_local13 * GameConst.CARD_W) * 0.5));
            offsetY = (((((Core.stage3DManager.canvasHeight - 100) - (GameConst.ROW_COUNT * GameConst.CARD_W)) >> 1) + ((_local12 * GameConst.CARD_W) * 0.5)) + 100);
            _local6 = 0;
            while (_local6 < GameConst.ROW_COUNT)
            {
                _local7 = 0;
                while (_local7 < GameConst.COL_COUNT)
                {
                    _local14 = _local1[_local6][_local7];
                    if (_local14 > 0)
                    {
                        _local15 = (TileBg.pool.take() as TileBg);
                        _local16 = getCandyPosition(_local6, _local7);
                        _local15.x = _local16.x;
                        _local15.y = _local16.y;
                        tileBgs[_local6][_local7] = _local15;
                        tileBg_layer.addChild(_local15);
                        if (((((isBlank(_local6, (_local7 - 1))) && (isBlank((_local6 - 1), _local7)))) && (isBlank((_local6 - 1), (_local7 - 1)))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_left_up, tileBg_layer, (_local16.x - 38), (_local16.y - 38));
                            tileBoarders.push(_local17);
                        }
                        if (((!(isBlank((_local6 + 1), (_local7 - 1)))) && (isBlank((_local6 + 1), _local7))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_left_up_x, tileBg_layer, (_local16.x - 32), (_local16.y + 32));
                            tileBoarders.push(_local17);
                        }
                        if (((((isBlank(_local6, (_local7 + 1))) && (isBlank((_local6 - 1), _local7)))) && (isBlank((_local6 - 1), (_local7 + 1)))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_right_up, tileBg_layer, (_local16.x - 3), (_local16.y - 38));
                            tileBoarders.push(_local17);
                        }
                        if (((!(isBlank((_local6 + 1), (_local7 + 1)))) && (isBlank((_local6 + 1), _local7))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_right_up_x, tileBg_layer, (_local16.x - 4), (_local16.y + 32));
                            tileBoarders.push(_local17);
                        }
                        if (((((isBlank((_local6 - 1), _local7)) && (!(isBlank(_local6, (_local7 + 1)))))) && (isBlank((_local6 - 1), (_local7 + 1)))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_heng_xia, tileBg_layer, _local16.x, (_local16.y - 38));
                            tileBoarders.push(_local17);
                        }
                        if (((((isBlank(_local6, (_local7 - 1))) && (!(isBlank((_local6 + 1), _local7))))) && (isBlank((_local6 + 1), (_local7 - 1)))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_shu_you, tileBg_layer, (_local16.x - 38), _local16.y);
                            tileBoarders.push(_local17);
                        }
                        if (((((isBlank(_local6, (_local7 + 1))) && (!(isBlank((_local6 + 1), _local7))))) && (isBlank((_local6 + 1), (_local7 + 1)))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_shu_zuo, tileBg_layer, (_local16.x + 32), _local16.y);
                            tileBoarders.push(_local17);
                        }
                        if (((((isBlank(_local6, (_local7 - 1))) && (isBlank((_local6 + 1), _local7)))) && (isBlank((_local6 + 1), (_local7 - 1)))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_left_down, tileBg_layer, (_local16.x - 38), (_local16.y - 3));
                            tileBoarders.push(_local17);
                        }
                        if (((isBlank(_local6, (_local7 + 1))) && (!(isBlank((_local6 + 1), (_local7 + 1))))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_left_down_x, tileBg_layer, (_local16.x + 32), (_local16.y - 4));
                            tileBoarders.push(_local17);
                        }
                        if (((((isBlank(_local6, (_local7 + 1))) && (isBlank((_local6 + 1), _local7)))) && (isBlank((_local6 + 1), (_local7 + 1)))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_right_down, tileBg_layer, (_local16.x - 3), (_local16.y - 3));
                            tileBoarders.push(_local17);
                        }
                        if (((isBlank(_local6, (_local7 - 1))) && (!(isBlank((_local6 + 1), (_local7 - 1))))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_right_down_x, tileBg_layer, (_local16.x - 68), (_local16.y - 4));
                            tileBoarders.push(_local17);
                        }
                        if (((((isBlank((_local6 + 1), _local7)) && (!(isBlank(_local6, (_local7 + 1)))))) && (isBlank((_local6 + 1), (_local7 + 1)))))
                        {
                            _local17 = TileBoarder.pool.take();
                            _local17.setType(TileBoarder.x_border_heng_shang, tileBg_layer, _local16.x, (_local16.y + 32));
                            tileBoarders.push(_local17);
                        }
                    }
                    _local7++;
                }
                _local6++;
            }
        }

        private function isBlank(_arg1:int, _arg2:int):Boolean
        {
            if (!isValidPos(_arg1, _arg2))
            {
                return true;
            }
            if (currentLevel.tile[_arg1][_arg2] == 0)
            {
                return true;
            }
            return false;
        }

        private function createDoor():void
        {
            var _local3:int;
            var _local4:int;
            var _local5:FruitDoor;
            var _local6:Point;
            var _local1:Array = currentLevel.entryAndExit;
            var _local2:int;
            while (_local2 < GameConst.ROW_COUNT)
            {
                _local3 = 0;
                while (_local3 < GameConst.COL_COUNT)
                {
                    _local4 = _local1[_local2][_local3];
                    if (_local4 == TileConst.FRUIT_END)
                    {
                        _local5 = (FruitDoor.pool.take() as FruitDoor);
                        _local6 = getCandyPosition(_local2, _local3);
                        _local5.x = _local6.x;
                        _local5.y = (_local6.y + 30);
                        _local5.alpha = 0.7;
                        door_layer.addChild(_local5);
                    }
                    else
                    {
                        if ((((_local4 >= TileConst.T_DOOR_ENTRY1)) && ((_local4 <= TileConst.T_DOOR_EXIT9))))
                        {
                            createTransportDoor(_local2, _local3, _local4);
                        }
                    }
                    _local3++;
                }
                _local2++;
            }
        }

        private function createTransportDoor(_arg1:int, _arg2:int, _arg3:int):void
        {
            var _local4:TransportDoor = (TransportDoor.pool.take() as TransportDoor);
            _local4.tileID = _arg3;
            _local4.row = _arg1;
            _local4.col = _arg2;
            var _local5:Point = getCandyPosition(_arg1, _arg2);
            _local4.x = _local5.x;
            _local4.y = _local5.y;
            ice_layer.addChild(_local4);
            tDoors[_arg1][_arg2] = _local4;
        }

        private function createBrick():void
        {
            var _local3:int;
            var _local4:int;
            var _local5:Brick;
            var _local6:Point;
            var _local1:Array = currentLevel.board;
            var _local2:int;
            while (_local2 < GameConst.ROW_COUNT)
            {
                _local3 = 0;
                while (_local3 < GameConst.COL_COUNT)
                {
                    _local4 = _local1[_local2][_local3];
                    if (_local4 > 0)
                    {
                        _local5 = (Brick.pool.take() as Brick);
                        _local5.brickID = _local4;
                        _local5.row = _local2;
                        _local5.col = _local3;
                        _local6 = getCandyPosition(_local2, _local3);
                        _local5.x = _local6.x;
                        _local5.y = _local6.y;
                        brick_layer.addChild(_local5);
                        bricks[_local2][_local3] = _local5;
                    }
                    _local3++;
                }
                _local2++;
            }
        }

        private function createIce(row:int, col:int, tileID:int):Ice
        {
            var ice:Ice = (Ice.pool.take() as Ice);
            ice.tileID = tileID;
            ice.row = row;
            ice.col = col;
            var _local5:Point = getCandyPosition(row, col);
            ice.x = _local5.x;
            ice.y = _local5.y;
            ice_layer.addChild(ice);
            ices[row][col] = ice;
            return (ice);
        }

        private function createStones(row:int, col:int, _arg3:int):void
        {
            var _local4:Stone = (Stone.pool.take() as Stone);
            _local4.tileID = _arg3;
            _local4.row = row;
            _local4.col = col;
            var _local5:Point = getCandyPosition(row, col);
            _local4.x = _local5.x;
            _local4.y = _local5.y;
            stone_layer.addChild(_local4);
            stones[row][col] = _local4;
        }

        private function createCandys():void
        {
            var _local4:int;
            var _local5:int;
            var _local6:Candy;
            var _local1:Boolean;
            var _local2:Array = currentLevel.candy;
            var _local3:int;
            while (_local3 < GameConst.ROW_COUNT)
            {
                _local4 = 0;
                while (_local4 < GameConst.COL_COUNT)
                {
                    if ((((currentLevel.tile[_local3][_local4] > 0)) && (isCandyValidPos(_local3, _local4))))
                    {
                        _local5 = _local2[_local3][_local4];
                        if (_local5 > 0)
                        {
                            if ((((_local5 >= 6)) && ((_local5 <= 10))))
                            {
                                _local6 = newCandy(_local3, _local4, (_local5 - 5));
                                _local6.setSpecialStatus(CandySpecialStatus.HORIZ);
                            }
                            else
                            {
                                if ((((_local5 >= 11)) && ((_local5 <= 15))))
                                {
                                    _local6 = newCandy(_local3, _local4, (_local5 - 10));
                                    _local6.setSpecialStatus(CandySpecialStatus.VERT);
                                }
                                else
                                {
                                    if ((((_local5 >= 16)) && ((_local5 <= 20))))
                                    {
                                        _local6 = newCandy(_local3, _local4, (_local5 - 15));
                                        _local6.setSpecialStatus(CandySpecialStatus.BOMB);
                                    }
                                    else
                                    {
                                        if (_local5 == TileConst.COLORFUL)
                                        {
                                            _local6 = newCandy(_local3, _local4);
                                            _local6.setSpecialStatus(CandySpecialStatus.COLORFUL);
                                        }
                                        else
                                        {
                                            newCandy(_local3, _local4, _local5);
                                        }
                                    }
                                }
                            }
                            _local1 = false;
                        }
                        else
                        {
                            _local1 = true;
                            newCandy(_local3, _local4, _local5);
                        }
                    }
                    _local4++;
                }
                _local3++;
            }
            if (_local1)
            {
                shuffle();
            }
        }

        private function newCandy(row:int, col:int, color:int=0):Candy
        {
            if (color == 0)
            {
                color = int(((Math.random() * currentLevel.colorCount) + 1));
            }
            var candy:Candy = (Candy.pool.take() as Candy);
            candy.reset();
            var pos:Point = getCandyPosition(row, col);
            candy.x = pos.x;
            candy.y = pos.y;
            candy.row = row;
            candy.col = col;
            candy.color = color;
            candys[row][col] = candy;
            candy_layer.addChild(candy);
            return (candy);
        }

        private function getCandyPosition(_arg1:int, _arg2:int):Point
        {
            return (new Point(((_arg2 * GameConst.CARD_W) + offsetX), ((_arg1 * GameConst.CARD_W) + offsetY)));
        }

        private function createIronWires():void
        {
            var _local3:int;
            var _local4:int;
            var _local1:Array = currentLevel.ironWire;
            var _local2:int;
            while (_local2 < GameConst.ROW_COUNT)
            {
                _local3 = 0;
                while (_local3 < GameConst.COL_COUNT)
                {
                    _local4 = _local1[_local2][_local3];
                    if (_local4 > 0)
                    {
                        if (_local4 == TileConst.IRONWIRE)
                        {
                            createIronWire(_local2, _local3, 1);
                        }
                        else
                        {
                            if (_local4 == TileConst.IRONWIRE2)
                            {
                                createIronWire(_local2, _local3, 2);
                            }
                        }
                    }
                    _local3++;
                }
                _local2++;
            }
        }

		/**
		 * 创建铁丝 
		 * @param _arg1
		 * @param _arg2
		 * @param _arg3
		 * 
		 */		
        private function createIronWire(col:int, col:int, dir:int=1):void
        {
            var ironWire:IronWire = (IronWire.pool.take() as IronWire);
            ironWire.dir = dir;
            ironWire.row = col;
            ironWire.col = col;
            var point:Point = getCandyPosition(col, col);
            ironWire.x = point.x;
            ironWire.y = point.y;
            ironWire_layer.addChild(ironWire);
            ironWires[col][col] = ironWire;
        }

        private function createBomb(_arg1:int, _arg2:int):void
        {
            var _local3:int = ((Math.random() * 7) + 10);
            var _local4:Candy = candys[_arg1][_arg2];
            _local4.setBomb(_local3);
        }

        private function isCandyValidPos(_arg1:int, _arg2:int):Boolean
        {
            if (((((!((ices[_arg1][_arg2] == null))) || (!((stones[_arg1][_arg2] == null))))) || (!((eats[_arg1][_arg2] == null)))))
            {
                return false;
            }
            return true;
        }

        private function createEat(_arg1:int, _arg2:int):Eat
        {
            var _local3:Eat = (Eat.pool.take() as Eat);
            _local3.reset();
            _local3.row = _arg1;
            _local3.col = _arg2;
            var _local4:Point = getCandyPosition(_arg1, _arg2);
            _local3.x = _local4.x;
            _local3.y = _local4.y;
            eat_layer.addChild(_local3);
            eats[_arg1][_arg2] = _local3;
            return (_local3);
        }

        private function createMonster(_arg1:int, _arg2:int):Monster
        {
            var _local3:Monster = (Monster.pool.take() as Monster);
            _local3.reset();
            _local3.row = _arg1;
            _local3.col = _arg2;
            var _local4:Point = getCandyPosition(_arg1, _arg2);
            _local3.x = _local4.x;
            _local3.y = _local4.y;
            monster_layer.addChild(_local3);
            monsters[_arg1][_arg2] = _local3;
            return (_local3);
        }

        private function createLock(_arg1:int, _arg2:int):Lock
        {
            var _local3:Lock = (Lock.pool.take() as Lock);
            _local3.row = _arg1;
            _local3.col = _arg2;
            var _local4:Point = getCandyPosition(_arg1, _arg2);
            _local3.x = _local4.x;
            _local3.y = _local4.y;
            lock_layer.addChild(_local3);
            locks[_arg1][_arg2] = _local3;
            return (_local3);
        }

        private function update(e:EnterFrameEvent):void
        {
            switch (state)
            {
                case STATE_INIT:
                    createElements();
                    MsgDispatcher.execute(GameEvents.OPEN_MISSION_UI);
                    state = STATE_WAIT;
                    setTimeout(function ():void
                    {
                        var _local1:int = Model.levelModel.selectedLevel;
                        if (_local1 <= 5)
                        {
                            MsgDispatcher.execute(GameEvents.OPEN_GUIDE, _local1);
                        }
                        state = STATE_GAME;
                    }, 3000);
                    return;
                case STATE_GAME:
                    updateGameState();
                    return;
                case STATE_PAUSE:
                    return;
                case STATE_END:
                    return;
                case STATE_WAIT:
                    return;
            }
        }

        private function updateGameState():void
        {
            var _local1:int;
            var _local2:int;
            var _local3:Candy;
            var _local4:NoSwapTip;
            tipCount++;
            if (tipCount > tipDelay)
            {
                checkSwapTip();
                tipCount = 0;
            }
            switch (gameState)
            {
                case STATE_GAME_SWAP:
                    return;
                case STATE_GAME_SHUFFLE:
                    return;
                case STATE_GAME_WAIT_DROP:
                    dropCount++;
                    if (dropCount > DROP_DELAY)
                    {
                        dropCount = 0;
                        gameState = STATE_GAME_WAIT;
                        checkTop();
                    }
                    return;
                case STATE_GAME_WAIT:
                    return;
                case STATE_GAME_REMOVE:
                    return;
                case STATE_GAME_CHECK_DROP_COMPLETE:
                    isMoving = false;
                    _local1 = 0;
                    while (_local1 < GameConst.ROW_COUNT)
                    {
                        _local2 = 0;
                        while (_local2 < GameConst.COL_COUNT)
                        {
                            _local3 = candys[_local1][_local2];
                            if (_local3 != null)
                            {
                                if (Tweener.isTweening(_local3))
                                {
                                    isMoving = true;
                                }
                            }
                            _local2++;
                        }
                        _local1++;
                    }
                    tipCount = 0;
                    if (!isMoving)
                    {
                        if (checkHasMatches())
                        {
                            removeAllMatches();
                        }
                        else
                        {
                            checkBomb();
                            checkEatAndMonster();
                            if (Model.gameModel.checkAimComplete())
                            {
                                if ((((currentLevel.mode == GameMode.NORMAL)) || ((((currentLevel.mode == GameMode.TIME)) && ((Model.gameModel.time == 0))))))
                                {
                                    Debug.log("游戏胜利");
                                    gameState = STATE_GAME_END;
                                    handleVictory();
                                }
                                else
                                {
                                    gameState = STATE_GAME_WAIT;
                                }
                            }
                            else
                            {
                                if ((((currentLevel.mode == GameMode.NORMAL)) && ((Model.gameModel.step == 0))))
                                {
                                    Debug.log("游戏失败");
                                    gameState = STATE_GAME_END;
                                    handleFailed();
                                }
                                else
                                {
                                    if ((((currentLevel.mode == GameMode.TIME)) && ((Model.gameModel.time == 0))))
                                    {
                                        Debug.log("游戏失败");
                                        gameState = STATE_GAME_END;
                                        handleFailed();
                                    }
                                }
                                if (checkConnectable().length == 0)
                                {
                                    gameState = STATE_GAME_WAIT;
                                    _local4 = new NoSwapTip();
                                    _local4.doAniamtion(null);
                                    addChild(_local4);
                                    Debug.log("没有可以消除的了，洗牌");
                                    shuffle(true);
                                }
                                else
                                {
                                    gameState = STATE_GAME_WAIT;
                                }
                            }
                        }
                    }
                    return;
            }
        }

        private function onTimer():void
        {
            Model.gameModel.time--;
            if (Model.gameModel.time == 0)
            {
                Core.timerManager.remove(this, onTimer);
                gameState = STATE_GAME_CHECK_DROP_COMPLETE;
            }
        }

        private function onTouch(_arg1:TouchEvent):void
        {
            var _local3:Point;
            var selectRow:int;
            var selectCol:int;
            var stageLocation:Point;
            if (state != STATE_GAME)
            {
                return;
            }
            if (gameState != STATE_GAME_WAIT)
            {
                return;
            }
            var touch:Touch = _arg1.getTouch(Starling.current.stage);
            if (!touch)
            {
                return;
            }
            if (touch.phase == TouchPhase.BEGAN)
            {
                _local3 = touch.getLocation(Starling.current.stage);
                selectedCard = getCandyByTouch(_local3);
                if (selectedCard != null)
                {
                    Debug.log(("选择的candy位置:row=" + selectedCard.row), ("col=" + selectedCard.col), selectedCard.x, selectedCard.y);
                }
            }
            else
            {
                if (touch.phase == TouchPhase.MOVED)
                {
					if (selectedCard != null)
					{
						selectRow = selectedCard.row;
						selectCol = selectedCard.col;
						stageLocation = touch.getLocation(Starling.current.stage);
						if 
							(
								selectCol - 1 >= 0
								&& candys[selectRow][(selectCol - 1)] != null
								&& locks[selectRow][(selectCol - 1)] == null
								&& monsters[selectRow][(selectCol - 1)] == null
								&& candys[selectRow][(selectCol - 1)].collidePoint(stageLocation)
								&& !(hasIronWire(selectedCard.row, selectedCard.col, 1))
							)
						{
							makeSwap(selectedCard, candys[selectRow][(selectCol - 1)]);
						}
						else if 
							(
								selectCol + 1 < GameConst.COL_COUNT
								&& candys[selectRow][(selectCol + 1)] != null 
								&& locks[selectRow][(selectCol + 1)] == null
								&& monsters[selectRow][(selectCol + 1)] == null
								&& candys[selectRow][(selectCol + 1)].collidePoint(stageLocation)
								&& !(hasIronWire(selectRow, (selectCol + 1), 1))
							)
						{
							makeSwap(selectedCard, candys[selectRow][(selectCol + 1)]);
						}
						else if 
							(
								selectRow - 1 >= 0
								&& candys[(selectRow - 1)][selectCol] != null 
								&& locks[(selectRow - 1)][selectCol] == null
								&& monsters[(selectRow - 1)][selectCol] == null
								&& candys[(selectRow - 1)][selectCol].collidePoint(stageLocation) 
								&& !(hasIronWire((selectRow - 1), selectCol, 2))
							)
						{
							makeSwap(selectedCard, candys[(selectRow - 1)][selectCol]);
						}
						else if 
							(
								selectRow + 1 < GameConst.ROW_COUNT
								&& candys[(selectRow + 1)][selectCol] != null
								&& locks[(selectRow + 1)][selectCol] == null
								&& monsters[(selectRow + 1)][selectCol] == null
								&& candys[(selectRow + 1)][selectCol].collidePoint(stageLocation) 
								&& !(hasIronWire(selectedCard.row, selectedCard.col, 2))
							)
						{
							makeSwap(selectedCard, candys[(selectRow + 1)][selectCol]);
						}
					}
                }
                else
                {
                    if (touch.phase == TouchPhase.ENDED)
                    {
                    }
                }
            }
        }

        private function hasIronWire(_arg1:int, _arg2:int, _arg3:int):Boolean
        {
            if (ironWires[_arg1][_arg2] != null)
            {
                if (ironWires[_arg1][_arg2].dir == _arg3)
                {
                    return true;
                }
            }
            return false;
        }

        private function makeSwap(candyA:Candy, candyB:Candy):void
        {
            var posA:Point;
            var posB:Point;
            stopCandyTip();
            aimCard = candyB;
            gameState = STATE_GAME_SWAP;
            swapCandy(candyA, candyB);
            if (currentLevel.mode == GameMode.TIME)
            {
                Core.timerManager.add(this, onTimer, 1000);
            }
            posA = getCandyPosition(candyA.row, candyA.col);
            posB = getCandyPosition(candyB.row, candyB.col);
            candyA.runMoveAction({
                "time":0.2,
                "x":posA.x,
                "y":posA.y,
                "transition":"linear"
            });
            candyB.runMoveAction({
                "time":0.2,
                "x":posB.x,
                "y":posB.y,
                "transition":"linear",
                "onComplete":function ():void
                {
                    if ((((((((candyA.status == 4)) || ((candyB.status == 4)))) || ((((candyA.status > 0)) && ((candyB.status > 0)))))) || (checkHasMatches(false))))
                    {
                        Debug.log("交换有效");
                        handleValidSwap();
                    }
                    else
                    {
                        Debug.log("交换无效");
                        SoundManager.instance.playSound("notswap");
                        swapCandy(candyA, candyB);
                        posA = getCandyPosition(candyA.row, candyA.col);
                        posB = getCandyPosition(candyB.row, candyB.col);
                        candyA.runMoveAction({
                            "time":0.2,
                            "x":posA.x,
                            "y":posA.y,
                            "transition":"linear"
                        });
                        candyB.runMoveAction({
                            "time":0.2,
                            "x":posB.x,
                            "y":posB.y,
                            "transition":"linear",
                            "onComplete":function ():void
                            {
                                gameState = STATE_GAME_WAIT;
                            }
                        });
                    }
                }
            });
        }

        private function swapCandy(_arg1:Candy, _arg2:Candy):void
        {
            var _local3:int = _arg1.row;
            var _local4:int = _arg1.col;
            _arg1.row = _arg2.row;
            _arg1.col = _arg2.col;
            _arg2.row = _local3;
            _arg2.col = _local4;
            candys[_arg1.row][_arg1.col] = _arg1;
            candys[_arg2.row][_arg2.col] = _arg2;
        }

        private function getCandyByTouch(_arg1:Point):Candy
        {
            var _local3:int;
            var _local4:Candy;
            var _local2:int;
            while (_local2 < GameConst.ROW_COUNT)
            {
                _local3 = 0;
                while (_local3 < GameConst.COL_COUNT)
                {
                    _local4 = candys[_local2][_local3];
                    if (((((!((_local4 == null))) && ((locks[_local2][_local3] == null)))) && ((monsters[_local2][_local3] == null))))
                    {
                        if (_local4.collidePoint(_arg1))
                        {
                            return (_local4);
                        }
                    }
                    _local3++;
                }
                _local2++;
            }
            return (null);
        }

        private function checkSwapTip():void
        {
            var _local2:Array;
            var _local3:Candy;
            var _local4:Candy;
            if (hasSwapTip())
            {
                return;
            }
            var _local1:Array = checkConnectable();
            if (_local1.length > 0)
            {
                _local2 = _local1[int((Math.random() * _local1.length))];
                stopCandyTip();
                _local3 = _local2[0];
                _local4 = _local2[int(((Math.random() * (_local2.length - 1)) + 1))];
                _local3.shake();
                _local4.shake();
            }
        }

        private function hasSwapTip():Boolean
        {
            var _local2:int;
            var _local3:Candy;
            var _local1:int;
            while (_local1 < GameConst.ROW_COUNT)
            {
                _local2 = 0;
                while (_local2 < GameConst.COL_COUNT)
                {
                    _local3 = candys[_local1][_local2];
                    if (((!((_local3 == null))) && (_local3.isShake)))
                    {
                        return true;
                    }
                    _local2++;
                }
                _local1++;
            }
            return false;
        }

        private function stopCandyTip():void
        {
            var _local2:int;
            var _local3:Candy;
            var _local1:int;
            while (_local1 < GameConst.ROW_COUNT)
            {
                _local2 = 0;
                while (_local2 < GameConst.COL_COUNT)
                {
                    _local3 = candys[_local1][_local2];
                    if (_local3 != null)
                    {
                        _local3.stopShake();
                    }
                    _local2++;
                }
                _local1++;
            }
        }

        private function handleValidSwap():void
        {
            gameState = STATE_GAME_REMOVE;
            handleGuide();
            if ((((((aimCard.status == 4)) || ((selectedCard.status == 4)))) || ((((aimCard.status > 0)) && ((selectedCard.status > 0))))))
            {
                Debug.log("特殊交换");
                matchCountOnceSwap = 0;
                checkSpecialSwapMathces();
                if (currentLevel.mode == GameMode.NORMAL)
                {
                    Model.gameModel.step--;
                }
                checkNeedDropFruit();
                aimCard = (selectedCard = null);
            }
            else
            {
                Debug.log("普通交换");
                removeAllMatches();
                matchCountOnceSwap = 0;
                checkNeedDropFruit();
                if (currentLevel.mode == GameMode.NORMAL)
                {
                    Model.gameModel.step--;
                }
            }
        }

        private function checkHasMatches(_arg1:Boolean=true):Boolean
        {
            var _local2:int;
            var _local3:int;
            var _local4:Array;
            var _local5:Candy;
            var _local6:Array;
            var _local7:Array;
            var _local8:Array;
            _local2 = 0;
            while (_local2 < GameConst.ROW_COUNT)
            {
                _local3 = 0;
                while (_local3 < GameConst.COL_COUNT)
                {
                    _local5 = candys[_local2][_local3];
                    if (_local5 != null)
                    {
                        _local6 = getHorizMatches(candys, _local2, _local3);
                        if (_local6.length >= 3)
                        {
                            return true;
                        }
                        _local7 = getVertMatches(candys, _local2, _local3);
                        if (_local7.length >= 3)
                        {
                            return true;
                        }
                    }
                    _local3++;
                }
                _local2++;
            }
            if (_arg1)
            {
                _local8 = checkFruitIsEnd();
                if (_local8.length > 0)
                {
                    return true;
                }
            }
            return false;
        }

        private function searchMatchesAndMark():Array
        {
            var _local4:int;
            var _local5:int;
            var _local6:Array;
            var _local7:Candy;
            var _local8:Array;
            var _local9:Array;
            var _local10:Array;
            var _local11:Array;
            var _local1:Number = getTimer();
            var _local2:Array = [];
            var _local3:Array = candys;
            _local4 = 0;
            while (_local4 < GameConst.ROW_COUNT)
            {
                _local5 = 0;
                while (_local5 < GameConst.COL_COUNT)
                {
                    _local7 = _local3[_local4][_local5];
                    if (_local7 != null)
                    {
                        _local7.setNextStatus(0);
                        _local7.mark = false;
                        _local7.remove = false;
                    }
                    _local5++;
                }
                _local4++;
            }
            _local4 = 0;
            while (_local4 < GameConst.ROW_COUNT)
            {
                _local5 = 0;
                while (_local5 < GameConst.COL_COUNT)
                {
                    _local7 = _local3[_local4][_local5];
                    if (_local7 != null)
                    {
                        if (!_local7.mark)
                        {
                            _local8 = getHorizMatches(_local3, _local4, _local5);
                            if (_local8.length >= 5)
                            {
                                markAndChangeStatus(_local8, CandySpecialStatus.COLORFUL);
                            }
                            else
                            {
                                _local9 = getVertMatches(_local3, _local4, _local5);
                                if (_local9.length >= 5)
                                {
                                    markAndChangeStatus(_local9, CandySpecialStatus.COLORFUL);
                                }
                            }
                        }
                    }
                    _local5++;
                }
                _local4++;
            }
            _local4 = 0;
            while (_local4 < GameConst.ROW_COUNT)
            {
                _local5 = 0;
                while (_local5 < GameConst.COL_COUNT)
                {
                    _local7 = _local3[_local4][_local5];
                    if (_local7 != null)
                    {
                        if (!_local7.mark)
                        {
                            _local6 = getHVMatches(_local3, _local4, _local5, [1, 2, 3], [-1, 1, -2]);
                            if (_local6.length >= 5)
                            {
                                markAndChangeStatus(_local6, CandySpecialStatus.BOMB);
                            }
                            else
                            {
                                _local6 = getHVMatches(_local3, _local4, _local5, [1, 2, 4], [-1, 1, 2]);
                                if (_local6.length >= 5)
                                {
                                    markAndChangeStatus(_local6, CandySpecialStatus.BOMB);
                                }
                                else
                                {
                                    _local6 = getHVMatches(_local3, _local4, _local5, [3, 4, 1], [-1, 1, -2]);
                                    if (_local6.length >= 5)
                                    {
                                        markAndChangeStatus(_local6, CandySpecialStatus.BOMB);
                                    }
                                    else
                                    {
                                        _local6 = getHVMatches(_local3, _local4, _local5, [3, 4, 2], [-1, 1, 2]);
                                        if (_local6.length >= 5)
                                        {
                                            markAndChangeStatus(_local6, CandySpecialStatus.BOMB);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    _local5++;
                }
                _local4++;
            }
            _local4 = 0;
            while (_local4 < GameConst.ROW_COUNT)
            {
                _local5 = 0;
                while (_local5 < GameConst.COL_COUNT)
                {
                    _local7 = _local3[_local4][_local5];
                    if (_local7 != null)
                    {
                        if (!_local7.mark)
                        {
                            _local6 = getHVMatches(_local3, _local4, _local5, [4, 1], [2, -2]);
                            if (_local6.length >= 5)
                            {
                                markAndChangeStatus(_local6, CandySpecialStatus.BOMB);
                            }
                            else
                            {
                                _local6 = getHVMatches(_local3, _local4, _local5, [3, 1], [-2, -2]);
                                if (_local6.length >= 5)
                                {
                                    markAndChangeStatus(_local6, CandySpecialStatus.BOMB);
                                }
                                else
                                {
                                    _local6 = getHVMatches(_local3, _local4, _local5, [3, 2], [-2, 2]);
                                    if (_local6.length >= 5)
                                    {
                                        markAndChangeStatus(_local6, CandySpecialStatus.BOMB);
                                    }
                                    else
                                    {
                                        _local6 = getHVMatches(_local3, _local4, _local5, [4, 2], [2, 2]);
                                        if (_local6.length >= 5)
                                        {
                                            markAndChangeStatus(_local6, CandySpecialStatus.BOMB);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    _local5++;
                }
                _local4++;
            }
            _local4 = 0;
            while (_local4 < GameConst.ROW_COUNT)
            {
                _local5 = 0;
                while (_local5 < GameConst.COL_COUNT)
                {
                    _local7 = _local3[_local4][_local5];
                    if (_local7 != null)
                    {
                        if (!_local7.mark)
                        {
                            _local10 = getHorizMatches(_local3, _local4, _local5);
                            if (_local10.length == 4)
                            {
                                markAndChangeStatus(_local10, CandySpecialStatus.VERT);
                            }
                            else
                            {
                                _local11 = getVertMatches(_local3, _local4, _local5);
                                if (_local11.length == 4)
                                {
                                    markAndChangeStatus(_local11, CandySpecialStatus.HORIZ);
                                }
                                else
                                {
                                    if (_local10.length == 3)
                                    {
                                        markAndChangeStatus(_local10, CandySpecialStatus.NOTHING);
                                    }
                                    else
                                    {
                                        if (_local11.length == 3)
                                        {
                                            markAndChangeStatus(_local11, CandySpecialStatus.NOTHING);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    _local5++;
                }
                _local4++;
            }
            _local4 = 0;
            while (_local4 < GameConst.ROW_COUNT)
            {
                _local5 = 0;
                while (_local5 < GameConst.COL_COUNT)
                {
                    _local7 = _local3[_local4][_local5];
                    if (((!((_local7 == null))) && (_local7.remove)))
                    {
                        _local2.push(_local7);
                    }
                    _local5++;
                }
                _local4++;
            }
            Debug.log((((("搜索移除耗时:" + (getTimer() - _local1)) + "ms") + "---") + _local2.length));
            return (_local2);
        }

        private function markAndChangeStatus(_arg1:Array, _arg2:int=0):void
        {
            var _local4:Candy;
            var _local3:Boolean;
            for each (_local4 in _arg1)
            {
                _local4.mark = true;
                _local4.remove = true;
                if ((((((_local4 == selectedCard)) || ((_local4 == aimCard)))) && ((_arg2 > 0))))
                {
                    _local3 = true;
                    _local4.setNextStatus(_arg2);
                }
            }
            if (((!(_local3)) && ((_arg2 > 0))))
            {
                _arg1[(_arg1.length - 1)].setNextStatus(_arg2);
            }
        }

        private function changeCandysStatus(_arg1:Array, _arg2:int):void
        {
            var _local3:Candy;
            for each (_local3 in _arg1)
            {
                _local3.setSpecialStatus(_arg2);
            }
        }

        private function getHorizMatches(_arg1:Array, _arg2:int, _arg3:int):Array
        {
            var _local4:Array = [_arg1[_arg2][_arg3]];
            var _local5:int = (_arg3 + 1);
            while (_local5 < GameConst.COL_COUNT)
            {
                if (((((((!((_arg1[_arg2][_local5] == null))) && ((_arg1[_arg2][_arg3].color == _arg1[_arg2][_local5].color)))) && ((_arg1[_arg2][_local5].color > 0)))) && (isCandyValidPos(_arg2, _local5))))
                {
                    _local4.push(_arg1[_arg2][_local5]);
                }
                else
                {
                    break;
                }
                _local5++;
            }
            return (_local4);
        }

        private function getVertMatches(_arg1:Array, _arg2:int, _arg3:int):Array
        {
            var _local4:Array = [_arg1[_arg2][_arg3]];
            var _local5:int = (_arg2 + 1);
            while (_local5 < GameConst.ROW_COUNT)
            {
                if (((((((!((_arg1[_local5][_arg3] == null))) && ((_arg1[_arg2][_arg3].color == _arg1[_local5][_arg3].color)))) && ((_arg1[_local5][_arg3].color > 0)))) && (isCandyValidPos(_local5, _arg3))))
                {
                    _local4.push(_arg1[_local5][_arg3]);
                }
                else
                {
                    break;
                }
                _local5++;
            }
            return (_local4);
        }

        private function getHVMatches(_arg1:Array, _arg2:int, _arg3:int, _arg4:Array, _arg5:Array):Array
        {
            var _local8:int;
            var _local10:int;
            var _local6:Array = [_arg1[_arg2][_arg3]];
            var _local7:int;
            var _local9:int;
            while (_local9 < _arg4.length)
            {
                _local10 = _arg4[_local9];
                if (_local10 == 3)
                {
                    _local8 = Math.max(0, (_arg3 + _arg5[_local9]));
                    _local7 = (_arg3 - 1);
                    while (_local7 >= _local8)
                    {
                        if (((!((_arg1[_arg2][_local7] == null))) && ((_arg1[_arg2][_arg3].color == _arg1[_arg2][_local7].color))))
                        {
                            _local6.push(_arg1[_arg2][_local7]);
                        }
                        else
                        {
                            break;
                        }
                        _local7--;
                    }
                }
                if (_local10 == 4)
                {
                    _local8 = Math.min((GameConst.COL_COUNT - 1), (_arg3 + _arg5[_local9]));
                    _local7 = (_arg3 + 1);
                    while (_local7 <= _local8)
                    {
                        if (((!((_arg1[_arg2][_local7] == null))) && ((_arg1[_arg2][_arg3].color == _arg1[_arg2][_local7].color))))
                        {
                            _local6.push(_arg1[_arg2][_local7]);
                        }
                        else
                        {
                            break;
                        }
                        _local7++;
                    }
                }
                if (_local10 == 2)
                {
                    _local8 = Math.min((GameConst.ROW_COUNT - 1), (_arg2 + _arg5[_local9]));
                    _local7 = (_arg2 + 1);
                    while (_local7 <= _local8)
                    {
                        if (((!((_arg1[_local7][_arg3] == null))) && ((_arg1[_arg2][_arg3].color == _arg1[_local7][_arg3].color))))
                        {
                            _local6.push(_arg1[_local7][_arg3]);
                        }
                        else
                        {
                            break;
                        }
                        _local7++;
                    }
                }
                if (_local10 == 1)
                {
                    _local8 = Math.max(0, (_arg2 + _arg5[_local9]));
                    _local7 = (_arg2 - 1);
                    while (_local7 >= _local8)
                    {
                        if (((!((_arg1[_local7][_arg3] == null))) && ((_arg1[_arg2][_arg3].color == _arg1[_local7][_arg3].color))))
                        {
                            _local6.push(_arg1[_local7][_arg3]);
                        }
                        else
                        {
                            break;
                        }
                        _local7--;
                    }
                }
                _local9++;
            }
            return (_local6);
        }

        private function removeAllMatches():void
        {
            var _local1:Array = checkFruitIsEnd();
            if (_local1.length > 0)
            {
                removeFruits(_local1);
                gameState = STATE_GAME_WAIT_DROP;
            }
            var _local2:Array = searchMatchesAndMark();
            if (_local2.length >= 3)
            {
                if (!checkHasStatusCandy(_local2))
                {
                    tempScore = (((_local2.length - 3) * 25) + 50);
                }
                else
                {
                    tempScore = 300;
                }
                handleRemoveList(_local2);
                gameState = STATE_GAME_WAIT_DROP;
                selectedCard = (aimCard = null);
            }
        }

        private function checkBomb():void
        {
            var _local2:int;
            var _local3:Candy;
            var _local1:int;
            while (_local1 < GameConst.ROW_COUNT)
            {
                _local2 = 0;
                while (_local2 < GameConst.COL_COUNT)
                {
                    _local3 = candys[_local1][_local2];
                    if (((_local3) && ((_local3.getBombCount() > 0))))
                    {
                        _local3.bombCountUpdate();
                    }
                    _local2++;
                }
                _local1++;
            }
        }

        private function checkEatAndMonster():void
        {
            var _local2:Array;
            var _local3:Object;
            var _local4:Eat;
            var _local5:Point;
            var _local6:Candy;
            var _local7:Eat;
            var _local8:Point;
            var _local9:Object;
            var _local10:Monster;
            var _local11:Point;
            var _local12:Point;
            if (!eatRemoved)
            {
                _local2 = getEatAndAroundCandys();
                if (_local2.length > 0)
                {
                    _local3 = _local2[int((Math.random() * _local2.length))];
                    _local4 = _local3.eat;
                    _local4.zoomOutIn();
                    _local5 = _local3.pos;
                    _local6 = candys[_local5.x][_local5.y];
                    if (_local6 != null)
                    {
                        candys[_local5.x][_local5.y] = null;
                        _local6.removeFromParent();
                        _local6.reset();
                        Candy.pool.put(_local6);
                    }
                    _local7 = Eat.pool.take();
                    _local7.row = _local5.x;
                    _local7.col = _local5.y;
                    _local7.reset();
                    eats[_local5.x][_local5.y] = _local7;
                    _local7.zoomIn();
                    SoundManager.instance.playSound("msc_virus");
                    _local8 = getCandyPosition(_local5.x, _local5.y);
                    _local7.x = _local8.x;
                    _local7.y = _local8.y;
                    eat_layer.addChild(_local7);
                }
            }
            eatRemoved = false;
            var _local1:Array = getMonsterAndAroundCandys();
            if (_local1.length > 0)
            {
                _local9 = _local1[int((Math.random() * _local1.length))];
                _local10 = _local9.monster;
                _local11 = _local9.pos;
                monsters[_local10.row][_local10.col] = null;
                _local10.row = _local11.x;
                _local10.col = _local11.y;
                monsters[_local11.x][_local11.y] = _local10;
                _local12 = getCandyPosition(_local11.x, _local11.y);
                Tweener.addTween(_local10, {
                    "time":0.1,
                    "x":_local12.x,
                    "y":_local12.y
                });
                SoundManager.instance.playSound("msc_moveable");
            }
            if (matchCountOnceSwap >= 40)
            {
                addGoodTip(3);
            }
            else
            {
                if (matchCountOnceSwap >= 25)
                {
                    addGoodTip(2);
                }
                else
                {
                    if (matchCountOnceSwap >= 10)
                    {
                        addGoodTip(1);
                    }
                }
            }
            matchCountOnceSwap = 0;
        }

        private function checkHasStatusCandy(_arg1:Array):Boolean
        {
            var _local2:Candy;
            for each (_local2 in _arg1)
            {
                if ((((((_local2.status == 1)) || ((_local2.status == 2)))) || ((_local2.status == 3))))
                {
                    return true;
                }
            }
            return false;
        }

        private function checkFruitIsEnd():Array
        {
            var _local4:int;
            var _local5:int;
            var _local6:Candy;
            var _local1:Array = [];
            var _local2:Array = currentLevel.entryAndExit;
            var _local3:int;
            while (_local3 < GameConst.ROW_COUNT)
            {
                _local4 = 0;
                while (_local4 < GameConst.COL_COUNT)
                {
                    _local5 = _local2[_local3][_local4];
                    if (_local5 == TileConst.FRUIT_END)
                    {
                        _local6 = candys[_local3][_local4];
                        if (((!((_local6 == null))) && (_local6.isFruit())))
                        {
                            _local1.push(_local6);
                        }
                    }
                    _local4++;
                }
                _local3++;
            }
            return (_local1);
        }

        private function checkSpecialSwapMathces():void
        {
            var matches:Array;
            var cols:Array;
            var rows:Array;
            var candyA:Candy;
            var candyB:Candy;
            matches = [];
            if (selectedCard.status < aimCard.status)
            {
                candyA = aimCard;
                candyB = selectedCard;
            }
            else
            {
                candyA = selectedCard;
                candyB = aimCard;
            }
            if (candyA.status == CandySpecialStatus.COLORFUL)
            {
                if (candyB.status == CandySpecialStatus.COLORFUL)
                {
                    matches = getAllCandys();
                    tempScore = 300;
                    removeCandys(matches);
                    waitDrop();
                }
                else
                {
                    if (candyB.status == CandySpecialStatus.BOMB)
                    {
                        matches = getCandysByColorType(candyB.color);
                        createLaserEffect(candyA.x, candyA.y, matches, CandySpecialStatus.BOMB, function ():void
                        {
                            tempScore = 300;
                            changeCandysStatus(matches, CandySpecialStatus.BOMB);
                            matches.push(candyA);
                            removeCandys(matches);
                            waitDrop();
                        });
                    }
                    else
                    {
                        if (candyB.status == CandySpecialStatus.VERT)
                        {
                            matches = getCandysByColorType(candyB.color);
                            createLaserEffect(candyA.x, candyA.y, matches, CandySpecialStatus.VERT, function ():void
                            {
                                tempScore = 300;
                                changeCandysStatus(matches, CandySpecialStatus.VERT);
                                matches.push(candyA);
                                removeCandys(matches);
                                waitDrop();
                            });
                        }
                        else
                        {
                            if (candyB.status == CandySpecialStatus.HORIZ)
                            {
                                matches = getCandysByColorType(candyB.color);
                                createLaserEffect(candyA.x, candyA.y, matches, CandySpecialStatus.HORIZ, function ():void
                                {
                                    tempScore = 300;
                                    changeCandysStatus(matches, CandySpecialStatus.HORIZ);
                                    matches.push(candyA);
                                    removeCandys(matches);
                                    waitDrop();
                                });
                            }
                            else
                            {
                                if (candyB.status == CandySpecialStatus.NOTHING)
                                {
                                    matches = getCandysByColorType(candyB.color);
                                    createRayEffect(candyA.x, candyA.y, matches, function ():void
                                    {
                                        tempScore = 300;
                                        matches.push(candyA);
                                        removeCandys(matches);
                                        waitDrop();
                                    });
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                if (candyA.status == CandySpecialStatus.BOMB)
                {
                    if (candyB.status == CandySpecialStatus.BOMB)
                    {
                        matches = getAroundCandys2(candyA, candyB);
                        tempScore = 300;
                        removeCandys(matches);
                        waitDrop();
                    }
                    else
                    {
                        if (candyB.status == CandySpecialStatus.VERT)
                        {
                            if (candyA.col < candyB.col)
                            {
                                cols = [(candyA.col - 1), candyA.col, candyB.col, (candyB.col + 1)];
                            }
                            else
                            {
                                if (candyA.col > candyB.col)
                                {
                                    cols = [(candyA.col + 1), candyA.col, candyB.col, (candyB.col - 1)];
                                }
                                else
                                {
                                    if (candyA.col == candyB.col)
                                    {
                                        cols = [(candyA.col - 1), candyA.col, (candyB.col + 1)];
                                    }
                                }
                            }
                            matches = getCandysByRowsOrCols([], cols);
                            tempScore = 300;
                            removeCandys(matches);
                            waitDrop();
                        }
                        else
                        {
                            if (candyB.status == CandySpecialStatus.HORIZ)
                            {
                                if (candyA.row < candyB.row)
                                {
                                    rows = [(candyA.row - 1), candyA.row, candyB.row, (candyB.row + 1)];
                                }
                                else
                                {
                                    if (candyA.row > candyB.row)
                                    {
                                        rows = [(candyA.row + 1), candyA.row, candyB.row, (candyB.row - 1)];
                                    }
                                    else
                                    {
                                        if (candyA.row == candyB.row)
                                        {
                                            rows = [(candyA.row - 1), candyA.row, (candyB.row + 1)];
                                        }
                                    }
                                }
                                matches = getCandysByRowsOrCols(rows, []);
                                tempScore = 300;
                                removeCandys(matches);
                                waitDrop();
                            }
                        }
                    }
                }
                else
                {
                    if (candyA.status == CandySpecialStatus.VERT)
                    {
                        if (candyB.status == CandySpecialStatus.VERT)
                        {
                            tempScore = 300;
                            removeCandys([candyA, candyB]);
                            waitDrop();
                        }
                        else
                        {
                            if (candyB.status == CandySpecialStatus.HORIZ)
                            {
                                tempScore = 300;
                                removeCandys([candyA, candyB]);
                                waitDrop();
                            }
                        }
                    }
                    else
                    {
                        if (candyA.status == CandySpecialStatus.HORIZ)
                        {
                            if (candyB.status == CandySpecialStatus.HORIZ)
                            {
                                tempScore = 300;
                                removeCandys([candyA, candyB]);
                                waitDrop();
                            }
                        }
                    }
                }
            }
        }

        private function createLaserEffect(x:int, y:int, list:Array, changeStatus:int, complete:Function):void
        {
            var animationCount:int;
            var candy:Candy;
            var disX:Number;
            var disY:Number;
            var dis:Number;
            var radian:Number;
            var laserEffect:LaserEffect;
            animationCount = 0;
            var i:int;
            while (i < list.length)
            {
                candy = list[i];
                disX = (candy.x - x);
                disY = (candy.y - y);
                dis = Math.sqrt(((disX * disX) + (disY * disY)));
                radian = Math.atan2(disY, disX);
                laserEffect = LaserEffect.pool.take();
                laserEffect.x = x;
                laserEffect.y = y;
                laserEffect.setData(radian);
                addChild(laserEffect);
                Tweener.addTween(laserEffect, {
                    "time":(dis / 400),
                    "x":candy.x,
                    "y":candy.y,
                    "onCompleteParams":[candy, laserEffect],
                    "transition":"linear",
                    "onComplete":function (_arg1:Candy, _arg2:LaserEffect):void
                    {
                        _arg2.removeFromParent();
                        LaserEffect.pool.put(_arg2);
                        _arg1.setSpecialStatus(changeStatus, true);
                        animationCount++;
                        if (animationCount == list.length)
                        {
                            complete();
                        }
                    }
                });
                i = (i + 1);
            }
        }

        private function createRayEffect(x:int, y:int, list:Array, complete:Function):void
        {
            var animationCount:int;
            var candy:Candy;
            var disX:Number;
            var disY:Number;
            var dis:Number;
            var radian:Number;
            var laserEffect:RayEffect;
            animationCount = 0;
            var i:int;
            while (i < list.length)
            {
                candy = list[i];
                disX = (candy.x - x);
                disY = (candy.y - y);
                dis = Math.sqrt(((disX * disX) + (disY * disY)));
                radian = Math.atan2(disY, disX);
                laserEffect = RayEffect.pool.take();
                laserEffect.x = x;
                laserEffect.y = y;
                addChild(laserEffect);
                Tweener.addTween(laserEffect, {
                    "time":(dis / 800),
                    "x":candy.x,
                    "y":candy.y,
                    "onCompleteParams":[candy, laserEffect],
                    "transition":"linear",
                    "onComplete":function (_arg1:Candy, _arg2:RayEffect):void
                    {
                        _arg2.removeFromParent();
                        RayEffect.pool.put(_arg2);
                        animationCount++;
                        if (animationCount == list.length)
                        {
                            complete();
                        }
                    }
                });
                i = (i + 1);
            }
        }

        private function handleRemoveList(_arg1:Array):void
        {
            var _local3:Candy;
            var _local4:Candy;
            var _local2:int;
            while (_local2 < _arg1.length)
            {
                _local3 = _arg1[_local2];
                if (_local3.getNextStatus() > 0)
                {
                    removeCandys([_local3]);
                    _local4 = newCandy(_local3.row, _local3.col, _local3.color);
                    _local4.setSpecialStatus(_local3.getNextStatus(), true);
                    _arg1.splice(_local2, 1);
                    _local2--;
                }
                _local2++;
            }
            removeCandys(_arg1);
        }

        private function removeCandys(_arg1:Array):void
        {
            var _local3:Candy;
            var i:int;
            var _local5:Array;
            var _local6:Point;
            var _local7:Point;
            var candy:Candy;
           
            var _local2:Array = [];
            for each (_local3 in _arg1)
            {
                _local5 = searchSpecialRelativeCandys(_local3);
                for each (_local6 in _local5)
                {
                    if (_local2.indexOf(_local6) == -1)
                    {
                        _local2.push(_local6);
                    }
                }
            }
            SoundManager.instance.playSound("boomcommon");
            i = (_local2.length - 1);
            while (i >= 0)
            {
                _local7 = _local2[i];
                candy = candys[_local7.x][_local7.y];
                if (candy != null&& candy.color < 7)
                {
                    removeElementAroundCandy(candy);
                    addEffect(candy.status, candy.x, candy.y);
                    candy.reset();
                    candys[candy.row][candy.col] = null;
                    Candy.pool.put(candy);
                    candy.removeFromParent();
                    matchCountOnceSwap++;
                }
                else
                {
					var ice:Ice = ices[_local7.x][_local7.y];
                    if (ice != null)
                    {
                        removeIce(ice);
                    }
					var brick:Brick = bricks[_local7.x][_local7.y];
                    if (brick != null)
                    {
                        removeBrick(brick);
                    }
					var eat:Eat = eats[_local7.x][_local7.y];
                    if (eat != null)
                    {
                        eats[eat.row][eat.col] = null;
                        eat.doAnimation();
                        eatRemoved = true;
                    }
					var monster:Monster = monsters[_local7.x][_local7.y];
                    if (monster != null)
                    {
                        monsters[monster.row][monster.col] = null;
                        monster.doAnimation();
                    }
                }
                i--;
            }
        }

        private function waitDrop():void
        {
            gameState = STATE_GAME_WAIT_DROP;
        }

        private function removeElementAroundCandy(_arg1:Candy):void
        {
            var _local5:Monster;
            var _local6:Array;
            var _local7:Eat;
            var _local8:Array;
            var _local9:Ice;
            var _local10:Array;
            var _local11:Stone;
            if (_arg1.status == CandySpecialStatus.HORIZ)
            {
                SoundManager.instance.playSound("effect_hyper");
                Model.gameModel.offsetAim(AimType.LINE_BOMB, 1);
            }
            else
            {
                if (_arg1.status == CandySpecialStatus.VERT)
                {
                    SoundManager.instance.playSound("effect_hyper");
                    Model.gameModel.offsetAim(AimType.LINE_BOMB, 1);
                }
                else
                {
                    if (_arg1.status == CandySpecialStatus.BOMB)
                    {
                        SoundManager.instance.playSound("bomb_blast");
                    }
                }
            }
            var _local2:Lock = locks[_arg1.row][_arg1.col];
            if (_local2)
            {
                locks[_arg1.row][_arg1.col] = null;
                _arg1.remove = false;
                _arg1.mark = false;
                _local2.doAnimation();
                return;
            }
            var _local3:Brick = bricks[_arg1.row][_arg1.col];
            if (_local3)
            {
                removeBrick(_local3);
            }
            var _local4:Array = getNearMonster(_arg1.row, _arg1.col);
            for each (_local5 in _local4)
            {
                monsters[_local5.row][_local5.col] = null;
                _local5.doAnimation();
            }
            _local6 = getNearEat(_arg1.row, _arg1.col);
            for each (_local7 in _local6)
            {
                eats[_local7.row][_local7.col] = null;
                _local7.doAnimation();
                eatRemoved = true;
            }
            _local8 = getNearIce(_arg1.row, _arg1.col);
            for each (_local9 in _local8)
            {
                removeIce(_local9);
            }
            _local10 = getNearStone(_arg1.row, _arg1.col);
            for each (_local11 in _local10)
            {
                _local11.setLife((_local11.life - 1), true);
                if (_local11.life == 0)
                {
                    stones[_local11.row][_local11.col] = null;
                    Stone.pool.put(_local11);
                    _local11.removeFromParent();
                }
            }
            if (_arg1.color == ColorType.GREEN)
            {
                Model.gameModel.offsetAim(AimType.GREEN, 1);
            }
            else
            {
                if (_arg1.color == ColorType.RED)
                {
                    Model.gameModel.offsetAim(AimType.RED, 1);
                }
                else
                {
                    if (_arg1.color == ColorType.BLUE)
                    {
                        Model.gameModel.offsetAim(AimType.BLUE, 1);
                    }
                    else
                    {
                        if (_arg1.color == ColorType.PURPLE)
                        {
                            Model.gameModel.offsetAim(AimType.PURPLE, 1);
                        }
                        else
                        {
                            if (_arg1.color == ColorType.YELLOW)
                            {
                                Model.gameModel.offsetAim(AimType.YELLOW, 1);
                            }
                        }
                    }
                }
            }
            Model.gameModel.score = (Model.gameModel.score + tempScore);
            Model.gameModel.offsetAim(AimType.SCORE, tempScore);
            addScoreTip(_arg1.x, _arg1.y, tempScore, _arg1.color);
        }

        private function removeIce(ice:Ice):void
        {
            SoundManager.instance.playSound("iceboom", false, 0, 1, 1, true);
            ice.subLife(true);
            if (ice.isDie())
            {
                Model.gameModel.offsetAim(AimType.ICE, 1);
                ices[ice.row][ice.col] = null;
                Ice.pool.put(ice);
                ice.removeFromParent();
            }
        }

        private function removeBrick(_arg1:Brick):void
        {
            _arg1.loseLife();
            if (_arg1.life == 0)
            {
                bricks[_arg1.row][_arg1.col] = null;
                Brick.pool.put(_arg1);
                _arg1.removeFromParent();
                Model.gameModel.offsetAim(AimType.BOARD, 1);
            }
        }

        private function removeFruits(list:Array):void
        {
            var removeCandy:Candy;
            var tp:Point;
            var disX:Number;
            var disY:Number;
            var dis:Number;
            var t:Number;
            Debug.log("移除水果");
            for each (removeCandy in list)
            {
                addScoreTip(removeCandy.x, removeCandy.y, 10, removeCandy.color);
                addEffect(removeCandy.status, removeCandy.x, removeCandy.y);
                removeCandy.reset();
                candys[removeCandy.row][removeCandy.col] = null;
                addChild(removeCandy);
                tp = new Point(0, 0);
                if (removeCandy.color == 7)
                {
                    tp = infoPanel.getIconPos(AimType.FRUIT1);
                }
                else
                {
                    if (removeCandy.color == 8)
                    {
                        tp = infoPanel.getIconPos(AimType.FRUIT2);
                    }
                    else
                    {
                        if (removeCandy.color == 9)
                        {
                            tp = infoPanel.getIconPos(AimType.FRUIT3);
                        }
                    }
                }
                disX = ((tp.x + infoPanel.x) - removeCandy.x);
                disY = ((tp.y + infoPanel.y) - removeCandy.y);
                dis = Math.sqrt(((disX * disX) + (disY * disY)));
                t = (dis / 600);
                Tweener.addTween(removeCandy, {
                    "time":t,
                    "x":(tp.x + infoPanel.x),
                    "y":(tp.y + infoPanel.y),
                    "scaleX":0.6,
                    "scaleY":0.6,
                    "onCompleteParams":[removeCandy],
                    "onComplete":function (_arg1:Candy):void
                    {
                        if (_arg1.color == ColorType.FRUIT1)
                        {
                            Model.gameModel.offsetAim(AimType.FRUIT1, 1);
                        }
                        else
                        {
                            if (_arg1.color == ColorType.FRUIT2)
                            {
                                Model.gameModel.offsetAim(AimType.FRUIT2, 1);
                            }
                            else
                            {
                                if (_arg1.color == ColorType.FRUIT3)
                                {
                                    Model.gameModel.offsetAim(AimType.FRUIT3, 1);
                                }
                            }
                        }
                        Candy.pool.put(_arg1);
                        _arg1.reset();
                        _arg1.removeFromParent();
                    }
                });
            }
        }

        private function searchSpecialRelativeCandys(_arg1:Candy):Array
        {
            var _local4:Point;
            var _local5:Candy;
            var _local6:Array;
            var _local7:Point;
            var _local8:Candy;
            var _local2:Array = [];
            var _local3:Array = [];
            _local2.push(new Point(_arg1.row, _arg1.col));
            while (_local2.length > 0)
            {
                _local4 = _local2.shift();
                _local5 = candys[_local4.x][_local4.y];
                _local3.push(_local4);
                if (((!((_local5 == null))) && ((_local5.status > 0))))
                {
                    _local6 = getRelativeCandysByStatus(_local5);
                    for each (_local7 in _local6)
                    {
                        _local8 = candys[_local7.x][_local7.y];
                        if (_local8 != _local5)
                        {
                            if (((!((_local8 == null))) && ((_local8.status > 0))))
                            {
                                if (((!(checkListContainPoint(_local2, _local7))) && (!(checkListContainPoint(_local3, _local7)))))
                                {
                                    _local2.push(_local7);
                                }
                            }
                            else
                            {
                                if (!checkListContainPoint(_local3, _local7))
                                {
                                    _local3.push(_local7);
                                }
                            }
                        }
                    }
                }
            }
            return (_local3);
        }

        private function checkListContainPoint(_arg1:Array, _arg2:Point):Boolean
        {
            var _local3:Point;
            for each (_local3 in _arg1)
            {
                if ((((_local3.x === _arg2.x)) && ((_local3.y == _arg2.y))))
                {
                    return true;
                }
            }
            return false;
        }

        private function checkTop():void
        {
            var _local2:int;
            var _local3:Boolean;
            var _local4:Candy;
            colAdd = [];
            tDoorAdd = [];
            var _local1:int;
            while (_local1 < GameConst.ROW_COUNT)
            {
                _local2 = 0;
                while (_local2 < GameConst.COL_COUNT)
                {
                    if (currentLevel.entryAndExit[_local1][_local2] == TileConst.ENTRY)
                    {
                        colAdd[_local2] = (_local1 - 1);
                    }
                    else
                    {
                        if ((((currentLevel.entryAndExit[_local1][_local2] >= TileConst.T_DOOR_EXIT1)) && ((currentLevel.entryAndExit[_local1][_local2] <= TileConst.T_DOOR_EXIT9))))
                        {
                            tDoorAdd[_local2] = (_local1 - 1);
                        }
                    }
                    _local2++;
                }
                _local1++;
            }
            while (true)
            {
                _local3 = dropAndAdd();
                if (!_local3) break;
            }
            _local1 = 0;
            while (_local1 < GameConst.ROW_COUNT)
            {
                _local2 = 0;
                while (_local2 < GameConst.COL_COUNT)
                {
                    _local4 = candys[_local1][_local2];
                    if (_local4 != null)
                    {
                        if (_local4.path.length > 0)
                        {
                            _local4.runAsPath();
                        }
                    }
                    _local2++;
                }
                _local1++;
            }
        }

        private function dropAndAdd():Boolean
        {
            var _local4:int;
            var _local5:int;
            var _local6:Candy;
            var candyColor:int;
            var _local8:Candy;
            var _local9:Point;
            var _local10:Candy;
            var _local11:Point;
            var _local12:Point;
            var _local1:Boolean;
            var _local2:Array = [4, 3, 2, 1, 0, 5, 6, 7, 8];
            var _local3:int = (GameConst.ROW_COUNT - 1);
            while (_local3 >= 0)
            {
                _local4 = 0;
                while (_local4 < _local2.length)
                {
                    _local5 = _local2[_local4];
                    _local6 = candys[_local3][_local5];
                    if ((((((_local6 == null)) && (!((currentLevel.tile[_local3][_local5] == 0))))) && (!(checkIsBlock(_local3, _local5)))))
                    {
                        if (currentLevel.entryAndExit[_local3][_local5] == TileConst.ENTRY)
                        {
                            candyColor = 0;
                            if (nextFruitId > 0)
                            {
                                candyColor = nextFruitId;
                                nextFruitId = 0;
                            }
                            _local8 = newCandy(_local3, _local5, candyColor);
                            _local9 = getCandyPosition(colAdd[_local5], _local5);
                            _local8.x = _local9.x;
                            _local8.y = _local9.y;
                            gameState = STATE_GAME_CHECK_DROP_COMPLETE;
                            _local8.addPath({
                                "pos":getCandyPosition(_local3, _local5),
                                "type":1
                            });
                            _local1 = true;
                            colAdd[_local5]--;
                            Debug.log("添加新的candy", _local3, _local5);
                        }
                        else
                        {
                            if ((((currentLevel.entryAndExit[_local3][_local5] >= TileConst.T_DOOR_EXIT1)) && ((currentLevel.entryAndExit[_local3][_local5] <= TileConst.T_DOOR_EXIT9))))
                            {
                                _local10 = getTransportCandy(currentLevel.entryAndExit[_local3][_local5]);
                                if (_local10 != null)
                                {
                                    candys[_local10.row][_local10.col] = null;
                                    _local10.row = _local3;
                                    _local10.col = _local5;
                                    _local11 = getCandyPosition(tDoorAdd[_local5], _local5);
                                    _local10.addPath({
                                        "pos":_local11,
                                        "type":2
                                    });
                                    candys[_local3][_local5] = _local10;
                                    var _local13:Array = tDoorAdd;
                                    var _local14:int = _local5;
                                    var _local15:int = (_local13[_local14] - 1);
                                    _local13[_local14] = _local15;
                                    _local10.addPath({
                                        "pos":getCandyPosition(_local3, _local5),
                                        "type":1
                                    });
                                    gameState = STATE_GAME_CHECK_DROP_COMPLETE;
                                    _local1 = true;
                                }
                            }
                            else
                            {
                                if (checkIsUpPosition(_local3, _local5))
                                {
                                    if (((((isValidPos((_local3 - 1), (_local5 + 1))) && (!(checkIsBlock((_local3 - 1), (_local5 + 1)))))) && (!((candys[(_local3 - 1)][(_local5 + 1)] == null)))))
                                    {
                                        _local12 = new Point((_local3 - 1), (_local5 + 1));
                                        candys[_local12.x][_local12.y].row = _local3;
                                        candys[_local12.x][_local12.y].col = _local5;
                                        candys[_local12.x][_local12.y].addPath({
                                            "pos":getCandyPosition(_local3, _local5),
                                            "type":1
                                        });
                                        candys[_local3][_local5] = candys[_local12.x][_local12.y];
                                        candys[_local12.x][_local12.y] = null;
                                        gameState = STATE_GAME_CHECK_DROP_COMPLETE;
                                        _local1 = true;
                                    }
                                    else
                                    {
                                        if (((((isValidPos((_local3 - 1), (_local5 - 1))) && (!(checkIsBlock((_local3 - 1), (_local5 - 1)))))) && (!((candys[(_local3 - 1)][(_local5 - 1)] == null)))))
                                        {
                                            _local12 = new Point((_local3 - 1), (_local5 - 1));
                                            candys[_local12.x][_local12.y].row = _local3;
                                            candys[_local12.x][_local12.y].col = _local5;
                                            candys[_local12.x][_local12.y].addPath({
                                                "pos":getCandyPosition(_local3, _local5),
                                                "type":1
                                            });
                                            candys[_local3][_local5] = candys[_local12.x][_local12.y];
                                            candys[_local12.x][_local12.y] = null;
                                            gameState = STATE_GAME_CHECK_DROP_COMPLETE;
                                            _local1 = true;
                                        }
                                    }
                                }
                                else
                                {
                                    _local12 = getCandyCanDropPos(_local3, _local5);
                                    if (_local12 != null)
                                    {
                                        candys[_local12.x][_local12.y].row = _local3;
                                        candys[_local12.x][_local12.y].col = _local5;
                                        candys[_local12.x][_local12.y].addPath({
                                            "pos":getCandyPosition(_local3, _local5),
                                            "type":1
                                        });
                                        candys[_local3][_local5] = candys[_local12.x][_local12.y];
                                        candys[_local12.x][_local12.y] = null;
                                        gameState = STATE_GAME_CHECK_DROP_COMPLETE;
                                        _local1 = true;
                                    }
                                }
                            }
                        }
                    }
                    _local4++;
                }
                _local3--;
            }
            return (_local1);
        }

        private function checkIsUpPosition(_arg1:int, _arg2:int):Boolean
        {
            var _local5:int;
            var _local3:Array = currentLevel.tile;
            var _local4:int;
            while (_local4 < GameConst.COL_COUNT)
            {
                _local5 = 0;
                while (_local5 < GameConst.ROW_COUNT)
                {
                    if (_local3[_local5][_local4] != 0)
                    {
                        if ((((_arg1 == _local5)) && ((_arg2 == _local4))))
                        {
                            return true;
                        }
                        break;
                    }
                    _local5++;
                }
                _local4++;
            }
            return false;
        }

        private function getCandyCanDropPos(_arg1:int, _arg2:int):Point
        {
            var _local3:int = (_arg1 - 1);
            if (_local3 < 0)
            {
                return (null);
            }
            if (((((!((candys[_local3][_arg2] == null))) && (!(checkIsBlock(_local3, _arg2))))) && (!(hasIronWire(_local3, _arg2, 2)))))
            {
                return (new Point(_local3, _arg2));
            }
            if (((((!((ices[_local3][_arg2] == null))) || (locks[_local3][_arg2]))) || (hasIronWire(_local3, _arg2, 2))))
            {
                if (((((((_arg2 - 1) >= 0)) && (!((candys[_local3][(_arg2 - 1)] == null))))) && (!(checkIsBlock(_local3, (_arg2 - 1))))))
                {
                    return (new Point(_local3, (_arg2 - 1)));
                }
                if (((((((_arg2 + 1) < GameConst.COL_COUNT)) && (!((candys[_local3][(_arg2 + 1)] == null))))) && (!(checkIsBlock(_local3, (_arg2 + 1))))))
                {
                    return (new Point(_local3, (_arg2 + 1)));
                }
            }
            else
            {
                if (currentLevel.tile[_local3][_arg2] == 0)
                {
                    return (getCandyCanDropPos(_local3, _arg2));
                }
            }
            return (null);
        }

        private function getTransportCandy(_arg1:int):Candy
        {
            var _local5:int;
            var _local6:int;
            var _local2:int = (_arg1 - 9);
            var _local3:Array = currentLevel.entryAndExit;
            var _local4:int;
            while (_local4 < GameConst.ROW_COUNT)
            {
                _local5 = 0;
                while (_local5 < GameConst.COL_COUNT)
                {
                    _local6 = _local3[_local4][_local5];
                    if (_local6 == _local2)
                    {
                        if (candys[_local4][_local5] != null)
                        {
                            return (candys[_local4][_local5]);
                        }
                    }
                    _local5++;
                }
                _local4++;
            }
            return (null);
        }

        private function checkIsBlock(_arg1:int, _arg2:int):Boolean
        {
            if (((((((((!((ices[_arg1][_arg2] == null))) || (!((locks[_arg1][_arg2] == null))))) || (!((stones[_arg1][_arg2] == null))))) || (!((eats[_arg1][_arg2] == null))))) || (!((monsters[_arg1][_arg2] == null)))))
            {
                return true;
            }
            return false;
        }

        private function checkConnectable():Array
        {
            var _local2:Array;
            var _local5:int;
            var _local1:Array = candys;
            var _local3:Array = [];
            var _local4:int;
            while (_local4 < GameConst.ROW_COUNT)
            {
                _local5 = 0;
                while (_local5 < GameConst.COL_COUNT)
                {
                    if (_local1[_local4][_local5] != null)
                    {
                        _local2 = checkMatches([_local4, _local5], [0, 1], [0, 2], [[0, 3], [-1, 2], [1, 2]]);
                        if (_local2.length >= 1)
                        {
                            _local2.unshift(candys[_local4][(_local5 + 2)]);
                            _local3.push(_local2);
                        }
                        _local2 = checkMatches([_local4, _local5], [0, 1], [0, -1], [[0, -2], [-1, -1], [1, -1]]);
                        if (_local2.length >= 1)
                        {
                            _local2.unshift(candys[_local4][(_local5 - 1)]);
                            _local3.push(_local2);
                        }
                        _local2 = checkMatches([_local4, _local5], [0, 2], [0, 1], [[-1, 1], [1, 1]]);
                        if (_local2.length >= 1)
                        {
                            _local2.unshift(candys[_local4][(_local5 + 1)]);
                            _local3.push(_local2);
                        }
                        _local2 = checkMatches([_local4, _local5], [1, 0], [2, 0], [[3, 0], [2, -1], [2, 1]]);
                        if (_local2.length >= 1)
                        {
                            _local2.unshift(candys[(_local4 + 2)][_local5]);
                            _local3.push(_local2);
                        }
                        _local2 = checkMatches([_local4, _local5], [1, 0], [-1, 0], [[-2, 0], [-1, -1], [-1, 1]]);
                        if (_local2.length >= 1)
                        {
                            _local2.unshift(candys[(_local4 - 1)][_local5]);
                            _local3.push(_local2);
                        }
                        _local2 = checkMatches([_local4, _local5], [2, 0], [1, 0], [[1, -1], [1, 1]]);
                        if (_local2.length >= 3)
                        {
                            _local2.unshift(candys[(_local4 + 1)][_local5]);
                            _local3.push(_local2);
                        }
                    }
                    _local5++;
                }
                _local4++;
            }
            return (_local3);
        }

        private function checkMatches(_arg1:Array, _arg2:Array, _arg3:Array, _arg4:Array):Array
        {
            var _local14:int;
            var _local15:int;
            var _local5:Array = candys;
            var _local6:Array = [];
            var _local7:int = _arg1[0];
            var _local8:int = _arg1[1];
            var _local9:int = (_local7 + _arg2[0]);
            var _local10:int = (_local8 + _arg2[1]);
            var _local11:int = (_local7 + _arg3[0]);
            var _local12:int = (_local8 + _arg3[1]);
            if (!isValidPos(_local9, _local10))
            {
                return (_local6);
            }
            if (_local5[_local9][_local10] == null)
            {
                return (_local6);
            }
            if (_local5[_local9][_local10].color != _local5[_local7][_local8].color)
            {
                return (_local6);
            }
            if (!isValidPos(_local11, _local12))
            {
                return (_local6);
            }
            if (_local5[_local11][_local12] == null)
            {
                return (_local6);
            }
            if (checkIsBlock(_local11, _local12))
            {
                return (_local6);
            }
            var _local13:int;
            while (_local13 < _arg4.length)
            {
                _local14 = (_arg4[_local13][0] + _local7);
                _local15 = (_arg4[_local13][1] + _local8);
                if (((isValidPos(_local14, _local15)) && (!((_local5[_local14][_local15] == null)))))
                {
                    if ((((_local5[_local7][_local8].color == _local5[_local14][_local15].color)) && (!(checkIsBlock(_local14, _local15)))))
                    {
                        _local6.push(_local5[_local14][_local15]);
                    }
                }
                _local13++;
            }
            return (_local6);
        }

        private function getNearIce(_arg1:int, _arg2:int):Array
        {
            var _local6:int;
            var _local7:int;
            var _local3:Array = [];
            var _local4:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]];
            var _local5:int;
            while (_local5 < _local4.length)
            {
                _local6 = (_arg1 + _local4[_local5][0]);
                _local7 = (_arg2 + _local4[_local5][1]);
                if (isValidPos(_local6, _local7))
                {
                    if (ices[_local6][_local7] != null)
                    {
                        _local3.push(ices[_local6][_local7]);
                    }
                }
                _local5++;
            }
            return (_local3);
        }

        private function getNearStone(_arg1:int, _arg2:int):Array
        {
            var _local6:int;
            var _local7:int;
            var _local3:Array = [];
            var _local4:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]];
            var _local5:int;
            while (_local5 < _local4.length)
            {
                _local6 = (_arg1 + _local4[_local5][0]);
                _local7 = (_arg2 + _local4[_local5][1]);
                if (isValidPos(_local6, _local7))
                {
                    if (stones[_local6][_local7] != null)
                    {
                        _local3.push(stones[_local6][_local7]);
                    }
                }
                _local5++;
            }
            return (_local3);
        }

        private function getNearEat(_arg1:int, _arg2:int):Array
        {
            var _local6:int;
            var _local7:int;
            var _local3:Array = [];
            var _local4:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]];
            var _local5:int;
            while (_local5 < _local4.length)
            {
                _local6 = (_arg1 + _local4[_local5][0]);
                _local7 = (_arg2 + _local4[_local5][1]);
                if (isValidPos(_local6, _local7))
                {
                    if (eats[_local6][_local7] != null)
                    {
                        _local3.push(eats[_local6][_local7]);
                    }
                }
                _local5++;
            }
            return (_local3);
        }

        private function getNearMonster(_arg1:int, _arg2:int):Array
        {
            var _local6:int;
            var _local7:int;
            var _local3:Array = [];
            var _local4:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]];
            var _local5:int;
            while (_local5 < _local4.length)
            {
                _local6 = (_arg1 + _local4[_local5][0]);
                _local7 = (_arg2 + _local4[_local5][1]);
                if (isValidPos(_local6, _local7))
                {
                    if (monsters[_local6][_local7] != null)
                    {
                        _local3.push(monsters[_local6][_local7]);
                    }
                }
                _local5++;
            }
            return (_local3);
        }

        private function getCandysByColorType(_arg1:int):Array
        {
            var _local4:int;
            var _local2:Array = [];
            var _local3:int;
            while (_local3 < GameConst.ROW_COUNT)
            {
                _local4 = 0;
                while (_local4 < GameConst.COL_COUNT)
                {
                    if (((!((candys[_local3][_local4] == null))) && ((candys[_local3][_local4].color == _arg1))))
                    {
                        _local2.push(candys[_local3][_local4]);
                    }
                    _local4++;
                }
                _local3++;
            }
            return (_local2);
        }

        private function getSpecialCandys():Array
        {
            var _local3:int;
            var _local4:Candy;
            var _local1:Array = [];
            var _local2:int;
            while (_local2 < GameConst.ROW_COUNT)
            {
                _local3 = 0;
                while (_local3 < GameConst.COL_COUNT)
                {
                    _local4 = candys[_local2][_local3];
                    if (((((!((_local4 == null))) && ((_local4.status > 0)))) && ((_local4.status < 5))))
                    {
                        _local1.push(_local4);
                    }
                    _local3++;
                }
                _local2++;
            }
            return (_local1);
        }

        private function getNormalCandys():Array
        {
            var _local3:int;
            var _local4:Candy;
            var _local1:Array = [];
            var _local2:int;
            while (_local2 < GameConst.ROW_COUNT)
            {
                _local3 = 0;
                while (_local3 < GameConst.COL_COUNT)
                {
                    _local4 = candys[_local2][_local3];
                    if (((!((_local4 == null))) && ((_local4.status == 0))))
                    {
                        _local1.push(_local4);
                    }
                    _local3++;
                }
                _local2++;
            }
            return (_local1);
        }

        private function getCandysByRowsOrCols(_arg1:Array, _arg2:Array):Array
        {
            var _local4:int;
            var _local5:int;
            var _local6:Candy;
            var _local3:Array = [];
            var _local7:int;
            while (_local7 < _arg1.length)
            {
                _local4 = _arg1[_local7];
                if (!(((_local4 < 0)) || ((_local4 >= GameConst.ROW_COUNT))))
                {
                    _local5 = 0;
                    while (_local5 < GameConst.COL_COUNT)
                    {
                        _local6 = candys[_local4][_local5];
                        if (((!((_local6 == null))) && (!(_local6.isFruit()))))
                        {
                            _local3.push(_local6);
                        }
                        _local5++;
                    }
                }
                _local7++;
            }
            _local7 = 0;
            while (_local7 < _arg2.length)
            {
                _local5 = _arg2[_local7];
                if (!(((_local5 < 0)) || ((_local5 >= GameConst.COL_COUNT))))
                {
                    _local4 = 0;
                    while (_local4 < GameConst.ROW_COUNT)
                    {
                        _local6 = candys[_local4][_local5];
                        if (((!((_local6 == null))) && (!(_local6.isFruit()))))
                        {
                            _local3.push(_local6);
                        }
                        _local4++;
                    }
                }
                _local7++;
            }
            return (_local3);
        }

        private function getRelativeCandysByStatus(_arg1:Candy):Array
        {
            if (_arg1.status == CandySpecialStatus.HORIZ)
            {
                return (getCandysByRow(_arg1.row));
            }
            if (_arg1.status == CandySpecialStatus.VERT)
            {
                return (getCandysByCol(_arg1.col));
            }
            if (_arg1.status == CandySpecialStatus.BOMB)
            {
                return (getAroundCandys(_arg1.row, _arg1.col));
            }
            return ([]);
        }

        private function getCandysByRow(_arg1:int):Array
        {
            var _local2:Array = [];
            var _local3:int;
            while (_local3 < GameConst.COL_COUNT)
            {
                _local2.push(new Point(_arg1, _local3));
                _local3++;
            }
            return (_local2);
        }

        private function getCandysByCol(_arg1:int):Array
        {
            var _local2:Array = [];
            var _local3:int;
            while (_local3 < GameConst.ROW_COUNT)
            {
                _local2.push(new Point(_local3, _arg1));
                _local3++;
            }
            return (_local2);
        }

        private function getAroundCandys(_arg1:int, _arg2:int):Array
        {
            var _local6:int;
            var _local7:int;
            var _local3:Array = [[0, -1], [0, -2], [0, 1], [0, 2], [-1, 0], [-2, 0], [1, 0], [2, 0], [1, -1], [1, 1], [-1, -1], [-1, 1]];
            var _local4:Array = [];
            var _local5:int;
            while (_local5 < _local3.length)
            {
                _local6 = (_arg1 + _local3[_local5][0]);
                _local7 = (_arg2 + _local3[_local5][1]);
                if ((((((((_local6 > 0)) && ((_local6 < GameConst.ROW_COUNT)))) && ((_local7 > 0)))) && ((_local7 < GameConst.COL_COUNT))))
                {
                    _local4.push(new Point(_local6, _local7));
                }
                _local5++;
            }
            return (_local4);
        }

        private function getAroundCandys2(_arg1:Candy, _arg2:Candy):Array
        {
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:Point;
            var _local9:Point;
            var _local10:Candy;
            var _local3:Array = [];
            if (_arg1.row == _arg2.row)
            {
                if (_arg1.col < _arg2.col)
                {
                    _local8 = new Point(_arg1.row, _arg1.col);
                    _local9 = new Point(_arg2.row, _arg2.col);
                }
                else
                {
                    _local8 = new Point(_arg2.row, _arg2.col);
                    _local9 = new Point(_arg1.row, _arg1.col);
                }
                _local4 = 0;
                while (_local4 >= -3)
                {
                    _local6 = ((_local8.x - 3) - _local4);
                    _local7 = ((_local8.x + 3) + _local4);
                    _local5 = _local6;
                    while (_local5 <= _local7)
                    {
                        if (isValidPos(_local5, (_local8.y + _local4)))
                        {
                            _local10 = candys[_local5][(_local8.y + _local4)];
                            if (_local10 != null)
                            {
                                _local3.push(_local10);
                            }
                        }
                        _local5++;
                    }
                    _local4--;
                }
                _local4 = 0;
                while (_local4 <= 3)
                {
                    _local6 = ((_local9.x - 3) + _local4);
                    _local7 = ((_local9.x + 3) - _local4);
                    _local5 = _local6;
                    while (_local5 <= _local7)
                    {
                        if (isValidPos(_local5, (_local9.y + _local4)))
                        {
                            _local10 = candys[_local5][(_local9.y + _local4)];
                            if (_local10 != null)
                            {
                                _local3.push(_local10);
                            }
                        }
                        _local5++;
                    }
                    _local4++;
                }
            }
            else
            {
                if (_arg1.col == _arg2.col)
                {
                    if (_arg1.row < _arg2.row)
                    {
                        _local8 = new Point(_arg1.row, _arg1.col);
                        _local9 = new Point(_arg2.row, _arg2.col);
                    }
                    else
                    {
                        _local8 = new Point(_arg2.row, _arg2.col);
                        _local9 = new Point(_arg1.row, _arg1.col);
                    }
                    _local4 = 0;
                    while (_local4 >= -3)
                    {
                        _local6 = ((_local8.y - 3) - _local4);
                        _local7 = ((_local8.y + 3) + _local4);
                        _local5 = _local6;
                        while (_local5 <= _local7)
                        {
                            if (isValidPos((_local8.x + _local4), _local5))
                            {
                                _local10 = candys[(_local8.x + _local4)][_local5];
                                if (_local10 != null)
                                {
                                    _local3.push(_local10);
                                }
                            }
                            _local5++;
                        }
                        _local4--;
                    }
                    _local4 = 0;
                    while (_local4 <= 3)
                    {
                        _local6 = ((_local9.y - 3) + _local4);
                        _local7 = ((_local9.y + 3) - _local4);
                        _local5 = _local6;
                        while (_local5 <= _local7)
                        {
                            if (isValidPos((_local9.x + _local4), _local5))
                            {
                                _local10 = candys[(_local9.x + _local4)][_local5];
                                if (_local10 != null)
                                {
                                    _local3.push(_local10);
                                }
                            }
                            _local5++;
                        }
                        _local4++;
                    }
                }
            }
            return (_local3);
        }

        private function isValidPos(_arg1:int, _arg2:int):Boolean
        {
            if ((((((((_arg1 >= 0)) && ((_arg1 < GameConst.ROW_COUNT)))) && ((_arg2 >= 0)))) && ((_arg2 < GameConst.COL_COUNT))))
            {
                return true;
            }
            return false;
        }

        private function getAllCandys():Array
        {
            var _local3:int;
            var _local1:Array = [];
            var _local2:int;
            while (_local2 < GameConst.ROW_COUNT)
            {
                _local3 = 0;
                while (_local3 < GameConst.COL_COUNT)
                {
                    if (candys[_local2][_local3] != null)
                    {
                        _local1.push(candys[_local2][_local3]);
                    }
                    _local3++;
                }
                _local2++;
            }
            return (_local1);
        }

        private function getFruits():Array
        {
            var _local3:int;
            var _local4:Candy;
            var _local1:Array = [];
            var _local2:int;
            while (_local2 < GameConst.ROW_COUNT)
            {
                _local3 = 0;
                while (_local3 < GameConst.COL_COUNT)
                {
                    _local4 = candys[_local2][_local3];
                    if (((!((_local4 == null))) && (_local4.isFruit())))
                    {
                        if (_local4.color == ColorType.FRUIT1)
                        {
                            _local1.push(AimType.FRUIT1);
                        }
                        else
                        {
                            if (_local4.color == ColorType.FRUIT2)
                            {
                                _local1.push(AimType.FRUIT2);
                            }
                            else
                            {
                                if (_local4.color == ColorType.FRUIT3)
                                {
                                    _local1.push(AimType.FRUIT3);
                                }
                            }
                        }
                    }
                    _local3++;
                }
                _local2++;
            }
            return (_local1);
        }

        private function checkNeedDropFruit():void
        {
            var _local1:Array = getFruits();
            var _local2:Array = Model.gameModel.getLeftFruitAim(_local1);
            if (_local2.length > 0)
            {
                addFruitIndex++;
                if (addFruitIndex == 1)
                {
                    nextFruitId = _local2[int((Math.random() * _local2.length))];
                }
                else
                {
                    if (_local1.length == 0)
                    {
                        nextFruitId = _local2[int((Math.random() * _local2.length))];
                    }
                    else
                    {
                        if (addFruitIndex >= 10)
                        {
                            addFruitIndex = 0;
                        }
                    }
                }
            }
        }

        private function getEatAndAroundCandys():Array
        {
            var _local2:Eat;
            var _local5:int;
            var _local1:Array = [];
            var _local3:int;
            while (_local3 < GameConst.ROW_COUNT)
            {
                _local5 = 0;
                while (_local5 < GameConst.COL_COUNT)
                {
                    _local2 = eats[_local3][_local5];
                    if (_local2 != null)
                    {
                        _local1.push(_local2);
                    }
                    _local5++;
                }
                _local3++;
            }
            var _local4:Array = [];
            for each (_local2 in _local1)
            {
                if (((((isValidPos((_local2.row - 1), _local2.col)) && (!((candys[(_local2.row - 1)][_local2.col] == null))))) && (!(checkIsBlock((_local2.row - 1), _local2.col)))))
                {
                    _local4.push({
                        "eat":_local2,
                        "pos":new Point((_local2.row - 1), _local2.col)
                    });
                }
                if (((((isValidPos((_local2.row + 1), _local2.col)) && (!((candys[(_local2.row + 1)][_local2.col] == null))))) && (!(checkIsBlock((_local2.row + 1), _local2.col)))))
                {
                    _local4.push({
                        "eat":_local2,
                        "pos":new Point((_local2.row + 1), _local2.col)
                    });
                }
                if (((((isValidPos(_local2.row, (_local2.col - 1))) && (!((candys[_local2.row][(_local2.col - 1)] == null))))) && (!(checkIsBlock(_local2.row, (_local2.col - 1))))))
                {
                    _local4.push({
                        "eat":_local2,
                        "pos":new Point(_local2.row, (_local2.col - 1))
                    });
                }
                if (((((isValidPos(_local2.row, (_local2.col + 1))) && (!((candys[_local2.row][(_local2.col + 1)] == null))))) && (!(checkIsBlock(_local2.row, (_local2.col + 1))))))
                {
                    _local4.push({
                        "eat":_local2,
                        "pos":new Point(_local2.row, (_local2.col + 1))
                    });
                }
            }
            return (_local4);
        }

        private function getMonsterAndAroundCandys():Array
        {
            var _local2:Monster;
            var _local5:int;
            var _local1:Array = [];
            var _local3:int;
            while (_local3 < GameConst.ROW_COUNT)
            {
                _local5 = 0;
                while (_local5 < GameConst.COL_COUNT)
                {
                    _local2 = monsters[_local3][_local5];
                    if (_local2 != null)
                    {
                        _local1.push(_local2);
                    }
                    _local5++;
                }
                _local3++;
            }
            var _local4:Array = [];
            for each (_local2 in _local1)
            {
                if (((((isValidPos((_local2.row - 1), _local2.col)) && (!((candys[(_local2.row - 1)][_local2.col] == null))))) && ((monsters[(_local2.row - 1)][_local2.col] == null))))
                {
                    _local4.push({
                        "monster":_local2,
                        "pos":new Point((_local2.row - 1), _local2.col)
                    });
                }
                if (((((isValidPos((_local2.row + 1), _local2.col)) && (!((candys[(_local2.row + 1)][_local2.col] == null))))) && ((monsters[(_local2.row + 1)][_local2.col] == null))))
                {
                    _local4.push({
                        "monster":_local2,
                        "pos":new Point((_local2.row + 1), _local2.col)
                    });
                }
                if (((((isValidPos(_local2.row, (_local2.col - 1))) && (!((candys[_local2.row][(_local2.col - 1)] == null))))) && ((monsters[_local2.row][(_local2.col - 1)] == null))))
                {
                    _local4.push({
                        "monster":_local2,
                        "pos":new Point(_local2.row, (_local2.col - 1))
                    });
                }
                if (((((isValidPos(_local2.row, (_local2.col + 1))) && (!((candys[_local2.row][(_local2.col + 1)] == null))))) && ((monsters[_local2.row][(_local2.col + 1)] == null))))
                {
                    _local4.push({
                        "monster":_local2,
                        "pos":new Point(_local2.row, (_local2.col + 1))
                    });
                }
            }
            return (_local4);
        }

        private function shuffle(_arg1:Boolean=false):void
        {
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:Candy;
            var _local9:Candy;
            var _local10:int;
            var _local11:int;
            var _local12:int;
            var _local13:Candy;
            var _local14:Point;
            Debug.log("洗牌");
            var _local2:Array = getAllCandys();
            var _local3:int;
            while (true)
            {
                _local5 = 0;
                while (_local5 < 20)
                {
                    _local6 = int((Math.random() * _local2.length));
                    _local7 = int((Math.random() * _local2.length));
                    if (_local6 != _local7)
                    {
                        _local8 = _local2[_local6];
                        _local9 = _local2[_local7];
                        _local10 = _local8.row;
                        _local8.row = _local9.row;
                        _local9.row = _local10;
                        _local11 = _local8.col;
                        _local8.col = _local9.col;
                        _local9.col = _local11;
                        candys[_local8.row][_local8.col] = _local8;
                        candys[_local9.row][_local9.col] = _local9;
                    }
                    _local5++;
                }
                _local3 = (_local3 + 1);
                if (((!(checkHasMatches())) && ((checkConnectable().length > 0)))) break;
            }
            Debug.log(("洗牌次数:" + _local3));
            var _local4:int;
            while (_local4 < GameConst.ROW_COUNT)
            {
                _local12 = 0;
                while (_local12 < GameConst.COL_COUNT)
                {
                    _local13 = candys[_local4][_local12];
                    if (_local13 != null)
                    {
                        if (_arg1)
                        {
                            moveToRightPos(_local13);
                        }
                        else
                        {
                            _local14 = getCandyPosition(_local4, _local12);
                            _local13.x = _local14.x;
                            _local13.y = _local14.y;
                        }
                    }
                    _local12++;
                }
                _local4++;
            }
        }

        private function moveToRightPos(_arg1:Candy, _arg2:Function=null):void
        {
            var _local3:Point = getCandyPosition(_arg1.row, _arg1.col);
            var _local4:Number = Math.abs((_local3.y - _arg1.y));
            var _local5:Number = Math.abs((_local3.x - _arg1.x));
            var _local6:Number = Math.sqrt(((_local5 * _local5) + (_local4 * _local4)));
            var _local7:Number = ((_local6 / GameConst.CARD_W) * 0.1);
            Tweener.addTween(_arg1, {
                "x":_local3.x,
                "y":_local3.y,
                "time":_local7,
                "transition":"linear",
                "delay":0.5
            });
        }

        private function handleVictory():void
        {
            var _local1:Array = getSpecialCandys();
            if (_local1.length > 0)
            {
                queueToBouns();
            }
            else
            {
                if (Model.gameModel.step > 0)
                {
                    doBounsTimeEffect();
                }
                else
                {
                    Debug.log("弹出胜利结算面板");
                    Model.gameModel.isSuccess = true;
                    MsgDispatcher.execute(GameEvents.OPEN_GAME_END_UI);
                }
            }
        }

        private function handleFailed():void
        {
            Debug.log("弹出失败结算面板");
            Model.gameModel.isSuccess = false;
            MsgDispatcher.execute(GameEvents.OPEN_GAME_END_UI);
        }

        private function queueToBouns():void
        {
            Tweener.addCaller(this, {
                "time":0.2,
                "count":1,
                "onComplete":function ():void
                {
                    var _local2:*;
                    var _local3:*;
                    var _local1:* = getSpecialCandys();
                    if (_local1.length > 0)
                    {
                        _local2 = int((Math.random() * _local1.length));
                        _local3 = _local1[_local2];
                        removeCandys([_local3]);
                        gameState = STATE_GAME_WAIT_DROP;
                    }
                }
            });
        }

        private function doBounsTimeEffect():void
        {
            var bonusTip:BonusTimeTip = BonusTimeTip.pool.take();
            addChild(bonusTip);
            bonusTip.doAniamtion();
            setTimeout(function ():void
            {
                var candys:Array;
                var animationCount:int;
                var i:int;
                var rnd:int;
                var candy:Candy;
                var disX:Number;
                var disY:Number;
                var dis:Number;
                var radian:Number;
                var laserEffect:LaserEffect;
                if (Model.gameModel.step > 0)
                {
                    candys = getNormalCandys();
                    if (candys.length > 0)
                    {
                        animationCount = 0;
                        i = 0;
                        while (i < Model.gameModel.step)
                        {
                            rnd = (Math.random() * candys.length);
                            candy = candys[rnd];
                            disX = (candy.x - 100);
                            disY = (candy.y - 20);
                            dis = Math.sqrt(((disX * disX) + (disY * disY)));
                            radian = Math.atan2(disY, disX);
                            laserEffect = LaserEffect.pool.take();
                            laserEffect.x = 100;
                            laserEffect.y = 20;
                            laserEffect.setData(radian);
                            addChild(laserEffect);
                            Tweener.addTween(laserEffect, {
                                "time":(dis / 600),
                                "x":candy.x,
                                "y":candy.y,
                                "onCompleteParams":[candy, laserEffect],
                                "transition":"linear",
                                "onComplete":function (_arg1:Candy, _arg2:LaserEffect):void
                                {
                                    _arg2.removeFromParent();
                                    LaserEffect.pool.put(_arg2);
                                    var _local3:* = ((Math.random() * 3) + 1);
                                    _arg1.setSpecialStatus(_local3, true);
                                    candys.splice(rnd, 1);
                                    animationCount++;
                                    if (animationCount == Model.gameModel.step)
                                    {
                                        Model.gameModel.step = 0;
                                        queueToBouns();
                                    }
                                }
                            });
                            i = (i + 1);
                        }
                    }
                }
            }, 1200);
        }

        private function addScoreTip(_arg1:int, _arg2:int, _arg3:int, _arg4:int):void
        {
            var _local5:ScoreTip = (ScoreTip.pool.take() as ScoreTip);
            _local5.x = _arg1;
            _local5.y = _arg2;
            _local5.setData(_arg3, _arg4);
            addChild(_local5);
        }

        private function addGoodTip(_arg1:int):void
        {
            var _local2:GoodTip = GoodTip.pool.take();
            _local2.x = (Core.stage3DManager.canvasWidth >> 1);
            _local2.y = ((Core.stage3DManager.canvasHeight >> 1) + 40);
            _local2.setType(_arg1);
            addChild(_local2);
        }

        private function addEffect(_arg1:int, _arg2:int, _arg3:int):void
        {
            var _local4:BombNormalEffect;
            var _local5:LineBombEffect;
            var _local6:LineBombEffect;
            var _local7:BombEffect;
            if (_arg1 == 0)
            {
                _local4 = BombNormalEffect.pool.take();
                _local4.x = _arg2;
                _local4.y = _arg3;
                _local4.play();
                addChild(_local4);
            }
            else
            {
                if (_arg1 == 1)
                {
                    _local5 = LineBombEffect.pool.take();
                    _local5.x = _arg2;
                    _local5.y = _arg3;
                    _local5.play(1);
                    addChild(_local5);
                }
                else
                {
                    if (_arg1 == 2)
                    {
                        _local6 = LineBombEffect.pool.take();
                        _local6.x = _arg2;
                        _local6.y = _arg3;
                        _local6.play(2);
                        addChild(_local6);
                    }
                    else
                    {
                        if (_arg1 == 3)
                        {
                            _local7 = BombEffect.pool.take();
                            _local7.x = _arg2;
                            _local7.y = _arg3;
                            _local7.play();
                            addChild(_local7);
                        }
                        else
                        {
                            if (_arg1 == 4)
                            {
                            }
                        }
                    }
                }
            }
        }

        private function removeAll():void
        {
            var _local1:int;
            var _local2:int;
            var _local3:int;
            var _local4:TileBoarder;
            removeEventListener(EnterFrameEvent.ENTER_FRAME, update);
            Core.timerManager.remove(this, onTimer);
            removeAllElements(candys, Candy.pool);
            removeAllElements(tileBgs, TileBg.pool);
            removeAllElements(bricks, Brick.pool);
            removeAllElements(locks, Lock.pool);
            removeAllElements(eats, Eat.pool);
            removeAllElements(ices, Ice.pool);
            removeAllElements(monsters, Monster.pool);
            removeAllElements(tDoors, TransportDoor.pool);
            removeAllElements(ironWires, IronWire.pool);
            _local3 = (tileBoarders.length - 1);
            while (_local3 >= 0)
            {
                _local4 = tileBoarders[_local3];
                TileBoarder.pool.put(_local4);
                _local4.removeFromParent();
                tileBoarders.splice(_local3, 1);
                _local3--;
            }
            Model.gameModel.reset();
        }

        private function removeAllElements(_arg1:Array, _arg2:BasePool):void
        {
            var _local4:int;
            var _local5:Element;
            var _local3:int;
            while (_local3 < GameConst.ROW_COUNT)
            {
                _local4 = 0;
                while (_local4 < GameConst.COL_COUNT)
                {
                    _local5 = _arg1[_local3][_local4];
                    if (_local5 != null)
                    {
                        _local5.reset();
                        _arg2.put(_local5);
                        _local5.removeFromParent();
                        _arg1[_local3][_local4] = null;
                    }
                    _local4++;
                }
                _local3++;
            }
        }

        private function handleGuide():void
        {
            if (Model.levelModel.selectedLevel == 1)
            {
                if ((((((selectedCard == candys[2][2])) && ((aimCard == candys[2][1])))) || ((((aimCard == candys[2][2])) && ((selectedCard == candys[2][1]))))))
                {
                    GuideManager.instance.nextStep();
                }
                else
                {
                    if ((((((selectedCard == candys[2][7])) && ((aimCard == candys[2][6])))) || ((((aimCard == candys[2][7])) && ((selectedCard == candys[2][6]))))))
                    {
                        GuideManager.instance.nextStep();
                    }
                }
            }
            else
            {
                if (Model.levelModel.selectedLevel == 2)
                {
                    if ((((((selectedCard == candys[5][5])) && ((aimCard == candys[6][5])))) || ((((aimCard == candys[5][5])) && ((selectedCard == candys[6][5]))))))
                    {
                        GuideManager.instance.nextStep();
                    }
                }
                else
                {
                    if (Model.levelModel.selectedLevel == 3)
                    {
                        if ((((((selectedCard == candys[2][4])) && ((aimCard == candys[3][4])))) || ((((aimCard == candys[2][4])) && ((selectedCard == candys[3][4]))))))
                        {
                            GuideManager.instance.nextStep();
                        }
                    }
                    else
                    {
                        if (Model.levelModel.selectedLevel == 4)
                        {
                            if ((((((selectedCard == candys[6][4])) && ((aimCard == candys[7][4])))) || ((((aimCard == candys[6][4])) && ((selectedCard == candys[7][4]))))))
                            {
                                GuideManager.instance.nextStep();
                            }
                        }
                        else
                        {
                            if (Model.levelModel.selectedLevel == 5)
                            {
                                if ((((((selectedCard == candys[1][1])) && ((aimCard == candys[1][2])))) || ((((aimCard == candys[1][1])) && ((selectedCard == candys[1][2]))))))
                                {
                                    GuideManager.instance.nextStep();
                                }
                            }
                        }
                    }
                }
            }
        }

        public function guideProcess(_arg1:GuideVO=null):void
        {
            if (_arg1)
            {
            }
        }

        public function getComponentByName(_arg1:String):void
        {
        }

        public function guideClear():void
        {
        }

        public function get instanceName():String
        {
            return (_instanceName);
        }

        public function set instanceName(_arg1:String):void
        {
            _instanceName = _arg1;
        }

        override public function destory():void
        {
            removeAll();
            super.destory();
        }
    }
} 