
package com.popchan.sugar.modules.guide
{
    import __AS3__.vec.Vector;
    import starling.display.Sprite;
    import com.popchan.framework.core.Core;
    import com.popchan.framework.manager.Layer3DManager;
    import flash.utils.setTimeout;

    public class GuideManager 
    {

        private static var _instance:GuideManager;
        private static var _list:Vector.<GuideVO>;
        private static var _currentStep:int;

        private var _talkPanel:TalkPanel;
        private var _parent:Sprite;
        private var _maskPanel:GuideMask;
        private var _guideArrow:GuideArrow;

        public function GuideManager()
        {
            this._parent = Core.layer3DManager.take(Layer3DManager.TIP);
            this._maskPanel = new GuideMask();
            this._parent.addChild(this._maskPanel);
            this._talkPanel = new TalkPanel();
            this._parent.addChild(this._talkPanel);
            this._guideArrow = new GuideArrow();
            this._parent.addChild(this._guideArrow);
        }

        public static function get instance():GuideManager
        {
            if (_instance == null)
            {
                _instance = new (GuideManager)();
            }
            return (_instance);
        }


        public function setUp(_arg1:Vector.<GuideVO>):void
        {
            _currentStep = 0;
            _list = _arg1;
        }

        public function start():void
        {
            _currentStep++;
            this.doGuide();
        }

        public function doGuide():void
        {
            if (_currentStep > _list.length)
            {
                return;
            }
            var guideVO:GuideVO = _list[(_currentStep - 1)];
            switch (guideVO.type)
            {
                case 1:
                    this._talkPanel.visible = true;
                    this._talkPanel.setContent(guideVO.content);
                    this._talkPanel.x = guideVO.x;
                    this._talkPanel.y = guideVO.y;
                    break;
                case 2:
                    this._maskPanel.visible = true;
                    this._maskPanel.createMask(guideVO.rect);
                    if (guideVO.rectAdd1 != null)
                    {
                        this._maskPanel.addMask(guideVO.rectAdd1);
                    }
                    if (guideVO.rectAdd2 != null)
                    {
                        this._maskPanel.addMask(guideVO.rectAdd2);
                    }
                    break;
                case 3:
                    setTimeout(function ():void
                    {
                        nextStep();
                    }, guideVO.value);
                    break;
                case 4:
                    this._guideArrow.visible = true;
                    this._guideArrow.x = guideVO.x;
                    this._guideArrow.y = guideVO.y;
                    this._guideArrow.moveBetween(guideVO.p1, guideVO.p2);
                    break;
                case 5:
                    this._guideArrow.visible = false;
                    this._maskPanel.visible = false;
                    this._talkPanel.visible = false;
                    break;
            }
            if (guideVO.next)
            {
                this.nextStep();
            }
        }

        public function nextStep():void
        {
            _currentStep++;
            this.doGuide();
        }


    }
}//package com.popchan.sugar.modules.guide
