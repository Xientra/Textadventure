unit PlayerClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage},
  RoomClass{für TRoom}, WeaponClass{Für TWeapon};

type
  TPlayer = class
  public
    constructor Create(startRoom: TRoom; startWeapon: TWeapon);
    procedure ChangeRoom(_direction: string);
    function GetCurrendRoom(): TRoom;
    function GetCurrendWeapon(): TWeapon;
  private
    currendRoom: TRoom;
    currendWeapon: TWeapon;
  end;

implementation

uses unit1;

constructor TPlayer.Create(startRoom: TRoom, startWeapon: TWeapon);
begin
  inherited Create;
  currendRoom := startRoom;
  currendWeapon := startWeapon;
  //ShowMessage('PlayerCreated');
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

function TPlayer.GetCurrendRoom(): TRoom;
begin
  result := currendRoom;
end;
function TPlayer.GetCurrendWeapon(): TWeapon;
begin
  result := currendWeapon;
end;

end.

