unit uFrmChangePassWord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, GIFImg;

type
  TFrmChangePassWord = class(TForm)
    EdtNovaSenha: TLabeledEdit;
    EdtSenhaAtual: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Image1: TImage;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmChangePassWord: TFrmChangePassWord;

implementation

uses uUsuario;

{$R *.dfm}

procedure TFrmChangePassWord.BitBtn1Click(Sender: TObject);
begin
 if Tusuario.GetInstance.ChangePassword(EdtSenhaAtual.Text,
                                     EdtNovaSenha.Text) then
 begin
   MessageDlg('Senha Alterada com Sucesso !!!!', mtInformation, [mbOK], 0);
 end
 else
 begin
   MessageDlg('Não foi possível alterar a senha. Tente novamente mais tarde !!!!', mtError, [mbOK], 0);
 end;
 Close;
end;

procedure TFrmChangePassWord.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

end.
