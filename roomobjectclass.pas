unit RoomObjectClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, EnemyClass, ItemClass, SkillClass;

type
  TRoomObject = class
  public
    constructor Create(_name, _description: string);
    procedure SetHealing();
    procedure SetChest(_item: TItem);
    procedure SetMimic(_item: TItem; _enemy: TEnemy);
    procedure SetSkillTeacher(_skill: TSkill);
  private
    name: string;
    description: string;

    IsUseless,
    IsHealing,
    IsChest,
    IsMimic,
    IsSkillTeacher: boolean;

    ChestItem: TItem;
    MimicEnemy: Tenemy;
    SkillToTeach: TSkill;
  end;

implementation

constructor TRoomObject.Create(_name, _description: string);
begin
  name := _name;
  description := _description;
end;

procedure TRoomObject.SetHealing();
begin
  IsUseless := false;
  IsHealing := true;
  IsChest := false;
  IsMimic := false;
  IsSkillTeacher := false;
end;
procedure TRoomObject.SetChest(_item: TItem);
begin
  IsUseless := false;
  IsHealing := false;
  IsChest := true;
  IsMimic := false;
  IsSkillTeacher := false;

  ChestItem := _item;
end;
procedure TRoomObject.SetMimic(_item: TItem; _enemy: TEnemy);
begin
  IsUseless := false;
  IsHealing := false;
  IsChest := false;
  IsMimic := true;
  IsSkillTeacher := false;

  ChestItem := _item;
  MimicEnemy := _enemy;
end;
procedure TRoomObject.SetSkillTeacher(_skill: TSkill);
begin
  IsUseless := false;
  IsHealing := false;
  IsChest := false;
  IsMimic := false;
  IsSkillTeacher := true;

  SkillToTeach := _skill;
end;

end.

