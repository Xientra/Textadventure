unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LCLType, ActnList, MMSystem{für die Musik},
  RoomClass{für TRoom}, PlayerClass{für TPlayer}, EnemyClass{für TEnemy}, WeaponClass{für TWeapon}, ItemClass{für TItem}, SkillClass{I think you know by now...}, RoomObjectClass{could it be? is this really for TRoomClass?!}, menue;

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
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Label_LeaveClick(Sender: TObject);
    procedure MusicTimerTimer(Sender: TObject);
    procedure MuteBtn_ImageClick(Sender: TObject);

  public

  private
    //unabhängingig von den lazarus generierten ButtonClick proceduren
    procedure Button_1_Action();
    procedure Button_2_Action();
    procedure Button_3_Action();
    procedure Button_4_Action();
    //ändert die Buttons
    procedure SetButton(_background: TImage; _text: TLabel; toSetTo: boolean); //aktiviert oder deaktiviert den Butten mit dem TImage _bg und dem TLbl _text

    //Verwaltung der Situation und UIState
    procedure ChangeSituation(_situation: integer); //ändert die grundlegende Situation und ruft danach auch ChangeUIState(); auf um die UI zu updaten
    procedure ChangeUIState(_state: integer); //Updatet die UI kann das Inventar öffnen
    procedure PrintAndUIChange(_changeUITo: integer; _toPrint: string); //zeigt zusätzlich zum ändern der UI noch eine einmalige Nachicht. Sollte man es mit UIState aufrufen zeigt sie einfach nur eine Nachricht und geht dan zurück zu wo es war

    //Logic hinter bestimmten Situationen
    procedure OnEnterRoom(); //situation = 0;  schaut ob dinge/Enemyies im Raum sind usw.
    procedure OnLeaveRoom(); //Resetet cooldowns und alle Ignore Variablen von Sahcen die im Raum sind
    procedure PlayerEndTurn(); //situation = 1;  schaut ob der Enemy besiegt ist und verigert die cooldowns
    procedure EnemyTurn(); //situation = 2;  Runde des Gegners

    //Schreibt die jeweiligen Infos auf dei jeweiligen memos und so
    procedure PrintPlayerData(_player: TPlayer); //print situation all
    procedure PrintRoomData(_room: TRoom); //print situation = 0
    procedure PrintEnemyData(_enemy: TEnemy); //print situation = 1 and 2
    procedure PrintWeaponData(_weapon: TWeapon); //print situation = 53 and 10
    procedure PrintItemData(_item: TItem); //print situation = 54 and 11
    procedure PrintSkillData(_skill: TSkill); //print situation = 55
    procedure PrintRoomObjectData(_roomObject: TRoomObject); //situation 12, 13, 14, 15

    //Erstellen der Räume
    procedure CreateARoom(_description: string; _imagePath: string; _pos_x, _pos_y, _pos_z: integer); //ist besser, damit die position an der der Raum erstellt wurde auf jeden fall dem Raum bekannt ist
    procedure CreateRooms(); //Erstellt den Inhalt des Spieles
  end;

var
  Form1: TForm1;

  //Music Vars
  MusicCounter: integer; //Der Musik counter, der die Zeit zählt bis die Musik wiederholt werden muss
  songPath: PChar; //PChar ist irgentwie string aber PlayerSound braucht genau das
  songlength: integer; //wie lange MusicTimer warten muss bis er den song wiederholt. In secunden, da alles darunter irgentwie nicht mehr richtig die Zeit wiederspiegelt
  muted: boolean; //wenn false wird musik gespielt

  RoomArr: Array of Array of Array of TRoom; //Das Array aller Räume
  Room_x, Room_y, Room_z: integer; //Die Länge des RoomArray in alle drei Richtungen
  Player1: TPlayer; //Das Spieler Object welches leben und Inventar speichert
  FightingEnemy: TEnemy; //Der gegner gegen den man Kämpft wenn man in Situation 1 oder 2 ist

  //Diese Variablen sind dafür da die Spielsituationen zu ändern
  currendSituation: integer; //diese variable merkt sich die grundlegende Spielsituation unabhängig von dem möglicherweise offenen Menü //0 = laufen; 1 = Kampf(Runde des Spielers) 2 = Kampf(Runde des Gegners)
  UIState: integer; //diese Variable ist dafür da alle Menüs zu navigieren sie ist unabhängig von currendSituation damit man wieder dahin zurückkehren kann von wo man das Menu geöffnet hat
  UIStateCopy: integer; //diese var ist für situation 99 um dahin zurück zukehren wo man vorher war

  //diese Beiden vars sind dafür da, das die information an welcher stelle das item/etc jewailigen array des Inventar/Raum ist. bsp: man hat zwei items in inventar was auch immer danach geschaut hat weiß das und will, das infos zum ersten gedruckt werden also setzt es die var auf die stelle des items
  inventoryIndex: integer;
  roomStuffIndex: integer;

implementation

{$R *.lfm}

