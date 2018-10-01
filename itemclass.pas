unit ItemClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage};

type
  TItem = class
  public
    constructor Create(_name, _description, _imagePath: string);

    function UseItem(): boolean;

    function GetName(): string;
    function GetDescription(): string;
    function GetImagePath(): string;

    procedure SetHealing(_factor: real);
    procedure SetDamageUp(_factor: real);
    procedure SetDefenseUp(_factor: real);
    procedure SetKey(_keyIndex: real);
    procedure SetBomb(_damage: real);
    function GetKeyIndex: real;

  private
    ItemName: string;
    ItemDescription: string;
    ImagePath: string;

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
    BombDamage,
    KeyIndex
    : real;

  end;

implementation

uses Unit1;

constructor TItem.Create(_name, _description, _imagePath: string);
begin
  inherited Create;
  itemName := _name;
  ItemDescription := _description;
  ImagePath := _imagePath;

  IsUseless := true;
  IsHealing := false;
  IsDamageUp := false;
  IsDefenseUp := false;
  IsBomb := false;
  IsKey := false;
end;

function TItem.UseItem(): boolean;
begin
  result := false;
  if (IsUseless = true) or (IsKey = true) then
    result := false
  else
  begin
    if (IsHealing) then
    begin
      Unit1.Player1.ChangeHealthBy(HealingFactor);
      result := true;
    end;
    if (IsDamageUp) then
    begin
      Unit1.Player1.SetDamageMultiplyer(DamageUpFactor);
      result := true;
    end;
    if (IsDefenseUp) then
    begin
      Unit1.Player1.SetDefenseMultiplyer(DefenseUpFactor);
      result := true;
    end;
    if (IsBomb) then
    begin
      Unit1.FightingEnemy.DoDamage(0, 0, 0, BombDamage);
      result := true;
    end;
  end;
end;

function TItem.GetName(): string;
begin
  result := ItemName;
end;
function TItem.GetDescription(): string;
begin
  result := ItemDescription;
end;
function TItem.GetImagePath(): string;
begin
  result := ImagePath;
end;

procedure TItem.SetHealing(_factor: real);
begin
  IsUseless := false;
  IsHealing := true;
  //IsDamageUp := false;
  //IsDefenseUp := false;  //wenn wir das ander true lassen könnte ein Item mehrere effekte haben (und btw wenn wir uns dagegen entscheiden, dann können auch die factor var zu einer werden)
  IsBomb := false;
  IsKey := false;

  HealingFactor := _factor;
end;
procedure TItem.SetDamageUp(_factor: real);
begin
  IsUseless := false;
  //IsHealing := false;
  IsDamageUp := true;
  //IsDefenseUp := false;
  IsBomb := false;
  IsKey := false;

  DamageUpFactor := _factor;
end;
procedure TItem.SetDefenseUp(_factor: real);
begin
  IsUseless := false;
  //IsHealing := false;
  //IsDamageUp := false;
  IsDefenseUp := true;
  IsBomb := false;
  IsKey := false;

  DefenseUpFactor := _factor;
end;

procedure TItem.SetBomb(_damage: real);
begin
  IsUseless := false;
  IsHealing := false;
  IsDamageUp := false;
  IsDefenseUp := false;
  IsBomb := true;
  IsKey := false;

  BombDamage := _damage;
end;

procedure TItem.SetKey(_keyIndex: real);
begin
  IsUseless := false;
  IsHealing := false;
  IsDamageUp := false;
  IsDefenseUp := false;
  IsBomb := false;
  IsKey := true;

  KeyIndex := _keyIndex;
end;

function TItem.GetKeyIndex(): real;
begin
  result := KeyIndex;
end;

end.






