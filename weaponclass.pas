unit WeaponClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
  type
    TWeapon = class
    public
      constructor Create(_name: string; _description: String; _StrikeDmg, _ThrustDmg, _SlashDmg, _MagicDmg: real);
      function GetStrikeDmg(): real;
      function GetThrustDmg(): real;
      function GetSlashDmg(): real;
      function GetMagicDmg(): real;
    private
      name : string;
      description : string;

      StrikeDamage,
      ThrustDamage,
      SlashDamage
      : real;

      MagicDamage: real;
    end;

implementation

constructor TWeapon.Create (_name: string; _description: String; _StrikeDmg, _ThrustDmg, _SlashDmg, _MagicDmg: real);
begin
     inherited Create;
     name := _name;
     description := _description;

     StrikeDamage := _StrikeDmg;
     ThrustDamage := _ThrustDmg;
     SlashDamage := _SlashDmg;
     MagicDamage := _MagicDmg;
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

end.

