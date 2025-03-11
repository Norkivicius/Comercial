unit uDM;

interface

uses
  SysUtils, Classes, WideStrings, DB, SqlExpr, FMTBcd, DBClient,
  Provider, TConnect, Data.DBXFirebird;

type
  TDM = class(TDataModule)
    sdsCliente: TSQLDataSet;
    DspCliente: TDataSetProvider;
    cdsClientes: TClientDataSet;
    sdsProduto: TSQLDataSet;
    DspProduto: TDataSetProvider;
    cdsProdutos: TClientDataSet;
    sdsUsuario: TSQLDataSet;
    dspUsuario: TDataSetProvider;
    cdsUsuarios: TClientDataSet;
    sdsPerfil: TSQLDataSet;
    DspPerfil: TDataSetProvider;
    cdsPerfil: TClientDataSet;
    sdsVendas: TSQLDataSet;
    DspVendas: TDataSetProvider;
    cdsVendas: TClientDataSet;
    DBAcesso: TSQLConnection;
    cdsVendasVENDAID: TIntegerField;
    cdsVendasCLIENTEID: TIntegerField;
    cdsVendasUSUARIOID: TIntegerField;
    cdsVendasDATA: TDateField;
    sdsPerfilConf: TSQLDataSet;
    DsPerfil_PerfilConf: TDataSource;
    cdsPerfilConf: TClientDataSet;
    sdsItens: TSQLDataSet;
    DsVenda_Itens: TDataSource;
    cdsVendassdsItens: TDataSetField;
    cdsItens: TClientDataSet;
    cdsProdutosPRODUTOID: TIntegerField;
    cdsProdutosDESCRICAO: TStringField;
    cdsProdutosESTOQUE: TFloatField;
    cdsProdutosPRECO: TFloatField;
    cdsClientesCLIENTEID: TIntegerField;
    cdsClientesNOME: TStringField;
    cdsClientesENDERECO: TStringField;
    cdsClientesBAIRRO: TStringField;
    cdsClientesCIDADE: TStringField;
    cdsClientesCEP: TStringField;
    cdsClientesUF: TStringField;
    cdsClientesEMAIL: TStringField;
    cdsClientesTELEFONE: TStringField;
    cdsPerfilNOME: TStringField;
    cdsPerfilDESCRICAO: TStringField;
    cdsPerfilPERFILID: TIntegerField;
    cdsPerfilsdsPerfilConf: TDataSetField;
    cdsPerfilConfNAME: TStringField;
    cdsPerfilConfCAPTION: TStringField;
    cdsPerfilConfPREMISSAO: TStringField;
    cdsPerfilConfPERFILID: TIntegerField;
    cdsUsuariosUSUARIOID: TIntegerField;
    cdsUsuariosPERFILID: TIntegerField;
    cdsUsuariosNOME: TStringField;
    cdsUsuariosEMAIL: TStringField;
    cdsUsuariosLOGIN: TStringField;
    cdsUsuariosSENHA: TStringField;
    cdsUsuariosVENDEDOR: TStringField;
    cdsUsuariosPerfil: TStringField;
    sdsAcesso: TSQLDataSet;
    DspAcesso: TDataSetProvider;
    cdsAcesso: TClientDataSet;
    cdsAcessoUSUARIOID: TIntegerField;
    cdsAcessoFORMULARIO: TStringField;
    cdsAcessoINCLUIR: TStringField;
    cdsAcessoEXCLUIR: TStringField;
    cdsAcessoALTERAR: TStringField;
    cdsAcessoCONSULTAR: TStringField;
    cdsAcessoIMPRIMIR: TStringField;
    cdsAcessoUSUARIO: TStringField;
    sdsCategoria: TSQLDataSet;
    sdsFabricante: TSQLDataSet;
    DspCategoria: TDataSetProvider;
    DspFabricante: TDataSetProvider;
    cdsCategoria: TClientDataSet;
    cdsFabricante: TClientDataSet;
    sdsCategoriaCATEGORIAID: TIntegerField;
    sdsCategoriaDESCRICAO: TStringField;
    sdsFabricanteFABRICANTEID: TIntegerField;
    sdsFabricanteDESCRICAO: TStringField;
    cdsFabricanteFABRICANTEID: TIntegerField;
    cdsFabricanteDESCRICAO: TStringField;
    cdsCategoriaCATEGORIAID: TIntegerField;
    cdsCategoriaDESCRICAO: TStringField;
    cdsProdutosFABRICANTE: TIntegerField;
    cdsProdutosCATEGORIA: TIntegerField;
    cdsProdutosDESCCATEGORIA: TStringField;
    cdsProdutosDESCFABRICANTE: TStringField;
    sdsConsulta: TSQLDataSet;
    dspConsulta: TDataSetProvider;
    LocalConnection1: TLocalConnection;
    sdsConsultaPRODUTO: TIntegerField;
    sdsConsultaDESCRICAO: TStringField;
    sdsConsultaESTOQUE: TSingleField;
    sdsConsultaPRECO: TSingleField;
    sdsConsultaFABRICANTE: TStringField;
    sdsConsultaCATEGORIA: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    function GenID(tablename: String): Integer;
    procedure GetID(DataSet: TDataSet);
    procedure GetError(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

uses
  Dialogs;

{$R *.dfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Pred(ComponentCount) do
   if Components[I] is  TClientDataSet then
   begin
    TClientDataSet(Components[I]).OnNewRecord := GetID;
    TClientDataSet(Components[I]).OnReconcileError := GetError;
   end;
   cdsPerfilConf.OnNewRecord := nil;
   cdsItens.OnNewRecord      := nil;
   cdsAcesso.OnNewRecord     := nil;
end;

function TDM.GenID(tablename: String): Integer;
var
  Qry: TSQLQuery;
begin
  Qry := TSQLQuery.Create(Self);
  Qry.SQLConnection := DBAcesso;
  Qry.SQL.Add('SELECT GEN_ID(GEN_'+tablename+'_ID,1) FROM RDB$DATABASE');
  Qry.Open;
  Result := Qry.Fields[0].AsInteger; 
end;

procedure TDM.GetError(DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  showmessage('Um Erro Ocorreu ao tentar gravar o registro '+#13+
             'Mensagem Original '+E.Message);
end;

procedure TDM.GetID(DataSet: TDataSet);
begin
  DataSet.Fields[0].AsInteger := GenID(Copy(DataSet.Name,4));
end;

end.
