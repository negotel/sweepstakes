program sweepstakes;

uses
  Vcl.Forms,
  System.SysUtils,
  home in 'home.pas' {fHome},
  main in 'main.pas' {fMain},
  importacao in 'importacao.pas' {fimportacao},
  premio in 'premio.pas' {fCadastraPremio},
  analises in 'analises.pas' {fAnalises},
  modalDataSorteio in 'modalDataSorteio.pas' {fModal},
  login in 'login.pas' {fLogin},
  datamodule in 'datamodule.pas' {dmConexao: TDataModule},
  splashscren in 'splashscren.pas' {fSplashScreen},
  messagem in 'messagem.pas' {fMensagem},
  unit_funcoes in 'unit_funcoes.pas',
  logs in 'logs.pas' {fLogs},
  cusuario in 'cusuario.pas' {fCUsuario};

{$R *.res}

begin

  Application.Initialize;
  Application.MainFormOnTaskBar := True;

  fSplashScreen := TfSplashScreen.Create(Application);
 
  Application.ProcessMessages;
  Application.CreateForm(TdmConexao, dmConexao);
  fLogin := TfLogin.Create(nil);
  fLogin.ShowModal;


  Application.CreateForm(TfCUsuario, fCUsuario);
  Application.CreateForm(TfLogs, fLogs);
  Application.CreateForm(TfHome, fHome);
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(Tfimportacao, fimportacao);
  Application.CreateForm(TfCadastraPremio, fCadastraPremio);
  Application.CreateForm(TfAnalises, fAnalises);
  Application.CreateForm(TfModal, fModal);

  fLogin.Hide;
  fLogin.Free;

  Application.Run;

end.
