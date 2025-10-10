program pedido;

uses
  System.StartUpCopy,
  FMX.Forms,
  udmLocal in 'udmLocal.pas' {dmLocal: TDataModule},
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  configVo in 'configVo.pas',
  NetworkState in 'NetworkState.pas',
  uFancyDialog in 'uFancyDialog.pas',
  controller.distribuidora in 'controller.distribuidora.pas',
  ufrprodutos in 'ufrprodutos.pas' {frmProdutos},
  UnitBuscaCliente in 'UnitBuscaCliente.pas' {FrmBuscaCliente},
  uLoading in 'uLoading.pas',
  ufrFormaPagamentos in 'ufrFormaPagamentos.pas' {frmFormaPagamento};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmLocal, dmLocal);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
