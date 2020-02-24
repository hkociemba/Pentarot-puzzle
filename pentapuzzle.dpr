program pentapuzzle;

uses
  Vcl.Forms,
  puzzle in 'puzzle.pas' {Form1},
  tables in 'tables.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
