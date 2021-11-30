program spacewar;

uses 
  crt, math_util;

const
  X_SIZE = 14;
  Y_SIZE = 8;
  MAX_PROJECTILES = 99;
  DT = 0.016; { A small fraction of time, in seconds (1/60) }

type
  TWorldYRange = 0..Y_SIZE-1;
  TWorldXRange = 0..X_SIZE-1;

  { A matrix of chars that will be rendered on screen, where an empty entry represents
    an empty space }
  TWorldMatrix = array [0..Y_SIZE - 1, 0..X_SIZE - 1] of char;

  TEntityType = ( play, projectile );

  TEntity = record
    fig: char; { The char that graphically represents this entity }
    pos: TVector;
    case etype: TEntityType of
      play : ();
      projectile : ( vel: real ); { Velocity on the Y (vertical) axis }
  end;

  { Variant record which uses bounded arrays to store entities }
  TEntityContainer = record
    case etype : TEntityType of
    projectile : (
      bound: -1..MAX_PROJECTILES;
      container: array [0..MAX_PROJECTILES] of TEntity
    );
  end;

var
  world: TWorldMatrix;
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

procedure manage_entities(var entities: TEntityContainer);
var
  i: integer;
begin
  with entities do
    case etype of
      projectile: begin
	if bound <> -1 then { If it's not empty, then }
	for i := 0 to bound do
	begin
	  { Update position }
	  container[i].pos.y += container[i].vel * DT;

	  { World limits }
	  if (container[i].pos.y > Y_SIZE) or (container[i].pos.y < 1) then
	  begin
	    container[i].pos.x := container[bound].pos.x;
	    container[i].pos.y := container[bound].pos.y;
	    container[i].vel := container[bound].vel;
	    bound -= 1
	    { The projectile is deleted }
	    { TODO: Generalize to a delete() method }
	  end;
	end;
      end; { projectile case }
    end; { case }
end;

function empty_world(fig : char) : TWorldMatrix;
var
  y_index: TWorldYRange;
  x_index: TWorldXRange;
begin
  for y_index in TWorldYRange do
    for x_index in TWorldXRange do
      empty_world[y_index, x_index] := fig;
end;

procedure add_to_world(var world : TWorldMatrix; entities: TEntityContainer);
var
  i: integer;
begin
  with entities do
    case etype of
      projectile:
	if bound <> -1 then { If it's not empty, then }
	  for i := 0 to bound do
	    with container[i] do
	      world[round(pos.y), round(pos.x)] := fig;
    end;
end;

{ The player's entity is excluded from the previous procedures and has its own, as it's
a special kind of entity }
procedure manage_player(var player : TEntity; var world : TWorldMatrix);
begin
  with player do
    case etype of
    play:
      begin
	{ World limits }
	if pos.x >= X_SIZE-1  then pos.x := X_SIZE-1;
	if pos.x <= 0	      then pos.x := 0;
	if pos.y >= Y_SIZE-1  then pos.y := Y_SIZE-1;
	if pos.y <= 0	      then pos.y := 0;

	world[round(pos.y), round(pos.x)] := fig;
      end;
    end;
end;

procedure render_graphics(world : TWorldMatrix);
var
  y_index: TWorldYRange;
  x_index: TWorldXRange;
begin
  clrscr();

  for y_index in TWorldYRange do
  begin
    for x_index in TWorldXRange do
      write(world[y_index, x_index], ' ');
    writeln();
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
  world := empty_world('-');

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

    add_to_world(world, projectiles);

    manage_player(player, world);

    render_graphics(world);
    world := empty_world('-');

    writeln('Press: ESC to quit.');
    writeln('       WASD to move.');
    writeln('       SPACEBAR to shoot!');

    delay(16) { 1/60 in milliseconds, making the game run at a little less than 60 fps }
  end;
end.
