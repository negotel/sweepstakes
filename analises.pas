unit analises;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Data.Win.ADODB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSAcc, FireDAC.Phys.MSAccDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Phys.ODBCBase, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons, frxClass, frxDesgn, Vcl.ExtCtrls,
  frxGaugePanel, frxDBSet, Vcl.Imaging.pngimage;

type
  TfAnalises = class(TForm)
    dsSorteio: TDataSource;
    queryGridActive: TFDQuery;
    lbl_message_process: TLabel;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    frxDBTotalMilhar: TfrxDBDataset;
    dsTotal: TDataSource;
    querySQL: TFDQuery;
    pnl_fundo: TPanel;
    pnl_top: TPanel;
    img_close_sistema: TImage;
    pnl_borde_top: TPanel;
    pnl_cliente_select: TPanel;
    Label1: TLabel;
    dbDados: TDBGrid;
    pnl_controle: TPanel;
    Label2: TLabel;
    edControle: TEdit;
    Panel2: TPanel;
    pnl_milhar: TPanel;
    Label3: TLabel;
    edMilhar: TEdit;
    Panel4: TPanel;
    pnl_data_sorteio: TPanel;
    Label4: TLabel;
    txtDataSorteio: TMaskEdit;
    Panel5: TPanel;
    pnl_premio: TPanel;
    Label5: TLabel;
    cbPremio: TComboBox;
    pnl_sp_filtra: TPanel;
    sh_filtrar: TShape;
    btn_filtrar: TSpeedButton;
    cb_clientes: TEdit;
    Panel3: TPanel;
    pnl_imprimir_relatorio: TPanel;
    sh_imprimir_relatorio: TShape;
    sp_imprimir_relatorio: TSpeedButton;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_filtrarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure img_close_sistemaClick(Sender: TObject);
    procedure dbDadosDblClick(Sender: TObject);
    procedure dbDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure sp_imprimir_relatorioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TDBGridPadrao = class(TDBGrid);

var
  fAnalises: TfAnalises;

implementation

{$R *.dfm}

uses home, modalDataSorteio, datamodule, unit_funcoes;

procedure TfAnalises.dbDadosDblClick(Sender: TObject);
var
  ARow, ACol: Integer;
  Pt: TPoint;
  CellValue: String;
begin

  // First, get the mouse pointer coordinates
  Pt.X := Mouse.CursorPos.X;
  Pt.Y := Mouse.CursorPos.Y;
  // Translate them into the coordinate system of the DBGrid
  Pt := dbDados.ScreenToClient(Pt);

  // Use TDBGrids inbuilt functionality to identify the Column and
  // row number.
  ACol := dbDados.MouseCoord(Pt.X, Pt.Y).X - 1;
  ARow := dbDados.MouseCoord(Pt.X, Pt.Y).Y;
  CellValue := dbDados.Columns[0].Field.AsString;

  Caption := Format('Col:%d Row:%d Cell Value:%s', [ACol, ARow, CellValue]);

  Application.CreateForm(TfModal, fModal);
  fModal.ShowModal;
  fModal.Free;

  dmConexao.query.Active := false;

end;

procedure TfAnalises.dbDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
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

procedure TfAnalises.FormActivate(Sender: TObject);
var
  item_combo: string;
begin

  with dmConexao.carrega_premios_cb do
  begin
    Close;
    Open;
    while not Eof do
    begin
      item_combo := FieldByName('id').AsString + ' - ' + FieldByName('descricao').AsString;
      cbPremio.Items.AddObject(item_combo, TObject(FieldByName('id').AsInteger));
      Next;
    end;
    Close;
  end;

  pnl_fundo.Left := Round((fAnalises.Width - pnl_fundo.Width) / 2);
  pnl_fundo.top := Round((fAnalises.Height - pnl_fundo.Height) / 2);
  TDBGridPadrao(dbDados).DefaultRowHeight := 30;
  //TDBGridPadrao(dbDados).ClientHeight     := (30 * TDBGridPadrao(dbDados).RowCount)+30;

end;

procedure TfAnalises.FormCreate(Sender: TObject);
begin
  lbl_message_process.Caption := IntToStr(queryGridActive.RecordCount);
end;

procedure TfAnalises.img_close_sistemaClick(Sender: TObject);
begin
  close;
