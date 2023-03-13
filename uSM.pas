unit uSM;

interface

uses System.SysUtils, System.Classes, System.Json,
  Datasnap.DSServer, Datasnap.DSAuth, Datasnap.DSProviderDataModuleAdapter,
  REST.Json, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
  FireDAC.Comp.Client, Data.DB, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Datasnap.Provider,
  FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  IdBaseComponent, IdThreadComponent;

type
{$METHODINFO ON}
  TSM = class(TDataModule)
    FDConnPG: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDTransaction1: TFDTransaction;
    FDTPessoa: TFDTable;
    FDTPessoaidpessoa: TLargeintField;
    FDTPessoadsdocumento: TWideStringField;
    FDTPessoanmprimeiro: TWideStringField;
    FDTPessoanmsegundo: TWideStringField;
    FDTPessoadtregistro: TDateField;
    FDTEndereco: TFDTable;
    FDTEndereco_integracao: TFDTable;
    FDTEndereco_integracaoidendereco: TLargeintField;
    FDTEndereco_integracaodsuf: TWideStringField;
    FDTEndereco_integracaonmcidade: TWideStringField;
    FDTEndereco_integracaonmbairro: TWideStringField;
    FDTEndereco_integracaonmlougradouro: TWideStringField;
    FDTEndereco_integracaodscomplemento: TWideStringField;
    FDTEnderecoidendereco: TLargeintField;
    FDTEnderecoidpessoa: TLargeintField;
    FDTEnderecodscep: TWideStringField;
    DataSetProvider1: TDataSetProvider;
    FDMemTable1: TFDMemTable;
    FDQaux: TFDQuery;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDTPessoapflnatureza: TLargeintField;
    FDTEndereco_integracaornumero: TLargeintField;
    FDUpdateSQL1: TFDUpdateSQL;
    IdThreadComponent1: TIdThreadComponent;
  private
    Fbusca_cep: string;
    Fger_id_endereco: Integer;
    Fger_id_pessoa: Integer;
    procedure Setbusca_cep(const Value: string);
    procedure Setger_id_endereco(const Value: Integer);
    procedure Setger_id_pessoa(const Value: Integer);
    { Private declarations }
    property busca_cep: string read Fbusca_cep write Setbusca_cep;
    property ger_id_pessoa: Integer read Fger_id_pessoa write Setger_id_pessoa;
    property ger_id_endereco: Integer read Fger_id_endereco
      write Setger_id_endereco;
    procedure DataModuleCreate(Sender: TObject);
    procedure Lger_new_ids;
    function Loccep(cep: string): TJSONObject;
    function Validacep(cep: string): Boolean;
  public
    { Public declarations Methods }
    function Pessoas: TJSONObject;
    function acceptPessoas(cad: TJSONObject): TJSONValue;
    function cancelPessoas(Aid: Integer): TJSONValue;
    function updatePessoas(TObjJSON: TJSONObject): TJSONValue;
    function acceptListaDados(dados: TJSONObject):TJSONValue;
    function acceptListarpessoas(const all: string): TJSONValue;
    function acceptBuserdata(const allend: Integer): TJSONValue;

  end;

var
  SM_Config: TSM;
  Json: TJSONArray;
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses
  System.StrUtils, Pessoa, Endereco, Endereco_integracao, hCep,
  Cadastro, uModelPessoa;

{ TSM }

// alterar
function TSM.acceptPessoas(cad: TJSONObject): TJSONValue;
var
  vCadastro, gCadastro: TCadastro;
  teste: TJSONValue;
  doc, casta, testcep,erro: string;
  tsJSONObject: TJSONObject;
