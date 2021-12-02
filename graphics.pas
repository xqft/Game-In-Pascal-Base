unit graphics;

interface

uses
  crt, world;

procedure render_graphics(world : TWorldMatrix);

implementation

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

end.
