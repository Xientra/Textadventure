unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LCLType, ActnList, MMSystem{für die Musik},
  RoomClass{für TRoom}, PlayerClass{für TPlayer}, EnemyClass{für TEnemy}, WeaponClass{für TWeapon}, ItemClass{für TItem}, SkillClass{I think you know by now...}, RoomObjectClass{could it be? is this really for TRoomClass?!};

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
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    MuteBtn_Image: TImage;
    Memo_Stats: TMemo;
    Memo_Description: TMemo;
    Image1: TImage;
    RoomPicture: TImage;
    Label_Leave: TLabel;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      //Its a secret!
    Memo1: TMemo;
    MusicTimer: TTimer;
    procedure Btn1Click(Sender: TObject);
    procedure Btn2Click(Sender: TObject);
    procedure Btn3Click(Sender: TObject);
    procedure Btn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Label_LeaveClick(Sender: TObject);
    procedure MusicTimerTimer(Sender: TObject);
    procedure MuteBtn_ImageClick(Sender: TObject);

  public
    procedure OnEnterRoom(); //beschreibung unter "Logic hinter bestimmten Situationen" unter private

  private
    //unabhängingig von den lazarus generierten ButtonClick proceduren
    procedure Button_1_Action();
    procedure Button_2_Action();
    procedure Button_3_Action();
    procedure Button_4_Action();
    //ändert die Buttons
    procedure SetButton(_background: TImage; _text: TLabel; toSetTo: boolean); //aktiviert oder deaktiviert den Butten mit dem TImage _bg und dem TLbl _text

    //Verwaltung der Situation und UIState
    procedure ChangeSituation(_situation: integer);
    procedure ChangeUIState(_state: integer);
    procedure PrintAndUIChange(_changeUITo: integer; _toPrint: string); //zeigt zusätzlich zum ändern der UI noch eine einmalige Nachicht

    //Logic hinter bestimmten Situationen
    {procedure OnEnterRoom();} //situation = 0;  schaut ob dinge/Enemyies im Raum sind usw. ist public
    procedure PlayerEndTurn(); //situation = 1;  schaut ob der Enemy besiegt ist und verigert die cooldowns
    procedure EnemyTurn(); //situation = 2;  Runde des Gegners

    //Schreibt die jeweiligen Infos auf dei jeweiligen memos und so
    procedure PrintPlayerData(_player: TPlayer); //print situation all
    procedure PrintRoomData(_room: TRoom); //print situation = 0
    procedure PrintEnemyData(_enemy: TEnemy); //print situation = 1 and 2
    procedure PrintWeaponData(_weapon: TWeapon); //print situation = 53 and 12
    procedure PrintItemData(_item: TItem); //print situation = 54 and 11
    procedure PrintSkillData(_skill: TSkill); //print situation = 55

    //Erstellen der Räume
    procedure CreateARoom(_description: string; _imagePath: string; _pos_x, _pos_y, _pos_z: integer); //ist besser, damit die position an der der Raum erstellt wurde auf jeden fall dem Raum bekannt ist
    procedure CreateRooms(); //Erstellt den Inhalt des Spieles
  end;

//------------------------------------------------------------------------------------------------------------------------//
//-----------------------------------------------Schau in die ToDoListe---------------------------------------------------//
//------------------------------------------------------------------------------------------------------------------------//

var
  Form1: TForm1;

  //Music Vars
  MusicTimer: TTimer;
  MusicCounter: integer;
  songPath: PChar; //PChar ist irgentwie string aber PlayerSound breacht genau das
  songlength: integer; //in seconds?
  muted: boolean;

  RoomArr: Array of Array of Array of TRoom;
  Room_x, Room_y, Room_z: integer;
  Player1: TPlayer;
  FightingEnemy: TEnemy;

  currendSituation: integer; //0 = map; 1 = combat;  = interact with RoomObjects;
  //0: Btn1: Norden; Btn2: Westen; Btn3: Süden; Btn: Osten;
  //1: Btn1: Angriff; Btn2: Skills; Btn3: Items; Btn4: Flee;
  UIState, UIStateCopy: integer;

  //diese Beiden vars sind dafür da, das die information an welcher stelle das item/etc jewailigen array des Inventar/Raum ist. bsp: man hat zwei items in inventar was auch immer danach geschaut hat weiß das und will, das infos zum ersten gedruckt werden also setzt es die var auf die stelle des items
  inventoryIndex: integer;
  roomStuffIndex: integer;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
