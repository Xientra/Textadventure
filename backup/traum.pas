unit TRaum;

{$mode objfpc}{$H+}

interface

uses
<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> 440f79f3dc5187390049b9e6d692ea55ddea6b8a
=======

>>>>>>> 440f79f3dc5187390049b9e6d692ea55ddea6b8a
  Classes, SysUtils;

type
  TRoom = class
<<<<<<< HEAD
<<<<<<< HEAD
    private
    description: string;
    visited: boolean;
    public
    function getdescription: string;
    function getvisited: boolean;
    procedure setdescription(d:string);
    procedure setvisited(v:boolean);
  end;

implementation

function TRoom.getdescription: string;
begin
  result := description;
end;

function TRoom.getvisited: boolean;
begin
  result := visited;
end;

procedure TRoom.setdescription(d:string);
begin
  description := d;
end;


procedure TRoom.setvisited(v:boolean);
begin
  visited := v;
end;

=======
=======
>>>>>>> 440f79f3dc5187390049b9e6d692ea55ddea6b8a
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
<<<<<<< HEAD
>>>>>>> 440f79f3dc5187390049b9e6d692ea55ddea6b8a
=======
>>>>>>> 440f79f3dc5187390049b9e6d692ea55ddea6b8a
end.

