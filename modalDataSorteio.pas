unit modalDataSorteio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TfModal = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    txtControle: TLabel;
    Label3: TLabel;
    txtMilhar: TLabel;
    Label5: TLabel;
    txtData: TLabel;
    Label7: TLabel;
    txtPremio: TLabel;
    Label2: TLabel;
    txtCliente: TLabel;
    Label6: TLabel;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    txtResponsavel: TLabel;
    Image3: TImage;
    procedure FormActivate(Sender: TObject);
    procedure Image3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fModal: TfModal;

implementation

{$R *.dfm}

uses analises, home, datamodule;

procedure TfModal.FormActivate(Sender: TObject);
var
  ARow,
  ACol : Integer;
  Pt : TPoint;
  CellValueID, CellValuePremio : String;
  milhar, controle: string;
begin

  //  First, get the mouse pointer coordinates
  Pt.X := Mouse.CursorPos.X;
  Pt.Y := Mouse.CursorPos.Y;
  //  Translate them into the coordinate system of the DBGrid
  Pt := fAnalises.dbDados.ScreenToClient(Pt);

  //  Use TDBGrids inbuilt functionality to identify the Column and
  //  row number.
  ACol := fAnalises.dbDados.MouseCoord(Pt.X, Pt.Y).X -1;
  ARow := fAnalises.dbDados.MouseCoord(Pt.X, Pt.Y).Y;
  CellValueID := fAnalises.dbDados.Columns[0].Field.AsString;
  CellValuePremio := fAnalises.dbDados.Columns[6].Field.AsString;

  //Caption := 'Resultado da Consulta: '+Format('Col:%d Row:%d Cell Value:%s', [ACol, ARow, CellValueID]);

  dmConexao.query.Active := false;
  with dmConexao.query do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM sorteio WHERE ID = ' + CellValueID);
    Close;
    Open;

    if RecordCount > 0 then
    begin

      controle := FormatFloat('0000', StrToInt(FieldByName('controle').AsString));
      milhar := FormatFloat('0000', StrToInt(FieldByName('milhar').AsString));

      // mostra resultado
      txtControle.Caption := 'C' + FieldByName('controle').AsString;
      txtMilhar.Caption := milhar;
      txtCliente.Caption := FieldByName('cliente_id').AsString;

      // mostra detalhe do premio
      with dmConexao.query1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT * FROM premio WHERE id = '+CellValuePremio);
        Close;
        Open;

        txtResponsavel.Caption := FieldByName('responsavel').AsString;
        txtData.Caption := FieldByName('dataSorteio').AsString;
        txtPremio.Caption := FieldByName('descricao').AsString;
      end;
    end
    else
    begin

      Application.MessageBox('Consulta não retornou nenhum dados!', 'ecosta', MB_OK + MB_ICONINFORMATION);

      txtControle.Caption := '....';
      txtMilhar.Caption := '....';
      txtCliente.Caption := '....';
      txtResponsavel.Caption := '....';
      txtData.Caption := '....';
      txtPremio.Caption := '....';
    end;
  end;

end;

procedure TfModal.Image3Click(Sender: TObject);
begin
  Close;
end;

end.
