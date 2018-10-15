unit Menue;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, lclintf{to open documents};

type

  { TForm2 }

  TForm2 = class(TForm)
    Image1_Btn: TImage;
    Image2_Btn: TImage;
    Image3_Btn: TImage;
    Head_Label: TLabel;
    Label1_Btn: TLabel;
    Label1_Btn1: TLabel;
    Label1_Btn2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnClick1(Sender: TObject);
    procedure BtnClick2(Sender: TObject);
    procedure BtnClick3(Sender: TObject);
    procedure BtnMouseDown1(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnMouseUp1(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnMouseDown2(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnMouseUp2(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnMouseDown3(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnMouseUp3(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnMouseEnter1(Sender: TObject);
    procedure BtnMouseLeave1(Sender: TObject);
    procedure BtnMouseEnter2(Sender: TObject);
    procedure BtnMouseLeave2(Sender: TObject);
    procedure BtnMouseEnter3(Sender: TObject);
    procedure BtnMouseLeave3(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

uses unit1;

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormCreate(Sender: TObject);
begin

end;

procedure TForm2.BtnClick1(Sender: TObject);
begin
  Form2.close;
end;

procedure TForm2.BtnClick2(Sender: TObject);
begin
  OpenDocument('HowToPlay.txt');
end;

procedure TForm2.BtnClick3(Sender: TObject);
begin
  Application.Terminate();
end;

procedure TForm2.BtnMouseDown1(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin Image1_Btn.Picture.LoadFromFile('Images/Buttons/Button_down.png'); end;
procedure TForm2.BtnMouseUp1(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin Image1_Btn.Picture.LoadFromFile('Images/Buttons/Button.png'); end;
procedure TForm2.BtnMouseDown2(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin Image2_Btn.Picture.LoadFromFile('Images/Buttons/Button_down.png'); end;
procedure TForm2.BtnMouseUp2(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin Image2_Btn.Picture.LoadFromFile('Images/Buttons/Button.png'); end;
procedure TForm2.BtnMouseDown3(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin Image3_Btn.Picture.LoadFromFile('Images/Buttons/Button_down.png'); end;
procedure TForm2.BtnMouseUp3(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin Image3_Btn.Picture.LoadFromFile('Images/Buttons/Button.png'); end;

procedure TForm2.BtnMouseEnter1(Sender: TObject); begin Image1_Btn.Picture.LoadFromFile('Images/Buttons/Button_hover.png'); end;
procedure TForm2.BtnMouseLeave1(Sender: TObject); begin Image1_Btn.Picture.LoadFromFile('Images/Buttons/Button.png'); end;
procedure TForm2.BtnMouseEnter2(Sender: TObject); begin Image2_Btn.Picture.LoadFromFile('Images/Buttons/Button_hover.png'); end;
procedure TForm2.BtnMouseLeave2(Sender: TObject); begin Image2_Btn.Picture.LoadFromFile('Images/Buttons/Button.png'); end;
procedure TForm2.BtnMouseEnter3(Sender: TObject); begin Image3_Btn.Picture.LoadFromFile('Images/Buttons/Button_hover.png'); end;
procedure TForm2.BtnMouseLeave3(Sender: TObject); begin Image3_Btn.Picture.LoadFromFile('Images/Buttons/Button.png'); end;


end.
