unit UFrmFinalizaVenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, DB, DBClient;

type
  TFrmFinalizaVenda = class(TForm)
    EdtCliente: TLabeledEdit;
    DBGrid1: TDBGrid;
    EdtSenha: TLabeledEdit;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    DBText2: TDBText;
    CdsCliente: TClientDataSet;
    DsCliente: TDataSource;
    procedure EdtClienteChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmFinalizaVenda: TFrmFinalizaVenda;

implementation

uses uFrmVendas, uDM, DBXCommon;

{$R *.dfm}

procedure TFrmFinalizaVenda.BitBtn1Click(Sender: TObject);
var
  DBCon:   TDBXConnection;
  Command: TDBXCommand;
  Reader:  TDBXReader;
  IDUsu: Integer;
begin
  if EdtSenha.Text = EmptyStr then
  begin
    ShowMessage('Informe a Senha do Vendedor');
    EdtSenha.SetFocus;
    Exit;
  end;

  DBCon := TDBXConnectionFactory.GetConnectionFactory.GetConnection('DBVENDAS','SYSDBA','masterkey');
  Command := DBCon.CreateCommand;
  Command.Text := 'SELECT VENDEDOR, USUARIOID FROM USUARIOS WHERE SENHA = '+QuotedStr(EdtSenha.Text);
  Reader := Command.ExecuteQuery;
  if Reader.Next then
    if not (Reader.Value[0].GetAnsiString = 'S') then
    begin
      MessageDlg('A senha informada não permite realizar venda!!',mtWarning,[mbOK],0);
      EdtSenha.SetFocus;
      Exit;
    end
    else
      IDUsu := Reader.Value[1].GetInt32
  else
    MessageDlg('Senha Informada Inválida !!',mtWarning,[mbOK],0);

  if CdsCliente.IsEmpty then
  begin
    MessageDlg('Você deve selecionar um cliente !!',mtWarning,[mbOK],0);
    EdtCliente.SetFocus;
    EXIT;
  end;

  with DM do
  begin
    cdsVendas.Open;
    cdsVendas.Append;
    cdsVendasCLIENTEID.Value := self.cdsCliente.FieldByName('CLIENTEID').value;
    cdsVendasUSUARIOID.Value := IDUsu;
    cdsVendasDATA.Value      := Date;
    FrmVendas.CdsItens.First;
    while Not FrmVendas.CdsItens.Eof do
    begin
      cdsItens.Append;
      cdsItens.FieldByName('PRODUTOID').Value := FrmVendas.CdsItensCodigo.Value;
      cdsItens.FieldByName('QTDE').Value      := FrmVendas.CdsItensQuantidade.Value;
      cdsItens.FieldByName('PRECO').Value     := FrmVendas.CdsItensPreco.Value;
      cdsItens.Post;
      FrmVendas.CdsItens.Next;
    end;
    cdsVendas.ApplyUpdates(0);
    cdsVendas.Close;
    FrmVendas.CdsItens.EmptyDataSet;
    Close;
  end;
end;

procedure TFrmFinalizaVenda.EdtClienteChange(Sender: TObject);
Var
  S: TStringList;
begin
  try
    S := TStringList.Create;
    if EdtCliente.Text <> EmptyStr then
    begin
      CdsCliente.Close;
      S.Add(' SELECT C.CLIENTEID, C.NOME, C.ENDERECO, C. BAIRRO, C.TELEFONE ');
      S.Add('   FROM CLIENTES C ');
      S.Add('  WHERE C.NOME LIKE '+QuotedStr(EdtCliente.Text+'%'));
      CdsCliente.CommandText := S.Text;
      CdsCliente.Open;
    end;
  finally
    FreeAndNil(S);
  end;
end;

end.
