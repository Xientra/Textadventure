unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, TRaum;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  //x,y,z: integer;
  Room: Array[0..5,0..5,0..5] of TRoom;
implementation

{$R *.lfm}

//Hi?

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

end.

