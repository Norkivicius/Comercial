unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnList, Vcl.ActnMan, Vcl.ToolWin,
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.Menus, Vcl.CustomizeDlg,
  Vcl.ExtCtrls, Vcl.ActnColorMaps, Vcl.StdStyleActnCtrls;

type
  TFrmPrincipal = class(TForm)
    Acoes: TActionManager;
    Imagens: TImageList;
    ac_Clientes: TAction;
    ac_Produtos: TAction;
    ac_Usuarios: TAction;
    ac_Sair: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    ac_Ajuda: TAction;
    ac_Sobre_Sistema: TAction;
    ac_movimento_diario: TAction;
    ac_PDV: TAction;
    ac_lista_clientes: TAction;
    ac_Vendas_dias: TAction;
    ac_bloco_notas: TAction;
    ac_calculadora: TAction;
    ac_calendario: TAction;
    ac_Internet: TAction;
    ac_logoff: TAction;
    ac_Perfil: TAction;
    BarraPadrao: TActionToolBar;
    PopupMenu1: TPopupMenu;
    CustomizeDlg1: TCustomizeDlg;
    Personalizar1: TMenuItem;
    XPColorMap1: TXPColorMap;
    Ac_Seguranca_AlterarSenha: TAction;
    AC_Seguranca_Controle_Acesso: TAction;
    procedure Personalizar1Click(Sender: TObject);
    procedure ac_ClientesExecute(Sender: TObject);
    procedure ac_ProdutosExecute(Sender: TObject);
    procedure ac_PerfilExecute(Sender: TObject);
    procedure ac_UsuariosExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Ac_Seguranca_AlterarSenhaExecute(Sender: TObject);
    procedure AC_Seguranca_Controle_AcessoExecute(Sender: TObject);
    procedure ac_bloco_notasExecute(Sender: TObject);
    procedure ac_calculadoraExecute(Sender: TObject);
    procedure ac_calendarioExecute(Sender: TObject);
    procedure ac_InternetExecute(Sender: TObject);
    procedure ac_PDVExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  uFrmClientes, uFrmProduto, uFrmPerfil, uFrmUsuario, uFrmLogin, uFrmChangePassWord, uFrmAcesso, uFrmCalendario, Winapi.ShellAPI;

{$R *.dfm}

procedure TFrmPrincipal.ac_bloco_notasExecute(Sender: TObject);
begin
  WinExec('NOTEPAD',SW_SHOWNORMAL);
end;

procedure TFrmPrincipal.ac_calculadoraExecute(Sender: TObject);
begin
  WinExec('CALC',SW_SHOWNORMAL);
end;

procedure TFrmPrincipal.ac_calendarioExecute(Sender: TObject);
begin
  frmCalendario := TfrmCalendario.Create(self);
  frmCalendario.ShowModal;
end;

procedure TFrmPrincipal.ac_ClientesExecute(Sender: TObject);
begin
  FrmClientes := TfrmClientes.Create(Self);
  FrmClientes.ShowModal;
  FreeAndNil(FrmClientes);
end;

procedure TFrmPrincipal.ac_InternetExecute(Sender: TObject);
begin
  ShellExecute(Application.Handle,'Open','http://www.google.com.br','','', SW_NORMAL);
end;

procedure TFrmPrincipal.ac_PDVExecute(Sender: TObject);
var
  H : HMODULE;
  PForm : TFormClass;
  Form: TForm;
begin
  if FileExists('Vendas.bpl') then
  begin
    H:= LoadPackage('Vendas.bpl');
    if H > 0 then
    begin
      Pform:= TFormClass(GetClass('TfrmVendas'));
      if Assigned(PForm) then
      begin
        Form := PForm.Create(nil);
        Form.ShowModal;
        FreeAndNil(Form);
        UnloadPackage(H);
      end
      else
        ShowMessage('Erro ao carregar Clase');
    end
    else
      ShowMessage('Erro ao carregar pacote');
  end
  else
  begin
    MessageDlg('Voc� n�o possui esse recurso entre em contato com o fabricante',mtWarning,[mbok],0)
  end;
//  FrmVendas := TFrmVendas.Create(Self);
//  FrmVendas.ShowModal;
//  FreeAndNil(FrmVendas);
end;

procedure TFrmPrincipal.ac_PerfilExecute(Sender: TObject);
begin
  FrmPerfil := TFrmPerfil.Create(Self, Acoes);
  FrmPerfil.ShowModal;
  FreeAndNil(FrmPerfil);
end;

procedure TFrmPrincipal.ac_ProdutosExecute(Sender: TObject);
begin
  FrmProduto := TfrmProduto.Create(Self);
  FrmProduto.ShowModal;
  FreeAndNil(FrmProduto);
end;

procedure TFrmPrincipal.Ac_Seguranca_AlterarSenhaExecute(Sender: TObject);
begin
  FrmChangePassWord := TFrmChangePassWord.Create(Self);
  FrmChangePassWord.ShowModal;
  FreeAndNil(FrmChangePassWord);
end;

procedure TFrmPrincipal.AC_Seguranca_Controle_AcessoExecute(Sender: TObject);
begin
  FrmAcesso:= TFrmAcesso.Create(self);
  FrmAcesso.ShowModal;
  FreeAndNil(FrmAcesso);
end;

procedure TFrmPrincipal.ac_UsuariosExecute(Sender: TObject);
begin
  FrmUsuario:= TFrmUsuario.Create(self);
  FrmUsuario.ShowModal;
  FreeAndNil(FrmUsuario);
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
//  frmLogin := TfrmLogin.Create(Self);
//  if frmLogin.ShowModal <> 1 then
//  begin
//    MessageDlg('Voc� n�o logou corretamente. A aplica��o ser� encerrada',mtInformation, mbOKCancel,0);
//    Application.Terminate;
//  end
//  else
//    FreeAndNil(frmLogin);
end;

procedure TFrmPrincipal.Personalizar1Click(Sender: TObject);
begin
  CustomizeDlg1.Show;
end;

end.
