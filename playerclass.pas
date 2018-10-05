unit PlayerClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage},
  RoomClass{für TRoom}, WeaponClass{Für TWeapon}, ItemClass{für TItem}, SkillClass{für TSkill};

type
  TPlayer = class
  public
    //public da man Array of X nicht returnen kann...
    itemInventory: Array of TItem; //Item Inventar
    weaponInventory: Array of TWeapon; //Waffen Inventar
    Skills: Array of TSkill; //Skill Inventar

    constructor Create(startRoom: TRoom; startWeapon: TWeapon; _health: real);

    procedure ChangeRoom(_direction: string); //ändert den Raum in der gegebenen Richtung

    function GetHealth(): real;
    procedure ChangeHealthBy(_amount: real);
    function GetCurrendRoom(): TRoom;
    function GetCurrendWeapon(): TWeapon;
    procedure SetCurrendWeapon(_weapon: TWeapon);
    function GetAmountOfSkills(): integer; //results AountOfSkills
    function GetMaxAmountOfSkills(): integer; //Der Spieler kann nur eine begrenzte anzahl Skills haben

    procedure AddItem(_item: TItem); //erhöht die größe des Item Inventar und fügt ein Item hinzu
    procedure AddWeapon(_weapon: TWeapon); //erhöht die größe des Waffen Inventar und fügt eine Waffen hinzu
    procedure AddSkill(_skill: TSkill); //erhöht die größe des Skill Inventar und fügt einen Skill hinzu

    function HasWeaponsInInventory(): boolean; //Schaut ob der Spieler überhaupt Waffen hat
    function HasItemsInInventory(): integer; //Schaut ob der Spieler überhaupt Items hat und returnt die erste position. -1 = false
    function HasSkills(): boolean; //Schaut ob der Spieler überhaupt Skills hat

    //für die Beiden Buff Items zur verbessern des Agrifffes/ der Verteidigung
    procedure SetDamageMultiplyer(_multi: real);
    procedure SetDefenseMultiplyer(_multi: real);

  private
    health: real;

    currendRoom: TRoom;
    currendWeapon: TWeapon;
    standartWeapon: TWeapon;

    AmountOfSkills: integer; //die länge des Skills Array und gleichzeitig der Counter zum hinuzufügen von skills
    MaxAmountOfSkills: integer; //die Maximale anzahl Skills die ein Spieler haben kann

    //für die Beiden Buff Items zur verbessern des Agrifffes/ der Verteidigung
    DamageMultiplyer,
    DefenseMultiplyer: real;
  end;

implementation

uses unit1;

constructor TPlayer.Create(startRoom: TRoom; startWeapon: TWeapon; _health: real);
begin
  inherited Create;
  currendRoom := startRoom;
  standartWeapon := startWeapon;
  currendWeapon := standartWeapon;
  health := _health;

  MaxAmountOfSkills := 4;
  AmountOfSkills := MaxAmountOfSkills;
  SetLength(Skills, AmountOfSkills);
end;

procedure TPlayer.ChangeRoom(_direction: string); //ändert den Raum
begin
  case _direction of
  'xPos': currendRoom := Unit1.RoomArr[currendRoom.GetPosX+1,currendRoom.GetPosY,currendRoom.GetPosZ];
  'yPos': currendRoom := Unit1.RoomArr[currendRoom.GetPosX,currendRoom.GetPosY+1,currendRoom.GetPosZ];
  'zPos': currendRoom := Unit1.RoomArr[currendRoom.GetPosX,currendRoom.GetPosY,currendRoom.GetPosZ+1];
  'xNeg': currendRoom := Unit1.RoomArr[currendRoom.GetPosX-1,currendRoom.GetPosY,currendRoom.GetPosZ];
  'yNeg': currendRoom := Unit1.RoomArr[currendRoom.GetPosX,currendRoom.GetPosY-1,currendRoom.GetPosZ];
  'zNeg': currendRoom := Unit1.RoomArr[currendRoom.GetPosX,currendRoom.GetPosY,currendRoom.GetPosZ-1];
  end;
end;

//Get/Set Stuff
function TPlayer.GetHealth(): real;
begin
  result := health;
end;
procedure TPlayer.ChangeHealthBy(_amount: real);
begin
  health := health + _amount;
end;
function TPlayer.GetCurrendRoom(): TRoom;
begin
  result := currendRoom;
end;
function TPlayer.GetCurrendWeapon(): TWeapon;
begin
  result := currendWeapon;
end;
procedure TPlayer.SetCurrendWeapon(_weapon: TWeapon);
begin
  currendWeapon := _weapon;
end;
function TPlayer.GetAmountOfSkills(): integer;
begin
  result := AmountOfSkills;
end;
function TPlayer.GetMaxAmountOfSkills(): integer;
begin
  result := MaxAmountOfSkills;
end;


//Add Stuff
procedure TPlayer.AddItem(_item: TItem);
begin
  SetLength(itemInventory, Length(itemInventory) + 1);
  itemInventory[Length(itemInventory) - 1] := _item;
end;
procedure TPlayer.AddWeapon(_weapon: TWeapon);
begin
  SetLength(weaponInventory, Length(weaponInventory) + 1);
  weaponInventory[Length(weaponInventory) - 1] := _weapon;
end;
procedure TPlayer.AddSkill(_skill: TSkill);
begin
  if (AmountOfSkills - 1 >= 0) then
  begin
    Skills[AmountOfSkills - 1] := _skill;
    AmountOfSkills := AmountOfSkills - 1;
  end;
end;

//Player has Stuff
function TPlayer.HasWeaponsInInventory(): boolean;
var i: integer;
begin
  if (length(weaponInventory) = 0) then result := false
  else
    for i := 0 to length(self.weaponInventory) - 1 do
      if (self.weaponInventory[i] <> nil) then result := true;
end;
function TPlayer.HasItemsInInventory(): integer;
var i: integer; stop: boolean;
begin
  stop := false;
  result := -1;
  if (length(itemInventory) = 0) then result := -1
  else
    for i := 0 to length(self.itemInventory) - 1 do
      if (self.itemInventory[i] <> nil) then
        if (stop = false) then
        begin
          result := i;
          stop := true;
        end;
end;
function TPlayer.HasSkills(): boolean;
var i: integer;
begin
  if (length(Skills) = 0) then result := false
  else
    for i := 0 to length(self.Skills) - 1 do
      if (self.Skills[i] <> nil) then result := true;
end;

//Stuff for the Buff Items
procedure TPlayer.SetDamageMultiplyer(_multi: real);
begin
  DamageMultiplyer := _multi;
end;
procedure TPlayer.SetDefenseMultiplyer(_multi: real);
begin
  DefenseMultiplyer := _multi;
end;

end.

