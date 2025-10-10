unit udmLocal;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Comp.UI,System.IOUtils,
  FireDAC.Stan.StorageBin, ConfigVo, FireDAC.Phys.SQLiteWrapper.Stat,
  System.ImageList, FMX.ImgList, FMX.Types, FMX.Controls;


type
  TdmLocal = class(TDataModule)
    conLocal: TFDConnection;
    Link: TFDPhysSQLiteDriverLink;
    Cursor: TFDGUIxWaitCursor;
    binLink: TFDStanStorageBinLink;
    ImageList1: TImageList;
    memPedido: TFDMemTable;
    memPedidoItem: TSmallintField;
    memPedidoqtde: TFloatField;
    memPedidovrunit: TCurrencyField;
    memPedidolkmesa: TStringField;
    memPedidoproduto: TStringField;
    memPedidoTotal: TCurrencyField;
    memPedidocodDest: TSmallintField;
    memPedidodescresumida: TStringField;
    memPedidoTipoTabela: TStringField;
    memPedidovrunit1: TCurrencyField;
    memPedidolkgrupo: TSmallintField;
    memPedidoobservacao: TStringField;
    dtsLinkPedido: TDataSource;
    memPedidoSomaTotal: TAggregateField;
    memPedidolkprod: TStringField;
    fdPagamentos: TFDMemTable;
    fdPagamentosid: TIntegerField;
    fdPagamentosdescricao: TStringField;
    fdPagamentosvalor: TBCDField;
    fdPagamentosparcelar: TStringField;
    qryFin: TFDQuery;
    qryFinid: TIntegerField;
    qryFinfinalizadora: TStringField;
    qryFinparcelar: TStringField;
    qryFinvalor: TCurrencyField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  dmLocal: TdmLocal;
  Config:TConfigVo;
  CodigoVEndedor:String='1';
implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmLocal.DataModuleCreate(Sender: TObject);

begin

     with ConLocal do
    begin
        {$IFDEF MSWINDOWS}
        if NOT FileExists(System.SysUtils.GetCurrentDir + '\db\rest.db') then
            raise Exception.Create('Banco de dados não encontrado: ' +
                                   System.SysUtils.GetCurrentDir + '\DB\rest.db');

        try
            Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\DB\rest.db';
            Connected := true;
        except on E:Exception do
                raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
        end;

        {$ELSE}

        Params.Values['DriverID'] := 'SQLite';
        try
           //nome do banco deve ser igual a refererida pasta. Case sensitive
            Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'distdb.db');
            Connected := true;
        except on E:Exception do
            raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
        end;
        {$ENDIF}
    end;








end;

end.
