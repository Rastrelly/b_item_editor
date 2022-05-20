unit ubitemedit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  itm = record
    name, category, sellable, value, icon, str_bon, agi_bon, spd_bon,
    int_bon, gives_perk, dmg, str_scl, agi_scl, spd_scl, int_scl, crit_bon,
    base_accuracy, reload_time, dmg_time, description, stamina_dtain, mana_drain,
    armor_bonus, shield_bonus, provides_spell:string;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    btnAdd: TButton;
    btnLoad1: TButton;
    btnRem: TButton;
    btnRem1: TButton;
    btnSave: TButton;
    btnLoad: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    chbSellable: TCheckBox;
    cbCategory: TComboBox;
    cbDmgType: TComboBox;
    edtSetSize: TEdit;
    edPerk: TEdit;
    edDmg: TEdit;
    edStrScl: TEdit;
    edAgiScl: TEdit;
    edSpdScl: TEdit;
    EdIntScl: TEdit;
    edCritBon: TEdit;
    edBaseAcc: TEdit;
    edReloadTime: TEdit;
    edStaminaDrain: TEdit;
    edName: TEdit;
    edManaDrain: TEdit;
    edArmorBon: TEdit;
    edShldBon: TEdit;
    edSpell: TEdit;
    edtPath: TEdit;
    edValue: TEdit;
    edIcon: TEdit;
    edStrBon: TEdit;
    edAgiBon: TEdit;
    edSpdBon: TEdit;
    edIntBon: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbName: TListBox;
    memoDescription: TMemo;
    memoPreview: TMemo;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    procedure removeitem(id:integer);
    procedure btnAddClick(Sender: TObject);
    procedure btnLoad1Click(Sender: TObject);
    procedure btnRem1Click(Sender: TObject);
    procedure btnRemClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbNameClick(Sender: TObject);
    procedure SaveSettings;
    procedure LoadSettings;
    procedure listitms;
    procedure updateitem(id:integer);
    procedure showitem(id:integer);
    procedure btnLoadClick(Sender: TObject);
    procedure cbCategoryChange(Sender: TObject);
    procedure makelist;
    procedure buildlist;
  private

  public

  end;

var
  Form1: TForm1;
  itms:array of itm;
  f:textfile;
  appfolder:string;
  aa:integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.LoadSettings;
var fn,wf:string;
begin
  fn:=appfolder+'settings_ie.cfg';
  if FileExists(fn) then
  begin
    AssignFile(f,fn);
    reset(f);
    ReadLn(f,wf);
    edtPath.Text:=wf;
    closefile(f);
  end;
end;

procedure TForm1.SaveSettings;
var fn:string;
begin
  fn:=appfolder+'settings_ie.cfg';
  AssignFile(f,fn);
  Rewrite(f);
  WriteLn(f,edtPath.Text);
  CloseFile(f);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  appfolder:=extractfiledir(Application.ExeName)+'\';
  LoadSettings;
end;

procedure TForm1.lbNameClick(Sender: TObject);
begin
  aa:=lbName.ItemIndex;
  showitem(aa);
end;

procedure TForm1.btnLoad1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    edtPath.Text:=OpenDialog1.FileName;
  end;
  SaveSettings;
end;

procedure TForm1.btnRem1Click(Sender: TObject);
begin
  updateitem(aa);
end;

procedure TForm1.btnRemClick(Sender: TObject);
begin
  removeitem(aa);
end;

procedure tform1.listitms;
var i:integer;
begin
  lbName.Clear;
  if length(itms)>0 then begin
    for i:=0 to Length(itms)-1 do lbName.AddItem(inttostr(i)+') '+itms[i].name+' ('+itms[i].category+')',lbName);
  end;
end;



procedure tform1.showitem(id:integer);
begin
  if (id>=0) and (id<length(itms)) then
  with itms[id] do
  begin
    edName.Text:=name;
    cbCategory.Text:=category;
    chbSellable.Checked:=strtobool(sellable);
    edValue.Text:=value;
    edIcon.Text:=icon;
    edStrBon.Text:=str_bon;
    edAgiBon.Text:=agi_bon;
    edSpdBon.text:=spd_bon;
    edIntBon.text:=int_bon;
    edPerk.Text:=gives_perk;
    edDmg.Text:=dmg;
    edStrScl.Text:=str_scl;
    edAgiScl.Text:=agi_scl;
    edSpdScl.Text:=spd_scl;
    edIntScl.Text:=int_scl;
    edCritBon.text:=crit_bon;
    edBaseAcc.text:=base_accuracy;
    edReloadTime.Text:=reload_time;
    cbDmgType.Text:=dmg_time;
    memoDescription.Text:=description;
    edStaminaDrain.text:=stamina_dtain;
    edManaDrain.Text:=mana_drain;
    edArmorBon.Text:=armor_bonus;
    edShldBon.Text:=shield_bonus;
    edSpell.Text:=provides_spell;
  end;
end;


procedure tform1.removeitem(id:integer);
var i:integer;
begin
  if (id>=0)  and (id<Length(itms)-1) then
  for i:=id to length(itms)-2 do
  begin
    itms[i]:=itms[i+1];
  end;
  setlength(itms,length(itms)-1);
end;

