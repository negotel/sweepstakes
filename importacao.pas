unit importacao;

interface

uses

  Vcl.Samples.Gauges, Vcl.Buttons,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, System.Types, Data.DB, Data.Win.ADODB,
  Vcl.Imaging.pngimage, Vcl.Grids, Vcl.Outline, Vcl.Samples.DirOutln,
  Vcl.FileCtrl;

type
  Tfimportacao = class(TForm)
    buscaArquivo: TOpenDialog;
    pnl_fundo: TPanel;
    pnl_buscar_arquivo: TPanel;
    sh_cadastrar: TShape;
    sp_cadastrar: TSpeedButton;
    pnl_premio: TPanel;
    cbPremio: TComboBox;
    pnl_top: TPanel;
    img_close_sistema: TImage;
    Label6: TLabel;
    pnl_borde_top: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Shape2: TShape;
    sp_add_premio: TSpeedButton;
    Label5: TLabel;
    progress_bar: TGauge;
    lbl_message_process: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    lbl_processo_finalizado: TLabel;
    procedure sp_cadastrarClick(Sender: TObject);
    function importDataFileToMemoCount(FileName: string): Integer;
    function ReadFileData(FileName: string): String;
    procedure FormCreate(Sender: TObject);
    function mostrarMensageLabel(tString: String; labelform: TLabel): String;
    function ExtractName(const FileName: String): String;
    procedure FormActivate(Sender: TObject);

    procedure FormDestroy(Sender: TObject);
    procedure img_close_sistemaClick(Sender: TObject);
    procedure sp_add_premioClick(Sender: TObject);

  private
    { Private declarations }
    FtempoInicial: Double;
  public
    { Public declarations }
  end;

var
  fimportacao: Tfimportacao;

implementation

{$R *.dfm}

uses main, premio, home, datamodule, unit_funcoes;

function Tfimportacao.mostrarMensageLabel(tString: String;
  labelform: TLabel): String;
begin
  labelform.Visible := True;
  labelform.Caption := tString;
  labelform.Refresh;
  labelform.Update;
end;

procedure Tfimportacao.sp_add_premioClick(Sender: TObject);
begin
    Application.CreateForm(TfCadastraPremio, fCadastraPremio);
    fCadastraPremio.ShowModal;
    fCadastraPremio.Free;
end;

procedure Tfimportacao.sp_cadastrarClick(Sender: TObject);
var
  arq: TextFile; { declarando a variável "arq" do tipo arquivo texto }
  linha, linha1, nArquivo, menssage, cliente, nomeArquivo: string;
  rcont, cont: Integer;
  slArquivo, slLinha: TStringList;
  i, j, x, controle, milhar, nNum, nPremio: Integer;
  aStringSeparada: TStringDynArray;
  controleSplitted, clienteSplitted, clienteSplitted1: TArray<String>;
begin
  buscaArquivo.Filter := '.*';
  Memo1.Clear;
  progress_bar.Progress := 0;

  if cbPremio.Text = '' then
  begin

        fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Sucesso',
                         'Escolha um premio para processar o arquivo',
                         ExtractFilePath(Application.ExeName)+'\icones\info.png', 'OK');
    exit;
  end;

  nPremio := Integer(cbPremio.Items.Objects[cbPremio.ItemIndex]);

  if buscaArquivo.Execute then
  begin


    nomeArquivo := ExtractName(ExtractFileName(buscaArquivo.FileName));
    clienteSplitted := nomeArquivo.Split(['_'], 2);

    //verifica se o arquivo ja foi importado
    with dmConexao.query do begin
       Close;
       SQL.Clear;
       SQL.Add('SELECT * FROM sorteio WHERE cliente_id = "'+clienteSplitted[0]+'" And premio_id = '+IntToStr(nPremio)+';');
       Open;

       if RecordCount > 0 then begin
          menssage := 'O arquivo já foi importado: '+ExtractFileName(buscaArquivo.FileName);
          Application.MessageBox(Pchar(menssage), 'ecosta', MB_OK + MB_ICONINFORMATION);
          Close;
          exit;
       end;
    end;

    // limpaTabela;

    slArquivo := TStringList.create;
    slLinha := TStringList.create;
    slLinha.Delimiter := ';'; // aponta qual o
    // delimitador

    slLinha.StrictDelimiter := False;

    progress_bar.MaxValue := 0;

    FtempoInicial := now;
    try
      slArquivo.LoadFromFile(buscaArquivo.FileName);

      menssage := 'Aguarde, processando arquivo: ' + ExtractFileName(buscaArquivo.FileName);

      if slArquivo.Count = 0 then
      begin

        fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Sucesso',
                         'O arquivo carregado não tem registro!',
                         ExtractFilePath(Application.ExeName)+'\icones\info.png', 'OK');
        exit;
      end;

      progress_bar.MaxValue := slArquivo.Count;
      cont := 1;

      for i := 0 to slArquivo.Count - 1 do
      begin
        slLinha.DelimitedText := slArquivo[i]; // Recebe o texto
        // Quebrou o texto em linhas

        Application.ProcessMessages;

        if slLinha.Count = 9 then
        begin

          // Form1.conexaoAcess.KeepConnection := True;
          // Form1.connetcAcess;

          controle := 0;
          milhar := 1;

          for x := 1 to 4 do
          begin
            Application.ProcessMessages;

            if (slLinha[controle] <> 'XXXX.XXXX') and (slLinha[milhar] <> 'XXXX')
            then
            begin

              controleSplitted := slLinha[controle].Split(['.'], 2);

              with dmConexao.query do
              begin
                Close;
                SQL.Clear;
                SQL.Add('INSERT INTO sorteio');
                SQL.Add('(controle,milhar,cliente_id,premio_id)');
                SQL.Add('VALUES');
                SQL.Add('(:IDCONTROL,:MILHAR,:CLIENTE, :PREMIOID)');
                ParamByName('IDCONTROL').Value := controleSplitted[0];
                ParamByName('MILHAR').Value := slLinha[milhar];
                ParamByName('CLIENTE').Value := clienteSplitted[0];
                ParamByName('PREMIOID').Value := nPremio;
                ExecSQL;
              end;
              Memo1.Lines.Add(clienteSplitted[0] + ' - C' + controleSplitted[0] + ' - M' + slLinha[milhar]);
            end;

            controle := milhar + 1;
            milhar := controle + 1;

            // Form1.conexaoAcess.KeepConnection := False;
          end;

          mostrarMensageLabel(menssage + ' ' + IntToStr(cont) + ' de ' + IntToStr(slArquivo.Count), lbl_message_process);
          cont := cont + 1;
        end
        else
        begin
        fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Sucesso',
                         'O arquivo não tem o formato padrão definido pelo sistema!',
                         ExtractFilePath(Application.ExeName)+'\icones\info.png', 'OK');
          exit;
        end;

        progress_bar.Progress := progress_bar.Progress + 1;
      end;
    finally
      mostrarMensageLabel('Processo finalizado, o processo levou ' + FormatDateTime('hh:nn:ss', FtempoInicial - now) + ' até seu terminio', lbl_message_process);
      FreeAndNil(slLinha);
      FreeAndNil(slArquivo);
      FtempoInicial := 0;
      Memo2.Lines.Add('Arquivo: '+ ExtractFileName(buscaArquivo.FileName));
      iLogs(dmConexao.fdQrLogin.FieldByName('id').AsString, 'Importou arquivo: '+
            ExtractFileName(buscaArquivo.FileName)+' Prmio: '+cbPremio.Text,
            'FormImportacao');

      fnc_criar_mensagem('CONFIRMAÇÃO',
                         'Sucesso',
                         'Dados importado com sucesso!',
                         ExtractFilePath(Application.ExeName)+'\icones\success.png', 'OK');
    end;
  end;

