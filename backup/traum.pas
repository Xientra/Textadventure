unit TRaum;

{$mode objfpc}{$H+}

interface

uses

  Classes, SysUtils;

type
  TRoom = class
  public
    constructor Create();
  private
    _RoomArray: Array of Array of Array of TRoom;

    Pos_x, Pos_y, Pos_z: integer;
    Oben, Unten, Norden, Westen, Sueden, Osten: TRoom;

    procedure SetExits();
  end;

implementation

constructor TRoom.Create();
begin
  _RoomArray := MainUnit.RoomArray;
end;

procedure TRoom.SetExits();
begin
  Norden := _RoomArray[Pos_x + 3, Pos_y, Pos_z];
end;

{
01 02 03 04  I--> x
05 06 07 08  I
09 10 11 12  V
}          //y
end.

