unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls{für die Bilder}, StdCtrls{für die Timer}, LCLType{für die Tasteneingaben (wie VK_SPACE)},
  RoomClass{für TRoom}, PlayerClass{für TPlayer}, EnemyClass{für TEnemy}, WeaponClass{für TWeapon};

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


  public
    procedure OnEnterRoom();

  private
    procedure CreateRooms();
    procedure CreateARoom(_description: string; _imagePath: string; _pos_x, _pos_y, _pos_z: integer);
    //procedure SetAllNeighborRooms();

    procedure Button_1_Action();
    procedure Button_2_Action();
    procedure Button_3_Action();
    procedure Button_4_Action();

    procedure UpdateUI();

  end;

var
  Form1: TForm1;
  Timer1: TTimer;

  RoomArr: Array of Array of Array of TRoom;
  Room_x, Room_y, Room_z: integer;
  Player1: TPlayer;
  FightingEnemy: TEnemy;
  currendSituation: integer; //0 = map; 1 = combat;  = interact with RoomObjects;
  //0: Btn1: Norden; Btn2: Westen; Btn3: Süden; Btn: Osten;
  //1: Btn1: Angriff; Btn2: Skills; Btn3: Items; Btn4: Flee;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  i, ii: integer;
begin
  currendSituation := 0;

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
  Player1 := TPlayer.Create(RoomArr[0, 0, 0], TWeapon.Create('Fists', 'Just your good old hands.', 10, 0, 0, 0);

  UpdateUI();
end;

procedure TForm1.CreateRooms();
begin

  CreateARoom('CathedralRoom.', 'Images/Rooms/CathedralRoom.png', 0, 0, 0);
  CreateARoom('You are in HELL', 'Images/Rooms/Höle.png', 1, 0, 0);
  CreateARoom('HereShould be a Enemy', 'Images/Rooms/Höle.png', 0, 1, 0);
  RoomArr[0, 1, 0].AddEnemy(TEnemy.Create(100));
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
var
  _dmg: real;
begin
  //ShowMessage('Button 1 pressed');
  if (currendSituation = 0) then
  begin
    Player1.ChangeRoom('xPos');
    UpdateUI();
    OnEnterRoom();
  end;
  if (currendSituation = 1) then
  begin
    _dmg := FightingEnemy.DoDamage(Player1.GetCurrendWeapon().GetStrikeDmg(), Player1.GetCurrendWeapon().GetThrustDmg(), Player1.GetCurrendWeapon().GetSlashDmg(), Player1.GetCurrendWeapon().GetMagicDmg());
    Memo1.Clear();
    Memo1.Lines.Add('You delt: ' + FloatToStr(_dmg) + ' The Enemy now has ' + FloatToStr(FightingEnemy.GetHealth()) + 'health left');
  end;
end;
procedure TForm1.Button_2_Action();
begin
  //ShowMessage('Button 2 pressed');
  Player1.ChangeRoom('xNeg');
  UpdateUI();
  OnEnterRoom();
end;
procedure TForm1.Button_3_Action();
begin
  //ShowMessage('Button 3 pressed');
  Player1.ChangeRoom('yPos');
  UpdateUI();
  OnEnterRoom();
end;
procedure TForm1.Button_4_Action();
begin
  //ShowMessage('Button 4 pressed');
  Player1.ChangeRoom('yNeg');
  UpdateUI();
  OnEnterRoom();
end;

procedure TForm1.UpdateUI();
begin
  Memo1.Clear();
  Memo1.Lines.Add(Player1.GetCurrendRoom().GetDescription());
  RoomPicture.Picture.LoadFromFile(Player1.GetCurrendRoom().GetImagePath());
end;

procedure TForm1.OnEnterRoom();
var
  i: integer;
begin
  ShowMessage('Entered a Room');

  //1. check nach Gegnern
  if (length(Player1.GetCurrendRoom().EnemyArr) - 1 >= 0) then
    for i := 0 to length(Player1.GetCurrendRoom().EnemyArr) - 1 do
    begin
      //start Fight
      currendSituation := 1;
      FightingEnemy := Player1.GetCurrendRoom().EnemyArr[i];
    end;

  //2. check nach items
  //3. check nach RoomObjects

  if (currendSituation = 0) then UpdateUI();
  if (currendSituation = 1) then
  begin
    Memo1.Clear();
    Memo1.Lines.Add('You ar now fighting! The Enemy has ' + FloatToStr(FightingEnemy.GetHealth()) + ' health left.');
  end;
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

