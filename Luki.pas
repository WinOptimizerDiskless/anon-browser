unit Luki;

interface
  uses
      Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
          Vcl.StdCtrls, System.Threading,dialogs,Registry,JvCombobox,ioutils,System.Types;
  type
      TExternalProcessThread = class(TThread)
      private
        FExecutablePath: string;
        FParameters: string;
      protected
        procedure Execute; override;
      public
        constructor Create(const ExecutablePath, Parameters: string);
      end;
    type
        TLuki = record
          function GetTorExe: string;
          function GetPlugTorPath: string;
          function ConnectToLuk: Integer;
          function DisconnectToLuk: Integer;
          procedure CreateRAMDisk(const DriveLetter: Char; SizeInGB: Integer);
          procedure RemoveRAMDisk(const DriveLetter: Char);
          function RunExecPid(ProgramName : String; Wait, hide: Boolean;minimize : boolean = false) : integer;
           procedure SetProxy(EnableProxy: Boolean; const ProxyServer: string; const ProxyPort: string);
          function VPNConnect: integer;
          function VPNDisconnect: integer;
          function GetFreeDriveLetters: TStringList;
          procedure PopulateComboBoxWithFreeDriveLetters(ComboBox: TJVCombobox; LabelCaption: TLabel);

          var
            VPNPID_: integer;
            LUKPID_: integer;
        end;

  var
    lukutils: TLuki;
   procedure GetVPNConf;
   function GetProgrFiles: string;
   function GetOpenVPNDir: string;
   function GetSystem32Dir: string;
   function IsRamDisk(const DriveLetter: AnsiChar): Boolean;
   function FindRamDiskLetter: Char;
   procedure DeleteNonEmptyFolder(const FolderPath: string);
   function DeleteFolder(const FolderPath: string): Boolean;
implementation

           uses
             ShellApi,unit1, Controls,
{ TExternalProcessThread }

  IdTCPClient, IdSocks;
function DeleteFolder(const FolderPath: string): Boolean;
var
  FileOp: TSHFileOpStruct;
