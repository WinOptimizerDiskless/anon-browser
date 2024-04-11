unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, JvExControls, JvSpeedButton, Vcl.ExtCtrls,
  JvExExtCtrls, JvImage, Vcl.WinXCtrls, JvGradientHeaderPanel, Vcl.StdCtrls,
  JvExStdCtrls, JvMemo, JvExtComponent, JvPanel, JvNavigationPane;

type
  TForm3 = class(TForm)
    JvNavPanelHeader1: TJvNavPanelHeader;
    JvPanel1: TJvPanel;
    JvPanel3: TJvPanel;
    JvImage1: TJvImage;
    JvPanel2: TJvPanel;
    JvSpeedButton2: TJvSpeedButton;
    JvSpeedButton3: TJvSpeedButton;
    procedure JvSpeedButton3Click(Sender: TObject);
    procedure JvSpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation
         uses
            luki, umainform;
{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
if lukutils.VPNPID_ <= 0 then

 begin

   if lukutils.VPNPID_ > 0 then
     begin


             JVSpeedbutton3.Caption:='Connect';
         lukutils.VPNDisconnect;
//      IDTcpServer1.Active:=True;
//      ShowMessage(lukutils.LUKPID_.ToString);

     end;
 end  else


     begin
//          ShowMessage(lukutils.VPNPID_.ToString);
             JVSpeedbutton3.Caption:='Disconnect';
    //           IDTcpServer1.Active:=False;
    //     ShowMessage(lukutils.LUKPID_.ToString);
     end;


end;

procedure TForm3.JvSpeedButton2Click(Sender: TObject);
begin
close;
end;

procedure TForm3.JvSpeedButton3Click(Sender: TObject);
begin
if lukutils.VPNPID_ <= 0 then

 begin
      lukutils.VPNPID_:=lukutils.VPNConnect;
   if lukutils.VPNPID_ > 0 then
     begin
      JVSpeedbutton3.Caption:='Disconnect';
         if MainForm.JvPanel1.Visible then
            mainform.JvCheckListBox1.Checked[3]:=true;


//      IDTcpServer1.Active:=True;
//      ShowMessage(lukutils.LUKPID_.ToString);

     end;
 end  else


     begin
//          ShowMessage(lukutils.VPNPID_.ToString);
         if MainForm.JvPanel1.Visible then
            mainform.JvCheckListBox1.Checked[3]:=false;
             JVSpeedbutton3.Caption:='Connect';
         lukutils.VPNDisconnect;
    //           IDTcpServer1.Active:=False;
    //     ShowMessage(lukutils.LUKPID_.ToString);
     end;


end;

end.