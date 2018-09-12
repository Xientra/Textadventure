unit WeaponClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
  type
    TWeapon = class
      public
        constructor Create(_name: string; _description: String;_StrikeDamage,_ThurstDamage,_SlashDamage,_MagicDamage: real);
      private
        name : string;
        description : string;
        StrikeDamage: real;
        ThrustDamage: real;
        SlashDamage: real;
        MagicDamage: real;
    end;

implementation
constructor TWeapon.Create (_name: string; _description: String;_StrikeDamage,_ThurstDamage,_SlashDamage,_MagicDamage: real);
begin
     inherited Create;
     name := _name;
     description := _description;
     StrikeDamage := _StrikeDamage;
     ThrustDamage := _ThrustDamage;
     SlashDamage := _SlashDamage;
     MagicDamage := MagicDamage;
end;
end.

