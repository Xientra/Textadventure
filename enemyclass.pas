unit EnemyClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
  type
    TEnemy = class
    public
      constructor Create(_health: real);
      function DoDamage(_strikeDmg, _thrustDmg, _slashDmg: real; _magicDmg: real): real;
      procedure SetResistants(_strikeResist, _thrustResist, _slashResist: real);

      function GetHealth(): real;
    private
      health: real;
      damage: real;

      strikeResist,
      thrustResist,
      slashResist
      : real;

    end;

implementation

constructor TEnemy.Create(_health: real);
begin
  inherited Create;
  health := _health;
end;

procedure TEnemy.SetResistants(_strikeResist, _thrustResist, _slashResist: real);
begin
  strikeResist := _strikeResist;
  thrustResist := _thrustResist;
  slashResist := _slashResist;
end;

function TEnemy.DoDamage(_strikeDmg, _thrustDmg, _slashDmg: real; _magicDmg: real): real;
var
  tempHealth: real;
begin
  tempHealth := health;
  health := health - (_strikeDmg * strikeResist);
  health := health - (_thrustDmg * thrustResist);
  health := health - (_slashDmg * slashResist);
  health := health - (_magicDmg);
  result := tempHealth - Health;
  //Round(Health);
end;

function TEnemy.GetHealth(): real;
begin

end;

end.

