program spacewar;

uses 
  crt, math_util;

const
  X_SIZE = 14;
  Y_SIZE = 8;
  MAX_PROJECTILES = 99;
  DT = 0.016; (* Pequeña fracción de tiempo, en segundos (1/60) *)

type
  TProjectile = record
    position: TVector;
    vel: real (* La velocidad es solo en el eje vertical *)
  end;

  TProjectileContainer = record
    container: array [0..MAX_PROJECTILES] of TProjectile;
    last_element_index: integer
    (* Cada elemento es un proyectil. last_element_index indica el índice del último
    proyectil, será usado para loopear desde 0 hasta este valor y pasar por cada 
    proyectil. *)
  end;

  TShip = record
    position: TVector
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
      position := ship.position;
      vel := velocity
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
      container[i].position.y += container[i].vel * DT;

      if (container[i].position.y > Y_SIZE) or (container[i].position.y < 1) then (* Límites *)
      begin
	container[i].position.x := container[last_element_index].position.x;
	container[i].position.y := container[last_element_index].position.y;
	container[i].vel := container[last_element_index].vel;
	last_element_index -= 1
	(* Se elimina el proyectil, copiando el último elemento al índice del
	eliminado y luego reduciendo last_element_index *)
      end;
    end;
end;

procedure manage_graphics;
var
  x_index, y_index, i: integer;
  has_projectile: boolean;
begin
  (* Límites del jugador *)
  with player.position do
  begin
    if x > X_SIZE then x := X_SIZE;
    if x < 1	  then x := 1;
    if y > Y_SIZE then y := Y_SIZE;
    if y < 1	  then y := 1
  end;

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
	    with container[i].position do
	      if (x_index = round(x)) and (y_index = round(y)) then 
	      begin
		write ('| ');
		has_projectile := true (* Esta celda tiene un proyectil *)
	      end;

	  if not has_projectile then
	    if (x_index = player.position.x) and (y_index = player.position.y) then
	      write('o ')
	    else 
	      write('- ');

	end else (* No hay proyectiles *)
	  if (x_index = player.position.x) and (y_index = player.position.y) then
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
    'w': player.position.y -= 1;
    's': player.position.y += 1;
    'd': player.position.x += 1;
    'a': player.position.x -= 1;
    #27: running := false;  (* #27 = ESC *)
    #32: shoot(player, -8); (* #32 = SPACEBAR *)
  end;
end;

begin
  player.position.x := X_SIZE div 2;
  player.position.y := Y_SIZE div 2;

  projectiles.last_element_index := -1; (* Está inicialmente vacío *)

  running := true;

  while running do
  begin
    manage_input();
    manage_projectiles();
    manage_graphics();
    writeln('Move with WASD. Exit with ESC. Shoot with SPACE!');

    delay(16) (* 1/60 en milisegundos, simula un poco menos de 60 fps *)
  end;
end.
