
package com.popchan.sugar.modules.menu.model
{
    import com.popchan.framework.utils.DataUtil;

	/**
	 *设置 
	 * @author admin
	 * 
	 */	
    public class SettingModel 
    {

        public var sound:Boolean;
        public var music:Boolean;
        public var isWudiBan:Boolean = false;


        public function loadData():void
        {
            sound = DataUtil.readBool("sound", true);
            music = DataUtil.readBool("music", true);
        }

        public function saveData():void
        {
            DataUtil.writeBool("sound", sound);
            DataUtil.writeBool("music", music);
            DataUtil.save(DataUtil.id);
        }


    }
} 