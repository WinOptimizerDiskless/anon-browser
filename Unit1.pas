unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvNavigationPane,
  JvSpeedButton, Vcl.ExtCtrls, JvExExtCtrls, JvExtComponent, JvPanel,
  JvGradientHeaderPanel, Vcl.StdCtrls, JvExStdCtrls, JvMemo, Vcl.WinXCtrls,
  JvImage, JvLinkLabel, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdMappedPortTCP, IdTCPServer, IdContext;

type
  TForm1 = class(TForm)
    JvNavPanelHeader1: TJvNavPanelHeader;
    JvPanel1: TJvPanel;
    JvPanel2: TJvPanel;
    JvSpeedButton2: TJvSpeedButton;
    JvMemo1: TJvMemo;
    JvSpeedButton3: TJvSpeedButton;
    JvGradientHeaderPanel1: TJvGradientHeaderPanel;
    ToggleSwitch1: TToggleSwitch;
    JvImage1: TJvImage;
    JvPanel3: TJvPanel;
    JvSpeedButton1: TJvSpeedButton;
    IdTCPServer1: TIdTCPServer;
    procedure JvSpeedButton2Click(Sender: TObject);
    procedure ToggleSwitch1Click(Sender: TObject);
    procedure LinkLabel1Click(Sender: TObject);
    procedure JvLinkLabel1Click(Sender: TObject);
    procedure JvSpeedButton1Click(Sender: TObject);
    procedure JvSpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
