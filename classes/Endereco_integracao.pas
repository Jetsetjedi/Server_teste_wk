unit Endereco_integracao;

interface

type TEnderecoIntegracao  = class
  private
    Fnmlougradouro: string;
    Fidendereco: Integer;
    Fnmbairro: string;
    Fdsuf: string;
    Fdscomplemento: string;
    Fcep: string;
    Fcidade: string;
    procedure Setdscomplemento(const Value: string);
    procedure Setdsuf(const Value: string);
    procedure Setidendereco(const Value: Integer);
    procedure Setnmbairro(const Value: string);
    procedure Setnmlougradouro(const Value: string);
    procedure Setcep(const Value: string);
    procedure Setcidade(const Value: string);
      public
       property idendereco:Integer read Fidendereco write Setidendereco;
       property cep:string read Fcep write Setcep;
       property cidade:string read Fcidade write Setcidade;
       property dsuf:string read Fdsuf write Setdsuf;
       property nmbairro:string read Fnmbairro write Setnmbairro;
       property nmlougradouro:string read Fnmlougradouro write Setnmlougradouro;
       property dscomplemento:string read Fdscomplemento write Setdscomplemento;
end;

implementation

{ TEnderecoIntegracao }

procedure TEnderecoIntegracao.Setcep(const Value: string);
begin
  Fcep := Value;
end;

procedure TEnderecoIntegracao.Setcidade(const Value: string);
begin
  Fcidade := Value;
end;

procedure TEnderecoIntegracao.Setdscomplemento(const Value: string);
begin
  Fdscomplemento := Value;
end;

procedure TEnderecoIntegracao.Setdsuf(const Value: string);
begin
  Fdsuf := Value;
end;

procedure TEnderecoIntegracao.Setidendereco(const Value: Integer);
begin
  Fidendereco := Value;
end;

procedure TEnderecoIntegracao.Setnmbairro(const Value: string);
begin
  Fnmbairro := Value;
end;

procedure TEnderecoIntegracao.Setnmlougradouro(const Value: string);
begin
  Fnmlougradouro := Value;
end;

end.
