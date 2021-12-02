unit world;

interface

const
  X_SIZE = 14;
  Y_SIZE = 8;

type
  TWorldYRange = 0..Y_SIZE-1;
  TWorldXRange = 0..X_SIZE-1;

  { A matrix of chars that will be rendered on screen, where an empty entry represents
    an empty space }
  TWorldMatrix = array [0..Y_SIZE - 1, 0..X_SIZE - 1] of char;

function empty_world(fig : char) : TWorldMatrix;

implementation

function empty_world(fig : char) : TWorldMatrix;
var
  y_index: TWorldYRange;
  x_index: TWorldXRange;
begin
  for y_index in TWorldYRange do
    for x_index in TWorldXRange do
      empty_world[y_index, x_index] := fig;
end;

end.