begin
  vCadastro := TCadastro.Create;
  gCadastro := TCadastro.Create;
  try
    vCadastro := TJson.JsonToObject<TCadastro>(cad.ToJSON);
    vCadastro.id_cad := StrToInt(Trim(cad.Values['idpessoa'].ToString));
    vCadastro.cdscep := cad.Values['cep'].ToString;
    testcep := Trim(cad.Values['cep'].ToString);
    vCadastro.cnmprimeiro := cad.Values['nmprimeiro'].ToString;
    vCadastro.cnmsegundo := cad.Values['nmsegundo'].ToString;
    vCadastro.cdocumento := cad.Values['dsdocumento'].ToString;
    vCadastro.cflnatureza := StrToInt(cad.Values['flnatureza'].ToString);
    doc := Trim(cad.Values['dsdocumento'].ToString);
    { #Criterios
      para Alteração se o documento existe,
      testa os Campos do objeto e atualiza o que esta diferente }
    FDTPessoa.Active := True;
    if FDTPessoa.Locate('dsdocumento', doc.Replace('"', ''), [loPartialKey])
    then
    begin
      FDTPessoa.Edit;
      gCadastro.id_cad := FDTPessoa.FieldByName('idpessoa').AsInteger;
      gCadastro.cnmprimeiro := FDTPessoa.FieldByName('nmprimeiro').AsString;
      gCadastro.cnmsegundo := FDTPessoa.FieldByName('nmsegundo').AsString;
      gCadastro.cdocumento := FDTPessoa.FieldByName('dsdocumento').AsString;

    end;

    // compara e atualiza
    if gCadastro.cnmprimeiro <> vCadastro.cnmprimeiro then
      FDTPessoa.FieldByName('nmprimeiro').AsString :=
        vCadastro.cnmprimeiro.Replace('"', '');

    if gCadastro.cnmsegundo <> vCadastro.cnmsegundo then
      FDTPessoa.FieldByName('nmsegundo').AsString :=
        vCadastro.cnmsegundo.Replace('"', '');

    FDTEndereco.Active := True;
    FDTEndereco_integracao.Active := True;

    if FDTEndereco.Locate('idpessoa', gCadastro.id_cad, [loPartialKey]) then
    begin
      if testcep.Replace('"', '') <> FDTEnderecodscep.AsString then
      begin
        tsJSONObject := Loccep(testcep.Replace('"', ''));
        gCadastro.cdscep := tsJSONObject.GetValue('cep').ToString;
        gCadastro.ccidade := tsJSONObject.GetValue('localidade').ToString;
        gCadastro.cuf := tsJSONObject.GetValue('uf').ToString;
        gCadastro.cbairro := tsJSONObject.GetValue('bairro').ToString;
        gCadastro.clougradouro := tsJSONObject.GetValue('logradouro').ToString;
        gCadastro.ccomplemento := tsJSONObject.GetValue('complemento').ToString;
        gCadastro.cdtregistro := DateToStr(FDTPessoa.FieldByName('dtregistro')
          .AsDateTime);
        gCadastro.cflnatureza := 0;

        FDTEndereco_integracao.Active := True;

        if FDTEndereco_integracao.Locate('idendereco',
          FDTEndereco_integracao.FieldByName('idendereco').AsString,
          [loPartialKey]) then
        begin
          FDTEndereco_integracao.Edit;
          FDTEndereco_integracao.FieldByName('dsuf').AsString :=
            gCadastro.cuf.Replace('"', '');
          FDTEndereco_integracao.FieldByName('nmcidade').AsString :=
            gCadastro.ccidade.Replace('"','');
          FDTEndereco_integracao.FieldByName('nmbairro').AsString :=
            gCadastro.cbairro.Replace('"','');
          FDTEndereco_integracao.FieldByName('nmlougradouro').AsString :=
            gCadastro.clougradouro.Replace('"','');
          FDTEndereco_integracao.FieldByName('dscomplemento').AsString :=
            gCadastro.ccomplemento.Replace('"','');
          FDTEndereco_integracao.FieldByName('rnumero').AsString := '0';

          FDTEndereco.Edit;
          FDTEndereco.FieldByName('dscep').AsString :=
            gCadastro.cdscep.Replace('"', '').Replace('-', '');

          FDTEndereco.Post;
          FDTEndereco_integracao.Post;
        end;
      end;
    end;
    // fim #Criterios

    FDTPessoa.Post;
    FDTPessoa.ApplyUpdates(0);
    FDTEndereco.ApplyUpdates(0);
    FDTEndereco_integracao.ApplyUpdates(0);
    Result := TJson.ObjectToJsonObject(vCadastro);
    vCadastro.Free;
    gCadastro.Free;
  except
    erro:='Registro não gravado!';
    Result :=TJSONString.Create(erro);
   //raise Exception.Create('Erro ao processar Alteração no servidor!.');
  end;

end;

// excluir
function TSM.cancelPessoas(Aid: Integer): TJSONValue;
begin

  // carrega pessoa para deletar
  FDTPessoa.Active := True;
  FDTEndereco.Active := True;
  FDTEndereco_integracao.Active := True;

  FDTPessoa.Locate('idpessoa', Aid.ToString, [loPartialKey]);
  FDTEndereco.Locate('idpessoa', Aid.ToString, [loPartialKey]);
  FDTEndereco_integracao.Locate('idendereco', Aid.ToString, [loPartialKey]);


  FDTEndereco_integracao.Delete;
   FDTEndereco.Delete;
    FDTPessoa.Delete;

  FDTEndereco_integracao.ApplyUpdates(0);
   FDTEndereco.ApplyUpdates(0);
    FDTPessoa.ApplyUpdates(0);


  Result := TJSONString.Create(Aid.ToString)
