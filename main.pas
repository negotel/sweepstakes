unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Data.Win.ADODB,
  ExtCtrls, ShellApi,
  Vcl.Buttons, Vcl.Menus, Vcl.Imaging.pngimage;

type
  TfMain = class(TForm)
    pnl_fundo: TPanel;
    Panel5: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Panel3: TPanel;
    Label10: TLabel;
    cbPremio: TComboBox;
    Panel1: TPanel;
    Label8: TLabel;
    edMilhar: TEdit;
    Panel2: TPanel;
    Memo1: TMemo;
    Label1: TLabel;
    Panel6: TPanel;
    txtControle: TLabel;
    Label3: TLabel;
    txtMilhar: TLabel;
    Label5: TLabel;
    txtData: TLabel;
    Label7: TLabel;
    txtPremio: TLabel;
    Label2: TLabel;
    txtCliente: TLabel;
    Label9: TLabel;
    txtResponsavel: TLabel;
    Label4: TLabel;
    Image3: TImage;
    Panel4: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure edMilharKeyPress(Sender: TObject; var Key: Char);
    procedure consulta;
    procedure ReiniciarSistema;
    procedure FormActivate(Sender: TObject);
    procedure Image3Click(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

uses importacao, home, datamodule, unit_funcoes;
{ TForm1 }

procedure TfMain.consulta;
var
  milhar, controle: string;
  idpremio: integer;
begin

  idpremio := Integer(cbPremio.Items.Objects[cbPremio.ItemIndex]);

  with dmConexao.query do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM sorteio WHERE milhar = ' + edMilhar.Text +' AND premio_id = '+IntToStr(idpremio));
    Close;
    Open;


    if RecordCount > 0 then begin

      controle := FormatFloat('0000', StrToInt(FieldByName('controle').AsString));
      milhar := FormatFloat('0000', StrToInt(FieldByName('milhar').AsString));

      // mostra resultado
      txtControle.Caption := 'C' + FieldByName('controle').AsString;
      txtMilhar.Caption := milhar;
      txtCliente.Caption := FieldByName('cliente_id').AsString;

      Memo1.Lines.Add('C' + controle + ' -- ' + 'M' + milhar + ' -- ' + FieldByName('cliente_id').AsString);
      // mostra detalhe do premio
      with dmConexao.query1 do begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM premio WHERE id = '+inttostr(idpremio));
        Close;
        Open;

        txtResponsavel.Caption := FieldByName('responsavel').AsString;
        txtData.Caption := FieldByName('dataSorteio').AsString;
        txtPremio.Caption := FieldByName('descricao').AsString;
      end;

    end else begin

      fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Ops!',
                         'Consulta não retornou nenhum dados!',
                         ExtractFilePath(Application.ExeName)+'\icones\erro.png', 'OK');

      txtControle.Caption := '....';
      txtMilhar.Caption := '....';
      txtCliente.Caption := '....';
      txtResponsavel.Caption := '....';
      txtData.Caption := '....';
      txtPremio.Caption := '....';
      edMilhar.Text := '';
      edMilhar.SetFocus;

    end;
  end;
end;

procedure TfMain.edMilharKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // se teclar enter
  begin

    if (edMilhar.Text = '') then begin
      fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Ops!',
                         'Por favor, você deve informa um numero para consulta',
                         ExtractFilePath(Application.ExeName)+'\icones\erro.png', 'OK');
      abort;
    end;

    if (cbPremio.Text = '-1') or (cbPremio.Text = '') then begin
      fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Ops!',
                         'Por favor, Selecione um premio para consultar uma milhar.',
                         ExtractFilePath(Application.ExeName)+'\icones\erro.png', 'OK');
      abort;
    end;

    consulta;
  end;
end;

procedure TfMain.FormActivate(Sender: TObject);
var
  item_combo: string;
begin
  with dmConexao.carrega_premios_cb do begin
      Close;
      Open;
      while not Eof do begin
        item_combo := FieldByName('id').AsString + ' - ' + FieldByName('descricao').AsString;
        cbPremio.Items.AddObject(item_combo, TObject(FieldByName('id').AsInteger));
        Next;
      end;
      Close;
    end;

    pnl_fundo.Left := Round((fMain.Width - pnl_fundo.Width) / 2);
    pnl_fundo.top := Round((fMain.Height - pnl_fundo.Height) / 2);
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  txtControle.Caption := '....';
  txtMilhar.Caption := '....';
  txtCliente.Caption := '....';
  txtResponsavel.Caption := '....';
  txtData.Caption := '....';
  txtPremio.Caption := '....';

  Memo1.Lines.Clear;
end;


procedure TfMain.Image3Click(Sender: TObject);
begin
  Close;
end;

procedure TfMain.ReiniciarSistema;
var AppName : PChar;
begin
 AppName := PChar(Application.ExeName);
 ShellExecute(Handle,'open', AppName, nil, nil, SW_SHOWNORMAL);
 Application.Terminate;
end;

end.
