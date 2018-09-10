unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls{für die Bilder}, StdCtrls{für die Timer}, LCLType{für die Tasteneingaben (wie VK_SPACE)},
  Unit2{für TRoom}, PlayerClass{für TPlayer};

type

  { TForm1 }

  TForm1 = class(TForm)

    Btn1_Label: TLabel;
    Btn2_Label: TLabel;
    Btn3_Label: TLabel;
    Btn4_Label: TLabel;
    Btn1_Image: TImage;
    Btn2_Image: TImage;
    Btn3_Image: TImage;
    Btn4_Image: TImage;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    RoomPicture: TImage;
    Label_Leave: TLabel;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      //Its a secret!
    Memo1: TMemo;
    procedure Btn1Click(Sender: TObject);
    procedure Btn2Click(Sender: TObject);
    procedure Btn3Click(Sender: TObject);
    procedure Btn4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Label_LeaveClick(Sender: TObject);

  private
    procedure CreateRooms();
    procedure CreateARoom(_description: string; _imagePath: string; _pos_x, _pos_y, _pos_z: integer);
    //procedure SetAllNeighborRooms();

    procedure Button_1_Action();
    procedure Button_2_Action();
    procedure Button_3_Action();
    procedure Button_4_Action();
    procedure UpdateUI();

  public

  end;

var
  Form1: TForm1;
  Timer1: TTimer;

  RoomArr: Array of Array of Array of TRoom;
  Room_x, Room_y, Room_z: integer;
  Player1: TPlayer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  i, ii: integer;
begin

  //Set RoomArray size
  Room_x := 5-1;
  Room_y := 5-1;
  Room_z := 5-1;

  //initilise RoomArray
  SetLength(RoomArr, Room_x);
  for i := 0 to Room_y - 1 do
  begin
    SetLength(RoomArr[i], Room_y);
    for ii := 0 to Room_z - 1 do SetLength(RoomArr[i, ii], Room_z);
  end;

  CreateRooms(); //Creates all the Rooms
  //SetAllNeighborRooms();
  Player1 := TPlayer.Create(RoomArr[0, 0, 0]);

  Memo1.Clear();
  Memo1.Lines.Add(Player1.GetCurrendRoom().GetDescription());
  RoomPicture.Picture.LoadFromFile(Player1.GetCurrendRoom().GetImagePath());
end;

procedure TForm1.CreateRooms();
begin

  CreateARoom('CathedralRoom.', 'Images/Rooms/CathedralRoom.png', 0, 0, 0);
  CreateARoom('You are in HELL', 'Images/Rooms/Höle.png', 1, 0, 0);


  //CreateARoom('Room to the xPos from 222', 3, 2, 2);
  //CreateARoom('Room to the xNeg from 222', 1, 2, 2);
  //CreateARoom('Room to the yPos from 222', 2, 3, 2);
  //CreateARoom('Room to the yNeg from 222', 2, 1, 2);

end;

//ist besser, damit die position an der der Raum erstellt wurde auf jeden fall dem Raum bekannt ist
procedure TForm1.CreateARoom(_description: string; _imagePath: string; _pos_x, _pos_y, _pos_z: integer);
begin
  RoomArr[_pos_x, _pos_y, _pos_z] := TRoom.Create(_description, _imagePath, _pos_x, _pos_y, _pos_z);
end;

{
procedure TForm1.SetAllNeighborRooms(); //for each created Room we have to set their Neighbor Rooms once all Rooms are created
var
  x, y, z: integer;
begin

  for z := 0 to Room_z - 1 do
    for y := 0 to Room_y - 1 do
      for x := 0 to Room_x - 1 do
        if (RoomArr[x, y, z] <> nil) then RoomArr[x, y, z].SetNeighborRooms();
end;
}

procedure TForm1.Btn1Click(Sender: TObject); begin Button_1_Action(); end;
procedure TForm1.Btn2Click(Sender: TObject); begin Button_2_Action(); end;
procedure TForm1.Btn3Click(Sender: TObject); begin Button_3_Action(); end;
procedure TForm1.Btn4Click(Sender: TObject); begin Button_4_Action(); end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (RoomArr[StrToInt(Edit1.Text), StrToInt(Edit2.Text), StrToInt(Edit3.Text)] = nil) then
    Memo1.Lines.Add('nil')
  else
    Memo1.Lines.Add(RoomArr[StrToInt(Edit1.Text), StrToInt(Edit2.Text), StrToInt(Edit3.Text)].GetDescription);

end;

procedure TForm1.Button_1_Action();
begin
  //ShowMessage('Button 1 pressed');
  Player1.ChangeRoom('xPos');
  UpdateUI();
end;
procedure TForm1.Button_2_Action();
begin
  //ShowMessage('Button 2 pressed');
  Player1.ChangeRoom('xNeg');
  UpdateUI();
end;
procedure TForm1.Button_3_Action();
begin
  //ShowMessage('Button 3 pressed');
  Player1.ChangeRoom('yPos');
  UpdateUI();
end;
procedure TForm1.Button_4_Action();
begin
  //ShowMessage('Button 4 pressed');
  Player1.ChangeRoom('yNeg');
  UpdateUI();
end;

procedure TForm1.UpdateUI();
begin
  Memo1.Clear();
  Memo1.Lines.Add(Player1.GetCurrendRoom().GetDescription());
  RoomPicture.Picture.LoadFromFile(Player1.GetCurrendRoom().GetImagePath());
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then Application.Terminate();

  if (Key = VK_1) then Button_1_Action();
  if (Key = VK_2) then Button_2_Action();
  if (Key = VK_3) then Button_3_Action();
  if (Key = VK_4) then Button_4_Action();
end;

procedure TForm1.Label_LeaveClick(Sender: TObject);
begin
  Application.Terminate();
end;

end.