var
  i, ii: integer;
begin
  inventoryIndex := 0;

  songPath := 'music\overworldTheme_loop.wav';
  songlength := 27; //27s ist die exakte länge von overworldTheme_loop
  muted := true;
  if (muted = true) then
    MuteBtn_Image.Picture.LoadFromFile('Images/Buttons/MuteBtnOff.png')
  else if (muted = false) then
    MuteBtn_Image.Picture.LoadFromFile('Images/Buttons/MuteBtnOn.png');

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
  //Stuff just for testing the inventory
  Player1.AddItem(TItem.Create('some Key', 'it not usefull for any door...','Images/Items/Key1.png'));
  Player1.AddItem(TItem.Create('ITEM', 'ITEM!!!!!!!!!!','Images/Items/ITEM.png'));
  Player1.AddItem(TItem.Create('DamageUpItemThingy', 'It boosts your Damage by 20%','Images/Items/DamageUp.png'));
  Player1.itemInventory[2].SetDamageUp(0.2);
  Player1.AddItem(TItem.Create('SomeBomb', 'Its a Bomb','Images/Items/Bomb.png'));
  Player1.itemInventory[3].SetBomb(50);
  Player1.AddWeapon(TWeapon.Create('Some Sword', 'It is acually sharp even thought it looks a bit blocky.', 'Images/Items/ShortSword.png', 0, 0, 15, 0));
  Player1.AddSkill(TSkill.Create('Some Skill', 'You can KILL with it.' +sLineBreak+ 'It deals Strike Damage', 'Images/Skills/someSkill.png', 2, 1.5, 0, 0, 0));
  Player1.AddSkill(TSkill.Create('Some other Skill', 'This one is just useless...'+sLineBreak+ 'It deals Slash Damage', 'Images/Skills/someOtherSkill.png', 5, 0, 0, 1.2, 0));


  ChangeSituation(0); //updates UI
  Memo_Description.Clear();

end;


{------------------------------------------------------------------------------}
{----------------------Lazarus-generierte-proceduren---------------------------}
//Die von Lazarus Generierten procedure rufen nur unsere eigene auf sonst nichts
procedure TForm1.Btn1Click(Sender: TObject); begin Button_1_Action(); end;
procedure TForm1.Btn2Click(Sender: TObject); begin Button_2_Action(); end;
procedure TForm1.Btn3Click(Sender: TObject); begin Button_3_Action(); end;
procedure TForm1.Btn4Click(Sender: TObject); begin Button_4_Action(); end;

//Schaut ob Tasten gedrückt wurden
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then Application.Terminate();

  if (Key = VK_1) then Button_1_Action();
  if (Key = VK_2) then Button_2_Action();
  if (Key = VK_3) then Button_3_Action();
  if (Key = VK_4) then Button_4_Action();
end;

procedure TForm1.Label_LeaveClick(Sender: TObject); //Exit Button
begin
  Application.Terminate();
end;

procedure TForm1.MuteBtn_ImageClick(Sender: TObject); //Mute Button
begin
  if (muted = false) then
  begin
    MuteBtn_Image.Picture.LoadFromFile('Images/Buttons/MuteBtnOff.png');
    MusicTimer.Enabled := false;
    MusicCounter := 0;
    PlaySound('music/mute.wav', 0, SND_ASYNC);
    muted := true;
  end
  else if (muted = true) then
  begin
    MuteBtn_Image.Picture.LoadFromFile('Images/Buttons/MuteBtnOn.png');
    MusicCounter := songlength; //damit er wieder anfängt zu spielen
    MusicTimer.Enabled := true;
    muted := false;
  end;
