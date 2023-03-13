unit Cadastro;

interface

type
TCadastro = class
  private
    Fid_cad: Integer;
    Fccidade: string;
    Fclougradouro: string;
    Fcbairro: string;
    Fcuf: string;
    Fcnmprimeiro: string;
    Fcdtregistro: string;
    Fcnmsegundo: string;
    Fcdocumento: string;
    Fcdscep: string;
    Fccomplemento: string;
    Fcflnatureza: integer;
    procedure Setcbairro(const Value: string);
    procedure Setccidade(const Value: string);
    procedure Setccomplemento(const Value: string);
    procedure Setcdocumento(const Value: string);
    procedure Setcdscep(const Value: string);
    procedure Setcdtregistro(const Value: string);
    procedure Setcflnatureza(const Value: integer);
    procedure Setclougradouro(const Value: string);
    procedure Setcnmprimeiro(const Value: string);
    procedure Setcnmsegundo(const Value: string);
    procedure Setcuf(const Value: string);
    procedure Setid_cad(const Value: Integer);
  published
   property id_cad:Integer read Fid_cad write Setid_cad;
   property cnmprimeiro:string read Fcnmprimeiro write Setcnmprimeiro;
   property cnmsegundo:string read Fcnmsegundo write Setcnmsegundo;
   property cdocumento:string read Fcdocumento write Setcdocumento;
   property cdtregistro :string read Fcdtregistro write Setcdtregistro;
   property cflnatureza:integer read Fcflnatureza write Setcflnatureza;
   property cdscep:string read Fcdscep write Setcdscep;
   property cuf:string read Fcuf write Setcuf;
   property ccidade:string read Fccidade write Setccidade;
   property cbairro:string read Fcbairro write Setcbairro;
   property clougradouro:string read Fclougradouro write Setclougradouro;
   property ccomplemento:string read Fccomplemento write Setccomplemento;



end;

implementation

{ TCadastro }

procedure TCadastro.Setcbairro(const Value: string);
begin
  Fcbairro := Value;
end;

procedure TCadastro.Setccidade(const Value: string);
begin
  Fccidade := Value;
end;

procedure TCadastro.Setccomplemento(const Value: string);
begin
  Fccomplemento := Value;
end;

procedure TCadastro.Setcdocumento(const Value: string);
begin
  Fcdocumento := Value;
end;

procedure TCadastro.Setcdscep(const Value: string);
begin
  Fcdscep := Value;
end;

procedure TCadastro.Setcdtregistro(const Value: string);
begin
  Fcdtregistro := Value;
end;

procedure TCadastro.Setcflnatureza(const Value: integer);
begin
  Fcflnatureza := Value;
end;

procedure TCadastro.Setclougradouro(const Value: string);
begin
  Fclougradouro := Value;
end;

procedure TCadastro.Setcnmprimeiro(const Value: string);
begin
  Fcnmprimeiro := Value;
end;

procedure TCadastro.Setcnmsegundo(const Value: string);
begin
  Fcnmsegundo := Value;
end;

procedure TCadastro.Setcuf(const Value: string);
begin
  Fcuf := Value;
end;

procedure TCadastro.Setid_cad(const Value: Integer);
begin
  Fid_cad := Value;
end;

end.
