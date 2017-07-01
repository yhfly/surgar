
package com.popchan.sugar.core.manager
{
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class FontsManager 
    {

        public static const itemMoneyFont2_res:Class = FontsManager_itemMoneyFont2_res;
        public static const scoreTipFont_res:Class = FontsManager_scoreTipFont_res;
        public static const levelFont_res:Class = FontsManager_levelFont_res;
        public static const endHighScore_res:Class = FontsManager_endHighScore_res;
        public static const lvfont_res:Class = FontsManager_lvfont_res;
        public static const endScoreFont_res:Class = FontsManager_endScoreFont_res;
		
//		[Embed(source="assets/xml/FontsManager_itemMoneyFont2_cfg.xml",mimeType="application/octet-stream")]
//        public static const itemMoneyFont2_cfg:Class;
//		
//		[Embed(source="assets/xml/FontsManager_endHighScore_cfg.xml",mimeType="application/octet-stream")]
//        public static const endHighScore_cfg:Class;
//		
//		[Embed(source="assets/xml/FontsManager_levelFont_cfg.xml",mimeType="application/octet-stream")]
//        public static const levelFont_cfg:Class;
//		
//		[Embed(source="assets/xml/FontsManager_scoreTipFont_cfg.xml",mimeType="application/octet-stream")]
//        public static const scoreTipFont_cfg:Class;
//		
//		[Embed(source="assets/xml/FontsManager_lvfont_cfg.xml",mimeType="application/octet-stream")]
//        public static const lvfont_cfg:Class;
//		
//		[Embed(source="assets/xml/FontsManager_endScoreFont_cfg.xml",mimeType="application/octet-stream")]
//        public static const endScoreFont_cfg:Class;
		
		
        public static const FONT_ITEM_MONTY2:String = "itemMoneyFont2";
        public static const FONT_SCORETIP:String = "scoreTipFont";
        public static const FONT_LV:String = "lvfont";
        public static const FONT_LEVEL:String = "levelFont";
        public static const FONT_END_HIGH:String = "endHighScore";
        public static const FONT_END_SCORE:String = "endScoreFont";


        public static function init():void
        {
            var bitmapFont:BitmapFont = new BitmapFont(Texture.fromBitmapData(new itemMoneyFont2_res()), XML(new EmbedManager.itemMoneyFont2_cfg()));
            TextField.registerBitmapFont(bitmapFont, FONT_ITEM_MONTY2);
			bitmapFont = new BitmapFont(Texture.fromBitmapData(new scoreTipFont_res()), XML(new EmbedManager.scoreTipFont_cfg()));
            TextField.registerBitmapFont(bitmapFont, FONT_SCORETIP);
            TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmapData(new lvfont_res()), XML(new EmbedManager.lvfont_cfg())), FONT_LV);
            TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmapData(new levelFont_res()), XML(new EmbedManager.levelFont_cfg())), FONT_LEVEL);
            TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmapData(new endHighScore_res()), XML(new EmbedManager.endHighScore_cfg())), FONT_END_HIGH);
            TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmapData(new endScoreFont_res()), XML(new EmbedManager.endScoreFont_cfg())), FONT_END_SCORE);
        }


    }
}