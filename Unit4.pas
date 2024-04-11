unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvPanel, Vcl.StdCtrls, JvExStdCtrls, JvCombobox, JvExControls,
  JvNavigationPane;

type
  TForm4 = class(TForm)
    JvPanel1: TJvPanel;
    JvPanel2: TJvPanel;
    JvPanel3: TJvPanel;
    JvComboBox1: TJvComboBox;
    JvComboBox2: TJvComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    JvNavPanelHeader1: TJvNavPanelHeader;
    procedure JvComboBox2DropDown(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure JvComboBox2Select(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation
            uses
                luki, uMainForm, ioutils;
{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
begin
//    if IsRamDisk('X') then showmessage('RAM') else ShowMessage('NOT RAM');
  if Button2.caption  = 'Unmount' then
      begin
         MainForm.SetCustomCacheDir(ConCat(GetEnvironmentVariable('TMP'),'\ChromeCache'));
         lukutils.RemoveRAMDisk(Char(JvComboBox2.Items[JVCombobox2.ItemIndex][1]));
         Label1.Caption:='';
         label2.Caption:='Unmounted';
         Label3.Caption:='NO FOUND RAM';
         button2.Caption:='Mount';
         if MainForm.JvPanel1.Visible then
            mainform.JvCheckListBox1.Checked[2]:=false;
      end else
  begin
  //    lukutils.CreateRAMDisk('x',1);
//    SetCustomCacheDir('X:\cache');
         lukutils.CreateRAMDisk(Char(JvComboBox2.Items[JVCombobox2.ItemIndex][1]),JvComboBox1.Items[JVCombobox1.ItemIndex].Replace(' MB','').Replace(' ( 3 GB )','').Replace(' ( 2 GB )','').Replace(' ( 1 GB )','').ToInteger());
         MainForm.SetCustomCacheDir(ConCat(JvComboBox2.Items[JVCombobox2.ItemIndex][1], ':\cache'));

         Label1.Caption:=JvComboBox2.Items[JVCombobox2.ItemIndex][1];
         label2.Caption:='Ìunted';
         Label3.Caption:='FOUND';
         button2.Caption:='Unmount';
         if MainForm.JvPanel1.Visible then
            mainform.JvCheckListBox1.Checked[2]:=true;
  end
  ;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
Close;
end;

procedure TForm4.FormCreate(Sender: TObject);

var
  FreeDriveLetters: TStringList;
begin
//  FreeDriveLetters:=TStringList.Create;
//  FreeDriveLetters := lukutils.GetFreeDriveLetters;
//  try
////      ShowMessage(FreeDriveLetters.Text);
//      JVCombobox2.Items.Assign(FreeDriveLetters);
//  finally
//    FreeDriveLetters.Free;
//  end;
//if JVCombobox2.Items.Count >= 0 then
  lukutils.PopulateComboBoxWithFreeDriveLetters(JVCombobox2, label1);
  if Length(Label1.Caption)>0 then
      begin
        Label2.Caption:='Mounted';
        Button2.Caption:='Unmount';
        Label3.Caption:='FOUND';
         JVComboBox1.ItemIndex:=JVComboBox1.Items.IndexOf(ConCat(TFile.ReadAllText(ConCat(AnsiChar(JvComboBox2.Items[JVCombobox2.ItemIndex][1]),':\.ramdisk.mask')),' MB'));
        if JVComboBox1.ItemIndex = -1 then
           JVComboBox1.ItemIndex:=JVComboBox1.Items.IndexOf(ConCat(TFile.ReadAllText(ConCat(AnsiChar(JvComboBox2.Items[JVCombobox2.ItemIndex][1]),':\.ramdisk.mask')),' MB ( 1 GB )'));
        if JVComboBox1.ItemIndex = -1 then
           JVComboBox1.ItemIndex:=JVComboBox1.Items.IndexOf(ConCat(TFile.ReadAllText(ConCat(AnsiChar(JvComboBox2.Items[JVCombobox2.ItemIndex][1]),':\.ramdisk.mask')),' MB ( 2 GB )'));
        if JVComboBox1.ItemIndex = -1 then
           JVComboBox1.ItemIndex:=JVComboBox1.Items.IndexOf(ConCat(TFile.ReadAllText(ConCat(AnsiChar(JvComboBox2.Items[JVCombobox2.ItemIndex][1]),':\.ramdisk.mask')),' MB ( 3 GB )'));

      end
        else
      begin
       JVCombobox1.ItemIndex:=4;
       Label2.Caption:='Unmouned';
       Button2.Caption:='Mount';
       Label3.Caption:='NOT FOUND';
      end;


end;

procedure TForm4.JvComboBox2DropDown(Sender: TObject);



begin
  lukutils.PopulateComboBoxWithFreeDriveLetters(JVCombobox2, label1);

end;

procedure TForm4.JvComboBox2Select(Sender: TObject);
begin
      if  IsRamDisk(AnsiChar(JvComboBox2.Items[JVCombobox2.ItemIndex][1])) then
      begin
        Label2.Caption:='Mounted';
        Button2.Caption:='Unmount';
         JVComboBox1.ItemIndex:=JVComboBox1.Items.IndexOf(ConCat(TFile.ReadAllText(ConCat(AnsiChar(JvComboBox2.Items[JVCombobox2.ItemIndex][1]),':\.ramdisk.mask')),' MB'));
        if JVComboBox1.ItemIndex = -1 then
           JVComboBox1.ItemIndex:=JVComboBox1.Items.IndexOf(ConCat(TFile.ReadAllText(ConCat(AnsiChar(JvComboBox2.Items[JVCombobox2.ItemIndex][1]),':\.ramdisk.mask')),' MB ( 1 GB )'));
        if JVComboBox1.ItemIndex = -1 then
           JVComboBox1.ItemIndex:=JVComboBox1.Items.IndexOf(ConCat(TFile.ReadAllText(ConCat(AnsiChar(JvComboBox2.Items[JVCombobox2.ItemIndex][1]),':\.ramdisk.mask')),' MB ( 2 GB )'));
        if JVComboBox1.ItemIndex = -1 then
           JVComboBox1.ItemIndex:=JVComboBox1.Items.IndexOf(ConCat(TFile.ReadAllText(ConCat(AnsiChar(JvComboBox2.Items[JVCombobox2.ItemIndex][1]),':\.ramdisk.mask')),' MB ( 3 GB )'));
      end
        else
      begin

        Label2.Caption:='Unmounted';
        Button2.Caption:='Mount';
      end;

end;

end.
