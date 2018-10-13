unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LCLType, ActnList, MMSystem{für die Musik},
  menue, youdied, //Die Anderen Formen
  RoomClass{für TRoom}, PlayerClass{für TPlayer}, EnemyClass{für TEnemy}, WeaponClass{für TWeapon}, ItemClass{für TItem}, SkillClass{I think you know by now...}, RoomObjectClass{could it be? is this really for TRoomClass?!}, BossClass{...};

type

  { TForm1 }

  TForm1 = class(TForm)
    Arrow_Image: TImage;
    Oriantation_Image: TImage;
    Direction_Image: TImage;
    Direction_Label: TLabel;
    MuteBtn_Image: TImage;
    Memo_Stats: TMemo;
    Memo_Description: TMemo;
    Image1: TImage;
    RoomPicture: TImage;
    Label_Leave: TLabel;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      //Its a secret!
    Memo1: TMemo;
    MusicTimer: TTimer;
    //Alles zu Buttons
    Btn1_Label: TLabel;
    Btn2_Label: TLabel;
    Btn3_Label: TLabel;
    Btn4_Label: TLabel;
    Btn1_Image: TImage;
    Btn2_Image: TImage;
    Btn3_Image: TImage;
    Btn4_Image: TImage;
    procedure Btn1Click(Sender: TObject);
    procedure Btn2Click(Sender: TObject);
    procedure Btn3Click(Sender: TObject);
    procedure Btn4Click(Sender: TObject);
    procedure Btn1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Btn1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Btn2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Btn2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Btn3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Btn3MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Btn4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Btn4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Btn1MouseEnter(Sender: TObject);
    procedure Btn1MouseLeave(Sender: TObject);
    procedure Btn2MouseEnter(Sender: TObject);
    procedure Btn2MouseLeave(Sender: TObject);
    procedure Btn3MouseEnter(Sender: TObject);
    procedure Btn3MouseLeave(Sender: TObject);
    procedure Btn4MouseEnter(Sender: TObject);
    procedure Btn4MouseLeave(Sender: TObject);

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
    procedure SetButton(_background: TImage; _text: TLabel; toSetTo: boolean; door: boolean= false); //aktiviert oder deaktiviert den Butten mit dem TImage _bg und dem TLbl _text

    //Verwaltung der Situation und UIState
    //procedure ChangeSituation(_situation: integer); //ändert die grundlegende Situation und ruft danach auch ChangeUIState(); auf um die UI zu updaten
    procedure ChangeUIState(_state: integer); //Updatet die UI kann das Inventar öffnen
    procedure PrintAndUIChange(_changeUITo: integer; _toPrint: string); //zeigt zusätzlich zum ändern der UI noch eine einmalige Nachicht. Sollte man es mit UIState aufrufen zeigt sie einfach nur eine Nachricht und geht dan zurück zu wo es war

    //Logic hinter bestimmten Situationen
    procedure OnEnterRoom(); //situation = 0;  schaut ob dinge/Enemyies im Raum sind usw.
    procedure OnLeaveRoom(); //Resetet cooldowns und alle Ignore Variablen von Sahcen die im Raum sind
    procedure PlayerEndTurn(); //situation = 1;  schaut ob der Enemy besiegt ist und verigert die cooldowns
    procedure EnemyTurn(); //situation = 2;  macht dem Player schaden und schaut ob dieser Tod ist
    procedure PlayerEndTurnBoss(); ////situation = 3;  schaut ob der Boss besiegt wurde und verigert die cooldowns
    procedure BossTurn(); //logic situation = 4 macht dem Player schaden und schaut ob dieser Tod ist

    procedure PlayerDeath();

    //Schreibt die jeweiligen Infos auf dei jeweiligen memos und so
    procedure PrintPlayerData(_player: TPlayer); //print situation all
    procedure PrintRoomData(_room: TRoom); //print situation = 0
    procedure PrintEnemyData(_enemy: TEnemy); //print situation = 1 and 2
    procedure PrintBossData(_boss: TBoss); //print situation 3 and 4
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
  songlength: integer; //wie lange MusicTimer warten muss bis er den song wiederholt. In sekunden, da alles darunter irgendwie nicht mehr richtig die Zeit wiederspiegelt
  muted: boolean; //wenn false wird musik gespielt

  //Buttons
  Btn1_active,
  Btn2_active,
  Btn3_active,
  Btn4_active: boolean;

  RoomArr: Array of Array of Array of TRoom; //Das Array aller Räume
  Room_x, Room_y, Room_z: integer; //Die Länge des RoomArray in alle drei Richtungen
  Player1: TPlayer; //Das Spieler Object welches leben und Inventar speichert
  FightingEnemy: TEnemy; //Der gegner gegen den man Kämpft wenn man in Situation 1 oder 2 ist
  FightingBoss: TBoss; //Der Boss gegen den man Kämpft wenn man in Situation 3 oder 4 ist
  DelayedPhaseChange: boolean; //merkt sich ob die phase des bosses verzögert wurde um das nicht wieder zu tun

  //Diese Variablen sind dafür da die Spielsituationen zu ändern
  currendSituation: integer; //diese variable merkt sich die grundlegende Spielsituation unabhängig von dem möglicherweise offenen Menü //0 = laufen; 1 = Kampf(Runde des Spielers) 2 = Kampf(Runde des Gegners)
  UIState: integer; //diese Variable ist dafür da alle Menüs zu navigieren sie ist unabhängig von currendSituation damit man wieder dahin zurückkehren kann von wo man das Menu geöffnet hat
  UIStateCopy: integer; //diese var ist für situation 99 um dahin zurück zukehren wo man vorher war

  //diese Beiden vars sind dafür da, das die information an welcher stelle das item/etc jewailigen array des Inventar/Raum ist. bsp: man hat zwei items in inventar was auch immer danach geschaut hat weiß das und will, das infos zum ersten gedruckt werden also setzt es die var auf die stelle des items
  inventoryIndex: integer;
  roomStuffIndex: integer;
  DmgBuff, DefBuff: real;
  multyAttack: integer; //gimick for daggers
  isplaying: boolean;

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
  roomStuffIndex := 0;
  DmgBuff := 1;
  DefBuff := 1;

  multyAttack := 1;

  DelayedPhaseChange := false;

  songPath := 'music\overworldTheme_loop.wav';
  songlength := 27; //27s ist die exakte länge von overworldTheme_loop
  muted := true;
  if (muted = true) then
    MuteBtn_Image.Picture.LoadFromFile('Images/Buttons/MuteBtnOff.png')
  else if (muted = false) then
    MuteBtn_Image.Picture.LoadFromFile('Images/Buttons/MuteBtnOn.png');

  //Set RoomArray size
  Room_x := 8;
  Room_y := 8;
  Room_z := 7;

  //Setzt die Länge des RoomArray erst in x dann y und dann z Richtung
  SetLength(RoomArr, Room_x);
  for i := 0 to Room_y - 1 do
  begin
    SetLength(RoomArr[i], Room_y);
    for ii := 0 to Room_z - 1 do SetLength(RoomArr[i, ii], Room_z);
  end;

  CreateRooms(); //Erstellt das Spiel
  //Erschafft den Spieler in einem Raum
  Player1 := TPlayer.Create(RoomArr[3, 2, 1], TWeapon.Create('Fists', 'Just your good old hands.', 'Images/Items/ITEMpng', 10000, 0, 0, 0), 10000);

  //Ändert die Situation zum erstem mal
  ChangeUIState(0); //also updates UI
  Memo_Description.Clear();
end;

{------------------------------------------------------------------------------}
{----------------------Lazarus-generierte-proceduren---------------------------}
//Die von Lazarus Generierten procedure rufen nur unsere eigene auf sonst nichts
procedure TForm1.Btn1Click(Sender: TObject); begin Button_1_Action(); end;
procedure TForm1.Btn2Click(Sender: TObject); begin Button_2_Action(); end;
procedure TForm1.Btn3Click(Sender: TObject); begin Button_3_Action(); end;
procedure TForm1.Btn4Click(Sender: TObject); begin Button_4_Action(); end;

//MouseDown und MouseUp proceduren welche einfach nur den Buton an die Maus anpassen
procedure TForm1.Btn1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin if (Btn1_active = true) and (Player1.GetCurrendRoom.GetDoorRight = false) then Btn1_Image.Picture.LoadFromFile('Images/Buttons/Button_down.png'); end;
procedure TForm1.Btn1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin if (Btn1_active = true) and (Player1.GetCurrendRoom.GetDoorRight = false) then Btn1_Image.Picture.LoadFromFile('Images/Buttons/Button.png'); end;
procedure TForm1.Btn2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin if (Btn2_active = true) and (Player1.GetCurrendRoom.GetDoorLeft = false) then Btn2_Image.Picture.LoadFromFile('Images/Buttons/Button_down.png'); end;
procedure TForm1.Btn2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin if (Btn2_active = true) and (Player1.GetCurrendRoom.GetDoorLeft = false) then Btn2_Image.Picture.LoadFromFile('Images/Buttons/Button.png'); end;
procedure TForm1.Btn3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin if (Btn3_active = true) and (Player1.GetCurrendRoom.GetDoorTop = false) then Btn3_Image.Picture.LoadFromFile('Images/Buttons/Button_down.png'); end;
procedure TForm1.Btn3MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin if (Btn3_active = true) and (Player1.GetCurrendRoom.GetDoorTop = false) then Btn3_Image.Picture.LoadFromFile('Images/Buttons/Button.png'); end;
procedure TForm1.Btn4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin if (Btn4_active = true) and (Player1.GetCurrendRoom.GetDoorBottom = false) then Btn4_Image.Picture.LoadFromFile('Images/Buttons/Button_down.png'); end;
procedure TForm1.Btn4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); begin if (Btn4_active = true) and (Player1.GetCurrendRoom.GetDoorBottom = false) then Btn4_Image.Picture.LoadFromFile('Images/Buttons/Button.png'); end;

