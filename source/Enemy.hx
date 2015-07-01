package;

import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxParticle;
import org.flixel.FlxEmitter;
import openfl.Assets;
import flash.geom.Rectangle;
import flash.net.SharedObject;


/**
 * ...
 * @author tf
 */

class Enemy extends FlxSprite
{
	private var targ:FlxSprite;
	
	public function new() 
	{
		super();
		this.loadGraphic("assets/zombie.png", true, true, 10, 22);
		
		//customize the player
		this.x = 40;
		this.y = 70;
		this.acceleration.y = 200;
		this.drag.x = 100;
	}
	
	public function setTarget(t:FlxSprite) {
		targ = t;
	}
	
	override public function update() {
		super.update();
		
		var distX:Float = this.x - targ.x;
		var distY:Float = this.y - targ.y;
		
		if (distX > 0) {
			this.velocity.x = -50;
			this.facing = FlxObject.LEFT;
		} else {
			this.velocity.x = 50;
			this.facing = FlxObject.RIGHT;
		}
		
		if (distY > 0) {
			this.velocity.y = - 150;
		}
		
		if (this.velocity.y == 0) {
		}
	}
	
}