end;

procedure TSM.DataModuleCreate(Sender: TObject);
begin
  SM_Config.FDConnPG.Connected := False;
  SM_Config.FDConnPG.Params.Values['user_name'] := 'postgres';
  SM_Config.FDConnPG.Params.Values['password'] := '1401';
  Try
    SM_Config.FDConnPG.Connected := True;
  finally
    SM_Config.Free;
  End;
end;

// local cep
function TSM.Loccep(cep: string): TJSONObject;
var
  lJSONObject: TJSONObject;
begin
  Json := Json.loadFromURL('https://viacep.com.br/ws/' + cep + '/json/');
  lJSONObject := Json.Get(0) as TJSONObject;
  Result := lJSONObject;
end;

// Get cadastro
function TSM.acceptBuserdata(const allend: Integer): TJSONValue;
var
  Smt: TMwk_pessoa;
begin
  if allend = 0 then
  begin
    FDTEndereco.Close;
    FDTEndereco.Open;
    FDTEndereco.First;
    Json := Smt.FDTtableToJsonArray(FDTEndereco);
    Result := Json;
  end;
  Result := Json;

end;

function TSM.acceptListarpessoas(const all: string): TJSONValue;
var
  cEndereco_integracao: TEnderecoIntegracao;
  cJSONPair: TJSONPair;
  cJSONarray: TJSONArray;
  Smt: TMwk_pessoa;
begin
  if all = '0' then
  begin
    FDTPessoa.Close;
    FDTPessoa.Open;
    FDTPessoa.First;
    Json := Smt.FDTtableToJsonArray(FDTPessoa);
    Result := Json;
  end;
  // JSON := JSON.loadFromURL('https://viacep.com.br/ws/'+cep+'/json/');
  Result := Json;
end;

// listar
function TSM.Pessoas: TJSONObject;
var
  VPessoa: TPessoa;
  Smt: TMwk_pessoa;
  cJSONarray: TJSONArray;
  msg_E_pessoa: string;
  vobj: TJSONObject;
  i: Integer;
  vJSONPair: TJSONPair;
begin
  VPessoa := TPessoa.Create;
  try
    FDTPessoa.Close;
    FDTPessoa.Open;
    FDTPessoa.First;

    cJSONarray := Smt.FDTtableToJsonArray(FDTPessoa);
    vobj := TJSONObject.Create;
    for i := 0 to Pred(cJSONarray.Count - 1) do
    begin
      VPessoa := TJson.JsonToObject<TPessoa>(cJSONarray.Get(i).ToJSON);
      // vobj.AddPair(VPessoa.ToString)
      // vobj:=TJson.ObjectToJsonObject(vPessoa);
    end;
    // vpessoa:= TJson.JsonToObject<TPessoa>(cJSONarray.Get(1).ToJSON);

    // vJSONPair := bJSONObject.Get(0);
    // cJSONarray := vjsonpair.JsonValue as TJSONArray;
    // vCadastro:= TJson.JsonToObject<TCadastro>(cJSONarray.Get(0).ToJSON);

    // vobj:=TJSONObject.Create;
    // while not FDTPessoa.Eof  do
    // begin
    // for I := 0 to Pred(FDTPessoa.FieldCount) do
    // begin
    // vobj.AddPair(FDTPessoa.Fields[i].FieldName,FDTPessoa.Fields[i].AsString);
    // end;
    // FDTPessoa.Next;
    //
    /// /            VPessoa.idpessoa:=FDTPessoa.FieldByName('idpessoa').AsInteger;
    /// /            VPessoa.nmprimeiro:=FDTPessoa.FieldByName('nmprimeiro').AsString;
    /// /            VPessoa.idpessoa:=FDTPessoa.FieldByName('idpessoa').AsInteger;
    /// /            VPessoa.nmprimeiro:=FDTPessoa.FieldByName('nmprimeiro').AsString;
    /// /            VPessoa.nmsegundo:=FDTPessoa.FieldByName('nmsegundo').AsString;
    /// /            VPessoa.dsdocumento:=FDTPessoa.FieldByName('dsdocumento').AsString;
    /// /            VPessoa.dtregistro:=FDTPessoa.FieldByName('dtregistro').AsDateTime;
    /// /            FDTPessoa.Next;
    // end;

    msg_E_pessoa := VPessoa.ToString;

    Result := TJson.ObjectToJsonObject(VPessoa);
  finally
    VPessoa.Free;
  end;
