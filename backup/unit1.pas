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
    procedure SetButton(_background: TImage; _text: TLabel; toSetTo: boolean);

    procedure PrintRoomData(); //situation = 0
    procedure PlayerEndTurn(); //situation = 1
    procedure PrintWeaponData(); //situation = 2
    procedure PrintItemData(); //situation = 3
    procedure PrintSkillData(); //situation = 5

    procedure ChangeSituation(_situation: integer); //damit man die Button label änder kann wenn sie geändert wird
    procedure ChangeUIState(_state: integer);

    procedure PrintAndUIChange(_changeUITo: integer; _toPrint: string);

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
  UIState, UIStateCopy: integer;

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
  Room_x := 7-1;
  Room_y := 7-1;
  Room_z := 7-1;

  //initilise RoomArray
  SetLength(RoomArr, Room_x);
  for i := 0 to Room_y - 1 do
  begin
    SetLength(RoomArr[i], Room_y);
    for ii := 0 to Room_z - 1 do SetLength(RoomArr[i, ii], Room_z);
  end;

  CreateRooms(); //Creates all the Rooms
  //SetAllNeighborRooms();
  Player1 := TPlayer.Create(RoomArr[1, 0, 0], TWeapon.Create('Fists', 'Just your good old hands.', 'Images/Items/ShortSword.png', 10, 0, 0, 0), 100);
  Player1.AddItem(TItem.Create('some Key', 'it not usefull for any door...','Images/Items/Key1.png'));
  Player1.AddItem(TItem.Create('ITEM', 'ITEM!!!!!!!!!!','Images/Items/ITEM.png'));
  Player1.AddWeapon(TWeapon.Create('Some Sword', 'It is acually sharp even thought it looks a bit blocky.', 'Images/Items/ShortSword.png', 0, 0, 15, 0));
  Player1.AddWeapon(TWeapon.Create('Iron Bar', 'A brocken off piece of a former cell.'+sLineBreak+'It is a bit rosty already...', 'Images/Items/IronBar.png', 0, 0, 15, 0));
  Player1.AddSkill(TSkill.Create('Some Skill', 'You can KILL with it.' +sLineBreak+ 'It deals Strike Damage', 'Images/Skills/someSkill.png', 2, 1.5, 0, 0, 0));
  Player1.AddSkill(TSkill.Create('Some other Skill', 'This one is just useless...'+sLineBreak+ 'It deals Slash Damage', 'Images/Skills/someOtherSkill.png', 5, 0, 0, 1.2, 0));


  ChangeSituation(0); //updates UI
  Memo_Description.Clear();
end;

