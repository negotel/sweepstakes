unit logs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfLogs = class(TForm)
    pnl_fundo: TPanel;
    tvLogs: TTreeView;
    Panel3: TPanel;
    Panel2: TPanel;
    Image3: TImage;
    procedure Image3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLogs: TfLogs;

implementation

{$R *.dfm}

uses datamodule;

procedure TfLogs.FormActivate(Sender: TObject);
var
ItemTitulo, ItemDate:TTreeNode;
qqLog, qqLogGroup: TFDQuery;
dataSplitted: TArray<String>;
sDate, nomeUsuario, horaLog, descricaTarefa: string;
begin
    qqLog       := TFDQuery.Create(nil);
    qqLogGroup  := TFDQuery.Create(nil);

    with qqLog do begin
      Connection := dmConexao.conn;
      Close;
      SQL.Clear;
      SQL.Add('SELECT logs.id, logs.origem, DATE(data_log) as periodo FROM logs GROUP BY periodo ORDER BY periodo ASC');
      Open;

      ItemTitulo  :=    tvLogs.Items.AddChild(nil, 'Logs do Sistema');
      while not Eof do begin

         sDate := FieldByName('periodo').AsString;
         dataSplitted := sDate.Split(['/'], 3);

         ItemDate    :=    tvLogs.Items.AddChildFirst(ItemTitulo, sDate);
         with qqLogGroup do begin
            Connection := dmConexao.conn;
            Close;
            SQL.Clear;
            SQL.Add('SELECT logs.descricao, logs.data_log, login.usuario FROM logs LEFT JOIN login ON logs.usuario_id = login.id WHERE DATE(data_log) = :d ORDER BY data_log DESC');
            ParamByName('d').Value := dataSplitted[2]+'-'+dataSplitted[1]+'-'+dataSplitted[0];
            Open;

            while not Eof do begin
              nomeUsuario     := FieldByName('usuario').AsString;
              descricaTarefa  :=  FieldByName('descricao').AsString;
              horaLog         := FormatDateTime('HH:mm', FieldByName('data_log').AsDateTime);
              tvLogs.Items.AddChild(ItemDate, nomeUsuario.ToLower+' '+descricaTarefa+' - '+horaLog);
              Next;
            end;
         end;
         Next;
      end;
    end;

    pnl_fundo.Left := Round((fLogs.Width - pnl_fundo.Width) / 2);
    pnl_fundo.top := Round((fLogs.Height - pnl_fundo.Height) / 2);
end;

procedure TfLogs.Image3Click(Sender: TObject);
begin
  Close;
end;

end.
