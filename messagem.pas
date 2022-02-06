unit messagem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TfMensagem = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Panel2: TPanel;
    img_src: TImage;
    pnl_nao: TPanel;
    lbl_titulo_janela: TLabel;
    btn_nao: TSpeedButton;
    pnl_sim: TPanel;
    btn_sim: TSpeedButton;
    lbl_titulo_messagem: TLabel;
    lbl_mesagem: TLabel;
    procedure btn_naoClick(Sender: TObject);
    procedure btn_simClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    sTituloJanela, sTituloMSG, sMSG, sCaminhoIcone, sTipo : string;
    bRespostaMSG: Boolean;
  end;
var
  fMensagem: TfMensagem;

implementation
{$R *.dfm}

procedure TfMensagem.btn_naoClick(Sender: TObject);
begin
  bRespostaMSG := False;
  Close;
end;

procedure TfMensagem.btn_simClick(Sender: TObject);
begin
   bRespostaMSG := True;
  Close;
end;

procedure TfMensagem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfMensagem.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_RETURN then begin
      btn_simClick(Self);
    end else begin
      if Key = VK_ESCAPE then begin
         btn_naoClick(Self);
      end;
    end;
end;

procedure TfMensagem.FormShow(Sender: TObject);
begin
   bRespostaMSG := False;

   lbl_titulo_janela.Caption    := sTituloJanela;
   lbl_titulo_messagem.Caption  := sTituloMSG;
   lbl_mesagem.Caption          := sMSG;

   img_src.Picture.LoadFromFile(sCaminhoIcone);

   if sTipo = 'OK' then begin
      pnl_nao.Visible := False;
      btn_sim.Caption := 'OK ( ENTER )';
   end;
end;

end.
