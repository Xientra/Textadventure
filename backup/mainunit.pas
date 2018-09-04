unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  TRaum;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  Room: Array of Array of Array of TRoom;
  Room_x, Room_y, Room_z: integer;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  i, ii: integer;
begin
  Room_x := 5;
  Room_y := 5;
  Room_z := 5;

  SetLength(Room, Room_x);
  for i := 0 to Room_y - 1 do
  begin
    SetLength(Room[i], Room_y);
    for ii := 0 to Room_z - 1 do
      SetLength(Room[i, ii], Room_z);
  end;
end;

end.




