unit YouDied;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Header_Label: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseEnter(Sender: TObject);
    procedure Image1MouseLeave(Sender: TObject);
    procedure Image2MouseEnter(Sender: TObject);
    procedure Image2MouseLeave(Sender: TObject);
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



procedure TForm3.Timer1Timer(Sender: TObject);
begin
  if (Form3.AlphaBlendValue < 255) then
    Form3.AlphaBlendValue := Form3.AlphaBlendValue + 1
  else begin
    Form3.AlphaBlendValue := 255;
    Timer1.Enabled := false;
  end;
end;

procedure TForm3.Image1Click(Sender: TObject);
begin
  Form1.visible := false;
  Form2.visible := true;
  Form3.visible := false;
end;

procedure TForm3.Image2Click(Sender: TObject);
begin
  Form2.close;
end;

procedure TForm3.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin Image1.Picture.LoadFromFile('Images/Buttons/Button_down.png'); end;
procedure TForm3.Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin Image1.Picture.LoadFromFile('Images/Buttons/Button.png'); end;
procedure TForm3.Image2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin Image2.Picture.LoadFromFile('Images/Buttons/Button_down.png'); end;
procedure TForm3.Image2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin Image2.Picture.LoadFromFile('Images/Buttons/Button.png'); end;

procedure TForm3.Image1MouseEnter(Sender: TObject); begin Image1.Picture.LoadFromFile('Images/Buttons/Button_hover.png'); end;
procedure TForm3.Image1MouseLeave(Sender: TObject); begin Image1.Picture.LoadFromFile('Images/Buttons/Button_down.png'); end;
procedure TForm3.Image2MouseEnter(Sender: TObject); begin Image2.Picture.LoadFromFile('Images/Buttons/Button_hover.png'); end;
procedure TForm3.Image2MouseLeave(Sender: TObject); begin Image2.Picture.LoadFromFile('Images/Buttons/Button_down.png'); end;



end.
