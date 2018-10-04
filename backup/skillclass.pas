unit SkillClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage};

type
  TSkill = class
  public
    constructor Create(_name, _description, _imagePath: string; _cooldown: integer; _strikeMulti, _thrustMulti, _slashMulti, _magicMulti: real);

    procedure SetTurnToWaitToCooldown(); //wird aufgerufen wenn man einen Skill einsetzt um den Cooldown zu setzten
    procedure SetTurnToWaitToZero(); //wir aufgerufen wenn man einen Raum verlässt um den Cooldown zu reseten
    procedure ReduceTurnsToWait(); //wird jede PlayerTurn aufgerufen um den Colldown von allen Skill um eins zu verringern

    //Get Data
    function GetName(): string;
    function GetDescription(): string;
    function GetImagePath(): string;
    function GetTurnsToWait(): integer;

    //Get Damage Multipliers
    function GetStrikeMulti(): real;
    function GetThrustMulti(): real;
    function GetSlashMulti(): real;
    function GetMagicMulti(): real;

  private
    name: string;
    description: string;
    ImagePath: string;

    cooldown: integer;
    turnsToWait: integer;

    //Damage Multipliers
    StrikeMultiplyer,
    ThrustMultiplyer,
    SlashMultiplyer,
    MagicMultiplyer
    : real;
  end;

implementation

constructor TSkill.Create(_name, _description, _imagePath: string; _cooldown: integer; _strikeMulti, _thrustMulti, _slashMulti, _magicMulti: real);
begin
  inherited Create;
  name := _name;
  description := _description;
  ImagePath := _imagePath;

  StrikeMultiplyer := _strikeMulti;
  ThrustMultiplyer := _thrustMulti;
  SlashMultiplyer := _slashMulti;
  MagicMultiplyer := _magicMulti;

  cooldown := _cooldown;
  turnsToWait := 0;
end;

//Verändert TurnsToWait
procedure TSkill.SetTurnToWaitToCooldown();
begin
  turnsToWait := cooldown;
end;
procedure TSkill.SetTurnToWaitToZero();
begin
  turnsToWait := 0;
end;
procedure TSkill.ReduceTurnsToWait();
begin
  if (turnsToWait > 0) then turnsToWait := turnsToWait - 1;
end;

//Get Data
function TSkill.GetName(): string;
begin
  result := name;
end;
function TSkill.GetDescription(): string;
begin
  result := description;
end;
function TSkill.GetImagePath(): string;
begin
  result := ImagePath;
end;

//Get Damage Multipliers
function TSkill.GetStrikeMulti(): real;
begin
  result := StrikeMultiplyer;
end;
function TSkill.GetThrustMulti(): real;
begin
  result := ThrustMultiplyer;
end;
function TSkill.GetSlashMulti(): real;
begin
  result := SlashMultiplyer;
end;
function TSkill.GetMagicMulti(): real;
begin
  result := MagicMultiplyer;
end;

end.

