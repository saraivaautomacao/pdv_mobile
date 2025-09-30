unit controller.distribuidora;

interface
 uses system.JSON,FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,system.SysUtils,configvo,udmlocal;


  type
    TControllerDistribuidora=Class


     public
      class function gerapedido(objped: TJsonobject;out status: integer): string;
      class function Carga(Tabela:string;out status:integer):TFDMemTable;
      class function statusmesa(out status:integer):TFDMemTable;
      class function statuscaixa(out status: integer): String;
      class function conferencia(idmesa: string;
      out status: integer): TFDMemTable; static;
       class function imprimeparcial(mesa: string; out status: integer): String; static;

    End;




implementation
uses RESTRequest4D,DataSet.Serialize.Adapter.RESTRequest4D, DataSet.Serialize;


{ TControllerComanda }



class function TControllerDistribuidora.Carga(Tabela: string;
  out status: integer): TFDMemTable;
var
    Resp : IResponse;
begin
   status:=0;
   var memTable:=TFDMemTable.Create(nil);
   Resp := TRequest.New.BaseURL(config.url)
             .Resource('carga')
             .BasicAuthentication('username', 'password')
             .Accept('application/json')
             .AddParam('tabela',tabela)
             .Adapters(TDataSetSerializeAdapter.New(MemTable))
             .get;
   status:=resp.StatusCode;
   result:=memtable;

end;

class function TControllerDistribuidora.statusmesa(out status: integer): TFDMemTable;
var
    Resp : IResponse;
begin
   status:=0;
   var memTable:=TFDMemTable.Create(nil);
   Resp := TRequest.New.BaseURL(config.url)
             .Resource('statusmesa')
             .BasicAuthentication('username', 'password')
             .Accept('application/json')
             .Adapters(TDataSetSerializeAdapter.New(MemTable))
             .get;
   status:=resp.StatusCode;
   result:=memtable;

end;

class function TControllerDistribuidora.statuscaixa(out status: integer): String;
var
    Resp : IResponse;
begin

   try
     Resp := TRequest.New.BaseURL(config.url)
             .Resource('statuscaixa')
             .BasicAuthentication('username', 'password')
             .Accept('application/json')
             .get;
   except on E: exception do
    begin
         status:=404;
         result:='';
         exit;
     end;
   end;
   status:=resp.StatusCode;
   result:=resp.Content;
end;

class function TControllerDistribuidora.conferencia(idmesa: string;
  out status: integer): TFDMemTable;
var
    Resp : IResponse;
begin
   status:=0;
   var memTable:=TFDMemTable.Create(nil);
   Resp := TRequest.New.BaseURL(config.url)
             .Resource('conferencia/'+idmesa)
             .BasicAuthentication('username', 'password')
             .Accept('application/json')

             .Adapters(TDataSetSerializeAdapter.New(MemTable))
             .get;
   status:=resp.StatusCode;
   result:=memtable;
end;

class function TControllerDistribuidora.gerapedido(objped: TJsonobject;out status: integer): string;
var
    Resp : IResponse;
begin
  //TDataSetSerializeConfig.GetInstance.Export.FormatCurrency := '0.00##';
   Resp := TRequest.New.BaseURL(config.url)
             .Resource('gerapedido')
             .BasicAuthentication('username', 'password')
             .Accept('application/json')
             .AddBody(objped)
             .post;
   status:=resp.StatusCode;
   result:=resp.Content;


end;

class function TControllerDistribuidora.imprimeparcial(mesa:string; out status: integer): String;
var
    Resp : IResponse;
begin
   status:=0;
   var memTable:=TFDMemTable.Create(nil);
   Resp := TRequest.New.BaseURL(config.url)
             .Resource('imprimeparcial/'+mesa)
             .BasicAuthentication('username', 'password')
             .Accept('application/json')
             .get;
   status:=resp.StatusCode;
   result:=resp.Content;

end;

end.
