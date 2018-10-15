unit BossClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs{für ShowMessage},
  SkillClass{für TSkill}, RoomObjectClass{für TRoomObject};


type
  TBoss = class
  public
    constructor Create(_name, _adjective, _imagePath: string; _level: integer; _health, _damage: real);
    function DoDamage(_strikeDmg, _thrustDmg, _slashDmg: real; _magicDmg: real): real;
    procedure SetStance1(_strikeResist, _thrustResist, _slashResist: real);
    procedure SetStance2(_strikeResist, _thrustResist, _slashResist: real);
    procedure SetStance3(_strikeResist, _thrustResist, _slashResist: real);

    //GetStuff
    function GetName(): string;
    function GetAdjective(): string;
    function GetImagePath(): string;
    function GetLevel(): integer;
    function GetHealth(): real;
    function GetMaxHealth(): real;
    function GetDamage(): real;
    function GetPhase(): integer;
    function SetPhase(_phase: integer): boolean;
    procedure SetPhaseLate();
    procedure SetChangeStateNowToTrue();
    function GetChangeStateNow(): boolean;
    function GetWeaknessesOfPhase(_phase: integer): string;
    function GetStrengthsOfPhase(_phase: integer): string;

    function GetStrikeResist(): real;
    function GetThrustResist(): real;
    function GetSlashResist(): real;

    //Get/Set Stuff
    procedure SetSkillDrop(_skill: TSkill);
    function GetSkillDrop(): TSkill;
    procedure SetRoomObjectToCreate(_roomObject: TRoomObject; _x, _y, _z: integer);
    function GetRoomObjectToCreate(): TRoomObject;
    procedure TriggerRoomObjectCreation();

  private
    name: string;
    ImagePath: string;
    adjective: string;
    level: integer;

    health: real;
    maxHealth: real;
    damage: real;

    phase: integer;

    //Stärken/Schwächen Multiplier der verschiedenen Haltungen
    strikeResist,
    thrustResist,
    slashResist
    : real;
    strikeResistS1,
    thrustResistS1,
    slashResistS1
    : real;
    strikeResistS2,
    thrustResistS2,
    slashResistS2
    : real;
    strikeResistS3,
    thrustResistS3,
    slashResistS3
    : real;

    hasStance1,
    hasStance2,
    hasStance3
    : boolean;
    changeStaceNow: boolean;

    //Sachen die der Boss fallen läst/macht wenn er besiegt wurde
    SkillDrop: TSkill;
    RoomObjectToCreate: TRoomObject;
    x, y, z: integer;
  end;

implementation

uses Unit1;

constructor TBoss.Create(_name, _adjective, _imagePath: string; _level: integer; _health, _damage: real);
begin
  inherited Create;
  name := _name;
  adjective := _adjective;
  level := _level;
  maxHealth := _health;
  health := maxHealth;
  damage := _damage;
  phase := 0;
  ImagePath := _imagePath;

  strikeResist := 1;
  thrustResist := 1;
  slashResist := 1;
  hasStance1 := false;
  hasStance2 := false;
  hasStance3 := false;

  SkillDrop := nil;
  RoomObjectToCreate := nil;

  changeStaceNow  := true;
end;

//Setzt die Resistenzen
procedure TBoss.SetStance1(_strikeResist, _thrustResist, _slashResist: real);
begin
  strikeResistS1 := _strikeResist;
  thrustResistS1 := _thrustResist;
  slashResistS1 := _slashResist;
  hasStance1 := true;
end;
procedure TBoss.SetStance2(_strikeResist, _thrustResist, _slashResist: real);
begin
  strikeResistS2 := _strikeResist;
  thrustResistS2 := _thrustResist;
  slashResistS2 := _slashResist;
  hasStance2 := true;
end;
procedure TBoss.SetStance3(_strikeResist, _thrustResist, _slashResist: real);
begin
  strikeResistS3 := _strikeResist;
  thrustResistS3 := _thrustResist;
  slashResistS3 := _slashResist;
  hasStance3 := true;
end;