procedure TForm1.CreateRooms();
begin

  CreateARoom('CathedralRoom.', 'Images/Rooms/CathedralRoom.png', 1, 0, 0);

  CreateARoom('Here Should be an Enemy', 'Images/Rooms/Höle.png', 2, 0, 0);
  CreateARoom('Irgendein Raum', 'Images/Rooms/Höle.png', 2, 1, 0);
  RoomArr[2, 0, 0].AddEnemy(TEnemy.Create(20, 5));
  RoomArr[2, 0, 0].EnemyArr[0].SetResistants(1, 1, 1);
  RoomArr[2, 0, 0].EnemyArr[0].SetItemDrop(TItem.Create('Literely just Trash', 'Like acually.', 'Images/Items/ITEM.png'));

  CreateARoom('Hier Liegt eine Eisenstange', 'Images/Rooms/Höle.png', 3, 0, 0);
  CreateARoom('Vier Wege von hier aus', 'Images/Rooms/Höle.png', 2, 2, 0);
  CreateARoom('Du siehst eine Waffe im nächsten Raum', 'Images/Rooms/Höle.png', 1, 2, 0);
  CreateARoom('WOW hier liegt tatsächlich ein Dolch', 'Images/Rooms/Höle.png', 0, 2, 0);
  CreateARoom('F*cking Goblins', 'Images/Rooms/Höle.png', 2, 3, 0);
  CreateARoom('I see trouble', 'Images/Rooms/Höle.png', 3, 2, 0);
  CreateARoom('And we make it tripple', 'Images/Rooms/Höle.png', 4, 2, 0);
  CreateARoom('Gäb es doch nur Bonfire', 'Images/Rooms/Höle.png', 5, 2, 0);
  CreateARoom('Praise the Bonfire', 'Images/Rooms/Höle.png', 5, 3, 0);
  CreateARoom('Leerer Raum oder so', 'Images/Rooms/Höle.png', 4, 3, 0);
  CreateARoom('Drop den Schlüssel Goblin', 'Images/Rooms/Höle.png', 4, 4, 0);
  CreateARoom('Useless ahead', 'Images/Rooms/Höle.png', 3, 4, 0);
  CreateARoom('Zum Glück hatte ich den schlüssel', 'Images/Rooms/Höle.png', 2, 4, 0);
  CreateARoom('Estus vorraus', 'Images/Rooms/Höle.png', 1, 4, 0);
  CreateARoom('Alexa, spiel Gwyns theme', 'Images/Rooms/Höle.png', 2, 5, 0);
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
begin
  //ShowMessage('Button 1 pressed');
  case UIState of
  0:
    begin
      if (Player1.GetCurrendRoom.GetPosX+1 <= 5) and (RoomArr[Player1.GetCurrendRoom.getPosX+1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] <> nil) then
      begin
        Player1.ChangeRoom('xPos');
        PrintRoomData();
        OnEnterRoom();
      end;
    end;
  1:
    begin
      if (Player1.HasSkills() = true) then ChangeUIState(5) //Skill Menu
      else Memo1.Lines.Add('You have no skills yet.')
    end;
  2:
    begin
      ChangeUIState(currendSituation);
      Memo_Description.Clear();
    end;
  3:
    begin
      ChangeUIState(currendSituation);
      Memo_Description.Clear();
    end;
  5:
    begin
      PrintRoomData();
      ChangeUIState(currendSituation);
      Memo_Description.Clear();

    end

    else Memo1.Lines.Add('lol no');
  end;
end;
procedure TForm1.Button_2_Action();
var
  _dmg: real;
