unit ufrFormaPagamentos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.EditBox, FMX.NumberBox, FMX.ListBox, FMX.Controls.Presentation,
  FMX.Objects, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Layouts, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.DBScope, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,uFancyDialog, FMX.Ani;

type
  TfrmFormaPagamento = class(TForm)
    recFormaPgto: TRectangle;
    Label4: TLabel;
    cbxFormaPgto: TComboBox;
    edtRecebido: TNumberBox;
    SpeedButton2: TSpeedButton;
    Layout1: TLayout;
    ListView1: TListView;
    Rectangle1: TRectangle;
    BindSourceDB1: TBindSourceDB;
    rectHeader: TRectangle;
    img_voltar: TImage;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    Label1: TLabel;
    lblTotalPagar: TLabel;
    lblTotalRecebido: TLabel;
    Label2: TLabel;
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure edtRecebidoTyping(Sender: TObject);
    procedure cbxFormaPgtoClosePopup(Sender: TObject);
    procedure img_voltarClick(Sender: TObject);
  private
    { Private declarations }
     fancy : TFancyDialog;
     function  totalRecebido:Extended;
  public
    { Public declarations }
    TotalPagar:extended;
  end;

var
  frmFormaPagamento: TfrmFormaPagamento;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}

uses udmLocal, ufrprodutos;

procedure TfrmFormaPagamento.cbxFormaPgtoClosePopup(Sender: TObject);
begin
 edtRecebido.Visible:=true;
 edtRecebido.ReadOnly:=false;
 if dmLocal.qryFin.locate('finalizadora',cbxFormaPgto.text) then
 begin
    if dmlocal.qryFinparcelar.asstring='S' then
    begin
       //edtRecebido.ReadOnly:=true;
       edtRecebido.value:=totalpagar;
       exit;
    end;

 end;
 edtRecebido.value:=totalpagar-totalRecebido;
end;

procedure TfrmFormaPagamento.edtRecebidoTyping(Sender: TObject);
begin
   edtRecebido.text := StringReplace(edtRecebido.text , '.', '', [rfReplaceAll]);
end;

procedure TfrmFormaPagamento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   fancy.DisposeOf;
   Action := TCloseAction.caFree;
   frmFormaPagamento:= nil;
   frmFormaPagamento.DisposeOf;
end;

procedure TfrmFormaPagamento.FormCreate(Sender: TObject);
begin
 fancy := TFancyDialog.Create(frmFormaPagamento);


end;

procedure TfrmFormaPagamento.FormShow(Sender: TObject);
begin

       dmLocal.qryFin.open;
       cbxFormaPgto.Items.Clear;
       dmLocal.qryFin.first;
       while not dmLocal.qryFin.eof do
       begin
         cbxFormaPgto.Items.Add( dmLocal.qryFinfinalizadora.asstring) ;
         dmLocal.qryFin.next;
       end;
      lblTotalPagar.text:=FloatToStrf(TotalPagar,ffcurrency,12,2);
      lblTotalRecebido.text:=FloattoStrf( totalrecebido,ffcurrency,12,2);


end;

procedure TfrmFormaPagamento.img_voltarClick(Sender: TObject);
begin
   frmProdutos.lblPAgo.text:=floattostrf(totalRecebido,ffFixed,12,2);
   close;
end;

procedure TfrmFormaPagamento.SpeedButton2Click(Sender: TObject);
begin
   if cbxFormaPgto.ItemIndex=-1 then
    begin
        fancy.Show(TIconDialog.Info, 'Informacao','Informar forma pagamento',  'OK');
        abort;
    end;
    //para venda parcela nao aceita multiplas forma dde pagamento    ,
    dmlocal.qryFin.locate('finalizadora',cbxFormaPgto.text);
    if dmlocal.qryFinparcelar.asstring='S' then
    begin
        dmlocal.qryFin.first;
        while not dmlocal.qryFin.eof do
        begin
          dmlocal.qryFin.edit;
          dmlocal.qryFinvalor.ascurrency:=0;
          dmlocal.qryFin.post;
          dmlocal.qryFin.next;
        end;
        dmlocal.qryFin.locate('finalizadora',cbxFormaPgto.text);
        dmlocal.qryFin.edit;
        if edtRecebido.text.ToExtended()=0 then
            dmlocal.qryFinvalor.ascurrency:=0
        Else
           dmlocal.qryFinvalor.ascurrency:=totalpagar;
        dmlocal.qryFin.post;
    end
    else
    begin

       if totalpagar>=(abs(totalrecebido-edtrecebido.value)) then
       begin
        dmLocal.qryFin.locate('finalizadora',cbxFormaPgto.text);
        dmLocal.qryFin.edit;
        dmLocal.qryFinvalor.ascurrency:=edtRecebido.text.ToExtended();
        dmLocal.qryFin.post;
       end;
    end;
  edtrecebido.visible:=false;
  lblTotalRecebido.text:=FloatToStrf(TotalRecebido,ffcurrency,12,2);
  cbxFormaPgto.ItemIndex:=-1;


end;

function TfrmFormaPagamento.totalRecebido: Extended;
begin
    with dmlocal do
    begin
        qryfin.first;
        result:=0;
        while not qryfin.eof do
        begin
           result:=result+qryFinvalor.ascurrency;
           qryfin.next;
        end;
    end;
end;


end.
