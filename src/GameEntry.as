
package 
{
    import com.popchan.framework.core.Core;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.framework.utils.DataUtil;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.sugar.core.Model;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.core.manager.FontsManager;
    import com.popchan.sugar.core.manager.Sounds;
    import com.popchan.sugar.modules.end.EndModule;
    import com.popchan.sugar.modules.game.GameModule;
    import com.popchan.sugar.modules.guide.GuideModule;
    import com.popchan.sugar.modules.map.MapModule;
    import com.popchan.sugar.modules.menu.MenuModule;
    import com.popchan.sugar.modules.menu.view.HProgressBar;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.utils.AssetManager;

    public class GameEntry extends Sprite 
    {

        public static const loading_progress_cover:Class = GameEntry_loading_progress_cover;
        public static const loading_progress:Class = GameEntry_loading_progress;
        public static const loading_txt:Class = GameEntry_loading_txt;
        public static const logo:Class = GameEntry_logo;
        public static const bg:Class = GameEntry_bg;

        private var loadingTxt:Image;
        private var progressBar:HProgressBar;
        private var logoImg:Image;
        private var back:Image;


        public function init():void
        {
            back = ToolKit.createImage(this, Texture.fromBitmapData(new bg()), 0, 0);
            progressBar = ToolKit.createProgressBar(this, Texture.fromBitmapData(new loading_progress_cover()), Texture.fromBitmapData(new loading_progress()), 180, 340, 12, 7);
            loadingTxt = ToolKit.createImage(this, Texture.fromBitmapData(new loading_txt()), 260, 390);
            logoImg = ToolKit.createImage(this, Texture.fromBitmapData(new logo()), 200, 100);
            logoImg.scaleX = logoImg.scaleY = 0.7;
            var assetManager:AssetManager = Core.texturesManager;
//			http://flash.7k7k.com/cms/cms10/20170225/1201057261/6/assets/level/Level209.xml
            assetManager.enqueue("assets/textures/card.png?rnd=1");
            assetManager.enqueue("assets/textures/card.xml?rnd=100");
            assetManager.enqueue("assets/textures/ui02.png");
            assetManager.enqueue("assets/textures/ui02.xml");
            assetManager.enqueue("assets/textures/map.png");
            assetManager.enqueue("assets/textures/map.xml");
            assetManager.enqueue("assets/textures/menu.png");
            assetManager.enqueue("assets/textures/menu.xml");
            assetManager.enqueue("assets/effect.png");
            assetManager.enqueue("assets/effect.xml");
            assetManager.enqueue("assets/textures/gameui.png");
            assetManager.enqueue("assets/textures/gameui.xml");
            assetManager.enqueue("assets/textures/guide.png");
            assetManager.enqueue("assets/textures/guide.xml");
            assetManager.enqueue("assets/title_bg.jpg");
            assetManager.enqueue("assets/worldBg_2.png");
            assetManager.enqueue("assets/textures/game01.png");
            assetManager.enqueue("assets/textures/game01.xml");
            assetManager.enqueue("assets/textures/game02.png");
            assetManager.enqueue("assets/textures/game02.xml");
            assetManager.enqueue("assets/textures/game03.png");
            assetManager.enqueue("assets/textures/game03.xml");
            var i:int = 1;
            while (i <= 5)
            {
                assetManager.enqueue((("assets/level/Level" + i) + ".xml"));
                i++;
            }
            i = 0;
            while (i <= 4)
            {
                assetManager.enqueue((("assets/map/map_" + i) + ".png"));
                i++;
            }
            assetManager.enqueue("assets/map/cloud.png");
            assetManager.verbose = true;
            assetManager.loadQueue(onLoadProgress);
            DataUtil.id = "com.popchanniuniu.bubble410";
            DataUtil.load(DataUtil.id);
            Model.levelModel.loadData();
            Model.settingModel.loadData();
            FontsManager.init();
            Sounds.init();
            MenuModule.getInstance().init();
            GameModule.getInstance().init();
            EndModule.getInstance().init();
            MapModule.getInstance().init();
            GuideModule.getInstance().init();
        }

        private function onLoadProgress(percent:Number):void
        {
            progressBar.ratio = percent;
            if (percent == 1)
            {
                back.removeFromParent(true);
                loadingTxt.removeFromParent(true);
                progressBar.removeFromParent(true);
                logoImg.removeFromParent(true);
//                MsgDispatcher.execute(GameEvents.OPEN_MENU_UI);
//				var scoreTip:ScoreTip = new ScoreTip();
//				scoreTip.setData(432,1);
//				addChild(scoreTip);
//				scoreTip.x = 100;
//				scoreTip.y = 100;
				
				var level:int = 1;
				Model.levelModel.selectedLevel = level;
				MsgDispatcher.execute(GameEvents.OPEN_GAME_UI);
            }
        }
		

    }
} 