end;

procedure TForm1.MusicTimerTimer(Sender: TObject);
begin

  Edit2.Text := IntToStr(MusicCounter);
  if (MusicCounter = songlength) then
  begin
    PlaySound(songPath,0,SND_ASYNC);
    MusicCounter := 0;
  end;
  MusicCounter := MusicCounter + 1;
end;
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{----------------------Funktionen der Buttons----------------------------------}
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

procedure TForm1.Button_1_Action(); //                                     --> 1
begin
  case UIState of
  0:
    begin
      if (Player1.GetCurrendRoom.GetPosX+1 <= 5) and (RoomArr[Player1.GetCurrendRoom.getPosX+1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] <> nil) then
      begin
        Player1.ChangeRoom('xPos');
        PrintRoomData(Player1.GetCurrendRoom());
        OnEnterRoom();
      end;
    end;
  1:
    begin
      if (Player1.HasSkills() = true) then ChangeUIState(55) //Skill Menu
      else Memo1.Lines.Add('You have no skills yet.')
    end;
  2: {do nothing};
  10: {do nothing};
  11: {do nothing};
  53:
    begin
      ChangeUIState(currendSituation);
    end;
  54:
    begin
      ChangeUIState(currendSituation);
    end;
  55:
    begin
      PrintRoomData(Player1.GetCurrendRoom());
      ChangeUIState(currendSituation);
    end;
  99: ;
  else
    Memo1.Lines.Add('lol no');
  end;
end;
procedure TForm1.Button_2_Action(); //                                     --> 2
var
  _dmg: real;
begin
  case UIState of
  0:
    begin
      if (Player1.GetCurrendRoom.GetPosX-1 >= 0) and (RoomArr[Player1.GetCurrendRoom.getPosX-1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] <> nil) then begin
      Player1.ChangeRoom('xNeg');
      PrintRoomData(PLayer1.GetCurrendRoom());
      OnEnterRoom();
      end;
    end;
  1:
    begin
      _dmg := FightingEnemy.DoDamage(Player1.GetCurrendWeapon().GetStrikeDmg(), Player1.GetCurrendWeapon().GetThrustDmg(), Player1.GetCurrendWeapon().GetSlashDmg(), Player1.GetCurrendWeapon().GetMagicDmg());

      PrintAndUIChange(2, 'You delt ' + FloatToStr(Round(_dmg)) + ' damage.'+sLineBreak+'The Enemy now has ' + FloatToStr(Round(FightingEnemy.GetHealth())) + ' health left');

      PlayerEndTurn();
    end;
  2:
    begin
      ChangeUIState(1);
    end;
  10:
    begin
      Player1.AddWeapon(Player1.GetCurrendRoom().WeaponArr[roomStuffIndex]);
      Player1.GetCurrendRoom().WeaponArr[roomStuffIndex] := nil;
      ChangeUIState(currendSituation);
    end;
  11:
    begin
      Player1.AddItem(Player1.GetCurrendRoom().ItemArr[roomStuffIndex]);
      Player1.GetCurrendRoom().ItemArr[roomStuffIndex] := nil;
      ChangeUIState(currendSituation);
    end;
  53:
    begin
      Player1.SetCurrendWeapon(Player1.weaponInventory[inventoryIndex]);
      PrintAndUIChange(2, 'You equiped '+Player1.weaponInventory[inventoryIndex].GetName()+'.');
      PlayerEndTurn();
    end;
  54:
    begin
      If (Player1.itemInventory[inventoryIndex].UseItem() = false) then ShowMessage('You are not able to use this Item in combat.')
      else begin
        PrintAndUIChange(2, 'You used '+Player1.itemInventory[inventoryIndex].GetName()+'.');
        PlayerEndTurn();
      end;
    end;
  55:
    begin
      if (Player1.Skills[inventoryIndex].GetTurnsToWait() = 0) then
      begin
        _dmg := FightingEnemy.DoDamage(
          Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetStrikeMulti(),
          Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetThrustMulti(),
          Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetSlashMulti(),
          Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetMagicMulti());

        Player1.Skills[inventoryIndex].SetTurnToWaitToCooldown();
        PrintAndUIChange(2, 'You delt ' + FloatToStr(Round(_dmg)) + ' damage.'+sLineBreak+'The Enemy now has ' + FloatToStr(Round(FightingEnemy.GetHealth())) + ' health left');
        Memo_Description.Clear();

        PlayerEndTurn();
      end else
      begin
        ShowMessage('You have to wait '+IntToStr(Player1.Skills[inventoryIndex].GetTurnsToWait())+' more turns to use this skill.');
      end;
    end;
  99:
    begin
      ChangeUIState(UIStateCopy);
    end
  else
    Memo1.Lines.Add('lol no');
  end;
