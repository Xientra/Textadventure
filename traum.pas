unit TRaum;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TRoom = class
    private
    description: string;
    visited: boolean;
    public
    function getdescription: string;
    function getvisited: boolean;
    procedure setdescription(d:string);
    procedure setvisited(v:boolean);
  end;

implementation

function TRoom.getdescription: string;
begin
  result := description;
end;

function TRoom.getvisited: boolean;
begin
  result := visited;
end;

procedure TRoom.setdescription(d:string);
begin
  description := d;
end;


procedure TRoom.setvisited(v:boolean);
begin
  visited := v;
end;

end.

