unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvCaptionPanel, JvPanel, JvExControls, JvGradientHeaderPanel,
  Vcl.StdCtrls, JvExStdCtrls, JvMemo, Vcl.Buttons;

type
  TForm2 = class(TForm)
    JvGradientHeaderPanel1: TJvGradientHeaderPanel;
    JvPanel1: TJvPanel;
    JvPanel2: TJvPanel;
    JvMemo1: TJvMemo;
    SpeedButton1: TSpeedButton;
    CheckBox1: TCheckBox;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
       uses uMainForm, unit1;
{$R *.dfm}

procedure TForm2.SpeedButton1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    MainForm.AddTabExtBtnClick(MainForm,'http://18plus.sytes.net/bridges/?transport=obfs4') else
    MainForm.AddTabExtBtnClick(MainForm,'https://bridges.torproject.org/bridges/?transport=obfs4');
    SpeedButton1.Enabled:=false;
end;

procedure TForm2.SpeedButton2Click(Sender: TObject);
begin
JVMemo1.Clear;
Close;
end;

procedure TForm2.SpeedButton3Click(Sender: TObject);
var
  i: Integer;
begin
  if pos('obfs4',JVmemo1.Lines.Text)>0 then
  begin
    form1.JvMemo1.Clear;
    for I := 0 to JVMemo1.Lines.count-1 do
      if pos('obfs4',JVMemo1.Lines[i])>0 then
        Form1.JvMemo1.Lines.Add(JvMemo1.Lines[i]);
    JVMemo1.Clear;
    Close;
  end else
    ShowMessage('NOT FOUND BRIDGE LINES! Skip Apply');

end;

end.