//Macht dem gegner Schaden
function TBoss.DoDamage(_strikeDmg, _thrustDmg, _slashDmg: real; _magicDmg: real): real;
var
  tempHealth: real;
begin
  tempHealth := health;
  health := health - (_strikeDmg * strikeResist);
  health := health - (_thrustDmg * thrustResist);
  health := health - (_slashDmg * slashResist);
  health := health - (_magicDmg);
  if (health < 0) then health := 0;
  result := tempHealth - Health;
  //Round(Health);
end;

//Get Stuff
function TBoss.GetName(): string;
begin
  result := name;
end;
function TBoss.GetAdjective(): string;
begin
  result := adjective;;
end;
function TBoss.GetImagePath(): string;
begin
  result := ImagePath;
end;
function TBoss.GetLevel(): integer;
begin
  result := level;
end;
function TBoss.GetHealth(): real;
begin
  result := health;
end;
function TBoss.GetMaxHealth(): real;
begin
  result := maxHealth;
end;
function TBoss.GetDamage(): real;
begin
  result := damage;
end;
function TBoss.GetPhase(): integer;
begin
  result := phase;
end;
function TBoss.SetPhase(_phase: integer): boolean;
begin
  result := false;


  if (phase <= 3) then
  begin
  phase := _phase;
    case phase of
    1:
      begin
        if (hasStance1 = true) then
        begin
          strikeResist := strikeResistS1;
          thrustResist := thrustResistS1;
          slashResist := slashResistS1;
          result := true
        end;
      end;
    2:
      begin
        if (hasStance2 = true) then
        begin
          strikeResist := strikeResistS2;
          thrustResist := thrustResistS2;
          slashResist := slashResistS2;
          result := true;
        end;
      end;
    3:
      begin
        if (hasStance2 = true) then
        begin
          strikeResist := strikeResistS3;
          thrustResist := thrustResistS3;
          slashResist := slashResistS3;
          result := true;
        end;
      end;
    end;
  end else ShowMessage('Bosses only have 3 phases (0 is default resistances)');
end;

procedure TBoss.SetPhaseLate();
begin
  changeStaceNow := false;
end;
function TBoss.GetChangeStateNow(): boolean;
begin
  result := changeStaceNow;
end;
procedure TBoss.SetChangeStateNowToTrue();
begin
  changeStaceNow := true;
end;

function TBoss.GetWeaknessesOfPhase(_phase: integer): string;
var _weaknesses: string;
begin
  _weaknesses := 'nothing';

  case _phase of
  1:
    begin
    if (strikeResistS1 > 1) then _weaknesses := 'strike';
      if (thrustResistS1 > 1) then
      begin
        if (_weaknesses = 'nothing') then
          _weaknesses := 'thrust'
        else begin
          _weaknesses := _weaknesses + ' and ';
          _weaknesses := _weaknesses + 'thrust';
        end;
      end;
      if (slashResistS1 > 1) then
      begin
        if (_weaknesses = 'nothing') then
          _weaknesses := 'slash'
        else begin
          _weaknesses := _weaknesses + ' and ';
          _weaknesses := _weaknesses + 'slash';
        end;
      end;
    end;
  2:
    begin
      if (strikeResistS2 > 1) then _weaknesses := 'strike';
      if (thrustResistS2 > 1) then
      begin
        if (_weaknesses = 'nothing') then
          _weaknesses := 'thrust'
        else begin
          _weaknesses := _weaknesses + ' and ';
          _weaknesses := _weaknesses + 'thrust';
        end;
      end;
      if (slashResistS2 > 1) then
      begin
        if (_weaknesses = 'nothing') then
          _weaknesses := 'slash'
        else begin
          _weaknesses := _weaknesses + ' and ';
          _weaknesses := _weaknesses + 'slash';
        end;
      end;
    end;
  3:
    begin
    if (strikeResistS3 > 1) then _weaknesses := 'strike';
      if (thrustResistS3 > 1) then
      begin
        if (_weaknesses = 'nothing') then
          _weaknesses := 'thrust'
        else begin
          _weaknesses := _weaknesses + ' and ';
          _weaknesses := _weaknesses + 'thrust';
        end;
      end;
      if (slashResistS3 > 1) then
      begin
        if (_weaknesses = 'nothing') then
          _weaknesses := 'slash'
        else begin
          _weaknesses := _weaknesses + ' and ';
          _weaknesses := _weaknesses + 'slash';
        end;
      end;
    end;
  end;
  result := _weaknesses;
