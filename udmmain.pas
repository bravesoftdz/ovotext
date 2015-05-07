{ Ovotext - simple text editor

  Copyright (C) 2015 Marco Caselli <marcocas@gmail.com>

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
}
unit udmmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Dialogs,
  SupportFuncs, SynEditHighlighter, SynExportHTML, fgl, Graphics, config,
  Stringcostants, SynExportRTF,
  // included with Lazarus
  SynHighlighterPas,
  SynHighlighterCpp, SynHighlighterJava, SynHighlighterPerl, SynHighlighterHTML,
  SynHighlighterXML, SynHighlighterLFM, synhighlighterunixshellscript,
  SynHighlighterCss, SynHighlighterPHP, SynHighlighterTeX, SynHighlighterSQL,
  SynHighlighterPython, SynHighlighterVB, SynHighlighterBat, SynHighlighterIni,
  SynHighlighterPo,
  // from other people
  SynHighlighterTclTk, SynHighlighterRuby, SynHighlighterCS,
  SynHighlighterHaskell, SynHighlighterFoxpro, SynHighlighterInno,
  SynHighlighterDml, SynHighlighterCAC, SynHighlighterModelica,
  SynHighlighterVrml97, SynHighlighterHP48, SynHighlighterAWK,
  SynHighlighterProgress, SynHighlighterEiffel, SynHighlighterBaan,
  SynHighlighterDiff, SynHighlighterJScript,
  SynHighlighterM3, SynHighlighterLDraw, SynHighlighterVBScript,
  SynHighlighterSml, SynHighlighterIDL, SynHighlighterCobol, SynHighlighterGWS,
  SynHighlighterAsm, SynHighlighterLua, SynHighlighterFortran,
  SynHighlighterProlog, SynHighlighterRC;

type

  RHighlighter = record
    HLClass: TSynCustomHighlighterClass;
    Filter: string;
    HL: TSynCustomHighlighter;
  end;

