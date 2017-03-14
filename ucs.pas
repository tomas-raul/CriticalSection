unit uCS;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  syncobjs;

type

    { tIQCriticalSection }

    tCS = class(tCriticalSection)
    private
      class var FLogLonger: Integer;
      class var FTimeOutException: Integer;
    private
      FLockName: String;
      procedure SetLockName(AValue: String);
    public
      constructor Create;
      procedure Enter (const pLockName : string);
      procedure Leave;

      class property LogLonger : Integer read FLogLonger write fLogLonger;
      class property TimeOutException : Integer read FTimeOutException write fTimeOutException;

    published
       property LockName : String read FLockName write SetLockName;
    end;

function InitCS : tCS;
procedure EnterCS( CS : tCS; const pLockName : string);
procedure LeaveCS( CS : tCS);
procedure DoneCS( CS : tCS);

implementation

uses
  DateUtils;

function InitCS: tCS;
begin
   result := tCS.Create;
end;

procedure EnterCS( CS: tCS; const pLockName : string);
begin
   CS.Enter(pLockName);
end;

procedure LeaveCS( CS: tCS);
begin
   CS.Leave;
end;

procedure DoneCS( CS: tCS);
begin
   CS.Free;
end;

{ tIQCriticalSection }

constructor tCS.Create;
begin
   inherited;
   LogLonger := 50;
   LockName := '';
   TimeOutException := 5000;
end;

procedure tCS.Enter(const pLockName: string);
var start, LogAfter, TimeOutAfter : tDateTime;
    logafterdone : boolean;
begin
   start := now;
   LogAfter := DateUtils.IncMilliSecond(start,fLogLonger);
   TimeOutAfter := DateUtils.IncMilliSecond(start,fTimeOutException);
   logafterdone := false;

   while not TryEnter do
   begin
     if ( now > TimeOutAfter ) then
     begin
        {$IFDEF LOG}        Log('CS-Timeout - ' + pLockName + ' waits for ' + fLockName + ' longer than ' + IntToStr(TimeOutException) + ' ms');{$ENDIF}
        raise Exception.Create('CS-Timeout - ' + pLockName + ' waits for ' + fLockName + ' longer than ' + IntToStr(TimeOutException) + ' ms');
     end;
     if ( not logafterdone and (now > LogAfter) ) then
     begin
        logafterdone := true;
     end;
   end;
   if (logafterdone) then
   begin
      {$IFDEF LOG}      Log('CS-Wait-done - ' + pLockName + ' waits for ' + fLockName + ' ' + IntToStr(DateUtils.MilliSecondsBetween(start,now)) + ' ms');{$ENDIF}
   end;

   FLockName:=pLockName;
end;

procedure tCS.Leave;
begin
   inherited Leave;
end;

procedure tCS.SetLockName(AValue: String);
begin
  if FLockName=AValue then Exit;
  FLockName:=AValue;
end;

end.

