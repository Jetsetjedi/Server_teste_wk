unit Endereco;

interface

 type TEndereco = class
  private
    Fidendereco: Integer;
    Fdscep: string;
    Fidpessoa: integer;
    procedure Setdscep(const Value: string);
    procedure Setidendereco(const Value: Integer);
    procedure Setidpessoa(const Value: integer);
   public
    property idendereco: Integer read Fidendereco write Setidendereco;
    property idpessoa:integer read Fidpessoa write Setidpessoa;
    property dscep: string read Fdscep write Setdscep;

 end;

implementation

{ TEndereco }

procedure TEndereco.Setdscep(const Value: string);
begin
  Fdscep := Value;
end;

procedure TEndereco.Setidendereco(const Value: Integer);
begin
  Fidendereco := Value;
end;

procedure TEndereco.Setidpessoa(const Value: integer);
begin
  Fidpessoa := Value;
end;

end.
