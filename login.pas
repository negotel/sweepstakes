unit login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, System.Actions, Vcl.ActnList;

type
  TfLogin = class(TForm)
    pnl_fundo: TPanel;
    pnl_lateral: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    img_log: TImage;
    Panel1: TPanel;
    Label6: TLabel;
    edt_usuario: TEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    Label7: TLabel;
    Panel4: TPanel;
    edt_senha: TEdit;
    Panel5: TPanel;
    btn_confirma: TSpeedButton;
    Panel6: TPanel;
    Label5: TLabel;
    Label8: TLabel;
    Atlhos: TActionList;
    ENTER: TAction;
    Image3: TImage;
    procedure btn_confirmaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ENTERExecute(Sender: TObject);
    procedure autenticacao();
    procedure Image3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLogin: TfLogin;

implementation

{$R *.dfm}

uses datamodule, unit_funcoes;

procedure TfLogin.autenticacao;
var
  senhaStorege, usuarioStorege: string;
begin

  usuarioStorege := 'ADMIN';
  senhaStorege := '123456';

  if edt_usuario.Text = '' then
  begin
    fnc_criar_mensagem('CONFIRMAÇÃO', 'Ops!',
      'Informe o nome do usuário, por favor!',
      ExtractFilePath(Application.ExeName) + '\icones\erro.png', 'OK');

    edt_usuario.SetFocus;
    exit;
  end;

  if edt_senha.Text = '' then
  begin
    Application.MessageBox('Informe o senha, por favor!', 'ecosta',
      MB_OK + MB_ICONINFORMATION);
    edt_senha.SetFocus;
    exit;
  end;

  with dmConexao.fdQrLogin do
  begin
    Close;
    ParamByName('u').Value := edt_usuario.Text;
    ParamByName('s').Value := edt_senha.Text;
    Open;

    if RecordCount > 0 then
    begin
      iLogs(FieldByName('id').AsString, 'Logou no Sistema', 'FormLogin');
    end
    else
    begin
      fnc_criar_mensagem('CONFIRMAÇÃO', 'Ops!', 'Usuário ou Senha incorreto!',
        ExtractFilePath(Application.ExeName) + '\icones\erro.png', 'OK');
      exit;
    end;
  end;
  Close;
end;

procedure TfLogin.btn_confirmaClick(Sender: TObject);
begin
  autenticacao();
end;

procedure TfLogin.ENTERExecute(Sender: TObject);
begin
  autenticacao();
end;

procedure TfLogin.FormActivate(Sender: TObject);
begin
  pnl_fundo.Left := Round((fLogin.Width - pnl_fundo.Width) / 2);
  pnl_fundo.top := Round((fLogin.Height - pnl_fundo.Height) / 2);
end;

procedure TfLogin.Image3Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
