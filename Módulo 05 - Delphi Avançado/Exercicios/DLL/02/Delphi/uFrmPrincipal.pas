unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type

  TSoma = function (A: Double; B: Double): Double; stdcall;

  TfrmPrincipal = class(TForm)
    edtNumero1: TEdit;
    edtNumero2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnCalcular: TButton;
    lblResultado: TLabel;
    procedure btnCalcularClick(Sender: TObject);
  private
    { Private declarations }
    procedure ChamarDll;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  System.SysUtils;

{$R *.dfm}

procedure TfrmPrincipal.btnCalcularClick(Sender: TObject);
begin
  Self.ChamarDLL;
  lblResultado.Visible := True;
end;

//Consumindo DLL Explicitamente
procedure TfrmPrincipal.ChamarDll;
var
  xHandle: THandle;
  xSoma: TSoma;
  xResultado: Double;

  xNum1, xNum2: Double;
begin
  if not TryStrToFloat(edtNumero1.Text, xNum1) then
    raise Exception.Create('Valor para o n�mero 1 inv�lido!');

  if not TryStrToFloat(edtNumero2.Text, xNum2) then
    raise Exception.Create('Valor para o n�mero 2 inv�lido!');

  xHandle := LoadLibrary('MinhaDLL.dll');
  if xHandle > 0 then
  begin
    try
      @xSoma := GetProcAddress(xHandle, 'Somar');

      if @xSoma <> nil then
      begin
        xResultado := xSoma(xNum1, xNum2);
        lblResultado.Caption := xResultado.ToString;
      end
      else
        ShowMessage('N�o foi poss�vel carregar o procedimento da DLL.');
    finally
      FreeLibrary(xHandle);
    end;
  end
  else
    ShowMessage('N�o foi poss�vel carregar a DLL.');
end;

end.
