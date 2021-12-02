program spacewar;

uses 
  crt, math_util, world, entity, graphics;

var
  game_world: TWorldMatrix;
  player: TEntity;
  projectiles: TEntityContainer;
  running: boolean;

procedure shoot(entity: TEntity; velocity: real; var projectiles: TEntityContainer); (* velocity está en celdas por segundo aprox. *)
begin
  with projectiles do
  begin
    case etype of
      projectile:
      begin
	bound += 1;
	with container[bound] do
	begin
	  fig := '|';
	  pos := entity.pos;
	  vel := velocity;
	end;
      end;
    end; { case }
  end;
end;

{ The player's entity is excluded from the previous procedures and has its own, as it's
a special kind of entity }
procedure manage_player(var player : TEntity; var game_world : TWorldMatrix);
begin
  with player do
    case etype of
    play:
      begin
	{ game_world limits }
	if pos.x >= X_SIZE-1  then pos.x := X_SIZE-1;
	if pos.x <= 0	      then pos.x := 0;
	if pos.y >= Y_SIZE-1  then pos.y := Y_SIZE-1;
	if pos.y <= 0	      then pos.y := 0;

	game_world[round(pos.y), round(pos.x)] := fig;
      end;
    end;
end;

procedure manage_input;
var
  keystroke: char;
begin
  if keypressed() then { So the loop doesn't stop until receiving input }
  keystroke := readkey();
  case keystroke of
    'w': player.pos.y -= 1;
    's': player.pos.y += 1;
    'd': player.pos.x += 1;
    'a': player.pos.x -= 1;
    #27: running := false;		  { #27 = ESC }
    #32: shoot(player, -8, projectiles);  { #32 = SPACEBAR }
  end;
end;

begin
  game_world := empty_world('-');

  player.etype	:= play;
  player.fig	:= 'o';
  player.pos.x	:= X_SIZE div 2;
  player.pos.y	:= Y_SIZE div 2;

  projectiles.etype := projectile;
  projectiles.bound := -1; { Initially empty }

  running := true;

  while running do
  begin
    manage_input();

    manage_entities(projectiles);

    add_to_world(game_world, projectiles);

    manage_player(player, game_world);

    render_graphics(game_world);
    game_world := empty_world('-');

    writeln('Press: ESC to quit.');
    writeln('       WASD to move.');
    writeln('       SPACEBAR to shoot!');

    delay(16) { 1/60 in milliseconds, making the game run at a little less than 60 fps }
  end;
end.
