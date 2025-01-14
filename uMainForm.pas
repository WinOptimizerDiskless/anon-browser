unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  uWVLoader, uWVCoreWebView2Args, JvgSpeedButton, JvExControls, JvSpeedButton,
  Vcl.Menus, JvMenus, JvExExtCtrls, JvExtComponent, JvPanel, JvxCheckListBox,
  Vcl.StdCtrls, Vcl.CheckLst, JvExCheckLst, JvCheckListBox, JvExStdCtrls,
  JvGroupBox, JvMemo, Winapi.WebView2, Winapi.ActiveX, Vcl.Edge, Vcl.OleCtrls,
  SHDocVw;

const
  WV_INITIALIZED = WM_APP + $100;

  HOMEPAGE_URL        = 'https://tutanota.com';
  DEFAULT_TAB_CAPTION = 'New tab';

type
  TMainForm = class(TForm)
    ButtonPnl: TPanel;
    AddTabBtn: TSpeedButton;
    RemoveTabBtn: TSpeedButton;
    BrowserPageCtrl: TPageControl;
    JvSpeedButton1: TJvSpeedButton;
    JvSpeedButton2: TJvSpeedButton;
    JvSpeedButton3: TJvSpeedButton;
    JvSpeedButton4: TJvSpeedButton;
    JvPanel1: TJvPanel;
    JvGroupBox1: TJvGroupBox;
    JvCheckListBox1: TJvCheckListBox;
    JvMemo1: TJvMemo;
    Button1: TButton;

    procedure FormShow(Sender: TObject);
    procedure AddTabBtnClick(Sender: TObject);
    procedure RemoveTabBtnClick(Sender: TObject);
    procedure JvSpeedButton3Click(Sender: TObject);
    procedure JvSpeedButton1Click(Sender: TObject);
    procedure JvSpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JvSpeedButton4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  protected
    FLastTabID       : cardinal;

    function  GetNextTabID : cardinal;
    procedure EnableButtonPnl;

    property  NextTabID       : cardinal   read GetNextTabID;

  public
    procedure WVInitializedMsg(var aMessage : TMessage); message WV_INITIALIZED;
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure AddTabExtBtnClick(Sender: TObject; eURL: string);
    procedure CreateNewTab(const aArgs : TCoreWebView2NewWindowRequestedEventArgs);
    procedure CloseAllTabs;
    procedure SetCustomCacheDir(const CacheDir: string);


  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

// This demo shows how to create multiple browsers at runtime using tabs.

uses
  uBrowserTab, Luki, unit1,unit3,unit4,ioutils;
procedure TMainForm.CloseAllTabs;
var
  i: Integer;
begin
  for i := BrowserPageCtrl.PageCount - 1 downto 0 do
    BrowserPageCtrl.Pages[i].Free;
end;
procedure TMainForm.SetCustomCacheDir(const CacheDir: string);
begin
  // ���������, ��� �� WebView2 ��� ���������������
  if GlobalWebView2Loader.Initialized then
  begin
    // ����� ����� ���� ��� ��� "������" ��������� � ���������� ���������, ���� ��� ����������
            CloseAllTabs;
  end;
 GlobalWebView2Loader.Free;
 GlobalWebView2Loader := TWVLoader.Create(nil);

  // ������������� ����� ���������� ��� ������ ������������
  GlobalWebView2Loader.UserDataFolder := CacheDir;
//  GlobalWebView2Loader.hi       := ConCat(CacheDir, 'CacheUserland');
  // ������������� WebView2 � ����� �����
  GlobalWebView2Loader.StartWebView2;
end;
procedure TMainForm.FormCreate(Sender: TObject);
begin
 jvCheckListBox1.ItemEnabled[0]:=false;
  jvCheckListBox1.ItemEnabled[1]:=false;
   jvCheckListBox1.ItemEnabled[2]:=false;
    jvCheckListBox1.ItemEnabled[3]:=false;
if FindRamDiskLetter <> '' then
  MainForm.SetCustomCacheDir(ConCat(FindRamDiskLetter, ':\cache'));

if FileExists(ConCat(GetEnvironmentVariable('TMP'),'\luk.pid')) then lukutils.LUKPID_:=TFile.ReadAllText(ConCat(GetEnvironmentVariable('TMP'),'\luk.pid')).ToInteger;
if FileExists(ConCat(GetEnvironmentVariable('TMP'),'\ovpn.pid')) then lukutils.VPNPID_:=TFile.ReadAllText(ConCat(GetEnvironmentVariable('TMP'),'\ovpn.pid')).ToInteger;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if GlobalWebView2Loader.InitializationError then
//    showmessage(GlobalWebView2Loader.ErrorMessage)
   else
    if GlobalWebView2Loader.Initialized then
      EnableButtonPnl;
   form1.Caption:='AnoBrowser';
end;

procedure TMainForm.WVInitializedMsg(var aMessage : TMessage);
begin
  EnableButtonPnl;
end;

function TMainForm.GetNextTabID : cardinal;
begin
  inc(FLastTabID);
  Result := FLastTabID;
end;

procedure TMainForm.JvSpeedButton1Click(Sender: TObject);
begin
 Form1.show;
end;

procedure TMainForm.JvSpeedButton2Click(Sender: TObject);
begin
// SetCustomCacheDir(ConCat(GetEnvironmentVariable('TMP'),'\ChromeCache'));
// lukutils.RemoveRAMDisk('x');
//    lukutils.CreateRAMDisk('x',1);
//    SetCustomCacheDir('X:\cache');
form4.show;
end;

