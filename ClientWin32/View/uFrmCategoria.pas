unit uFrmCategoria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmModelo, DB, ImgList, ActnList, Menus, Grids, DBGrids, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, ToolWin, Mask, DBCtrls;

type
  TFrmCategoria = class(TFrmModelo)
    Label4: TLabel;
    DBEdit1: TDBEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCategoria: TFrmCategoria;

implementation

uses uDM;

{$R *.dfm}

end.
