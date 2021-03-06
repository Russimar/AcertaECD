unit uAjustaECD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit, Buttons;

type
  TfrmAjustaECD = class(TForm)
    btnAjustar: TBitBtn;
    btnFechar: TBitBtn;
    FilenameEdit1: TFilenameEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFecharClick(Sender: TObject);
    procedure btnAjustarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    LinhaECD: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAjustaECD: TfrmAjustaECD;

implementation

{$R *.dfm}

procedure TfrmAjustaECD.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmAjustaECD.btnFecharClick(Sender: TObject);
begin
  close;
end;

procedure TfrmAjustaECD.btnAjustarClick(Sender: TObject);
var
  ECD, ECDNOVO: TextFile;
  Contador: Integer;
  NomeArquivoNovo, TipoRegistro: string;
  SavCursor : TCursor;
begin
  if FilenameEdit1.Text = '' then
  begin
    showmessage('Informe o caminho do arquivo');
    FilenameEdit1.SetFocus;
    exit;
  end;
  AssignFile(ECD, FilenameEdit1.Text);

  Contador := 0;
  NomeArquivoNovo := StringReplace(FilenameEdit1.Text, '.TXT', '_New.txt', [rfReplaceAll]);
  Assignfile(ECDNOVO, NomeArquivoNovo);
  SavCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  btnAjustar.Enabled := False;
  btnFechar.Enabled := False;
  try
    //Contar numero de linhas
    Reset(ECD);
    while not Eof(ECD) do
    begin
      Readln(ECD, LinhaECD);
      Inc(Contador);
    end;
    CloseFile(ECD);

    Rewrite(ECDNOVO);
    Reset(ECD);
    while not Eof(ECD) do
    begin
      Readln(ECD, LinhaECD);
      TipoRegistro := copy(LinhaECD,2,4);
      if TipoRegistro = 'I010' then
        LinhaECD := StringReplace(LinhaECD,'5.00','6.00',[rfReplaceAll]);
      if (TipoRegistro = 'I030') or (TipoRegistro = 'J900') then
        LinhaECD := StringReplace(LinhaECD,'|9999|','|'+ IntToStr(Contador)+'|',[rfReplaceAll]);
      if (TipoRegistro = 'J100') or (TipoRegistro = 'J150') then
        LinhaECD := LinhaECD + '|';
      Writeln(ECDNOVO, LinhaECD);
    end;
  finally
    btnAjustar.Enabled := True;
    btnFechar.Enabled := True;
    Screen.Cursor := SavCursor;
    CloseFile(ECD);
    CloseFile(ECDNOVO);
    ShowMessage('Arquivo Gerado');
  end;

end;

procedure TfrmAjustaECD.FormShow(Sender: TObject);
begin
  FilenameEdit1.Text := ExtractFileDir(application.exename) + '\ECD.TXT';
end;

end.

