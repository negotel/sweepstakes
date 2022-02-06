unit cusuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons;

type
  TfCUsuario = class(TForm)
    pnl_fundo: TPanel;
    pnl_top: TPanel;
    img_close_sistema: TImage;
    lbl_titulo: TLabel;
    pnl_borde_top: TPanel;
    dbDados: TDBGrid;
    pnl_nome_sobrenome: TPanel;
    Label2: TLabel;
    ed_nome_sobrenome: TEdit;
    Panel2: TPanel;
    pnl_nome_usuario_acesso: TPanel;
    Label1: TLabel;
    ed_nome_usuario_acesso: TEdit;
    Panel3: TPanel;
    pnl_senha_acesso: TPanel;
    Label3: TLabel;
    ed_senha_acesso: TEdit;
    Panel4: TPanel;
    pnl_nivel_acesso: TPanel;
    Label5: TLabel;
    cb_nivel_acesso: TComboBox;
    Panel1: TPanel;
    queryGridActive: TFDQuery;
    dsUsuarios: TDataSource;
    pnl_sp_filtra: TPanel;
    sh_filtrar: TShape;
    btn_filtrar: TSpeedButton;
    pnl_cadastrar: TPanel;
    sh_cadastrar: TShape;
    sp_cadastrar: TSpeedButton;
    qrInsertUsuario: TFDQuery;
    procedure img_close_sistemaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dbDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);

    procedure cadastrar_usuario;
    procedure sp_cadastrarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TDBGridPadrao = class(TDBGrid);

var
  fCUsuario: TfCUsuario;

implementation

{$R *.dfm}

uses datamodule, unit_funcoes;

procedure TfCUsuario.cadastrar_usuario;
begin
  if ed_nome_sobrenome.Text = '' then begin
    fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Ops!',
                         'Preencha o campo Nome Sobrenome',
                         ExtractFilePath(Application.ExeName)+'\icones\info.png', 'OK');
    ed_nome_sobrenome.SetFocus;
    exit;
  end;

  if ed_nome_usuario_acesso.Text = '' then begin
    fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Ops!',
                         'Preencha o campo Nome Usuário Acesso',
                         ExtractFilePath(Application.ExeName)+'\icones\info.png', 'OK');
    ed_nome_usuario_acesso.SetFocus;
    Exit;
  end;

  if ed_nome_usuario_acesso.Text = '' then begin
    fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Ops!',
                         'Preencha o campo Senha Acesso',
                         ExtractFilePath(Application.ExeName)+'\icones\info.png', 'OK');
    ed_senha_acesso.SetFocus;
    Exit;
  end;

  if cb_nivel_acesso.Text = '' then begin
    fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Ops!',
                         'Selecione um Nivel de Acesso',
                         ExtractFilePath(Application.ExeName)+'\icones\info.png', 'OK');
    Exit;
  end;

  try
     with qrInsertUsuario do begin
        Close;
        ParamByName('nome').Value     := ed_nome_sobrenome.Text;
        ParamByName('usuario').Value  := ed_nome_usuario_acesso.Text;
        ParamByName('senha').Value    := ed_senha_acesso.Text;
        ParamByName('nivel').Value    := cb_nivel_acesso.Text;
        ExecSQL;

        fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Sucesso',
                         'Dados cadastrado com sucesso!',
                         ExtractFilePath(Application.ExeName)+'\icones\success.png', 'OK');

        iLogs(dmConexao.fdQrLogin.FieldByName('id').AsString, 'Cadastrou um usuário no sistema', 'FormCadastrarUsuario');

        dsUsuarios.DataSet := queryGridActive;
        TDBGridPadrao(dbDados).DefaultRowHeight := 30;
     end;
  finally
      TDBGridPadrao(dbDados).DefaultRowHeight := 30;
     dsUsuarios.DataSet := queryGridActive;
     qrInsertUsuario.Close;

     ed_nome_sobrenome.Text       := '';
     ed_nome_usuario_acesso.Text  := '';
     ed_senha_acesso.Text         := '';
     cb_nivel_acesso.Text         := '';

  end;
end;

procedure TfCUsuario.dbDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
    if Odd(dbDados.DataSource.DataSet.RecNo) then begin
      dbDados.Canvas.Brush.Color := $00E9E9E9;
    end else begin
      dbDados.Canvas.Brush.Color := clWhite;
    end;

    if (gdSelected in State) then begin
      dbDados.Canvas.Brush.Color := clBlue;
      dbDados.Canvas.Font.Color := clWhite;
      dbDados.Canvas.Font.Style := [fsBold];
    end;

    dbDados.Canvas.FillRect(Rect);
    dbDados.DefaultDrawColumnCell(Rect, DataCol, Column, State);

    dbDados.Canvas.TextRect(Rect, Rect.Left+8, Rect.Top + 8, Column.Field.DisplayText);
end;

procedure TfCUsuario.FormActivate(Sender: TObject);
begin
    pnl_fundo.Left := Round((fCUsuario.Width - pnl_fundo.Width) / 2);
    pnl_fundo.top := Round((fCUsuario.Height - pnl_fundo.Height) / 2);

    TDBGridPadrao(dbDados).DefaultRowHeight := 30;
end;

procedure TfCUsuario.FormShow(Sender: TObject);
begin
  TDBGridPadrao(dbDados).DefaultRowHeight := 30;
end;

procedure TfCUsuario.img_close_sistemaClick(Sender: TObject);
begin
  Close;
end;

procedure TfCUsuario.sp_cadastrarClick(Sender: TObject);
begin
    cadastrar_usuario;
end;

end.