end;

function Tfimportacao.ExtractName(const FileName: String): String;
var
  aExt: String;
  aPos: Integer;
begin
  aExt := ExtractFileExt(FileName);
  Result := ExtractFileName(FileName);
  if aExt <> '' then
  begin
    aPos := Pos(aExt, Result);
    if aPos > 0 then
    begin
      Delete(Result, aPos, Length(aExt));
    end;
  end;
end;

procedure Tfimportacao.FormActivate(Sender: TObject);
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

     pnl_fundo.Left := Round((fimportacao.Width - pnl_fundo.Width) / 2);
    pnl_fundo.top := Round((fimportacao.Height - pnl_fundo.Height) / 2);
end;

procedure Tfimportacao.FormCreate(Sender: TObject);
begin
  lbl_message_process.Caption := '';
  lbl_processo_finalizado.Caption := '';
  Memo1.Clear;
end;

procedure Tfimportacao.FormDestroy(Sender: TObject);
begin
   //Form1.conexaoAcess.Close;
end;

procedure Tfimportacao.img_close_sistemaClick(Sender: TObject);
begin
  Close;
end;

function Tfimportacao.importDataFileToMemoCount(FileName: string): Integer;
var
  memoTemp: TMemo;
  arq: TextFile; { declarando a variável "arq" do tipo arquivo texto }
  linha: String;
  cont: Integer;
begin
  memoTemp := TMemo.create(nil);
  with memoTemp do
  begin
    Parent := fimportacao;
    Visible := False;
    memoTemp.Clear;

    AssignFile(arq, FileName);
{$I-}         // desativa a diretiva de Input
    Reset(arq); // [ 3 ] Abre o arquivo texto para leitura
{$I+}
    if (IOResult <> 0) // verifica o resultado da operação de abertura
    then
      Application.MessageBox('Erro na abertura do arquivo !!!', 'ecosta',
        MB_OK + MB_ICONINFORMATION)
    else
    begin
      // [ 11 ] verifica se o ponteiro de arquivo atingiu a marca de final de arquivo
      while (not Eof(arq)) do
      begin
        readln(arq, linha); // [ 6 ] Lê uma linha do arquivo
        cont := cont + 1;
      end;
      CloseFile(arq); // [ 8 ] Fecha o arquivo texto aberto
    end;
  end;

  Result := cont;
end;

function Tfimportacao.ReadFileData(FileName: string): String;
var
  xfile: TextFile; { declarando a variável "arq" do tipo arquivo texto }
begin
  AssignFile(xfile, FileName);
{$I-}         // desativa a diretiva de Input
  Reset(xfile); // [ 3 ] Abre o arquivo texto para leitura
{$I+}
  if (IOResult <> 0) // verifica o resultado da operação de abertura
  then
    Application.MessageBox('Erro na abertura do arquivo !!!', 'ecosta',
      MB_OK + MB_ICONINFORMATION)
  else
  begin
    CloseFile(xfile); // [ 8 ] Fecha o arquivo texto aberto
    Result := '';
  end;
end;

end.
