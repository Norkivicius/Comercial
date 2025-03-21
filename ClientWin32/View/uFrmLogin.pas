unit uFrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, GIFImg;

type
  TFrmLogin = class(TForm)
    EdtSenha: TLabeledEdit;
    EdtUsuario: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Image1: TImage;
    CheckBox1: TCheckBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses uUsuario, uFrmPrincipal, Registry;

{$R *.dfm}

procedure TFrmLogin.BitBtn1Click(Sender: TObject);
begin
  if not TUsuario.GetInstance.Login(EdtUsuario.Text,
                                EdtSenha.Text,
                                FrmPrincipal.Acoes) then
  begin
    ModalResult := mrOk;
  end
  else
  begin
    MessageDlg('Usu�rio ou senha inv�lidos. Por favor tente novamente!!!!',mtWarning,[mbOK],0);
  end;

end;

procedure TFrmLogin.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
