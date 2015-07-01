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
import org.flixel.FlxObject;
import org.flixel.util.FlxMath;
import org.flixel.util.FlxRect;
import org.flixel.FlxTilemap;
import org.flixel.FlxCamera;
import org.flixel.FlxGroup;
import org.flixel.plugin.photonstorm.FlxDelay;
import org.flixel.plugin.photonstorm.fx.StarfieldFX;
import org.flixel.FlxParticle;
import org.flixel.FlxEmitter;

class PlayState extends FlxState
{
	public var level:FlxTilemap;
	public var player:FlxSprite;
	public var enemyGroup:FlxGroup;
	public var timer:FlxDelay;
	public var timer2:FlxDelay;
	public var bullets:FlxGroup;
	public var zomb10text:FlxText;
	public var background:FlxSprite;
	public var stars:StarfieldFX;
	public var scoreText:FlxText;
	public var scoreNum:Int;
	public var gameOverText:FlxText;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.hide();
		#end

		FlxG.play("gMusic", 1, true);
		

		stars = new StarfieldFX();
		stars.create(0, 0, FlxG.width, FlxG.height, 200, 1);
		stars.setStarSpeed(5, 0);

		background = new FlxSprite();
		background.loadGraphic("assets/clouds.png", true, true, 640, 480);
		add(background);

		//add(new FlxBackdrop("assets/clouds.png", 3, 300, true, true));

		level = new FlxTilemap();
		level.loadMap(FlxTilemap.imageToCSV("assets/map.png", false, 4), "assets/tiles.png", 0, 0, FlxTilemap.ALT);
		level.follow();
		add(level);

		player = new FlxSprite();
		player.loadGraphic("assets/player.png", true, true, 8, 22);
		add(player);
		player.x = 40;
		player.y = 70;
		player.acceleration.y = 300;
		player.drag.x = 350;
		player.addAnimation("default", [0]);
		player.addAnimation("jump", [2]);
		player.addAnimation("go", [0,1], 3);
		player.play("default");

		makeEnemies();

		timer = new FlxDelay(10000);
		timer.start();

		timer2 = new FlxDelay(5000);

		scoreNum = 0;
		scoreText = new FlxText(13, 0, 100, "0");
		scoreText.setFormat(null, 30, 0xFFFFFFFF, "center");
		add(scoreText);

		//FlxG.camera.setBounds(0, 0, level.width, level.height);
		//FlxG.worldBounds = new FlxRect(0, 0, level.width, level.height);

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
		FlxG.collide(level,player);

		//FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
		if(player.alive)
		{
			scoreNum += 1;
			scoreText.text = Std.string(scoreNum);
		}
		
		if(FlxG.keys.LEFT)
		{
			player.play("go");
			player.velocity.x = -130;
			player.facing = FlxObject.LEFT;
		}

		if(FlxG.keys.RIGHT)
		{
			player.play("go");
			player.velocity.x = 130;
			player.facing = FlxObject.RIGHT;
		}

		//if(FlxG.keys.justPressed("Z"))
		//{
		//	spawnBullet();
		//}

		if(FlxG.keys.justPressed("R"))
		{
			FlxG.play("Reload");
			FlxG.fade(0xff000000, 1, gotoReload);
		}

		if (player.velocity.y == 0 && FlxG.keys.UP) 
		{
			player.velocity.y = -200;
			player.play("jump");
			FlxG.play("Jump");
		}

		if(FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("RIGHT") || FlxG.keys.justReleased("UP"))
		{
			player.play("default");
		}

		FlxG.collide(level, enemyGroup);

		if(timer.hasExpired)
		{
			makeEnemies();
			timer.reset(10000);
			FlxG.play("Spawn");
			zomb10text = new FlxText(120, 0, 400, "ZOMBIOOOOO!!!");
			zomb10text.setFormat(null, 42, 0xFFCC0000, "center");
			add(zomb10text);
			timer2.start();
		}

		if(timer2.hasExpired)
		{
			zomb10text.kill();
			timer2.reset(5000);
		}

		FlxG.overlap(player, enemyGroup, overlapPlayerEnemies);

		super.update();
	}

	override public function draw():Void
	{
		stars.draw();
		super.draw();
	}

	private function spawnBullet():Void
	{
		bullets = new FlxGroup();
		add(bullets);

		var _bullet:Bullet = new Bullet();
		_bullet.x = player.x;
		_bullet.y = player.y;
		bullets.add(_bullet);
	}

	private function makeEnemies():Void 
	{
		//make the group for the enemies, add it to the game
		enemyGroup = new FlxGroup();
		add(enemyGroup);
		
		//make three enemies
		var enemy:Enemy = new Enemy();
		enemy.setTarget(player);
		enemy.x = 500;
		enemy.y = 100;
		enemyGroup.add(enemy);
		
		enemy = new Enemy();
		enemy.setTarget(player);
		enemy.x = 200;
		enemy.y = 400;
		enemyGroup.add(enemy);
		
		enemy = new Enemy();
		enemy.setTarget(player);
		enemy.x = 200;
		enemy.y = 300;
		enemyGroup.add(enemy);
	}

	private function overlapPlayerEnemies(char:FlxSprite, enemy:Enemy):Void
	{
		var emitter:FlxEmitter = createEmitter();
		emitter.at(char);
		FlxG.shake(0.035, 0.5);
		FlxG.play("Bang");
		char.kill();
		enemy.kill();
		gameOverText = new FlxText(0, FlxG.height / 2-30, FlxG.width, "Game over!\nPress R to play again");
		gameOverText.setFormat(null, 16, 0xFFFFFFFF, "center");
		add(gameOverText);
	}	

	private function createEmitter():FlxEmitter
	{
			var emitter:FlxEmitter = new FlxEmitter();
			emitter.lifespan = 1;
			emitter.gravity = 0;
			emitter.maxRotation = 0;
			emitter.setXSpeed( -300, 300);
			emitter.setYSpeed( -300, 300);
			var particles:Int = 30;
			for (i in 0...particles)
			{
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(5, 5, 0xFFFF0000);
				particle.exists = false;
				emitter.add(particle);
			}
			emitter.start();
			add(emitter);
			return emitter;
	}

	public function gotoReload():Void
	{
		FlxG.switchState(new PlayState());
	}
}