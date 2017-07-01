package
{
	/**
	 *
	 * 请为我写上注释，以告诉其他小伙伴我是用来做什么的
	 * @author fly.liuyang
	 * 创建时间：2017-6-29 下午10:31:18
	 * 
	 */
	public class EmbedManager
	{
		
		[Embed(source="../assets/xml/FontsManager_itemMoneyFont2_cfg.xml",mimeType="application/octet-stream")]
		public static const itemMoneyFont2_cfg:Class;
		
		[Embed(source="../assets/xml/FontsManager_endHighScore_cfg.xml",mimeType="application/octet-stream")]
		public static const endHighScore_cfg:Class;
		
		[Embed(source="../assets/xml/FontsManager_levelFont_cfg.xml",mimeType="application/octet-stream")]
		public static const levelFont_cfg:Class;
		
		[Embed(source="../assets/xml/FontsManager_scoreTipFont_cfg.xml",mimeType="application/octet-stream")]
		public static const scoreTipFont_cfg:Class;
		
		[Embed(source="../assets/xml/FontsManager_lvfont_cfg.xml",mimeType="application/octet-stream")]
		public static const lvfont_cfg:Class;
		
		[Embed(source="../assets/xml/FontsManager_endScoreFont_cfg.xml",mimeType="application/octet-stream")]
		public static const endScoreFont_cfg:Class;
		
		
		//-----------------------------------------------
		
		
		
		[Embed(source="../assets/xml/GameEndPanel_exp_cfg.xml",mimeType="application/octet-stream")]
		public static const gameEndPanel_exp_cfg:Class;
		
		//---------------------------------------------
		
		[Embed(source="../assets/xml/ParticlePool_bubbleExp1_cfg.xml",mimeType="application/octet-stream")]
		public static const bubbleExp1_cfg:Class;
		
		[Embed(source="../assets/xml/ParticlePool_bubbleExp2_cfg.xml",mimeType="application/octet-stream")]
		public static const bubbleExp2_cfg:Class;
		
		[Embed(source="../assets/xml/ParticlePool_lightning_cfg.xml",mimeType="application/octet-stream")]
		public static const lightning_cfg:Class;
		
		[Embed(source="../assets/xml/ParticlePool_leafExp_cfg.xml",mimeType="application/octet-stream")]
		public static const leafExp_cfg:Class;
		
		//		[Embed(source="../assets/xml/ParticlePool_exp_cfg.xml",mimeType="application/octet-stream")]
		[Embed(source="../assets/xml/ParticlePool_leafExp_cfg.xml",mimeType="application/octet-stream")]
		public static const exp_cfg:Class;
		public function EmbedManager()
		{
		}
	}
}