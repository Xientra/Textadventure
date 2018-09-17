unit SkillClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage};

type
  TSkill = class
  public
    constructor Create(_name, _description, _imagePath: string; _cooldown: integer; _strikeMulti, _thrustMulti, _slashMulti, _magicMulti: real);
    function GetCooldown(): integer;
    procedure ReduceCooldown();
    function GetName(): string;
    function GetDescription(): string;
    function GetImagePath(): string;
    function GetStrikeMulti(): real;
    function GetThrustMulti(): real;
    function GetSlashMulti(): real;
    function GetMagicMulti(): real;
  private
    name: string;
    description: string;
    ImagePath: string;

    StrikeMultiplyer,
    ThrustMultiplyer,
    SlashMultiplyer,
    MagicMultiplyer
    : real;

    cooldown: integer;
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

end;

function TSkill.GetCooldown(): integer;
begin
  result := cooldown;
end;
procedure TSkill.ReduceCooldown();
begin
  if (cooldown > 0) then cooldown := cooldown - 1;
end;
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

