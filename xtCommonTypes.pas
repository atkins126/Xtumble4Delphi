unit xtCommonTypes;

interface

uses
  SysUtils, Classes, DB;

type

  TConnectionType = (ctHTTP, ctWebSoket, ctSoket);

  TDBSCript = record
    scriptID: Int64;
    app_scope: String;
    psql: String;
  end;

  TConnectionParam = record
    ServerAddress: String;
    companyId: String;
    userName: String;
    password: String;
    attachmentCachePath: String;
    readTimeOut: Integer;
    connectionTimeOut: Integer;
    agent            : String;
    procedure init;
    class operator Initialize(out Dest: TConnectionParam);
  end;

  TValidateAccount = record
    Success: Boolean;
    Ok: Boolean;
    ResultString: String;
    UserId: Integer;
    accesslevel: Integer;
    LimitiSuperati: Boolean;
    LimitString: String;
    ErrorString: String;
    SessionID: String;
    procedure init;
    class operator Initialize(out Dest: TValidateAccount);
  end;

  // CAMPI NECESSARI PER CREARE UN ACCOUNT SYNALOGIN / XTUMBLE
  TCreateXTAccountParams = record
    reg_ragione_sociale: String;
    reg_PIVA: String;
    reg_nome: String;
    reg_cognome: String;
    reg_username: String;
    reg_password: String;
    reg_mail: String;
    reg_code_reseller: String;
    reg_naz: String;
    function compilato: Boolean;
  end;

  TLoginXTAccountParams = record
    reg_PIVA: String;
    reg_username: String;
    reg_password: String;
    function compilato: Boolean;
  end;

  // ********************** [ TDBCacheKind ] ********************
  // cdkNotUsrDBCache --> forzo che non venga usata
  // cdkStrictReadOnly      --> Legge soltanto dalla cache
  // cdkReadOnly            --> Quando effettua le modifiche le scrive anche sulla cache
  // cdkBidirectional       --> Legge e scrive sulla cache
  // cdkUseOnlyCacheSystem  --> Utilizza esclusivamente la cache

  TDBCacheKind = (cdkDisableDBCache, cdkStrictReadOnly, cdkReadOnly,
    cdkBidirectional, cdkUseOnlyCacheSystem);

  TArrayOfString = array of string;

  TFieldNameValue = record
    Name: String;
    Value: String;
  end;

  TRcdArray = TArray<TFieldNameValue>;

  TRecAllegatoProp = record
    pk_id: Integer;
    OriginalFileName: String;
    DisplayFileName: String;
    FileSize: Int64;
    MS: TMemoryStream;
    CacheFileName: String; // nome file dell'allegato nella cache dir
    DestFileName: String; // nome file di destinazione scelto dall'utente
    Error: String;
    Downloaded: Boolean;
    TagString: String;
    Tag: Integer;
    TagObject: TObject;
  end;

  TFunctionToFireAfterAsync = function(dataset: TDataSet): String;

  TAttchmentDloadEndProc = procedure(IDAllegato: Integer;
    OriginalFileName: String; LocalCacheFileName: String; MS: TMemoryStream;
    Error: String; DestFileName: String; Downloaded: Boolean) of object;
  TAttchmentDloadEndProcEX = procedure(IDAllegato: Integer;
    OriginalFileName: String; LocalCacheFileName: String; MS: TMemoryStream;
    Error: String; DestFileName: String; Downloaded: Boolean;
    AllegatoProp: TRecAllegatoProp) of object;

  TAttchmentUploadEndProc = procedure(IDAllegato: Integer; fileName: TFileName;
    fk_cartella: Integer = -1; relTableName: String = '';
    relPk_ID: Integer = -1; fk_Tipo_Allegati: Integer = -1;
    descrizione_libera: String = ''; user_id_owner: Integer = -1;
    accesslevel: Integer = -1; ExtraQU: String = '') of object;

  TAttachProcEnd = procedure;

  TQuEndProc = procedure(qu, Error: String);

  TLogProcedure = procedure(const text: String) of object;



  TAccountOutCome = record
    registratoCorrettamente: Boolean;
    errorCode: Integer;
    messaggio: String;
  end;



implementation

{ TDataBaseConnectionParam }
uses
  System.IOUtils;


class operator TConnectionParam.Initialize
  (out Dest: TConnectionParam);
begin
  Dest.ServerAddress := '';
  Dest.companyId     := '';
  Dest.userName      := '';
  Dest.password      := '';
  Dest.attachmentCachePath := '';
  Dest.readTimeOut   := 20000;
  Dest.connectionTimeOut := 500;
end;

procedure TConnectionParam.init;
begin
  self.ServerAddress := '';
  self.companyId     := '';
  self.userName      := '';
  self.password      := '';
  self.attachmentCachePath := '';
  self.readTimeOut   := 20000;
  self.connectionTimeOut := 500;
  self.agent := '';
end;

{ TCreateXTAccountParams }

function TCreateXTAccountParams.compilato: Boolean;
begin

  result := (reg_ragione_sociale <> '') and (reg_PIVA <> '') and
  (* (reg_nome            <> '')and
    (reg_cognome         <> '')and *)
    (reg_username <> '') and (reg_password <> '') and (reg_mail <> '');

end;

{ TLoginXTAccountParams }

function TLoginXTAccountParams.compilato: Boolean;
begin
  result := (self.reg_PIVA <> '') and (self.reg_username <> '') and
    (self.reg_password <> '');
end;

{ TValidateAccountResult }

class operator TValidateAccount.Initialize
  (out Dest: TValidateAccount);
begin
  Dest.Success := False;
  Dest.Ok := False;
  Dest.ResultString := '';
  Dest.UserId := -1;
  Dest.accesslevel := 1000000;
  Dest.LimitiSuperati := False;
  Dest.LimitString := '';
  Dest.ErrorString := '';
  Dest.SessionID := '';

end;

procedure TValidateAccount.init;
begin
  Self.Success := False;
  Self.Ok := False;
  Self.ResultString := '';
  Self.UserId := -1;
  Self.accesslevel := 1000000;
  Self.LimitiSuperati := False;
  Self.LimitString := '';
  Self.ErrorString := '';
  Self.SessionID := '';
end;

end.