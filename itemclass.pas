unit ItemClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage};

type
  TItem = class
  public
    constructor Create(_name: string; _description: String);

    function GetName(): string;

    procedure SetHealing(_factor: integer);
    procedure SetDamageUp(_factor: integer);
    procedure SetDefenseUp(_factor: integer);
    procedure SetKey(_keyIndex: integer);
    function GetKeyIndex: integer;

  private
    ItemName: string;
    ItemDescription: string;

    IsUseless: boolean;

    IsHealing,
    IsDamageUp,
    IsDefenseUp,
    IsBomb,
    IsKey
    : boolean;

    HealingFactor,
    DamageUpFactor,
    DefenseUpFactor,
    KeyIndex
    : integer;

  end;

implementation

constructor TItem.Create(_name: string; _description: String);
begin
  inherited Create;
  itemName := _name;
  ItemDescription := _description;

  IsUseless := true;
  IsHealing := false;
  IsDamageUp := false;
  IsDefenseUp := false;
  IsBomb := false;
  IsKey := false;
end;


function TItem.GetName(): string;
begin
  result := ItemName;
end;

procedure TItem.SetHealing(_factor: integer);
begin
  IsUseless := false;
  IsHealing := true;
  //IsDamageUp := false;
  //IsDefenseUp := false;  //wenn wir das ander true lassen könnte ein Item mehrere effekte haben (und btw wenn wir uns dagegen entscheiden, dann können auch die factor var zu einer werden)
  IsBomb := false;
  IsKey := false;

  HealingFactor := _factor;
end;
procedure TItem.SetDamageUp(_factor: integer);
begin
  IsUseless := false;
  //IsHealing := false;
  IsDamageUp := true;
  //IsDefenseUp := false;
  IsBomb := false;
  IsKey := false;

  DamageUpFactor := _factor;
end;
procedure TItem.SetDefenseUp(_factor: integer);
begin
  IsUseless := false;
  //IsHealing := false;
  //IsDamageUp := false;
  IsDefenseUp := true;
  IsBomb := false;
  IsKey := false;

  DefenseUpFactor := _factor;
end;

procedure TItem.SetKey(_keyIndex: integer);
begin
  IsUseless := false;
  IsHealing := false;
  IsDamageUp := false;
  IsDefenseUp := false;
  IsBomb := false;
  IsKey := true;

  KeyIndex := _keyIndex;
end;

function TItem.GetKeyIndex(): integer;
begin
  result := KeyIndex;
end;

end.







