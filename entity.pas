unit entity;

interface

uses
  math_util, world;

const
  MAX_PROJECTILES = 99;
  DT = 0.016; { A small fraction of time, in seconds (1/60) }

type
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

procedure manage_entities(var entities: TEntityContainer);
procedure add_to_world(var world : TWorldMatrix; entities: TEntityContainer);

implementation

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

end.
