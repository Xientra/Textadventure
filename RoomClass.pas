unit RoomClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage},
  EnemyClass{für TEnemy}, BossClass{für TBoss}, ItemClass{für TItem}, WeaponClass{für TWeapon}, RoomObjectClass{für TRoomObject};

type
  TRoom = class
  public
    //da man anscheinend keine Array of ... mit functions returnen kann müssen diese Array public sein
    EnemyArr: Array of TEnemy; //Gegner im Raum
    WeaponArr: Array of TWeapon; //Waffen im Raum
    ItemArr: Array of TItem; //Items im Raum
    RoomObjectArr: Array of TRoomObject; //RoomObjects im Raum
    Boss: TBoss; //der Vollständigkeit halber

    constructor Create(_description: string; _imagePath: string; _pos_x, _pos_y, _pos_z: integer);

    function GetDescription: string;
    procedure SetDescriptionVisited(d: string);
    function GetImagePath(): string;
    procedure SetImagePathVisited(d: string);

    function GetVisited: boolean;
    procedure SetVisited(v: boolean);
    function GetItemPickedUp: boolean;
    procedure SetItemPickedUp(v: boolean);

    function GetPosX: Integer;
    function GetPosY: Integer;
    function GetPosZ: Integer;

    //Get/Set stuff über Ausgänge in alle Richtungen
    procedure SetFakeRight(b: boolean);
    procedure SetFakeLeft(b: boolean);
    procedure SetFakeTop(b: boolean);
    procedure SetFakeBottom(b: boolean);

    function GetFakeRight: boolean;
    function GetFakeLeft: boolean;
    function GetFakeTop: boolean;
    function GetFakeBottom: boolean;

    procedure SetDoorRight(b: boolean; door_index: integer = -1);
    procedure SetDoorLeft(b: boolean; door_index: integer = -1);
    procedure SetDoorTop(b: boolean; door_index: integer = -1);
    procedure SetDoorBottom(b: boolean; door_index: integer = -1);

    function GetDoorRight: boolean;
    function GetDoorLeft: boolean;
    function GetDoorTop: boolean;
    function GetDoorBottom: boolean;
    //Schlüsselloch Prinzip

    function GetDoorIndexRight: integer;
    function GetDoorIndexLeft: integer;
    function GetDoorIndexTop: integer;
    function GetDoorIndexBottom: integer;

    procedure AddEnemy(_enemy: TEnemy);
    procedure AddBoss(_boss: TBoss);
    procedure AddWeapon(_weapon: TWeapon);
    procedure AddItem(_item: TItem);
    procedure AddRoomObject(_roomObject: TRoomObject);

  private

    description: string;
    description_visited:string;
    ImagePath: string;
    ImagePathVisited: string;
    visited: boolean; //wurde bereits besucht oder nicht
    ItemPickedUp: booleaN;
    //Position des Raumes
    pos_x, pos_y, pos_z: integer;
    //Tür Variablen
    Fake_right, Fake_left, Fake_top, Fake_bottom : boolean;
    door_right, door_left, door_top, door_bottom: boolean;
    doorIndex_right, doorIndex_left, doorIndex_top, doorIndex_bottom: integer;
  end;

implementation

uses Unit1;

constructor TRoom.Create(_description: string; _imagePath: string; _pos_x, _pos_y, _pos_z: integer);
begin
  inherited Create;
  description := _description;
  description_visited := description;
  ImagePath := _imagePath;
  ImagePathVisited := ImagePath;
  visited := false;
  ItemPickedUp:= false;
  pos_x := _pos_x;
  pos_y := _pos_y;
  pos_z := _pos_z;

  //Türen stuff
  Fake_right:= false;
  Fake_left := false;
  Fake_top := false;
  Fake_bottom := false;
  door_right := false;
  door_left := false;
  door_top := false;
  door_bottom := false;
end;

//Get Position
function TRoom.GetPosX:Integer; begin result := pos_x; end;
function TRoom.GetPosY:Integer; begin result := pos_y; end;
function TRoom.GetPosZ:Integer; begin result := pos_z; end;

//Get Room Data
function TRoom.GetDescription: string;
begin
  if visited = false then
  result := description //wenn hier ein error erscheint ist es sehr warscheinlich, dass der Raum gar nicht existiert
  else result := description_visited;
end;

function TRoom.GetImagePath(): string;
begin
  if ItemPickedUp = false then
  result := ImagePath
  else result := ImagePathVisited;
end;

function TRoom.GetVisited(): boolean;
begin
  result := visited;
end;
procedure TRoom.SetVisited(v: boolean);
begin
  visited := v;
end;
function TRoom.GetItemPickedUp(): boolean;
begin
  result := ItemPickedUp;
end;
procedure TRoom.SetItemPickedUp(v: boolean);
begin
  ItemPickedUp := v;
end;
procedure TRoom.SetDescriptionVisited(d: string);
begin
  description_visited := d;
end;
procedure TRoom.SetImagePathVisited(d: string);
begin
  ImagePathVisited := d;
end;

//Add Stuff
procedure TRoom.AddEnemy(_enemy: TEnemy);
begin
  SetLength(EnemyArr, Length(EnemyArr) + 1);
  EnemyArr[Length(EnemyArr) - 1] := _enemy;
end;
procedure TRoom.AddBoss(_boss: TBoss);
begin
  if (Boss <> nil) then Showmessage('The boss '+Boss.GetName()+' of this Room was not nil before.');
  Boss := _boss;
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
procedure TRoom.AddRoomObject(_roomObject: TRoomObject);
begin
  SetLength(RoomObjectArr, Length(RoomObjectArr) + 1);
  RoomObjectArr[Length(RoomObjectArr) - 1] := _roomObject;
end;

//TÜREN!
procedure TRoom.SetFakeRight(b: boolean);
begin
  Fake_right := b;
end;
procedure TRoom.SetFakeLeft(b: boolean);
begin
  Fake_left := b;
end;
procedure TRoom.SetFakeTop(b: boolean);
begin
  Fake_top := b;
end;
procedure TRoom.SetFakeBottom(b: boolean);
begin
  Fake_bottom := b;
end;

procedure TRoom.SetDoorRight(b: boolean; door_index: integer = -1);
begin
  door_right := b;
  doorIndex_right := door_index;
end;
procedure TRoom.SetDoorLeft(b: boolean; door_index: integer = -1);
begin
  door_left := b;
  doorIndex_left := door_index;
end;
procedure TRoom.SetDoorTop(b: boolean; door_index: integer = -1);
begin
  door_top := b;
  doorIndex_top := door_index;
end;
procedure TRoom.SetDoorBottom(b: boolean; door_index: integer = -1);
begin
  door_bottom := b;
  doorIndex_bottom := door_index;
end;

function TRoom.GetFakeRight: boolean;
begin
  result := Fake_right;
end;
function TRoom.GetFakeLeft: boolean;
begin
  result := Fake_left;
end;
function TRoom.GetFakeTop: boolean;
begin
  result := Fake_top;
end;
function TRoom.GetFakeBottom: boolean;
begin
  result := Fake_bottom;
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

//Schlüsselloch Prinzip


function TRoom.GetDoorIndexRight: integer;
begin
  result := doorIndex_right;
end;
function TRoom.GetDoorIndexLeft: integer;
begin
  result := doorIndex_left;
end;
function TRoom.GetDoorIndexTop: integer;
begin
  result := doorIndex_top;
end;
function TRoom.GetDoorIndexBottom: integer;
begin
  result := doorIndex_bottom;
end;
end.
