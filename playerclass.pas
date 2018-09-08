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

constructor TPlayer.Create(startRoom: TRoom);
begin
  inherited Create;
  currendRoom := startRoom;
  //ShowMessage('PlayerCreated');
end;

procedure TPlayer.ChangeRoom(_direction: string);
begin
  currendRoom := currendRoom.GetNeighborRooms(_direction);
end;

function TPlayer.GetCurrendRoom(): TRoom;
begin
  result := currendRoom;
end;

end.

