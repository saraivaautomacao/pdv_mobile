unit UnitBuscaCliente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit,
  FireDAC.Comp.Client, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,uloading;

type
  TExecuteOnClose = procedure(id_cliente:integer;nome:string) of Object;
  //TBuscaCliente = procedure(busca: string) of Object;

  TFrmBuscaCliente = class(TForm)
    rectToolbar: TRectangle;
    Label2: TLabel;
    lvCliente: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    img_voltar: TImage;
    procedure lvClienteItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure img_voltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FExecuteOnClose: TExecuteOnClose;
    procedure AddCliente(id_cliente: integer; nome: string);
    procedure ListarClientes(busca: string);
    procedure ListarBanco(busca: string);
    procedure ThreadCargaTerminate(Sender: TObject);
    procedure CargaCliente;
    { Private declarations }
  public
    ExecuteOnClose: TExecuteOnClose;
    //BuscaCliente: TBuscaCliente;
    Qry: TFDQuery;
    //property ExecuteOnClose: TExecuteOnClose read FExecuteOnClose write FExecuteOnClose;
  end;

var
  FrmBuscaCliente: TFrmBuscaCliente;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}

uses udmLocal;

procedure TFrmBuscaCliente.ListarBanco(busca: string);
begin
    with Qry do
    begin
        Active := false;
        SQL.Clear;
        SQL.Add('select id_cliente, nome from tab_cliente');
        SQL.Add('where id_cliente > 0');

        if busca <> '' then
        begin
            SQL.Add('and nome like :nome');
            ParamByName('nome').Value := '%' + busca + '%';
        end;

        SQL.Add('order by nome');
        Active := true;
    end;
end;

procedure TFrmBuscaCliente.AddCliente(id_cliente: integer; nome: string);
var
    item: TListViewItem;
begin
    try
        item := lvCliente.Items.Add;

        with item do
        begin
            Height := 50;
            Tag := id_cliente;
            TagString := nome;

            // Cliente...
            TListItemText(Objects.FindDrawable('txtCliente')).Text := nome;
        end;

    except on ex:exception do
        showmessage('Erro ao inserir cliente na lista: ' + ex.Message);
    end;
end;

procedure TFrmBuscaCliente.ListarClientes(busca: string);
begin
end;

procedure TFrmBuscaCliente.lvClienteItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
   ExecuteOnClose(AItem.Tag, AItem.TagString);
    close;
end;

procedure TFrmBuscaCliente.ThreadCargaTerminate(Sender: TObject);
begin
   lvCliente.EndUpdate;
   TLoading.Hide;
   if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

end;
procedure TFrmBuscaCliente.CargaCliente;

var t:TThread;
begin
    lvCliente.BeginUpdate;
    lvCliente.Items.Clear;
    TLoading.Show(FrmBuscaCliente, 'Carregando...'); // Thread

   // try
     t := TThread.CreateAnonymousThread(procedure
    begin

    var qry:TFdQuery:=TFDQuery.Create(nil);
      try
           qry.Connection:=dmLocal.conLocal;
           qry.open('select * from cliente order by nome');
           TThread.Synchronize(TThread.CurrentThread, procedure
            begin
                while NOT qry.eof do
                begin
                    AddCliente(qry.fieldbyname('codigo').asinteger,
                             qry.fieldbyname('nome').asstring);

                   qry.next;
                end;
              end);
      finally
        qry.close;
        qry.DisposeOf;

      end;
    end);
   // except on ex:exception do
  //      showmessage('Erro ao buscar clientes: ' + ex.Message);
   // end;

    t.OnTerminate := ThreadCargaTerminate;
    t.Start;

end;

procedure TFrmBuscaCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := TCloseAction.caFree;
    FrmBuscaCliente:= nil;
    FrmBuscaCliente.DisposeOf;
end;

procedure TFrmBuscaCliente.FormShow(Sender: TObject);
begin

CargaCliente;
end;

procedure TFrmBuscaCliente.img_voltarClick(Sender: TObject);
begin
  close;
end;

end.
