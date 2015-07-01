package;

import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;
	/**
	 * ...
	 * @author neocrey
	 */
	class Bullet extends FlxSprite 
	{

		private var left_b:Int = 0;
		private var right_b:Int = 0;
		
		public function new()
		{
			super();
			this.loadGraphic("assets/bullet.png", true, true, 5, 5);			
		}

		override public function update():Void
		{
			super.update();

			if(FlxG.keys.LEFT)
			{
				left_b = 1;
				right_b = 0;
			}

			if(FlxG.keys.RIGHT)
			{
				left_b = 0;
				right_b = 1;
			}

			if(right_b == 1 && left_b == 0)
			{
				this.velocity.x = 1000;
			}
			if(left_b == 1 && right_b == 0)
			{
				this.velocity.x = -1000;
			}
		}
		
	}

