program mijuego;

uses crt;

const
  X_SIZE = 14;
  Y_SIZE = 8;

var 
  x_index, y_index, player_x, player_y: integer;
  keystroke: char;
  running: boolean;

begin
  player_x := X_SIZE div 2;
  player_y := Y_SIZE div 2;
  running := true;

  clrscr();

  while running do
  begin
    for y_index := 1 to Y_SIZE do
    begin
      for x_index := 1 to X_SIZE do
	if (x_index = player_x) and (y_index = player_y) then
	  write('o ')
	else
	  write('- ');
      writeln()
    end;

      writeln('Move with WASD. Exit with ESC.');

      keystroke := readkey();
      case keystroke of
	'w': player_y -= 1;
	's': player_y += 1;
	'd': player_x += 1;
	'a': player_x -= 1;
	#27: running := false; (* #27 = ESC *)
      end;

      clrscr();
    end;
end.
