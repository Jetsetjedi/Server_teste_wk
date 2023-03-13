program project_wk;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uPrincipal in 'uPrincipal.pas' {Form1},
  uSM in 'uSM.pas' {SM: TDataModule},
  uSC in 'uSC.pas' {ServerContainer1: TDataModule},
  uWM in 'uWM.pas' {WebModule1: TWebModule},
  Pessoa in 'classes\Pessoa.pas',
  Endereco in 'classes\Endereco.pas',
  Endereco_integracao in 'classes\Endereco_integracao.pas',
  hCep in 'helpers\hCep.pas',
  Edereco_integracao in 'classes\Edereco_integracao.pas',
  Cadastro in 'classes\Cadastro.pas',
  uModelPessoa in 'model\uModelPessoa.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
