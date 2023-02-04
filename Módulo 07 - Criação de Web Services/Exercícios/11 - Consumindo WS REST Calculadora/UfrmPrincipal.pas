unit UfrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
  TOperacao = (opSomar, opSubtrair, opMultiplicar, opDividir);

  TfrmPrincipal = class(TForm)
    edtValor1: TEdit;
    edtValor2: TEdit;
    cmbOperacao: TComboBox;
    btnCalcular: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblResultado: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure btnCalcularClick(Sender: TObject);
  private
    { Private declarations }
    procedure Calcular;
    procedure TratarResultado;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

const
  SUCESSO = 200;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnCalcularClick(Sender: TObject);
begin
  Self.Calcular;
end;

procedure TfrmPrincipal.Calcular;
var
  xValor1, xValor2: Double;
begin
  if not TryStrToFloat(edtValor1.Text, xValor1) then
    raise Exception.Create('Valor 1 Inv�lido!');

  if not TryStrToFloat(edtValor2.Text, xValor2) then
    raise Exception.Create('Valor 2 Inv�lido!');

  case TOperacao(cmbOperacao.ItemIndex) of
    opSomar:
      RESTClient1.BaseURL :=
        Format('http://localhost:9090/somar/%f/%f', [xValor1, xValor2]);
    opSubtrair:
      RESTClient1.BaseURL :=
        Format('http://localhost:9090/subtrair/%f/%f', [xValor1, xValor2]);
    opMultiplicar:
      RESTClient1.BaseURL :=
        Format('http://localhost:9090/multiplicar/%f/%f', [xValor1, xValor2]);
    opDividir:
      RESTClient1.BaseURL :=
        Format('http://localhost:9090/dividir/%f/%f', [xValor1, xValor2]);
  end;

  RESTRequest1.Execute;
  Self.TratarResultado;
end;

procedure TfrmPrincipal.TratarResultado;
begin
  if RESTResponse1.StatusCode = SUCESSO then
    lblResultado.Caption := RESTResponse1.Content
  else
    lblResultado.Caption := 'Erro: ' + RESTResponse1.Content;
end;

end.
