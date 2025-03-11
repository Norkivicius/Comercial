unit uUsuario;

interface

uses
  Vcl.ActnList, Data.DBXCommon;

type
  TPermissao = record
    Incluir : Boolean;
    Excluir : Boolean;
    Alterar : Boolean;
    Consultar : Boolean;
    Imprimir : Boolean;
  end;

  TUsuario = class
  private
    FID: Integer;
    FSenha: string;
    FLogin: string;
    FNome: string;
    FPerfilID: Integer;
    FLogado: Boolean;
    FAcoes: TcustomActionList;
    class var FInstance: TUsuario;
    constructor CreatePrivate;
    { private declarations }
  protected
    { protected declarations }
    function LoadProfile : Boolean; virtual;
  public
    { public declarations }
    constructor Create;
    function Login(AUsuario, ASenha : string; Acoes: TcustomActionList): Boolean;
    function GetPerfil : string;
    function GetPerfilDescrption : string;
    function ChangePassword(strOldPassword, strNewPassword: string): Boolean;
    function GetPermissao(AFormulario : String): TPermissao;
    function IsMaster : Boolean;
    class function GetInstance : TUsuario;

  published
    { published declarations }
    property  ID: Integer read FID;
    property  Nome: string read FNome;
    property  Usuario: string read FLogin;
    property  Senha: string read FSenha;
    property  PerfilID: Integer read FPerfilID;

  end;

implementation

uses
  System.SysUtils, Vcl.Dialogs;

{ TUsuario }

function TUsuario.ChangePassword(strOldPassword,strNewPassword: string): Boolean;
var
  DbCon  : TDBXConnection;
  Command: TDBXCommand;
  T      : TDBXTransaction;
begin
  if FLogado then
  begin
    if FSenha = strOldPassword then
    begin
      try
        DbCon := TDBXConnectionFactory.GetConnectionFactory.GetConnection('DBVENDAS','SYSDBA','masterkey');
        T := DbCon.BeginTransaction;
        Command := DbCon.CreateCommand;
        Command.Text := Format('UPDATE USUARIOS SET SENHA = %s WHERE USUARIO = %d ',[QuotedStr(strNewPassword),(FID)]);
        Command.ExecuteUpdate;
        DbCon.CommitFreeAndNil(T);
        Result:= True;
      except
        DbCon.RollbackFreeAndNil(T);
      end;
    end
    else
      MessageDlg('A senha antiga n�o confere',mtInformation,[mbOK],0);
  end;
end;

constructor TUsuario.Create;
begin
  raise Exception.Create('Para obeter a instancia TUsuarios use a fun��o TUsuario.getinstance!');
end;

constructor TUsuario.CreatePrivate;
begin
  inherited Create;
end;

class function TUsuario.GetInstance: TUsuario;
begin
  if not Assigned(FInstance) then
    FInstance := TUsuario.CreatePrivate;
  Result:= FInstance;
end;

function TUsuario.GetPerfil: string;
var
  DbCon: TDBXConnection;
  Command: TDBXCommand;
  Reader : TDBXReader;
begin
  if FLogado then
  begin
    DbCon := TDBXConnectionFactory.GetConnectionFactory.GetConnection('DBVENDAS','SYSDBA','masterkey');
    Command := DbCon.CreateCommand;
    Command.Text := Format('SELECT NOME FROM PERFIL WHERE PERFILID = %d ',[FPerfilID]);
    Reader := Command.ExecuteQuery;

    if Reader.Next then
    begin
      Result := Reader.Value[0].GetString;
    end
    else
      MessageDlg('� necess�rio estar logado para invocar esse m�todo !!',mtWarning,[mbOK],0);
  end;
end;

function TUsuario.GetPerfilDescrption: string;
var
  DbCon: TDBXConnection;
  Command: TDBXCommand;
  Reader : TDBXReader;
begin
  if FLogado then
  begin
    DbCon := TDBXConnectionFactory.GetConnectionFactory.GetConnection('DBVENDAS','SYSDBA','masterkey');
    Command := DbCon.CreateCommand;
    Command.Text := Format('SELECT DESCRICAO FROM PERFIL WHERE PERFILID = %d ',[FPerfilID]);
    Reader := Command.ExecuteQuery;

    if Reader.Next then
    begin
      Result := Reader.Value[0].GetString
    end
    else
      MessageDlg('� necess�rio estar logado para invocar esse m�todo !!',mtWarning,[mbOK],0);
  end;
end;

function TUsuario.GetPermissao(AFormulario: String): TPermissao;
var
  DbCon: TDBXConnection;
  Command: TDBXCommand;
  Reader : TDBXReader;
  Temp : TPermissao;
