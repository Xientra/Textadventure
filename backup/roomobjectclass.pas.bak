unit RoomObjectClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  EnemyClass{für TEnemy}, ItemClass{für TItem}, SkillClass{für TSkill};

type
  TRoomObject = class
  public
    constructor Create(_name, _description, _imagePath: string);

    //Get Data
    function GetName(): string;
    function GetDescription(): string;
    function GetImagePath(): string;
    //Get/Set Ignore
    function GetIgnore(): boolean;
    procedure SetIgnore(_setTo: boolean);

    //Setzt was das RoomObject ist
    procedure SetHealing();
    procedure SetChest(_item: TItem);
    procedure SetMimic(_item: TItem; _enemy: TEnemy);
    procedure SetSkillStatue(_skill: TSkill);
    procedure SetLadder();
    procedure SetDealer(_item: TItem);

    //Get Effect
    function GetIsUseless(): boolean;
    function GetIsHealing(): boolean;
    function GetIsChest(): boolean;
    function GetIsMimic(): boolean;
    function GetIsSkillStatue(): boolean;
    function GetIsLadder(): boolean;
    function GetIsDealer(): boolean;
    function GetDealerItem: TItem;
    //Get Effect Values
    function GetChestItem(): TItem;
    function GetMimicEnemy(): TEnemy;
    function GetSkillToTeach(): TSkill;

  private
    name: string;
    description: string;
    ImagePath: string;

    IsUseless,
    IsHealing,
    IsChest,
    IsMimic,
    IsSkillStatue,
    IsLadder,
    IsDealer: boolean;

    ChestItem: TItem;
    MimicEnemy: TEnemy;
    SkillToTeach: TSkill;
    DealerItem: TItem;

    Ignore: boolean;
  end;

implementation

constructor TRoomObject.Create(_name, _description, _imagePath: string);
begin
  inherited Create;
  name := _name;
  description := _description;
  ImagePath := _imagePath;

  IsUseless := true;
  IsHealing := false;
  IsChest := false;
  IsMimic := false;
  IsSkillStatue := false;

  Ignore := false;
end;

//Get Data
function TRoomObject.GetName(): string;
begin
  result := name;
end;
function TRoomObject.GetDescription(): string;
begin
  result := description;
end;
function TRoomObject.GetImagePath(): string;
begin
  result := ImagePath;
end;
//Get/Set Ignore
function TRoomObject.GetIgnore(): boolean;
begin
  result := Ignore;
end;
procedure TRoomObject.SetIgnore(_setTo: boolean);
begin
  Ignore := _setTo;
end;

//Setzt was das RoomObject ist
procedure TRoomObject.SetHealing();
begin
  IsUseless := false;
  IsHealing := true;
  IsChest := false;
  IsMimic := false;
  IsSkillStatue := false;
end;
procedure TRoomObject.SetChest(_item: TItem);
begin
  IsUseless := false;
  IsHealing := false;
  IsChest := true;
  IsMimic := false;
  IsSkillStatue := false;

  ChestItem := _item;
end;
procedure TRoomObject.SetMimic(_item: TItem; _enemy: TEnemy);
begin
  IsUseless := false;
  IsHealing := false;
  IsChest := false;
  IsMimic := true;
  IsSkillStatue := false;

  ChestItem := _item;
  MimicEnemy := _enemy;
end;
procedure TRoomObject.SetSkillStatue(_skill: TSkill);
begin
  IsUseless := false;
  IsHealing := false;
  IsChest := false;
  IsMimic := false;
  IsSkillStatue := true;

  SkillToTeach := _skill;
end;
Procedure TRoomObject.SetLadder();
begin
  isLadder := true;
  isUseless := false;
end;
procedure TRoomObject.SetDealer(_item: TItem);
begin
  IsUseless := false;
  IsHealing := false;
  IsChest := false;
  IsMimic := false;
  IsSkillStatue := false;
  IsDealer := true;
  DealerItem := _item;
end;

//Get Effect
function TRoomObject.GetIsUseless(): boolean;
begin
  result := IsUseless;
end;
function TRoomObject.GetIsHealing(): boolean;
begin
  result := IsHealing;
end;
function TRoomObject.GetIsChest(): boolean;
begin
  result := IsChest;
end;
function TRoomObject.GetIsMimic(): boolean;
begin
  result := IsMimic;
end;
function TRoomObject.GetIsSkillStatue(): boolean;
begin
  result := IsSkillStatue;
end;
function TRoomObject.GetIsLadder(): boolean;
begin
  result := IsLadder;
end;
function TRoomObject.GetIsDealer(): boolean;
begin
  result := IsDealer;
end;

//Get Effect Values
function TRoomObject.GetChestItem(): TItem;
begin
  result := ChestItem;
end;
function TRoomObject.GetMimicEnemy(): TEnemy;
begin
  result := MimicEnemy;
end;
function TRoomObject.GetSkillToTeach(): TSkill;
begin
  result := SkillToTeach;
end;
function TRoomObject.GetDealerItem: TItem;
begin
  result := DealerItem;
end;

end.
