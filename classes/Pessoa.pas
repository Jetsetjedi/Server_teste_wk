unit Pessoa;

interface

 type
  TPessoa = class
  private
    Fnmprimeiro: string;
    Fdtregistro: TDate;
    Fnmsegundo: string;
    Fdsdocumento: string;
    Fidpessoa: Integer;
    Fflnatureza: Integer;
    Fcep: string;
    procedure Setdsdocumento(const Value: string);
    procedure Setdtregistro(const Value: TDate);
    procedure Setflnatureza(const Value: Integer);
    procedure Setidpessoa(const Value: Integer);
    procedure Setnmprimeiro(const Value: string);
    procedure Setnmsegundo(const Value: string);
    procedure Setcep(const Value: string);
      public
      property idpessoa:    Integer read Fidpessoa write Setidpessoa;
      property cep: string read Fcep write Setcep;
      property flnatureza:  Integer  read Fflnatureza write Setflnatureza;
      property dsdocumento: string read Fdsdocumento write Setdsdocumento;
      property nmprimeiro:  string read Fnmprimeiro write Setnmprimeiro;
      property nmsegundo :  string read Fnmsegundo write Setnmsegundo;
      property dtregistro:  TDate read Fdtregistro write Setdtregistro;


  end;

implementation

{ TPessoa }

procedure TPessoa.Setcep(const Value: string);
begin
  Fcep := Value;
end;

procedure TPessoa.Setdsdocumento(const Value: string);
begin
  Fdsdocumento := Value;
end;

procedure TPessoa.Setdtregistro(const Value: TDate);
begin
  Fdtregistro := Value;
end;

procedure TPessoa.Setflnatureza(const Value:  Integer);
begin
  Fflnatureza := Value;
end;

procedure TPessoa.Setidpessoa(const Value: Integer);
begin
  Fidpessoa := Value;
end;

procedure TPessoa.Setnmprimeiro(const Value: string);
begin
  Fnmprimeiro := Value;
end;

procedure TPessoa.Setnmsegundo(const Value: string);
begin
  Fnmsegundo := Value;
end;

end.