//Hover Effekt
procedure TForm1.Btn1MouseEnter(Sender: TObject); begin if (Btn1_active = true) and (Player1.GetCurrendRoom.GetDoorRight = false) then Btn1_Image.Picture.LoadFromFile('Images/Buttons/Button_hover.png'); end;
procedure TForm1.Btn1MouseLeave(Sender: TObject); begin if (Btn1_active = true) and (Player1.GetCurrendRoom.GetDoorRight = false) then Btn1_Image.Picture.LoadFromFile('Images/Buttons/Button.png'); end;
procedure TForm1.Btn2MouseEnter(Sender: TObject); begin if (Btn2_active = true) and (Player1.GetCurrendRoom.GetDoorLeft = false) then Btn2_Image.Picture.LoadFromFile('Images/Buttons/Button_hover.png'); end;
procedure TForm1.Btn2MouseLeave(Sender: TObject); begin if (Btn2_active = true) and (Player1.GetCurrendRoom.GetDoorLeft = false) then Btn2_Image.Picture.LoadFromFile('Images/Buttons/Button.png'); end;
procedure TForm1.Btn3MouseEnter(Sender: TObject); begin if (Btn3_active = true) and (Player1.GetCurrendRoom.GetDoorTop = false) then Btn3_Image.Picture.LoadFromFile('Images/Buttons/Button_hover.png'); end;
procedure TForm1.Btn3MouseLeave(Sender: TObject); begin if (Btn3_active = true) and (Player1.GetCurrendRoom.GetDoorTop = false) then Btn3_Image.Picture.LoadFromFile('Images/Buttons/Button.png'); end;
procedure TForm1.Btn4MouseEnter(Sender: TObject); begin if (Btn4_active = true) and (Player1.GetCurrendRoom.GetDoorBottom = false) then Btn4_Image.Picture.LoadFromFile('Images/Buttons/Button_hover.png'); end;
procedure TForm1.Btn4MouseLeave(Sender: TObject); begin if (Btn4_active = true) and (Player1.GetCurrendRoom.GetDoorBottom = false) then Btn4_Image.Picture.LoadFromFile('Images/Buttons/Button.png'); end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction); //Wenn man Form1 schließ dann schließt sich Form2 nicht automatisch da Form2 die Main Form ist
begin
  Form2.close();
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //Schaut ob Tasten gedrückt wurden
begin
  if (Key = VK_ESCAPE) then Application.Terminate();

  if (Key = VK_RIGHT) or (Key = VK_D) then Button_1_Action();
  if (Key = VK_LEFT) or (Key = VK_A) then Button_2_Action();
  if (Key = VK_UP) or (Key = VK_W) then Button_3_Action();
  if (Key = VK_DOWN) or (Key = VK_S) then Button_4_Action();
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
procedure TForm1.SetButton(_background: TImage; _text: TLabel; toSetTo: boolean; door: boolean= false);
begin
  if door then
  begin
    _text.Cursor := crDefault;
    _background.Cursor := crDefault;
    _background.Picture.LoadFromFile('Images/Buttons/Button_chained.png');
  end else if (toSetTo = true) then
  begin
    _text.Cursor := crHandPoint;
    _background.Cursor := crHandPoint;
    _background.Picture.LoadFromFile('Images/Buttons/Button.png');
  end
  else begin
    _text.Cursor := crDefault;
    _background.Cursor := crDefault;
    _background.Picture.LoadFromFile('Images/Buttons/Button_off.png');
  end;

  if (_background.Name = 'Btn1_Image') and (_text.Name = 'Btn1_Label') and (door = false) then Btn1_active := toSetTo;
  if (_background.Name = 'Btn2_Image') and (_text.Name = 'Btn2_Label') and (door = false) then Btn2_active := toSetTo;
  if (_background.Name = 'Btn3_Image') and (_text.Name = 'Btn3_Label') and (door = false) then Btn3_active := toSetTo;
  if (_background.Name = 'Btn4_Image') and (_text.Name = 'Btn4_Label') and (door = false) then Btn4_active := toSetTo;
end;

procedure TForm1.Button_1_Action(); //                                     --> 1
var i : integer;
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
      end else if Player1.GetCurrendRoom.GetDoorRight then
      begin
        for i:=0 to length(Player1.itemInventory)-1 do begin
            if Player1.GetCurrendRoom.GetDoorIndexRight = Player1.itemInventory[i].getKeyIndex then begin
              Player1.GetCurrendRoom.SetDoorRight(false);
              RoomArr[Player1.GetCurrendRoom.getPosX+1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ].SetDoorLeft(false);
              SetButton(Btn1_Image, Btn1_Label, true);
            end;
        end;
      end;
    end;
  1: //Öffnet das Skill Menu
    begin
      if (Player1.HasSkills() = true) then ChangeUIState(55) //Skill Menu
      else PrintAndUIChange(UIState, 'You have no skills yet.')
    end;
  2: {do nothing};
  3: //Öffnet das Skill Menu
    begin
      if (Player1.HasSkills() = true) then ChangeUIState(55) //Skill Menu
      else PrintAndUIChange(UIState, 'You have no skills yet.')
    end;
  4: {do nothing};
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
  16: //lässt das RoomObject im Raum
    begin
      Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].SetIgnore(true);
      PrintAndUIChange(currendSituation, 'You leave the Ladder.');
    end;
  17: //lässt das RoomObject im Raum
    begin
      Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].SetIgnore(true);
      PrintAndUIChange(currendSituation, 'You leave the Dealer.');
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
  i: integer;