//-------------------------------------------------------------------------------------------------------------------//
//-----------------------------------------------Schau in die ToDoListe----------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------//

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
  Room_x := 8-1;
  Room_y := 8-1;
  Room_z := 7-1;

  //Setzt die Länge des RoomArray erst in x dann y und dann z Richtung
  SetLength(RoomArr, Room_x);
  for i := 0 to Room_y - 1 do
  begin
    SetLength(RoomArr[i], Room_y);
    for ii := 0 to Room_z - 1 do SetLength(RoomArr[i, ii], Room_z);
  end;

  CreateRooms(); //Erstellt das Spiel
  //Erschafft den Spieler in einem Raum
  Player1 := TPlayer.Create(RoomArr[1, 0, 0], TWeapon.Create('Fists', 'Just your good old hands.', 'Images/Items/ShortSword.png', 10, 0, 0, 0), 100);

  //Stuff just for testing the inventory
  Player1.AddItem(TItem.Create('some Key', 'it not usefull for any door...','Images/Items/Key1.png'));
  Player1.AddItem(TItem.Create('DamageUpItemThingy', 'It boosts your Damage by 20%','Images/Items/DamageUp.png'));
  Player1.itemInventory[1].SetDamageUp(0.2);
  Player1.AddItem(TItem.Create('SomeBomb', 'Its a Bomb','Images/Items/Bomb.png'));
  Player1.itemInventory[2].SetBomb(50);
  Player1.AddWeapon(TWeapon.Create('Some Sword', 'It is acually sharp even thought it looks a bit blocky.', 'Images/Items/ShortSword.png', 0, 0, 15, 0));
  Player1.AddSkill(TSkill.Create('Some Skill', 'You can KILL with it.' +sLineBreak+ 'It deals Strike Damage', 'Images/Skills/someSkill.png', 2, 1.5, 0, 0, 0));
  //---

  //Ändert die Situation zum erstem mal
  ChangeSituation(0); //also updates UI
  Memo_Description.Clear();
end;

{------------------------------------------------------------------------------}
{----------------------Lazarus-generierte-proceduren---------------------------}
//Die von Lazarus Generierten procedure rufen nur unsere eigene auf sonst nichts
procedure TForm1.Btn1Click(Sender: TObject); begin Button_1_Action(); end;
procedure TForm1.Btn2Click(Sender: TObject); begin Button_2_Action(); end;
procedure TForm1.Btn3Click(Sender: TObject); begin Button_3_Action(); end;
procedure TForm1.Btn4Click(Sender: TObject); begin Button_4_Action(); end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Form2.close();
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //Schaut ob Tasten gedrückt wurden
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

procedure TForm1.MusicTimerTimer(Sender: TObject); //Der Timer welcher die Musik wiederholt
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
  0: //x Plus im RoomArr
    begin
      if (Player1.GetCurrendRoom.GetPosX+1 <= Room_x) and (RoomArr[Player1.GetCurrendRoom.getPosX+1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] <> nil) and (Player1.GetCurrendRoom.GetBlockedRight = false) and (Player1.GetCurrendRoom.GetDoorRight = false) then
      begin
        OnLeaveRoom();
        Player1.ChangeRoom('xPos');
        PrintRoomData(Player1.GetCurrendRoom());
        OnEnterRoom();
      end;
    end;
  1: //Öffnet das Skill Menu
    begin
      if (Player1.HasSkills() = true) then ChangeUIState(55) //Skill Menu
      else Memo1.Lines.Add('You have no skills yet.')
    end;
  2: {do nothing};
  10: //lässt die Waffe im Raum liegen
    begin
      Player1.GetCurrendRoom().WeaponArr[roomStuffIndex].SetIgnore(true);
      PrintAndUIChange(currendSituation, 'You leave the Weapon where it is.');
    end;
  11: //lässt das Item im Raum liegen
    begin
      Player1.GetCurrendRoom().ItemArr[roomStuffIndex].SetIgnore(true);
      PrintAndUIChange(currendSituation, 'You leave the Item where it is.');
    end;
  12: //lässt das RoomObject im Raum
    begin
      Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].SetIgnore(true);
      PrintAndUIChange(currendSituation, 'You leave the Stature be.');
    end;
  13: //lässt das RoomObject im Raum
    begin
      Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].SetIgnore(true);
      PrintAndUIChange(currendSituation, 'You leave the Chest where it is.');
    end;
  14: //lässt das RoomObject im Raum
    begin
      Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].SetIgnore(true);
      PrintAndUIChange(currendSituation, 'You leave the Chest where it is.');
    end;
  15: //lässt das RoomObject im Raum
    begin
      Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].SetIgnore(true);
      PrintAndUIChange(currendSituation, 'You leave the Stature be.');
    end;
  53: //Geht aus dem Waffen Menu zurück in das Kampf Menu
    begin
      ChangeUIState(currendSituation);
    end;
  54: //Geht aus dem Item Menu zurück in das Kampf Menu
    begin
      ChangeUIState(currendSituation);
    end;
  55: //Geht aus dem Skill Menu zurück in das Kampf Menu
    begin
      PrintRoomData(Player1.GetCurrendRoom());
      ChangeUIState(currendSituation);
    end;
  99: {do nothing};
  else ShowMessage('This Button has no effect'); //Debug
  end;
end;
procedure TForm1.Button_2_Action(); //                                     --> 2
var
  _dmg: real;
