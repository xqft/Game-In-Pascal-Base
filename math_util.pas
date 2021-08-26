unit math_util;

interface

type
  TVector = record
    x, y: real;
  end;

operator + (u, v: TVector) w: TVector;

operator * (k: real; u: TVector) w: TVector;
operator * (u: TVector; k: real) w: TVector;

operator * (k: integer; u: TVector) w: TVector;
operator * (u: TVector; k: integer) w: TVector;

implementation

operator + (u, v: TVector) w: TVector;
begin
  w.x := u.x + v.x;
  w.y := u.y + v.y
end;

operator * (k: real; u: TVector) w: TVector;
begin
  w.x := u.x * k;
  w.y := u.y * k
end;
operator * (u: TVector; k: real) w: TVector;
begin
  w.x := u.x * k;
  w.y := u.y * k
end;
operator * (k: integer; u: TVector) w: TVector;
begin
  w.x := u.x * k;
  w.y := u.y * k
end;
operator * (u: TVector; k: integer) w: TVector;
begin
  w.x := u.x * k;
  w.y := u.y * k
end;

end.