begin
  case UIState of
  0: //x Minus im RoomArr
    begin
      if (Player1.GetCurrendRoom.GetPosX-1 >= 0) and (RoomArr[Player1.GetCurrendRoom.getPosX-1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] <> nil) and (Player1.GetCurrendRoom.GetBlockedLeft = false) and (Player1.GetCurrendRoom.GetDoorLeft = false) then
      begin
        OnLeaveRoom();
        Player1.ChangeRoom('xNeg');
        PrintRoomData(PLayer1.GetCurrendRoom());
        OnEnterRoom();
      end else if Player1.GetCurrendRoom.GetDoorLeft then
      begin
        for i:=0 to length(Player1.itemInventory)-1 do begin
            if Player1.GetCurrendRoom.GetDoorIndexLeft = Player1.itemInventory[i].getKeyIndex then begin
              Player1.GetCurrendRoom.SetDoorLeft(false);
              RoomArr[Player1.GetCurrendRoom.getPosX-1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ].SetDoorRight(false);
              SetButton(Btn2_Image, Btn2_Label, true);
            end;
        end;
      end;
    end;
  1: //Greift den Gegner an und macht ihm Schaden; Beendet die Runde des Spielers
    begin
      if (Player1.GetCurrendWeapon.GetName = 'Dagger') or (Player1.GetCurrendWeapon.GetName = 'MagicDagger') then
      begin
        randomize;
        multyattack := Random(4)+1;
      end;
      _dmg := FightingEnemy.DoDamage(Player1.GetCurrendWeapon().GetStrikeDmg()*DmgBuff*multyattack,
                                     Player1.GetCurrendWeapon().GetThrustDmg()*DmgBuff*multyattack,
                                     Player1.GetCurrendWeapon().GetSlashDmg()*DmgBuff*multyattack,
                                     Player1.GetCurrendWeapon().GetMagicDmg()*DmgBuff*multyattack);
      multyattack := 1;

      if (Player1.GetCurrendWeapon.GetName = 'Dagger') or (Player1.GetCurrendWeapon.GetName = 'MagicDagger') then
      PrintAndUIChange(2, 'You quickly attacked '+ IntToStr(multyattack)+' times with your Dagger'+sLineBreak+'You delt ' + FloatToStr(Round(_dmg)) + ' damage.'+sLineBreak+'The Enemy now has ' + FloatToStr(Round(FightingEnemy.GetHealth())) + ' health left')
      else PrintAndUIChange(2, 'You delt ' + FloatToStr(Round(_dmg)) + ' damage.'+sLineBreak+'The Enemy now has ' + FloatToStr(Round(FightingEnemy.GetHealth())) + ' health left');

      PlayerEndTurn();
    end;
  2: //Beendet die Runde des Gegners
    begin
      ChangeUIState(1);
    end;
  3:
    begin
      if (Player1.GetCurrendWeapon.GetName = 'Dagger') or (Player1.GetCurrendWeapon.GetName = 'Magic Dagger') then
      begin
        randomize;
        multyattack := Random(4)+1;
        _dmg := FightingBoss.DoDamage(Player1.GetCurrendWeapon().GetStrikeDmg()*multyattack,
                                          Player1.GetCurrendWeapon().GetThrustDmg()*multyattack,
                                          Player1.GetCurrendWeapon().GetSlashDmg()*multyattack,
                                          Player1.GetCurrendWeapon().GetMagicDmg()*multyattack);
      end else
        _dmg := FightingBoss.DoDamage(Player1.GetCurrendWeapon().GetStrikeDmg(),
                                          Player1.GetCurrendWeapon().GetThrustDmg(),
                                          Player1.GetCurrendWeapon().GetSlashDmg(),
                                          Player1.GetCurrendWeapon().GetMagicDmg());

      if (Player1.GetCurrendWeapon.GetName = 'Dagger') or (Player1.GetCurrendWeapon.GetName = 'MagicDagger') then
      PrintAndUIChange(4, 'You quickly attacked '+ IntToStr(multyattack)+' times with your Dagger'+sLineBreak+'You delt ' + FloatToStr(Round(_dmg)) + ' damage.'+sLineBreak+'The Enemy now has ' + FloatToStr(Round(FightingBoss.GetHealth())) + ' health left')
      else PrintAndUIChange(4, 'You delt ' + FloatToStr(Round(_dmg)) + ' damage.'+sLineBreak+'The Boss now has ' + FloatToStr(Round(FightingBoss.GetHealth())) + ' health left');

      PlayerEndTurnBoss();
    end;
  4: //Beendet die Runde des Bosses
    begin
      ChangeUIState(3);
    end;
  10: //Nimmt die Waffe die im Raum liegt und geht weiter
    begin
      Player1.AddWeapon(Player1.GetCurrendRoom().WeaponArr[roomStuffIndex]);
      Player1.GetCurrendRoom().WeaponArr[roomStuffIndex] := nil;
      Player1.GetCurrendRoom().SetItemPickedUp(true);
      PrintAndUIChange(currendSituation, 'You take the Weapon.');
    end;
  11: //Nimmt das Item die im Raum liegt und geht weiter
    begin
      Player1.AddItem(Player1.GetCurrendRoom().ItemArr[roomStuffIndex]);
      Player1.GetCurrendRoom().ItemArr[roomStuffIndex] := nil;
      Player1.GetCurrendRoom().SetItemPickedUp(true);
      PrintAndUIChange(currendSituation, 'You take the Item');
    end;
  12: //Interagiert mit der HeilStatur und heit den Spieler
    begin
      Player1.SetFullHealth();
      PrintAndUIChange(currendSituation, 'You pray to the godess you dont know and ask for her assistance.'+sLineBreak+'You health has been restored.');
      FreeAndNil(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  13: //Öffnet die Chest und gibt dem Spieler das Item in der Truhe
    begin
      Player1.AddItem(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetChestItem());
      PrintAndUIChange(currendSituation, 'You open the chest.'+sLineBreak+'You found '+Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetChestItem().GetName()+'. '+sLineBreak+Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetChestItem().GetDescription());
      FreeAndNil(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
      //Player1.GetCurrendRoom().SetItemPickedUp(true);
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
  16: //Interagiet mit der Leiter
    begin
      PrintAndUIChange(0, 'As you touch the Ladder you feel great power and knowlegde flow throght your body.'+sLineBreak+
                                         'You have learned... how to climb');
      FreeAndNil(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
      Player1.ChangeRoom('zPos');
    end;
  17: //Interagiet mit dem Dealer
    begin
      PrintAndUIChange(0, 'This poor soul offers you a bomb if you can pay him appropriate.');
      for i := 0 to length(Player1.iteminventory)-1 do begin
        if Player1.iteminventory[i].GetIsCoin then begin
           Player1.AddItem(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex].GetDealerItem());
           FreeAndNil(Player1.iteminventory[i]);
           FreeAndNil(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
           end;
      end;
    end;
  53: //Rüstet die im Inventar ausgewählte waffe aus und beendet die Runde des Spielers
    begin
      Player1.SetCurrendWeapon(Player1.weaponInventory[inventoryIndex]);
      PrintAndUIChange(2, 'You equiped '+Player1.weaponInventory[inventoryIndex].GetName()+'.');
      PlayerEndTurn();
    end;
  54: //Benutzt das im Inventar ausgewählte Item und beendet die Runde des Spielers
    begin
      If (Player1.itemInventory[inventoryIndex].UseItem() = false) then PrintAndUIChange(UIState, 'You are not able to use this Item in combat.')
      else begin
        PrintAndUIChange(2, 'You used '+Player1.itemInventory[inventoryIndex].GetName()+'.');
        if Player1.itemInventory[inventoryIndex].GetDmgDuration = 0 then
        begin
          DmgBuff := 1.5;
        end;
        if Player1.itemInventory[inventoryIndex].GetDefDuration = 0 then
          begin
          DefBuff := 0.5;
          end;
        PlayerEndTurn();
      end;
    end;
  55: //Bunutzt den im Inventar ausgewählten Skill, macht dem Gegner Schaden und beendet die Runde des Spielers
    begin
      if (Player1.Skills[inventoryIndex].GetTurnsToWait() = 0) then
      begin
        _dmg := FightingEnemy.DoDamage(
          Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetStrikeMulti()*DmgBuff,
          Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetThrustMulti()*DmgBuff,
          Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetSlashMulti()*DmgBuff,
          Player1.GetCurrendWeapon().GetHighestDmg() * Player1.Skills[inventoryIndex].GetMagicMulti()*DmgBuff);

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
var i: integer; break: boolean;
begin
  case UIState of
  0: //y Positiv im RoomArr
    begin
      if (Player1.GetCurrendRoom.GetPosY+1 <= Room_y) and (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY+1,Player1.GetCurrendRoom.getPosZ] <> nil) and (Player1.GetCurrendRoom.GetBlockedTop = false) and (Player1.GetCurrendRoom.GetDoorTop = false) then
      begin
        OnLeaveRoom();
        Player1.ChangeRoom('yPos');
        PrintRoomData(Player1.GetCurrendRoom());
        OnEnterRoom();
      end else if Player1.GetCurrendRoom.GetDoorTop then
      begin
        for i:=0 to length(Player1.itemInventory)-1 do begin
            if Player1.GetCurrendRoom.GetDoorIndexTop = Player1.itemInventory[i].getKeyIndex then begin
              Player1.GetCurrendRoom.SetDoorTop(false);
              RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY+1,Player1.GetCurrendRoom.getPosZ].SetDoorBottom(false);
              SetButton(Btn3_Image, Btn3_Label, true);
            end;
        end;
      end;
    end;
  1: //Öffnet das Waffen Menü
    begin
      if (Player1.HasWeaponsInInventory() = true) then  ChangeUIState(53) //Weapon Menu
      else PrintAndUIChange(UIState, 'You have no weapons in your arsenal yet.')
    end;
  2: {do nothing};
  3: //Öffnet das Waffen Menü
    begin
      if (Player1.HasWeaponsInInventory() = true) then  ChangeUIState(53) //Weapon Menu
      else PrintAndUIChange(UIState, 'You have no weapons in your arsenal yet.')
    end;
  4: {do nothing};
  10: {directly equip found weapon}
    begin
      Player1.SetCurrendWeapon(Player1.GetCurrendRoom().WeaponArr[roomStuffIndex]);
      Player1.AddWeapon(Player1.GetCurrendRoom().WeaponArr[roomStuffIndex]);
      Player1.GetCurrendRoom().WeaponArr[roomStuffIndex] := nil;
      Player1.GetCurrendRoom().SetItemPickedUp(true);
      PrintAndUIChange(currendSituation, 'You directly equip the Weapon.');
    end;
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
        else PrintAndUIChange(UIState, 'Can not go futher up.') //next is nil
      else PrintAndUIChange(UIState, 'Can not go futher up.'); //out of array (negative)
      PrintWeaponData(Player1.weaponInventory[inventoryIndex]);
    end;
  54: //geht im Item Menü nach oben. kann nil überspringen falls man ein Item eingesetzt hat
    begin
      if (inventoryIndex - 1 >= 0) then
      begin
        break := false;
        i := inventoryIndex;
        while (break = false) and (i > 0) do
        begin
          i := i - 1;
          if (Player1.itemInventory[i] <> nil) then
            break := true;
        end;
        if (break = false) then PrintAndUIChange(UIState, 'Can not go futher up.') //there are no more items this way in the array
        else inventoryIndex := i;
      end else PrintAndUIChange(UIState, 'Can not go futher up.'); //out of array (negative)
      PrintItemData(Player1.itemInventory[inventoryIndex]);
    end;
  55: //geht im Skill Menü nach oben
    begin
      if (inventoryIndex - 1 >= 0) then
        if (Player1.Skills[inventoryIndex - 1] <> nil) then
          inventoryIndex := inventoryIndex - 1
        else PrintAndUIChange(UIState, 'Can not go futher up.') //next is nil
      else PrintAndUIChange(UIState, 'Can not go futher up.'); //out of array (negative)
      PrintSkillData(Player1.Skills[inventoryIndex]);
    end;
  99: {Do Nothing};
  else ShowMessage('This Button has no effect'); //Debug
  end;
end;
procedure TForm1.Button_4_Action(); //                                     --> 4
var i: integer; break: boolean;
begin
  case UIState of
  0: //y Minus im RoomArray
    begin
      if (Player1.GetCurrendRoom.GetPosY-1 >= 0) and (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY-1,Player1.GetCurrendRoom.getPosZ] <> nil) and (Player1.GetCurrendRoom.GetBlockedBottom = false) and (Player1.GetCurrendRoom.GetDoorBottom = false) then begin
        OnLeaveRoom();
        Player1.ChangeRoom('yNeg');
        PrintRoomData(Player1.GetCurrendRoom());
        OnEnterRoom();
      end else if Player1.GetCurrendRoom.GetDoorBottom then
      begin
        for i:=0 to length(Player1.itemInventory)-1 do begin
            if Player1.GetCurrendRoom.GetDoorIndexBottom = Player1.itemInventory[i].getKeyIndex then begin
              Player1.GetCurrendRoom.SetDoorBottom(false);
              RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY-1,Player1.GetCurrendRoom.getPosZ].SetDoorTop(false);
              SetButton(Btn4_Image, Btn4_Label, true);
            end;
        end;
      end;
    end;
  1: //Öffnet das Item Menü
    begin
      if (Player1.HasItemsInInventory() <> -1) then
        ChangeUIState(54) //Item Menu
      else PrintAndUIChange(UIState, 'You have no items in your inventory yet.')
    end;
  2: {do nothing};
  3: //Öffnet das Item Menü
    begin
      if (Player1.HasItemsInInventory() <> -1) then
        ChangeUIState(54) //Item Menu
      else PrintAndUIChange(UIState, 'You have no items in your inventory yet.')
    end;
  4: {do nothing};
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
        else PrintAndUIChange(UIState, 'Can not go futher down.') //next is nil
      else PrintAndUIChange(UIState, 'Can not go futher down.'); //out of Array (positive)
      PrintWeaponData(Player1.weaponInventory[inventoryIndex]);
    end;
  54: //geht im Item Menü nach unten. kann nil überspringen falls man ein Item eingesetzt hat
    begin
      if (inventoryIndex + 1 <= length(Player1.itemInventory) - 1) then
      begin
        break := false;
        i := inventoryIndex;
        while (break = false) and (i < length(Player1.itemInventory) - 1) do
        begin
          i := i + 1;
          if (Player1.itemInventory[i] <> nil) then
            break := true;
        end;
        if (break = false) then PrintAndUIChange(UIState, 'Can not go futher down.') //there are no more items this way in the array
        else inventoryIndex := i;
      end
      else PrintAndUIChange(UIState, 'Can not go futher down.'); //out of array (positive)

      PrintItemData(Player1.itemInventory[inventoryIndex]);
    end;
  55: //geht im Skill Menü nach unten
    begin
      if (inventoryIndex + 1 <= length(Player1.Skills) - 1) then
        if (Player1.Skills[inventoryIndex + 1] <> nil) then
          inventoryIndex := inventoryIndex + 1
        else PrintAndUIChange(UIState, 'Can not go futher down.') //next is nil
      else PrintAndUIChange(UIState, 'Can not go futher down.'); //out of Array (positive)
      PrintSkillData(Player1.Skills[inventoryIndex]);
    end;
  99: {Do Nothing};
  else ShowMessage('This Button has no effect'); //Debug
  end;