end;

procedure TfAnalises.sp_imprimir_relatorioClick(Sender: TObject);
var
  path: string;
begin
  path := ExtractFilePath(Application.ExeName);
  frxReport1.LoadFromFile(path + 'relatorio.fr3');
  frxReport1.ShowReport();
end;

procedure TfAnalises.btn_filtrarClick(Sender: TObject);
var
  query: TADOQuery;
  whereClienteVendedor, wherePremio, whereMilhar, whereControle,
    whereDataSorteio: string;
  premioID: Integer;
begin
  pnl_imprimir_relatorio.Visible := False;
  whereClienteVendedor := '';
  wherePremio := '';
  whereMilhar := '';
  whereControle := '';
  whereDataSorteio := '';

  // Filtra Cliente/Vendedor
  if cb_clientes.Text <> '' then
  begin
    whereClienteVendedor := 'AND sorteio.cliente_id = "' + cb_clientes.Text + '"';
    if cbPremio.Text = '' then
    begin
        fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Ops!',
                         'Para consulta com cliente,'+chr(13)+ chr(10)+'Você precisa escolher um premio.',
                         ExtractFilePath(Application.ExeName)+'\icones\info.png', 'OK');
      exit;
    end;

  end;

  // Filtra Premio
  if cbPremio.Text <> '' then
  begin
    premioID := Integer(cbPremio.Items.Objects[cbPremio.ItemIndex]);
    wherePremio := 'AND sorteio.premio_id = ' + IntToStr(premioID);
  end;

  // Filtra Milhar
  if edMilhar.Text <> '' then
  begin
    whereMilhar := 'AND sorteio.milhar = ' + edMilhar.Text;
  end;

  // Filtra Controle
  if edControle.Text <> '' then
  begin
    pnl_imprimir_relatorio.Visible := False;
    whereControle := 'AND sorteio.controle = ' + edControle.Text;
  end;

  // Filtra Data do Sorteio
  if (txtDataSorteio.Text <> '') and (txtDataSorteio.Text <> '  /  /    ') then
  begin
    whereDataSorteio := 'AND premio.dataSorteio = ' + txtDataSorteio.Text;
  end;

  with fHome do
  begin
    with dmConexao.query do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT sorteio.id,' +
                     'sorteio.cliente_id,' +
                     'sorteio.controle,' +
                     'sorteio.milhar,' +
                     'sorteio.premio_id,' +
                     'premio.id as pID,' +
                     'premio.descricao,' +
                     'premio.dataSorteio,' +
                     'premio.responsavel FROM sorteio');
      SQL.Add('LEFT JOIN premio ON premio.id = sorteio.premio_id');
      SQL.Add('WHERE sorteio.id <> 0 ');
      SQL.Add(whereClienteVendedor + ' ' + wherePremio + ' ' + whereMilhar + ' '
        + whereControle + ' ' + whereDataSorteio);
      Open;

      if RecordCount = 0 then
      begin
        fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Ops!',
                         'Sua consulta não retornou nenhum registro.',
                         ExtractFilePath(Application.ExeName)+'\icones\info.png', 'OK');
        exit;
      end;

      dsSorteio.DataSet := dmConexao.query;

      //lbl_message_process.Caption := 'Total de registro encontrado: ' + IntToStr(RecordCount);
    end;

    // Filtra Cliente/Vendedor
    if (cb_clientes.Text <> '') or (cbPremio.Text <> '') then
    begin

      if edMilhar.Text = '' then begin
         pnl_imprimir_relatorio.Visible := True;
      end else begin
        pnl_imprimir_relatorio.Visible := False;
      end;

      with querySQL do
      begin
        Close;
        if (cbPremio.Text <> '') then
        begin
          SQL.Add(' AND premio_id = :premioid');
          ParamByName('premioid').Value := premioID;
        end;

        if (cb_clientes.Text <> '') then
        begin
          ParamByName('cliente').Value := cb_clientes.Text;
        end;

        Open;

        dsTotal.DataSet := querySQL;
      end;

      lbl_message_process.Caption := 'Total de registro encontrado: ' + querySQL.FieldByName('TOTAL').AsString;
    end;

  end;
  TDBGridPadrao(dbDados).DefaultRowHeight := 30;
end;

end.
