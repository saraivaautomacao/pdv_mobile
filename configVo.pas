unit configVo;

interface


 type
  TConfigVo=Class
  private
    FPORTA: string;
    FIP: string;
    FURL: string;


  published
    property ip: string read FIP write FIP;
    property porta: string read FPORTA write FPORTA;
    property url: string read FURL write FURL;
  end;

implementation
end.