end;
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{---------------------------Ändern-der-Situation-------------------------------}

procedure TForm1.PrintAndUIChange(_changeUITo: integer; _toPrint: string); //änderd UIState und zeigt vorher noch eine Nachricht
begin
  Memo1.Clear();
  Memo1.Lines.Add(_toPrint);
  UIStateCopy := _changeUITo;

  ChangeUIState(99);
end;

procedure TForm1.ChangeUIState(_state: integer); //ändert UIState und Updatet dementsprechend die UI
var i: integer;
begin
  UIState := _state;

  //Activate all Buttons at first
  SetButton(Btn1_Image, Btn1_Label, true);
  SetButton(Btn2_Image, Btn2_Label, true);
  SetButton(Btn3_Image, Btn3_Label, true);
  SetButton(Btn4_Image, Btn4_Label, true);

  case UIState of
  0: //das Bewegen in den Räumen
    begin
      if (muted = false) then
      begin
        isplaying := false;
        songlength := 27;
        songpath := 'music\overworldTheme_loop.wav';
        if isplaying = false then
        begin
          PlaySound(songPath,0,SND_ASYNC);
          isplaying := true;
        end;
      end;

      currendSituation := 0;
      Btn1_Label.caption := 'Plus X';
      Btn2_Label.caption := 'Minus X';
      Btn3_Label.caption := 'Plus Y';
      Btn4_Label.caption := 'Minus Y';
      PrintRoomData(Player1.GetCurrendRoom());

      OnEnterRoom(); //whenever you can walk again (after fights and stuff) it checks if there is (still) stuff in the Room
    end;
  1: //Kämpfen mit normalen Gegnern (Runde des Spielers)
    begin
      if (muted = false)  then
      begin
        isplaying := false;
        songlength := 32;
        songpath := 'music\FightinTrackAlternative.wav';
        if isplaying = false then
        begin
          PlaySound(songPath,0,SND_ASYNC);
          isplaying := true;
        end;
      end;

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
  3: //Kampf mit Bossen (Runde des Spielers)
    begin
      if (muted = false) then
      begin
      if FightingBoss.getLevel = 1 then
        begin
        isplaying := false;
        songlength := 31;
        songpath := 'music\textadventure track2.wav';
        end else if FightingBoss.getLevel = 2 then
          begin
        isplaying := false;
        songlength := 36;
        songpath := 'music\BossTrack1.wav';
        end else if FightingBoss.getLevel = 3 then
          begin
        isplaying := false;
        songlength := 31;
        songpath := 'music\Textadventure_Track_3.wav';
        end;
        if isplaying = false then
        begin
          PlaySound(songPath,0,SND_ASYNC);
          isplaying := true;
        end;
      end;
      currendSituation := 3;
      Btn1_Label.caption := 'Skills';
      Btn2_Label.caption := 'Attack';
      Btn3_Label.caption := 'Weapons';
      Btn4_Label.caption := 'Items';

      Memo1.Clear();
      Memo1.Lines.Add('Before you stands the '+FightingBoss.GetAdjective()+' '+FightingBoss.GetName()+'.'+sLineBreak+'What are you going to do?');


      PrintBossData(FightingBoss);
    end;
  4: //Kampf mit Bossen (Runde des Gegners)
    begin
      currendSituation := 4;
      Btn1_Label.caption := '';
      SetButton(Btn1_Image, Btn1_Label, false);
      Btn2_Label.caption := 'Ok';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := '';
      SetButton(Btn3_Image, Btn3_Label, false);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      BossTurn(); //The Enemy deals Damage

      PrintBossData(FightingBoss);
    end;
  10: //Interagiert mit einer Waffe in einem Raum
    begin
      Btn1_Label.caption := 'Leave';
      SetButton(Btn1_Image, Btn1_Label, true);
      Btn2_Label.caption := 'Take';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := 'Equip';
      SetButton(Btn3_Image, Btn3_Label, true);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      Memo1.Clear();
      Memo1.Lines.AddText('You notice a Weapon and inspect it closer.');

      PrintWeaponData(Player1.GetCurrendRoom().WeaponArr[roomStuffIndex]);
    end;
  11: //Interagiert mit einem Item in einem Raum
    begin
      Btn1_Label.caption := 'Leave';
      SetButton(Btn1_Image, Btn1_Label, true);
      Btn2_Label.caption := 'Take';
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
  16: //Interagiert mit einer Skill Statur in einem Raum
    begin
      Btn1_Label.caption := 'Leave';
      SetButton(Btn1_Image, Btn1_Label, true);
      Btn2_Label.caption := 'Climb';
      SetButton(Btn2_Image, Btn2_Label, true);
      Btn3_Label.caption := '';
      SetButton(Btn3_Image, Btn3_Label, false);
      Btn4_Label.caption := '';
      SetButton(Btn4_Image, Btn4_Label, false);

      PrintRoomObjectData(Player1.GetCurrendRoom().RoomObjectArr[roomStuffIndex]);
    end;
  17: //Interagiert mit einem Dealer in einem Raum
    begin
      Btn1_Label.caption := 'Leave';
      SetButton(Btn1_Image, Btn1_Label, true);
      Btn2_Label.caption := 'Buy';
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

      inventoryIndex := Player1.HasItemsInInventory(); //die erste stelle wo ein item ist

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

  //Debug
end;
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{------------------Logic-hinter-bestimmten-Situationen-------------------------}
//wird aufgerufen wenn man einen Raum betritt und wenn man eine aktion im Raum beendet hat (Kämpfen, Interagieren)
procedure TForm1.OnEnterRoom(); //logic situation = 0
var
  i: integer;
begin
  //check nach Gegnern
  if (length(Player1.GetCurrendRoom().EnemyArr) > 0) then
  begin
    for i := 0 to length(Player1.GetCurrendRoom().EnemyArr) - 1 do
      if (Player1.GetCurrendRoom().EnemyArr[i] <> nil) then
      begin  //start Fight
        FightingEnemy := Player1.GetCurrendRoom().EnemyArr[i];
        PrintAndUIChange(1, 'You are now fighting!');
      end;
  end else
  //1. check nach Bossen
  if (Player1.GetCurrendRoom().Boss <> nil) then
  begin  //start BossFight
    FightingBoss := Player1.GetCurrendRoom().Boss;
    PrintAndUIChange(3, 'You are now fighting!');
    if (FightingBoss.SetPhase(1) = false) then ShowMessage(FightingBoss.GetName()+' has no first phase Assinged');
  end else
  //check nach Waffen
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
  //check nach Items
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
  //check nach RoomObjects
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
          if (Player1.GetCurrendRoom().RoomObjectArr[i].GetIsLadder()) then
            PrintAndUIChange(16, 'You notice a Ladder and get closer to it.');
          if (Player1.GetCurrendRoom().RoomObjectArr[i].GetIsDealer()) then
            PrintAndUIChange(17, 'You notice a Dealer in one of the cells and get closer to him.');
        end;
  end;

  //Check nach verfügbaren Räumen und aktiviere die Knöpfe dem entsprechend
  if (UIState = 0) then
  begin
    if (Player1.GetCurrendRoom.GetPosX+1 > Room_x-1) or (RoomArr[Player1.GetCurrendRoom.getPosX+1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] = nil) or (Player1.GetCurrendRoom.GetBlockedRight = true) then
      SetButton(Btn1_Image, Btn1_Label, false, false)
    else if  (Player1.GetCurrendRoom.GetDoorRight = true) then
      SetButton(Btn1_Image, Btn1_Label, true, true)
      else SetButton(Btn1_Image, Btn1_Label, true, false);

    if (Player1.GetCurrendRoom.GetPosX-1 < 0) or (RoomArr[Player1.GetCurrendRoom.getPosX-1,Player1.GetCurrendRoom.getPosY,Player1.GetCurrendRoom.getPosZ] = nil) or (Player1.GetCurrendRoom.GetBlockedLeft = true) then
      SetButton(Btn2_Image, Btn2_Label, false)
    else if (Player1.GetCurrendRoom.GetDoorLeft = true) then
      SetButton(Btn2_Image, Btn2_Label, true, true)
      else SetButton(Btn2_Image, Btn2_Label, true);

    if (Player1.GetCurrendRoom.GetPosY+1 > Room_y-1) or (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY+1,Player1.GetCurrendRoom.getPosZ] = nil) or (Player1.GetCurrendRoom.GetBlockedTop = true) then
      SetButton(Btn3_Image, Btn3_Label, false)
    else if  (Player1.GetCurrendRoom.GetDoorTop = true) then
      SetButton(Btn3_Image, Btn3_Label, true, true)
      else SetButton(Btn3_Image, Btn3_Label, true);

    if (Player1.GetCurrendRoom.GetPosY-1 < 0) or (RoomArr[Player1.GetCurrendRoom.getPosX,Player1.GetCurrendRoom.getPosY-1,Player1.GetCurrendRoom.getPosZ] = nil) or (Player1.GetCurrendRoom.GetBlockedBottom = true) then
      SetButton(Btn4_Image, Btn4_Label, false)
    else if  (Player1.GetCurrendRoom.GetDoorBottom = true) then
      SetButton(Btn4_Image, Btn4_Label, true, true)
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
  for i := 0 to length(Player1.ItemInventory) - 1 do
  begin
  if Player1.itemInventory[i].GetDmgDuration > 0 then
  Player1.itemInventory[i].SetDmgDuration(0);
  if Player1.itemInventory[i].GetDefDuration > 0 then
  Player1.itemInventory[i].SetDefDuration(0);
  end;
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
  DmgBuff := 1;
  DefBuff := 1;

  //setzt die variable visited des raumes auf true
  Player1.getcurrendroom.setvisited(true);
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
    //Der Kampf wurde dadurch beendet, dass die Situation auf von 2 (Runde des Enemy) auf 0 gesetzt wurde

    //Destroy den Enemy Object und setzt alle Variablen die auf ihn zeigen zu nil
    for i := 0 to length(Player1.GetCurrendRoom.EnemyArr)-1 do
    begin
      if (Player1.GetCurrendRoom.EnemyArr[i] = FightingEnemy) then
        FreeAndNil(Player1.GetCurrendRoom().EnemyArr[i]); //FreeAndNil Destroyd ein Object und setz die pointer var (die in den Klammern) auf nil
    end;
    FightingEnemy := nil;  //da der gegner zerstört wurde sollte auch FightingEnemy wieder auf nil

  end
  else //Its already the Enemies turn
  begin
    //verringert den cooldoown von jedem skill
    for i := 0 to length(Player1.Skills) - 1 do begin
      if (Player1.Skills[i] <> nil) then Player1.Skills[i].ReduceTurnsToWait();
    end;
    {if Player1.itemInventory[DmgBuffIndex].GetDmgDuration > 0 then
      Player1.itemInventory[DmgBuffIndex].SetDmgDuration(Player1.itemInventory[DmgBuffIndex].GetDmgDuration-1);
    if Player1.itemInventory[DefBuffIndex].GetDefDuration > 0 then
      Player1.itemInventory[DefBuffIndex].SetDefDuration(Player1.itemInventory[DefBuffIndex].GetDefDuration-1);}
  end;