begin
  if FLogado then
  begin
    DbCon := TDBXConnectionFactory.GetConnectionFactory.GetConnection('DBVENDAS.FDB','SYSDBA','masterkey');
    Command := DbCon.CreateCommand;
    Command.Text := Format('SELECT INCLUIR,EXCLUIR, ALTERAR, CONSULTAR, IMPRIMIR FROM ACESSOS WHERE USUARIOID = %d  AND FORMULARIO = %s ',[FPerfilID, QuotedStr(Aformulario)]);
    Reader := Command.ExecuteQuery;

    if Reader.Next then
    begin
      Temp.Incluir   := Reader.Value[0].GetAnsiString = 'S';
      Temp.Excluir   := Reader.Value[1].GetAnsiString = 'S';
      Temp.Alterar   := Reader.Value[2].GetAnsiString = 'S';
      Temp.Consultar := Reader.Value[3].GetAnsiString = 'S';
      Temp.Imprimir  := Reader.Value[4].GetAnsiString = 'S';
    end
    else
    begin
      Temp.Incluir    := True;
      Temp.Excluir   := True;
      Temp.Alterar   := True;
      Temp.Consultar := True;
      Temp.Imprimir  := True;
    end;
    Result:= Temp;
  end
  else
    MessageDlg('� necess�rio estar logado para invocar esse m�todo !!',mtWarning,[mbOK],0);
end;

function TUsuario.IsMaster: Boolean;
var
  DbCon: TDBXConnection;
  Command: TDBXCommand;
  Reader : TDBXReader;
begin
  if FLogado then
  begin
    DbCon := TDBXConnectionFactory.GetConnectionFactory.GetConnection('DBVENDAS.FDB','SYSDBA','masterkey');
    Command := DbCon.CreateCommand;
    Command.Text := Format('SELECT MASTER FROM USUARIOS WHERE USUARIOID = %d ',[FPerfilID]);
    Reader := Command.ExecuteQuery;

    if Reader.Next then
    begin
      Result := Reader.Value[0].GetAnsiString = 'S';
    end;
  end;
end;

function TUsuario.LoadProfile: Boolean;
var
  DbCon: TDBXConnection;
  Command: TDBXCommand;
  Reader : TDBXReader;
  I: Integer;
  Nm, Pr : string;
begin
  if FLogado then
  begin
    DbCon := TDBXConnectionFactory.GetConnectionFactory.GetConnection('DBVENDAS.FDB','SYSDBA','masterkey');
    Command := DbCon.CreateCommand;
    Command.Text := Format('SELECT NAME, PERMISSAO FROM PERFIL_CONF WHERE PERFILID = %d ',[FPerfilID]);
    Reader := Command.ExecuteQuery;

    Nm := Reader.Value[0].GetAnsiString;
    Pr := Reader.Value[1].GetAnsiString;
    while Reader.Next do
    begin
      for I := 0 to Pred(FAcoes.ActionCount) do
        if TAction(FAcoes.Actions[I]).Name = Nm then
        begin
          TAction(FAcoes.Actions[I]).Enabled := 'V' = Pr;
          Break;
        end;
    end;
  end;
  Result := True;
end;

function TUsuario.Login(AUsuario, ASenha: string; Acoes: TcustomActionList): Boolean;
var
  DbCon: TDBXConnection;
  Command: TDBXCommand;
  Reader : TDBXReader;
//  I: Integer;
begin
  DbCon := TDBXConnectionFactory.GetConnectionFactory.GetConnection('DBVENDAS','SYSDBA','masterkey');
  Command := DbCon.CreateCommand;
  Command.Text := Format('SELECT * FROM USUARIOS WHERE LOGIN = %s AND SENHA = %s ',[QuotedStr(AUsuario),QuotedStr(ASenha)]);
  Reader := Command.ExecuteQuery;

  if Reader.Next then
  begin
//    for I := 0 to Reader.ColumnCount -1 do
//    begin
//      case Reader.ValueType[I].DataType of
//        TDBXDataTypes.AnsiStringType : reader.Value[I].GetAnsiString;
//        TDBXDataTypes.DateType       : reader.Value[I].GetDate;
//        TDBXDataTypes.Int32Type      : reader.Value[I].GetInt32;
//      end;
//    end;
    FID       := Reader.Value[0].GetInt32;
    FPerfilID := Reader.Value[0].GetInt32;
    FNome     := Reader.Value[0].GetString;
    FLogin    := Reader.Value[0].GetString;
    FSenha    := Reader.Value[0].GetString;
    FAcoes    := Acoes;
    FLogado   := True;
    if LoadProfile then
      Result:= True
    else
      MessageDlg('� necess�rio estar logado para invocar esse m�todo !!',mtWarning,[mbOK],0);
  end;
end;
end.
