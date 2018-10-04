unit EnemyClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage},
  WeaponClass{TWeapon}, ItemClass{TItem};


type
  TEnemy = class
  public
    constructor Create(_name: string; _health, _damage: real; _imagePath: string);
    function DoDamage(_strikeDmg, _thrustDmg, _slashDmg: real; _magicDmg: real): real; //macht dem Gegner Schaden multipliziert mit den Stärken und Schwächen des Gegners
    procedure SetResistants(_strikeResist, _thrustResist, _slashResist: real); //Gibt dem Gegner stärken oder Schwächen gegen bestimme Angriffe

    //GetStuff
    function GetName(): string;
    function GetImagePath(): string;
    function GetHealth(): real;
    function GetDamage(): real;

    //Get/Set Stuff
    procedure SetWeaponDrop(_weapon: TWeapon);
    function GetWeaponDrop(): TWeapon;
    procedure SetItemDrop(_item: TItem);
    function GetItemDrop(): TItem;

  private
    name: string;
    ImagePath: string;

    health: real;
    damage: real;

    //Stärken/Schwächen Multiplier
    strikeResist,
    thrustResist,
    slashResist
    : real;

    //Sachen die der Gegner fallen läst wenn er besiegt wurde
    weaponDrop: TWeapon;
    itemDrop: TItem;
  end;

implementation

constructor TEnemy.Create(_name: string; _health, _damage: real; _imagePath: string);
begin
  inherited Create;
  name := _name;
  health := _health;
  damage := _damage;
  ImagePath := _imagePath;

  strikeResist := 1;
  thrustResist := 1;
  slashResist := 1;

  weaponDrop := nil;
  itemDrop := nil;
end;

//Setzt die Resistenzen
procedure TEnemy.SetResistants(_strikeResist, _thrustResist, _slashResist: real);
begin
  strikeResist := _strikeResist;
  thrustResist := _thrustResist;
  slashResist := _slashResist;
end;

//Macht dem gegner Schaden
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

//Get Stuff
function TEnemy.GetName(): string;
begin
  result := name;
end;
function TEnemy.GetImagePath(): string;
begin
  result := ImagePath;
end;
function TEnemy.GetHealth(): real;
begin
  result := health;
end;
function TEnemy.GetDamage(): real;
begin
  result := damage;
end;

//Get/Set Drop
procedure TEnemy.SetWeaponDrop(_weapon: TWeapon);
begin
  weaponDrop := _weapon;
  if (itemDrop <> nil) then
  begin
    itemDrop := nil;
    ShowMessage('The Item Drop of this enemy has been set to nil.')
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
    ShowMessage('The Weapon Drop of this enemy has been set to nil.')
  end;
end;
function TEnemy.GetItemDrop(): TItem;
begin
  result := itemDrop;
end;


end.

