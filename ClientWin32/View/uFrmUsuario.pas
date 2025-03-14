unit uFrmUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmModelo, Data.DB, Vcl.ActnList,
  Vcl.Menus, Vcl.ImgList, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.DBCtrls, Vcl.Mask;

type
  TFrmUsuario = class(TfrmModelo)
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    DBLookupComboBox1: TDBLookupComboBox;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUsuario: TFrmUsuario;

implementation

uses
  uDM, uUsuario, Datasnap.DBClient;

{$R *.dfm}

procedure TFrmUsuario.FormCreate(Sender: TObject);
begin
  inherited;
  dsDados.DataSet.Close;
  if  TUsuario.GetInstance.IsMaster then

    TClientDataSet(dsDados.DataSet).CommandText := 'SELECT * FROM USUARIOS'
  else
    TClientDataSet(dsDados.DataSet).CommandText := Format('SELECT * FROM USUARIOS WHERE USUARIOID = %d',[Tusuario.GetInstance.ID]);

  dsDados.DataSet.Open;
end;

end.
