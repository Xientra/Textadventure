unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage};

type
  TRoom = class
  public
    constructor Create(_description: string; _pos_x, _pos_y, _pos_z: integer);
    //procedure SetNeighborRooms();
    function GetDescription: string;
    function GetRoomID(): integer;
    //function GetNeighborRooms(_direction: string): TRoom;
    function GetVisited: boolean;
    procedure SetVisited(v: boolean);
    function GetPosX:Integer;
    function GetPosY:Integer;
    function GetPosZ:Integer;

  private

    description: string;
    visited: boolean;

    //RoomArray: Array of Array of Array of TRoom;
    pos_x, pos_y, pos_z: integer;
    RoomID: integer;
    xPos, xNeg, yPos, yNeg, zPos, zNeg: TRoom; //zPos = Up; zNeg = Unten; xPos = rechts(?) usw...


  end;

implementation

uses Unit1; //entweder machen wir das damit oder wir übergeben das RoomArray über Create (damit der Raum seine pos benutzen kann)

constructor TRoom.Create(_description: string; _pos_x, _pos_y, _pos_z: integer);
begin
  description := _description;
  visited := false;
  pos_x := _pos_x;
  pos_y := _pos_y;
  pos_z := _pos_z;
  RoomID := _pos_x*100 + _pos_y*10 +_pos_z;

  //RoomArray := Unit1.RoomArr;

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
procedure TRoom.SetNeighborRooms(); //Das kommt absolut nicht klar mit den Rändern des Array (also so gar nicht trotz der if abfragen die da schon sind)
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
end;     }

function TRoom.GetDescription: string;
begin
  result := description; //wenn hier ein error erscheint ist es sehr warscheinlich, dass der Raum gar nicht existiert
end;

function TRoom.GetRoomID: integer;
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


end.

