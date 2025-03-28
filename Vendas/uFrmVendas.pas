unit uFrmVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Data.DB, Datasnap.DBClient, Vcl.DBCtrls;

type
  TFrmVendas = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    edtCodigo: TLabeledEdit;
    edtDescricao: TLabeledEdit;
    edtCategoria: TLabeledEdit;
    edtFabricante: TLabeledEdit;
    BitBtn1: TBitBtn;
    DBGrid2: TDBGrid;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn4: TBitBtn;
    cdsConsultaProduto: TClientDataSet;
    dsConsultaProduto: TDataSource;
    cdsConsultaProdutoPRODUTO: TIntegerField;
    cdsConsultaProdutoDESCRICAO: TStringField;
    cdsConsultaProdutoESTOQUE: TSingleField;
    cdsConsultaProdutoPRECO: TSingleField;
    cdsConsultaProdutoFABRICANTE: TStringField;
    cdsConsultaProdutoCATEGORIA: TStringField;
    cdsItens: TClientDataSet;
    dsItens: TDataSource;
    cdsItensCodigo: TIntegerField;
    cdsItensDescricao: TStringField;
    cdsItensQuantidade: TFloatField;
    cdsItensPreco: TFloatField;
    cdsItensTotalItens: TAggregateField;
    cdsItensSubTotal: TAggregateField;
    cdsItensValorTotal: TFloatField;
    DBText1: TDBText;
    DBText2: TDBText;
    procedure BitBtn4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cdsItensCalcFields(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure ConsultaProduto;virtual;
  public
    { Public declarations }
  end;

var
  FrmVendas: TFrmVendas;

implementation

uses
  ufrmItens, uFrmFinalizaVenda, uDM;

{$R *.dfm}

procedure TFrmVendas.BitBtn1Click(Sender: TObject);
begin
  ConsultaProduto;
end;

procedure TFrmVendas.BitBtn3Click(Sender: TObject);
begin
  FrmFinalizaVenda := TFrmFinalizaVenda.create(Self);
  FrmFinalizaVenda.showmodal;
  FreeandNil(FrmFinalizaVenda);
end;

procedure TFrmVendas.BitBtn4Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmVendas.cdsItensCalcFields(DataSet: TDataSet);
begin
  cdsItensValorTotal.value := cdsItensQuantidade.Value * cdsItensPreco.Value;
end;

procedure TFrmVendas.ConsultaProduto;
var
  S: TStringList;
begin
  S := TStringList.create;
  S.add(' SELECT P.PRODUTOID PRODUTO, P.DESCRICAO, P.ESTOQUE, P.PRECO, F.DESCRICAO FABRICANTE, C.DESCRICAO CATEGORIA ');
  S.add(' FROM CATEGORIA C, FABRICANTE F, PRODUTOS P ');
  S.add(' WHERE P.CATEGORIA = C.CATEGORIAID AND ');
  S.add(' P.FABRICANTE = F.FABRICANTEID ');

  if edtCodigo.text <> emptyStr then
    S.add(' AND P.PRODUTOID = ' + edtCodigo.text);
  if edtDescricao.text <> emptyStr then
    S.add(' AND P.DESCRICAO LIKE ' + QuotedStr(edtDescricao.text + '%'));
  if edtFabricante.text <> emptyStr then
    S.add(' AND F.DESCRICAO LIKE ' + QuotedStr(edtfABRICANTE.text + '%'));
  if edtCategoria.text <> emptyStr then
    S.add(' AND C.DESCRICAO LIKE ' + QuotedStr(edtCategoria.text + '%'));

  cdsConsultaProduto.close;
  cdsConsultaProduto.commandtext := S.text;
  cdsConsultaProduto.open;

  FreeandNil(S);
end;

procedure TFrmVendas.DBGrid1DblClick(Sender: TObject);
begin
  frmItens.edtQuantidade.Text := '1';
  frmItens.edtPreco.Text := cdsConsultaProdutoPRECO.AsString;
  if frmItens.ShowModal = mrok then
  begin
    cdsItens.Append;
    cdsItensCodigo.Value        := cdsConsultaProdutoPRODUTO.Value;
    cdsItensDescricao.Value     := cdsConsultaProdutoDESCRICAO.Value;
    cdsItensQuantidade.AsString := frmItens.edtQuantidade.Text;
    cdsItensPreco.AsString      := frmItens.edtPreco.Text;
    cdsItens.Post;
  end;
end;

procedure TFrmVendas.FormCreate(Sender: TObject);
begin
  frmItens := TfrmItens.Create(Self);
end;

procedure TFrmVendas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F6: Close;
    VK_F2: ConsultaProduto;
  end;
end;

initialization
  RegisterClass(TFrmVendas);

end.