begin
  //ShowMessage('Button 2 pressed');

  case UIState of
  0:
    begin
      if (Player1.GetCurrendRoom.GetPosX-1 >= 0) and (RoomArr[Player1.GetCurrendRoom.getPosX-1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] <> nil) then begin
      Player1.ChangeRoom('xNeg');
      PrintRoomData();
      OnEnterRoom();
      end;
    end;
  1:
    begin
      _dmg := FightingEnemy.DoDamage(Player1.GetCurrendWeapon().GetStrikeDmg(), Player1.GetCurrendWeapon().GetThrustDmg(), Player1.GetCurrendWeapon().GetSlashDmg(), Player1.GetCurrendWeapon().GetMagicDmg());

      //Memo1.Clear();
      //Memo1.Lines.Add('You delt ' + FloatToStr(Round(_dmg)) + ' The Enemy now has ' + FloatToStr(Round(FightingEnemy.GetHealth())) + ' health left');
      PrintAndUIChange(currendSituation, 'You delt ' + FloatToStr(Round(_dmg)) + ' damage.'+sLineBreak+'The Enemy now has ' + FloatToStr(Round(FightingEnemy.GetHealth())) + ' health left');

      PlayerEndTurn();

    end;
  5:
    begin
      _dmg := FightingEnemy.DoDamage(
        Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetStrikeMulti(),
        Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetThrustMulti(),
        Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetSlashMulti(),
        Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetMagicMulti());

      //Memo1.Clear();
      //ChangeUIState(1);
      //Memo1.Lines.Add('You delt ' + FloatToStr(Round(_dmg)) + ' The Enemy now has ' + FloatToStr(Round(FightingEnemy.GetHealth())) + ' health left');

      PrintAndUIChange(1, 'You delt ' + FloatToStr(Round(_dmg)) + ' damage.'+sLineBreak+'The Enemy now has ' + FloatToStr(Round(FightingEnemy.GetHealth())) + ' health left');
      Memo_Description.Clear();

      PlayerEndTurn();
    end;
  99:
    begin
      ChangeUIState(UIStateCopy);
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
      if (Player1.GetCurrendRoom.GetPosY+1 <= 5) and (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY+1,Player1.GetCurrendRoom.getPosZ] <> nil) then begin
      Player1.ChangeRoom('yPos');
      PrintRoomData();
      OnEnterRoom();
      end;
    end;
  1:
    begin
      if (Player1.HasWeaponsInInventory() = true) then  ChangeUIState(2) //Weapon Menu
      else Memo1.Lines.Add('You have no weapons in your inventory.')
    end;
  2:
    begin
      if (inventoryIndex - 1 >= 0) then
        if (Player1.weaponInventory[inventoryIndex - 1] <> nil) then
          inventoryIndex := inventoryIndex - 1
        else ShowMessage('There is no weapon down there')
      else ShowMessage('can now go futher down (index of Weapons)');
      PrintWeaponData();
    end;
  3:
    begin
      if (inventoryIndex - 1 >= 0) then
        if (Player1.itemInventory[inventoryIndex - 1] <> nil) then
          inventoryIndex := inventoryIndex - 1
        else ShowMessage('There is no item down there')
      else ShowMessage('can now go futher down (index of Weapons)');
      PrintItemData();
    end;
  5:
    begin
      if (inventoryIndex - 1 >= 0) then
        if (Player1.Skills[inventoryIndex - 1] <> nil) then
          inventoryIndex := inventoryIndex - 1
        else ShowMessage('There is no weapon down there')
      else ShowMessage('can now go futher down');
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
      if (Player1.GetCurrendRoom.GetPosY-1 >= 0) and (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY-1,Player1.GetCurrendRoom.getPosZ] <> nil) then begin
      Player1.ChangeRoom('yNeg');
      PrintRoomData();
      OnEnterRoom();
      end;
    end;
  1:
    begin
      if (Player1.HasItemsInInventory() = true) then ChangeUIState(3) //Item Menu
      else Memo1.Lines.Add('You have no items in your inventory.')
    end;
  2:
    begin
      if (inventoryIndex + 1 <= length(Player1.weaponInventory) - 1) then
        if (Player1.weaponInventory[inventoryIndex + 1] <> nil) then
          inventoryIndex := inventoryIndex + 1
        else ShowMessage('There is no weapon up there')
      else ShowMessage('can now go futher up (index of Weapons)');
      PrintWeaponData();
    end;
  3:
    begin
      if (inventoryIndex + 1 <= length(Player1.itemInventory) - 1) then
        if (Player1.itemInventory[inventoryIndex + 1] <> nil) then
          inventoryIndex := inventoryIndex + 1
        else ShowMessage('There is no weapon up there')
      else ShowMessage('can now go futher up (index of Weapons)');
      PrintItemData();
    end;
  5:
    begin
      if (inventoryIndex + 1 <= length(Player1.Skills) - 1) then
        if (Player1.Skills[inventoryIndex + 1] <> nil) then
          inventoryIndex := inventoryIndex + 1
        else ShowMessage('There is no skill up there')
      else ShowMessage('can now go futher up');
      PrintSkillData();
    end
  else
    Memo1.Lines.Add('lol no');
  end;
