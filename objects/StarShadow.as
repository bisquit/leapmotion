package objects
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class StarShadow extends Sprite
	{
		
		[Embed(source="../assets/images/star_shadow.png")]
		private var StarShadowImg:Class;
		
		public function StarShadow(s_x:Number, s_y:Number):void
		{
			var star_shadow_img:Bitmap = new StarShadowImg();
			star_shadow_img.scaleX = star_shadow_img.scaleY = 0.3;
			star_shadow_img.x = -star_shadow_img.width/2;
			star_shadow_img.y = -star_shadow_img.height/2;
			addChild(star_shadow_img);
			
			this.x = s_x + 10;
			this.y = s_y + 10;
		}
	}
}