const
  HIGHLIGHTERCOUNT = 46;
  ARHighlighter: array [0..HIGHLIGHTERCOUNT - 1] of RHighlighter = (
  (HLClass: TSynAWKSyn; Filter: 'AWK Script (*.awk)|*.awk'; HL: nil),
  (HLClass: TSynBaanSyn; Filter: 'Baan 4GL Files (*.cln)|*.cln'; HL: nil),
  (HLClass: TSynCppSyn; Filter: 'C++ Files (*.c,*.cpp,*.h,*.hpp,*.hh)|*.c;*.cpp;*.h;*.hpp;*.hh'; HL: nil),
  (HLClass: TSynCACSyn; Filter: 'CA-Clipper Files (*.prg,*.ch,*.inc)|*.prg;*.ch;*.inc'; HL: nil),
  (HLClass: TSynCssSyn; Filter: 'Cascading Stylesheets (*.css)|*.css'; HL: nil),
  (HLClass: TSynCobolSyn; Filter: 'COBOL Files (*.cbl;*.cob)|*.cbl;*.cob'; HL: nil),
  (HLClass: TSynIdlSyn; Filter: 'CORBA IDL files (*.idl)|*.idl'; HL: nil),
  (HLClass: TSynCSSyn; Filter: 'C# Files (*.cs)|*.cs'; HL: nil),
  (HLClass: TSynDiffSyn; Filter: 'Diff Files (*.diff)|*.diff'; HL: nil),
  (HLClass: TSynEiffelSyn; Filter: 'Eiffel (*.e;*.ace)|*.e;*.ace'; HL: nil),
  (HLClass: TSynFortranSyn; Filter: 'Fortran Files (*.for)|*.for'; HL: nil),
  (HLClass: TSynFoxproSyn; Filter: 'Foxpro Files (*.prg)|*.prg'; HL: nil),
  (HLClass: TSynDmlSyn; Filter: 'GEMBASE Files (*.dml,*.gem)|*.DML;*.GEM'; HL: nil),
  (HLClass: TSynGWScriptSyn; Filter: 'GW-TEL Script Files (*.gws)|*.gws'; HL: nil),
  (HLClass: TSynHaskellSyn; Filter: 'Haskell Files (*.hs;*.lhs)|*.hs;*.lhs'; HL: nil),
  (HLClass: TSynHP48Syn; Filter: 'HP48 Files (*.s,*.sou,*.a,*.hp)|*.s;*.sou;*.a;*.hp'; HL: nil),
  (HLClass: TSynHTMLSyn; Filter: 'HTML Document (*.htm,*.html)|*.htm;*.html'; HL: nil),
  (HLClass: TSynIniSyn; Filter: 'INI Files (*.ini)|*.ini'; HL: nil),
  (HLClass: TSynInnoSyn; Filter: 'Inno Setup Scripts (*.iss)|*.iss'; HL: nil),
  (HLClass: TSynJavaSyn; Filter: 'Java Files (*.java)|*.java'; HL: nil),
  (HLClass: TSynJScriptSyn; Filter: 'Javascript Files (*.js)|*.js'; HL: nil),
  (HLClass: TSynLFMSyn; Filter: 'Lazarus Form Files (*.lfm)|*.lfm'; HL: nil),
  (HLClass: TSynLDRSyn; Filter: 'LEGO LDraw Files (*.ldr)|*.ldr'; HL: nil),
  (HLClass: TSynLuaSyn; Filter: 'Lua Script File (*.Lua)|*.Lua'; HL: nil),
  (HLClass: TSynModelicaSyn; Filter: 'Modelica Files (*.mo)|*.mo'; HL: nil),
  (HLClass: TSynM3Syn; Filter: 'Modula-3 Files (*.m3)|*.m3'; HL: nil),
  (HLClass: TSynVBScriptSyn; Filter: 'VBScript Files (*.vbs)|*.vbs'; HL: nil),
  (HLClass: TSynBatSyn; Filter: 'MS-DOS Batch Files (*.bat;*.cmd)|*.bat;*.cmd'; HL: nil),
  (HLClass: TSynPasSyn; Filter: 'Pascal Files (*.pas,*.dpr,*.dpk,*.inc)|*.pas;*.dpr;*.dpk;*.inc'; HL: nil),
  (HLClass: TSynPerlSyn; Filter: 'Perl Files (*.pl,*.pm,*.cgi)|*.pl;*.pm;*.cgi'; HL: nil),
  (HLClass: TSynPHPSyn; Filter: 'PHP Files (*.php,*.php3,*.phtml,*.inc)|*.php;*.php3;*.phtml;*.inc'; HL: nil),
  (HLClass: TSynPoSyn; Filter: 'Po Files (*.po)|*.po'; HL: nil),
  (HLClass: TSynProgressSyn; Filter: 'Progress Files (*.w,*.p,*.i)|*.w;*.p;*.i'; HL: nil),
  (HLClass: TSynPrologSyn; Filter: 'Prolog Files (*.pl;*.pro;*.prl)|*.pl;*.pro;*.prl';HL: nil),
  (HLClass: TSynPythonSyn; Filter: 'Python Files (*.py)|*.py'; HL: nil),
  (HLClass: TSynRCSyn; Filter: 'Resource Files (*.rc)|*.rc'; HL: nil),
  (HLClass: TSynRubySyn; Filter: 'Ruby Files (*.rb;*.rbw)|*.rb;*.rbw'; HL: nil),
  (HLClass: TSynSQLSyn; Filter: 'SQL Files (*.sql)|*.sql'; HL: nil),
  (HLClass: TSynSMLSyn; Filter: 'Standard ML Files (*.sml)|*.sml'; HL: nil),
  (HLClass: TSynTclTkSyn; Filter: 'Tcl/Tk Files (*.tcl)|*.tcl'; HL: nil),
  (HLClass: TSynTeXSyn; Filter: 'TeX Files (*.tex)|*.tex'; HL: nil),
  (HLClass: TSynUNIXShellScriptSyn; Filter: 'UNIX Shell Scripts (*.sh)|*.sh'; HL: nil),
  (HLClass: TSynVBSyn; Filter: 'Visual Basic Files (*.bas)|*.bas'; HL: nil),
  (HLClass: TSynVrml97Syn; Filter:'Vrml97/X3D World (*.wrl;*.wrml;*.vrl;*.vrml;*.x3d)|*.wrl;*.wrml;*.vrl;*.vrml;*.x3d'; HL: nil),
  (HLClass: TSynAsmSyn; Filter: 'x86 Assembly Files (*.asm)|*.ASM'; HL: nil),
  (HLClass: TSynXMLSyn; Filter: 'XML Document (*.xml,*.xsd,*.xsl,*.xslt,*.dtd)|*.xml;*.xsd;*.xsl;*.xslt;*.dtd';    HL: nil)

  {  (HLClass: TSynPasSyn; Filter: 'Pascal Files (*.pas,*.dpr,*.dpk,*.inc)|*.pas;*.dpr;*.dpk;*.inc'; HL: nil),
    (HLClass: TSynCppSyn; Filter: 'C++ Files (*.c,*.cpp,*.h,*.hpp,*.hh)|*.c;*.cpp;*.h;*.hpp;*.hh'; HL: nil),
    (HLClass: TSynJavaSyn; Filter: 'Java Files (*.java)|*.java'; HL: nil),
    (HLClass: TSynPerlSyn; Filter: 'Perl Files (*.pl,*.pm,*.cgi)|*.pl;*.pm;*.cgi'; HL: nil),
    (HLClass: TSynHTMLSyn; Filter: 'HTML Document (*.htm,*.html)|*.htm;*.html'; HL: nil),
    (HLClass: TSynXMLSyn; Filter: 'XML Document (*.xml,*.xsd,*.xsl,*.xslt,*.dtd)|*.xml;*.xsd;*.xsl;*.xslt;*.dtd';    HL: nil),
    (HLClass: TSynLFMSyn; Filter: 'Lazarus Form Files (*.lfm)|*.lfm'; HL: nil),
    (HLClass: TSynUNIXShellScriptSyn; Filter: 'UNIX Shell Scripts (*.sh)|*.sh'; HL: nil),
    (HLClass: TSynCssSyn; Filter: 'Cascading Stylesheets (*.css)|*.css'; HL: nil),
    (HLClass: TSynPHPSyn; Filter: 'PHP Files (*.php,*.php3,*.phtml,*.inc)|*.php;*.php3;*.phtml;*.inc'; HL: nil),
    (HLClass: TSynTeXSyn; Filter: 'TeX Files (*.tex)|*.tex'; HL: nil),
    (HLClass: TSynSQLSyn; Filter: 'SQL Files (*.sql)|*.sql'; HL: nil),
    (HLClass: TSynPythonSyn; Filter: 'Python Files (*.py)|*.py'; HL: nil),
    (HLClass: TSynVBSyn; Filter: 'Visual Basic Files (*.bas)|*.bas'; HL: nil),
    (HLClass: TSynBatSyn; Filter: 'MS-DOS Batch Files (*.bat;*.cmd)|*.bat;*.cmd'; HL: nil),
    (HLClass: TSynIniSyn; Filter: 'INI Files (*.ini)|*.ini'; HL: nil),
    (HLClass: TSynPoSyn; Filter: 'Po Files (*.po)|*.po'; HL: nil),
    (HLClass: TSynTclTkSyn; Filter: 'Tcl/Tk Files (*.tcl)|*.tcl'; HL: nil),
    (HLClass: TSynRubySyn; Filter: 'Ruby Files (*.rb;*.rbw)|*.rb;*.rbw'; HL: nil),
    (HLClass: TSynCSSyn; Filter: 'C# Files (*.cs)|*.cs'; HL: nil),
    (HLClass: TSynHaskellSyn; Filter: 'Haskell Files (*.hs;*.lhs)|*.hs;*.lhs'; HL: nil),
    (HLClass: TSynFoxproSyn; Filter: 'Foxpro Files (*.prg)|*.prg'; HL: nil),
    (HLClass: TSynInnoSyn; Filter: 'Inno Setup Scripts (*.iss)|*.iss'; HL: nil),
    (HLClass: TSynDmlSyn; Filter: 'GEMBASE Files (*.dml,*.gem)|*.DML;*.GEM'; HL: nil),
    (HLClass: TSynCACSyn; Filter: 'CA-Clipper Files (*.prg,*.ch,*.inc)|*.prg;*.ch;*.inc'; HL: nil),
    (HLClass: TSynModelicaSyn; Filter: 'Modelica Files (*.mo)|*.mo'; HL: nil),
    (HLClass: TSynVrml97Syn; Filter:'Vrml97/X3D World (*.wrl;*.wrml;*.vrl;*.vrml;*.x3d)|*.wrl;*.wrml;*.vrl;*.vrml;*.x3d'; HL: nil),
    (HLClass: TSynHP48Syn; Filter: 'HP48 Files (*.s,*.sou,*.a,*.hp)|*.s;*.sou;*.a;*.hp'; HL: nil),
    (HLClass: TSynAWKSyn; Filter: 'AWK Script (*.awk)|*.awk'; HL: nil),
    (HLClass: TSynProgressSyn; Filter: 'Progress Files (*.w,*.p,*.i)|*.w;*.p;*.i'; HL: nil),
    (HLClass: TSynEiffelSyn; Filter: 'Eiffel (*.e;*.ace)|*.e;*.ace'; HL: nil),
    (HLClass: TSynBaanSyn; Filter: 'Baan 4GL Files (*.cln)|*.cln'; HL: nil),
    (HLClass: TSynDiffSyn; Filter: 'Diff Files (*.diff)|*.diff'; HL: nil),
    (HLClass: TSynJScriptSyn; Filter: 'Javascript Files (*.js)|*.js'; HL: nil),
    (HLClass: TSynM3Syn; Filter: 'Modula-3 Files (*.m3)|*.m3'; HL: nil),
    (HLClass: TSynLDRSyn; Filter: 'LEGO LDraw Files (*.ldr)|*.ldr'; HL: nil),
    (HLClass: TSynVBScriptSyn; Filter: 'VBScript Files (*.vbs)|*.vbs'; HL: nil),
    (HLClass: TSynSMLSyn; Filter: 'Standard ML Files (*.sml)|*.sml'; HL: nil),
    (HLClass: TSynIdlSyn; Filter: 'CORBA IDL files (*.idl)|*.idl'; HL: nil),
    (HLClass: TSynCobolSyn; Filter: 'COBOL Files (*.cbl;*.cob)|*.cbl;*.cob'; HL: nil),
    (HLClass: TSynGWScriptSyn; Filter: 'GW-TEL Script Files (*.gws)|*.gws'; HL: nil),
    (HLClass: TSynAsmSyn; Filter: 'x86 Assembly Files (*.asm)|*.ASM'; HL: nil),
    (HLClass: TSynLuaSyn; Filter: 'Lua Script File (*.Lua)|*.Lua'; HL: nil),
    (HLClass: TSynFortranSyn; Filter: 'Fortran Files (*.for)|*.for'; HL: nil),
    (HLClass: TSynPrologSyn; Filter: 'Prolog Files (*.pl;*.pro;*.prl)|*.pl;*.pro;*.prl';HL: nil),
    (HLClass: TSynRCSyn; Filter: 'Resource Files (*.rc)|*.rc'; HL: nil)   }
    );

