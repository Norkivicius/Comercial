unit ufrmItens;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFrmItens = class(TForm)
    edtQuantidade: TLabeledEdit;
    edtPreco: TLabeledEdit;
    BitBtn1: TBitBtn;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmItens: TFrmItens;

implementation

{$R *.dfm}

procedure TFrmItens.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    ModalResult := mrCancel;
end;

end.
