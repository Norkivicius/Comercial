unit uFrmAcesso;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmModelo, Data.DB, Vcl.ActnList,
  Vcl.Menus, Vcl.ImgList, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.DBCtrls;

type
  TFrmAcesso = class(TfrmModelo)
    Label3: TLabel;
    Label4: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    DBComboBox1: TDBComboBox;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    procedure FormShow(Sender: TObject);
    procedure ac_SalvarExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAcesso: TFrmAcesso;

implementation

uses
  uDM, Data.DBXCommon;

{$R *.dfm}

procedure TFrmAcesso.ac_SalvarExecute(Sender: TObject);
begin
  inherited;
  FormShow(Self);
end;

procedure TFrmAcesso.FormShow(Sender: TObject);
var
  DbCon: TDBXConnection;
  Command: TDBXCommand;
  Reader : TDBXReader;
begin
  inherited;

  DbCon := TDBXConnectionFactory.GetConnectionFactory.GetConnection('DBVENDAS.FDB', 'SYSDBA', 'masterkey');
  Command := DbCon.CreateCommand;
  Command.Text := 'SELECT DISTINCT FORMUALARIO FROM ACESSOS ';
  Reader := Command.ExecuteQuery;

  while Reader.Next do
  begin
    DBComboBox1.Items.Add(Reader.Value[0].GetAnsiString)
  end;
end;
end.