//      ProxyServer: TProxyServer; // ���������� ���� ��� �������� ���������� ������-�������
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
         uses
            IOutils, unit2, luki, umainform;
{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
// ProxyServer := TProxyServer.Create; // �������� ���������� ������-�������
 if lukutils.LUKPID_ <= 0 then
 begin
   if lukutils.LUKPID_ > 0 then
     begin
      JVSpeedbutton3.Caption:='Connect';
               lukutils.SetProxy(False, '', '');


//      IDTcpServer1.Active:=True;
//      ShowMessage(lukutils.LUKPID_.ToString);

     end;
 end else


 begin

         JVSpeedbutton3.Caption:='Disconnect';
          lukutils.SetProxy(True, 'socks=127.0.0.1', '9050');
//           IDTcpServer1.Active:=False;
//     ShowMessage(lukutils.LUKPID_.ToString);
 end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//ProxyServer.Free; // ������������ ���������� ������-�������
end;

procedure TForm1.FormShow(Sender: TObject);
begin
              if (FileExists(ConCat(GetEnvironmentVariable('TMP'),'\torrc'))) and (pos('UseBridges 1',TFile.ReadAllText(ConCat(GetEnvironmentVariable('TMP'),'\torrc'))) > 0) then

              begin
               ToggleSwitch1.State:=tsson;
              end;
end;

procedure TForm1.JvLinkLabel1Click(Sender: TObject);
begin
//ShowMessage('sdfsdf');
end;

procedure TForm1.JvSpeedButton1Click(Sender: TObject);
begin
  if Form2.JvMemo1.Lines.Count >=0 then
    Form2.JvMemo1.Text:=JVMemo1.Text;
  Form2.SpeedButton1.Enabled:=true;
  Form2.Show;
end;

procedure TForm1.JvSpeedButton2Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.JvSpeedButton3Click(Sender: TObject);
var
  BridgeCfg: TStringList;
  i: INteger;
begin




if lukutils.LUKPID_ <= 0 then
 begin
   BridgeCfg:=TStringList.create;
    if ToggleSwitch1.IsOn then
      begin
        BridgeCfg.Add('UseBridges 1');
        BridgeCfg.Add(ConCat('ClientTransportPlugin obfs4 exec ',lukutils.GetPlugTorPath,'\lyrebird.exe'));
        {
        Bridge obfs4 64.4.175.62:8000 8B72740D150795ACB5101AA5F95D1ACDA4FE6B3E cert=vduuNhJ5U/8hjZmllP6AFfXSlSZsnrimdR8Tm8DY9dxWS4n2j92fNc0qHihUwRqwcOfIcg iat-mode=0
        Bridge obfs4 179.43.155.94:82 1062AAF68D0E645EBAF969287A63003D541D0C27 cert=2PS5xqoTv7JIC+XhWtXFP3B+9BJ3YaIMyjsJHW5z9AmN4R4sjkQUiYijFdmwS4QC1Pf0HQ iat-mode=0
        }
       for i := 0 to JvMemo1.Lines.Count-1 do
        BridgeCfg.Add(ConCat('Bridge ',JvMemo1.Lines[i]));
    end else
      begin
        BridgeCfg.Add('UseBridges 0');
      end;
      TFile.WriteAllText(ConCat(GetEnvironmentVariable('TMP'),'\torrc'),BridgeCfg.text);
  BridgeCfg.Free;
   lukutils.LUKPID_:=lukutils.ConnectToLuk;
   if lukutils.LUKPID_ > 0 then
     begin
      JVSpeedbutton3.Caption:='Disconnect';
       lukutils.SetProxy(True, 'socks=127.0.0.1', '9050');
       TFile.WriteAllText(ConCat(GetEnvironmentVariable('TMP'),'\luk.pid'),lukutils.LUKPID_.ToString) ;
//      IDTcpServer1.Active:=True;
//      ShowMessage(lukutils.LUKPID_.ToString);
        if MainForm.JvPanel1.Visible then
         begin
            mainform.JvCheckListBox1.Checked[0]:=true;
            if toggleswitch1.IsOn then
              mainform.JvCheckListBox1.Checked[1]:=true else
              mainform.JvCheckListBox1.Checked[1]:=false;
         end;


     end;
 end else


 begin

     lukutils.LUKPID_:=lukutils.DisconnectToLuk;
         JVSpeedbutton3.Caption:='Connect';
         lukutils.SetProxy(False, '', '');
        if MainForm.JvPanel1.Visible then
         begin
            mainform.JvCheckListBox1.Checked[0]:=false;
            if toggleswitch1.IsOn then
              mainform.JvCheckListBox1.Checked[1]:=false;
         end;

//           IDTcpServer1.Active:=False;
//     ShowMessage(lukutils.LUKPID_.ToString);
 end;
end;

procedure TForm1.LinkLabel1Click(Sender: TObject);
begin
ShowMessage('sdfsf');
end;



procedure TForm1.ToggleSwitch1Click(Sender: TObject);
var
  BridgeCfg: TStringList;
  i: integer;
begin
  BridgeCfg:=TStringList.create;
    if ToggleSwitch1.IsOn then
      begin
        BridgeCfg.Add('UseBridges 1');
        BridgeCfg.Add(ConCat('ClientTransportPlugin obfs4 exec ',lukutils.GetPlugTorPath,'\lyrebird.exe'));
        {
        Bridge obfs4 64.4.175.62:8000 8B72740D150795ACB5101AA5F95D1ACDA4FE6B3E cert=vduuNhJ5U/8hjZmllP6AFfXSlSZsnrimdR8Tm8DY9dxWS4n2j92fNc0qHihUwRqwcOfIcg iat-mode=0
        Bridge obfs4 179.43.155.94:82 1062AAF68D0E645EBAF969287A63003D541D0C27 cert=2PS5xqoTv7JIC+XhWtXFP3B+9BJ3YaIMyjsJHW5z9AmN4R4sjkQUiYijFdmwS4QC1Pf0HQ iat-mode=0
        }
       for i := 0 to JvMemo1.Lines.Count-1 do
        BridgeCfg.Add(ConCat('Bridge ',JvMemo1.Lines[i]));
    end else
      begin
        BridgeCfg.Add('UseBridges 0');
      end;
      TFile.WriteAllText(ConCat(GetEnvironmentVariable('TMP'),'\torrc'),BridgeCfg.text);
  BridgeCfg.Free;
end;

end.
