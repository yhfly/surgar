
package com.popchan.sugar.modules.menu.model
{
    import com.popchan.framework.utils.DataUtil;

    public class SettingModel 
    {

        public var sound:Boolean;
        public var music:Boolean;
        public var isWudiBan:Boolean = false;


        public function loadData():void
        {
            this.sound = DataUtil.readBool("sound", true);
            this.music = DataUtil.readBool("music", true);
        }

        public function saveData():void
        {
            DataUtil.writeBool("sound", this.sound);
            DataUtil.writeBool("music", this.music);
            DataUtil.save(DataUtil.id);
        }


    }
}//package com.popchan.sugar.modules.menu.model
