unit YouDied;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;

implementation
uses unit1, menue;
{$R *.lfm}

{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
begin
  Form1.visible := false;
  Form2.visible := true;
  Form3.visible := false;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Form2.close;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
  if (Form3.AlphaBlendValue < 255) then
    Form3.AlphaBlendValue := Form3.AlphaBlendValue + 1
  else begin
    Form3.AlphaBlendValue := 255;
    Timer1.Enabled := false;
  end;
end;

end.
