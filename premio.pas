unit premio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.Mask, Vcl.StdCtrls;

type
  TfCadastraPremio = class(TForm)
    txtDescricao: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    txtResponsavel: TEdit;
    Label3: TLabel;
    txtDataSorteio: TMaskEdit;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCadastraPremio: TfCadastraPremio;

implementation

{$R *.dfm}

uses main, importacao, home, datamodule;



procedure TfCadastraPremio.SpeedButton1Click(Sender: TObject);
var
dataDB ,dataMes, dataAno: string;
dataSplitted, dataMesSplitted, dataAnoSplitted1: TArray<String>;
begin

  if txtDescricao.Text = '' then begin
    Application.MessageBox('Por favor, Informe a Descrição do Premio', 'ecosta', MB_OK + MB_ICONINFORMATION);
    txtDescricao.SetFocus;
    exit;
  end else if txtResponsavel.Text = '' then begin
    Application.MessageBox('Por favor, Informe um Responsavel', 'ecosta', MB_OK + MB_ICONINFORMATION);
    txtResponsavel.SetFocus;
    exit;
  end else if txtDataSorteio.Text = '' then begin
    Application.MessageBox('Por favor, Informe um Data do Sorteio', 'ecosta', MB_OK + MB_ICONINFORMATION);
    txtDataSorteio.SetFocus;
    exit;
  end else begin
     dataDB := txtDataSorteio.Text;
     dataSplitted := dataDB.Split(['/'], 3);




     ShowMessage(dataSplitted[0]+'-'+dataSplitted[1]+'-'+dataSplitted[2]);

     with dmConexao.query do
     begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO premio');
        SQL.Add('(descricao,dataSorteio,responsavel)');
        SQL.Add('VALUES');
        SQL.Add('(:descricao,:dataSorteio,:responsavel)');
        ParamByName('descricao').Value := txtDescricao.Text;
        ParamByName('dataSorteio').Value := dataSplitted[2]+'-'+dataSplitted[1]+'-'+dataSplitted[0];
        ParamByName('responsavel').Value := txtResponsavel.Text;
        ExecSQL;
        Application.MessageBox('Dados salvo com sucesso!, O sistema ira reiniciar para atualizar dados.', 'ecosta', MB_OK + MB_ICONINFORMATION);

        txtDescricao.Text := '';
        txtResponsavel.Text := '';
        txtDataSorteio.Text  := '';
        fimportacao.cbPremio.Clear;

        fHome.atualizaCbPremios;
    end;

  end;


end;


end.