procedure TMainForm.JvSpeedButton3Click(Sender: TObject);
begin
// SetCustomCacheDir(ConCat(GetEnvironmentVariable('TMP'),'\ChromeCache'));
// lukutils.RemoveRAMDisk('x');
form3.show;

end;

procedure TMainForm.JvSpeedButton4Click(Sender: TObject);
begin

    case    jvPanel1.Visible of
      False: begin
         jvPanel1.Visible:=true;
         if FileExists(ConCat(GetEnvironmentVariable('TMP'),'\luk.pid')) then
         begin
          jvCheckListBox1.Checked[0]:= true;
              if (FileExists(ConCat(GetEnvironmentVariable('TMP'),'\torrc'))) and (pos('UseBridges 1',TFile.ReadAllText(ConCat(GetEnvironmentVariable('TMP'),'\torrc'))) > 0) then  jvCheckListBox1.Checked[1]:=true
              else
                  jvCheckListBox1.Checked[1]:=false;
           ;      //UseBridges 1
         end else begin
          jvCheckListBox1.Checked[0]:=False;
          jvCheckListBox1.Checked[1]:=false;
         end;
         if FileExists(ConCat(GetEnvironmentVariable('TMP'),'\ovpn.pid')) then
          jvCheckListBox1.Checked[3]:= true else  jvCheckListBox1.Checked[3]:=False;
         if FindRamDiskLetter <> '' then
              jvCheckListBox1.Checked[2]:=true else jvCheckListBox1.Checked[2]:=false;

      end;
      True: begin
         jvPanel1.Visible:=false;
      end;
    end;

end;

procedure TMainForm.RemoveTabBtnClick(Sender: TObject);
var
  TempTab : TBrowserTab;
begin
  TempTab := TBrowserTab(BrowserPageCtrl.Pages[BrowserPageCtrl.TabIndex]);
  TempTab.Free;
end;

procedure TMainForm.AddTabBtnClick(Sender: TObject);
var
  TempNewTab : TBrowserTab;
begin
  TempNewTab             := TBrowserTab.Create(self, NextTabID, DEFAULT_TAB_CAPTION);
  TempNewTab.PageControl := BrowserPageCtrl;

  BrowserPageCtrl.ActivePageIndex := pred(BrowserPageCtrl.PageCount);

  TempNewTab.CreateBrowser(HOMEPAGE_URL);
end;

procedure TMainForm.AddTabExtBtnClick(Sender: TObject; eURL: string);
var
  TempNewTab : TBrowserTab;
begin
    TempNewTab             := TBrowserTab.Create(self, NextTabID, eURL);
    TempNewTab.PageControl := BrowserPageCtrl;

     BrowserPageCtrl.ActivePageIndex := pred(BrowserPageCtrl.PageCount);

    TempNewTab.CreateBrowser(eURL);

end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if GlobalWebView2Loader.Initialized then
  begin
    // ����� ����� ���� ��� ��� "������" ��������� � ���������� ���������, ���� ��� ����������
            CloseAllTabs;
  end;
  sleep(2000);
if DirectoryExists(GetEnvironmentVariable('TMP')+'\CustomCache') then
    DeleteFolder(GetEnvironmentVariable('TMP')+'\CustomCache');
if DirectoryExists(GetEnvironmentVariable('APPDATA')+'\tor') then
    DeleteFolder(GetEnvironmentVariable('APPDATA')+'\tor');
end;

procedure TMainForm.CreateNewTab(const aArgs : TCoreWebView2NewWindowRequestedEventArgs);
var
  TempNewTab : TBrowserTab;
begin
  TempNewTab             := TBrowserTab.Create(self, NextTabID, DEFAULT_TAB_CAPTION);
  TempNewTab.PageControl := BrowserPageCtrl;

  BrowserPageCtrl.ActivePageIndex := pred(BrowserPageCtrl.PageCount);

  TempNewTab.CreateBrowser(aArgs);
end;




procedure TMainForm.EnableButtonPnl;
begin
  if not(ButtonPnl.Enabled) then
    begin
      ButtonPnl.Enabled := True;
      Caption           := 'Anon Browser v3.1.2.0';
      cursor            := crDefault;
      if (BrowserPageCtrl.PageCount = 0) then AddTabBtn.Click;
    end;
end;

procedure TMainForm.WMMove(var aMessage : TWMMove);
var
  i : integer;
begin
  inherited;

  i := 0;
  while (i < BrowserPageCtrl.PageCount) do
    begin
      TBrowserTab(BrowserPageCtrl.Pages[i]).NotifyParentWindowPositionChanged;
      inc(i);
    end;
end;

procedure TMainForm.WMMoving(var aMessage : TMessage);
var
  i : integer;
begin
  inherited;

  i := 0;
  while (i < BrowserPageCtrl.PageCount) do
    begin
      TBrowserTab(BrowserPageCtrl.Pages[i]).NotifyParentWindowPositionChanged;
      inc(i);
    end;
end;

procedure GlobalWebView2Loader_OnEnvironmentCreated(Sender: TObject);
begin
  if (MainForm <> nil) and MainForm.HandleAllocated then
    PostMessage(MainForm.Handle, WV_INITIALIZED, 0, 0);
end;

initialization
  GlobalWebView2Loader                      := TWVLoader.Create(nil);
  GlobalWebView2Loader.UserDataFolder:= GetEnvironmentVariable('TMP')+'\CustomCache';
  GlobalWebView2Loader.OnEnvironmentCreated := GlobalWebView2Loader_OnEnvironmentCreated;
  GlobalWebView2Loader.StartWebView2;

end.
