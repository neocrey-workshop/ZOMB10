package;

import openfl.Assets;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.util.FlxMath;

class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	private var playButton:FlxButton;

	override public function create():Void
	{
		// Set a background color
		FlxG.bgColor = 0xff000000;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end

		FlxG.play("mMusic", 1, true, true);

		playButton = new FlxButton(280, 360, "PLAY!", onPlay);
		playButton.color = 0xFFFF0000;
		playButton.label.color = 0xFFFFFFFF;
		add(playButton);

			var text:FlxText;
			text = new FlxText(60, 50, 420, "ZOMB");
			text.color = 0xffffff;
			text.alignment = "center";
			text.size = 72;
			add(text);

			var text5:FlxText;
			text5 = new FlxText(225, 50, 420, "10");
			text5.color = 0xDD0000;
			text5.alignment = "center";
			text5.size = 72;
			add(text5);

			var text2:FlxText;
			text2 = new FlxText(205, 130, 220, "by neocrey");
			text2.color = 0xffffff;
			text2.alignment = "center";
			text2.size = 30;
			add(text2);

			var text3:FlxText;
			text3 = new FlxText(75, 200, 500, "The Earth is in zombie apocalypse!\nTry to stay alive as long as you can.\nEvery 10 Seconds population of zombies increases.\nGood luck!");
			text3.color = 0xffffff;
			text3.alignment = "center";
			text3.size = 20;
			add(text3);

			var text4:FlxText;
			text4 = new FlxText(120, 420, 400, "http://neocrey.newgrounds.com");
			text4.color = 0xffffff;
			text4.alignment = "center";
			text4.size = 20;
			add(text4);

			var text6:FlxText;
			text6 = new FlxText(110, 10, 400, "Made for Ludum Dare 27 Compo");
			text6.color = 0xffffff;
			text6.alignment = "center";
			text6.size = 16;
			add(text6);
		
		super.create();

		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}

	public function onPlay():Void
	{
		FlxG.play("Click");
		FlxG.fade(0xff000000, 1, gotoPS);
	}
	
	public function gotoPS():Void
	{
		FlxG.switchState(new PlayState());
	}
}