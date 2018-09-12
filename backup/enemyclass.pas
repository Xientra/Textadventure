unit EnemyClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
  type
    TEnemy = class
      constructor Create(_health: real);
      private
        health : real;
        damage : real;
    end;

implementation
constructor TEnemy.Create(_health: real);
begin
  health := _health;
end;

end.