end;
procedure TForm1.Button_3_Action(); //                                     --> 3
begin
  case UIState of
  0:
    begin
      if (Player1.GetCurrendRoom.GetPosY+1 <= 5) and (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY+1,Player1.GetCurrendRoom.getPosZ] <> nil) then begin
      Player1.ChangeRoom('yPos');
      PrintRoomData(Player1.GetCurrendRoom());
      OnEnterRoom();
      end;
    end;
  1:
    begin
      if (Player1.HasWeaponsInInventory() = true) then  ChangeUIState(53) //Weapon Menu
      else Memo1.Lines.Add('You have no weapons in your arsenal.')
    end;
  2: {do nothing};
  10: {do nothing};
  11: {do nothing};
  53:
    begin
      if (inventoryIndex - 1 >= 0) then
        if (Player1.weaponInventory[inventoryIndex - 1] <> nil) then
          inventoryIndex := inventoryIndex - 1
        else ShowMessage('There is no weapon down there')
      else ShowMessage('can now go futher down (index of Weapons)');
      PrintWeaponData(Player1.weaponInventory[inventoryIndex]);
    end;
  54:
    begin
      if (inventoryIndex - 1 >= 0) then
        if (Player1.itemInventory[inventoryIndex - 1] <> nil) then
          inventoryIndex := inventoryIndex - 1
        else ShowMessage('There is no item down there')
      else ShowMessage('can now go futher down (index of Weapons)');
      PrintItemData(Player1.itemInventory[inventoryIndex]);
    end;
  55:
    begin
      if (inventoryIndex - 1 >= 0) then
        if (Player1.Skills[inventoryIndex - 1] <> nil) then
          inventoryIndex := inventoryIndex - 1
        else ShowMessage('There is no skill down there')
      else ShowMessage('can now go futher down');
      PrintSkillData(Player1.Skills[inventoryIndex]);
    end;
  99: ;
  else
    Memo1.Lines.Add('lol no');
  end;
