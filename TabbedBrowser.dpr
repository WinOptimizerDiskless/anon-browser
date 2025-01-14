
  program TabbedBrowser;

uses
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uBrowserFrame in 'uBrowserFrame.pas' {BrowserFrame: TFrame},
  uBrowserTab in 'uBrowserTab.pas',
  uChildForm in 'uChildForm.pas' {ChildForm},
  Luki in 'Luki.pas',
  Unit1 in 'Unit1.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4};

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  Application.Initialize;
      TStyleManager.TrySetStyle('Windows10 BlackPearl');
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