end;
procedure TForm1.SetButton(_background: TImage; _text: TLabel; toSetTo: boolean);
begin
  if (toSetTo = true) then
  begin
    _text.Cursor := crHandPoint;
    _background.Cursor := crHandPoint;
    _background.Picture.LoadFromFile('Images/ButtonBgPlayeholder.png');
  end
  else begin
    _text.Cursor := crDefault;
    _background.Cursor := crDefault;
    _background.Picture.LoadFromFile('Images/ButtonBgPlayeholderDisabled.png');
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
      PrintAndUIChange(0, 'You Won!'+sLineBreak+'He dropt ' + FightingEnemy.GetWeaponDrop().GetName() + '. It was added to your Inventory.');
    end
    else if (FightingEnemy.GetItemDrop() <> nil) then
    begin
      Player1.AddItem(FightingEnemy.GetItemDrop());
      PrintAndUIChange(0, 'You Won!'+sLineBreak+'He dropt ' + FightingEnemy.GetItemDrop().GetName() + '. It was added to your Inventory.');
    end
    else PrintAndUIChange(0, 'You Won!');
    //fight was ended

    //Destroy the Enemy
    FreeAndNil(Player1.GetCurrendRoom().EnemyArr[0]); //FreeAndNil Destroyd ein Object und setz die (pointer var) auf nil
    FightingEnemy := nil;  //da der gegner zerstört wurde sollte auch FightingEnemy wieder auf nil

  end
  else //Enemy deals damage
  begin
    Player1.ChangeHealthBy(-(FightingEnemy.GetDamage()));
    Memo1.Lines.Add('The Enemy delt ' + FloatToStr(FightingEnemy.GetDamage())+' damage.'+sLineBreak+'You now have ' + FloatToStr(Player1.GetHealth()) + ' health left');
    //PrintAndUIChange(UIState, 'The Enemy delt: ' + FloatToStr(FightingEnemy.GetDamage()) + ' You now have ' + FloatToStr(Player1.GetHealth()) + ' health left');

    //verringert den cooldoown von jedem skill
    for i := 0 to length(Player1.Skills) - 1 do
      if (Player1.Skills[i] <> nil) then Player1.Skills[i].ReduceCooldown();

  end;
end;

procedure TForm1.PrintWeaponData(); //situation = 2
begin
  Memo_Description.Clear();
  Memo_Description.Lines.AddText(Player1.weaponInventory[inventoryIndex].GetName());
  Memo_Description.Lines.Add('');
  Memo_Description.Lines.AddText(Player1.weaponInventory[inventoryIndex].GetDescription());
  Image1.Picture.LoadFromFile(Player1.weaponInventory[inventoryIndex].GetImagePath());
end;