end;
procedure TForm1.Button_4_Action(); //                                     --> 4
begin
  case UIState of
  0:
    begin
      if (Player1.GetCurrendRoom.GetPosY-1 >= 0) and (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY-1,Player1.GetCurrendRoom.getPosZ] <> nil) then begin
      Player1.ChangeRoom('yNeg');
      PrintRoomData(Player1.GetCurrendRoom());
      OnEnterRoom();
      end;
    end;
  1:
    begin
      if (Player1.HasItemsInInventory() = true) then ChangeUIState(54) //Item Menu
      else Memo1.Lines.Add('You have no items in your inventory.')
    end;
  2: {do nothing};
  10: {do nothing};
  11: {do nothing};
  53:
    begin
      if (inventoryIndex + 1 <= length(Player1.weaponInventory) - 1) then
        if (Player1.weaponInventory[inventoryIndex + 1] <> nil) then
          inventoryIndex := inventoryIndex + 1
        else ShowMessage('There is no weapon up there')
      else ShowMessage('can now go futher up (index of Items)');
      PrintWeaponData(Player1.weaponInventory[inventoryIndex]);
    end;
  54:
    begin
      if (inventoryIndex + 1 <= length(Player1.itemInventory) - 1) then
        if (Player1.itemInventory[inventoryIndex + 1] <> nil) then
          inventoryIndex := inventoryIndex + 1
        else ShowMessage('There is no item up there')
      else ShowMessage('can now go futher up (index of Items)');
      PrintItemData(Player1.itemInventory[inventoryIndex]);
    end;
  55:
    begin
      if (inventoryIndex + 1 <= length(Player1.Skills) - 1) then
        if (Player1.Skills[inventoryIndex + 1] <> nil) then
          inventoryIndex := inventoryIndex + 1
        else ShowMessage('There is no skill up there')
      else ShowMessage('can now go futher up (index of Skills)');
      PrintSkillData(Player1.Skills[inventoryIndex]);
    end;
  99: ;
  else
    Memo1.Lines.Add('lol no');
  end;
end;
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{---------------------------Ändern-der-Situation-------------------------------}
procedure TForm1.ChangeSituation(_situation: integer);
begin
  currendSituation := _situation;
  ChangeUIState(currendSituation);

  Edit2.Text := IntToStr(currendSituation);
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

procedure TForm1.ChangeUIState(_state: integer);
var i: integer;
begin
  UIState := _state;
  Edit1.Text := IntToStr(UIState);
  Edit3.Text := IntToStr(currendSituation);

  //Activate all Buttons at first
  SetButton(Btn1_Image, Btn1_Label, true);
  SetButton(Btn2_Image, Btn2_Label, true);
  SetButton(Btn3_Image, Btn3_Label, true);
  SetButton(Btn4_Image, Btn4_Label, true);

  case UIState of
    0: //walking UI
    begin
      Btn1_Label.caption := 'x Plus';
      Btn2_Label.caption := 'x Minus';
      Btn3_Label.caption := 'y Plus';
      Btn4_Label.caption := 'y Minus';
      PrintRoomData(Player1.GetCurrendRoom());

      OnEnterRoom(); //whenever you can walk again it checks if there is (still) stuff in the Room
    end;
  1: //fighting UI
    begin
      Btn1_Label.caption := 'Skills';
      Btn2_Label.caption := 'Attack';
      Btn3_Label.caption := 'Weapons';
      Btn4_Label.caption := 'Items';

      PrintEnemyData(FightingEnemy);
      Memo1.Clear();
      Memo1.Lines.Add('The Enemy stands in front of you.'+sLineBreak+'What will you do?');
    end;
  2:
    begin
      Btn1_Label.caption := '';
      SetButton(Btn1_Image, Btn1_Label, false);
      Btn2_Label.caption := 'Ok';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := '';
      SetButton(Btn3_Image, Btn3_Label, false);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      EnemyTurn(); //The Enemy deals Damage
    end;
  10: //Room Weapons
    begin
      Btn1_Label.caption := '';
      SetButton(Btn1_Image, Btn1_Label, false);
      Btn2_Label.caption := 'Take it';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := '';
      SetButton(Btn3_Image, Btn3_Label, false);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      Memo1.Clear();
      Memo1.Lines.AddText('You see a Weapon and inspect it closer.');
      //Print item description
      Memo_Description.Clear();
      Memo_Description.Lines.AddText(Player1.GetCurrendRoom().WeaponArr[roomStuffIndex].GetName());
      Memo_Description.Lines.Add('');
      Memo_Description.Lines.AddText(Player1.GetCurrendRoom().WeaponArr[roomStuffIndex].GetDescription());
      Image1.Picture.LoadFromFile(Player1.GetCurrendRoom().WeaponArr[roomStuffIndex].GetImagePath());
    end;
  11: //Room Items
    begin
      Btn1_Label.caption := '';
      SetButton(Btn1_Image, Btn1_Label, false);
      Btn2_Label.caption := 'Take it';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := '';
      SetButton(Btn3_Image, Btn3_Label, false);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      Memo1.Clear();
      Memo1.Lines.AddText('You see a Item and inspect it closer.');
      //Print item description
      Memo_Description.Clear();
      Memo_Description.Lines.AddText(Player1.GetCurrendRoom().ItemArr[roomStuffIndex].GetName());
      Memo_Description.Lines.Add('');
      Memo_Description.Lines.AddText(Player1.GetCurrendRoom().ItemArr[roomStuffIndex].GetDescription());
      Image1.Picture.LoadFromFile(Player1.GetCurrendRoom().ItemArr[roomStuffIndex].GetImagePath());
    end;
  53: //Weapon Menu
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
      PrintWeaponData(Player1.weaponInventory[inventoryIndex]);
    end;
  54: //Item Menu
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
      PrintItemData(Player1.itemInventory[inventoryIndex]);
    end;
  55: //skills Menu
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
      PrintSkillData(Player1.Skills[inventoryIndex]);
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
  else ShowMessage('You are in a UIState which has no definition.'+slineBreak+'How the hell did you get here?!');
  end;

  PrintPlayerData(Player1); //Schreibt die stats des Spielers
