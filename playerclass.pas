unit PlayerClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage},
  Unit2{für TRoom};

type
  TPlayer = class
  public
    constructor Create(startRoom: TRoom);
    procedure ChangeRoom(_direction: string);
    function GetCurrendRoom(): TRoom;
  private
    currendRoom: TRoom;
  end;

implementation
uses unit1;

constructor TPlayer.Create(startRoom: TRoom);
begin
  inherited Create;
  currendRoom := startRoom;
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

end.

