unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LCLType, ActnList, MMSystem{für die Musik},
  RoomClass{für TRoom}, PlayerClass{für TPlayer}, EnemyClass{für TEnemy}, WeaponClass{für TWeapon}, ItemClass{für TItem}, SkillClass{I think you know by now...};

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
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Memo_Description: TMemo;
    Image1: TImage;
    RoomPicture: TImage;
    Label_Leave: TLabel;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      //Its a secret!
    Memo1: TMemo;
    procedure Btn1Click(Sender: TObject);
    procedure Btn2Click(Sender: TObject);
    procedure Btn3Click(Sender: TObject);
    procedure Btn4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

    procedure PrintRoomData();
    procedure PlayerEndTurn();
    procedure PrintSkillData();

    procedure ChangeSituation(_situation: integer); //damit man die Button label änder kann wenn sie geändert wird
    procedure ChangeUIState(_state: integer);

  end;

//----------------------------------------------------------------------------//
//                         Schau in die ToDoListe                             //
//----------------------------------------------------------------------------//

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
  UIState: integer;

  inventoryIndex: integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  i, ii: integer;
begin
  inventoryIndex := 0;


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
  Player1 := TPlayer.Create(RoomArr[0, 0, 0], TWeapon.Create('Fists', 'Just your good old hands.', 10, 0, 0, 0), 100);
  Player1.AddItem(TItem.Create('someItem', 'it is useless'));
  Player1.AddSkill(TSkill.Create('Some Skill', 'You can KILL with it.' +sLineBreak+ 'It deals Strike Damage', 'Images/Skills/someSkill.png', 2, 1.5, 0, 0, 0));
  Player1.AddSkill(TSkill.Create('Some other Skill', 'This one is just useless...'+sLineBreak+ 'It deals Slash Damage', 'Images/Skills/someOtherSkill.png', 5, 0, 0, 1.2, 0));


  ChangeSituation(0); //updates UI
  //UpdateUI();
  Memo_Description.Clear();
end;

procedure TForm1.CreateRooms();
begin

  CreateARoom('CathedralRoom.', 'Images/Rooms/CathedralRoom.png', 0, 0, 0);
  CreateARoom('You are in HELL', 'Images/Rooms/Höle.png', 1, 0, 0);
  CreateARoom('HereShould be a Enemy', 'Images/Rooms/Höle.png', 0, 1, 0);
  RoomArr[0, 1, 0].AddEnemy(TEnemy.Create(20, 5));
  RoomArr[0, 1, 0].EnemyArr[0].SetResistants(1.12344536, 1, 1);
  RoomArr[0, 1, 0].EnemyArr[0].SetItemDrop(TItem.Create('Literely just Trash', 'Like acually.'));
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

procedure TForm1.Button2Click(Sender: TObject);
begin   //Music test
     if Edit4.text = '1' then begin
        PlaySound('music\Dancing in the Moonlight piano.wav',0,SND_ASYNC);
     end else if Edit4.text = '2' then begin
          PlaySound('music\Textadventure Gwyn Theme piano.wav',0,SND_ASYNC);
     end;
end;

procedure TForm1.Button_1_Action();
var
  _dmg: real;
begin
  //ShowMessage('Button 1 pressed');
  case UIState of
  0:
    begin
      Player1.ChangeRoom('xPos');
      PrintRoomData();
      OnEnterRoom();
    end;
  1:
    begin
      _dmg := FightingEnemy.DoDamage(Player1.GetCurrendWeapon().GetStrikeDmg(), Player1.GetCurrendWeapon().GetThrustDmg(), Player1.GetCurrendWeapon().GetSlashDmg(), Player1.GetCurrendWeapon().GetMagicDmg());
      Memo1.Clear();
      Memo1.Lines.Add('You delt ' + FloatToStr(Round(_dmg)) + ' The Enemy now has ' + FloatToStr(Round(FightingEnemy.GetHealth())) + ' health left');

      PlayerEndTurn();
    end;
  5:
    begin
      _dmg := FightingEnemy.DoDamage(
        Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetStrikeMulti(),
        Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetThrustMulti(),
        Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetSlashMulti(),
        Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetMagicMulti());
      Memo1.Clear();
      Memo1.Lines.Add('You delt ' + FloatToStr(Round(_dmg)) + ' The Enemy now has ' + FloatToStr(Round(FightingEnemy.GetHealth())) + ' health left');

      ChangeUIState(1);
      PlayerEndTurn();
    end
  else
    Memo1.Lines.Add('lol no');
  end;
end;
procedure TForm1.Button_2_Action();
begin
  //ShowMessage('Button 2 pressed');

  case UIState of
  0:
    begin
      Player1.ChangeRoom('xNeg');
      PrintRoomData();
      OnEnterRoom();
    end;
  1:
    begin
      ChangeUIState(5);
    end;
  5:
    begin
      if (inventoryIndex - 1 >= 0) then inventoryIndex := inventoryIndex - 1
      else ShowMessage('can now go futher down');
      PrintSkillData();
    end
  else
    Memo1.Lines.Add('lol no');
  end;
