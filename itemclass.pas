unit ItemClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage};

type
  TItem = class
  public
    constructor Create(_name: string; _description: String);

    procedure SetHealing(_factor: integer);
    procedure SetDamageUp(_factor: integer);
    procedure SetDefenseUp(_factor: integer);
  private
    ItemName: string;
    ItemDescription: string;

    IsUseless: boolean;

    IsHealing,
    IsDamageUp,
    IsDefenseUp,
    IsBomb
    : boolean;

    HealingFactor,
    DamageUpFactor,
    DefenseUpFactor
    : integer;

  end;

implementation

constructor TItem.Create(_name: string; _description: String);
begin
  itemName := _name;
  ItemDescription := _description;

  IsUseless := true;
  IsHealing := false;
  IsDamageUp := false;
  IsDefenseUp := false;
end;


procedure TItem.SetHealing(_factor: integer);
begin
  IsUseless := false;
  IsHealing := true;
  //IsDamageUp := false;
  //IsDefenseUp := false;  //wenn wir das ander true lassen könnte ein Item mehrere effekte haben (und btw wenn wir uns dagegen entscheiden, dann können auch die factor var zu einer werden)
  HealingFactor := _factor;
end;
procedure TItem.SetDamageUp(_factor: integer);
begin
  IsUseless := false;
  //IsHealing := false;
  IsDamageUp := true;
  //IsDefenseUp := false;
  DamageUpFactor := _factor;
end;
procedure TItem.SetDefenseUp(_factor: integer);
begin
  IsUseless := false;
  //IsHealing := false;
  //IsDamageUp := false;
  IsDefenseUp := true;
  DefenseUpFactor := _factor;
end;

end.