end;
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{------------------Logic-hinter-bestimmten-Situationen-------------------------}
procedure TForm1.OnEnterRoom(); //logic situation = 0
var
  i: integer;
begin
  //1. check nach Gegnern
  if (length(Player1.GetCurrendRoom().EnemyArr) > 0) then
    for i := 0 to length(Player1.GetCurrendRoom().EnemyArr) - 1 do
    begin
      if (Player1.GetCurrendRoom().EnemyArr[i] <> nil) then
      begin  //start Fight
        FightingEnemy := Player1.GetCurrendRoom().EnemyArr[i];
        PrintAndUIChange(1, 'You are now fighting!');
      end;
    end;

  //2. check nach waffen
  if (length(Player1.GetCurrendRoom().WeaponArr) > 0) then
    for i := 0 to length(Player1.GetCurrendRoom().WeaponArr) - 1 do
    begin
      if (Player1.GetCurrendRoom().WeaponArr[i] <> nil) then
      begin
        roomStuffIndex := i;
        ChangeUIState(10);
      end;
    end
  else
  //3. check nach items
  if (length(Player1.GetCurrendRoom().ItemArr) > 0) then
    for i := 0 to length(Player1.GetCurrendRoom().ItemArr) - 1 do
    begin
      if (Player1.GetCurrendRoom().ItemArr[i] <> nil) then
      begin
        roomStuffIndex := i;
        ChangeUIState(11);
      end;
    end
  else
  //4. check nach RoomObjects
  if (length(Player1.GetCurrendRoom().RoomObjectArr) > 0) then
    for i := 0 to length(Player1.GetCurrendRoom().RoomObjectArr) - 1 do
    begin
      if (Player1.GetCurrendRoom().RoomObjectArr[i] <> nil) then
      begin
        ShowMessage('There is a RoomObject but what to do with it...');
        //change situation to inspectRoomObject
      end;
    end;

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

  if (currendSituation = 0) and (UIState = 0) then PrintRoomData(Player1.GetCurrendRoom());
end;

