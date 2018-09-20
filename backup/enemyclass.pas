unit EnemyClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage},
  WeaponClass{TWeapon}, ItemClass{TItem};


  type
    TEnemy = class
    public
      constructor Create(_health, _damage: real);
      function DoDamage(_strikeDmg, _thrustDmg, _slashDmg: real; _magicDmg: real): real;
      procedure SetResistants(_strikeResist, _thrustResist, _slashResist: real);

      procedure SetWeaponDrop(_weapon: TWeapon);
      function GetWeaponDrop(): TWeapon;
      procedure SetItemDrop(_item: TItem);
      function GetItemDrop(): TItem;

      function GetHealth(): real;
      function GetDamage(): real;
      destructor Destroy();
    private
      name: string;
      ImagePath: string;

      health: real;
      damage: real;

      strikeResist,
      thrustResist,
      slashResist
      : real;

      weaponDrop: TWeapon;
      itemDrop: TItem;

    end;

implementation

constructor TEnemy.Create(_health, _damage: real);
begin
  inherited Create;
  health := _health;
  damage := _damage;

  strikeResist := 1;
  thrustResist := 1;
  slashResist := 1;

  weaponDrop := nil;
  itemDrop := nil;
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

procedure TEnemy.SetWeaponDrop(_weapon: TWeapon);
begin
  weaponDrop := _weapon;
  if (itemDrop <> nil) then
  begin
    itemDrop := nil;
    ShowMessage('The Item Drop of this enemy has been deleted.')
  end;
end;
function TEnemy.GetWeaponDrop(): TWeapon;
begin
  result := weaponDrop;
end;

procedure TEnemy.SetItemDrop(_item: TItem);
begin
  itemDrop := _item;
  if (weaponDrop <> nil) then
  begin
    weaponDrop := nil;
    ShowMessage('The Weapon Drop of this enemy has been deleted.')
  end;
end;
function TEnemy.GetItemDrop(): TItem;
begin
  result := itemDrop;
end;

function TEnemy.GetHealth(): real;
begin
  result := health;
end;

function TEnemy.GetDamage(): real;
begin
  result := damage;
end;

destructor TEnemy.Destroy();  //this is never acually called
begin
  FreeAndNil(self);
  ShowMessage('I ll be back!');
  inherited Destroy;

end;

end.

