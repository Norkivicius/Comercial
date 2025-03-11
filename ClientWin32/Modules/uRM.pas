unit uRM;

interface

uses
  System.SysUtils, System.Classes;

type
  TRM = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RM: TRM;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