end;

//wird am ende/in der Runde des Gegners aufgerufen und macht dem Spieler Schaden
procedure TForm1.EnemyTurn(); //logic situation = 2
begin
  Memo1.Clear();

  if (((FightingEnemy.GetHealth() / FightingEnemy.GetMaxHealth()) * 100) <= 50) and (FightingEnemy.GetIsInSecondStance() = false) then
  begin
    FightingEnemy.GoToSecondStance();
    Memo1.Lines.Add(FightingEnemy.GetName()+' changed his stance.'+sLineBreak+'It now has different Resistences.')
  end;

  Player1.ChangeHealthBy(-(FightingEnemy.GetDamage()*DefBuff));
  Memo1.Lines.Add('The Enemy delt ' + FloatToStr(FightingEnemy.GetDamage())+' damage.'+sLineBreak+'You now have ' + FloatToStr(Player1.GetHealth()) + ' health left');
  if (Player1.getHealth > 0) then PlayerDeath();
  end;
end;

procedure TForm1.PlayerEndTurnBoss();
var
  i: integer;
begin
  //check if enemy is defeated
  if (FightingBoss.GetHealth() <= 0) then
  begin
    Memo1.Clear();
    Memo1.Lines.Add('You defeated the Enemy');
    Player1.SetFullHealth(); //Der Spieler wird wieder geheilt
    if (FightingBoss.GetSkillDrop() <> nil) then
    begin
      PLayer1.AddSkill((FightingBoss.GetSkillDrop()));
      PrintAndUIChange(0, 'You defeated you Opponent!'+sLineBreak+
                          'You feel how some of his Powers transfer to you.'+
                          'You Health has been restored and you learned the Skill '+FightingBoss.GetSkillDrop().GetName()+'. '+sLineBreak+
                          FightingBoss.GetSkillDrop().GetDescription());
    end else PrintAndUIChange(0, 'You defeated you Opponent!'+sLineBreak+'You Health has been restored.');
    //Der Kampf wurde dadurch beendet, dass die Situation auf von 4 (Runde des Bosses) auf 0 gesetzt wurde

    //Destroy das Boss Object und setzt alle Variablen die auf ihn zeigen zu nil
    FreeAndNil(Player1.GetCurrendRoom().Boss); //FreeAndNil Destroyd ein Object und setz die pointer var (die in den Klammern) auf nil
    FightingEnemy := nil; //da der gegner zerstört wurde sollte auch FightingEnemy wieder auf nil

  end
  else //Its already the Enemies turn
  begin
    //verringert den cooldoown von jedem skill
    for i := 0 to length(Player1.Skills) - 1 do begin
      if (Player1.Skills[i] <> nil) then Player1.Skills[i].ReduceTurnsToWait();
    end;
  end;
end;
procedure TForm1.BossTurn(); //logic situation = 4
begin
  Memo1.Clear();
  //bei noch zwei drittel Leben
  if (((FightingBoss.GetHealth() / FightingBoss.GetMaxHealth()) * 100) <= 66) and (FightingBoss.GetPhase() = 1) then
  begin
    //für Bosse mit Level 1
    if (FightingBoss.GetLevel() = 1) then
    begin
      if (FightingBoss.GetChangeStateNow() = true) then
      begin
        FightingBoss.SetPhaseLate();
        Memo1.Lines.AddText(FightingBoss.GetName()+' will change his stance.'+sLineBreak+
                            'It will be weak against '+ FightingBoss.GetWeaknessesOfPhase(2)+sLineBreak+
                            'and strong against '+ FightingBoss.GetStrengthsOfPhase(2)+' damage.');
      end else if (FightingBoss.GetChangeStateNow() = false) then
      begin
        FightingBoss.SetPhase(2);
        Memo1.Lines.AddText(FightingBoss.GetName()+' changed his stance.'+sLineBreak+'It now has different Resistences.');
        FightingBoss.SetChangeStateNowToTrue();
      end;
    end else

    //für alle Bosse auf allen leveln außer 1
    if (FightingBoss.SetPhase(2) = true) then //SetPhase wurde soeben gecalled
    begin
      Memo1.Lines.AddText(FightingBoss.GetName()+' changed his stance.'+sLineBreak+'It now has different Resistences.');
    end else ShowMessage(FightingBoss.GetName()+' has no second phase Assinged');

  //Bei noch ein drittel Leben
  end else if (((FightingBoss.GetHealth() / FightingBoss.GetMaxHealth()) * 100) <= 33) and (FightingBoss.GetPhase() = 2) then
  begin
    //für Bosse mit Level 1
    if (FightingBoss.GetLevel() = 1) then
    begin
      if (FightingBoss.GetChangeStateNow() = true) then
      begin
        FightingBoss.SetPhaseLate();
        Memo1.Lines.AddText(FightingBoss.GetName()+' will change his stance.'+sLineBreak+
                                    'It will be weak against '+ FightingBoss.GetWeaknessesOfPhase(3)+sLineBreak+
                                    'and strong against '+ FightingBoss.GetStrengthsOfPhase(3)+' damage.');
      end else if (FightingBoss.GetChangeStateNow() = false) then
      begin
        FightingBoss.SetPhase(3);
        Memo1.Lines.AddText(FightingBoss.GetName()+' changed his stance.'+sLineBreak+'It now has different Resistences.');
        FightingBoss.SetChangeStateNowToTrue();
      end;
    end else

    //für alle Bosse auf allen leveln außer 1
    if (FightingBoss.SetPhase(3) = true) then
    begin
      Memo1.Lines.AddText(FightingBoss.GetName()+' changed his stance.'+sLineBreak+'It now has different Resistences.');
    end else ShowMessage(FightingBoss.GetName()+' has no third phase Assinged');
  end else

  //Macht dem Spieler Schaden
  begin
    Player1.ChangeHealthBy(-(FightingBoss.GetDamage()));

    if (Player1.getHealth > 0) then
    Memo1.Lines.Add('The Boss delt ' + FloatToStr(FightingBoss.GetDamage())+' damage.'+sLineBreak+'You now have ' + FloatToStr(Player1.GetHealth()) + ' health left')
    else begin
      Memo1.Lines.Add('The Boss delt ' + FloatToStr(FightingBoss.GetDamage())+' damage.'+sLineBreak+'You now have 0 health left');
      PlayerDeath();
    end;
  end;
end;

procedure TForm1.PlayerDeath(); //death has no logic
begin
  Form3.Timer1.Enabled := true;
  Form3.AlphaBlendValue := 0;
  Form3.ShowModal();
  //mute music
  MuteBtn_Image.Picture.LoadFromFile('Images/Buttons/MuteBtnOff.png');
  MusicTimer.Enabled := false;
  MusicCounter := 0;
  PlaySound('music/mute.wav', 0, SND_ASYNC);
  muted := true;
end;