type

  { TdmMain }
  THighLighterList = specialize TFPGMap<string, integer>;


  TdmMain = class(TDataModule)
    imgBookMark: TImageList;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    fHighlighters: THighLighterList;
    fRTFExporter : TSynExporterRTF;
    fHTMLExporter : TSynExporterHTML;
    procedure FontAttribToAttribute(Attribute: TSynHighlighterAttributes;
      Attrib: TFontAttributes);
    function GetSynExporterHTML: TSynExporterHTML;
    function GetSynExporterRTF: TSynExporterRTF;
    procedure LoadHighlighters;
    procedure SetAttribute(AttrName: string;
      Attribute: TSynHighlighterAttributes; DefaultAttrib: TFontAttributes);
  public
    procedure InitializeHighlighter(Highlighter: TSynCustomHighlighter);

    Property RFTExporter: TSynExporterRTF read GetSynExporterRTF;
    Property HTMLExporter: TSynExporterHTML read GetSynExporterHTML;
    function getHighLighter(Extension: string): TSynCustomHighlighter;
    function GetFiters: string;

  end;

var
  dmMain: TdmMain;


implementation

uses lclproc;

{$R *.lfm}

{ TdmMain }

procedure TdmMain.DataModuleCreate(Sender: TObject);
begin
  fHighlighters := THighlighterList.Create;
  LoadHighlighters;
