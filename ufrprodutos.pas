unit ufrprodutos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Edit, FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,
  FMX.StdCtrls, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope,data.db, FMX.Ani,FMX.Platform, FMX.VirtualKeyboard,
  FMX.TabControl, FMX.Effects, FMX.ListBox,Data.FiredacJsonReflect,uFancyDialog,  FMX.SearchBox,
  FMX.Memo.Types, FMX.ScrollBox, FMX.EditBox, FMX.SpinBox, FMX.NumberBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,uloading;

type
  TfrmProdutos = class(TForm)
    tabPrincipal: TTabControl;
    tabPedido: TTabItem;
    tabFinalizar: TTabItem;
    rectHeader: TRectangle;
    img_voltar: TImage;
    Image1: TImage;
    lblQuant: TLabel;
    layTabProdutos: TLayout;
    lstVProdutos: TListView;
    rectTabelaPreco: TRectangle;
    lstbxTabPrecos: TListBox;
    lstbxDescItem: TListBoxItem;
    lstbxPreco1: TListBoxItem;
    lstbxPreco2: TListBoxItem;
    lstbxPreco3: TListBoxItem;
    lstbxPreco4: TListBoxItem;
    lstbxFinalizar: TListBoxItem;
    rdbPreco1: TRadioButton;
    rdbPreco2: TRadioButton;
    rdbPreco3: TRadioButton;
    rdbPreco4: TRadioButton;
    lstbxObservacao: TListBoxItem;
    edtObservacao: TEdit;
    Button1: TButton;
    SpeedButton1: TSpeedButton;
    lstvPedido: TListView;
    Button2: TButton;
    ToolBar1: TToolBar;
    rectObs: TRectangle;
    Button3: TButton;
    lblDescricao: TLabel;
    rectObs1: TRectangle;
    StyleBook1: TStyleBook;
    recPeso: TRectangle;
    lstbxPeso: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    edtPeso: TEdit;
    ListBoxItem7: TListBoxItem;
    btnConfirmaPeso: TSpeedButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    spinQuant: TSpinBox;
    lblTotal: TLabel;
    LinkPropertyToFieldText: TLinkPropertyToField;
    Button4: TButton;
    edtPreco: TNumberBox;
    lblPreco: TLabel;
    Label2: TLabel;
    rectCliente: TRectangle;
    Label3: TLabel;
    lblCliente: TLabel;
    Image2: TImage;
    cbxFormaPgto: TComboBox;
    Label5: TLabel;
    Label4: TLabel;
    imgCarga: TImage;
    FloatAnimation3: TFloatAnimation;
    Timer1: TTimer;
    procedure img_voltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstVProdutosButtonClick(const Sender: TObject;
      const AItem: TListItem; const AObject: TListItemSimpleControl);
    procedure Image1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Button4Click(Sender: TObject);
    procedure rectClienteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgCargaClick(Sender: TObject);
    procedure edtPrecoExit(Sender: TObject);
    procedure edtPrecoTyping(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
     precoUnit:Extended;
     DescResumida,id_produto:String;
     controleCarga:boolean;
     fancy : TFancyDialog;
      situacaocaixa:char; //A-aberto F-fechado I-Indefinido(sem contato server
      procedure SelecionarCliente(id_cliente:integer; nome: string);
     procedure carga;
    procedure ThreadCargaTerminate(Sender: TObject);
      procedure ThreadListaTerminate(Sender: TObject);
    function caixaAberto: Char;
    procedure AddCliente(produto, id_produto: string; preco: extended);
    procedure listaprodutos;
  public
    { Public declarations }
    numMesa:String;
  end;

var
  frmProdutos: TfrmProdutos;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

uses udmLocal,system.JSON,
controller.distribuidora, UnitBuscaCliente;

procedure TfrmProdutos.Button2Click(Sender: TObject);
begin
    if cbxFormaPgto.ItemIndex=-1 then
    begin
        fancy.Show(TIconDialog.Info, 'Informacao','Informar forma pagamento',  'OK');
        abort;
    end;
     var qry:TFdQuery:=TFDQuery.Create(nil);
     var objPed:TJSONObject:=TJSONObject.Create;
     try
         qry.Connection:=dmLocal.conLocal;
         qry.open('select * from finalizadora where finalizadora='+
        quotedstr(cbxFormaPgto.Items[cbxFormaPgto.ItemIndex]));
        if (lblCliente.Tag<=0) and  (qry.fieldbyname('PArcelar').asString='S') THEN
        begin
            fancy.Show(TIconDialog.Info, 'Informacao','Informar cliente',  'OK');
              exit;
        end;
        objped.AddPair('codigocliente',lblCliente.Tag.ToString);
        objped.AddPair('cliente',lblcliente.text);
        objped.AddPair('pagamento', qry.fieldbyname('id').asstring);
        objped.AddPair('codigovendedor',TJSONNumber.create(StrToInt(udmlocal.CodigoVendedor)));
        var arrayitems:=TJSONArray.Create;
        dmLocal.memPedido.First;
        while not dmlocal.memPedido.eof do
        begin
            var objItemPed:=TJSONObject.Create;
            objItemped.AddPair('lkprod',dmlocal.memPedidolkprod.asString);
            objItemped.AddPair('qtde', TJsonNumber.create(dmlocal.memPedidoqtde.Asextended));
            objItemped.AddPair('vrunit',TJsonNumber.create(dmlocal.memPedidovrunit.asextended));
            objItemped.AddPair('produto',dmlocal.memPedidoproduto.asString);
            objItemped.AddPair('item',TJsonNumber.create(dmlocal.memPedidoitem.asinteger));
            arrayitems.AddElement(objItemped);
            dmlocal.memPedido.next;
        end;

        objped.AddPair('itenspedido',arrayitems);
        var status:integer;
        var retorno:=
        TControllerDistribuidora.gerapedido(objped,status);
        if status<>200 then
        begin
           fancy.Show(TIconDialog.Error, 'Error',retorno,  'OK');
            abort;
        end;
        lblquant.Text:='0';
        dmlocal.memPedido.Close;
        dmlocal.memPedido.open;
        lblcliente.text:='Cliente Padrao';
        lblcliente.Tag:=0;
        cbxFormaPgto.ItemIndex:=-1;
        tabPrincipal.ActiveTab:=tabPedido;
      finally
        qry.close;
        qry.DisposeOf;

      end;
end;


procedure TfrmProdutos.Button3Click(Sender: TObject);
begin
      with dmlocal do
      begin
          if memPedido.locate('lkprod',
          id_produto)  Then
          begin
            if spinQuant.Value=0 then
            begin
                dmLocal.memPedido.Delete ;
                lblquant.Text:=inttostr(lblquant.Text.ToInteger-1);
                exit;
            end;

             memPedido.edit;
             memPedidoqtde.AsExtended:= spinQuant.Value;
             dmLocal.memPedidovrunit.Value:=edtPreco.Value;
             dmLocal.memPedidoTotal.AsCurrency:=memPedidovrunit.AsCurrency*memPedidoqtde.AsFloat;
             memPedido.post;
             //exit;
          end
          else
          begin
               if spinQuant.Value>0 Then
               begin
                   memPedido.Insert;
                  memPedidolkprod.AsString:=id_produto;
                  memPedidoqtde.AsExtended:=spinQuant.Value;
                  memPedidovrunit.AsCurrency:=edtPreco.Value;
                  memPedidoproduto.AsString:=lbldescricao.text;
                  memPedidoItem.AsInteger:=memPedido.RecordCount+1;
                  lblQuant.text:= IntToStr(lblQuant.text.ToInteger+1);
                  memPedidoTotal.AsCurrency:=memPedidovrunit.AsCurrency*memPedidoqtde.AsFloat;
                  memPedidoobservacao.asString:=edtObservacao.text;
                  mempedido.post;
               end;
          end;
      end;


  edtpreco.value:=0;
  spinQuant.Value:=0;
  rectobs1.Visible:=false;

end;


procedure TfrmProdutos.Button4Click(Sender: TObject);
begin
 // edtobsitem.text:='';
  rectobs1.Visible:=false;
end;

procedure TfrmProdutos.ThreadCargaTerminate(Sender: TObject);
begin

   lstVProdutos.EndUpdate;
   TLoading.Hide;

   controleCarga:=false;
   if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

end;

procedure TfrmProdutos.ThreadListaTerminate(Sender: TObject);
begin
   TLoading.Hide;
   lstVProdutos.EndUpdate;
  // FloatAnimation3.stop;
   if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

end;

procedure TfrmProdutos.Timer1Timer(Sender: TObject);
begin
    timer1.Enabled:=false;
    var qry:TFdQuery:=TFDQuery.Create(nil);
    try
       qry.Connection:=dmLocal.conLocal;
       cbxFormaPgto.Items.Clear;
       qry.open('select * from finalizadora');
        while not qry.eof do
       begin
         cbxFormaPgto.Items.Add( qry.fieldbyname('finalizadora').asstring) ;
         qry.next;
       end;
    finally
       qry.close;
       qry.disposeof;
    end;
    dmLocal.memPedido.open;

    lblQuant.text:=dmLocal.memPedido.RecordCount.ToString;
   for var I := 0 to Lstvprodutos.Controls.Count-1 do
    if Lstvprodutos.Controls[I] is TSearchBox then
    begin
      TSearchBox(Lstvprodutos.Controls[I]).Text := '';
      break;
    end;
    listaProdutos;


end;

procedure TfrmProdutos.carga;
var
    t: TThread;
    status:integer;


begin
    if controlecarga Then
       exit;
    controlecarga:=true;
    TLoading.Show(FrmProdutos, 'Atualizando...'); // Thread
    VAr query:=TFDQuery.Create(nil);
    query.Connection:=dmLocal.conLocal;
    Var memCarga:=TFDMemTable.Create(nil);


    t := TThread.CreateAnonymousThread(procedure
    begin
        try
          // FloatAnimation3.Start;
            With dmLocal do
            begin

               //produtos
             lstVProdutos.items.Clear;
             lstVProdutos.BeginUpdate;
              memCarga.AppendData(TControllerDistribuidora.Carga('produto',status));
              memCarga.First;
              query.SQL.Text:='delete from produto';
              query.ExecSQL;
              query.SQL.Text:='Insert into produto (codigo,produto,unidade,lksetor,precovenda) '+
              ' values  '+
              '(:codigo,:produto,:unidade,:lksetor,:precovenda)';
              TThread.Synchronize(TThread.CurrentThread, procedure
              begin
               while not memCarga.Eof do
               begin
                    query.ParamByName('codigo').AsString:=memCarga.FieldByName('codigo').AsString;
                    query.ParamByName('produto').AsString:=memCarga.FieldByName('produto').AsString;
                    query.ParamByName('unidade').AsString:=memCarga.FieldByName('unidade').AsString;
                    query.ParamByName('lksetor').AsInteger:=memCarga.FieldByName('lksetor').AsInteger;
                    query.ParamByName('precovenda').AsCurrency:=StrtocurrDef(memCarga.FieldByName('precovenda').AsString,0);
                    query.ExecSQL;
                    var item:TListViewItem:= lstvProdutos.Items.Add;
                    with item do
                    begin
                        Height := 50;
                        //Tag :=StrToInt64Def( id_produto,0);
                        TagString :=memCarga.FieldByName('codigo').AsString;
                        //TagFloat:=preco;
                        // Cliente...
                        TListItemText(Objects.FindDrawable('Text1')).Text := memCarga.FieldByName('produto').AsString;
                        TListItemText(Objects.FindDrawable('Text2')).Text :=memCarga.FieldByName('codigo').AsString;
                        TListItemText(Objects.FindDrawable('Text4')).Text := FloatToStrf(
                        memCarga.FieldByName('precovenda').asExtended,
                        ffnumber,12,2);
                    end;
                memCarga.Next;
                 end;
              end);

              memCarga.Close;
              memCarga.AppendData(TControllerDistribuidora.Carga('grupo',status));
              memCarga.First;
              query.SQL.Text:='delete from grupo';
              query.ExecSQL;
              query.SQL.Text:='Insert into grupo (controle,setor) values (:controle,:setor)';
              while not memCarga.Eof do
              begin
                query.ParamByName('controle').AsInteger:=memCarga.FieldByName('controle').AsInteger;
                query.ParamByName('setor').AsString:=memCarga.FieldByName('setor').AsString;
                query.ExecSQL;
                memCarga.Next;
              end;
              memCarga.Close;
              //vendedores
              query.SQL.Text:='delete from vendedor';
              query.ExecSQL;
              query.SQL.Text:='Insert into vendedor (codvend,cognome,senha)'+
              ' values '+
              '(:codvend,:cognome,:senha)';
              memCarga.AppendData(TControllerDistribuidora.Carga('vendedor',status));
              memCarga.First;
              while not memCarga.Eof do
              begin
                query.ParamByName('codvend').AsInteger:=memCarga.FieldByName('codvend').AsInteger;
                query.ParamByName('cognome').AsString:=uppercase(memCarga.FieldByName('cognome').AsString);
                query.ParamByName('senha').AsString:=memCarga.FieldByName('senha').AsString;
                query.ExecSQL;
                memCarga.Next;
              end;
              memCarga.Close;

              //clientes
              query.SQL.Text:='delete from cliente';
              query.ExecSQL;
              query.SQL.Text:='Insert into  cliente(codigo,nome)'+
              ' values '+
              '(:codigo,:nome)';
              memCarga.AppendData(TControllerDistribuidora.Carga('cliente',status));
              memCarga.First;
              while not memcarga.Eof do
              begin
                query.ParamByName('codigo').AsString:=memCarga.FieldByName('codigo').AsString;
                query.ParamByName('nome').AsString:=memCarga.FieldByName('nome').AsString;
                query.ExecSQL;
                memCarga.Next;
              end;
              memCarga.Close;

             //finalizadora
              query.SQL.Text:='delete from finalizadora';
              query.ExecSQL;
              query.SQL.Text:='Insert into  finalizadora (id,finalizadora,parcelar)'+
              ' values '+
              '(:id,:finalizadora,:parcelar)';
              memCarga.AppendData(TControllerDistribuidora.Carga('finalizadora',status));
              memCarga.First;
              while not memcarga.Eof do
              begin
                query.ParamByName('id').Asinteger:=memCarga.FieldByName('id').Asinteger;
                query.ParamByName('finalizadora').AsString:=memCarga.FieldByName('finalizadora').AsString;
                query.ParamByName('parcelar').AsString:=memCarga.FieldByName('parcelar').AsString;
                query.ExecSQL;
                memCarga.Next;
              end;
              memCarga.Close;
              cbxFormaPgto.Items.Clear;
              query.open('select * from finalizadora');
              while not query.eof do
              begin
                   cbxFormaPgto.Items.Add( query.fieldbyname('finalizadora').asstring) ;
                    query.next;
              end;

             end;

      finally
        memCarga.Close;
        query.close;
        query.disposeof;
        memcarga.disposeof;

       end;
     end);
   t.OnTerminate := ThreadCargaTerminate;
   t.Start;



end;

procedure TfrmProdutos.edtPrecoExit(Sender: TObject);
begin
edtpreco.Text := FormatFloat('#,##0.00', edtpreco.Value);
end;

procedure TfrmProdutos.edtPrecoTyping(Sender: TObject);
begin
 edtPreco.text := StringReplace(edtPreco.text , '.', '', [rfReplaceAll]);
end;

procedure TfrmProdutos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    frmProdutos:=nil;
    fancy.DisposeOf;
    dmLocal.memPedido.close;
    lblQuant.text:='0';
end;

procedure TfrmProdutos.FormCreate(Sender: TObject);
begin
   fancy := TFancyDialog.Create(frmProdutos);
end;

procedure TfrmProdutos.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  {$IFDEF ANDROID}
  if Key = vkReturn then
  begin
      Key := vkTab;
      KeyDown(Key, KeyChar, Shift);
  end;
 {$ENDIF}
  if Key = vkHardwareBack then
      key := 0;
end;


function TfrmProdutos.caixaAberto:Char;
begin
  var status:integer;
  var retorno:String:=TControllerdiSTRIBUIDORA.statuscaixa(status);
  if retorno='' then
     result:='I';
  if status=200 then
  begin
    var  JSONResponse:TjsonObject := TJSONObject.ParseJSONValue(retorno) as TJSONObject;
    if (JSONResponse.GetValue('aberto').Value).ToBoolean Then
       result:='A'
    else
       result:='F'
  end;

end;


 procedure TfrmProdutos.AddCliente(produto,id_produto: string; preco: extended);
var
    item: TListViewItem;
begin
    try
        item := lstvProdutos.Items.Add;

        with item do
        begin
            Height := 50;
            //Tag :=StrToInt64Def( id_produto,0);
            TagString := id_produto;
            //TagFloat:=preco;

            // Cliente...
            TListItemText(Objects.FindDrawable('Text1')).Text := produto;
            TListItemText(Objects.FindDrawable('Text2')).Text := id_produto;
            TListItemText(Objects.FindDrawable('Text4')).Text := FloatToStrf(preco,ffnumber,12,2);
        end;

    except on ex:exception do
        showmessage('Erro ao inserir cliente na lista: ' + ex.Message);
    end;
end;



procedure TfrmProdutos.FormShow(Sender: TObject);
begin
   id_produto:='';
   Situacaocaixa:=caixaaberto;
   tabPrincipal.ActiveTab:=tabPedido;
   if   situacaocaixa='F' Then
   begin
        fancy.Show(TIconDialog.Info,'Aviso','Necessário abrir caixa retaguarda', 'OK');
        exit;
   end
   Else if situacaocaixa='I' Then   //sem contato com o servidor
   begin
       fancy.Show(TIconDialog.Info,'Aviso','Servidor Inativo', 'OK');
       exit;
   end;
    lblQuant.text:='0';
    lblCliente.Text:='Cliente Padrao';
    controlecarga:=false;
   rectTabelaPreco.Visible:=false;
    recPeso.Visible:=false;
    tabPrincipal.ActiveTab:=tabPedido;
    fancy := TFancyDialog.Create(FrmProdutos);
    rectObs1.Visible:=false;
    timer1.Enabled:=true;
end;

procedure TfrmProdutos.Image1Click(Sender: TObject);
begin
   rectobs1.Visible:=false;
  if dmLocal.memPedido.isempty then
  begin
     fancy.Show(TIconDialog.Info, 'Aviso','Carrinho vazio', 'OK');
     exit;
  end;
  cbxFormaPgto.ItemIndex:=-1;
  Tabprincipal.ActiveTab:=tabFinalizar;
end;

procedure TfrmProdutos.imgCargaClick(Sender: TObject);
begin
  carga;

end;

procedure TfrmProdutos.img_voltarClick(Sender: TObject);
begin

   rectObs1.Visible:=false;
   if tabPrincipal.ActiveTab=tabFinalizar then
   begin
      tabPrincipal.ActiveTab:=tabPedido;
   end ;



end;


procedure TfrmProdutos.listaprodutos;
var
   T: TThread;
   qry:TFdQuery ;
begin
    lstvProdutos.Items.Clear;
     lstvProdutos.BeginUpdate;
     qry :=TFDQuery.Create(nil);
     qry.Connection:=dmLocal.conLocal;
    qry.open('select * from produto order by produto');
    TLoading.Show(FrmProdutos, 'Carregando...'); // Thread
    t := TThread.CreateAnonymousThread(procedure
    begin
        TThread.Synchronize(TThread.CurrentThread, procedure
        begin
        while NOT qry.eof do
              begin
                  var item:TListViewItem:= lstvProdutos.Items.Add;
                  with item do
                  begin
                      Height := 50;
                      //Tag :=StrToInt64Def( id_produto,0);
                      TagString :=qry.fieldbyname('codigo').asstring;
                      //TagFloat:=preco;
                      // Cliente...
                      TListItemText(Objects.FindDrawable('Text1')).Text := qry.fieldbyname('produto').asString;
                      TListItemText(Objects.FindDrawable('Text2')).Text := qry.fieldbyname('codigo').asstring;
                      TListItemText(Objects.FindDrawable('Text4')).Text := FloatToStrf( qry.fieldByname('precovenda').asExtended,
                      ffnumber,12,2);
                  end;
               qry.next;
             end;
       end);
      qry.close;
      qry.DisposeOf;
     end);
    t.Start;
    t.OnTerminate := ThreadListaTerminate;
end;

procedure TfrmProdutos.lstVProdutosButtonClick(const Sender: TObject;
  const AItem: TListItem; const AObject: TListItemSimpleControl);
begin
    rectObs1.visible:=true;

    id_produto:= aitem.Tagstring;
   with dmLocal do
   begin
       var qry:TFdQuery:=TFDQuery.Create(nil);
       try
         qry.Connection:=dmLocal.conLocal;
         qry.open('select codigo,precovenda,produto from produto where codigo='+quotedstr(id_produto));
         lblDescricao.text:=Copy(qry.fieldbyname('produto').asString,1,30);
        if  dmLocal.memPedido.Locate('lkprod',aitem.Tagstring) then
        begin
            spinQuant.Value:= dmLocal.memPedidoqtde.Value;
            edtPreco.Value:=dmLocal.memPedidovrunit.Value;
        end
         Else
         begin
           spinQuant.Value:=1;
           edtPreco.Value:=qry.fieldbyname('precovenda').asExtended;               //dmLocal.qrProdutosprecovenda.AsExtended;
         end;
       finally
         qry.close;
         qry.DisposeOf;
       end;


   end;
end;

procedure TfrmProdutos.rectClienteClick(Sender: TObject);
begin
   if NOT Assigned(FrmBuscaCliente) then
        Application.CreateForm(TFrmBuscaCliente, FrmBuscaCliente);

    FrmBuscaCliente.ExecuteOnClose := SelecionarCliente;
    FrmBuscaCliente.Show;
end;

procedure TfrmProdutos.SelecionarCliente(id_cliente:integer; nome: string);
begin
    lblCliente.Text := nome;
    lblCliente.Tag := id_cliente;
end;

end.
