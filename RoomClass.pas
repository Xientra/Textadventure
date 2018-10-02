unit RoomClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage},
  ItemClass{für TItem}, WeaponClass{für TWeapon}, EnemyClass{für TEnemy}, RoomObjectClass{für TRoomObject};

type
  TRoom = class
  public
    EnemyArr: Array of TEnemy; //da man anscheinend keine Array of ... mit functions returnen kann müssen diese Array public sein
    WeaponArr: Array of TWeapon;
    ItemArr: Array of TItem;
    RoomObjectArr: Array of TRoomObject;

    constructor Create(_description: string; _imagePath: string; _pos_x, _pos_y, _pos_z: integer);

    //procedure SetNeighborRooms();
    //function GetNeighborRooms(_direction: string): TRoom;

    function GetDescription: string;
    function GetRoomID(): integer;
    function GetImagePath(): string;

    function GetVisited: boolean;
    procedure SetVisited(v: boolean);

    function GetPosX: Integer;
    function GetPosY: Integer;
    function GetPosZ: Integer;

    procedure SetBlockedRight(b: boolean);
    procedure SetBlockedLeft(b: boolean);
    procedure SetBlockedTop(b: boolean);
    procedure SetBlockedBottom(b: boolean);

    function GetBlockedRight: boolean;
    function GetBlockedLeft: boolean;
    function GetBlockedTop: boolean;
    function GetBlockedBottom: boolean;

    procedure SetDoorRight(b: boolean);
    procedure SetDoorLeft(b: boolean);
    procedure SetDoorTop(b: boolean);
    procedure SetDoorBottom(b: boolean);

    function GetDoorRight: boolean;
    function GetDoorLeft: boolean;
    function GetDoorTop: boolean;
    function GetDoorBottom: boolean;

    procedure AddItem(_item: TItem);
    procedure AddWeapon(_weapon: TWeapon);
    procedure AddEnemy(_enemy: TEnemy);
    procedure AddRoomObject(_roomObject: TRoomObject);
    //function GetEnemyArr(): Array of TEnemy;
  private

    description: string;
    ImagePath: string;
    visited: boolean;
    blocked_right, blocked_left, blocked_top, blocked_bottom: boolean;
    door_right, door_left, door_top, door_bottom: boolean;

    pos_x, pos_y, pos_z: integer;
    RoomID: integer;
    //xPos, xNeg, yPos, yNeg, zPos, zNeg: TRoom; //zPos = Up; zNeg = Unten; xPos = rechts(?) usw...

  end;

implementation

uses Unit1;

constructor TRoom.Create(_description: string; _imagePath: string; _pos_x, _pos_y, _pos_z: integer);
begin
  inherited Create;
  description := _description;
  ImagePath := _imagePath;
  visited := false;
  pos_x := _pos_x;
  pos_y := _pos_y;
  pos_z := _pos_z;
  RoomID := _pos_x*100 + _pos_y*10 +_pos_z;

  blocked_right:= false;
  blocked_left := false;
  blocked_top := false;
  blocked_bottom := false;
  door_right := false;
  door_left := false;
  door_top := false;
  door_bottom := false;
  //ShowMessage(IntToStr(pos_x) + IntToStr(pos_y) + IntToStr(pos_z));
end;

function TRoom.GetPosX:Integer;
begin
  result := pos_x;
end;

function TRoom.GetPosY:Integer;
begin
  result := pos_y;
end;

function TRoom.GetPosZ:Integer;
begin
  result := pos_z;
end;