begin
  FillChar(FileOp, SizeOf(FileOp), 0);
  FileOp.Wnd := 0;
  FileOp.wFunc := FO_DELETE;
  FileOp.pFrom := PChar(FolderPath + #0);
  FileOp.fFlags := FOF_SILENT or FOF_NOERRORUI or FOF_NOCONFIRMATION;
  FileOp.fFlags := FileOp.fFlags or FOF_NOCONFIRMMKDIR; // �� ����������� ������������� �������� ����� �����

  Result := (0 = SHFileOperation(FileOp));
end;
function TLuki.GetFreeDriveLetters: TStringList;
var
  DrivesMask: DWORD;
  Drive: AnsiChar;
begin
  Result := TStringList.Create;
  try
    // �������� ������� ����� ���� ������
    DrivesMask := GetLogicalDrives;

    // ��������� ������ ��� �����, ����� ������, �������� �� ����
    for Drive := 'A' to 'Z' do
    begin
      if (DrivesMask and 1) = 0 then
        Result.Add(Drive + ':');
      DrivesMask := DrivesMask shr 1;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function IsRamDisk(const DriveLetter: AnsiChar): Boolean;
begin
  Result := FileExists(Format('%s:\.ramdisk.mask', [DriveLetter]));
end;

function GetExistingRamDiskIndex(ComboBox: TJVCombobox; LabelCaption: TLabel): Integer;
var
  Drive: AnsiChar;
begin
  // ������������� ����� ������
  for Drive := 'A' to 'Z' do
  begin
    // ���� ���� �������� RamDisk'��, ���������� ��� ������
    if IsRamDisk(Drive) then
    begin
      LabelCaption.Caption := Drive; // ���������� ����� ����� � ������� �������� � LabelCaption
      Exit(ComboBox.Items.IndexOf(Drive + ':'));
    end;
  end;
  // ���� RamDisk �� ������, ���������� -1
  Result := -1;
end;


procedure TLuki.PopulateComboBoxWithFreeDriveLetters(ComboBox: TJVCombobox; LabelCaption: TLabel);
var
  DrivesMask: DWORD;
  Drive: AnsiChar;
begin
  ComboBox.Items.Clear;

  DrivesMask := GetLogicalDrives;

  for Drive := 'A' to 'Z' do
  begin
    if (DrivesMask and 1) = 0 then
      ComboBox.Items.Add(Drive + ':');
    DrivesMask := DrivesMask shr 1;
  end;

  // ��������� �����, �� ������� ���� ���� .ramdisk.mask
  for Drive := 'A' to 'Z' do
  begin
    if IsRamDisk(Drive) then
      ComboBox.Items.Add(Drive + ':');
  end;

  // ������������� ������ ��� RamDisk'�, ���� �� ����������
  ComboBox.ItemIndex := GetExistingRamDiskIndex(ComboBox,LabelCaption);
  if ComboBox.ItemIndex = -1 then
      ComboBox.ItemIndex:=0;
end;

        constructor TExternalProcessThread.Create(const ExecutablePath, Parameters: string);
        begin
          inherited Create(True);
          FreeOnTerminate := True;
          FExecutablePath := ExecutablePath;
          FParameters := Parameters;
        end;



        procedure TExternalProcessThread.Execute;
        var
          StartupInfo: TStartupInfo;
          ProcessInfo: TProcessInformation;
        begin
          ZeroMemory(@StartupInfo, SizeOf(TStartupInfo));
          StartupInfo.cb := SizeOf(TStartupInfo);
          StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
          StartupInfo.wShowWindow := SW_HIDE;
          if CreateProcess(nil, PChar(FExecutablePath + ' ' + FParameters), nil, nil, False, CREATE_NO_WINDOW, nil, nil, StartupInfo, ProcessInfo) then
          begin
            CloseHandle(ProcessInfo.hProcess);
            CloseHandle(ProcessInfo.hThread);
          end;
        end;
             function hideWinByPid(wHandle: HWND;  pid1: DWORD): BOOL; stdcall;
              var
              sImageFileName: array [0..MAX_PATH] of Char;
              pid : DWORD;
              pHandle : THandle;
              s: string ;
              begin
                Result := true;
                GetWindowThreadProcessId(wHandle, @pid);
                if pid = pid1 then begin
                  showwindow(wHandle, SW_hide);

                end;
                CloseHandle(pHandle);
              end;

            function TLuki.RunExecPid(ProgramName : String; Wait, hide: Boolean;minimize : boolean = false) : integer;
            var
              StartInfo : TStartupInfo;
              ProcInfo : TProcessInformation;
              CreateOK : Boolean;
            begin
              FillChar(StartInfo,SizeOf(TStartupInfo),#0);
              FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
              UniqueString(ProgramName);
              if hide then begin
                StartInfo.wShowWindow := SW_HIDE;
                StartInfo.dwFlags := STARTF_USESHOWWINDOW;
              end;

              if minimize = true then
                StartInfo.wShowWindow := SW_Minimize;

              StartInfo.cb := SizeOf(TStartupInfo);
              CreateOK := CreateProcess(nil, PChar(ProgramName), nil, nil,False,
                          NORMAL_PRIORITY_CLASS,
                          nil, nil, StartInfo, ProcInfo);
              if CreateOK then begin
                if minimize = true then
                  enumwindows(@hideWinByPid, ProcInfo.dwProcessId);

                Result := ProcInfo.dwProcessId;
                if Wait then
                  WaitForSingleObject(ProcInfo.hProcess, INFINITE);
              end
              else begin
                Result := 0;
              end;
              CloseHandle(ProcInfo.hProcess);
              CloseHandle(ProcInfo.hThread);
            end;

        function TLuki.GetPlugTorPath: string;
        begin
           if DirectoryExists(ConCat(ExtractFileDir(ParamStr(0)),'\tor\tor\pluggable_transports')) then
                Result:=ConCat(ExtractFileDir(ParamStr(0)),'\tor\tor\pluggable_transports');

        end;
procedure GetVPNConf;

var
    FileOVPN : TStringList;
begin
   FileOVPN:=TStringList.Create;










     if lukutils.LUKPID_ > 0 then
     begin
//            ShowMessage('LUK');
         FileOVPN.Add('client');
         FileOVPN.Add('dev tun');
         FileOVPN.Add('proto tcp4');
         FileOVPN.Add('socks-proxy 127.0.0.1 9050');
         FileOVPN.Add('remote wfshnsrarkpyzouzusclj6zd77behwhs5phtz4sblgh4pihedoexbgad.onion 8443');
         FileOVPN.Add('socks-proxy-retry   ');
     end else
     begin

         FileOVPN.Add('client');
         FileOVPN.Add('dev tun');
         FileOVPN.Add('proto tcp4');
         FileOVPN.Add('remote 18plus.sytes.net 8443');

     end;
    FileOVPN.add('# ����� ������������');
    FileOVPN.add('resolv-retry infinite');
    FileOVPN.add('nobind');
    FileOVPN.add('persist-key');
    FileOVPN.add('persist-tun   ');
    FileOVPN.add('remote-cert-tls server');
    FileOVPN.add('auth SHA256              ');
    FileOVPN.add('cipher AES-128-GCM');
    FileOVPN.add('ignore-unknown-option block-outside-dns block-ipv6');
    FileOVPN.add('verb 3');
    FileOVPN.add('<ca>');
    FileOVPN.add('-----BEGIN CERTIFICATE-----');
    FileOVPN.add('MIIDSzCCAjOgAwIBAgIUJ8qReAeMq4bFwb4vTYxq2Ss8+Z4wDQYJKoZIhvcNAQEL');
    FileOVPN.add('BQAwFjEUMBIGA1UEAwwLRWFzeS1SU0EgQ0EwHhcNMjQwNDAyMTAwNzU5WhcNMzQw');
    FileOVPN.add('MzMxMTAwNzU5WjAWMRQwEgYDVQQDDAtFYXN5LVJTQSBDQTCCASIwDQYJKoZIhvcN');
    FileOVPN.add('AQEBBQADggEPADCCAQoCggEBALLi8/+9a4yOQ4WXA19HoKt0MfT6gWU1yXWoSeK7');
    FileOVPN.add('bCqfycMf9xoDtYb4R6xxUe1DJLH8HXzPefC8MoH1fziN9CU/EZMzxyV6F39Ch027');
    FileOVPN.add('I69h38ooGgQIXK9JeeP1++ntXA/DHu6Jjt9WZMg97y1S5a+Nd672lz9DS4WDy6/V');
    FileOVPN.add('P8XGrTMRo5T5DcyZlUpRa1JFtLL/Yx7i+PdWTlPV63QtZ1IFy7p1AOrVsUD1exk5');
    FileOVPN.add('3k3811r4J67tVrsMxMYRhOKA3mKjNXVEcnCBsIJlB8it6f0EATJPwWIcbeY7ex37');
    FileOVPN.add('20Ft9S9K4oGolSz502ER6BJFJVwt2GseA9bd1bEmL9USOkkCAwEAAaOBkDCBjTAM');
    FileOVPN.add('BgNVHRMEBTADAQH/MB0GA1UdDgQWBBSpe4/HOw/P+o6eQrTkoy5uM/5G6DBRBgNV');
    FileOVPN.add('HSMESjBIgBSpe4/HOw/P+o6eQrTkoy5uM/5G6KEapBgwFjEUMBIGA1UEAwwLRWFz');
    FileOVPN.add('eS1SU0EgQ0GCFCfKkXgHjKuGxcG+L02MatkrPPmeMAsGA1UdDwQEAwIBBjANBgkq');
    FileOVPN.add('hkiG9w0BAQsFAAOCAQEAqmGnnWqXp1W5GbNM4QZPdK9CpNyCqEQc4ywAs3kdbEjH');
    FileOVPN.add('sH6bN1Y6Kz3yhjcSAn1tacc9e00Hc+MiHNg3dtGaKtTJauZg9mbzwzUU0cceo/TC');
    FileOVPN.add('TfMV8yfCoDKmyhx7Rm4d3zNTRPE1HUhBdArO2h6I0bgUiPf/tTFb3j4rFH86hanZ');
    FileOVPN.add('/Pg4aS1YxkDmNrxtOteH00TcRpWcwiCCU6CERuJPZ8tneB3M2DGlLrq/SjH386Ze');
    FileOVPN.add('dwaqNjwam4n23LYmkK27wQXfZGkVbHY5kNBgNyS/z/Srwst5BE8U12wO2vrBkhWr');
    FileOVPN.add('gsbsW3+86i7mQoEf28p1fL0FzeNr+GZSFhOyb8LZpg==');
    FileOVPN.add('-----END CERTIFICATE-----');
    FileOVPN.add('</ca>');
    FileOVPN.add('<cert>');
    FileOVPN.add('-----BEGIN CERTIFICATE-----');
    FileOVPN.add('MIIDVTCCAj2gAwIBAgIRAI+5MNqJn8YByCTesGs2pCYwDQYJKoZIhvcNAQELBQAw');
    FileOVPN.add('FjEUMBIGA1UEAwwLRWFzeS1SU0EgQ0EwHhcNMjQwNDAyMTAwOTEwWhcNMzQwMzMx');
    FileOVPN.add('MTAwOTEwWjARMQ8wDQYDVQQDDAZ0ZXN0aW0wggEiMA0GCSqGSIb3DQEBAQUAA4IB');
    FileOVPN.add('DwAwggEKAoIBAQCu3FtxidHstyNsJzVh4EpdhQLATJzZdOpxpmGnKZHhPAWXYHkR');
    FileOVPN.add('2MUPHWad484gbRtVBF5n1eyMz+xxED5udNxyUB8iVcAA8vKJDw17R7xGw9bpBlqw');
    FileOVPN.add('TKyG31XvPktwcN1OHAjMcqTIcg3T+Qa+Pxpz/c7K8r+7Tlfkxkz++tKf1cFeipqA');
    FileOVPN.add('3w0ITcWCvjXYLy1+ydTFUInXiFYEOQXsnqqNyBHENxTsLULwel9OSxOa0Oqu6a4r');
    FileOVPN.add('fvNUQwtnt8EbDeuCmJVNttdljJ4fY2Qt1P8Wx7clKT9QWB864MjRJcFg26uwsoD5');
    FileOVPN.add('Dka6SG5Q4n04Z/0EnHW1zOp/pDp0jy4bDT+bAgMBAAGjgaIwgZ8wCQYDVR0TBAIw');
    FileOVPN.add('ADAdBgNVHQ4EFgQUZ8z8EBpL+F5d64eHnOPXCwlaMGgwUQYDVR0jBEowSIAUqXuP');
    FileOVPN.add('xzsPz/qOnkK05KMubjP+RuihGqQYMBYxFDASBgNVBAMMC0Vhc3ktUlNBIENBghQn');
    FileOVPN.add('ypF4B4yrhsXBvi9NjGrZKzz5njATBgNVHSUEDDAKBggrBgEFBQcDAjALBgNVHQ8E');
    FileOVPN.add('BAMCB4AwDQYJKoZIhvcNAQELBQADggEBADdMmPY7WyAas0Rt+rpaGwp5F445Jy/u');
    FileOVPN.add('fMK0J9b2fdspK7dch3LuMjVYrfThkgxXtIoOtYYQ5YB/zoBkiVe8E/Rgf0G4STKl');
    FileOVPN.add('+hDQkCNztMzP3OicdZEk8AVr7kocuLqvuREUcxp1ljQWCJBSQGJjK6m1evVUulW9');
    FileOVPN.add('0WRbXAqbmG02wgHY+uPwqnfRTI6If+OdwDcGJ61qZBsUjXj2crYIEYiareNByWR6');
    FileOVPN.add('ftwi1LIN/1G2TJU31Fomq95lLtGu2de07sX/dZZbFZQh/WcaFzYWXjk2AbpFH4z4');
    FileOVPN.add('8GrLdNcpObSaT29dt13dmImHpNIl3Fryor8bokt1VBd6JLe8sakM2ZM=');
    FileOVPN.add('-----END CERTIFICATE-----');
    FileOVPN.add('</cert>');
    FileOVPN.add('<key>');
    FileOVPN.add('-----BEGIN PRIVATE KEY-----');
    FileOVPN.add('MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCu3FtxidHstyNs');
    FileOVPN.add('JzVh4EpdhQLATJzZdOpxpmGnKZHhPAWXYHkR2MUPHWad484gbRtVBF5n1eyMz+xx');
    FileOVPN.add('ED5udNxyUB8iVcAA8vKJDw17R7xGw9bpBlqwTKyG31XvPktwcN1OHAjMcqTIcg3T');
    FileOVPN.add('+Qa+Pxpz/c7K8r+7Tlfkxkz++tKf1cFeipqA3w0ITcWCvjXYLy1+ydTFUInXiFYE');
    FileOVPN.add('OQXsnqqNyBHENxTsLULwel9OSxOa0Oqu6a4rfvNUQwtnt8EbDeuCmJVNttdljJ4f');
    FileOVPN.add('Y2Qt1P8Wx7clKT9QWB864MjRJcFg26uwsoD5Dka6SG5Q4n04Z/0EnHW1zOp/pDp0');
    FileOVPN.add('jy4bDT+bAgMBAAECggEAR/LXlXIV9IauhpPjfTBiqPRP23wqlbdrt/Oz/qo2Ii0m');
    FileOVPN.add('R9EkP9mny75XOORBLkp2kpbHmYYGXTI4oZUDe0OOaWLaTLBn3nwYm5ib/XvY1m1C');
    FileOVPN.add('goNg0WXbH2vJ2jURqWRnSvpyDF2nu+piEjRHOASTB+MJMayMg6+KrtGBYPEntSf5');
    FileOVPN.add('vLc6Xm+1R3VF3oxL5GxR/6eAFlQ2I0NG+j25dBbYQDTgMSo6IQ/GPL7gGKxDjsXB');
    FileOVPN.add('jyxUXLtoKFGd6AP73p3q8AzEqpA52l0JzmHT4fHr63Qc6sAPUgQhSOv+9PDtM2mW');
    FileOVPN.add('xCldGQW2WLGtwvgOpmayoHQuUhp+vCW61vBqrV/G8QKBgQC8917z2ps20dDkpAI4');
    FileOVPN.add('h1So6E4qMex0yLPEfUodd0Y/qdToNtdO5qBTjF+47UpI55nYWHBBIcK0nA1W7NyL');
    FileOVPN.add('EQNeRQW26urP+nSG8MdBwRMC860bc/4dA/F5RnCoMRdPQ4WT7WXwdtov0V5Y24bL');
    FileOVPN.add('2OiqI7gajlPXTm2HypWOmaDXFwKBgQDs5ATeloYt+mOc/mJFuZVJq/sgrPt/hbZz');
    FileOVPN.add('+BaczCaJKh1Y7JIAINXoiCZMw+IgNQQR2rMwO2NgxAC142/hH81ce4fZeYQLuQbZ');
    FileOVPN.add('TzHhpM8RckKIt0q/F2A35Z23UKxlbZr03gzjuXKUztOBDQbri2HYqwTCYhPizr5K');
    FileOVPN.add('84mMFX9uHQKBgFlsnyy7WRSaOkbZLovdzzyXotXpBkNF73ye5gIHveDG2BCEU2Pt');
    FileOVPN.add('VBX1qh7zfGH/6Bgv0f+goGmkJ9PpB31wMa3c8BVeGn0NwzNQopsFaZ/N/S+utqS4');
    FileOVPN.add('hv+jTBDsGmHSTFZy0/j15c8XP5TBXor9PS229Zrrm9WaMc8/GYOARFNFAoGAWpXz');
    FileOVPN.add('Or7qvohCMVWhdLI74TkvxdYAMkqKc5xJ4Vm73rXJFSkZx4zG3624n6BERzaewMkV');
    FileOVPN.add('vnrnTKiG8Qbw0HCd0iC22TW7hdQSR2UeWP/x4uUDhk44+gvRUm6uudvSoNKh78M9');
    FileOVPN.add('wJM4uqjAflfh7o6VMwpqvn5Mxm1ynSy1y2ipGw0CgYBo772/cMRjOMIOraeux7cK');
    FileOVPN.add('TZwdaQ2MP/WIHT7BBNW8SEZZDYAqKDPiwEp1OYjzk3FqHxbhQw+chLYkoRXfMsHW');
    FileOVPN.add('aVA/S6dNWw00nbU5nyDjcc+kzpdxXeRVz5cIWPHeFABrbsxQIJ9Z8lwou0scUpFA');
    FileOVPN.add('pSzZ94Mb3O5zZ5f10ArHSw==');
    FileOVPN.add('-----END PRIVATE KEY-----');
    FileOVPN.add('</key>');
    FileOVPN.add('<tls-crypt>');
    FileOVPN.add('-----BEGIN OpenVPN Static key V1-----');
    FileOVPN.add('fb5d343878607e1e409efa5ddec3ff51');
    FileOVPN.add('a9e6a1d273f6e4bb4fe08402899266b6');
    FileOVPN.add('45fd2ec991852af1c05ea57b6936bb09');
    FileOVPN.add('12192a0684c290ddfda548a61540be66');
    FileOVPN.add('96be3ef999172b47d2cb6e853a5effaf');
    FileOVPN.add('5396a4c33a62ebbab9197bbcc1b2c799');
    FileOVPN.add('2aa5c31804bdb26a8c52d1f85cd95534');
    FileOVPN.add('e5eed9601b5d729f2a5c5d15a2730eed');
    FileOVPN.add('f0962036876bc808566eba031d77a5ba');
    FileOVPN.add('cb4fd02f28f517141be63610c1068ed8');
    FileOVPN.add('7d6531c313d41bf0ce4c3ae2cf2c4bb4');
    FileOVPN.add('6661e6f5e922ebd0d0253fac3865b922');
    FileOVPN.add('51cf2f21e6d94430a8d70b4b2414a257');
    FileOVPN.add('039471945dd730f2f04e37271ddeaffb');
    FileOVPN.add('6776e013be3bad2e3ff20c0823d42faf');
    FileOVPN.add('2d54def280b06f23dd8f79ae517919a6');
    FileOVPN.add('-----END OpenVPN Static key V1-----');
    FileOVPN.add('</tls-crypt>');
  FileOVPN.SaveToFile(ConCat(GetEnvironmentVariable('TMP'),'\ovpn.ovpn'));
  FileOVPN.Free;
end;

procedure DeleteNonEmptyFolder(const FolderPath: string);
var
  Files: TStringDynArray;
  FilePath: string;
begin
  // ������� ��� ����� ������ �����
  Files := TDirectory.GetFiles(FolderPath);
  for FilePath in Files do
    DeleteFile(FilePath);

  // ���������� ������� ��� �������� ������ �����
  Files := TDirectory.GetDirectories(FolderPath);
  for FilePath in Files do
    DeleteNonEmptyFolder(FilePath);

  // ������� ���� �����
  RemoveDir(FolderPath);
end;

function  TLuki.GetTorExe: string;
        begin
           if DirectoryExists(ConCat(ExtractFileDir(ParamStr(0)),'\tor\tor')) then
            begin
              if FileExists(ConCat(ExtractFileDir(ParamStr(0)),'\tor\tor\tor.exe')) then
                Result:=ConCat(ExtractFileDir(ParamStr(0)),'\tor\tor\tor.exe');
            end;
        end;

        function TLuki.ConnectToLuk: Integer;
        begin

//             form1.JvMemo1.Lines.add  (ConCat(GetTorExe, ' -f "', GetEnvironmentVariable('TMP'),'\torrc"'));
             Result:= RunExecPid(ConCat(GetTorExe,' -f "', GetEnvironmentVariable('TMP'),'\torrc"'), False,true,false);

        end;

        function TLuki.DisconnectToLuk: Integer;
        begin
//                 ShowMessage(lukutils.LUKPID_.ToString);
                RunExecPid(Concat(GetEnvironmentVariable('WINDIR'),'\system32\taskkill /PID ',lukutils.LUKPID_.ToString),true,true,false) ;
                DeleteFile(ConCat(GetEnvironmentVariable('TMP'),'\luk.pid'));
                DeleteFile(ConCat(GetEnvironmentVariable('TMP'),'\torrc'));
                Result:=0;
        end;
 procedure TLuki.SetProxy(EnableProxy: Boolean; const ProxyServer: string; const ProxyPort: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings', True) then
    begin
      if EnableProxy then
      begin
        Reg.WriteInteger('ProxyEnable', 1);
        Reg.WriteString('ProxyServer', ProxyServer + ':' + ProxyPort);
      end
      else
      begin
        Reg.WriteInteger('ProxyEnable', 0);
        Reg.WriteString('ProxyServer', '');
      end;
    end;
  finally
    Reg.Free;
  end;
end;



function GetOpenVPNDir: string;
    begin
      Result:=ConCat(GetProgrFiles,'\OpenVPN');
    end;
function GetProgrFiles: string;
begin
  Result:=ConCat(GetEnvironmentVariable('SYSTEMDRIVE'),'\Program Files');
end;
function GetSystem32Dir: string;
begin
  Result:=ConCat(GetEnvironmentVariable('WINDIR'),'\system32');
end;
   function TLuki.VPNDisconnect: integer;
begin
  RunExecPid(ConCat(GetSystem32Dir,'\taskkill /pid ', lukutils.VPNPID_.ToString),true,true);
  DeleteFile(ConCat(GetEnvironmentVariable('TMP'),'\ovpn.pid'));
  DeleteFile(ConCat(GetEnvironmentVariable('TMP'),'\ovpn.ovpn'));
  lukutils.VPNPID_:=0;

end;
        function TLuki.VPNConnect: integer;
          begin
          GetVPNConf;
                Result:=RunExecPid(ConCat(GetOpenVPNDir,'\bin\openvpn.exe --config "',GetEnvironmentVariable('TMP'),'\ovpn.ovpn"'),false,true);
               if Result > 0 then
                  lukutils.VPNPID_:=Result;
                  Tfile.WriteAllText(ConCat(GetEnvironmentVariable('TMP'),'\ovpn.pid'),lukutils.VPNPID_.ToString);
          end;
function IsDriveAvailable(const DriveLetter: Char): Boolean;
begin
  Result := DirectoryExists(Format('%s:\', [DriveLetter]));
end;
procedure TLuki.CreateRAMDisk(const DriveLetter: Char; SizeInGB: Integer);
        var
          Command: string;
          countL: integer;
        begin
          // ��������� ������� ��� imdisk. ������ ����������� � ������, ������� �������� �� 1024*1024*1024 ��� GB.
          // � ���� ������� ���������� �������� ������� NTFS.
          Command := Format('imdisk -a -s %dM -m %s: -p "/fs:ntfs /q /y"', [SizeInGB, DriveLetter]);

          // �������� ������� ����� cmd.exe ��� ����������.
          ShellExecute(0, 'open', 'cmd.exe', PChar('/C ' + Command), nil, SW_HIDE);
          countL:=0;
          while not IsDriveAvailable(DriveLetter) do
             begin
               sleep(300);
               inc(countL);
               if countL >= 80 then
                break;
             end;
              TFile.WriteAllText((ConCat(DriveLetter,':\.ramdisk.mask')),SizeInGB.ToString);
        end;
        procedure TLuki.RemoveRAMDisk(const DriveLetter: Char);
        var
          Command: string;
        begin
          // ��������� ������� ��� �������� RAM-����� ��� �������� � ����������.
          Command := Format('imdisk -D -m %s:', [DriveLetter]);

          // ��������� ������� ����� cmd.exe.
          ShellExecute(0, 'open', 'cmd.exe', PChar('/C ' + Command), nil, SW_HIDE);
          DeleteFile(ConCat(DriveLetter,':\.ramdisk.mask'));
        end;
function FindRamDiskLetter: Char;
var
  Drive: Char;
begin
  Result := #0; // �� ��������� ��� �� ������ ����� � ������ .ramdisk.mask
  for Drive := 'A' to 'Z' do
  begin
    if TFile.Exists(Format('%s:\.ramdisk.mask', [Drive])) then
    begin
      Result := Drive;
      Break;
    end;
  end;
end;

end.
