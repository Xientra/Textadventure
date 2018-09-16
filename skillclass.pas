unit SkillClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage};

type
  TSkill = class
  public
    constructor Create(_name, _description, _imagePath: string; _damageType: integer; _damageMultiplier: real; _cooldown: integer);
    function GetCooldown(): integer;
    procedure ReduceCooldown();
    function GetName(): string;
    function GetDescription(): string;
    function GetImagePath(): string;
  private
    name: string;
    description: string;
    ImagePath: string;

    damageType: integer; //1 = strike; 2 = thrust; 3 = slash; 4 = magic;
    damageMultiplier: real;
    cooldown: integer;
  end;

implementation

constructor TSkill.Create(_name, _description, _imagePath: string; _damageType: integer; _damageMultiplier: real; _cooldown: integer);
begin
  inherited Create;
  name := _name;
  description := _description;
  ImagePath := _imagePath;

  if (_damageType > 4) then begin
    damageType := 4;
    ShowMessage('1 = strike; 2 = thrust; 3 = slash; 4 = magic; damageType was set to 4.');
  end else damageType := _damageType;
  damageMultiplier := _damageMultiplier;
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

end.