procedure TForm1.PrintItemData(); //situation = 3
begin
  Memo_Description.Clear();
  Memo_Description.Lines.AddText(Player1.itemInventory[inventoryIndex].GetName());
  Memo_Description.Lines.Add('');
  Memo_Description.Lines.AddText(Player1.itemInventory[inventoryIndex].GetDescription());
  Image1.Picture.LoadFromFile(Player1.itemInventory[inventoryIndex].GetImagePath());
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
      if (Player1.GetCurrendRoom().EnemyArr[i] <> nil) then
      begin  //start Fight
        FightingEnemy := Player1.GetCurrendRoom().EnemyArr[i];
        PrintAndUIChange(1, 'You are now fighting! The Enemy has ' + FloatToStr(FightingEnemy.GetHealth()) + ' health.');
      end;
    end;


  //3. check nach items
  //2. check nach waffen
  //4. check nach RoomObjects


  //Check nach verfügbaren Räumen und aktiviere die Knöpfe dem entsprechend
  if (UIState = 0) then
  begin
    if (Player1.GetCurrendRoom.GetPosX+1 > 5) or (RoomArr[Player1.GetCurrendRoom.getPosX+1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] = nil) then
      SetButton(Btn1_Image, Btn1_Label, false)
    else SetButton(Btn1_Image, Btn1_Label, true);

    if (Player1.GetCurrendRoom.GetPosX-1 < 0) or (RoomArr[Player1.GetCurrendRoom.getPosX-1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] = nil) then
      SetButton(Btn2_Image, Btn2_Label, false)
    else SetButton(Btn2_Image, Btn2_Label, true);

    if (Player1.GetCurrendRoom.GetPosY+1 > 5) or (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY+1,Player1.GetCurrendRoom.getPosZ] = nil) then
      SetButton(Btn3_Image, Btn3_Label, false)
    else SetButton(Btn3_Image, Btn3_Label, true);

    if (Player1.GetCurrendRoom.GetPosY-1 < 0) or (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY-1,Player1.GetCurrendRoom.getPosZ] = nil) then
      SetButton(Btn4_Image, Btn4_Label, false)
    else SetButton(Btn4_Image, Btn4_Label, true);
  end;

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
  //Activate all Buttons at first
  Btn1_Image.Picture.LoadFromFile('Images/ButtonBgPlayeholder.png');
  Btn2_Image.Picture.LoadFromFile('Images/ButtonBgPlayeholder.png');
  Btn3_Image.Picture.LoadFromFile('Images/ButtonBgPlayeholder.png');
  Btn4_Image.Picture.LoadFromFile('Images/ButtonBgPlayeholder.png');

  case UIState of
    0: //walking UI
    begin
      Btn1_Label.caption := 'x Plus';
      Btn2_Label.caption := 'x Minus';
      Btn3_Label.caption := 'y Plus';
      Btn4_Label.caption := 'y Minus';
      PrintRoomData();

      OnEnterRoom(); //whenever you can walk again it checks if there is (still) stuff in the Room
    end;
  1: //fighting UI
    begin
      Btn1_Label.caption := 'Skills';
      Btn2_Label.caption := 'Attack';
      Btn3_Label.caption := 'Weapons';
      Btn4_Label.caption := 'Items';

      Memo1.Clear();
      Memo1.Lines.Add('The Enemy stands in front of you.'+sLineBreak+'What will you do?');
      Image1.Picture.LoadFromFile(Player1.GetCurrendRoom().GetImagePath());
    end;
  2: //Weapon Menu
    begin
      Btn1_Label.caption := 'Back';
      Btn2_Label.caption := 'Equip';
      Btn3_Label.caption := 'Up';
      Btn4_Label.caption := 'Down';

      inventoryIndex := 0;
      Memo1.Clear();
      for i := 0 to length(Player1.weaponInventory) - 1 do
        if (Player1.weaponInventory[i] <> nil) then
          Memo1.Lines.Add('-'+Player1.weaponInventory[i].GetName());
      PrintWeaponData();
    end;
  3: //Item Menu
    begin
      Btn1_Label.caption := 'Back';
      Btn2_Label.caption := 'Use';
      Btn3_Label.caption := 'Up';
      Btn4_Label.caption := 'Down';

      inventoryIndex := 0;
      Memo1.Clear();
      for i := 0 to length(Player1.itemInventory) - 1 do
        if (Player1.itemInventory[i] <> nil) then
          Memo1.Lines.Add('-'+Player1.itemInventory[i].GetName());
      PrintItemData();
    end;
  4: ;
  5: //skills Menu
    begin
      Btn1_Label.caption := 'Back';
      Btn2_Label.caption := 'Use';
      Btn3_Label.caption := 'Up (index Down)';
      Btn4_Label.caption := 'Down (index Up)';

      Memo1.Clear();
      inventoryIndex := 0;
      for i := 0 to length(Player1.Skills) - 1 do
        if (Player1.Skills[i] <> nil) then
        begin
          Memo1.Lines.Add('-'+Player1.Skills[i].GetName());
          inventoryIndex := i;
        end;
      PrintSkillData();
    end;

  99: //Single Message
    begin
      Btn1_Label.caption := '';
      SetButton(Btn1_Image, Btn1_Label, false);
      Btn2_Label.caption := 'Ok';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := '';
      SetButton(Btn3_Image, Btn3_Label, false);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

    end;
  end;
end;

procedure TForm1.PrintAndUIChange(_changeUITo: integer; _toPrint: string);
begin
  if (_changeUITo = 0) then ChangeSituation(0);
  if (_changeUITo = 1) then ChangeSituation(1);

  Memo1.Clear();
  Memo1.Lines.Add(_toPrint);
  UIStateCopy := _changeUITo;

  ChangeUIState(99);
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