end;

// insere
function TSM.updatePessoas(TObjJSON: TJSONObject): TJSONValue;
var
  VPessoa: TPessoa;
  iEndereco_integracao: TEnderecoIntegracao;
  iCadastro: TCadastro;
  iJSONarray: TJSONArray;
  iJSONObject: TJSONObject;
  cep: string;
  erro:string;
  teste: string;
begin
  VPessoa := TJson.JsonToObject<TPessoa>(TObjJSON.ToJSON);
  cep := VPessoa.cep;
  iJSONObject := Loccep(cep);
  // teste:=iJSONObject.GetValue('cep').ToString;
  Lger_new_ids;
  try
    Result.Free;
    // carrega pessoa para gravar
    FDTPessoa.Active := True;
    FDTPessoa.Append;
    FDTPessoa.FieldByName('idpessoa').AsInteger := ger_id_pessoa;
    FDTPessoa.FieldByName('pflnatureza').AsInteger := VPessoa.flnatureza;
    FDTPessoa.FieldByName('dsdocumento').AsString := VPessoa.dsdocumento;
    FDTPessoa.FieldByName('nmprimeiro').AsString := VPessoa.nmprimeiro;
    FDTPessoa.FieldByName('nmsegundo').AsString := VPessoa.nmsegundo;
    FDTPessoa.FieldByName('dtregistro').AsDateTime := Now;

    FDTEndereco.Active := True;
    FDTEndereco.Append;
    FDTEndereco.FieldByName('idendereco').AsInteger := ger_id_endereco;
    FDTEndereco.FieldByName('idpessoa').AsInteger := ger_id_pessoa;
    FDTEndereco.FieldByName('dscep').AsString := cep;

    FDTEndereco_integracao.Active := True;
    FDTEndereco_integracao.Append;
    FDTEndereco_integracao.FieldByName('idendereco').AsInteger :=
      ger_id_endereco;
    FDTEndereco_integracao.FieldByName('dsuf').AsString :=
      iJSONObject.GetValue('uf').ToString;
    FDTEndereco_integracao.FieldByName('nmcidade').AsString :=
      iJSONObject.GetValue('localidade').ToString;
    FDTEndereco_integracao.FieldByName('nmbairro').AsString :=
      iJSONObject.GetValue('bairro').ToString;
    FDTEndereco_integracao.FieldByName('nmlougradouro').AsString :=
      iJSONObject.GetValue('logradouro').ToString;
    FDTEndereco_integracao.FieldByName('dscomplemento').AsString :=
      iJSONObject.GetValue('complemento').ToString;

    FDTPessoa.ApplyUpdates(0);
    FDTEndereco.ApplyUpdates(0);
    FDTEndereco_integracao.ApplyUpdates(0);

    // carrega ret rest
    iCadastro := TCadastro.Create;
    try
      iCadastro.id_cad := ger_id_pessoa;
      iCadastro.cnmprimeiro := VPessoa.nmprimeiro;
      iCadastro.cnmsegundo := VPessoa.nmsegundo;
      iCadastro.cdocumento := VPessoa.dsdocumento;
      iCadastro.cflnatureza := VPessoa.flnatureza;
      iCadastro.cdscep := iJSONObject.GetValue('cep').ToString;
      iCadastro.cuf := iJSONObject.GetValue('uf').ToString;
      iCadastro.ccidade := iJSONObject.GetValue('localidade').ToString;
      iCadastro.cbairro := iJSONObject.GetValue('bairro').ToString;
      iCadastro.clougradouro := iJSONObject.GetValue('logradouro').ToString;
      iCadastro.ccomplemento := iJSONObject.GetValue('complemento').ToString;
      Result := TJson.ObjectToJsonObject(iCadastro);
    finally
      iCadastro.Free;
      VPessoa.Free;
    end;

  except
    erro:='Registro não gravado!';
    Result :=TJSONString.Create(erro);
   //raise Exception.Create('Erro ao processar dados no servidor!.');
  end;
end;

function TSM.Validacep(cep: string): Boolean;
begin
  //
end;

procedure TSM.Lger_new_ids;
begin
  FDQaux.Close;
  FDQaux.SQL.Clear;
  FDQaux.SQL.Add('select idendereco, idpessoa, dscep');
  FDQaux.SQL.Add('FROM public.endereco ORDER by idendereco');
  FDQaux.Open;
  FDQaux.Last;
  ger_id_endereco := FDQaux.FieldByName('idendereco').AsInteger + 1;
  ger_id_pessoa := FDQaux.FieldByName('idpessoa').AsInteger + 1;