end;

procedure TdmMain.DataModuleDestroy(Sender: TObject);
begin
  fHighlighters.Free;
end;

procedure TdmMain.LoadHighlighters;
var
  i, j: integer;
  filter: string;
  stList: TStringList;
begin

  fHighlighters.Clear;
  for i := 0 to HIGHLIGHTERCOUNT - 1 do
  begin
    Filter := LowerCase(ARHighlighter[i].Filter);
    j := Pos('|', Filter);
    if j > 0 then
    begin
      Delete(Filter, 1, j);
      stList := TStringList.Create;
      StrToStrings(filter, ';', stList, False);
      for j := 0 to stList.Count - 1 do
        fHighlighters.Add(ExtractFileExt(stList[j]), i);
      stList.Free;
    end;
  end;

end;


procedure TdmMain.FontAttribToAttribute( Attribute: TSynHighlighterAttributes; Attrib: TFontAttributes);
begin
  Attribute.Foreground:=Attrib.Foreground;
  Attribute.Background:=Attrib.Background;
  Attribute.Style:=Attrib.Styles;

end;

function TdmMain.GetSynExporterHTML: TSynExporterHTML;
begin
  if not Assigned(fHTMLExporter) then
    fHTMLExporter:= TSynExporterHTML.Create(Self);
  result := fHTMLExporter;
