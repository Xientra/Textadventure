unit WeaponClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
  type
    TWeapon = class
    public
      constructor Create(_name, _description, _imagePath: string; _StrikeDmg, _ThrustDmg, _SlashDmg, _MagicDmg: real);

      function GetName(): string;
      function GetDescription(): string;
      function GetImagePath(): string;
      function GetStrikeDmg(): real;
      function GetThrustDmg(): real;
      function GetSlashDmg(): real;
      function GetMagicDmg(): real;
      function GetHighestDmg(): real;
    private
      name : string;
      description : string;
      ImagePath: string;

      StrikeDamage,
      ThrustDamage,
      SlashDamage
      : real;

      MagicDamage: real;
    end;

implementation

constructor TWeapon.Create (_name, _description, _imagePath: string; _StrikeDmg, _ThrustDmg, _SlashDmg, _MagicDmg: real);
begin
  inherited Create;
  name := _name;
  description := _description;
  ImagePath := _imagePath;

  StrikeDamage := _StrikeDmg;
  ThrustDamage := _ThrustDmg;
  SlashDamage := _SlashDmg;
  MagicDamage := _MagicDmg;
end;

function TWeapon.GetName(): string;
begin
  result := name;
end;
function TWeapon.GetDescription(): string;
begin
  result := description;
end;
function TWeapon.GetImagePath(): string;
begin
  result := name;
end;

function TWeapon.GetStrikeDmg(): real;
begin
  result := StrikeDamage;
end;
function TWeapon.GetThrustDmg(): real;
begin
  result := ThrustDamage;
end;
function TWeapon.GetSlashDmg(): real;
begin
  result := SlashDamage;
end;
function TWeapon.GetMagicDmg(): real;
begin
  result := MagicDamage;
end;
function TWeapon.GetHighestDmg(): real;
begin
  result := StrikeDamage;
  if (ThrustDamage > StrikeDamage) then result := ThrustDamage;
  if (SlashDamage > ThrustDamage) then result := SlashDamage;
  if (MagicDamage > SlashDamage) then result := MagicDamage;
end;

end.

