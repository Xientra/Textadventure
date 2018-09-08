unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage};

type
  TRoom = class
  public
    constructor Create(_description: string; _pos_x, _pos_y, _pos_z: integer);
    function GetDescription: string;
    function GetRoomID(): integer;
    function GetNeighborRooms(_direction: string): TRoom;
    function GetVisited: boolean;
    procedure SetVisited(v: boolean);

  private
    description: string;
    visited: boolean;

    //RoomArray: Array of Array of Array of TRoom;
    pos_x, pos_y, pos_z: integer;
    RoomID: integer;
    xPos, xNeg, yPos, yNeg, zPos, zNeg: TRoom; //zPos = Up; zNeg = Unten; xPos = rechts(?) usw...

    procedure SetNeighborRooms();

  end;

implementation

uses Unit1; //entweder machen wir das damit oder wir übergeben das RoomArray über Create (damit der Raum seine pos benutzen kann)

constructor TRoom.Create(_description: string; _pos_x, _pos_y, _pos_z: integer);
begin
  description := _description;
  pos_x := _pos_x;
  pos_y := _pos_y;
  pos_z := _pos_z;
  RoomID := _pos_x*100 + _pos_y*10 +_pos_z;

  //RoomArray := Unit1.RoomArr;

  SetNeighborRooms(); //Suchen der NachbarRäume
  //ShowMessage(IntToStr(pos_x) + IntToStr(pos_y) + IntToStr(pos_z));
  //if (description = 'Be The Room.') then ShowMessage(Unit1.RoomArr[pos_x, pos_y, pos_z].GetDescription()); //wenn das ausgeführt wir existiert noch kein Room im Array ich nehme an die werden erst nach Create assinged
end;

procedure TRoom.SetNeighborRooms(); //Das kommt absolut nicht klar mit den Rändern des Array (also so gar nicht trotz der if abfragen die da schon sind)
begin
  if (pos_x + 1 <= Unit1.Room_x) and (Unit1.RoomArr[pos_x + 1, pos_y, pos_z] <> nil) then
    xPos := Unit1.RoomArr[pos_x + 1, pos_y, pos_z];
  if (pos_x - 1 >= 0) and (Unit1.RoomArr[pos_x - 1, pos_y, pos_z] <> nil) then
    xNeg := Unit1.RoomArr[pos_x - 1, pos_y, pos_z];

  if (pos_y + 1 <= Unit1.Room_y) and (Unit1.RoomArr[pos_x, pos_y + 1, pos_z] <> nil) then
    yPos := Unit1.RoomArr[pos_x, pos_y + 1, pos_z];
  if (pos_y - 1 >= 0) and (Unit1.RoomArr[pos_x, pos_y - 1, pos_z] <> nil) then
    yNeg := Unit1.RoomArr[pos_x, pos_y - 1, pos_z];

  if (pos_z + 1 <= Unit1.Room_z) and (Unit1.RoomArr[pos_x, pos_y, pos_z + 1] <> nil) then
    zPos := Unit1.RoomArr[pos_x, pos_y, pos_z + 1];
  if (pos_z - 1 >= 0) and (Unit1.RoomArr[pos_x, pos_y, pos_z - 1] <> nil) then
    zNeg := Unit1.RoomArr[pos_x, pos_y, pos_z - 1];

  //ShowMessage(xPos.GetDescription());
end;

function TRoom.GetDescription: string;
begin
  result := description; //wenn hier ein error erscheint ist es sehr warscheinlich, dass der Raum gar nicht existiert
end;

function TRoom.GetRoomID: integer;
begin
  result := RoomID;
end;

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

function TRoom.GetVisited(): boolean;
begin
  result := visited;
end;
procedure TRoom.SetVisited(v: boolean);
begin
  visited := v;
end;


end.