{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{-------------Das-Schreiben-von-Infos-zur-jeweiligen-Situation-----------------}
procedure TForm1.PrintPlayerData(_player: TPlayer); //print situation all
begin
  Memo_Stats.Clear();
  Memo_Stats.Lines.AddText('Health: '+sLineBreak+
                           FloatToStr(_player.GetHealth())+'/'+FloatToStr(_player.GetMaxHealth())+sLineBreak+
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
var _directionImagePath: string;
begin
  Memo1.Clear();
  Memo1.Lines.Add(_room.GetDescription());
  Image1.Picture.LoadFromFile(_room.GetImagePath());
  Memo_Description.Clear();

  _directionImagePath := _room.GetImagePath();
  _directionImagePath := StringReplace(_directionImagePath, 'Rooms_lvl1', 'Directions_Level1', [rfReplaceAll]);
  _directionImagePath := StringReplace(_directionImagePath, 'Rooms_lvl2', 'Directions_Level2', [rfReplaceAll]);
  _directionImagePath := StringReplace(_directionImagePath, 'Rooms_lvl3', 'Directions_Level3', [rfReplaceAll]);
  _directionImagePath := StringReplace(_directionImagePath, '.png', '_XYZ.png', [rfReplaceAll]);

  Direction_Image.Picture.LoadFromFile(_directionImagePath);
end;

procedure TForm1.PrintEnemyData(_enemy: TEnemy); //print situation 1 and 2
begin
  Memo_Description.Clear();
  Memo_Description.Lines.AddText(_enemy.GetName()+sLineBreak+
                                 sLineBreak+
                                 'Health: '+sLineBreak+
                                 FloatToStr(Round(_enemy.GetHealth()))+'/'+FloatToStr(Round(_enemy.GetMaxHealth()))+sLineBreak
                                 +sLineBreak);
  if (_enemy.GetStrikeResist() < 1) then Memo_Description.Lines.Add('Strong against strike damage.')
  else if (_enemy.GetStrikeResist() > 1) then Memo_Description.Lines.Add('Weak against strike damage.');
  if (_enemy.GetThrustResist() < 1) then Memo_Description.Lines.Add('Strong against thrust damage.')
  else if (_enemy.GetThrustResist() > 1) then Memo_Description.Lines.Add('Weak against thrust damage.');
  if (_enemy.GetSlashResist() < 1) then Memo_Description.Lines.Add('Strong against slash damage.')
  else if (_enemy.GetSlashResist() > 1) then Memo_Description.Lines.Add('Weak against slash damage.');
  Image1.Picture.LoadFromFile(_enemy.GetImagePath());
end;

procedure TForm1.PrintBossData(_boss: TBoss); //print situation 3 and 4
begin
  Memo_Description.Clear();
  Memo_Description.Lines.Add(_boss.GetName()+sLineBreak+
                                 sLineBreak+
                                 'Health: '+sLineBreak+
                                 FloatToStr(_boss.GetHealth())+'/'+FloatToStr(_boss.GetMaxHealth())+sLineBreak
                                 +sLineBreak);
  if (_boss.GetStrikeResist() < 1) then Memo_Description.Lines.Add('Strong against strike damage.')
  else if (_boss.GetStrikeResist() > 1) then Memo_Description.Lines.Add('Weak against strike damage.');
  if (_boss.GetThrustResist() < 1) then Memo_Description.Lines.Add('Strong against thrust damage.')
  else if (_boss.GetThrustResist() > 1) then Memo_Description.Lines.Add('Weak against thrust damage.');
  if (_boss.GetSlashResist() < 1) then Memo_Description.Lines.Add('Strong against slash damage.')
  else if (_boss.GetSlashResist() > 1) then Memo_Description.Lines.Add('Weak against slash damage.');
  Image1.Picture.LoadFromFile(_boss.GetImagePath());
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
    //3 0 0
    CreateARoom('Your in a cell.'+sLineBreak+'But the Door is so old and rusted you can easily pass through a hole in the door.', 'Images/Rooms_lvl1/Cell1.png', 3, 0, 0);

    //4 0 0
    CreateARoom('There are more than just your cell down here but they don''t seem to be used anymore.', 'Images/Rooms_lvl1/RoomAfterStartCell.png', 4, 0, 0);

    //5 0 0
    CreateARoom('This cells door rusted away long time ago but the remains still can be usefull.', 'Images/Rooms_lvl1/Cell2.png', 5, 0, 0);
    RoomArr[5, 0, 0].AddWeapon(TWeapon.Create('Iron Bar', 'A brocken piece of a former cell.'+sLineBreak+'It is a bit rosty but can still function as a simple weapon.', 'Images/Items/IronBar.png', 15, 0, 0, 0));

    //4 1 0
    CreateARoom('There are even more cells here but they are also empty.', 'Images/Rooms_lvl1/MiddleCorridorClosedCells.png', 4, 1, 0);
    RoomArr[4, 1, 0].AddEnemy(TEnemy.Create('Rat', 20, 5, 'Images/Enemies_lvl1/Rat.png'));
    RoomArr[4, 1, 0].EnemyArr[0].SetResistances(0.5, 1.2, 1);

    //4 2 0
    CreateARoom('You can see a goblin in the room in front of you, he wears light armor but it has some unprotected spots.', 'Images/Rooms_lvl1/MiddleCorridorCross.png', 4, 2, 0);
    RoomArr[4, 2, 0].SetDescriptionVisited('There are four ways from here.');

    //3 2 0
    CreateARoom('There is nothing here of importance but there is stuff lying on the ground in the next room.', 'Images/Rooms_lvl1/RoomBeforeDagger.png', 3, 2, 0);

    //2 2 0
    CreateARoom('Here they stopped mining deeper.'+sLineBreak+'You wonder why...', 'Images/Rooms_lvl1/RoomWithDagger.png', 2, 2, 0);
    RoomArr[2,2,0].AddWeapon(TWeapon.Create('Dagger', 'A small Dagger which lacks power and reach, but can deal quick consecutive hits to unprotected spots due to their light weight', 'Images/Items/Dagger.png', 0, 8, 0, 0));

    //4 3 0
    CreateARoom('Before you is a wodden barack with a door build in it'+sLineBreak+'With a fitting key maybe you could open this door', 'Images/Rooms_lvl1/RoomWithGoblin.png', 4, 3, 0);
    RoomArr[4,3,0].SetDoorTop(true);
    RoomArr[4,3,0].SetDoorIndexTop(0);
    RoomArr[4, 3, 0].AddEnemy(TEnemy.Create('Goblin', 30, 10, 'Images/Enemies_lvl1/Goblin.png'));
    RoomArr[4, 3, 0].EnemyArr[0].SetResistances(0.7,1.3,1);
    RoomArr[4, 3, 0].EnemyArr[0].SetWeaponDrop(TWeapon.Create('A fancy Sword', 'With this Sword you can slash through hords of enemies.', 'Images/Items/Sword.png', 0, 0, 18, 0));

    //5 2 0
    CreateARoom('You can probably fit through that hole in the wall but you can hear the scraping of claws from the other side.', 'Images/Rooms_lvl1/RoomBeforeRats.png', 5, 2, 0);

    //6 2 0
    CreateARoom('There is a mysterious aura coming from your right.', 'Images/Rooms_lvl1/RoomWithRats.png', 6, 2, 0);
    RoomArr[6, 2, 0].AddEnemy(TEnemy.Create('Rat', 20, 5, 'Images/Enemies_lvl1/ThreeRats3.png'));
    RoomArr[6, 2, 0].EnemyArr[0].SetResistances(1, 0.8, 1.2);
    RoomArr[6, 2, 0].AddEnemy(TEnemy.Create('Rat', 20, 5, 'Images/Enemies_lvl1/ThreeRats2.png'));
    RoomArr[6, 2, 0].EnemyArr[1].SetResistances(1, 0.8, 1.2);
    RoomArr[6, 2, 0].AddEnemy(TEnemy.Create('Rat', 20, 5, 'Images/Enemies_lvl1/ThreeRats1.png'));
    RoomArr[6, 2, 0].EnemyArr[2].SetResistances(1, 0.8, 1.2);

    //7 2 0
    CreateARoom('You feel peaceful and safe in this room', 'Images/Rooms_lvl1/RoomWithHealStature.png', 7, 2, 0);
    RoomArr[7, 2, 0].AddRoomObject(TRoomObject.Create('A stature of an unknown Goddess', 'You have never seen this goddess before but she may still help you.', 'Images/RoomObjects/StatureOfAnUnknownGod.png'));
    RoomArr[7, 2, 0].RoomObjectArr[0].SetHealing();

    //6 3 0
    CreateARoom('There are marks written on the wall but you have never seen that language before.'+sLineBreak+'And why is there blood on the wall.', 'Images/Rooms_lvl1/RoomAfterRatsAndBeforeGoblin.png', 6, 3, 0);

    //6 4 0
    CreateARoom('The path takes a turn here.', 'Images/Rooms_lvl1/RoomWithGoblinWithKey.png', 6, 4, 0);
    RoomArr[6, 4, 0].AddEnemy(TEnemy.Create('Goblin', 30, 10, 'Images/Enemies_lvl1/GoblinWithKey.png'));
    RoomArr[6, 4, 0].EnemyArr[0].SetResistances(0.7, 1.3, 1);
    RoomArr[6, 4, 0].EnemyArr[0].SetItemDrop(TItem.Create('Old key', 'This key probably belongs to a door in this cave.', 'Images/Items/Key1.png', 0));

    //5 4 0
    CreateARoom('You can see a candle in the room on the end of this corridor.', 'Images/Rooms_lvl1/RoomAfterGoblinWithKey.png', 5, 4, 0);
    RoomArr[5, 4, 0].SetDescriptionVisited('This corridor connects the stature with the way to the next level.');

    //4 4 0
    CreateARoom('You can hear the footsteps of something bigger than a rat or goblin in the room ahead.'+sLineBreak+'Be aware of what might comes.' ,'Images/Rooms_lvl1/RoomBeforeBoss.png', 4, 4, 0);
    RoomArr[4, 4, 0].SetDescriptionVisited('This room is the beginning of the corridor which leads to the cells.');
    RoomArr[4, 4, 0].SetDoorBottom(true);
    RoomArr[4, 4, 0].SetDoorIndexBottom(0);

    //3 4 0
    CreateARoom('This looks like a working place'+sLineBreak+'Who would work at a place like this?', 'Images/Rooms_lvl1/RoomWithHealItem.png', 3, 4, 0);
    RoomArr[3,4,0].AddItem(TItem.Create('Healpotion', 'This elixir restores part of your health.', 'Images/Items/HealingItem.png'));

    // 4 5 0
    CreateARoom('There is a ladder in this room.'+sLineBreak+'It this the way out?', 'Images/Rooms_lvl1/BossRoom.png', 4, 5, 0);
    RoomArr[4, 5, 0].AddBoss(TBoss.create('Wererat', 'muscular', 'Images/Enemies_lvl1/RatKing.png',1, 120, 30));
    RoomArr[4, 5, 0].Boss.SetStance1(1, 1, 1);
    RoomArr[4, 5, 0].Boss.SetStance2(1, 1, 1);
    RoomArr[4, 5, 0].Boss.SetStance3(1, 1, 1);

    RoomArr[4, 5, 0].Boss.SetSkillDrop(TSkill.Create('Strike Skill', 'This skill throws pure force at your enemies.', 'Images/Skills/SkillStrike.png', 3, 1.5, 0, 0, 0));
    RoomArr[4, 5, 0].AddRoomObject(TRoomObject.Create('Ladder','The height of this ladder is beyond comprehension.','Images/RoomObjects/Ladder_lvl1.png'));
    RoomArr[4, 5, 0].RoomObjectArr[0].SetLadder();
  end;

  //Ebene 2
  begin

    //2 6 1
    CreateARoom('This looks like it has been corrupted by the guardain which has been standing here.', 'Images/Rooms_lvl2/part2/BossRoomlvl2.png', 2, 6, 1);
    RoomArr[2, 6, 1].AddBoss(TBoss.Create('Artorias', 'corrupted guardian', 'Images/Enemies_lvl2/Astorias.png', 2, 999999, 999999));
    RoomArr[2, 6, 1].Boss.SetStance1(1, 1, 1);
    RoomArr[2, 6, 1].Boss.SetStance2(1, 1, 1);
    RoomArr[2, 6, 1].Boss.SetStance3(1, 1, 1);

    //1 5 1
    CreateARoom('You can feel the power of the stature that holds a green skill.', 'Images/Rooms_lvl2/part2/RoomWithThrustSkill.png', 1, 5, 1);
    RoomArr[1,5,1].AddRoomObject(TRoomObject.Create('Skill Stature', 'You suddenly know that if you touch the stature you will gain knowledge of the power sealed inside of it.', 'Images/RoomObjects/ThrustSkillStature.png'));
    RoomArr[1,5,1].RoomObjectArr[0].SetSkillStatue(TSkill.Create('Thrust SKill','You are able to thrust through everything','Images/Skills/SkillThrust.png',3,0,1.5,0,0));

    //2 5 1
    CreateARoom('You feel a dark presence from that room in front of you.', 'Images/Rooms_lvl2/part2/RoomBeforeBosslvl2.png', 2, 5, 1);
    RoomArr[2,5,1].setblockedright(true);

    //3 5 1
    CreateARoom('There seem to be a contraption which makes it possible to go up.', 'Images/Rooms_lvl2/part1/StartRoomWithLadder.png', 3, 5, 1);
    RoomArr[3,5,1].setblockedleft(true);
    RoomArr[3,5,1].setblockedbottom(true);
    RoomArr[3,5,1].AddRoomObject(TRoomObject.Create('A Staircase', 'This Staircase seems to lead out of these catacombs', 'Images/RoomObjects/Ladder_lvl1.png'));

    //4 5 1
    CreateARoom('Your still in a cave but you can feel that you are closer to the surface.', 'Images/Rooms_lvl2/part1/StartRoomWithLadder.png', 4, 5, 1);

    //2 4 1
    CreateARoom('This area looks compleatly different from what you what you experienced before.'+sLineBreak+'You wonder what lies ahead of you.', 'Images/Rooms_lvl2/part2/FirstRoomPart2.png', 2, 4, 1);
    RoomArr[2,4,1].setdoorright(true);
    RoomArr[2,4,1].setdoorindexright(3);
    RoomArr[2,4,1].AddEnemy(TEnemy.Create('Guardian',75, 20,'Images/Enemies_lvl2/WardenPart2.png'));
    RoomArr[2,4,1].EnemyArr[0].SetResistances(1.5,0.8,0.8);

    //3 4 1
    CreateARoom('The white door seems to lead to another area.'+sLineBreak+'This could be a way out.', 'Images/Rooms_lvl2/part1/RoomWithDoorToSecondPart.png', 3, 4, 1);
    RoomArr[3,4,1].setdoorleft(true);
    RoomArr[3,4,1].setdoorindexleft(3);
    RoomArr[3,4,1].setdoorbottom(true);
    RoomArr[3,4,1].setdoorindexbottom(2);
    RoomArr[3,4,1].setblockedtop(true);

    //4 4 1
    CreateARoom('There are two way from here on the left you see even more skelletons and on the right are two door whch are probably locked.', 'Images/Rooms_lvl2/part1/RoomAfterStart.png', 4, 4, 1);
    RoomArr[4,4,1].SetDescriptionVisited('There are two ways from here.');
    RoomArr[4,4,1].setblockedbottom(true);
    RoomArr[4,4,1].AddEnemy(TEnemy.Create('Skelleton',40, 16,'Images/Enemies_lvl2/FirstSkelleton.png'));
    RoomArr[4,4,1].EnemyArr[0].SetResistances(1.5,0.8,0.8);

    //5 4 1
    CreateARoom('You can see a chest at the end of this corridor.', 'Images/Rooms_lvl2/part1/RoomWithTwoSkelletons.png', 5, 4, 1);
    RoomArr[5,4,1].setblockedbottom(true);
    RoomArr[5,4,1].AddEnemy(TEnemy.Create('Skelleton',40, 16,'Images/Enemies_lvl2/TwoSkelletons2.png'));
    RoomArr[5,4,1].EnemyArr[0].SetResistances(1.5,0.8,0.8);
    RoomArr[5,4,1].AddEnemy(TEnemy.Create('Skelleton',40, 16,'Images/Enemies_lvl2/TwoSkelletons1.png'));
    RoomArr[5,4,1].EnemyArr[1].SetResistances(1.5,0.8,0.8);

    //6 4 1
    CreateARoom('There is a chest lying around.'+'You wonder why noone has opened this chest yet.', 'Images/Rooms_lvl2/part1/RoomWithChest.png', 6, 4, 1);
    RoomArr[6,4,1].AddRoomObject(TRoomObject.create('Chest','made out of wood','Images/RoomObjects/ChestWithCoin.png'));
    RoomArr[6,4,1].RoomObjectArr[0].SetChest(TItem.create('Coin','You can buy thing with it i guess...', 'Images/Items/Coin.png'));
    RoomArr[6,4,1].RoomObjectArr[0].GetChestItem.SetIsCoin(true);

    //1 3 1
    CreateARoom('You can feel tranquility flow through this room. ', 'Images/Rooms_lvl2/part2/RoomWithHealingStaturePart2.png', 1, 3, 1);
    RoomArr[1,3,1].AddRoomObject(TRoomObject.create('Statue of an unknown Goddess', 'Maybe i should pray.', 'Images/RoomObjects/HealingStatureLevel2.png'));
    RoomArr[1,3,1].RoomObjectArr[0].SetHealing();

    //2 3 1
    CreateARoom('You can feel a aura coming from the next room.'+'It seems like this room leads to a important place.', 'Images/Rooms_lvl2/part2/RoomWithMimic.png', 2, 3, 1);
    RoomArr[2,3,1].setblockedright(true);
    RoomArr[2,3,1].AddRoomObject(TRoomObject.Create('Another Chest','Also made out of wood.','Images/RoomObjects/ChestMimic.png'));
    RoomArr[2,3,1].RoomObjectArr[0].SetMimic(TItem.Create('Defense Up', 'This makes your skin harder than steel so you receive less damage', 'Images/Items/DefUp.png'),TEnemy.create('Mimic',80, 15, 'Images/Enemies_lvl2/Mimic.png'));
    RoomArr[2,3,1].RoomObjectArr[0].GetChestItem().SetDefenseUp(1.5);

    //3 3 1
    CreateARoom('There are cells to the left, maybe I can find a friendly soul there.', 'Images/Rooms_lvl2/part1/RoomWithTwoDoors2.png', 3, 3, 1);
    RoomArr[3,3,1].setblockedleft(true);
    RoomArr[3,3,1].setdoortop(true);
    RoomArr[3,3,1].setdoorindextop(2);
    RoomArr[3,3,1].setdoorright(true);
    RoomArr[3,3,1].setdoorindexright(2);

    //4 3 1
    CreateARoom('The wall to the left does not look very solid...'+sLineBreak+'With enough force I could break through it', 'Images/Rooms_lvl2/part1/RoomNearSecretRoom.png', 4, 3, 1);
    RoomArr[4,3,1].setdoorleft(true);
    RoomArr[4,3,1].setdoorindexleft(2);
    RoomArr[4,3,1].setdoorbottom(true);
    RoomArr[4,3,1].setdoorindexbottom(99);//bomb
    RoomArr[4,3,1].setblockedtop(true);

    //5 3 1
    CreateARoom('This corridor leads to a door behind which is a crossroad.', 'Images/Rooms_lvl2/part1/RoomWithWarderWithKey2.png', 5, 3, 1);
    RoomArr[5,3,1].AddEnemy(TEnemy.Create('Guardian',75, 20,'Images/Enemies_lvl2/WardenWithKey.png'));
    RoomArr[5,3,1].EnemyArr[0].SetResistances(1.5,0.8,0.8);
    RoomArr[5,3,1].EnemyArr[0].SetItemDrop(TItem.create('Bone key', 'Never seen a key made out of bones?', 'Images/Items/Key1.png', 2));
    RoomArr[5,3,1].setblockedtop(true);
    RoomArr[5,3,1].setblockedbottom(true);

    //6 3 1
    CreateARoom('This room is filled with the power htat the sature emits.', 'Images/Rooms_lvl2/part1/RoomWithSlashSkill.png', 6, 3, 1);
    RoomArr[6,3,1].AddRoomObject(TRoomObject.Create('Skill Stature', 'It looks skillfull (pun intended)', 'Images/RoomObjects/SlashSkillStature.png'));
    RoomArr[6,3,1].RoomObjectArr[0].SetSkillStatue(TSkill.Create('Thrust Skill', 'You skill fires power like a speer to pirce your enemies.','Images/Skills/SkillThrust.png',3,0,0,1.5,0));

    //3 2 1
    CreateARoom('This is just another corridor in the same big cave.', 'Images/Rooms_lvl2/part1/RoomWithSkelletonToDealer.png', 3, 2, 1);
    RoomArr[3,2,1].setblockedright(true);
    RoomArr[3,2,1].AddEnemy(TEnemy.Create('Skelleton',40, 16,'Images/Enemies_lvl2/SkelletonNearDealer.png'));
    RoomArr[3,2,1].EnemyArr[0].SetResistances(1.5,0.8,0.8);

    //4 2 1
    CreateARoom('This room was hidden behind a wall.'+sLineBreak+'I wonder who did that.', 'Images/Rooms_lvl2/part1/SecretRoom.png', 4, 2, 1);
    RoomArr[4,2,1].setblockedleft(true);
    RoomArr[4,2,1].AddRoomObject(TRoomObject.create('Chest','Made out of wood.','Images/RoomObjects/ChestSecretRoom.png'));
    RoomArr[4,2,1].RoomObjectArr[0].SetChest(TItem.create('Damage Up', 'It strengthens your muscles beyon humen bounds.','Images/Items/DmgUp.png'));
    RoomArr[4,2,1].RoomObjectArr[0].GetChestItem().SetDamageUp(1.5);

    //3 1 1
    CreateARoom('There is still someone in this cell.', 'Images/Rooms_lvl2/part1/RoomWithWardenAndDealer.png', 3, 1, 1);
    RoomArr[3,1,1].AddRoomObject(TRoomObject.create('undead prisoner', 'even if he is in a cell he could help you', 'Images/RoomObjects/Dealer.png'));
    RoomArr[3,1,1].RoomObjectArr[0].SetDealer(TItem.create('Bomb', 'At close range it influences everything with enough Newton force to breake a wall', 'Images/Items/Bomb.png'));

    RoomArr[3,1,1].AddEnemy(TEnemy.Create('Guardian',75, 20,'Images/Enemies_lvl2/WardenNearDealer.png'));
    RoomArr[3,1,1].EnemyArr[0].SetResistances(1.5,0.8,0.8);
    RoomArr[3,1,1].EnemyArr[0].SetItemDrop(TItem.create('Clean looking Key', 'This key looks way better than the other two.', 'Images/Items/Key1.png', 3));
     end;

  //Ebene 3
  begin
    //3 5 2
    CreateARoom('You are now on the surface.'+sLineBreak+'Now you only need a way out of this building.', 'Images/Rooms_lvl3/StartRoomLevel3.png', 3, 5, 2);
    RoomArr[3,5,2].setblockedbottom(true);

    //3 5 2
    CreateARoom('This room connects the stairs with the main corrindor.', 'Images/Rooms_lvl3/RoomWithGuardianWithHeavySword.png', 4, 5, 2);
    RoomArr[3, 5, 2].AddEnemy(TEnemy.Create('Guardian', 20, 5, 'Images/Enemies_lvl3/Guardian.png'));
    RoomArr[3, 5, 2].EnemyArr[0].SetResistances(1, 1, 1);
    RoomArr[3, 5, 2].EnemyArr[0].SetWeaponDrop(TWeapon.create('Heavy Sword', 'It''s quite impressive that the guardians are able to wield this sword with just one hand.', 'Images/Items/HeavySword.png', 15,0,0,0));

    //0 4 2
    CreateARoom('You can still feel the power of the Spirtualist in this room.', 'Images/Rooms_lvl3/BossRoomLevel3.png', 0, 4, 2);
    RoomArr[0, 4, 2].AddBoss(TBoss.create('Spiritualist', 'ascended', 'Images/Enemies_lvl3/Spiritualist.png',3, 120, 30));
    RoomArr[0, 4, 2].Boss.SetStance1(1, 1, 1);
    RoomArr[0, 4, 2].Boss.SetStance2(1, 1, 1);
    RoomArr[0, 4, 2].Boss.SetStance3(1, 1, 1);

    //1 4 2
    CreateARoom('This whole corridor lead to this room.'+sLineBreak+'You feel a incedible presence of power behind this door', 'Images/Rooms_lvl3/RoomBeforeBoss.png', 1, 4, 2);
    RoomArr[1, 4, 2].AddEnemy(TEnemy.Create('Prediger', 20, 5, 'Images/Enemies_lvl3/PreacherBeforeBoss.png'));
    RoomArr[1, 4, 2].EnemyArr[0].SetResistances(1, 1, 1);

    //2 4 2
    CreateARoom('You continue the corridor. It looks like it''s leading to somewhere important.', 'Images/Rooms_lvl3/RoomWithTwoPreachersToBoss.png', 2, 4, 2);
    RoomArr[2, 4, 2].AddEnemy(TEnemy.Create('Prediger', 20, 5, 'Images/Enemies_lvl3/TwoPreachersTwoBoss1.png'));
    RoomArr[2, 4, 2].EnemyArr[0].SetResistances(1, 1, 1);
    RoomArr[2, 4, 2].AddEnemy(TEnemy.Create('Prediger', 20, 5, 'Images/Enemies_lvl3/TwoPreachersTwoBoss2.png'));
    RoomArr[2, 4, 2].EnemyArr[0].SetResistances(1, 1, 1);

    //3 4 2
    CreateARoom('I should be prepared if I want to continue forward.'+sLineBreak+'On the left side seems to be a storage of some kind maybe I can get a better weapon there.', 'Images/Rooms_lvl3/RoomWithPreacherWithKatana.png', 3, 4, 2);
    RoomArr[3, 4, 2].setblockedtop(true);
    RoomArr[3, 4, 2].AddEnemy(TEnemy.Create('Preacher', 20, 5, 'Images/Enemies_lvl3/PreacherWithKatana.png'));
    RoomArr[3, 4, 2].EnemyArr[0].SetResistances(1, 1, 1);
    RoomArr[3, 4, 2].EnemyArr[0].SetWeaponDrop(TWeapon.create('Katana', 'A blade thinner than paper and able to slash through Diamonds.', 'Images/Items/Katana.png',0,0,25,0));

    //4 4 2
    CreateARoom('You enter a corridor which goes through the whole building.'+sLineBreak+'The left leads to a big door.'+sLineBreak+'Maybe a way out?', 'Images/Rooms_lvl3/CrossRoom.png', 4, 4, 2);

    //5 4 2
    CreateARoom('In the room on the side are two preachers.'+sLineBreak+'It may be dangerous to go there but they look like the are guarding something.', 'Images/Rooms_lvl3/CrossRoomBeforeMagicWeapon.png', 5, 4, 2);
    RoomArr[5,4,2].SetDescriptionVisited('This sideway could be worth to take a look at.');
    RoomArr[5,4,2].setblockedtop(true);

    //6 4 2
    CreateARoom('There is an enormous in front of you.', 'Images/Rooms/Höle.png', 6, 4, 2);
    RoomArr[6, 4, 2].AddEnemy(TEnemy.Create('Preacher', 20, 5, 'Images/Enemies_lvl3/PreacherBeforeExit.png'));
    RoomArr[6, 4, 2].EnemyArr[0].SetResistances(1, 1, 1);

    //1 3 2
    CreateARoom('You feel determined and ready for whatever comes.', 'Images/Rooms_lvl3/RoomWithHealingStatureBeforeBoss.png', 1, 3, 2);
    RoomArr[1,3,2].AddRoomObject(TRoomObject.create('Statue of an unknown Goddes', 'This stature somehow feels like it want''s you to pray.', 'Images/RoomObjects/HealingStatureLevel2.png'));
    RoomArr[1,3,2].RoomObjectArr[0].SetHealing();

    //3 3 2
    CreateARoom('There is a guardian up ahead.'+sLineBreak+'Behind him is a storage.', 'Images/Rooms_lvl3/RoomToGuardianBeforeStorage.png', 3, 3, 2);
    RoomArr[3,3,2].SetDescriptionVisited('There is a storage up ahead.');

    //5 3 2
    CreateARoom('The next room is important enough that is was guarded by two preachers.', 'Images/Rooms_lvl3/RoomWithTwoPreachersToMagicWeapon.png', 5, 3, 2);
    RoomArr[5, 3, 2].setblockedright(true);
    RoomArr[5, 3, 2].AddEnemy(TEnemy.Create('Prediger', 20, 5, 'Images/Enemies_lvl3/TwoPeachersToMagicWeapon1.png'));
    RoomArr[5, 3, 2].EnemyArr[0].SetResistances(1, 1, 1);
    RoomArr[5, 3, 2].AddEnemy(TEnemy.Create('Prediger', 20, 5, 'Images/Enemies_lvl3/TwoPeachersToMagicWeapon2.png'));
    RoomArr[5, 3, 2].EnemyArr[0].SetResistances(1, 1, 1);

    //6 3 2
    CreateARoom('There is nothing in this room.', 'Images/Rooms_lvl3/RoomBeforeMoonlightRoom.png', 6, 3, 2);
    RoomArr[6,3,2].setblockedleft(true);
    RoomArr[6,3,2].setdoorbottom(true);

    //2 2 2
    CreateARoom('This is an item storage.', 'Images/Rooms_lvl3/StorageWithItemsRoom.png', 2, 2, 2);
    RoomArr[2,2,2].AddRoomObject(TRoomObject.create('Chest', 'Made out of wood.', 'Images/RoomObjects/ChestSecretRoom.png'));
    RoomArr[2,2,2].RoomObjectArr[0].SetChest(TItem.Create('Defense Up', 'This makes your skin harder than steel so you receive less damage', 'Images/Items/DefUp.png'));
    RoomArr[2,2,2].RoomObjectArr[0].GetChestItem().SetDefenseUp(1.5);

    //3 2 2
    CreateARoom('This pathway leads to two different storages.', 'Images/Rooms_lvl3/RoomWithGuardianBeforeStorage.png', 3, 2, 2);
    RoomArr[3, 2, 2].AddEnemy(TEnemy.Create('Guardian', 20, 5, 'Images/Enemies_lvl3/GuardianBeforeStorage.png'));
    RoomArr[3, 2, 2].EnemyArr[0].SetResistances(1, 1, 1);

    //5 2 2
    CreateARoom('The preachers use this room to enchant weapons with magic.', 'Images/Rooms/Höle.png', 5, 2, 2);
    RoomArr[5,2,2].AddWeapon(TWeapon.create('Magic Dagger', 'It''s blade is infused with magic.', 'Images/Items/Dagger.png', 0,5,0,10));
    RoomArr[5,2,2].setblockedright(true);

    //6 2 2
    CreateARoom('This is so dark you can barely see.', 'Images/Rooms_lvl3/RoomWithSwordOfMoonlight.png', 6, 2, 2);
    RoomArr[6,2,2].setblockedleft(true);
    RoomArr[6,2,2].AddWeapon(TWeapon.create('Sword of Moonlight', 'You can feel the great magical power this blade emits.', 'Images/Items/SwordOfMoolight.png', 0,5,0,10));

    //3 1 2
    CreateARoom('This room used to storage weapons.', 'Images/Rooms_lvl3/WeaponStorageRoom.png', 3, 1, 2);
    RoomArr[3,1,2].AddWeapon(TWeapon.create('Spear', 'If you had a shield you can use both to have optimal defense and attack.'+sLineBreak+'Sadly the shields from the guardians are way to heavy for you.', 'Images/Items/Spear.png', 0,20,0,0));
  end;
end;
{------------------------------------------------------------------------------}

end.
