unit uModelPessoa;

interface
      uses System.SysUtils, System.Classes, System.Json,
        Datasnap.DSServer, Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter,
        REST.Json, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
      FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
      FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
      FireDAC.Comp.Client, Data.DB, FireDAC.Stan.Param, FireDAC.DatS,
      FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Datasnap.Provider,
      FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC;

type
  TMwk_pessoa = class
   strict protected
    class var FMwk_pessoa:TMwk_pessoa;
    private
     constructor CreatePrivate;
     public
     constructor  Create;
     class function GetInstance: TMwk_pessoa;
     function FDTtableToJsonArray(FDTtable:TFDTable):TJSONArray;

  end;

implementation

{ TMwk_pessoa }

constructor TMwk_pessoa.Create;
begin
 begin
    raise Exception.Create('Problemas com este serviço! >> TMwk_pessoa ');
 end;

end;

constructor TMwk_pessoa.CreatePrivate;
begin
  inherited Create;
end;

function TMwk_pessoa.FDTtableToJsonArray(FDTtable: TFDTable): TJSONArray;
var
  vobj: TJSONObject;
  i:Integer;
begin
  if not  FDTtable.Active  then FDTtable.Open;
     FDTtable.First;
     Result:= TJSONArray.Create;
     while not FDTtable.Eof do
     begin
       vobj:=TJSONObject.Create;
        for I := 0 to Pred(FDTtable.FieldCount) do
           begin
             vobj.AddPair(FDTtable.Fields[i].FieldName,FDTtable.Fields[i].AsString);
           end;

       Result.AddElement(vobj);
       FDTtable.Next;
     end;

end;

class function TMwk_pessoa.GetInstance: TMwk_pessoa;
begin
  if not Assigned(FMwk_pessoa) then
   FMwk_pessoa := TMwk_pessoa.CreatePrivate;
   Result:=fmwk_pessoa;



end;

end.
