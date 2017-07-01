
package com.popchan.sugar.modules.game
{
    import com.popchan.framework.core.Core;
    import com.popchan.framework.manager.Debug;
    
    import flash.utils.Dictionary;
    
    import starling.core.Starling;
    import starling.extensions.PDParticleSystem;
    import starling.textures.Texture;

    public class ParticlePool 
    {
//		[Embed(source="assets/xml/ParticlePool_bubbleExp1_cfg.xml",mimeType="application/octet-stream")]
//        public static const bubbleExp1_cfg:Class;
//		
//		[Embed(source="assets/xml/ParticlePool_bubbleExp2_cfg.xml",mimeType="application/octet-stream")]
//        public static const bubbleExp2_cfg:Class;
//		
//		[Embed(source="assets/xml/ParticlePool_lightning_cfg.xml",mimeType="application/octet-stream")]
//        public static const lightning_cfg:Class;
//		
//		[Embed(source="assets/xml/ParticlePool_leafExp_cfg.xml",mimeType="application/octet-stream")]
//        public static const leafExp_cfg:Class;
//		
////		[Embed(source="assets/xml/ParticlePool_exp_cfg.xml",mimeType="application/octet-stream")]
//		[Embed(source="assets/xml/ParticlePool_leafExp_cfg.xml",mimeType="application/octet-stream")]
//        public static const exp_cfg:Class;

        private static var _instance:ParticlePool;

        private var particles:Dictionary;

        public function ParticlePool()
        {
            particles = new Dictionary();
            super();
        }

        public static function get instance():ParticlePool
        {
            if (_instance == null)
            {
                _instance = new (ParticlePool)();
            }
            return (_instance);
        }


        public function getParticleByType(type:int):PDParticleSystem
        {
            var pDParticleSystem:PDParticleSystem;
            var xml:XML;
            var texture:Texture;
            if (particles[type] == null)
            {
                particles[type] = [];
            }
            if (particles[type].length > 0)
            {
                return (particles[type].shift());
            }
            if (type == 1)
            {
                xml = XML(new EmbedManager.bubbleExp1_cfg());
                pDParticleSystem = new PDParticleSystem(xml, Core.texturesManager.getTexture("exp1_res"));
                Starling.juggler.add(pDParticleSystem);
            }
            else if (type == 2)
			{
				xml = XML(new EmbedManager.bubbleExp2_cfg());
				pDParticleSystem = new PDParticleSystem(xml, Core.texturesManager.getTexture("exp2_res"));
				Starling.juggler.add(pDParticleSystem);
			}
            else if (type == 3)
			{
				xml = XML(new EmbedManager.leafExp_cfg());
				pDParticleSystem = new PDParticleSystem(xml, Core.texturesManager.getTexture("leafExp"));
				Starling.juggler.add(pDParticleSystem);
			}
            else if (type == 4)
			{
				xml = XML(new EmbedManager.lightning_cfg());
				pDParticleSystem = new PDParticleSystem(xml, Core.texturesManager.getTexture("lightning"));
				Starling.juggler.add(pDParticleSystem);
			}
            else if (type == 5)
			{
				xml = XML(new EmbedManager.exp_cfg());
				pDParticleSystem = new PDParticleSystem(xml, Core.texturesManager.getTexture("followboom"));
				Starling.juggler.add(pDParticleSystem);
			}
            pDParticleSystem.tag = type;
            return pDParticleSystem;
        }

        public function returnParticle(_arg1:int, _arg2:PDParticleSystem):void
        {
            if (particles[_arg1] == null)
            {
                particles[_arg1] = [];
            }
            particles[_arg1].push(_arg2);
            Debug.log(("return type=" + _arg1), particles[_arg1].length);
        }


    }
} 