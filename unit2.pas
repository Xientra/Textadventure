unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage};

type
  TRoom = class
    private
    description: string;
    visited: boolean;
  public
    constructor Create(_description: string; _pos_x, _pos_y, _pos_z: integer);
    function GetDescription: string;
    function GetRoomID(): integer;
    function GetNeighborRooms(_direction: string): TRoom;
    function GetVisited: boolean;
    procedure SetVisited(v: boolean);

  private
    RoomArray: Array of Array of Array of TRoom;
    pos_x, pos_y, pos_z: integer;
    RoomID: integer;
    xPos, xNeg, yPos, yNeg, zPos, zNeg: TRoom; //zPos = Up; zNeg = Unten; xPos = rechts(?) usw...

    procedure SetNeighborRooms();


  end;

implementation

uses Unit1; //entweder machen wir das damit oder wir übergeben das RoomArray über Create

constructor TRoom.Create(_description: string; _pos_x, _pos_y, _pos_z: integer);
begin
  description := _description;
  _pos_x := pos_x;
  _pos_y := pos_y;
  _pos_z := pos_z;
  RoomID := _pos_x*100 + _pos_y*10 +_pos_z;

  RoomArray := Unit1.RoomArr;
  //Suchen der NachbarRäume


end;

procedure TRoom.SetNeighborRooms();
begin
  if (pos_x + 1 <= Unit1.Room_x) then
    xPos := RoomArray[pos_x + 1, pos_y, pos_z];
  if (pos_x - 1 >= 0) then
    xNeg := RoomArray[pos_x - 1, pos_y, pos_z];

  if (pos_y + 1 <= Unit1.Room_y) then
    yPos := RoomArray[pos_x, pos_y + 1, pos_z];
  if (pos_y - 1 >= 0) then
    yNeg := RoomArray[pos_x, pos_y - 1, pos_z];

  if (pos_z + 1 <= Unit1.Room_z) then
    zPos := RoomArray[pos_x, pos_y, pos_z + 1];
  if (pos_z - 1 >= 0) then
    zNeg := RoomArray[pos_x, pos_y, pos_z - 1];

  {
  yPos := RoomArray[pos_x, pos_y + Unit1.Room_y, pos_z];
  yNeg := RoomArray[pos_x, pos_y - Unit1.Room_y, pos_z];
  zPos := RoomArray[pos_x, pos_y, pos_z + (Unit1.Room_y * Unit1.Room_z)];
  zNeg := RoomArray[pos_x, pos_y, pos_z - (Unit1.Room_y * Unit1.Room_z)];
  }
end;

function TRoom.GetDescription: string;
begin
  result := description;
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