end;
procedure TForm1.Button_3_Action();
begin
  //ShowMessage('Button 3 pressed');

  case UIState of
  0:
    begin
      Player1.ChangeRoom('yPos');
      PrintRoomData();
      OnEnterRoom();
    end;
  5:
    begin
      if (inventoryIndex + 1 <= length(Player1.Skills) - 1) then inventoryIndex := inventoryIndex + 1
      else ShowMessage('can now go futher up');
      PrintSkillData();
    end
  else
    Memo1.Lines.Add('lol no');
  end;
end;
procedure TForm1.Button_4_Action();
begin
  //ShowMessage('Button 4 pressed');

  case UIState of
  0:
    begin
      Player1.ChangeRoom('yNeg');
      PrintRoomData();
      OnEnterRoom();
    end;
  5:
    begin
      PrintRoomData();
      ChangeUIState(currendSituation);
      Memo_Description.Clear();
    end
  else
    Memo1.Lines.Add('lol no');
  end;
end;

procedure TForm1.PrintRoomData(); //situation = 0
begin
  Memo1.Clear();
  Memo1.Lines.Add(Player1.GetCurrendRoom().GetDescription());
  Image1.Picture.LoadFromFile(Player1.GetCurrendRoom().GetImagePath());
end;

procedure TForm1.PlayerEndTurn(); //situation = 1
var
  i: integer;
begin
  //check if enemy is defeated
  if (FightingEnemy.GetHealth() <= 0) then
  begin
    Memo1.Clear();
    Memo1.Lines.Add('You defeated the Enemy');
    if (FightingEnemy.GetWeaponDrop() <> nil) then
    begin
      PLayer1.AddWeapon((FightingEnemy.GetWeaponDrop()));
      Memo1.Lines.Add('He dropt ' + FightingEnemy.GetWeaponDrop().GetName() + '. It was added to your Inventory.');
    end;
    if (FightingEnemy.GetItemDrop() <> nil) then
    begin
      Player1.AddItem(FightingEnemy.GetItemDrop());
      Memo1.Lines.Add('He dropt ' + FightingEnemy.GetItemDrop().GetName() + '. It was added to your Inventory.');
    end;

    FightingEnemy.Destroy();

    ChangeSituation(0);
  end
  else //Enemy deals damage
  begin
    Player1.ChangeHealthBy(-(FightingEnemy.GetDamage()));
    Memo1.Lines.Add('The Enemy delt: ' + FloatToStr(FightingEnemy.GetDamage()) + ' You now have ' + FloatToStr(Player1.GetHealth()) + ' health left');

    //verringert den cooldoown von jedem skill
    for i := 0 to length(Player1.Skills) - 1 do
      if (Player1.Skills[i] <> nil) then Player1.Skills[i].ReduceCooldown();

  end;
end;

procedure TForm1.PrintSkillData(); //situation = 5
begin
  Memo_Description.Clear();
  Memo_Description.Lines.AddText(Player1.Skills[inventoryIndex].GetName());
  Memo_Description.Lines.Add('');
  Memo_Description.Lines.AddText(Player1.Skills[inventoryIndex].GetDescription());
  Image1.Picture.LoadFromFile(Player1.Skills[inventoryIndex].GetImagePath());
end;

procedure TForm1.OnEnterRoom();
var
  i: integer;
begin
  //1. check nach Gegnern
  if (length(Player1.GetCurrendRoom().EnemyArr) - 1 >= 0) then
    for i := 0 to length(Player1.GetCurrendRoom().EnemyArr) - 1 do
    begin
      //start Fight
      FightingEnemy := Player1.GetCurrendRoom().EnemyArr[i];
      ChangeSituation(1);
    end;

  //2. check nach items
  //3. check nach RoomObjects

  if (currendSituation = 0) then PrintRoomData();
end;

procedure TForm1.ChangeSituation(_situation: integer);
begin
  currendSituation := _situation;
  ChangeUIState(currendSituation);
end;

procedure TForm1.ChangeUIState(_state: integer);
var i: integer;
begin
  UIState := _state;
  case UIState of
    0: //walking UI
    begin
      Btn1_Label.caption := 'x Plus';
      Btn2_Label.caption := 'x Minus';
      Btn3_Label.caption := 'y Plus';
      Btn4_Label.caption := 'y Minus';
      PrintRoomData();
    end;
  1: //fighting UI
    begin
      Btn1_Label.caption := 'Attack';
      Btn2_Label.caption := 'Skills';
      Btn3_Label.caption := 'Items';
      Btn4_Label.caption := 'Flee';

      Memo1.Clear();
      Memo1.Lines.Add('You are now fighting! The Enemy has ' + FloatToStr(FightingEnemy.GetHealth()) + ' health left.');
      Image1.Picture.LoadFromFile(Player1.GetCurrendRoom().GetImagePath());
    end;
  2: ; //weapon or item inventory Menu
  3: ; //weapon inv Menu
  4: ; //item inv Menu
  5: //skills Menu
    begin
      Btn1_Label.caption := 'Use';
      Btn2_Label.caption := 'index Down';
      Btn3_Label.caption := 'index Up';
      Btn4_Label.caption := 'Back';

      inventoryIndex := 0;
      for i := 0 to length(Player1.Skills) - 1 do
        if (Player1.Skills[i] <> nil) then inventoryIndex := i;
      PrintSkillData();
    end;
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

