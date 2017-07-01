
package com.popchan.sugar.core.cfg
{
    import com.popchan.framework.ds.Dict;
    import __AS3__.vec.Vector;
    import com.popchan.sugar.modules.guide.GuideVO;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import __AS3__.vec.*;

    public class GuideConfig 
    {

        public static var guideXML:XML = <data>
				<guide id="1">
					<step type="2" rect="96,272,256,64" next="true"/>
					<step type="1" x="100" y="100" content="交换红色和绿色的糖果,让三个相同的糖果连在一起消除它们" next="true"/>
					<step type="4" x="86" y="350" p1="116,290" p2="176,290"/>
					
					<step type="2" rect="416,272,128,192" rectAdd1="480,336,64,128" next="true"/>
					<step type="1" x="100" y="90" content="交换黄色和紫色的糖果" next="true"/>
					<step type="4" p1="500,292" p2="438,292"/>
					<step type="5" next="true"/>
					<step type="2" rect="-100,272,1,1" next="true"/>					
					<step type="1" x="100" y="90" content="收集目标数量的糖果就能通过这个关卡" next="true"/>
					<step type="3" value="3000"/>
					<step type="5"/>
				</guide>
				<guide id="2">
					<step type="2" rect="224,400,256,128" rectAdd1="224,400,128,64" rectAdd2="416,400,64,64" next="true"/>
					<step type="1" x="100" y="150" content="试试让四个相同的糖果连在一起吧！" next="true"/>					
					<step type="4" p1="376,422" p2="376,496"/>
					<step type="5"/>
				</guide>
				<guide id="3">
					<step type="2" rect="160,240,192,256" rectAdd1="160,240,128,64" rectAdd2="160,368,128,128" next="true"/>
					<step type="1" x="100" y="60" content="T型或者L型的可以生成一个炸弹，试试吧!" next="true"/>					
					<step type="4" p1="300,252" p2="300,336"/>
					<step type="5"/>
				</guide>
				<guide id="4">
					<step type="2" rect="160,496,320,128" rectAdd1="160,496,128,64" rectAdd2="352,496,128,64" next="true"/>
					<step type="1" x="100" y="220" content="5个相同颜色的糖果连在一起可以形成超级糖果哦，试试吧!" next="true"/>					
					<step type="4" p1="300,508" p2="300,592"/>
					<step type="5"/>
				</guide>
				<guide id="5">
					<step type="2" rect="96,176,128,64" next="true"/>
					<step type="1" x="30" y="270" content="特殊状态的糖果互相交换能产生特殊的效果哦，试试吧!" next="true"/>					
					<step type="4" p1="96,196" p2="192,196"/>
					<step type="5"/>
				</guide>
			</data>
        ;

        private var dict:Dict;

        public function GuideConfig()
        {
            this.dict = new Dict();
            super();
        }

        public function getGuideList(guideId:int):Vector.<GuideVO>
        {
            var _local2:XML;
            var _local3:Vector.<GuideVO>;
            var _local4:XML;
            var _local5:GuideVO;
            var _local6:Array;
            var _local7:Array;
            var _local8:Array;
            var _local9:Array;
            var _local10:Array;
            if (this.dict.contains(guideId))
            {
                return (this.dict.take(guideId));
            };
            for each (_local2 in guideXML.guide)
            {
                if (int(_local2.@id) == guideId)
                {
                    _local3 = new Vector.<GuideVO>();
                    for each (_local4 in _local2.step)
                    {
                        _local5 = new GuideVO();
                        _local5.className = _local4.@className;
                        _local5.type = _local4.@type;
                        _local5.content = _local4.@content;
                        _local5.x = _local4.@x;
                        _local5.y = _local4.@y;
                        _local5.value = _local4.@value;
                        _local5.next = (String(_local4.@next) == "true");
                        if (_local4.hasOwnProperty("@rect"))
                        {
                            _local8 = String(_local4.@rect).split(",");
                            _local5.rect = new Rectangle(int(_local8[0]), int(_local8[1]), int(_local8[2]), int(_local8[3]));
                        };
                        if (_local4.hasOwnProperty("@rectAdd1"))
                        {
                            _local9 = String(_local4.@rectAdd1).split(",");
                            _local5.rectAdd1 = new Rectangle(int(_local9[0]), int(_local9[1]), int(_local9[2]), int(_local9[3]));
                        };
                        if (_local4.hasOwnProperty("@rectAdd2"))
                        {
                            _local10 = String(_local4.@rectAdd2).split(",");
                            _local5.rectAdd2 = new Rectangle(int(_local10[0]), int(_local10[1]), int(_local10[2]), int(_local10[3]));
                        };
                        _local6 = String(_local4.@p1).split(",");
                        _local5.p1 = new Point(int(_local6[0]), int(_local6[1]));
                        _local7 = String(_local4.@p2).split(",");
                        _local5.p2 = new Point(int(_local7[0]), int(_local7[1]));
                        _local3.push(_local5);
                    };
                    this.dict.put(guideId, _local3);
                    return (_local3);
                };
            };
            return (null);
        }


    }
}//package com.popchan.sugar.core.cfg
