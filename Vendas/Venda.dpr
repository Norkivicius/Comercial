program Venda;

uses
  Vcl.Forms,
  uFrmVendas in 'uFrmVendas.pas' {FrmVendas},
  ufrmItens in 'ufrmItens.pas' {FrmItens},
  uFrmFinalizaVenda in 'uFrmFinalizaVenda.pas' {frmFinalizaVenda},
  uDM in '..\ClientWin32\Modules\uDM.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmVendas, FrmVendas);
  Application.CreateForm(TFrmItens, FrmItens);
  Application.CreateForm(TfrmFinalizaVenda, frmFinalizaVenda);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