end;

function TdmMain.GetSynExporterRTF: TSynExporterRTF;
begin
  if not Assigned(fRTFExporter) then
    fRTFExporter:= TSynExporterRTF.Create(Self);
  result := fRTFExporter;
end;

procedure TdmMain.SetAttribute(AttrName:string; Attribute: TSynHighlighterAttributes; DefaultAttrib: TFontAttributes);
var
  tmpAttribs: TFontAttributes;
begin
  if not Assigned(Attribute) then
    exit;
  tmpAttribs := ConfigObj.ReadFontAttributes(AttrName,DefaultAttrib);
  FontAttribToAttribute(Attribute, tmpAttribs);
end;

procedure TdmMain.InitializeHighlighter(Highlighter: TSynCustomHighlighter);
var
  i: integer;
  AttrName: string;
  DefaultAttrib: TFontAttributes;
begin
  DefaultAttrib:= ConfigObj.ReadFontAttributes('Default/Text', FontAttributes());

  if Configobj.XMLConfigExtended.PathExists('Schema/'+CleanupName(Highlighter.GetLanguageName)) then
    begin
      for i := 0 to Highlighter.AttrCount - 1 do
        begin
          AttrName:=CleanupName(Highlighter.GetLanguageName)+'/'+CleanupName(Highlighter.Attribute[i].Name)+'/';
          SetAttribute(AttrName, Highlighter.Attribute[i], DefaultAttrib);
        end;
    end
  else
    begin
      for i := 0 to Highlighter.AttrCount - 1 do
          FontAttribToAttribute(Highlighter.Attribute[i], DefaultAttrib);

      SetAttribute('Schema/DefaultLang/String/', Highlighter.StringAttribute, DefaultAttrib);
      SetAttribute('Schema/DefaultLang/Comment/', Highlighter.CommentAttribute, DefaultAttrib);
      SetAttribute('Schema/DefaultLang/Identifier/', Highlighter.IdentifierAttribute, DefaultAttrib);
      SetAttribute('Schema/DefaultLang/Keyword/', Highlighter.KeywordAttribute, DefaultAttrib);
      SetAttribute('Schema/DefaultLang/Symbol/', Highlighter.SymbolAttribute, DefaultAttrib);
      SetAttribute('Schema/DefaultLang/Whitespace/', Highlighter.WhitespaceAttribute, DefaultAttrib);

    end;
    ConfigObj.XMLConfigExtended.CloseKey;

end;

function TdmMain.getHighLighter(Extension: string): TSynCustomHighlighter;
var
  tmp: integer;
  idx: integer;

begin
  tmp := fHighlighters.IndexOf(Extension);
  if tmp > -1 then
  begin
    idx := fHighlighters.Data[tmp];
    if not Assigned(ARHighlighter[idx].HL) then
    begin
      ARHighlighter[idx].HL := ARHighlighter[idx].HLClass.Create(Self);
      InitializeHighlighter(ARHighlighter[idx].HL);
    end;
    Result := ARHighlighter[idx].HL;
  end
  else
    Result := nil;
end;

function TdmMain.GetFiters: string;
var
  i: integer;
begin
  Result := RSAllFile + ' ('+GetAllFilesMask+')|' + GetAllFilesMask;
  for i := 0 to HIGHLIGHTERCOUNT - 1 do
   result := Result+'|' +ARHighlighter[i].Filter;

end;

end.
