program prjAjustaECD;

uses
  Forms,
  uAjustaECD in 'uAjustaECD.pas' {frmAjustaECD};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAjustaECD, frmAjustaECD);
  Application.Run;
end.
