unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.TabControl,
  Rest.Types,data.db, FMX.Ani, FMX.Effects,uFancyDialog, System.Actions,
  FMX.ActnList;

type
  TFrmLogin = class(TForm)
    Rectangle1: TRectangle;
    lbl_titulo: TLabel;
    Layout1: TLayout;
    edt_usuario: TEdit;
    rect_login: TRectangle;
    Label3: TLabel;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabConfig: TTabItem;
    Layout2: TLayout;
    Label4: TLabel;
    edt_servidor: TEdit;
    rect_save_config: TRectangle;
    Label5: TLabel;
    laBtnConfiguracao: TLayout;
    Image3: TImage;
    ShadowEffect4: TShadowEffect;
    Label32: TLabel;
    FloatAnimation4: TFloatAnimation;
    edt_port: TEdit;
    lblPorta: TLabel;
    btnVoltar: TButton;
    procedure rect_loginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rect_save_configClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure laBtnConfiguracaoClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fancy : TFancyDialog;
    function Verifica_Server: boolean;
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}

uses udmLocal,configvo,NetworkState , ufrprodutos;

procedure TFrmLogin.btnVoltarClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(0, TTabTransition.Slide);
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmLogin := nil;
    frmLogin.DisposeOf;
    fancy.DisposeOf;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
fancy := TFancyDialog.Create(frmProdutos);
end;

procedure TFrmLogin.FormShow(Sender: TObject);
var
  tmpDataset:TDataset;
begin
     try
      dmLocal.conLocal.ExecSQL('Select ip,porta,autorizado from config',tmpDataset);
      Config:=TConfigvo.create;
      config.Ip:=tmpDataset.FieldByName('ip').AsString;
      config.Porta:=tmpDataset.FieldByName('porta').AsString;
      config.url:='http://'+config.Ip+':'+config.porta+'/dist';

      if config.ip<>emptyStr then
      begin
          TabControl.ActiveTab := TabLogin;
          edt_servidor.Text := tmpDataset.FieldByName('ip').AsString;
          edt_port.text:=tmpDataset.FieldByName('porta').AsString;
      end
      else
      begin
          lbl_titulo.Text := 'Configurações';
          TabControl.ActiveTab := TabConfig;
          edt_port.text:='9000';
      end;
       fancy := TFancyDialog.Create(FrmLogin);
  finally
    FreeAndNil(tmpDataset);
  end;
end;

procedure TFrmLogin.laBtnConfiguracaoClick(Sender: TObject);
begin
 TabControl.GotoVisibleTab(1, TTabTransition.Slide);
    lbl_titulo.Text := 'Configurações';
end;

function TFrmLogin.Verifica_Server: boolean;
begin
result:=false;
try
//ClientModule1.DSRestConnection1.TestConnection();
result:=true;

except
result:=false;

end;
end;


procedure TFrmLogin.rect_loginClick(Sender: TObject);

begin

    if  trim(edt_usuario.text)=emptystr then
    begin
        fancy.Show(TIconDialog.Warning, 'Aviso','Informe usuario', 'OK');
        exit;
    end;
    if Uppercase(edt_usuario.Text)<>'MASTER' then
    begin
        Var  tmpDataset:TDataset;
        dmLocal.conLocal.ExecSQL('select codvend,cognome,senha from vendedor where cognome='+
        quotedStr(uppercase(edt_usuario.text)),tmpDataset);
        if tmpDataset.IsEmpty  then
         begin
             fancy.Show(TIconDialog.Warning, 'Aviso','Usuario Incorreto', 'OK');
             exit;
         end;
         udmLocal.CodigoVEndedor:=tmpDAtaset.FieldByName('codvend').AsString;
    end;
    var  NS: TNetworkState:=TNetworkState.create;
    try
      if not  NS.IsWifiConnected then
      begin
          fancy.Show(TIconDialog.Warning, 'Sem WiFi','Aviso', 'OK');
          exit;
      end;
    finally
      ns.disposeof;
    end;



   dmlocal.memPedido.Close;
   If not assigned(frmProdutos) then
       Application.CreateForm(TfrmProdutos,frmProdutos);
  
   frmProdutos.show;
end;
procedure TFrmLogin.rect_save_configClick(Sender: TObject);
begin
    if edt_servidor.Text = '' then
    begin

        fancy.Show(TIconDialog.Warning, 'Aviso','Informe o servidor', 'OK');
        exit;
    end;

    dmLocal.conLocal.ExecSQL('delete from config');

    dmLocal.conLocal.ExecSQL('insert into config (ip,porta) '+
    ' values '+
    '(:ip,:porta)',
    [
     edt_servidor.Text,
     edt_port.text
    ]
    );
    TabControl.GotoVisibleTab(0, TTabTransition.Slide);
    lbl_titulo.Text := 'Acesso';
    config.Ip:=edt_servidor.Text;
    config.porta:=edt_port.text;
    config.url:='http://'+config.Ip+':'+config.porta+'/dist';
end;

procedure TFrmLogin.TabControlChange(Sender: TObject);
begin
   btnVoltar.Visible:= TabControl.ActiveTab=TabConfig;

end;

end.
