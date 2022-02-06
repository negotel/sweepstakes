unit unit_funcoes;

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
  frxGaugePanel, frxDBSet;

function fnc_criar_mensagem(TituloJanela, TituloMSG, MSG, Icone,
  Tipo: string): Boolean;
function iLogs(usuario_id: string; descricao: string; origem: string): Boolean;

implementation

uses messagem, datamodule;

function fnc_criar_mensagem(TituloJanela, TituloMSG, MSG, Icone,
  Tipo: string): Boolean;
begin

  Result := False;

  fMensagem := TfMensagem.Create(nil);
  fMensagem.sTituloJanela   := TituloJanela;
  fMensagem.sTituloMSG      := TituloMSG;
  fMensagem.sMSG            := MSG;
  fMensagem.sCaminhoIcone   := Icone;
  fMensagem.sTipo           := Tipo;

  fMensagem.ShowModal;
  Result                    := fMensagem.bRespostaMSG;

end;

function iLogs(usuario_id, descricao, origem: string): Boolean;
var
  logs: TFDQuery;
begin

  logs := TFDQuery.Create(nil);

  try
    with logs do
    begin
      Connection := dmConexao.conn;
      Close;
      SQL.Add('INSERT INTO logs (usuario_id, descricao, origem)VALUES(:uid, :descc, :orig)');
      ParamByName('UID').Value    := usuario_id;
      ParamByName('DESCC').Value  := descricao;
      ParamByName('ORIG').Value   := origem;
      ExecSQL;
    end;
    logs.Close;
    Result := True;
  except
    on E: Exception do
    begin
      logs.Close;
      Result := False;
    end;
  end;
end;

end.
