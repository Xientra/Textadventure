unit PlayerClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage},
  RoomClass{für TRoom}, WeaponClass{Für TWeapon}, ItemClass{für TItem}, SkillClass{für TSkill};

type
  TPlayer = class
  public
    //public da man sie nicht returnen kann...
    itemInventory: Array of TItem;
    weaponInventory: Array of TWeapon;
    Skills: Array of TSkill;

    constructor Create(startRoom: TRoom; startWeapon: TWeapon; _health: real);
    procedure ChangeRoom(_direction: string);

    function GetHealth(): real;
    procedure ChangeHealthBy(_amount: real);
    function GetCurrendRoom(): TRoom;
    function GetCurrendWeapon(): TWeapon;
    procedure AddItem(_item: TItem);
    procedure AddWeapon(_weapon: TWeapon);
    procedure AddSkill(_skill: TSkill);
    function GetAmountOfSkills(): integer;
  private
    health: real;

    currendRoom: TRoom;
    currendWeapon: TWeapon;

    AmountOfSkills: integer; //die länge des Skills Array und gleichzeitig der Counter zum hinuzufügen von skills
  end;

implementation

uses unit1;

constructor TPlayer.Create(startRoom: TRoom; startWeapon: TWeapon; _health: real);
begin
  inherited Create;
  currendRoom := startRoom;
  currendWeapon := startWeapon;
  health := _health;

  AmountOfSkills := 4;
  SetLength(Skills, AmountOfSkills);
end;

procedure TPlayer.ChangeRoom(_direction: string);
begin
  //currendRoom := currendRoom.GetNeighborRooms(_direction);
  case _direction of
  'xPos': currendRoom := Unit1.RoomArr[currendRoom.GetPosX+1,currendRoom.GetPosY,currendRoom.GetPosZ];
  'yPos': currendRoom := Unit1.RoomArr[currendRoom.GetPosX,currendRoom.GetPosY+1,currendRoom.GetPosZ];
  'zPos': currendRoom := Unit1.RoomArr[currendRoom.GetPosX,currendRoom.GetPosY,currendRoom.GetPosZ+1];
  'xNeg': currendRoom := Unit1.RoomArr[currendRoom.GetPosX-1,currendRoom.GetPosY,currendRoom.GetPosZ];
  'yNeg': currendRoom := Unit1.RoomArr[currendRoom.GetPosX,currendRoom.GetPosY-1,currendRoom.GetPosZ];
  'zNeg': currendRoom := Unit1.RoomArr[currendRoom.GetPosX,currendRoom.GetPosY,currendRoom.GetPosZ-1];
  end;
end;

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

function GetAmountOfSkills(): integer;
begin

end;

end.