procedure TForm1.updateitem(id:integer);
var s:string;
begin
  with itms[id] do
  begin
    name:=edName.Text;
    category:=cbCategory.Text;
    sellable:=booltostr(chbSellable.Checked);
    value:=edValue.Text;
    icon:=edIcon.Text;
    str_bon:=edStrBon.Text;
    agi_bon:=edAgiBon.Text;
    spd_bon:=edSpdBon.text;
    int_bon:=edIntBon.text;
    gives_perk:=edPerk.Text;
    dmg:=edDmg.Text;
    str_scl:=edStrScl.Text;
    agi_scl:=edAgiScl.Text;
    spd_scl:=edSpdScl.Text;
    int_scl:=edIntScl.Text;
    crit_bon:=edCritBon.text;
    base_accuracy:=edBaseAcc.text;
    reload_time:=edReloadTime.Text;
    dmg_time:=cbDmgType.Text;
    description:=memoDescription.Text;
    stamina_dtain:=edStaminaDrain.text;
    mana_drain:=edManaDrain.Text;
    armor_bonus:=edArmorBon.Text;
    shield_bonus:=edShldBon.Text;
    provides_spell:=edSpell.Text;
  end;
  listitms;;
end;

procedure TForm1.btnAddClick(Sender: TObject);
begin
  setlength(itms,length(itms)+1);
  updateitem(high(itms));
  aa:=High(itms);
  lbName.ItemIndex:=aa;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
   memoPreview.Lines.SaveToFile(edtPath.Text);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  buildlist;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  makelist;
end;

procedure TForm1.cbCategoryChange(Sender: TObject);
begin
end;

procedure TForm1.btnLoadClick(Sender: TObject);
begin
  memoPreview.Lines.LoadFromFile(edtPath.Text);
end;

procedure tform1.makelist;
var titm:itm;
    i,k,sz:integer;
begin
  if (MessageDlg('Warning','This will purge current item set and read item set from file. Are you sure you want to do it?',mtWarning,[mbOK,mbCancel],0))=mrOK then
  begin
  SetLength(itms,0); k:=0;
  edtSetSize.Text:=memoPreview.Lines[0];
  sz:=strtoint(edtSetSize.Text);
  for i := 1 to memoPreview.Lines.Count do
  begin
  with titm do
  begin
    if (k=0) then name:=memoPreview.Lines[i];
    if (k=1) then category:=memoPreview.Lines[i];
    if (k=2) then sellable:=memoPreview.Lines[i];
    if (k=3) then value:=memoPreview.Lines[i];
    if (k=4) then icon:=memoPreview.Lines[i];
    if (k=5) then str_bon:=memoPreview.Lines[i];
    if (k=6) then agi_bon:=memoPreview.Lines[i];
    if (k=7) then spd_bon:=memoPreview.Lines[i];
    if (k=8) then int_bon:=memoPreview.Lines[i];
    if (k=9) then gives_perk:=memoPreview.Lines[i];
    if (k=10) then dmg:=memoPreview.Lines[i];
    if (k=11) then str_scl:=memoPreview.Lines[i];
    if (k=12) then agi_scl:=memoPreview.Lines[i];
    if (k=13) then spd_scl:=memoPreview.Lines[i];
    if (k=14) then int_scl:=memoPreview.Lines[i];
    if (k=15) then crit_bon:=memoPreview.Lines[i];
    if (k=16) then base_accuracy:=memoPreview.Lines[i];
    if (k=17) then reload_time:=memoPreview.Lines[i];
    if (k=18) then dmg_time:=memoPreview.Lines[i];
    if (k=19) then description:=memoPreview.Lines[i];
    if (k=20) then stamina_dtain:=memoPreview.Lines[i];
    if (k=21) then mana_drain:=memoPreview.Lines[i];
    if (k=22) then armor_bonus:=memoPreview.Lines[i];
    if (k=23) then shield_bonus:=memoPreview.Lines[i];
    if (k=24) then provides_spell:=memoPreview.Lines[i];
    inc(k);
    if k>=25 then
    begin
      k:=0;
      SetLength(itms, length(itms)+1);
      itms[high(itms)]:=titm;
    end;
  end;
  end;
  listitms;
  end;
end;

procedure tform1.buildlist;
var i:integer;
begin
  memoPreview.Clear;
  memoPreview.Lines.Add(inttostr(25));
  for i:=0 to length(itms)-1 do
  with itms[i] do
  begin
    memoPreview.Lines.Add(name);
    memoPreview.Lines.Add(category);
    memoPreview.Lines.Add(sellable);
    memoPreview.Lines.Add(value);
    memoPreview.Lines.Add(icon);
    memoPreview.Lines.Add(str_bon);
    memoPreview.Lines.Add(agi_bon);
    memoPreview.Lines.Add(spd_bon);
    memoPreview.Lines.Add(int_bon);
    memoPreview.Lines.Add(gives_perk);
    memoPreview.Lines.Add(dmg);
    memoPreview.Lines.Add(str_scl);
    memoPreview.Lines.Add(agi_scl);
    memoPreview.Lines.Add(spd_scl);
    memoPreview.Lines.Add(int_scl);
    memoPreview.Lines.Add(crit_bon);
    memoPreview.Lines.Add(base_accuracy);
    memoPreview.Lines.Add(reload_time);
    memoPreview.Lines.Add(dmg_time);
    memoPreview.Lines.Add(description);
    memoPreview.Lines.Add(stamina_dtain);
    memoPreview.Lines.Add(mana_drain);
    memoPreview.Lines.Add(armor_bonus);
    memoPreview.Lines.Add(shield_bonus);
    memoPreview.Lines.Add(provides_spell);
  end;
end;

end.

