
package com.popchan.sugar.modules.guide
{
    import starling.display.Sprite;
    import starling.text.TextField;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;

    public class TalkPanel extends Sprite 
    {

        private var talk_txt:TextField;

        public function TalkPanel()
        {
            ToolKit.createImage(this, Core.texturesManager.getTexture("guideboard"));
            this.talk_txt = new TextField(260, 100, "");
            this.talk_txt.fontSize = 22;
            this.talk_txt.color = 0x6C3300;
            this.talk_txt.x = 170;
            this.talk_txt.y = 40;
            addChild(this.talk_txt);
        }

        public function setContent(_arg1:String):void
        {
            this.talk_txt.text = _arg1;
        }


    }
}//package com.popchan.sugar.modules.guide
