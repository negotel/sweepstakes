unit splashscren;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Samples.Gauges, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TfSplashScreen = class(TForm)
    ga_progress: TGauge;
    Label1: TLabel;
    StartupTimer: TTimer;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSplashScreen: TfSplashScreen;

implementation

{$R *.dfm}

procedure TfSplashScreen.FormCreate(Sender: TObject);
begin
  StartupTimer.Enabled := false;
  StartupTimer.Interval := 500; // can be changed to improve startup speed in later releases
end;

end.
