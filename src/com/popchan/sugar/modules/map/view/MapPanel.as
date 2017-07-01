
package com.popchan.sugar.modules.map.view
{
    import com.popchan.sugar.modules.BasePanel3D;
    import feathers.controls.ScrollContainer;
    import starling.display.Image;
    import com.popchan.framework.utils.ToolKit;
    import starling.text.TextField;
    import com.popchan.framework.core.Core;
    import com.popchan.sugar.modules.menu.view.SettingPanel;
    import starling.display.Button;
    import com.popchan.sugar.core.Model;
    import starling.events.Event;
    import com.popchan.framework.manager.SoundManager;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.sugar.core.events.GameEvents;

	/**
	 *  地图 
	 * @author admin
	 * 
	 */	
    public class MapPanel extends BasePanel3D 
    {

		public static const MAX_LEVEL:int = 330;
        private var lvItems:Array;
        private var container:ScrollContainer;
        private var posX:Array;
        private var posY:Array;
        private var maps:Array;
        private var lastPosition:Number = 0;

        public function MapPanel()
        {
            lvItems = [];
            posX = [449, 366, 230, 200, 315, 439, 562, 597, 508, 384, 246, 111, 94, 212, 332, 449, 482, 418, 465, 551, 562, 439, 329, 221, 163, 0xFF, 380, 499, 577, 499, 380, 237, 136, 136, 237, 374, 551, 401, 285, 180, 152, 280, 430, 534, 453, 305, 186, 246, 380, 499, 544, 430, 290, 168, 204, 323, 455, 551, 451, 282, 140, 129, 250, 406, 520, 564, 495, 351, 209, 163, 228, 326];
            posY = [637, 542, 479, 370, 323, 323, 299, 199, 112, 131, 168, 131, 22, -36, -61, -99, -197, -273, -480, -541, -633, -662, -666, -684, -768, -839, -863, -891, -974, -1078, -1091, -1091, -1123, -1229, -1294, -1338, -1539, -1584, -1615, -1665, -1791, -1854, -1885, -1985, -2079, -2104, -2142, -2248, -2278, -2332, -2445, -2492, -2513, -2555, -2674, -2720, -2752, -2827, -2911, -2927, -2951, -3061, -3114, -3151, -3226, -3328, -3428, -3418, -3403, -3514, -3620, -3708];
            maps = [];
            super();
        }

        override public function init():void
        {
            var i:int;
            var mapId:int;
            var image:Image;
            var textField:TextField = ToolKit.createTextField(this, 200, 30, 295, 780, 18);
            textField.pivotX = 100;
            textField.pivotY = 15;
            textField.text = "v1.0 by fish";
            container = new ScrollContainer();
            container.addEventListener("scrollComplete", onScrollComplete);
            container.clipContent = true;
            addChild(container);
            var mapCnt:int = Math.ceil((330 / 18));
            i = 1;
            while (i <= mapCnt)
            {
                mapId = (((i - 1) % 4) + 1);
                image = new Image(Core.texturesManager.getTexture(("map_" + mapId)));
                image.x = 0;
                image.y = ((-((i - 1)) * 1136) - 336);
                image.height = (image.height + 1);
                container.addChild(image);
                maps.push(image);
                i++;
            }
            ToolKit.createImage(container, Core.texturesManager.getTexture("map_0"), 0, 671);
            ToolKit.createImage(container, Core.texturesManager.getTexture("cloud"), 0, ((-1136 * (mapCnt - 1)) - 336));
            var _local4:SettingPanel = new SettingPanel();
            addChild(_local4);
			
			
            var button:Button = ToolKit.createButton(this, Core.texturesManager.getTexture("showoff"), 250, 616, onShowoffBtnTouch);
            button.scaleX = (button.scaleY = 0.8);
        }

        private function onShowoffBtnTouch():void
        {
            var _local1:Number = Model.levelModel.getTotalScore();
//            SugarCrush.getInstance().submitsocre(_local1);
			Model.gameModel.isSuccess = true;
			MsgDispatcher.execute(GameEvents.OPEN_GAME_END_UI);
			
        }

        override public function show(_arg1:*):void
        {
            var levelItem:LevelItem;
            var level:int;
            super.show(_arg1);
            level = (lvItems.length - 1);
            while (level >= 0)
            {
                levelItem = lvItems[level];
                levelItem.btn.removeEventListener(Event.TRIGGERED, onBtnTouch);
                levelItem.removeFromParent(true);
                lvItems.splice(level, 1);
                level--;
            }
            level = 1;
            while (level <= MAX_LEVEL)
            {
                levelItem = new LevelItem(level);
                levelItem.x = posX[((level - 1) % 72)];
                levelItem.y = (posY[((level - 1) % 72)] - ((int(((level - 1) / 72)) * 1136) * 4));
                levelItem.addEventListener(Event.TRIGGERED, onBtnTouch);
                lvItems.push(levelItem);
                container.addChild(levelItem);
                level++;
            }
            var _local4:Number = (posY[((Model.levelModel.currentLevel - 1) % 72)] - ((int(((Model.levelModel.currentLevel - 1) / 72)) * 1136) * 4));
            var _local5:Number = (_local4 - 400);
            if (_local5 > 0)
            {
                _local5 = 0;
            }
            if (_local5 < -11633)
            {
                _local5 = -11633;
            }
            container.scrollToPosition(0, _local5);
        }

        private function onBtnTouch(_arg1:Event):void
        {
            if (Math.abs((container.verticalScrollPosition - lastPosition)) > 10)
            {
                return;
            }
            var level:int = LevelItem(_arg1.currentTarget).levelId;
            SoundManager.instance.playSound("button_down", false);
            Model.levelModel.selectedLevel = level;
            close();
            MsgDispatcher.execute(GameEvents.OPEN_GAME_UI);
        }

        private function onScrollComplete(_arg1:Event):void
        {
            lastPosition = container.verticalScrollPosition;
        }

        private function onScroll(_arg1:Event):void
        {
            var _local2:int = container.verticalScrollPosition;
        }


    }
} 