procedure TForm1.PlayerEndTurn(); //logic situation = 1
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
      PrintAndUIChange(0, 'You Won!'+sLineBreak+
                          'He dropt '+FightingEnemy.GetWeaponDrop().GetName()+'. '+sLineBreak+
                          FightingEnemy.GetWeaponDrop().GetDescription()+sLineBreak+
                          'It deals '+FloatToStr(FightingEnemy.GetWeaponDrop().GetStrikeDmg())+' strike, '+FloatToStr(FightingEnemy.GetWeaponDrop().GetThrustDmg())+' thrust, '+FloatToStr(FightingEnemy.GetWeaponDrop().GetSlashDmg())+' slash, '+FloatToStr(FightingEnemy.GetWeaponDrop().GetMagicDmg())+' magic damage.'+sLineBreak+
                          'It was added to your Weapon arsenal.');
    end else if (FightingEnemy.GetItemDrop() <> nil) then
    begin
      Player1.AddItem(FightingEnemy.GetItemDrop());
      PrintAndUIChange(0, 'You Won!'+sLineBreak+
                          'He dropt ' + FightingEnemy.GetItemDrop().GetName()+'. '+sLineBreak+
                          FightingEnemy.GetItemDrop().GetDescription()+sLineBreak+
                          'It was added to your Inventory.');
    end
    else PrintAndUIChange(0, 'You Won!');
    //fight was ended

    //Destroy den Enemy Object und setzt alle Variablen die auf ihn zeigen zu nil
    for i := 0 to length(Player1.GetCurrendRoom.EnemyArr) do
    begin
      if (Player1.GetCurrendRoom.EnemyArr[i] = FightingEnemy) then
        FreeAndNil(Player1.GetCurrendRoom().EnemyArr[i]); //FreeAndNil Destroyd ein Object und setz die pointer var (die in den Klammern) auf nil
    end;
    FightingEnemy := nil;  //da der gegner zerstört wurde sollte auch FightingEnemy wieder auf nil

  end
  else //Enemy deals damage
  begin
    //verringert den cooldoown von jedem skill
    for i := 0 to length(Player1.Skills) - 1 do
      if (Player1.Skills[i] <> nil) then Player1.Skills[i].ReduceTurnsToWait();
  end;
end;

procedure TForm1.EnemyTurn(); //logic situation = 2
begin
  Player1.ChangeHealthBy(-(FightingEnemy.GetDamage()));
  Memo1.Clear();
  Memo1.Lines.Add('The Enemy delt ' + FloatToStr(FightingEnemy.GetDamage())+' damage.'+sLineBreak+'You now have ' + FloatToStr(Player1.GetHealth()) + ' health left');
  PrintEnemyData(FightingEnemy);
end;
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{-------------Das-Schreiben-von-Infos-zur-jeweiligen-Situation-----------------}
procedure TForm1.PrintPlayerData(_player: TPlayer); //print situation all
begin
  Memo_Stats.Clear();
  Memo_Stats.Lines.AddText('Health: '+sLineBreak+
                           FloatToStr(_player.GetHealth())+sLineBreak+
                           sLineBreak+
                           'Currend Weapon: '+sLineBreak+
                           _player.GetCurrendWeapon().GetName()+sLineBreak+
                           sLineBreak+
                           'Damage: '+sLineBreak+
                           FloatToStr(_player.GetCurrendWeapon().GetStrikeDmg())+' strike dmg'+sLineBreak+
                           FloatToStr(_player.GetCurrendWeapon().GetThrustDmg())+' thrust dmg'+sLineBreak+
                           FloatToStr(_player.GetCurrendWeapon().GetSlashDmg())+' slash dmg'+sLineBreak+
                           FloatToStr(_player.GetCurrendWeapon().GetMagicDmg())+' magic dmg'+sLineBreak+
                           sLineBreak+
                           'Amount of Skills: '+sLineBreak+
                           IntToStr(_player.GetMaxAmountOfSkills()-_player.GetAmountOfSkills()));
end;

procedure TForm1.PrintRoomData(_room: TRoom); //print situation = 0
begin
  Memo1.Clear();
  Memo1.Lines.Add(_room.GetDescription());
  Image1.Picture.LoadFromFile(_room.GetImagePath());
  Memo_Description.Clear();
end;

