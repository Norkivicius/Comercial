unit uFrmCalendario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Buttons;

type
  TfrmCalendario = class(TForm)
    MonthCalendar1: TMonthCalendar;
    spbtnSair: TSpeedButton;
    procedure spbtnSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCalendario: TfrmCalendario;

implementation

{$R *.dfm}

procedure TfrmCalendario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmCalendario.spbtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
