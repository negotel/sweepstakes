unit home;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Menus, Data.DB, Data.Win.ADODB, Vcl.Buttons, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfHome = class(TForm)
    lbl_rodape_copyright: TLabel;
    pnl_fundo: TPanel;
    pnl_importa_arquivo: TPanel;
    sh_importa_arquivo: TShape;
    sp_importa_arquivo: TSpeedButton;
    pnl_consulta_milhar: TPanel;
    sh_consulta_milhar: TShape;
    sp_consulta_milhar: TSpeedButton;
    pnl_analises_dados: TPanel;
    sh_analises_dados: TShape;
    sp_analises_dados: TSpeedButton;
    pnl_log_sistema: TPanel;
    sh_log_sistema: TShape;
    sp_log_sistema: TSpeedButton;
    pnl_border_topo: TPanel;
    img_close_tela: TImage;
    lbl_logado: TLabel;
    pnl_cadastrar_usuario: TPanel;
    sh_cadastrar_usuario: TShape;
    sp_cadastrar_usuario: TSpeedButton;
    procedure Panel1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure ImportaArquivo1Click(Sender: TObject);
    procedure ConsultaMilhar1Click(Sender: TObject);

    procedure atualizaCbPremios;
    procedure FormActivate(Sender: TObject);
    procedure AnalisesDados1Click(Sender: TObject);
    procedure Sair2Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure sp_consulta_milharClick(Sender: TObject);
    procedure sp_importa_arquivoClick(Sender: TObject);
    procedure sp_analises_dadosClick(Sender: TObject);
    procedure sp_log_sistemaClick(Sender: TObject);
    procedure sp_cadastrar_usuarioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fHome: TfHome;

implementation

{$R *.dfm}

uses main, importacao, analises, datamodule, logs, cusuario, unit_funcoes;

procedure TfHome.ConsultaMilhar1Click(Sender: TObject);
begin
  Application.CreateForm(TfMain, fMain);
  fMain.ShowModal;
  fMain.Free;
end;

procedure TfHome.FormActivate(Sender: TObject);
var
nivelAcesso: string;
begin

  nivelAcesso := dmConexao.fdQrLogin.FieldByName('nivel').AsString;

  if dmConexao.fdQrLogin.RecordCount > 0 then
  begin
    lbl_logado.Caption := 'Usuário Logado: ' + dmConexao.fdQrLogin.FieldByName('nome').AsString;
  end;


  pnl_fundo.Left := Round((fHome.Width - pnl_fundo.Width) / 2);
  pnl_fundo.top := Round((fHome.Height - pnl_fundo.Height) / 2);

  if nivelAcesso = 'admin' then begin
    pnl_importa_arquivo.Enabled   := True;
    pnl_consulta_milhar.Enabled   := True;
    pnl_analises_dados.Enabled    := True;
    pnl_log_sistema.Enabled       := True;
    pnl_cadastrar_usuario.Enabled := True;
  end else if nivelAcesso = 'user' then begin
    pnl_importa_arquivo.Enabled   := False;
    pnl_consulta_milhar.Enabled   := True;
    pnl_analises_dados.Enabled    := False;
    pnl_log_sistema.Enabled       := False;
    pnl_cadastrar_usuario.Enabled := False;
  end else begin
    pnl_fundo.Visible := False;
    fnc_criar_mensagem('CONFIRMAÇÃO',
                       'ERRO DE ACESSO',
                       Pchar('Ops, o sistema não pode se inicializado, '+chr(13)+ chr(10)+'Por esse motivo o sistema sera finalizado!'),
                       ExtractFilePath(Application.ExeName)+'\icones\erro.png', 'OK');
    Application.Terminate;
  end;

end;

procedure TfHome.Image3Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfHome.ImportaArquivo1Click(Sender: TObject);
begin
  Application.CreateForm(Tfimportacao, fimportacao);
  fimportacao.ShowModal;
  fimportacao.Free;
end;

procedure TfHome.Panel1Click(Sender: TObject);
begin
  Application.CreateForm(TfMain, fMain);
  fMain.ShowModal;
  fMain.Free;
end;

procedure TfHome.Panel2Click(Sender: TObject);
begin
  Application.CreateForm(Tfimportacao, fimportacao);
  fimportacao.ShowModal;
  fimportacao.Free;
end;

procedure TfHome.Sair1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfHome.Sair2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfHome.sp_cadastrar_usuarioClick(Sender: TObject);
begin
  Application.CreateForm(TfCUsuario, fCUsuario);
  fCUsuario.ShowModal;
  fCUsuario.Free;
end;

procedure TfHome.sp_importa_arquivoClick(Sender: TObject);
begin
  Application.CreateForm(Tfimportacao, fimportacao);
  fimportacao.ShowModal;
  fimportacao.Free;
end;

procedure TfHome.sp_log_sistemaClick(Sender: TObject);
begin
  Application.CreateForm(TfLogs, fLogs);
  fLogs.ShowModal;
  fLogs.Free;
end;

procedure TfHome.sp_consulta_milharClick(Sender: TObject);
begin
  Application.CreateForm(TfMain, fMain);
  fMain.ShowModal;
  fMain.Free;
end;

procedure TfHome.sp_analises_dadosClick(Sender: TObject);
begin
  Application.CreateForm(TfAnalises, fAnalises);
  fAnalises.ShowModal;
  fAnalises.Free;
end;

procedure TfHome.AnalisesDados1Click(Sender: TObject);
begin
  Application.CreateForm(TfAnalises, fAnalises);
  fAnalises.ShowModal;
  fAnalises.Free;
end;

procedure TfHome.atualizaCbPremios;
var
  item_combo: string;
  cbPremio: TComboBox;
begin
  // code here
end;

end.
