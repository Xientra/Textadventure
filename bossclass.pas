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
    function GetHealth(): real;
    function GetDamage(): real;

    //Get/Set Stuff
    procedure SetSkillDrop(_skill: TSkill);
    function GetSkillDrop(): TSkill;
    procedure SetRoomObjectToCreate(_roomObject: TRoomObject; _x, _y, _z: integer);
    procedure TriggerRoomObjectCreation();

  private
    name: string;
    ImagePath: string;
    adjective: string;
    level: integer;

    health: real;
    damage: real;

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
  health := _health;
  damage := _damage;
  ImagePath := _imagePath;

  strikeResist := 1;
  thrustResist := 1;
  slashResist := 1;
  hasStance1 := false;
  hasStance2 := false;
  hasStance3 := false;

  SkillDrop := nil;
  RoomObjectToCreate := nil;
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
function TBoss.GetHealth(): real;
begin
  result := health;
end;
function TBoss.GetDamage(): real;
begin
  result := damage;
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
  end;
end;
procedure TBoss.TriggerRoomObjectCreation();
begin
  if (RoomObjectToCreate <> nil) then
  begin
    Unit1.RoomArr[x, y, z].AddRoomObject(RoomObjectToCreate);
  end; //else ShowMessage('SetRoomObjectToCreate has to be called before this can be called.');
end;

end.
