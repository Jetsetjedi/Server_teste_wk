unit hCep;

interface

 uses

     System.Net.URLClient,System.Net.HttpClient, System.Net.HttpClientComponent,
     System.Classes, System.json;

 type
    TTesteWKhelper = class helper for TJSONArray
     function loadFromURL(const aDataRestTesteWK : string):TJSONArray;

    end;

implementation

{ TTesteWKhelper }

function TTesteWKhelper.loadFromURL(const aDataRestTesteWK: string): TJSONArray;
 var
   JsonStream : TStringStream;
   NetHTTPClient: TNetHTTPClient;
begin
     try
       JsonStream := TStringStream.Create;
       NetHTTPClient := TNetHTTPClient.Create(nil);

       NetHTTPClient.Get(aDataRestTesteWK,JsonStream);
        if TJSONObject.ParseJSONValue(JsonStream.DataString) is TJSONArray  then
            Result := TJSONObject.ParseJSONValue(JsonStream.DataString) as TJSONArray
        else
         if TJSONObject.ParseJSONValue(JsonStream.DataString)is TJSONObject  then
          Result := TJSONObject.ParseJSONValue('['+JsonStream.DataString+']') as TJSONArray;

     finally
       JsonStream.Free;
       NetHTTPClient.Free;
     end;



end;

end.
