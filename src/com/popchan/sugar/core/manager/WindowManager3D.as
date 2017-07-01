
package com.popchan.sugar.core.manager
{
    import starling.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    import com.popchan.framework.core.Core;
    import com.popchan.framework.manager.Layer3DManager;
    import starling.display.Quad;
    import starling.display.Sprite;
    import com.popchan.framework.manager.Debug;
    import flash.geom.Point;
    import com.popchan.sugar.modules.BasePanel3D;
    import starling.display.DisplayObject;

    public class WindowManager3D 
    {

        private static var _instance:WindowManager3D;

        private var _windowContainer:DisplayObjectContainer;
        private var _windows:Dictionary;
        private var _loaders:Dictionary;
        private var _showlist:Dictionary;

        public function WindowManager3D()
        {
            _windows = new Dictionary();
            _loaders = new Dictionary();
            _showlist = new Dictionary();
            _windowContainer = Core.layer3DManager.take(Layer3DManager.WINDOW);
            var quad:Quad = new Quad(Core.stage3DManager.canvasWidth, Core.stage3DManager.canvasHeight, 0);
            quad.alpha = 0.5;
            quad.name = "mask";
            quad.visible = false;
            _windowContainer.addChild(quad);
        }

        public static function getInstance():WindowManager3D
        {
            if (_instance == null)
            {
                _instance = new (WindowManager3D)();
            }
            return (_instance);
        }


        public function init(_arg1:Sprite):void
        {
        }

        public function open(panelInfo:Array, showData:Object=null, isCenter:Boolean=true, pos:Point=null, modal:Boolean=false):void
        {
            var panelName:String = panelInfo[0];
            Debug.log(("Open ui:" + panelName));
            var panelCls:Class = panelInfo[1];
            if (_showlist[panelName])
            {
                return;
            }
            _showlist[panelName] = {
                "modal":modal,
                "pos":pos,
                "isCenter":isCenter,
                "showData":showData
            }
            if (!_windows[panelName])
            {
                _windows[panelName] = new (panelCls)();
                if (panelInfo.length <= 2)
                {
                    loadPanelCompleteHandler(panelInfo);
                }
            }
            else
            {
                if (_loaders[panelName] == null)
                {
                    show(panelName);
                }
            }
        }

        private function loadPanelCompleteHandler(_arg1:Array):void
        {
            var panel:BasePanel3D = _windows[_arg1[0]];
            panel.winName = _arg1[0];
            panel.init();
            if (_showlist[_arg1[0]])
            {
                show(_arg1[0]);
            }
        }

        public function show(_arg1:String):void
        {
            var _local4:DisplayObject;
            var _local2:Object = _showlist[_arg1];
            var panel:BasePanel3D = _windows[_arg1];
            if (_local2.isCenter)
            {
                panel.x = ((Core.stageManager.canvasWidth - panel.width) >> 1);
                panel.y = ((Core.stageManager.canvasHeight - panel.height) >> 1);
            }
            else
            {
                panel.x = 0;
                panel.y = 0;
            }
            if (_local2.pos != null)
            {
                panel.x = (panel.x + _local2.pos.x);
                panel.y = (panel.y + _local2.pos.y);
            }
            if (_local2.modal)
            {
                _local4 = _windowContainer.getChildByName("mask");
                if (_local4)
                {
                    _local4.visible = true;
                    _windowContainer.addChild(_local4);
                }
            }
            _windowContainer.addChild(panel);
            panel.show(_local2.showData);
        }

        public function removeWindow(_arg1:String):void
        {
            if (!remove(_arg1))
            {
                return;
            }
        }

        private function remove(_arg1:String):BasePanel3D
        {
            if (!_showlist[_arg1])
            {
                return (null);
            }
            _showlist[_arg1] = null;
            delete _showlist[_arg1];
            if (_loaders[_arg1])
            {
                return (null);
            }
            var basePanel3D:BasePanel3D = _windows[_arg1];
            _windowContainer.getChildByName("mask").visible = false;
            if (basePanel3D.parent)
            {
                basePanel3D.close();
                basePanel3D.parent.removeChild(basePanel3D, true);
            }
            basePanel3D.hide();
            if (basePanel3D.destoryAfterClose)
            {
                basePanel3D.destory();
                delete _windows[_arg1];
            }
            return (basePanel3D);
        }

        public function removeAll(_arg1:Boolean=false):void
        {
            var _local2:String;
            for (_local2 in _windows)
            {
                remove(_local2);
            }
        }

        public function updateData(_arg1:String, _arg2:*):void
        {
        }

        public function isShow(_arg1:String):Boolean
        {
            return (_showlist[_arg1]);
        }

        public function getPanelName(_arg1:BasePanel3D):String
        {
            var panelNam:String;
            for (panelNam in _windows)
            {
                if (_windows[panelNam] == _arg1)
                {
                    return panelNam;
                }
            }
            return null;
        }
    }
} 