end;
function TBoss.GetStrengthsOfPhase(_phase: integer): string;
var _strengths: string;
begin
  _strengths := 'nothing';


  case _phase of
  1:
    begin
    if (strikeResistS1 < 1) then _strengths := 'strike';
      if (thrustResistS1 < 1) then
      begin
        if (_strengths = 'nothing') then
          _strengths := 'thrust'
        else begin
          _strengths := _strengths + ' and ';
          _strengths := _strengths + 'thrust';
        end;
      end;
      if (slashResistS1 < 1) then
      begin
        if (_strengths = 'nothing') then
          _strengths := 'slash'
        else begin
          _strengths := _strengths + ' and ';
          _strengths := _strengths + 'slash';
        end;
      end;
    end;
  2:
    begin
    if (strikeResistS2 < 1) then _strengths := 'strike';
      if (thrustResistS2 < 1) then
      begin
        if (_strengths = 'nothing') then
          _strengths := 'thrust'
        else begin
          _strengths := _strengths + ' and ';
          _strengths := _strengths + 'thrust';
        end;
      end;
      if (slashResistS2 < 1) then
      begin
        if (_strengths = 'nothing') then
          _strengths := 'slash'
        else begin
          _strengths := _strengths + ' and ';
          _strengths := _strengths + 'slash';
        end;
      end;
    end;
  3:
    begin
    if (strikeResistS3 < 1) then _strengths := 'strike';
      if (thrustResistS3 < 1) then
      begin
        if (_strengths = 'nothing') then
          _strengths := 'thrust'
        else begin
          _strengths := _strengths + ' and ';
          _strengths := _strengths + 'thrust';
        end;
      end;
      if (slashResistS3 < 1) then
      begin
        if (_strengths = 'nothing') then
          _strengths := 'slash'
        else begin
          _strengths := _strengths + ' and ';
          _strengths := _strengths + 'slash';
        end;
      end;
    end;
  end;

  result := _strengths;
end;

function TBoss.GetStrikeResist(): real;
begin
  result := strikeResist;
end;
function TBoss.GetThrustResist(): real;
begin
  result := thrustResist;
end;
function TBoss.GetSlashResist(): real;
begin
  result := slashResist;
end;

//Get/Set Skill Drop
procedure TBoss.SetSkillDrop(_skill: TSkill);
begin
  SkillDrop := _skill;
end;
function TBoss.GetSkillDrop(): TSkill;
begin
  result := SkillDrop;
end;

procedure TBoss.SetRoomObjectToCreate(_roomObject: TRoomObject; _x, _y, _z: integer);
begin
  if (_x < Unit1.Room_x)  and (_y < Unit1.Room_y) and (_z < Unit1.Room_z) then
  begin
    if (Unit1.RoomArr[_x, _y, _z] <> nil) then
    begin
      x := _x;
      y := _y;
      z := _z;
      RoomObjectToCreate := _roomObject;
    end else ShowMessage('The Room at the Position '+IntToStr(_x*100+_y*10+_z)+' is nil.');
  end else ShowMessage('The Position '+IntToStr(_x*100+_y*10+_z)+' is out of array.');
end;
function TBoss.GetRoomObjectToCreate(): TRoomObject;
begin
  result := RoomObjectToCreate;
end;

procedure TBoss.TriggerRoomObjectCreation();
begin
  if (RoomObjectToCreate <> nil) then
  begin
    Unit1.RoomArr[x, y, z].AddRoomObject(RoomObjectToCreate);
    ShowMessage('it should be there now');
  end; //else ShowMessage('SetRoomObjectToCreate has to be called before this can be called.');
end;

end.
