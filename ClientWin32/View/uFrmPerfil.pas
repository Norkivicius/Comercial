unit uFrmPerfil;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmModelo, DB, ImgList, ActnList, Menus, Grids, DBGrids, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, ToolWin, Mask, DBCtrls;

type
  TTipoPermisao = (tpCheck, tpUnchek, TpInvert);

  TFrmPerfil = class(TFrmModelo)
    Label4: TLabel;
    DBEdit1: TDBEdit;
    Label5: TLabel;
    DBEdit2: TDBEdit;
    DBGrid2: TDBGrid;
    DsDetail: TDataSource;
    Panel2: TPanel;
    BtnCheck: TSpeedButton;
    BtnUncheck: TSpeedButton;
    BtnInvert: TSpeedButton;
    BtnDefault: TSpeedButton;
    Image1: TImage;
    ImgPermissao: TImageList;
    procedure BtnDefaultClick(Sender: TObject);
    procedure BtnCheckClick(Sender: TObject);
    procedure BtnUncheckClick(Sender: TObject);
    procedure BtnInvertClick(Sender: TObject);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure Ac_SalvarUpdate(Sender: TObject);
  private
    { Private declarations }
    FAcoes: TCustomActionList;
    procedure LoadDefaultActions;
    procedure ChangePermissao(TipoPermissao: TTipoPermisao);
  public
    constructor Create(AOwner: TComponent; ActionList: TCustomActionList);reintroduce;
    { Public declarations }
  end;

var
  FrmPerfil: TFrmPerfil;

implementation

uses uDM, DBClient;

{$R *.dfm}

{ TFrmPerfil }

procedure TFrmPerfil.Ac_SalvarUpdate(Sender: TObject);
begin
  inherited;
  BtnDefault.Enabled := TAction(Sender).Enabled;
  BtnCheck.Enabled := TAction(Sender).Enabled;
  BtnUncheck.Enabled := TAction(Sender).Enabled;
  BtnInvert.Enabled := TAction(Sender).Enabled;
end;

procedure TFrmPerfil.BtnCheckClick(Sender: TObject);
begin
  inherited;
  ChangePermissao(tpCheck);
end;

procedure TFrmPerfil.BtnDefaultClick(Sender: TObject);
begin
  inherited;
  LoadDefaultActions;
end;

procedure TFrmPerfil.BtnInvertClick(Sender: TObject);
begin
  inherited;
  ChangePermissao(TpInvert);
end;

procedure TFrmPerfil.BtnUncheckClick(Sender: TObject);
begin
  inherited;
  ChangePermissao(tpUnchek);
end;

procedure TFrmPerfil.ChangePermissao(TipoPermissao: TTipoPermisao);
begin
  with DsDetail.DataSet do
  begin
    if not IsEmpty then
    begin
      First;
      DisableControls;
      while not Eof do
      begin
        Edit;
        case tipopermissao of
          tpCheck:  FieldByName('PERMISSAO').AsString := 'V';
          tpUnchek: FieldByName('PERMISSAO').AsString := 'F';
          TpInvert: if FieldByName('PERMISSAO').AsString = 'V' then
                       FieldByName('PERMISSAO').AsString := 'F'
                    else
                       FieldByName('PERMISSAO').AsString := 'V';
        end;
        Post;
        Next;
      end;
      EnableControls;
    end;
  end;
end;

constructor TFrmPerfil.Create(AOwner: TComponent;
  ActionList: TCustomActionList);
begin
  inherited Create(AOwner);
  FAcoes := ActionList;
end;

procedure TFrmPerfil.DBGrid2CellClick(Column: TColumn);
begin
  inherited;
  if Column.FieldName = 'PERMISSAO' then
  begin
    DsDetail.DataSet.Edit;
    if Column.Field.AsString = 'V' then
      Column.Field.AsString := 'F'
    else
      Column.Field.AsString := 'V';
    DsDetail.DataSet.Post;
  end;
end;

procedure TFrmPerfil.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  if Column.FieldName = 'PERMISSAO' then
  Begin
    DBGrid2.Canvas.FillRect(Rect);
    ImgPermissao.Draw(DBGrid2.Canvas,rect.Left+10,Rect.top,-1);
    if Column.Field.AsString = 'V' then
      ImgPermissao.Draw(DBGrid2.Canvas,rect.Left+10,Rect.top,1)
    else
      ImgPermissao.Draw(DBGrid2.Canvas,rect.Left+10,Rect.top,0);
  End;
end;

procedure TFrmPerfil.LoadDefaultActions;
var
  I: Integer;
begin
  if DsDetail.DataSet.RecordCount > 0 then
  begin
    with DsDetail.DataSet do
    begin
      First;
      while not EOF do
        Delete;
      TClientDataSet(DsDetail.DataSet).ApplyUpdates(0);
    end;
  end;
  
  for I := 0 to Pred(FAcoes.ActionCount) do
  begin
    with DsDetail.DataSet do
    begin
      Append;
      FieldByName('NAME').AsString := TAction(FAcoes.Actions[I]).Name;
      FieldByName('CAPTION').AsString := TAction(FAcoes.Actions[I]).Caption;
      FieldByName('PERMISSAO').AsString := 'F';
      Post;
    end;
  end;
end;

end.