end;

procedure TSM.Setbusca_cep(const Value: string);
begin
  Fbusca_cep := Value;
end;

procedure TSM.Setger_id_endereco(const Value: Integer);
begin
  Fger_id_endereco := Value;
end;

procedure TSM.Setger_id_pessoa(const Value: Integer);
begin
  Fger_id_pessoa := Value;
end;

//insere lista de dados
function TSM.acceptListaDados(dados: TJSONObject):TJSONValue;
var
  I: Integer;
  linha,erro:string;
  ldados:Tstringlist;
  ins_list_JSONObject: TJSONObject;
  iCadastro: TCadastro;
begin

  try
    linha:=dados.ToJSON.Replace('"','');
    ldados:=TStringList.Create;
    ldados.Delimiter:=';';
    ldados.DelimitedText:=Trim(linha);
    ins_list_JSONObject := Loccep(ldados[0]);
    Lger_new_ids;

   // grava a linha do arquivo realtime com dados do endereço
    FDTPessoa.Active := True;
    FDTPessoa.Append;
    FDTPessoa.FieldByName('idpessoa').AsInteger := ger_id_pessoa;
    FDTPessoa.FieldByName('pflnatureza').AsInteger := StrToInt(ldados[4]);
    FDTPessoa.FieldByName('dsdocumento').AsString := ldados[3];
    FDTPessoa.FieldByName('nmprimeiro').AsString := ldados[1];
    FDTPessoa.FieldByName('nmsegundo').AsString := ldados[2];
    FDTPessoa.FieldByName('dtregistro').AsDateTime := Now;

    FDTEndereco.Active := True;
    FDTEndereco.Append;
    FDTEndereco.FieldByName('idendereco').AsInteger := ger_id_endereco;
    FDTEndereco.FieldByName('idpessoa').AsInteger := ger_id_pessoa;
    FDTEndereco.FieldByName('dscep').AsString := ldados[0];

    FDTEndereco_integracao.Active := True;
    FDTEndereco_integracao.Append;
    FDTEndereco_integracao.FieldByName('idendereco').AsInteger :=
      ger_id_endereco;
    FDTEndereco_integracao.FieldByName('dsuf').AsString :=
      ins_list_JSONObject.GetValue('uf').ToString;
    FDTEndereco_integracao.FieldByName('nmcidade').AsString :=
      ins_list_JSONObject.GetValue('localidade').ToString;
    FDTEndereco_integracao.FieldByName('nmbairro').AsString :=
      ins_list_JSONObject.GetValue('bairro').ToString;
    FDTEndereco_integracao.FieldByName('nmlougradouro').AsString :=
      ins_list_JSONObject.GetValue('logradouro').ToString;
    FDTEndereco_integracao.FieldByName('dscomplemento').AsString :=
      ins_list_JSONObject.GetValue('complemento').ToString;

    FDTPessoa.ApplyUpdates(0);
    FDTEndereco.ApplyUpdates(0);
    FDTEndereco_integracao.ApplyUpdates(0);

    // carrega ret rest
    iCadastro := TCadastro.Create;
    try
      iCadastro.id_cad := ger_id_pessoa;
      iCadastro.cnmprimeiro := ldados[1];
      iCadastro.cnmsegundo := ldados[2];
      iCadastro.cdocumento := ldados[3];
      iCadastro.cflnatureza := StrToInt(ldados[4]);
      iCadastro.cdscep := ins_list_JSONObject.GetValue('cep').ToString;
      iCadastro.cuf := ins_list_JSONObject.GetValue('uf').ToString;
      iCadastro.ccidade := ins_list_JSONObject.GetValue('localidade').ToString;
      iCadastro.cbairro := ins_list_JSONObject.GetValue('bairro').ToString;
      iCadastro.clougradouro := ins_list_JSONObject.GetValue('logradouro').ToString;
      iCadastro.ccomplemento := ins_list_JSONObject.GetValue('complemento').ToString;
      Result := TJson.ObjectToJsonObject(iCadastro);
    finally
      iCadastro.Free;
    end;


     //Result :=TJSONString.Create(ldados[0]);
   except
    erro:='Registro não gravado!';
    Result :=TJSONString.Create(erro);
   //raise Exception.Create('Erro ao processar linha do arquivo no servidor!.');
        end;


end;

end.