{
procedure TRoom.SetNeighborRooms();
begin
  ShowMessage('SetRooms was called from ' + IntToStr(pos_x) + IntToStr(pos_y) + IntToStr(pos_z));

  if (pos_x + 1 <= Unit1.Room_x) then
    if (Unit1.RoomArr[pos_x + 1, pos_y, pos_z] <> nil) then
      xPos := Unit1.RoomArr[pos_x + 1, pos_y, pos_z];
    //else Showmessage('Room xPos is nil')
  //else ShowMessage('xPos Out of Array');

  if (pos_x - 1 >= 0) then
    if (Unit1.RoomArr[pos_x - 1, pos_y, pos_z] <> nil) then
      xNeg := Unit1.RoomArr[pos_x - 1, pos_y, pos_z];
    //else Showmessage('Roo xNeg is nil')
  //else ShowMessage('xNeg Out of Array');

  if (pos_y + 1 <= Unit1.Room_y) then
    if (Unit1.RoomArr[pos_x, pos_y + 1, pos_z] <> nil) then
      yPos := Unit1.RoomArr[pos_x, pos_y + 1, pos_z];
    //else Showmessage('Room yPos is nil')
  //else ShowMessage('yPos Out of Array');

  if (pos_y - 1 >= 0) then
    if (Unit1.RoomArr[pos_x, pos_y - 1, pos_z] <> nil) then
      yNeg := Unit1.RoomArr[pos_x, pos_y - 1, pos_z];
    //else Showmessage('Room yNeg is nil')
  //else ShowMessage('yNeg Out of Array');

  if (pos_z + 1 <= Unit1.Room_z) then
    if (Unit1.RoomArr[pos_x, pos_y, pos_z + 1] <> nil) then
      zPos := Unit1.RoomArr[pos_x, pos_y, pos_z + 1];
    //else Showmessage('Room zPos is nil')
  //else ShowMessage('zPos Out of Array');

  if (pos_z - 1 >= 0) then
    if (Unit1.RoomArr[pos_x, pos_y, pos_z - 1] <> nil) then
      zNeg := Unit1.RoomArr[pos_x, pos_y, pos_z - 1];
    //else Showmessage('Room zNeg is nil')
  //else ShowMessage('zNeg Out of Array');
end;
}

function TRoom.GetDescription: string;
begin
  result := description; //wenn hier ein error erscheint ist es sehr warscheinlich, dass der Raum gar nicht existiert
end;

function TRoom.GetRoomID(): integer;
begin
  result := RoomID;
end;
 {
function TRoom.GetNeighborRooms(_direction: string): TRoom;
begin
  case _direction of
    'xPos': result := xPos;
    'xNeg': result := xNeg;
    'yPos': result := yPos;
    'yNeg': result := yNeg;
    'zPos': result := zPos;
    'zNeg': result := zNeg;
  else
    ShowMessage('Rufe GetNeighborRooms nur mit xPos, xNeg, yPos, yNeg, zPos, zNeg auf.');
  end;
end;
       }
function TRoom.GetVisited(): boolean;
begin
  result := visited;
end;
procedure TRoom.SetVisited(v: boolean);
begin
  visited := v;
end;
function TRoom.GetImagePath(): string;
begin
  result := ImagePath;
end;

procedure TRoom.AddWeapon(_weapon: TWeapon);
begin
  SetLength(WeaponArr, Length(WeaponArr) + 1);
  WeaponArr[Length(WeaponArr) - 1] := _weapon;
end;

procedure TRoom.AddItem(_item: TItem);
begin
  SetLength(ItemArr, Length(ItemArr) + 1);
  ItemArr[Length(ItemArr) - 1] := _item;
end;
procedure TRoom.AddEnemy(_enemy: TEnemy);
begin
  SetLength(EnemyArr, Length(EnemyArr) + 1);
  EnemyArr[Length(EnemyArr) - 1] := _enemy;
end;
procedure TRoom.AddRoomObject(_roomObject: TRoomObject);
begin
  SetLength(RoomObjectArr, Length(RoomObjectArr) + 1);
  RoomObjectArr[Length(RoomObjectArr) - 1] := _roomObject;
end;

procedure TRoom.SetBlockedRight(b: boolean);
begin
  blocked_right := b;
end;

procedure TRoom.SetBlockedLeft(b: boolean);
begin
  blocked_left := b;
end;

procedure TRoom.SetBlockedTop(b: boolean);
begin
  blocked_top := b;
end;

procedure TRoom.SetBlockedBottom(b: boolean);
begin
  blocked_bottom := b;
end;

procedure TRoom.SetDoorRight(b: boolean);
begin
  door_right := b;
end;

procedure TRoom.SetDoorLeft(b: boolean);
begin
  door_left := b;
end;

procedure TRoom.SetDoorTop(b: boolean);
begin
  door_top := b;
end;

procedure TRoom.SetDoorBottom(b: boolean);
begin
  door_bottom := b;
end;

function TRoom.GetBlockedRight: boolean;
begin
  result := blocked_right;
end;

function TRoom.GetBlockedLeft: boolean;
begin
  result := blocked_left;
end;

function TRoom.GetBlockedTop: boolean;
begin
  result := blocked_top;
end;

function TRoom.GetBlockedBottom: boolean;
begin
  result := blocked_bottom;
end;

function TRoom.GetDoorRight: boolean;
begin
  result := door_right;
end;

function TRoom.GetDoorLeft: boolean;
begin
  result := door_left;
end;

function TRoom.GetDoorTop: boolean;
begin
  result := door_top;
end;

function TRoom.GetDoorBottom: boolean;
begin
  result := door_bottom;
end;


end.

