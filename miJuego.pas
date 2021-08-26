program spacewar;

uses crt;

const
  X_SIZE = 14;
  Y_SIZE = 8;
  MAX_PROJECTILES = 99;
  DT = 0.016; (* Pequeña fracción de tiempo, en segundos (1/60) *)

type
  TProjectile = record
    x, y, vel: real; (* La velocidad es solo en el eje vertical *)
  end;

  TProjectileContainer = record
    container: array [0..MAX_PROJECTILES] of TProjectile;
    last_element_index: integer;
    (* Cada elemento es un proyectil. last_element_index indica el índice del último
    proyectil, será usado para loopear desde 0 hasta este valor y pasar por cada 
    proyectil. *)
  end;

  TShip = record
    x: integer;
    y: integer;
  end;

var 
  player: TShip;
  running: boolean;
  projectiles: TProjectileContainer;

procedure shoot(ship: TShip; velocity: real); (* velocity está en celdas por segundo aprox. *)
begin
  with projectiles do
  begin
    projectiles.last_element_index += 1;
    with container[last_element_index] do
    begin
      x := ship.x;
      y := ship.y;
      vel := velocity;
    end;
  end;
end;

procedure manage_projectiles;
var
  i: integer;
begin
  with projectiles do
    if last_element_index <> -1 then (* No hay proyectiles *)
    for i := 0 to last_element_index do
    begin
      container[i].y += container[i].vel * DT;

      if (container[i].y > Y_SIZE) or (container[i].y < 1) then (* Límites *)
      begin
	container[i].x := container[last_element_index].x;
	container[i].y := container[last_element_index].y;
	container[i].vel := container[last_element_index].vel;
	last_element_index -= 1;
	(* Se elimina el proyectil, copiando el último elemento al índice del
	eliminado y entonces reduciendo last_element_index *)
      end;
    end;
end;

procedure manage_graphics;
var
  x_index, y_index, i: integer;
  has_projectile: boolean;
begin
  (* Límites del jugador *)
  if player.x > X_SIZE	then player.x := X_SIZE;
  if player.x < 1	then player.x := 1;
  if player.y > Y_SIZE  then player.y := Y_SIZE;
  if player.y < 1	then player.y := 1;

  (* Render *)
  clrscr();
  for y_index := 1 to Y_SIZE do
  begin
    for x_index := 1 to X_SIZE do
    begin
      has_projectile := false;
      with projectiles do
	if last_element_index <> -1 then 
	begin
	  for i := 0 to last_element_index do
	    with container[i] do
	      if (x_index = round(x)) and (y_index = round(y)) then 
	      begin
		write ('| ');
		has_projectile := true; (* Esta celda tiene un proyectil *)
	      end;

	  if not has_projectile then
	    if (x_index = player.x) and (y_index = player.y) then
	      write('o ')
	    else 
	      write('- ');

	end else (* No hay proyectiles *)
	  if (x_index = player.x) and (y_index = player.y) then
	    write('o ')
	  else 
	    write('- ');
    end;
    writeln()
  end;
end;

procedure manage_input;
var
  keystroke: char;
begin
  if keypressed() then (* Para que el loop no se detenga hasta obtener un input *)
  keystroke := readkey();
  case keystroke of
    'w': player.y -= 1;
    's': player.y += 1;
    'd': player.x += 1;
    'a': player.x -= 1;
    #27: running := false;  (* #27 = ESC *)
    #32: shoot(player, -8); (* #32 = SPACEBAR *)
  end;
end;

begin
  player.x := X_SIZE div 2;
  player.y := Y_SIZE div 2;

  projectiles.last_element_index := -1; (* Está inicialmente vacío *)

  running := true;

  clrscr();

  while running do
  begin
    manage_input();
    manage_projectiles();
    manage_graphics();
    delay(16); (* 1/60 en milisegundos, simula un poco menos de 60 fps *)

    writeln('Move with WASD. Exit with ESC.'); (* FIXME: No aparece este mensaje *)
  end;
end.
