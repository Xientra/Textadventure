unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TRoom = class
    private
    description: string;
    visited: boolean;
  public
    constructor Create(_description: string);
    function getDescription: string;
    function getVisited: boolean;
    procedure setVisited(v: boolean);
  private
    RoomArray: Array of Array of Array of TRoom;
    xPosition, yPosition, zPosition: integer;
    xPos, xNeg, yPos, yNeg, zPos, zNeg: TRoom; //zPos = Up; zNeg = Unten; xPos = rechts(?) usw...
  end;

implementation

uses Unit1; //entweder machen wir das damit oder wir übergeben das RoomArray über Create

constructor TRoom.Create(_description: string);
begin
  description := _description;
  RoomArray := Unit1.RoomArr;
  xPos := RoomArray[xPos + 1, yPos, zPos];
  xNeg := RoomArray[xPos - 1, yPos, zPos];
  yPos := RoomArray[xPos, yPos + Unit1.Room_y, zPos];
  yNeg := RoomArray[xPos, yPos - Unit1.Room_y, zPos];
  zPos := RoomArray[xPos, yPos + (Unit1.Room_y * Unit1.Room_z), zPos];
  zNeg := RoomArray[xPos, yPos - (Unit1.Room_y * Unit1.Room_z), zPos];
end;

function TRoom.getDescription: string;
begin
  result := description;
end;

function TRoom.getVisited: boolean;
begin
  result := visited;
end;

procedure TRoom.setVisited(v: boolean);
begin
  visited := v;
end;


end.

