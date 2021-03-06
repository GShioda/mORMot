/// MVC sample web application, publishing a simple BLOG
program MVCServer;

{$APPTYPE CONSOLE}

uses
  {$I SynDprUses.inc}    // will enable FastMM4 prior to Delphi 2006
  SynCrtSock,
  SynCommons,
  mORMot,
  SynSQLite3,
  SynSQLite3Static,
  mORMotSQLite3,
  mORMotHttpServer,
  mORMotMVC,
  MVCModel,
  MVCViewModel,
  SysUtils;

var aModel: TSQLModel;
    aServer: TSQLRestServerDB;
    aApplication: TBlogApplication;
    aHTTPServer: TSQLHttpServer;
begin
  aModel := CreateModel;
  try
    aServer := TSQLRestServerDB.Create(aModel,ChangeFileExt(paramstr(0),'.db'));
    try
      aServer.DB.Synchronous := smNormal;
      aServer.DB.LockingMode := lmExclusive;
      aServer.CreateMissingTables;
      aApplication := TBlogApplication.Create(aServer);
      try
        aHTTPServer := TSQLHttpServer.Create('8092',aServer,'+',useHttpApiRegisteringURI);
        try
          aHTTPServer.RootRedirectToURI('blog/default'); // redirect / to blog/default
          aServer.RootRedirectGet := 'blog/default';  // redirect blog to blog/default
          writeln('"MVC Blog Server" launched on port 8092 using ',aHttpServer.HttpServer.ClassName);
          writeln(#10'You can check http://localhost:8092/blog/mvc-info for information');
          writeln('or point to http://localhost:8092 to access the web app.');
          writeln(#10'Press [Enter] to close the server.'#10);
          readln;
        finally
          aHTTPServer.Free;
        end;
      finally
        aApplication.Free;
      end;
    finally
      aServer.Free;
    end;
  finally
    aModel.Free;
  end;
end.
