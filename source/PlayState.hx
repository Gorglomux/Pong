package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	
	var _player:FlxSprite;
	var _opponent:FlxSprite;
	
	var _ball:FlxSprite;
	var rand:FlxRandom;
	var _walls:FlxGroup;
	var _wallup:FlxSprite;
	var _walldown:FlxSprite;
	var _textScorePlayer:FlxText;
	var _textScoreOpponent:FlxText;
	
	override public function create():Void
	{	
		
		FlxG.mouse.visible = false;
		
		_textScorePlayer= new FlxText(140,0,50);
		_textScorePlayer.text=Std.string(Globals.scorePlayer) + " - " + Std.string(Globals.scoreOpponent);


		_walls = new FlxGroup();
		_walldown = new FlxSprite(0,239);
		_walldown.makeGraphic(320,1,FlxColor.BLACK);
		_walldown.immovable=true;
		
		_wallup = new FlxSprite(0,0);
		_wallup.makeGraphic(320,1,FlxColor.BLACK);
		_wallup.immovable=true;

		_walls.add(_walldown);
		_walls.add(_wallup);

		rand = new FlxRandom();
		_player = new FlxSprite(10,95);
		_player.makeGraphic(10,50,FlxColor.WHITE);

		_player.immovable=true;

		_opponent= new FlxSprite(300,95);
		_opponent.makeGraphic(10,50,FlxColor.WHITE);

		_opponent.immovable=true;

		_ball = new FlxSprite(150,110);
		_ball.makeGraphic(10,10,FlxColor.WHITE);


		add(_player);
		add(_opponent);
		add(_ball);
		add(_walls);
		add(_textScorePlayer);
		super.create();
	
		if(rand.bool()==false){
			_ball.velocity.x=-200;
		}else{
			_ball.velocity.x=200;
		}
	}
	var previousBallVelocity:Float;
	var over=false;
	override public function update(elapsed:Float):Void
	{	
		
		if(FlxG.keys.justPressed.R){
			FlxG.resetGame();
			Globals.scoreOpponent=0;
			Globals.scorePlayer=0;
		}
		if(!over){
			if(Globals.scorePlayer==10){
				
				gameOver("Player");
				over=true;
			}else if(Globals.scoreOpponent==10){
				gameOver("Opponent");
				over=true;
			}

			if(_ball.y+5<_opponent.y+25&&_ball.x>160&&_opponent.y>0){
				_opponent.velocity.y=-100;
			}
			else if(_ball.y+5>_opponent.y+25&&_opponent.y+50<320&&_ball.x>160){
				_opponent.velocity.y=100;
			}else{
				if(_opponent.y<70){
					_opponent.velocity.y=50;
				}else if (_opponent.y>120){
					_opponent.velocity.y=-50;
				}else{
					_opponent.velocity.y=0;
				}
			}

			previousBallVelocity=_ball.velocity.y;
			
			if(FlxG.keys.anyPressed([UP,Z])&&_player.y>=0){
				_player.y-=5+elapsed;
			}
			else if(FlxG.keys.anyPressed([DOWN,S])&&_player.y+50<=240){
				_player.y+=5+elapsed;
			}


			FlxG.collide(_player,_ball,collision);
			FlxG.collide(_opponent,_ball,collision);

			FlxG.overlap(_ball,_walls,bounce,FlxObject.separate);
			

			super.update(elapsed);

			if(_ball.x<0){
				Globals.scoreOpponent++;
				FlxG.resetState();
			}
			else if(_ball.x>320){
				Globals.scorePlayer++;
				FlxG.resetState();
			}
		}
	}
	function collision(_p:FlxSprite,_b:FlxSprite){
		var pmid=_p.y+25;
		var bmid= _b.y+5;
		if(_p.x<_b.x){
			_b.velocity.x=200;
			
		}else{
			_b.velocity.x=-200;
		}
		if(pmid>bmid){
			_b.velocity.y=-10*(pmid-bmid);

		}else{
			_b.velocity.y=10*(bmid-pmid);

		}
			
	}
	function bounce(_b:FlxSprite,_w:FlxGroup){
		_b.velocity.y=previousBallVelocity*-1;
	}


	function gameOver(winner:String){
		var text = new FlxText(120,120,150);
		text.text= winner + " wins !\n Press R to restart game";
		while(FlxG.keys.justPressed.R){

		}
		add(text);
	}
}