begin
  case UIState of
  0: //x Minus im RoomArr
    begin
      if (Player1.GetCurrendRoom.GetPosX-1 >= 0) and (RoomArr[Player1.GetCurrendRoom.getPosX-1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] <> nil) and (Player1.GetCurrendRoom.GetBlockedLeft = false) and (Player1.GetCurrendRoom.GetDoorLeft = false) then begin
        OnLeaveRoom();
        Player1.ChangeRoom('xNeg');
        PrintRoomData(PLayer1.GetCurrendRoom());
        OnEnterRoom();
      end;
    end;
  1: //Greift den Gegner an und macht ihm Schaden; Beendet die Runde des Spielers
    begin
      _dmg := FightingEnemy.DoDamage(Player1.GetCurrendWeapon().GetStrikeDmg(), Player1.GetCurrendWeapon().GetThrustDmg(), Player1.GetCurrendWeapon().GetSlashDmg(), Player1.GetCurrendWeapon().GetMagicDmg());

      PrintAndUIChange(2, 'You delt ' + FloatToStr(Round(_dmg)) + ' damage.'+sLineBreak+'The Enemy now has ' + FloatToStr(Round(FightingEnemy.GetHealth())) + ' health left');

      PlayerEndTurn();
    end;
  2: //Beendet die Runde des Gegners
    begin
      ChangeUIState(1);
    end;
  10: //Nimmt die Waffe die im Raum liegt und geht weiter
    begin
      Player1.AddWeapon(Player1.GetCurrendRoom().WeaponArr[roomStuffIndex]);
      Player1.GetCurrendRoom().WeaponArr[roomStuffIndex] := nil;
      ChangeUIState(currendSituation);
    end;
  11: //Nimmt das Item die im Raum liegt und geht weiter
    begin
      Player1.AddItem(Player1.GetCurrendRoom().ItemArr[roomStuffIndex]);
      Player1.GetCurrendRoom().ItemArr[roomStuffIndex] := nil;
      PrintAndUIChange(currendSituation, '');
      ChangeUIState(currendSituation);
    end;
  12: //Interagiert mit der HeilStatur und heit den Spieler
    begin
      Player1.ChangeHealthBy(100); //<------------------------------------------I DONT KNOW ABOUT THIS HEALTH
      PrintAndUIChange(currendSituation, 'You pray to the godess you dont know and ask for her assistance.'+sLineBreak+'You health has been restored.');
      FreeAndNil(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  13: //Öffnet die Chest und gibt dem Spieler das Item in der Truhe
    begin
      Player1.AddItem(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetChestItem());
      PrintAndUIChange(currendSituation, 'You open the chest.'+sLineBreak+'You found '+Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetChestItem().GetName()+'. '+sLineBreak+Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetChestItem().GetDescription());
      FreeAndNil(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  14: //Versucht die Mimic zu öffnen; Startet einen Kampf den der Gegner beginnt
    begin
      //Sets the chestItem to the item droped by the enemy
      Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetMimicEnemy().SetItemDrop(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetChestItem());
      FightingEnemy := Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetMimicEnemy();
      PrintAndUIChange(2, 'The Chest was a Monster!'+sLineBreak+'It hit you before you could react.');
      FreeAndNil(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  15: //Interagiet mit der Skill Statur und erhalte den ihren Skill
    begin
      Player1.AddSkill(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetSkillToTeach());
      PrintAndUIChange(currendSituation, 'As you touch the stature you feel great power and knowlegde flow throght your body.'+sLineBreak+
                                         'You have learned '+Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetSkillToTeach().GetName()+sLineBreak+
                                         Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetSkillToTeach().GetDescription());
      FreeAndNil(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  53: //Rüstet die im Inventar ausgewählte waffe aus und beendet die Runde des Spielers
    begin
      Player1.SetCurrendWeapon(Player1.weaponInventory[inventoryIndex]);
      PrintAndUIChange(2, 'You equiped '+Player1.weaponInventory[inventoryIndex].GetName()+'.');
      PlayerEndTurn();
    end;
  54: //Benutzt das im Inventar ausgewählte Item und beendet die Runde des Spielers
    begin
      If (Player1.itemInventory[inventoryIndex].UseItem() = false) then ShowMessage('You are not able to use this Item in combat.')
      else begin
        PrintAndUIChange(2, 'You used '+Player1.itemInventory[inventoryIndex].GetName()+'.');
        PlayerEndTurn();
      end;
    end;
  55: //Bunutzt den im Inventar ausgewählten Skill, macht dem Gegner Schaden und beendet die Runde des Spielers
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
        PrintAndUIChange(UIState, 'You have to wait '+IntToStr(Player1.Skills[inventoryIndex].GetTurnsToWait())+' turn(s) until you can use this skill again.');
      end;
    end;
  99: //Akzeptiert die Geschriebene Nachricht und geht zu der in den PrintAndUIChange(); ausgewählten UIState
    begin
      ChangeUIState(UIStateCopy);
    end
  else ShowMessage('This Button has no effect'); //Debug
  end;
end;
procedure TForm1.Button_3_Action(); //                                     --> 3
begin
  case UIState of
  0: //y Positiv im RoomArr
    begin
      if (Player1.GetCurrendRoom.GetPosY+1 <= Room_y) and (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY+1,Player1.GetCurrendRoom.getPosZ] <> nil) and (Player1.GetCurrendRoom.GetBlockedTop = false) and (Player1.GetCurrendRoom.GetDoorTop = false) then begin
        OnLeaveRoom();
        Player1.ChangeRoom('yPos');
        PrintRoomData(Player1.GetCurrendRoom());
        OnEnterRoom();
      end;
    end;
  1: //Öffnet das Waffen Menü
    begin
      if (Player1.HasWeaponsInInventory() = true) then  ChangeUIState(53) //Weapon Menu
      else Memo1.Lines.Add('You have no weapons in your arsenal.')
    end;
  2: {do nothing};
  10: {do nothing};
  11: {do nothing};
  12: {do nothing};
  13: //greift die Truhe an und zerstört sie
    begin
      PrintAndUIChange(0, 'You attack the chest and break it.'+sLineBreak+'Whatever has been inside is now destroyed.');
      FreeAndNil(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  14: //greift die Mimic an und startet den Kampf mit der Runde des Spieles als erstes
    begin
      Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetMimicEnemy().SetItemDrop(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetChestItem());
      FightingEnemy := Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetMimicEnemy();
      PrintAndUIChange(1, 'Before you can attack the Chest it jumpes up and reveals itself to be a monster.');
      FreeAndNil(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  15: {do nothing};
  53: //geht im Waffen Menü nach oben
    begin
      if (inventoryIndex - 1 >= 0) then
        if (Player1.weaponInventory[inventoryIndex - 1] <> nil) then
          inventoryIndex := inventoryIndex - 1
        else ShowMessage('There is no weapon down there')
      else ShowMessage('can now go futher down (index of Weapons)');
      PrintWeaponData(Player1.weaponInventory[inventoryIndex]);
    end;
  54: //geht im Item Menü nach oben
    begin
      if (inventoryIndex - 1 >= 0) then
        if (Player1.itemInventory[inventoryIndex - 1] <> nil) then
          inventoryIndex := inventoryIndex - 1
        else ShowMessage('There is no item down there')
      else ShowMessage('can now go futher down (index of Weapons)');
      PrintItemData(Player1.itemInventory[inventoryIndex]);
    end;
  55: //geht im Skill Menü nach oben
    begin
      if (inventoryIndex - 1 >= 0) then
        if (Player1.Skills[inventoryIndex - 1] <> nil) then
          inventoryIndex := inventoryIndex - 1
        else ShowMessage('There is no skill down there')
      else ShowMessage('can now go futher down');
      PrintSkillData(Player1.Skills[inventoryIndex]);
    end;
  99: {Do Nothing};
  else ShowMessage('This Button has no effect'); //Debug
  end;
end;
procedure TForm1.Button_4_Action(); //                                     --> 4
begin
  case UIState of
  0: //y Minus im RoomArray
    begin
      if (Player1.GetCurrendRoom.GetPosY-1 >= 0) and (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY-1,Player1.GetCurrendRoom.getPosZ] <> nil) and (Player1.GetCurrendRoom.GetBlockedBottom = false) and (Player1.GetCurrendRoom.GetDoorBottom = false) then begin
        OnLeaveRoom();
        Player1.ChangeRoom('yNeg');
        PrintRoomData(Player1.GetCurrendRoom());
        OnEnterRoom();
      end;
    end;
  1: //Öffnet das Item Menü
    begin
      if (Player1.HasItemsInInventory() = true) then ChangeUIState(54) //Item Menu
      else Memo1.Lines.Add('You have no items in your inventory.')
    end;
  2: {do nothing};
  10: {do nothing};
  11: {do nothing};
  12: {do nothing};
  13: {do nothing};
  14: {do nothing};
  15: {do nothing};
  53: //geht im Waffen Menü nach unten
    begin
      if (inventoryIndex + 1 <= length(Player1.weaponInventory) - 1) then
        if (Player1.weaponInventory[inventoryIndex + 1] <> nil) then
          inventoryIndex := inventoryIndex + 1
        else ShowMessage('There is no weapon up there')
      else ShowMessage('can now go futher up (index of Items)');
      PrintWeaponData(Player1.weaponInventory[inventoryIndex]);
    end;
  54: //geht im Item Menü nach unten
    begin
      if (inventoryIndex + 1 <= length(Player1.itemInventory) - 1) then
        if (Player1.itemInventory[inventoryIndex + 1] <> nil) then
          inventoryIndex := inventoryIndex + 1
        else ShowMessage('There is no item up there')
      else ShowMessage('can now go futher up (index of Items)');
      PrintItemData(Player1.itemInventory[inventoryIndex]);
    end;
  55: //geht im Skill Menü nach unten
    begin
      if (inventoryIndex + 1 <= length(Player1.Skills) - 1) then
        if (Player1.Skills[inventoryIndex + 1] <> nil) then
          inventoryIndex := inventoryIndex + 1
        else ShowMessage('There is no skill up there')
      else ShowMessage('can now go futher up (index of Skills)');
      PrintSkillData(Player1.Skills[inventoryIndex]);
    end;
  99: {Do Nothing};
  else ShowMessage('This Button has no effect'); //Debug
  end;
end;
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{---------------------------Ändern-der-Situation-------------------------------}

procedure TForm1.ChangeSituation(_situation: integer); //ändert currendSituation
begin
  currendSituation := _situation;
  ChangeUIState(currendSituation);

  Edit2.Text := IntToStr(currendSituation);
end;

procedure TForm1.PrintAndUIChange(_changeUITo: integer; _toPrint: string); //änderd UIState und zeigt vorher noch eine Nachricht
begin
  if (_changeUITo = 0) then ChangeSituation(0);
  if (_changeUITo = 1) then ChangeSituation(1);

  Memo1.Clear();
  Memo1.Lines.Add(_toPrint);
  UIStateCopy := _changeUITo;

  ChangeUIState(99);
end;

procedure TForm1.ChangeUIState(_state: integer); //ändert UIState und Updatet dementsprechend die UI
var i: integer;
begin
  UIState := _state;

  //Debug
  Edit1.Text := IntToStr(UIState);
  Edit3.Text := IntToStr(currendSituation);

  //Activate all Buttons at first
  SetButton(Btn1_Image, Btn1_Label, true);
  SetButton(Btn2_Image, Btn2_Label, true);
  SetButton(Btn3_Image, Btn3_Label, true);
  SetButton(Btn4_Image, Btn4_Label, true);

  case UIState of
    0: //das Bewegen in den Räumen
    begin
      currendSituation := 0;
      Btn1_Label.caption := 'x Plus';
      Btn2_Label.caption := 'x Minus';
      Btn3_Label.caption := 'y Plus';
      Btn4_Label.caption := 'y Minus';
      PrintRoomData(Player1.GetCurrendRoom());

      OnEnterRoom(); //whenever you can walk again it checks if there is (still) stuff in the Room
    end;
  1: //Kämpfen mit normalen Gegnern (Runde des Spielers)
    begin
      currendSituation := 1;
      Btn1_Label.caption := 'Skills';
      Btn2_Label.caption := 'Attack';
      Btn3_Label.caption := 'Weapons';
      Btn4_Label.caption := 'Items';

      Memo1.Clear();
      Memo1.Lines.Add('The Enemy stands in front of you.'+sLineBreak+'What will you do?');

      PrintEnemyData(FightingEnemy);
    end;
  2: //Kämpfen mit normalen Gegnern (Runde des Gegners)
    begin
      currendSituation := 2;
      Btn1_Label.caption := '';
      SetButton(Btn1_Image, Btn1_Label, false);
      Btn2_Label.caption := 'Ok';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := '';
      SetButton(Btn3_Image, Btn3_Label, false);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      EnemyTurn(); //The Enemy deals Damage

      PrintEnemyData(FightingEnemy);
    end;
  10: //Interagiert mit einer Waffe in einem Raum
    begin
      Btn1_Label.caption := 'Leave it';
      SetButton(Btn1_Image, Btn1_Label, true);
      Btn2_Label.caption := 'Take it';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := '';
      SetButton(Btn3_Image, Btn3_Label, false);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      Memo1.Clear();
      Memo1.Lines.AddText('You notice a Weapon and inspect it closer.');

      PrintWeaponData(Player1.GetCurrendRoom().WeaponArr[roomStuffIndex]);
    end;
  11: //Interagiert mit einem Item in einem Raum
    begin
      Btn1_Label.caption := 'Leave it';
      SetButton(Btn1_Image, Btn1_Label, true);
      Btn2_Label.caption := 'Take it';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := '';
      SetButton(Btn3_Image, Btn3_Label, false);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      Memo1.Clear();
      Memo1.Lines.AddText('You notice a Item and inspect it closer.');

      PrintItemData(Player1.GetCurrendRoom().ItemArr[roomStuffIndex]);
    end;
  12: //Interagiert mit einer Heil Statur in einem Raum
    begin
      Btn1_Label.caption := 'Leave';
      SetButton(Btn1_Image, Btn1_Label, true);
      Btn2_Label.caption := 'Pray';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := '';
      SetButton(Btn3_Image, Btn3_Label, false);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      PrintRoomObjectData(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  13: //Interagiert mit einer Truhe in einem Raum
    begin
      Btn1_Label.caption := 'Leave';
      SetButton(Btn1_Image, Btn1_Label, true);
      Btn2_Label.caption := 'Open';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := 'Attack';
      SetButton(Btn3_Image, Btn3_Label, true);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      PrintRoomObjectData(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  14: //Interagiert mit einer Mimic in einem Raum
    begin
      Btn1_Label.caption := 'Leave';
      SetButton(Btn1_Image, Btn1_Label, true);
      Btn2_Label.caption := 'Open';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := 'Attack';
      SetButton(Btn3_Image, Btn3_Label, true);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      PrintRoomObjectData(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  15: //Interagiert mit einer Skill Statur in einem Raum
    begin
      Btn1_Label.caption := 'Leave';
      SetButton(Btn1_Image, Btn1_Label, true);
      Btn2_Label.caption := 'Touch';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := '';
      SetButton(Btn3_Image, Btn3_Label, false);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      PrintRoomObjectData(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  53: //Das Waffen Menu
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
  54: //Das Item Menu
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
  55: //Das Skill Menu
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
          Memo1.Lines.Add('-'+Player1.Skills[i].GetName()+' ('+IntToStr(Player1.Skills[i].GetTurnsToWait())+')');
          inventoryIndex := i;
        end;
      PrintSkillData(Player1.Skills[inventoryIndex]);
    end;

  99: //Die einmalige Nachricht
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
  else ShowMessage('You are in a UIState which has no definition.'+slineBreak+'How the hell did you get here?!'); //Debug
  end;

  PrintPlayerData(Player1); //Schreibt die stats des Spielers
end;
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{------------------Logic-hinter-bestimmten-Situationen-------------------------}
//wird aufgerufen wenn man einen Raum betritt und wenn man eine aktion im Raum beendet hat (Kämpfen, Interagieren)
procedure TForm1.OnEnterRoom(); //logic situation = 0
var
  i: integer;
begin
  //1. check nach Gegnern
  if (length(Player1.GetCurrendRoom().EnemyArr) > 0) then
  begin
    for i := 0 to length(Player1.GetCurrendRoom().EnemyArr) - 1 do
      if (Player1.GetCurrendRoom().EnemyArr[i] <> nil) then
      begin  //start Fight
        FightingEnemy := Player1.GetCurrendRoom().EnemyArr[i];
        PrintAndUIChange(1, 'You are now fighting!');
      end;
  end;

  //2. check nach Waffen
  if (length(Player1.GetCurrendRoom().WeaponArr) > 0) then
  begin
    for i := 0 to length(Player1.GetCurrendRoom().WeaponArr) - 1 do
      if (Player1.GetCurrendRoom().WeaponArr[i] <> nil) then
        if (Player1.GetCurrendRoom().WeaponArr[i].GetIgnore() = false) then
        begin
          roomStuffIndex := i;
          ChangeUIState(10);
        end;
  end else
  //3. check nach Items
  if (length(Player1.GetCurrendRoom().ItemArr) > 0) then
  begin
    for i := 0 to length(Player1.GetCurrendRoom().ItemArr) - 1 do
      if (Player1.GetCurrendRoom().ItemArr[i] <> nil) then
        if (Player1.GetCurrendRoom().ItemArr[i].GetIgnore() = false) then
        begin
          roomStuffIndex := i;
          ChangeUIState(11);
        end;
  end else
  //4. check nach RoomObjects
  if (length(Player1.GetCurrendRoom().RoomObjectArr) > 0) then
  begin
    for i := 0 to length(Player1.GetCurrendRoom().RoomObjectArr) - 1 do
      if (Player1.GetCurrendRoom().RoomObjectArr[i] <> nil) then
        if (Player1.GetCurrendRoom().RoomObjectArr[i].GetIgnore() = false) then
        begin
          roomStuffIndex := i;
          if (Player1.GetCurrendRoom().RoomObjectArr[i].GetIsHealing()) then
            PrintAndUIChange(12, 'You notice a stature and get closer to it.');
          if (Player1.GetCurrendRoom().RoomObjectArr[i].GetIsChest()) then
            PrintAndUIChange(13, 'You notice a chest and get closer to it.');
          if (Player1.GetCurrendRoom().RoomObjectArr[i].GetIsMimic()) then
            PrintAndUIChange(14, 'You notice a chest and get closer to it.');
          if (Player1.GetCurrendRoom().RoomObjectArr[i].GetIsSkillStatue()) then
            PrintAndUIChange(15, 'You notice a stature and get closer to it.');
        end;
  end;

  //Check nach verfügbaren Räumen und aktiviere die Knöpfe dem entsprechend
  if (UIState = 0) then
  begin
    if (Player1.GetCurrendRoom.GetPosX+1 > Room_x-1) or (RoomArr[Player1.GetCurrendRoom.getPosX+1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] = nil) or (Player1.GetCurrendRoom.GetBlockedRight = true) or (Player1.GetCurrendRoom.GetDoorRight = true) then
      SetButton(Btn1_Image, Btn1_Label, false)
    else SetButton(Btn1_Image, Btn1_Label, true);

    if (Player1.GetCurrendRoom.GetPosX-1 < 0) or (RoomArr[Player1.GetCurrendRoom.getPosX-1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] = nil) or (Player1.GetCurrendRoom.GetBlockedLeft = true) or (Player1.GetCurrendRoom.GetDoorLeft = true) then
      SetButton(Btn2_Image, Btn2_Label, false)
    else SetButton(Btn2_Image, Btn2_Label, true);

    if (Player1.GetCurrendRoom.GetPosY+1 > Room_y-1) or (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY+1,Player1.GetCurrendRoom.getPosZ] = nil) or (Player1.GetCurrendRoom.GetBlockedTop = true) or (Player1.GetCurrendRoom.GetDoorTop = true) then
      SetButton(Btn3_Image, Btn3_Label, false)
    else SetButton(Btn3_Image, Btn3_Label, true);

    if (Player1.GetCurrendRoom.GetPosY-1 < 0) or (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY-1,Player1.GetCurrendRoom.getPosZ] = nil) or (Player1.GetCurrendRoom.GetBlockedBottom = true) or (Player1.GetCurrendRoom.GetDoorBottom = true) then
      SetButton(Btn4_Image, Btn4_Label, false)
    else SetButton(Btn4_Image, Btn4_Label, true);
  end;

  if (currendSituation = 0) and (UIState = 0) then PrintRoomData(Player1.GetCurrendRoom());
end;

//wird aufgerufen bevor man den Raum ändert
procedure TForm1.OnLeaveRoom(); //logic situation = 0
var i: integer;
begin
  //resets all cooldowns
  for i := 0 to length(Player1.Skills) - 1 do
    if (Player1.Skills[i] <> nil) then
      Player1.Skills[i].SetTurnToWaitToZero();

  //Sets all Ignore values back to false so that the items/whatever are interactable again
  for i := 0 to length(Player1.GetCurrendRoom().ItemArr) - 1 do
    if (Player1.GetCurrendRoom().ItemArr[i] <> nil) then
      Player1.GetCurrendRoom().ItemArr[i].SetIgnore(false);

  for i := 0 to length(Player1.GetCurrendRoom().WeaponArr) - 1 do
    if (Player1.GetCurrendRoom().WeaponArr[i] <> nil) then
      Player1.GetCurrendRoom().WeaponArr[i].SetIgnore(false);

  for i := 0 to length(Player1.GetCurrendRoom().RoomObjectArr) - 1 do
    if (Player1.GetCurrendRoom().RoomObjectArr[i] <> nil) then
      Player1.GetCurrendRoom().RoomObjectArr[i].SetIgnore(false);
end;

//wird am Ende der Spieler Runde aufgerufen und schaut ob der Gegner besiegt wurde
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
    for i := 0 to length(Player1.GetCurrendRoom.EnemyArr)-1 do
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

//wird am ende/in der Runde des Gegners aufgerufen und macht dem Spieler Schaden
procedure TForm1.EnemyTurn(); //logic situation = 2
begin
  Player1.ChangeHealthBy(-(FightingEnemy.GetDamage()));
  Memo1.Clear();
  Memo1.Lines.Add('The Enemy delt ' + FloatToStr(FightingEnemy.GetDamage())+' damage.'+sLineBreak+'You now have ' + FloatToStr(Player1.GetHealth()) + ' health left');
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

procedure TForm1.PrintWeaponData(_weapon: TWeapon); //print situation = 53 and 10
begin
  Memo_Description.Clear();
  Memo_Description.Lines.AddText(_weapon.GetName());
  Memo_Description.Lines.Add('');
  Memo_Description.Lines.AddText(_weapon.GetDescription());
  Image1.Picture.LoadFromFile(_weapon.GetImagePath());
end;

procedure TForm1.PrintItemData(_item: TItem); //print situation = 54 and 11
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

procedure TForm1.PrintRoomObjectData(_roomObject: TRoomObject); //print situation = 12, 13, 14, 15
begin
  Memo_Description.Clear();
  Memo_Description.Lines.AddText(_roomObject.GetName());
  Memo1.Clear();
  Memo1.Lines.AddText(_roomObject.GetDescription());
  Image1.Picture.LoadFromFile(_roomObject.GetImagePath());
end;
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{------------------------Erstellen-der-Räume-----------------------------------}
procedure TForm1.CreateARoom(_description: string; _imagePath: string; _pos_x, _pos_y, _pos_z: integer); //Erstellt einen Raum in der angegebenen Position im RoomArray
begin
  RoomArr[_pos_x, _pos_y, _pos_z] := TRoom.Create(_description, _imagePath, _pos_x, _pos_y, _pos_z);
end;

procedure TForm1.CreateRooms(); //Erstellt den Inhalt des Spieles
begin
  //Ebene 1
  begin
    CreateARoom('Your in your cell ...'+sLineBreak+'But you have a Bonfire!'+sLineBreak+sLineBreak+'Praise The Sun!', 'Images/Rooms/BonFireCellRoom.png', 1, 0, 0);
    CreateARoom('Erste Kreuzung.', 'Images/Rooms/Höle.png', 2, 0, 0);
    RoomArr[2, 0, 0].AddRoomObject(TRoomObject.Create('Definitly a chest', 'Why dont you open it?', 'Images/Enemies/BestMimicEver.jpg'));
    RoomArr[2, 0, 0].RoomObjectArr[0].SetHealing();
    RoomArr[2, 0, 0].RoomObjectArr[0].SetChest(TItem.Create('ITEM', 'ITEM!!!!!!!!!!','Images/Items/ITEM.png'));
    //RoomArr[2, 0, 0].RoomObjectArr[0].SetMimic(TItem.Create('ITEM', 'ITEM!!!!!!!!!!','Images/Items/ITEM.png'), TEnemy.Create('Best Mimic Ever', 15, 15, 'Images/Enemies/BestMimicEver.jpg'));
    //RoomArr[2, 0, 0].RoomObjectArr[0].SetSkillStatue(TSkill.Create('Some other Skill', 'This one is just useless...'+sLineBreak+ 'It deals Slash Damage', 'Images/Skills/someOtherSkill.png', 5, 0, 0, 1.2, 0));

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
    RoomArr[2,3,0].SetDoorTop(true);
    CreateARoom('I see trouble', 'Images/Rooms/Höle.png', 3, 2, 0);
    CreateARoom('And we make it tripple', 'Images/Rooms/Höle.png', 4, 2, 0);
    CreateARoom('Gäb es doch nur Bonfire', 'Images/Rooms/Höle.png', 5, 2, 0);
    CreateARoom('Praise the Bonfire', 'Images/Rooms/Höle.png', 5, 3, 0);
    RoomArr[5,3,0].SetBlockedLeft(true);
    CreateARoom('Leerer Raum oder so', 'Images/Rooms/Höle.png', 4, 3, 0);
    RoomArr[4,3,0].SetBlockedRight(true);
    CreateARoom('Drop den Schlüssel Goblin', 'Images/Rooms/Höle.png', 4, 4, 0);
    CreateARoom('Useless ahead', 'Images/Rooms/Höle.png', 3, 4, 0);
    CreateARoom('Zum Glück hatte ich den schlüssel', 'Images/Rooms/Höle.png', 2, 4, 0);
    RoomArr[2,4,0].SetDoorBottom(true);
    CreateARoom('Estus vorraus', 'Images/Rooms/Höle.png', 1, 4, 0);
    CreateARoom('This is so sad. Alexa, play Gwyns theme', 'Images/Rooms/Höle.png', 2, 5, 0);
  end;

  //Ebene 2
  begin
    CreateARoom('Bossraum.', 'Images/Rooms/Höle.png', 2, 5, 1);
    CreateARoom('Hier liegt ein Skill.', 'Images/Rooms/Höle.png', 0, 4, 1);
    CreateARoom('Drei Wege.', 'Images/Rooms/Höle.png', 1, 4, 1);
    CreateARoom('Hier gehts zum Boss.', 'Images/Rooms/Höle.png', 2, 4, 1);
    RoomArr[2,4,1].setblockedright(true);
    CreateARoom('Treppe zu Ebene 3.', 'Images/Rooms/Höle.png', 3, 4, 1);
    RoomArr[3,4,1].setblockedleft(true);
    RoomArr[3,4,1].setdoorright(true);
    CreateARoom('Startraum der zeiten Ebene.', 'Images/Rooms/Höle.png', 4, 4, 1);
    RoomArr[4,4,1].setdoorleft(true);
    CreateARoom('Shiny Truhe.', 'Images/Rooms/Höle.png', 6, 4, 1);
    CreateARoom('Schatz vorraus?.', 'Images/Rooms/Höle.png', 1, 3, 1);
    RoomArr[1,3,1].setblockedright(true);
    CreateARoom('Gut, dass ich den Schlüssel hatte.', 'Images/Rooms/Höle.png', 2, 3, 1);
    RoomArr[2,3,1].setblockedleft(true);
    RoomArr[2,3,1].setdoorright(true);
    CreateARoom('Hätte ich doch nur Schlüssel.', 'Images/Rooms/Höle.png', 3, 3, 1);
    RoomArr[3,3,1].setdoorleft(true);
    RoomArr[3,3,1].setdoorbottom(true);
    CreateARoom('F*cking Skelett.', 'Images/Rooms/Höle.png', 4, 3, 1);
    RoomArr[4,3,1].setblockedbottom(true);
    CreateARoom('Skelett im Doppelpack.', 'Images/Rooms/Höle.png', 5, 3, 1);
    RoomArr[5,3,1].setblockedbottom(true);
    CreateARoom('Schatz vorraus!.', 'Images/Rooms/Höle.png', 6, 3, 1);
    CreateARoom('Heal me up Scotty!.', 'Images/Rooms/Höle.png', 0, 2, 1);
    CreateARoom('Mimikrier mich nicht.', 'Images/Rooms/Höle.png', 1, 2, 1);
    RoomArr[1,2,1].setblockedright(true);
    CreateARoom('Leerer Raum.', 'Images/Rooms/Höle.png', 2, 2, 1);
    RoomArr[2,2,1].setblockedleft(true);
    RoomArr[2,2,1].setblockedright(true);
    CreateARoom('Zum Glück hatte ich noch einen Schlüssel.', 'Images/Rooms/Höle.png', 3, 2, 1);
    RoomArr[3,2,1].setblockedleft(true);
    RoomArr[3,2,1].setdoortop(true);
    RoomArr[3,2,1].setdoorright(true);
    CreateARoom('Diese Wand sieht nicht sehr stabil aus....', 'Images/Rooms/Höle.png', 4, 2, 1);
    RoomArr[4,2,1].setdoorleft(true);
    RoomArr[4,2,1].setdoorbottom(true);
    RoomArr[4,2,1].setblockedtop(true);
    CreateARoom('Random Wächter.', 'Images/Rooms/Höle.png', 5, 2, 1);
    RoomArr[5,2,1].setblockedtop(true);
    RoomArr[5,2,1].setblockedbottom(true);
    CreateARoom('Mehr Skills.', 'Images/Rooms/Höle.png', 6, 2, 1);
    CreateARoom('Noch ein Skelett.', 'Images/Rooms/Höle.png', 3, 1, 1);
    RoomArr[3,1,1].setblockedright(true);
    CreateARoom('Ein Agriffsboost liegt hinter dieser Wand.', 'Images/Rooms/Höle.png', 4, 1, 1);
    RoomArr[4,1,1].setblockedleft(true);
    CreateARoom('Hey, wanna buy some Keys.', 'Images/Rooms/Höle.png', 5, 1, 1);
    RoomArr[5,1,1].setblockedtop(true);
    CreateARoom('Dieser Wächter hat 100 pro einen Schlüssel.', 'Images/Rooms/Höle.png', 3, 0, 1);
  end;

  //Ebene 3
  begin

  end;
end;
{------------------------------------------------------------------------------}

end.
