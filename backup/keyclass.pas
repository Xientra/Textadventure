unit KeyClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
  type
    TKey = class
      constructor Create(_KeyIndex:Integer);
      function GetKeyIndex: integer;
      private
        KeyIndex : integer;
    end;

implementation
constructor TKey.Create(_KeyIndex: integer);
begin
  inherited Create;
  KeyIndex := _KeyIndex;
end;
function GetKeyIndex: integer;
begin
     result := KeyIndex;
end;

end.