procedure TForm1.PrintEnemyData(_enemy: TEnemy); //print situation 1 and 2
begin
  Memo_Description.Clear();
  Memo_Description.Lines.AddText(_enemy.GetName());
  Memo_Description.Lines.Add('');
  if Round(_enemy.GetHealth()) > 0 then
    Memo_Description.Lines.AddText('The '+_enemy.GetName()+' has '+FloatToStr(Round(FightingEnemy.GetHealth()))+' health left.')
  else
    Memo_Description.Lines.AddText('The '+_enemy.GetName()+' has '+' 0 health left.');
  Image1.Picture.LoadFromFile(_enemy.GetImagePath());
end;

procedure TForm1.PrintWeaponData(_weapon: TWeapon); //print situation = 53
begin
  Memo_Description.Clear();
  Memo_Description.Lines.AddText(_weapon.GetName());
  Memo_Description.Lines.Add('');
  Memo_Description.Lines.AddText(_weapon.GetDescription());
  Image1.Picture.LoadFromFile(_weapon.GetImagePath());
end;

procedure TForm1.PrintItemData(_item: TItem); //print situation = 54
begin
  Memo_Description.Clear();
  Memo_Description.Lines.AddText(_item.GetName());
  Memo_Description.Lines.Add('');
  Memo_Description.Lines.AddText(_item.GetDescription());
  Image1.Picture.LoadFromFile(_item.GetImagePath());
end;

procedure TForm1.PrintSkillData(_skill: TSkill); //print situation = 55
begin
  Memo_Description.Clear();
  Memo_Description.Lines.AddText(_skill.GetName());
  Memo_Description.Lines.Add('');
  Memo_Description.Lines.AddText(_skill.GetDescription());
  Image1.Picture.LoadFromFile(_skill.GetImagePath());
end;
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{------------------------Erstellen-der-Räume-----------------------------------}
procedure TForm1.CreateARoom(_description: string; _imagePath: string; _pos_x, _pos_y, _pos_z: integer); //ist besser, damit die position an der der Raum erstellt wurde auf jeden fall dem Raum bekannt ist
begin
  RoomArr[_pos_x, _pos_y, _pos_z] := TRoom.Create(_description, _imagePath, _pos_x, _pos_y, _pos_z);
end;

procedure TForm1.CreateRooms(); //Erstellt den Inhalt des Spieles
begin
  CreateARoom('Your in your cell ...'+sLineBreak+'But you have a Bonfire!'+sLineBreak+sLineBreak+'Praise The Sun!', 'Images/Rooms/BonFireCellRoom.png', 1, 0, 0);

  CreateARoom('Erste Kreuzung.', 'Images/Rooms/Höle.png', 2, 0, 0);
  CreateARoom('Der Raum mit der Ratte.', 'Images/Rooms/Höle.png', 2, 1, 0);
  RoomArr[2, 1, 0].AddEnemy(TEnemy.Create('AAAAA', 20, 5, 'Images/Enemies/AAAAA.png'));
  RoomArr[2, 1, 0].EnemyArr[0].SetResistants(1, 1, 1);
  RoomArr[2, 1, 0].EnemyArr[0].SetItemDrop(TItem.Create('Literely just Trash', 'Like acually.', 'Images/Items/ITEM.png'));
  //RoomArr[2, 0, 0].EnemyArr[0].SetWeaponDrop(TWeapon.Create('Test Wep', 'Hi, i am a test wep.', 'Images/Items/ITEM.png', 1, 2, 3, 4));
  RoomArr[2, 1, 0].AddEnemy(TEnemy.Create('AAAAA2', 20, 5, 'Images/Enemies/AAAAA.png'));

  CreateARoom('Hier Liegt eine Eisenstange', 'Images/Rooms/Höle.png', 3, 0, 0);
  RoomArr[3, 0, 0].AddWeapon(TWeapon.Create('Iron Bar', 'A brocken piece of a former cell.'+sLineBreak+'It is a bit rosty but can still function as a simple weapon.', 'Images/Items/IronBar.png', 15, 0, 0, 0));
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
  CreateARoom('This is so sad. Alexa, play Gwyns theme', 'Images/Rooms/Höle.png', 2, 5, 0);
end;

end.

