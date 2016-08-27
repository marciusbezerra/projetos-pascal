(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
  Este é o Kernel do sistema
**********************************************************************)
unit Kcrt;
(***********************************************************************)
interface
(***********************************************************************)
uses crt;
(***********************************************************************)
const
     Max_Hints = 13;
	  (*validas c-cor de frente f-cor de fundo*)
	  (* nao adianta mudar aqui, este sÆo defaults se o arq nao existir*)
     cmenu  : byte = 15;
	  fmenu  : byte = 9;
	  cbarra : byte = 15;
	  fbarra : byte = 1;
	  cdestaque : byte = 14;
	  cstatus : byte = 15;
	  fstatus : byte = 1;
	  ctitulo : byte = 1;
	  ftitulo : byte = 15;
	  cerro   : byte = 15;
	  ferro   : byte = 4;
	  cdesk   : byte = 15;
	  fdesk   : byte = 7;
     Msaver  : string = 'FARMACIA[PAULI';
     Timesaver : integer = 50;
     font      : byte = 1;
     Faz_sombra : boolean = true;
(***********************************************************************)
type
	  keys = ( nullkey, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10,
				  enter, tab, shifttab, bksp, uparrow, downarrow,
				  rigtharrow, leftarrow, deletekey, insertkey, homekey,
				  esc, endkey, textkey, numberkey, space, pgup, pgdn, click,
				  AltC,AltM,AltR,AltI,AltE,AltA,AltX,ALTH);
		telachars = record
				ch: char;
				at: byte;
		end;
		telas  = record
				position : array [1..25,1..80] of telachars;
				x,y: byte;
		 end;
		TCronometro = object
		  h1,m1,s1,c1 : word;
		  h2,m2,s2,c2 : word;
		  Total : real;
		  Result : string;
		  Procedure inicia;
		  Procedure finaliza;
		  Procedure mostra;
	  end;
    Mensagem = string[70]; (*usado pela variavel Hints*)
(***********************************************************************)
var
	key   : keys; (*da inkey*)
	screen: array [1..20] of ^telas; (*da salva tela*)
   Hints : array [1..Max_Hints] of Mensagem;
(***********************************************************************)
Procedure ver_memoria;
Procedure remost(x1,y1,c1,c2 : byte; text : string; q : byte);
Function time : string;
Function Date : string;
procedure vel_teclado;
Procedure ver_teclado;
Procedure status(mensagem : string);
procedure beep(freq,time:integer);
procedure most(x,y,c,f:byte;st:string);
function getchar : char;
procedure char_att (var ch1 :char; var at1,at2 : byte);
Function cor_de_fundo : byte;
Function cor_de_frente : byte;
procedure menu(x1,y1,x2,y2,c1,c2 : byte;text : string);
procedure blink_off;
procedure blink_on;
procedure off;
procedure on;
procedure erro (text : string);
Function Maiuscula(st1 : string) : string;
Function data_verify(data : string) : boolean;
procedure relogio;
procedure getscreentype;
procedure inkey( var functionkey: boolean;var caracter : char);
Procedure pesc;
Procedure inputstring( var s : string;windowlength, maxlength, x,y : integer;
							  ft : char;var ret_inp : byte);
Function ok : boolean;
Function YNC : byte;
procedure wri(x,y : byte; text : string);
procedure salva_tela (i: byte);
procedure volta_tela (i: byte; opcao: boolean);
Function inttostr(int : integer) : string;
Function strtoint(st1 : string) : integer;
Function strtoreal(st1 : string) : real;
Function realtostr(r : real) : string;
Procedure role(x1,y1,x2,y2,tc1,tb1,tc2,tb2 : byte; var sel,ret : byte);
procedure item(x,y : byte; text : string);
Procedure execute (comando : string);
Procedure cores(cor : byte);
Procedure QuickReport (arquivo,titulo : string);
Procedure RadioGroup (x1,y1,cor1,cor2,item : byte;var itemindex : byte);
Procedure CheckBox (x1,y1,item : byte; var marc : string);
Procedure square (x1,y2,cor1,cor2: byte;st : string);
Procedure tb(cor : byte);
Procedure tc(cor : byte);
procedure cls;
Function Randomiza_arquivo : string;
Procedure load;
Procedure save;
Procedure Limpa_Hints;
Procedure ola;
Function Caixinha (x,y : byte;items : string): string;
Procedure Carrega_mainfonte;
Procedure Carrega_normfonte;
Procedure SetHint(LongHint : string);
Procedure Gdelay(tempo : integer);
Procedure imprima(frase : string);
procedure preencha(c1,c2 : byte; st : char);
(**************************************************************************)
implementation
(**************************************************************************)
uses
	 fontes,printer,dos,saver;
(**************************************************************************)
type
    (*usado pela fun‡Æo ver_teclado*)
    TTeclas  = set of (NumLock,ScrollLock,CapsLock,InsertLock);
(**************************************************************************)
var
	vid : pointer; (*da salva tela*)
	stype : char; (*da getscreentype*)
{  Teclas : TTeclas; }
(************************************************************************)
(* Retorna um valor que ‚ o item selecionado do radio group *)
(* x1,y1 sÆo as cordenadas do 1o elemento, item sÆo o n£mero de linhas*)
(************************************************************************)
Procedure TCronometro.Inicia;
begin
	 gettime(h1,m1,s1,c1);
end;
(**************************************************************************)
Procedure TCronometro.Finaliza;
begin
	 gettime(h2,m2,s2,c2);
end;
(**************************************************************************)
Procedure TCronometro.Mostra;
begin
	 total:=(h2*3600+m2*60+s2+c2/100)-
	 (h1*3600+m1*60+s1+c1/100);
	 salva_tela(16);
	 menu(20,10,60,15,cmenu,fmenu,'Total');
	 most(22,12,cmenu,fmenu,'Inicial : '+
	 inttostr(h1)+':'+inttostr(m1)+':'+inttostr(s1)+':'+inttostr(c1));
	 most(22,13,cmenu,fmenu,'Final : '+
	 inttostr(h2)+':'+inttostr(m2)+':'+inttostr(s2)+':'+inttostr(c2));
	 gotoxy(22,14);
	 write('Total = ',total:5:3,' segundos');
	 pesc;
	 volta_Tela(16,false);
end;
(************************************************************************)
(* Cria vari vel com 8 letras randomizadas
(************************************************************************)
Function Randomiza_arquivo : string;
var
 n : byte;
 rand : string[8];
begin
	  rand:='';
	  for n:=1 to 8 do
		rand:=rand+chr(random(23)+65);
	 Randomiza_arquivo:=rand;
end;

(**************************************************************************)
Procedure RadioGroup (x1,y1,cor1,cor2,item : byte;var itemindex : byte);
var
	y : byte;
	chr : char;
	func : boolean;
	index : byte;
begin
	 index:=itemindex;
	 textcolor(cor1);
	 textbackground(cor2);
	 for y:=y1 to y1+item-1 do
			 wri(x1,y,'ËÌ');
	 repeat
			 most(x1,y1+index-1,cor1,cor2,'ÜÝ');
			 inkey(func,chr);
			 most(x1,y1+index-1,cor1,cor2,'ËÌ');
			 if (key=pgup) and (index>1) then index:=index-1;
			 if (key=pgdn) and (index<item) then index:=index+1;
	 until key in [esc,enter];
	 if key=enter then
end;
(************************************************************************)
(* Retorna uma string com o byte 0 para a posicao livre
	 e 1 para a posicao marcada
(************************************************************************)
Procedure CheckBox (x1,y1,item : byte; var marc : string);
var
	y : byte;
	chr : char;
	func : boolean;
	index : byte;
	str   : string[20];
begin
	 index:=1;
    textbackground(fmenu);
     if fmenu>7 then
        textcolor(cmenu+16)
     else textcolor(cmenu);
	 for y:=y1 to y1+item-1 do
	 begin
			if marc[y-y1+1]='0' then
			wri(x1,y,'ÔÕ')
			else
			wri(x1,y,'×Ø');
	 end;
	 repeat
			 gotoxy(x1,y1+index-1);
				if (getchar='Ô') then
				  most(x1,y1+index-1,cbarra,fbarra,'ÔÕ') else
				  most(x1,y1+index-1,cbarra,fbarra,'×Ø');
				 inkey(func,chr);
			 gotoxy(x1,y1+index-1);
			 if (getchar='Ô') then
				  most(x1,y1+index-1,cmenu,fmenu,'ÔÕ') else
				  most(x1,y1+index-1,cmenu,fmenu,'×Ø');
			 gotoxy(x1,y1+index-1);
			 if (key=space) then
				if (getchar='Ô') then
				begin
					  most(x1,y1+index-1,cmenu,fmenu,'×Ø');
					  str[index]:='1';
				end
				 else
				 begin
				  most(x1,y1+index-1,cmenu,fmenu,'ÔÕ');
				  str[index]:='0';
				 end;
			 if (key=pgup) and (index>1) then index:=index-1;
			 if (key=pgdn) and (index<item) then index:=index+1;
	 until key in [esc,enter];
end;

(************************************************************************
  Cria menu para leitura e impressao de relatorios
  Deve-se criar o arquivo antes e fornecer como parametro o nome do arquivo
  O procedimento entao cria um arquivo temporario
(************************************************************************)
Procedure QuickReport (arquivo,titulo : string);
type
	TQuick = record
		Linha : string [200];
	end;
var
	i1,i2,i3    : integer;
	char1     : char;
	func      : boolean;
	FQuick    : File of TQuick;
	Farquivo  : text;
	BQuick    : TQuick;
	pos : real;
	y,oy : byte;

Procedure Qmost;
var
	x : byte;
begin
	  textcolor(cmenu);
	  textbackground(fmenu);
	  gotoxy(3,3+y);
	  write(' ':74);
	  for x:=1 to length(BQuick.linha) do
	  if x<=74 then
	  begin

			 gotoxy(2+x,3+y);
			 write(BQuick.linha[x]);
	  end;
end;
Procedure mostra20;
begin
	y:=0;
	i2:=i1;
	if y<oy then
	repeat
		 seek(FQuick,i2);
		 read(FQuick,BQuick);
		 Qmost;
		 inc(y,1);
		 inc(i2,1);
	until (i2 >i1+19) or (eof(FQuick));
	if oy<>y+4 then
	most(77,oy,cmenu,fmenu,'±');
	y:=20; (*se a barra nao descer toda, altere este numero*)
	pos:=i1/i3;
	y:= trunc(y * pos);
	oy:=y+4;
	if oy<>y+4 then
		most(77,oy,cmenu,fmenu,'±');
	most(77,y+4,cmenu,fmenu,'Û');
	most(67,23,cmenu,fmenu,'ÄÄÄÄÄÄÄÄÄ');
	most(60,23,cmenu,fmenu,' LIN : '+inttostr(i1)+' ');
end;

Procedure print;
begin
	i2:=0;
	while not eof(FQuick) do
	begin
		  seek(FQuick,i2);
		  read(FQuick,BQuick);
		  writeln(lst,Bquick.linha);
		  i2:=i2+1;
	end;
end;


begin
  (*inicia*)
  salva_tela(18);
  menu(2,2,77,23,cmenu,fmenu,Titulo);
	for y:=4 to 22 do
		  most(77,y,cmenu,fmenu,'±');
	most(77,3,cmenu,fmenu,#30);
	most(77,23,cmenu,fmenu,#31);
  assign(Farquivo,arquivo);
  reset(Farquivo);

  (*cria arquivo $$$ com as strings lidas*)
  assign(FQuick,randomiza_arquivo+'.$$$');
  rewrite(FQuick);
  i1:=0;
  while not eof(Farquivo) do
  begin
		 readln(Farquivo,BQuick.Linha);
		 seek(FQuick,i1);
  		 write(FQuick,BQuick);
		 i1:=i1+1;
  end;
  close(FQuick);
  close(Farquivo);
  (*Prepara o Quick para mostrar*)
  reset(Fquick);
  i1:=0;
  i3:=filesize(FQuick);
  status('• Imprimir – Configurar p gina — Salvar para arquivo');
  repeat
		  mostra20;
		  inkey(func,char1);
		  if (key=downarrow) and
			  (i1<i3-20) then i1:=i1+1;
		  if (key=uparrow) and (i1>0) then i1:=i1-1;
		  if (key=Homekey) then i1:=0;
		  if (key=Endkey) and (i3-20>0) then i1:=i3-20;
		  if (key=pgdn) and (i1+40<i3) then i1:=i1+20;
   	  if (key=pgup) and (i1-20>=0) then i1:=i1-20;

		  if (key=F2) then print;
		  until key=esc;
  volta_Tela(18,false);
  erase(FQuick);
  close(FQuick);
end;
(*************************************************************************
  Mostra um frase e pula de linha quando encontrar o simbolo @
**************************************************************************)
Procedure square (x1,y2,cor1,cor2: byte;st : string);
var
	x : byte;
begin
	  textbackground(cor2);
     if cor2>7 then
        textcolor(cor1+16)
     else textcolor(cor1);

	  gotoxy(x1,y2);
	  x:=0;
	  repeat
			 repeat
					 inc(x,1);
					 if x>length(st) then break;
					 if (st[x]='@') then break;
					 write(st[x]);
			 until false;
			 if x>=length(st) then break;
			 y2:=y2+1;
			 gotoxy(x1,y2);
  until x>=length(st)-1;
end;
(************************************************************************
  Troca de cor
************************************************************************)
Procedure cores(cor : byte);
begin
	  if (cor mod 16)>7 then
		  textcolor(cor div 16+16)
		  else
		  textcolor(cor div 16);
		 textbackground(cor mod 16);
end;

(************************************************************************
  Executa um programa
************************************************************************)
Procedure execute ( comando : string);
begin
	  swapvectors;
	  exec(comando,'');
	  swapvectors;
end;

(************************************************************************
  Help da barra de rolagem
************************************************************************)

Procedure help_role;
begin
	  salva_tela(19);
	  menu(10,10,40,20,15,2,'Ajuda');
	  textcolor(15);
	  textbackground(2);
	  wri(12,12,#24+' '+#25+'   Move a barra');
	  wri(12,13,'1..9  Vai para o n. da linha');
	  wri(12,14,'A..Z  Vai p/ letra destacada');
	  wri(12,15,'Enter Entra na Op‡Æo');
	  wri(12,16,'Home  Vai ao inicio');
	  wri(12,17,'End   Vai ao final');
	  wri(12,18,'Alt+<letra> Troca de menu');
     wri(12,19,'F1..F10 Teclas de atalho');

	  status('Estas sÆo as teclas para se usar na barra de rolagem');
	  pesc;
	  volta_tela(19,false);
end;
(***********************************************************************)
(* Barra de rolagem
(***********************************************************************)
Procedure role(x1,y1,x2,y2,tc1,tb1,tc2,tb2 : byte;var sel,ret : byte);
var
	var_erro : integer;
	functionkey : boolean;
	caracter : char;
	lin,x,y,numero : byte;
	entra:boolean;
label
	sai;
begin
	  key:=nullkey;
	  lin:=y1+sel-1;
	  (*para entrar no menu quando se aperta um numero ou letra*)
	  entra:=false;
	  if tb2>7 then tc2:=tc2+16;
	  if tb1>7 then tc1:=tc1+16;

	  repeat
        (*para pular o Ú'*)
			  gotoxy(x1,lin);
    	     if (getchar='Ú') then
			    if (key=downarrow) then
                lin:=lin+1
             else
                lin:=lin-1;
           if (hints[lin-y1+1])<>'' then (*MUDADO EM 1/8/98*)
           status(Hints[lin-y1+1]); (*Mensagem Hint da barra de selecao*)
           (*seleciona*)
 			  textcolor(tc1);
			  textbackground(tb1);
			  for x:=x1 to x2 do
			  begin
					 gotoxy(x,lin);
                if cor_de_frente<>cmenu then
					 begin
     					 if tc1>15 then textcolor(cor_de_frente+16) else
							  textcolor(cor_de_Frente);
						 write(getchar);
						 textcolor(Tc1);
					 end
					 else
						write(getchar);
			  end;
			  if entra then break;
   		  repeat
                 off;
   				  inkey(functionkey,caracter);
					  if key=AltH then help_role;
					  if key=f10 then relogio;

			  until key in [downarrow,uparrow,leftarrow,rigtharrow,
								  numberkey,esc,enter,TextKey,EndKey,HomeKey,
								  AltC,AltM,AltR,AltI,AltE,AltA,
                          F4,F2,F3,F5,AltX];
			  if not(key in [esc,enter,rigtharrow,leftarrow,
                          F2,F3,F4,F5,AltX{Shortcuts}]) then
											 (* para nao apagar quando na sair do menu*)
			  begin
					 (*apaga*)
					 textcolor(tc2);
					 textbackground(tb2);
					 for x:=x1 to x2 do
					 begin
						  gotoxy(x,lin);
				        if cor_de_frente<>cbarra then
						  begin
						  if tc2>15 then textcolor(cor_de_frente+16) else
									textcolor(cor_de_frente);
							  write(getchar);
							  textcolor(tc2);
						  end
						  else
							 write(getchar);
					 end;
			  end;
			  if key=numberkey then
			  begin
					 val(caracter,numero,var_erro);
					 if numero<=y2-y1+1 then
							lin:=y1+numero-1;
					 Entra:=true;
			  end;
			  if key=TextKey then
			  begin
					  for y:=y1 to y2 do
						for x:=x1 to x2 do
						begin
							 gotoxy(x,y);
							 if (cor_de_frente=cdestaque) and
								 (upcase(getchar)=upcase(caracter)) then
								 begin
										lin:=y;
										entra:=true;
								 end;
					  end;
			  end;
			  if Key=HomeKey then lin:=y1;
			  if Key=EndKey then lin:=y2;
			  if key=uparrow then lin:=lin-1;
			  if key=downarrow then lin:=lin+1;
			  if lin<y1 then lin:=y2;
			  if lin>y2 then lin:=y1;
	 until key in [enter,esc,rigtharrow,leftarrow,
						AltC,AltM,AltR,AltI,AltE,AltA,
                  F2,F3,F4,F5,AltX];
	 sel:=(wherey-y1+1);
	 ret:=0;
	 if key=esc then ret:=1;
	 if key=rigtharrow then ret:=6;
	 if key=leftarrow then  ret:=4;
	 if key=AltC then ret:=46;
	 if key=AltM then ret:=50;
	 if key=AltR then ret:=19;
	 if key=AltI then ret:=23;
	 if key=AltE then ret:=18;
	 if key=AltA then ret:=30;
    if key=f2 then ret:=60;
    if key=f3 then ret:=61;
    if key=f4 then ret:=62;
    if key=f5 then ret:=63;
    if key=AltX then ret:=45;
end;
(*************************************************************************)
(* Escreve uma mensagem de menu sem trocar cores e selecionando destaque
(*************************************************************************)
procedure item(x,y : byte; text : string);
var
	i : byte;
begin
	  if fmenu>7 then  textcolor(cmenu+16)
	  else textcolor(cmenu);
	  textbackground(fmenu);
	  i:=1;
	  repeat
		 gotoxy(x,y);
		 if (text[i]<>'&') and (text[i]<>'<') then
		 begin
			  write(text[i]);
			  x:=x+1;
		 end
		 else
		 begin
          if text[i]='&' then
          begin
			   if fmenu>7 then
				  textcolor(cdestaque+16)
			     else textcolor(cdestaque);
  			     i:=i+1;
				  write(text[i]);
				  if fmenu>7 then
				  textcolor(cmenu+16)
				  else
				  textcolor(cmenu); (*mudar*)
				  x:=x+1;
			 end;
          if text[i]='<' then
          begin
             if fmenu>7 then
				  textcolor(cdestaque+16)
			     else textcolor(cdestaque);
              i:=i+1;
              while text[i]<>'>' do
              begin
                 write(text[i]);
                 i:=i+1;
              end;
          end;
          end;
			 i:=i+1;
	  until i>length(text);
end;
(***********************************************************************)
(* Escreve rapido na tela - usado pela inputstring
(***********************************************************************)
procedure fastwrite(x,y:integer; var s:string ; fg,bg:integer;stype:char  );
var i,b : byte;
begin
	  if upcase(stype) = 'M' then
	  begin
			 b := (bg Shl 4) + fg;
			 x := ((x-1)*2) + ((y-1)*160);
			 for i := 1 to length(s) do
			 begin
					mem[$B000:x] := byte(s[i]);
					mem[$B000:x+1] := b;
					inc(x,2);
			 end;
	  end
	  else
			 inline  ( $50/$53/$51/$52/
						  $06/$57/$56/$8B/$5E/<X/$8B/$46/<Y/
						  $4B/$4B/$B9/$50/$00/$F7/$E1/$03/$C3/
						  $B9/$02/$00/$F7/$E1/$8B/$F8/$8B/$5E/<bg/$8B/$46/<fg/
						  $B9/$04/$00/$D3/$E3/$03/$D8/$86/$DF/$BA/$DA/$03/
						  $B8/$00/$B8/$8E/$C0/$C5/$76/<s/$8A/$0C/$80/$F9/$00/
						  $74/$15/$FC/$46/$8A/$1C/$EC/
						  $A8/$01/$75/$FB/$FA/$EC/$A8/$01/
						  $74/$FB/$8B/$C3/$AB/$FB/$E2/$EC/
						  $5E/$5F/$07/$1F/$5A/
						  $59/$5B/$58/$E9/$00/$00/$8B/$E5/
						  $5D/$C2/$0E/$00 );
end;


(***************************************************************************)
(* Inputstring - Retorna St1
(***************************************************************************)
Procedure inputstring( var s : string;windowlength, maxlength, x,y : integer;
							  ft : char; var ret_inp : byte);
var
	  xx,i,j,p   : integer;
	  ch         : char;
	  inserton,
	  specialkey : boolean;
	  offset     : integer;
	  tempstr    : string;

	  procedure xy(x,y:integer);
	  var xsmall : integer;
	  begin
			 repeat
					xsmall := x - 80;
					if xsmall > 0 then
					begin
						  y := y + 1;
						  x := xsmall;
					end;
			 until xsmall <= 0;
			 gotoxy(x-1,y+1);
	  end;

	  procedure setstring;
	  var i : integer;
	  begin
			 i := length(s);
			 while s[i] = char(0) do
					i := i - 1;
			 s[0] := char(i);
	  end;

begin
	  y := y - 1;
	  x := x + 1;
	  j := length(s) + 1;
	  for i := j to maxlength do
			 s[i] := char(0);
	  s[0] :=char(maxlength);

	  tempstr := copy(s,1,windowlength);
	  fastwrite(x,y,tempstr,white,black,stype);
	  p := 1;
	  offset := 1;
	  inserton := true;
	  repeat
			 xx := x + (p - offset);
			 if p - offset = windowlength then
					xx := xx - 1;
			 xy(xx,y);
          on;
			 if inserton then
					inkey(specialkey,ch)
			 else
					inkey(specialkey,ch);

			 if ft = 'N' then
			 begin
					if key = textkey then
					begin
						  beep(800,250);
						  key := nullkey;
					end
					else
						if (ch = '-') {and
							((p > 1) or
							(s[1] = '-'))} then
						  begin
								 beep(800,250);
								 key := nullkey;
						  end
						  else
               			 if ch = '.' then
								 begin
										if not((pos('.',s) = 0) or
										(pos('.',s) = p)) then
										begin
											  beep(800,250);
											  key := nullkey;
										end
										else
											  delete (s,p,1);
								 end;

			 end;
			 case key of
					numberkey,
					textkey,
					space    : begin
									 if length(s) = maxlength then
									 begin
										if p = maxlength then
										begin
										  delete (s,maxlength,1);
										  s := s + ch;
										  if p = windowlength+offset then
												 offset := offset + 1;
											  tempstr := copy(s,offset,windowlength);
											  fastwrite(x,y,tempstr,white,black,stype);
										end
										else
										begin
										  if inserton then
										  begin
										  delete(s,maxlength,1);
										 insert(ch,s,p);
										 if p = windowlength+offset then
											 offset := offset + 1;
											 if p < maxlength then
											  p := p + 1;
											tempstr := copy(s,offset,windowlength);
										 fastwrite(x,y,tempstr,white,black,stype);
										  end
										  else
										  begin
											 delete (s,p,1);
											 insert(ch,s,p);
										  if p = windowlength+offset then
											offset := offset + 1;
											if p < maxlength then
											 p := p + 1;
										  tempstr := copy(s,offset,windowlength);
										  fastwrite(x,y,tempstr,white,black,stype);
											end;
										  end;
										 end
										 else
										 begin
										 if inserton then
										 begin
											  insert(ch,s,p);
										 end
										 else
										 begin
											  delete(s,p,1);
											  insert(ch,s,p);
										 end;
										 if p = windowlength+offset then
											  offset := offset + 1;
										 if p < maxlength then
											p := p + 1;
										 tempstr := copy(s,offset,windowlength);
										 fastwrite(x,y,tempstr,white,black,stype);
										 end;
								  end;
					bksp     : begin
										 if p > 1 then
										 begin
												p := p - 1;
												delete(s,p,1);
												s := s + char(0);
												if offset > 1 then
													  offset := offset - 1;
												tempstr := copy(s,offset,windowlength);
												fastwrite(x,y,tempstr,white,black,stype);
												ch := ' ';
										 end
										 else
										 begin
												beep(800,250);
												ch := ' ';
												p := 1;
										 end;
								  end;
				  leftarrow : begin
								 if p > 1 then
								 begin
										p := p - 1;
										if p < offset then
										begin
										  offset := offset - 1;
										  tempstr := copy(s,offset,windowlength);
										  fastwrite(x,y,tempstr,white,black,stype);
										end;
									 end;
								 end;

					(* eu botei*)
					 endkey : p:=maxlength;

					 homekey : p:=1;  {se a janela for menor que a entrada da pau}



				 rigtharrow : begin
									 if (s[p] <> char(0)) and
									 ( p < maxlength ) then
									 begin
										p := p + 1;
										if p = (windowlength+offset) then
										begin
										  offset := offset + 1;
										  tempstr := copy(s,offset,windowlength);
										  fastwrite(x,y,tempstr,white,black,stype);
										end;
												(* ********************************
												else
												begin
													  setstring;
													  exit;
												end;
												********************************** *)
										 end;
								  end;
				 deletekey  : begin
								 delete(s,p,1);
								 s := s + char(0);
								 if ((length(s) + 1 ) - offset ) >= windowlength then
								 begin
										tempstr := copy(s,offset,windowlength);
										fastwrite(x,y,tempstr,white,black,stype);
								 end
								 else
								 begin
										tempstr := copy(s,offset,windowlength);
										fastwrite(x,y,tempstr,white,black,stype);
								 end;
								  end;
				 insertkey  : begin
									 if inserton then
											inserton := false
									 else
											inserton := true;
								 end;
				 else       if  not( key in [ enter, uparrow, downarrow,
														pgdn, pgup, nullkey, esc, tab,
														f1,f2,f3,f4,f5,f6,f7,f8,f9,f10 ])  then
									 beep(800,250);
			 end;
	  until ( key in [ enter, uparrow, downarrow, pgup, pgdn, esc,
							 tab, f1,f2,f3,f4,f5,f6,f7,f8,f9,f10] );
	  setstring;
	  ret_inp:=1; {normal para todas as teclas acimas}
	  (*dai sob:=sob+1*)
	  if key=esc then ret_inp:=255;  {para sair}
	  (*dai sob:=255*)
	  if key IN [uparrow,pgup] then ret_inp:=0;
	  (*dai sob:=sob-1*)
	  (*pois sob usado pelo le_cli,le_cds...*)
end;
(***********************************************************************)
(* Repete ate pressionada a tecla ESC
(***********************************************************************)
Procedure pesc;
var
Functionkey:boolean;
caracter : char;
begin
     off;
	  repeat
			  inkey(Functionkey,caracter);
	  until key=esc;
	  key:=nullkey;
end;
(***********************************************************************)
(* Escreve a string na tela zerando as demais colunas
(***********************************************************************)

Procedure remost(x1,y1,c1,c2 : byte; text : string; q : byte);
begin
	  if c2>7 then
	  textcolor(c1+16) else
	  textcolor(c1);
	  textbackground(c2);
	  gotoxy(x1,y1);
	  write(' ':q);
     most(x1,y1,c1,c2,text);

     { old
	  gotoxy(x1,y1);
	  write(text); }
end;
(***********************************************************************)
(* Detecta video - Usado pela Inputstring
(***********************************************************************)
procedure getscreentype;
var
regs : registers;
begin
	  regs.ah := $0F;
	  intr($10,regs);
	  if regs.al = 7 then
			 stype := 'M'
	  else
			 stype := 'C';
end;
(***********************************************************************)
(* Retorna navari vel global key a tecla pressionada
(* Se for key=textkey ou n£mero entÆo verificar var caracter
(***********************************************************************)
procedure inkey( var functionkey: boolean;var caracter : char);
var
  ox,oy : byte;
{  mouseclick : boolean;
  regs : registers; }
  new_time : string[8];
  conta_segundo : byte;
{ OldTeclas : TTeclas; }
begin
	  functionkey := false;
	  caracter:=' ';
    (*como o mostrar o relogio ir  alterar as posi‡äes atuais do cursor
      as linhas abaixo guardam as coordenadas atuais*)
	  ox:=wherex;
	  oy:=wherey;
	{ mouseclick:=false; }
	 conta_segundo:=0;
{   OldTeclas:=[]; }
	 repeat
   {    ver_teclado;
       if Teclas<>OldTeclas then
       begin
       if (CapsLock in Teclas) then most(30,1,31,9,'ùú')
           else  most(30,1,31,9,'  ');
       if (NumLock  in Teclas) then most(33,1,31,9,'ûü')
           else most(33,1,31,9,'  ');
    {   if (InsertLock in Teclas) then most(36,1,31,9,'ýþ')
           else most(36,1,31,9,'  ');
       end;
       OldTeclas:=Teclas;}

   	 if time<>new_time then
		 begin
			 if fstatus>7 then textcolor(cstatus+16) else
			 textcolor(cstatus);
			 textbackground(fstatus);
			 gotoxy(1,25);
			 write(time);
			 new_time:=time;
			 gotoxy(ox,oy);
			 conta_segundo:=conta_segundo+1;
		  end;
		  if conta_segundo>timesaver then
		  begin
   			conta_segundo:=0;
				salva_tela(17);
				screen_saver1(msaver);
				volta_tela(17,false);
		  end;
			 { regs.ax:=3;
			  intr($33,regs);
			  if regs.bx>0 then mouseclick:=true;}
	  until (keypressed) {or (mouseclick)};
	  gotoxy(ox,oy); (*voltas as coordenadas iniciais*)
	  caracter := readkey;

	  if caracter = #0 then
	  begin
			 functionkey := true;
			 caracter := readkey;
	  end;
	  if functionkey then
			 case ord(caracter) of
					15 : key := shifttab;
					72 : key := uparrow;
					80 : key := downarrow;
					82 : key := insertkey;
					75 : key := leftarrow;
					77 : key := rigtharrow;
					73 : key := pgup;
					81 : key := pgdn;
					71 : key := homekey;
					79 : key := endkey;
					83 : key := deletekey;
					82 : key := insertkey;
					59 : key := f1;
					60 : key := f2;
					61 : key := f3;
					62 : key := f4;
					63 : key := f5;
					64 : key := f6;
					65 : key := f7;
					66 : key := f8;
					67 : key := f9;
					68 : key := f10;
					(*alt p/ barra de rolagem*)
					46 : key := AltC;
					50 : key := AltM;
					19 : key := AltR;
					23 : key := AltI;
					18 : key := AltE;
					30 : key := AltA;
					45 : key := AltX;
          35 : key := AltH;
				 end
	  else
			 case ord(caracter) of
					 8 : key := bksp;
					 9 : key := tab;
					13 : key := enter;
					27 : key := esc;
					32 : key := space;
					33..44,47,58..254 : key := textkey;
					45..46,48..57     : key := numberkey;
			 end;
			{ if mouseclick then key:=click;}
end;
(***********************************************************************)
(* Retorna hh:mm:ss
(***********************************************************************)
Function time : string;
var
	h,m,s,c : word;
	hd,md,sd : string[2];
begin
	  gettime(h,m,s,c);
	  str(h,hd);
	  if h<10 then insert('0',hd,1);
	  if h=0 then insert('0',hd,1);
	  str(m,md);
	  if m<10 then insert('0',md,1);
	  if m=0 then insert('0',md,1);
	  str(s,sd);
	  if s<10 then insert('0',sd,1);
	  if s=0 then insert('0',sd,1);
	  time:=hd+':'+md+':'+sd;
end;
(***********************************************************************)
(* Retorna dd/mm/aa
(***********************************************************************)
Function Date : string;
var
	hd,md : string[2];
	anod : string[4];
	weekd : string[13];
	dia,mes,ano,week : word;
begin
	  getdate(ano,mes,dia,week);
	  str(dia,hd);
	  str(mes,md);
	  str(ano,anod);
	  case week of
	  0 : weekd:='Domingo';
	  1 : weekd:='Segunda-Feira';
	  2 : weekd:='Ter‡a-Feira';
	  3 : weekd:='Quarta-Feira';
	  4 : weekd:='Quinta-Feira';
	  5 : weekd:='Sexta-Feira';
	  6 : weekd:='S bado';
	  end;


	  if length(hd)=1 then hd:='0'+hd;
	  if length(md)=1 then md:='0'+md;
	  Date:=hd+'/'+md+'/'+anod+' '+Weekd;
end;
(***********************************************************************)
(* Seta velocidade do teclado
(***********************************************************************)
procedure vel_teclado;
var
  regs : registers;
begin
	 with regs do
	 begin
			ah:=$03;
			al:=$05;
			bh:=$00;
			bl:=$0c;
	 end;
	 intr($16,regs);
end;

(***********************************************************************)
(* Verifica situa‡Æo das teclas especiais Caps, Num,Ins
(***********************************************************************)
Procedure ver_teclado;
var
  regs  : registers;
  total : real;

begin
   { Teclas:=[];
    regs.ah:=$02;
	 intr($16,regs);
    total:=regs.al;

    if total/128 >=1  then
    begin
       teclas:=teclas+[InsertLock];
       total:=total-128;
    end;
   if total/64>=1 then
   begin
      teclas:=teclas+[CapsLock];
      total:=total-64;
    end;
   if total/32>=1 then
   begin
     teclas:=teclas+[NumLock];
     total:=total-32;
   end;

   if total/16>=1 then
   begin
      teclas:=teclas+[ScrollLock];
      total:=total-16;
   end; }
end;
(***********************************************************************)
(* Escreve la embaixo a mensagem que vocˆ quiser
(***********************************************************************
PARA DEIXAR SEMPRE O MESMO STATUS EM UMA BARRA DE ROLAGEM DIGITE
 SETHINT('');
 STATUS('<MENSAGEM>');
*)
Procedure status(mensagem : string);
var
	met : real;
  ox,oy : byte;
begin
    ox:=wherex;
    oy:=wherey;
 {	met:=(length(mensagem)/2.0)+0.5; }
	  window(9,25,80,25); {textcolor(cj mod 16); textbackground(cj div 16);}
	  if fstatus>7 then textcolor(cstatus+16)
	  else textcolor(cstatus);
	  textbackground(fstatus);
	  clrscr;
	{ gotoxy(40-trunc(met),1); }
	  gotoxy(2,1);
	  write('í'+mensagem);
	  window(1,1,80,25);
    gotoxy(ox,oy);
 end;
(***********************************************************************)
(* Faz um beep
(***********************************************************************)
procedure beep(freq,time:integer);
begin
	  sound(freq);
	  {delay(time);}
	  nosound;
end;
(***********************************************************************)
(* Mostra uma mensagem na col=x1 lin=y1 cor=c1 e fundo=c2
Slow MOST by Guinther
(***********************************************************************)
{Procedure most(x1,y1,c1,c2 : byte; text : string);
begin
	  if c2>7 then c1:=c1+16;
	  textcolor(c1);
	  textbackground(c2);
	  gotoxy(x1,y1);
	  write(text);
end;}
(*************************************************************************)
(* Escreve uma mensagem sem trocar cores
(*************************************************************************)
procedure wri(x,y : byte; text : string);
begin
	  gotoxy(x,y);
	  write(text);
end;
(***********************************************************************)
(* Retorna caracter na posicao atual do cursor
 Fast screenchar by Rudolfo
(***********************************************************************)
function getchar : char;
begin
    	getchar:=char(mem[$b800:((wherex-1)*2)+((wherey-1)*160)]);
end;
{ slow screenchar
function getchar : char;
var
regs : registers;
begin
	  fillchar(regs,sizeof(regs),0);
	  regs.AH:=8;
	  regs.BH:=0;
	  intr($10,regs);
	  getchar:=chr(regs.AL);
end;}
(***********************************************************************)
(* Mesmo getchar mas voce posiciona o cursor
(***********************************************************************)
procedure char_att (var ch1 :char; var at1,at2 : byte);

var
regs : registers;
begin
	  fillchar(regs,sizeof(regs),0);
	  regs.AH:=8;
	  regs.BH:=0;
	  intr($10,regs);
	  ch1:=chr(regs.AL);
	  at1:=regs.ah mod 16;
	  at2:=regs.ah div 16;
end;
(***********************************************************************)
(* Retorna um byte que ‚ a cor de fundo da posi‡Æo atual do cursor
(***********************************************************************)
Function cor_de_fundo : byte;
var
regs : registers;
begin
	  fillchar(regs,sizeof(regs),0);
	  regs.AH:=8;
	  regs.BH:=0;
	  intr($10,regs);
	  cor_de_fundo:=regs.ah div 16;
end;
(***********************************************************************)
(* Retorna um byte que ‚ a cor de frente da posi‡Æo atual do cursor
(***********************************************************************)
Function cor_de_frente : byte;
var
	  regs : registers;
begin
	  fillchar(regs,sizeof(regs),0);
	  regs.AH:=8;
	  regs.BH:=0;
	  intr($10,regs);
	  cor_de_frente:=regs.ah mod 16;
end;
(***********************************************************************)
(* Faz uma janela, se text<>'' coloca titulo no meio
(***********************************************************************)
procedure menu(x1,y1,x2,y2,c1,c2 : byte;text : string);
var
	x,y,at1,at2 : byte;
	ch : char;

begin
     (*pinta*)
	  if c2>7 then c1:=c1+16;
	  textcolor(c1);
	  textbackground(c2);
	  for x:=x1 to x2 do
		for y:=y1 to y2 do
		begin
			  gotoxy(x,y);
			  writeln(' ');
		end;
	  for y:=(y1+1) to (y2-1) do
	  begin
			 gotoxy(x2,y);
			 write('Þ');
			 gotoxy(x1,y);
			 write('³');
	  end;
	  gotoxy(x1,y2);
	  write('À');
	  for x:=(x1+1) to (x2-1) do
			write('Ä');
	  write('Ù');
		 gotoxy(x1,y1);
	  (* Titulo *)
	  if text<>'' then
	  begin
	  if ftitulo>7 then  textcolor(ctitulo+16) else textcolor(ctitulo);
	  textbackground(ftitulo);
	  for x:=x1 to x2 do
			write(' ');
	  gotoxy(x1,y1);
	  write('ÉÊ');
	  begin
			  gotoxy(trunc(((x1+x2)/2.0+0.5-length(text)/2)),y1);
			  write(text);
	  end;
	  end
	  else
	  begin
			write('Í');
			for x:=(x1+1) to (x2-1) do
				  write('Å');
			write('Î');
	  end;
	  (*Sombra*)
     if faz_sombra then
     begin
	  textbackground(0);
	  for y:=y1+1 to y2+1 do
	  begin
		  gotoxy(x2+1,y);
		  char_att(ch,at1,at2);
		  if at2>7 then
			textcolor(at1+16)
		  else
			 textcolor(at1);
		  write(ch);
		  gotoxy(x2+2,y);
		  char_att(ch,at1,at2);
		  write(ch);
	  end;
	  for x:=x1+2 to x2+2 do
	  begin
			  gotoxy(x,y2+1);
			  char_att(ch,at1,at2);
			  write(ch);
	  end;
     end;
end;
(***********************************************************************)
(* Desabilita piscagem, isto ‚, deixa brilhante a cor de fundo
(***********************************************************************)
procedure blink_off;
var
regs : registers;
begin
	  regs.ax:=$1003;
	  regs.bl:=0;
	  intr($10,regs);
end;
(***********************************************************************)
(* Habilita piscagem, isto ‚, deixa normal a cor de fundo
(***********************************************************************)
procedure blink_on;
var
regs : registers;
begin
	  regs.ax:=$1003;
	  regs.bl:=1;
	  intr($10,regs);
end;
(***********************************************************************)
(* Desliga o cursor
(***********************************************************************)
procedure off;
var
regs : registers;
begin
	  regs.ah := $01;
	  regs.ch := $20;
	  regs.cl := $20;
	  intr($10,regs);
end;
(***********************************************************************)
(* Liga o cursor
(***********************************************************************)
procedure on;
var
regs : registers;
begin
		regs.ah := $01;
		regs.ch := 12;
		regs.cl := 13;
		intr($10,regs);
end;
(***********************************************************************)
(* Faz uma janela de erro vermelha e escreve uma mensagem
(***********************************************************************)
procedure erro (text : string);
var
  caracter : char;
  functionkey : boolean;
begin
	  salva_tela(20);
	  menu(22,11,60,13,cerro,ferro,'');
	  most(24,12,cerro,ferro,text);
	  status('Pressione Esc...');
	  beep(800,60);
	  beep(1000,80);
	  repeat
			  inkey(functionkey,caracter);
	  until key=esc;
    key:=nullkey;
	  Volta_Tela(20,false);
end;
(***********************************************************************)
(* Transforma uma string toda em maiuscula
(***********************************************************************)
Function Maiuscula(st1 : string) : string;
var
	i : integer;
begin
    for i:=1 to trunc(length(st1)) do
		 st1[i]:=upcase(st1[i]);
    Maiuscula:=st1;
end;
(***********************************************************************)
(* Retorna verdadeiro se o parƒmetro for uma data v lida
(***********************************************************************)
Function data_verify(data : string) : boolean;
var
	edia,emes,eano,var_erro : integer;
	flagg : byte;
begin
	  data_verify:=false;
	  if length(data)=6 then
	  begin
	  val(copy(data,1,2),edia,var_erro);
	  val(copy(data,3,2),emes,var_erro);
	  val(copy(data,5,2),eano,var_erro);
	  if emes in [1,3,5,7,8,10,12] then
		  if (edia>0) and (edia<32) then
				data_verify:=true;
	  if emes in [4,6,9,11] then
		  if (edia>0) and (edia<31) then
				data_verify:=true;
	  if (emes=2) and ((1900+eano) mod 4=0) then
			 if (edia>0) and (edia<30) then
				 data_verify:=true;
	  if (emes=2) and ((1900+eano) mod 4<>0) then
			 if (edia>0) and (edia<29) then
				  data_verify:=true;
	  end;
end;
(***********************************************************************)
(* Funcao de confirmacao
(***********************************************************************)
Function ok : boolean;
var
	functionkey : boolean;
	caracter : char;
	sel_conf,ret_conf : byte;
begin
    hints[1]:='Confirma a opera‡Æo';
    hints[2]:='Cancela a opera‡Æo';
	 salva_tela(16);
	 ok:=false;
	 sel_conf:=1;
	 menu(50,17,75,21,cmenu,fmenu,'Confirma ?');
	 Textcolor(cmenu);
	 textbackground(fmenu);
	 item(51,19,'&Confirma');
	 item(51,20,'C&ancela');
	 role(51,19,74,20,cbarra,fbarra,cmenu,fmenu,sel_conf,ret_conf);
	 if (sel_conf=1) and (ret_conf=0) then ok:=true;
	volta_Tela(16,false);
end;

(***********************************************************************)
(* confirmacao YNC
(***********************************************************************)
Function YNC : byte;
var
	functionkey : boolean;
	caracter : char;
	sel_conf,ret_conf : byte;
begin
    hints[1]:='Confirma opera‡Æo';
    hints[2]:='Retorna opera‡Æo';
    hints[3]:='Cancela a opera‡Æo';
	 salva_tela(14);
	 sel_conf:=1;
	 menu(50,17,75,22,cmenu,fmenu,'Confirma ?');
	 Textcolor(cmenu);
	 textbackground(fmenu);
	 item(51,19,'&Confirma');
	 item(51,20,'&Retorna');
    item(51,21,'C&ancela');
	 role(51,19,74,21,cbarra,fbarra,cmenu,fmenu,sel_conf,ret_conf);
	 case sel_conf of
    1   : YNC:=1;
    2   : YNC:=2;
    3   : YNC:=3;
    end;
    if ret_conf=1 then YNC:=3;
  	 volta_Tela(14,false);
end;


(***********************************************************************)
(* Faz uma frescura de rel¢gio
(***********************************************************************)
procedure relogio;
const
	  meses : array [1..12]
	  of string[12] = ('JANEIRO','FEVEREIRO','MARCO','ABRIL',
							 'MAIO','JUNHO','JULHO','AGOSTO','SETEMBRO',
							 'OUTUBRO','NOVEMBRO','DEZEMBRO');
	  days : array [0..6] of String[15] =
			('Domingo','Segunda-feira','Terca-feira',
		  'Quarta-feira','Quinta-feira','Sexta-feira',
		  'Sabado');
type
	 number = record
	 st : array [1..7] of string[6];
	 end;
var
	numeros : array [0..10] of number;
	h,m,s,c : word;
	i : integer;
	h1,h2,m1,m2,s1,s2 : integer;
	cr1,cr2 : char;
	dia,mes,ano,week : word;
	diastr : string[2];
	anostr : string[4];
begin
	  with numeros[1] do
	  begin
	  st[1]:='  Û   ';
	  st[2]:=' ÛÛ   ';
	  st[3]:='  Û   ';
	  st[4]:='  Û   ';
	  st[5]:='  Û   ';
	  st[6]:='  Û   ';
	  st[7]:='ÛÛÛÛÛ ';
	  end;
	  with numeros[2] do
	  begin
	  st[1]:='ÛÛÛÛÛÛ';
	  st[2]:='     Û';
	  st[3]:='     Û';
	  st[4]:='ÛÛÛÛÛÛ';
	  st[5]:='Û     ';
	  st[6]:='Û     ';
	  st[7]:='ÛÛÛÛÛÛ';
	  end;
	  with numeros[3] do
		begin
	  st[1]:='ÛÛÛÛÛÛ';
	  st[2]:='     Û';
	  st[3]:='     Û';
	  st[4]:='ÛÛÛÛÛÛ';
	  st[5]:='     Û';
	  st[6]:='     Û';
	  st[7]:='ÛÛÛÛÛÛ';
	  end;
	  with numeros[4] do
	  begin
	  st[1]:='Û    Û';
	  st[2]:='Û    Û';
	  st[3]:='Û    Û';
	  st[4]:='ÛÛÛÛÛÛ';
	  st[5]:='     Û';
	  st[6]:='     Û';
	  st[7]:='     Û';
	  end;
		with numeros[5] do
	  begin
	  st[1]:='ÛÛÛÛÛÛ';
	  st[2]:='Û     ';
	  st[3]:='Û     ';
	  st[4]:='ÛÛÛÛÛÛ';
	  st[5]:='     Û';
	  st[6]:='     Û';
	  st[7]:='ÛÛÛÛÛÛ';
	  end;
	  with numeros[6] do
	  begin
	  st[1]:='ÛÛÛÛÛÛ';
	  st[2]:='Û     ';
	  st[3]:='Û     ';
	  st[4]:='ÛÛÛÛÛÛ';
	  st[5]:='Û    Û';
	  st[6]:='Û    Û';
	  st[7]:='ÛÛÛÛÛÛ';
		end;
	  with numeros[7] do
	  begin
	  st[1]:='ÛÛÛÛÛÛ';
	  st[2]:='     Û';
	  st[3]:='     Û';
	  st[4]:='     Û';
	  st[5]:='     Û';
	  st[6]:='     Û';
	  st[7]:='     Û';
	  end;
	  with numeros[8] do
	  begin
	  st[1]:='ÛÛÛÛÛÛ';
	  st[2]:='Û    Û';
	  st[3]:='Û    Û';
	  st[4]:='ÛÛÛÛÛÛ';
	  st[5]:='Û    Û';
	  st[6]:='Û    Û';
	  st[7]:='ÛÛÛÛÛÛ';
	  end;
	  with numeros[9] do
	  begin
	  st[1]:='ÛÛÛÛÛÛ';
	  st[2]:='Û    Û';
	  st[3]:='Û    Û';
	  st[4]:='ÛÛÛÛÛÛ';
	  st[5]:='     Û';
	  st[6]:='     Û';
	  st[7]:='ÛÛÛÛÛÛ';
	  end;
	  with numeros[0] do
	  begin
	  st[1]:='ÛÛÛÛÛÛ';
	  st[2]:='Û    Û';
	  st[3]:='Û    Û';
	  st[4]:='Û    Û';
	  st[5]:='Û    Û';
	  st[6]:='Û    Û';
	  st[7]:='ÛÛÛÛÛÛ';
	  end;
	  with numeros[10] do
	  begin
	  st[1]:='    ';
	  st[2]:='    ';
	  st[3]:=' Û  ';
	  st[4]:='    ';
	  st[5]:=' Û  ';
	  st[6]:='    ';
	  st[7]:='    ';
	  end;
	  salva_tela(20);
	  getdate(ano,mes,dia,week);
	  str(ano,anostr);
	  str(dia,diastr);
	  menu(10,7,71,18,cmenu,fmenu,'Hora Certa');
	  status(' Santa Maria, '+diastr+' de '+meses[mes]+' de '+anostr+' - '+days[week]);
	  textcolor(9); textbackground(7);
	  repeat
	  gettime(h,m,s,c);
	  h1:=h div 10;
	  h2:=h mod 10;
	  m1:=m div 10;
	  m2:=m mod 10;
	  s1:=s div 10;
	  s2:=s mod 10;
	  if fmenu>7 then
	  textcolor(cmenu+16)
	  else textcolor(cmenu);
	  textbackground(fmenu);
	  for i:=1 to 7 do
	  begin
			 gotoxy(13,i+9);
			 writeln(numeros[h1].st[i]);
			 gotoxy(21,i+9);
			 writeln(numeros[h2].st[i]);
			 gotoxy(29,i+9);
			 writeln(numeros[10].st[i]);
			 gotoxy(34,i+9);
			 writeln(numeros[m1].st[i]);
			 gotoxy(42,i+9);
			 writeln(numeros[m2].st[i]);
			 gotoxy(50,i+9);
			 writeln(numeros[10].st[i]);
			 gotoxy(55,i+9);
			 writeln(numeros[s1].st[i]);
			 gotoxy(63,i+9);
			 writeln(numeros[s2].st[i]);
		 end;
		until keypressed;
			 cr1:=readkey;
			 if cr1=#0 then
				 cr2:=readkey;
	  volta_tela(20,false);
end;
(***********************************************************************)
(* Salva a tela
(***********************************************************************)
procedure getscreen(var video,source; length: word);
begin
inline($1e/$55/$ba/$da/$03/$c5/$b6/
video /$c4/$be/ source /$8b/$8e/
length /$fc/$ec/$d0/$d8/$72/$fb/$fa/$ec/$d0/$d8/$73/$fb/$ad/
$fb/$ab/$e2/$f0/$5d/$1f)
end;
procedure salva_tela (i: byte);
begin
new (screen[i]);
screen[i]^.x:= wherex;
screen[i]^.y:= wherey;
vid:= ptr ($b800,0);
getscreen (vid^,screen[i]^,2000);
end;
(***********************************************************************)
(* Volta a tela
(***********************************************************************)
procedure showscreen (var source,video; length: word);
begin
inline($90/$90/$90/$90/$1e/$55/$ba/$da/$03/$c5/$b6/
source /$c4/$be/ video /$8b/$8e/
length /$fc/$ad/$89/$c5/$b4/$09/$ec/$d0/$d8/$72/$fb/$fa/$ec/
$20/$e0/$74/$fb/$89/$e8/$ab/$fb/$e2/$ea/$5d/$1f)
end;
procedure volta_tela (i: byte; opcao: boolean);
begin
vid:= ptr ($b800,0);
showscreen (screen[i]^,vid^,2000);
gotoxy (screen[i]^.x,screen[i]^.y);
if opcao = false then dispose (screen[i]);
end;
(************************************************************************)
(* Retorna uma string de um inteiro
(************************************************************************)
Function inttostr(int : integer) : string;
var
 st1 : string;
begin
	  str(int,st1);
	  inttostr:=st1;
end;
(************************************************************************)
(* Retorna inteiro de string
(************************************************************************)
Function strtoint(st1 : string) : integer;
var
  var_erro : integer;
  int : integer;
begin
	  if st1='' then strtoint:=0 else
	  begin
	  val(st1,int,var_erro);
	  if int<=32767 then
	  strtoint:=int
	  else
		strtoint:=0;
	  end;
end;

(************************************************************************)
(* Retorna real de uma string
(************************************************************************)
Function strtoreal(st1 : string) : real;
var
  var_erro : integer;
  r : real;
begin
	  if st1='' then strtoreal:=0 else
     begin
	  val(st1,r,var_erro);
     strtoreal:=r;
     end;
end;
(************************************************************************)
(* Retorna string de um real
(************************************************************************)
Function realtostr(r : real) : string;
var
 st1 : string;
begin
	  str(r:5:2,st1);
	  realtostr:=st1;
end;
(************************************************************************)
(* textcolor
(************************************************************************)
procedure tc(cor : byte);
begin
	 textcolor(cor);
end;

(************************************************************************)
(* textbackground
(************************************************************************)
procedure tb(cor : byte);
begin
	 textbackground(cor);
end;

(************************************************************************)
(* limpa a tela
(************************************************************************)
procedure cls;
begin
	 textcolor(7);
	 textbackground(0);
	 clrscr;
    carrega_mainfonte;
    blink_off;
end;
(************************************************************************)
(* carrega variaveis de cores
(************************************************************************)
Procedure load;
var
	Arq : text;
	str : string;
	vo : boolean;
	io : integer;
begin
	  vo:=false;
	  assign(arq,'farm.dsk');
	  {$i-}
	  repeat
				reset(Arq);
				io:=ioresult;
				if io<>0 then
				begin
						if not(vo) then (* s¢ mostra a primeira vez*)
						status('Aguarde libera‡Æo de arquivo...');
						vo:=true;
				end;
				if io=2 then
				begin
					  save;
					  reset(arq);
				end;
	  until (io=0);
	  {$i+}
	  readln(arq,str); cmenu:=strtoint(copy(str,10,2));
	  readln(arq,str); fmenu:=strtoint(copy(str,10,2));
	  readln(arq,str); cbarra:=strtoint(copy(str,10,2));
	  readln(arq,str); fbarra:=strtoint(copy(str,10,2));
	  readln(arq,str); cdestaque:=strtoint(copy(str,10,2));
	  readln(arq,str); cstatus:=strtoint(copy(str,10,2));
	  readln(arq,str); fstatus:=strtoint(copy(str,10,2));
	  readln(arq,str); ctitulo:=strtoint(copy(str,10,2));
	  readln(arq,str); ftitulo:=strtoint(copy(str,10,2));
	  readln(arq,str); cerro:=strtoint(copy(str,10,2));
	  readln(arq,str); ferro:=strtoint(copy(str,10,2));
	  readln(arq,str); cdesk:=strtoint(copy(str,10,2));
	  readln(arq,str); fdesk:=strtoint(copy(str,10,2));
     readln(arq,str); Msaver:=str; delete(Msaver,1,9);
     readln(arq,str); TimeSaver:=strtoint(copy(str,10,2));
     readln(arq,str); font:=strtoint(copy(str,10,2));
	  close(arq);
     case font of
       1 : Tfont_normal;
       2 : Tfont_currier;
       3 : Tfont_comic;
       4 : Tfont_future;
       5 : Tfont_galla;
       6 : Tfont_script;
       7 : Tfont_funny;
       8 : Tfont_elegant;
       9 : Tfont_times;
       10 : Tfont_arial;
       11 : Tfont_tahoma;
       12 : Tfont_Italic;
       13 : Tfont_impact;
       14 : Tfont_segs;
    end;

end;
(************************************************************************)
(* grava variaveis de cores
(************************************************************************)
Procedure save;
var
	Arq : text;
begin
	  assign(arq,'farm.dsk');
	  rewrite(arq);
	  {$i+}
	  writeln(arq,'cmenu  = ',cmenu);
	  writeln(arq,'fmenu  = ',fmenu);
	  writeln(arq,'cbarra = ',cbarra);
	  writeln(arq,'fbarra = ',fbarra);
	  writeln(arq,'cdestaq= ',cdestaque);
	  writeln(arq,'cstatus= ',cstatus);
	  writeln(arq,'fstatus= ',fstatus);
	  writeln(arq,'ctitulo= ',ctitulo);
	  writeln(arq,'ftitulo= ',ftitulo);
	  writeln(arq,'cerro  = ',cerro);
	  writeln(arq,'ferro  = ',ferro);
	  writeln(arq,'cdesk  = ',cdesk);
	  writeln(arq,'fdesk  = ',fdesk);
     writeln(arq,'Msaver = ',Msaver);
     writeln(arq,'TimeSvr= ',TimeSaver);
     writeln(arq,'font   = ',font);
     writeln(arq,'[fim]');
	  close(arq);
end;
(************************************************************************)
(* Executa Mem/c/p
(************************************************************************)
Procedure ver_memoria;
begin
  swapvectors;
  exec('c:\windows\command\mem.exe','/c/p');
  readln;
  swapvectors;
end;
(************************************************************************)
(* Limpa os Hints da Barra de Status
(************************************************************************)
Procedure Limpa_Hints;
var
 i : byte;
begin
     for i:=low(Hints) to High(Hints) do
       Hints[i]:='';
end;
(************************************************************************
  Da um ola na tela - Usado para depura‡Æo
*************************************************************************)
Procedure ola;
begin
  erro('Ola Mundo CRUEL');
end;
(***************************************************************************
 FAZ UMA CAIXINHA COM AS STRINGS PASSADAS
 RETORNA STRING SELECIONADA
***************************************************************************)
Function Caixinha (x,y : byte;items : string): string;
var
 i,c,j : byte;
 linha : array [1..20] of string[30];
 sel,ret_sel,ma : byte;
begin
 for c:=1 to 20 do
 begin
   linha[c]:='';
 end;
 c:=1;
 for i:=1 to length(items) do
 begin
   if items[i]<>'@' then
     linha[c]:=linha[c]+items[i];
   if items[i]='@' then
      c:=c+1;
 end;
 (*ACHAR MAIOR STRING*)
 for j:=1 to c do
 begin
     if j=1 then
      ma:=length(linha[j])
     else
       if length(linha[j])>ma then
        ma:=length(linha[j]);
 end;
 salva_tela(19);
 menu(x,y,x+ma+3,y+c+1,cmenu,fmenu,'');
 for j:=1 to c do
 most(x+2,y+j,cmenu,fmenu,linha[j]);
 sel:=1;
 role(x+1,y+1,x+ma+2,y+c,cbarra,fbarra,cmenu,fmenu,sel,ret_sel);
 caixinha:=linha[sel];
 volta_tela(19,false);
 key:=nullkey;
end;
(***************************************************************************)
Procedure ndelay(tempo : integer);
var
 h1,m1,s1,c1,
 h2,m2,s2,c2 : word;
begin
  gettime(h1,m1,s1,c1);
 { repeat}
  gettime(h2,m2,s2,c2);
end;
(***************************************************************************
CARREGA FONTES
(***************************************************************************)
procedure carrega_mainfonte;
var r:registers;
const tabel:array[1..16*256] of byte =(
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,126,129,165,129,129,189,153,129,129,126,0,0,0,0,
0,0,126,255,219,255,255,195,231,255,255,126,0,0,0,0,
0,0,0,0,108,254,254,254,254,124,56,16,0,0,0,0,
0,0,0,0,16,56,124,254,124,56,16,0,0,0,0,0,
0,0,0,24,60,60,231,231,231,24,24,60,0,0,0,0,
0,0,0,24,60,126,255,255,126,24,24,60,0,0,0,0,
0,0,0,0,0,0,24,60,60,24,0,0,0,0,0,0,
255,255,255,255,255,255,231,195,195,231,255,255,255,255,255,255,
0,0,0,0,0,60,102,66,66,102,60,0,0,0,0,0,
255,255,255,255,255,195,153,189,189,153,195,255,255,255,255,255,
0,0,30,14,26,50,120,204,204,204,204,120,0,0,0,0,
0,0,60,102,102,102,102,60,24,126,24,24,0,0,0,0,
0,0,63,51,63,48,48,48,48,112,240,224,0,0,0,0,
0,0,127,99,127,99,99,99,99,103,231,230,192,0,0,0,
0,0,0,24,24,219,60,231,60,219,24,24,0,0,0,0,
0,128,192,224,240,248,252,248,240,224,192,128,0,0,0,0,
0,2,6,14,30,62,126,62,30,14,6,2,0,0,0,0,
0,0,24,60,126,24,24,24,126,60,24,0,0,0,0,0,
0,0,102,102,102,102,102,102,102,0,102,102,0,0,0,0,
0,0,127,219,219,219,123,27,27,27,27,27,0,0,0,0,
0,124,198,96,56,108,198,198,108,56,12,198,124,0,0,0,
0,0,0,0,0,0,0,0,254,254,254,254,0,0,0,0,
0,0,24,60,126,24,24,24,126,60,24,126,0,0,0,0,
0,0,24,60,126,24,24,24,24,24,24,24,0,0,0,0,
0,0,24,24,24,24,24,24,24,126,60,24,0,0,0,0,
0,0,0,0,0,24,12,254,12,24,0,0,0,0,0,0,
0,0,0,0,0,48,96,254,96,48,0,0,0,0,0,0,
0,0,0,0,0,0,192,192,192,254,0,0,0,0,0,0,
0,0,0,0,0,40,108,254,108,40,0,0,0,0,0,0,
0,0,0,0,16,56,56,124,124,254,254,0,0,0,0,0,
0,0,0,0,254,254,124,124,56,56,16,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,24,60,60,60,24,24,24,0,24,24,0,0,0,0,
0,102,102,102,36,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,108,108,254,108,108,108,254,108,108,0,0,0,0,
24,24,124,198,194,192,124,6,6,134,198,124,24,24,0,0,
0,0,0,0,194,198,12,24,48,96,198,134,0,0,0,0,
0,0,56,108,108,56,118,220,204,204,204,118,0,0,0,0,
0,48,48,48,96,0,0,0,0,0,0,0,0,0,0,0,
0,0,12,24,48,48,48,48,48,48,24,12,0,0,0,0,
0,0,48,24,12,12,12,12,12,12,24,48,0,0,0,0,
0,0,0,0,0,102,60,255,60,102,0,0,0,0,0,0,
0,0,0,0,0,24,24,126,24,24,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,24,24,24,48,0,0,0,
0,0,0,0,0,0,0,254,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,24,24,0,0,0,0,
0,0,0,0,2,6,12,24,48,96,192,128,0,0,0,0,
0,0,56,108,198,198,214,214,198,198,108,56,0,0,0,0,
0,0,24,56,120,24,24,24,24,24,24,126,0,0,0,0,
0,0,124,198,6,12,24,48,96,192,198,254,0,0,0,0,
0,0,124,198,6,6,60,6,6,6,198,124,0,0,0,0,
0,0,12,28,60,108,204,254,12,12,12,30,0,0,0,0,
0,0,254,192,192,192,252,6,6,6,198,124,0,0,0,0,
0,0,56,96,192,192,252,198,198,198,198,124,0,0,0,0,
0,0,254,198,6,6,12,24,48,48,48,48,0,0,0,0,
0,0,124,198,198,198,124,198,198,198,198,124,0,0,0,0,
0,0,124,198,198,198,126,6,6,6,12,120,0,0,0,0,
0,0,0,0,24,24,0,0,0,24,24,0,0,0,0,0,
0,0,0,0,24,24,0,0,0,24,24,48,0,0,0,0,
0,0,0,6,12,24,48,96,48,24,12,6,0,0,0,0,
0,0,0,0,0,126,0,0,126,0,0,0,0,0,0,0,
0,0,0,96,48,24,12,6,12,24,48,96,0,0,0,0,
0,0,124,198,198,12,24,24,24,0,24,24,0,0,0,0,
0,0,0,124,198,198,222,222,222,220,192,124,0,0,0,0,
0,0,16,56,108,198,198,254,198,198,198,198,0,0,0,0,
0,0,252,102,102,102,124,102,102,102,102,252,0,0,0,0,
0,0,60,102,194,192,192,192,192,194,102,60,0,0,0,0,
0,0,248,108,102,102,102,102,102,102,108,248,0,0,0,0,
0,0,254,102,98,104,120,104,96,98,102,254,0,0,0,0,
0,0,254,102,98,104,120,104,96,96,96,240,0,0,0,0,
0,0,60,102,194,192,192,222,198,198,102,58,0,0,0,0,
0,0,198,198,198,198,254,198,198,198,198,198,0,0,0,0,
0,0,60,24,24,24,24,24,24,24,24,60,0,0,0,0,
0,0,30,12,12,12,12,12,204,204,204,120,0,0,0,0,
0,0,230,102,102,108,120,120,108,102,102,230,0,0,0,0,
0,0,240,96,96,96,96,96,96,98,102,254,0,0,0,0,
0,0,198,238,254,254,214,198,198,198,198,198,0,0,0,0,
0,0,198,230,246,254,222,206,198,198,198,198,0,0,0,0,
0,0,124,198,198,198,198,198,198,198,198,124,0,0,0,0,
0,0,252,102,102,102,124,96,96,96,96,240,0,0,0,0,
0,0,124,198,198,198,198,198,198,214,222,124,12,14,0,0,
0,0,252,102,102,102,124,108,102,102,102,230,0,0,0,0,
0,0,124,198,198,96,56,12,6,198,198,124,0,0,0,0,
0,0,126,126,90,24,24,24,24,24,24,60,0,0,0,0,
0,0,198,198,198,198,198,198,198,198,198,124,0,0,0,0,
0,0,198,198,198,198,198,198,198,108,56,16,0,0,0,0,
0,0,198,198,198,198,214,214,214,254,238,108,0,0,0,0,
0,0,198,198,108,124,56,56,124,108,198,198,0,0,0,0,
0,0,102,102,102,102,60,24,24,24,24,60,0,0,0,0,
0,0,254,198,134,12,24,48,96,194,198,254,0,0,0,0,
0,0,60,48,48,48,48,48,48,48,48,60,0,0,0,0,
0,0,0,128,192,224,112,56,28,14,6,2,0,0,0,0,
0,0,60,12,12,12,12,12,12,12,12,60,0,0,0,0,
16,56,108,198,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,255,0,0,
0,48,24,12,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,120,12,124,204,204,204,118,0,0,0,0,
0,0,224,96,96,120,108,102,102,102,102,124,0,0,0,0,
0,0,0,0,0,124,198,192,192,192,198,124,0,0,0,0,
0,0,28,12,12,60,108,204,204,204,204,118,0,0,0,0,
0,0,0,0,0,124,198,254,192,192,198,124,0,0,0,0,
0,0,28,54,50,48,120,48,48,48,48,120,0,0,0,0,
0,0,0,0,0,118,204,204,204,204,204,124,12,204,120,0,
0,0,224,96,96,108,118,102,102,102,102,230,0,0,0,0,
0,0,24,24,0,56,24,24,24,24,24,60,0,0,0,0,
0,0,6,6,0,14,6,6,6,6,6,6,102,102,60,0,
0,0,224,96,96,102,108,120,120,108,102,230,0,0,0,0,
0,0,56,24,24,24,24,24,24,24,24,60,0,0,0,0,
0,0,0,0,0,236,254,214,214,214,214,198,0,0,0,0,
0,0,0,0,0,220,102,102,102,102,102,102,0,0,0,0,
0,0,0,0,0,124,198,198,198,198,198,124,0,0,0,0,
0,0,0,0,0,220,102,102,102,102,102,124,96,96,240,0,
0,0,0,0,0,118,204,204,204,204,204,124,12,12,30,0,
0,0,0,0,0,220,118,102,96,96,96,240,0,0,0,0,
0,0,0,0,0,124,198,96,56,12,198,124,0,0,0,0,
0,0,16,48,48,252,48,48,48,48,54,28,0,0,0,0,
0,0,0,0,0,204,204,204,204,204,204,118,0,0,0,0,
0,0,0,0,0,198,198,198,198,198,108,56,0,0,0,0,
0,0,0,0,0,198,198,214,214,214,254,108,0,0,0,0,
0,0,0,0,0,198,108,56,56,56,108,198,0,0,0,0,
0,0,0,0,0,198,198,198,198,198,198,126,6,12,248,0,
0,0,0,0,0,254,204,24,48,96,198,254,0,0,0,0,
0,0,14,24,24,24,112,24,24,24,24,14,0,0,0,0,
0,0,24,24,24,24,24,24,24,24,24,24,0,0,0,0,
0,0,112,24,24,24,14,24,24,24,24,112,0,0,0,0,
0,118,220,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,16,56,108,198,198,198,254,0,0,0,0,0,
0,0,60,102,194,192,192,192,192,194,102,60,24,112,0,0,
0,0,204,0,0,204,204,204,204,204,204,118,0,0,0,0,
0,12,24,48,0,124,198,254,192,192,198,124,0,0,0,0,
0,16,56,108,0,120,12,124,204,204,204,118,0,0,0,0,
0,0,204,0,0,120,12,124,204,204,204,118,0,0,0,0,
0,96,48,24,0,120,12,124,204,204,204,118,0,0,0,0,
0,56,108,56,0,120,12,124,204,204,204,118,0,0,0,0,
0,0,0,0,0,124,198,192,192,192,198,124,24,112,0,0,
0,16,56,108,0,124,198,254,192,192,198,124,0,0,0,0,
0,0,198,0,0,124,198,254,192,192,198,124,0,0,0,0,
0,96,48,24,0,124,198,254,192,192,198,124,0,0,0,0,
0,0,102,0,0,56,24,24,24,24,24,60,0,0,0,0,
0,24,60,102,0,56,24,24,24,24,24,60,0,0,0,0,
0,96,48,24,0,56,24,24,24,24,24,60,0,0,0,0,
0,198,0,16,56,108,198,198,254,198,198,198,0,0,0,0,
56,108,56,16,56,108,198,198,254,198,198,198,0,0,0,0,
12,24,0,254,102,98,104,120,104,98,102,254,0,0,0,0,
0,0,0,0,0,236,180,52,124,88,88,108,0,0,0,0,
0,0,62,108,204,204,254,204,204,204,204,206,0,0,0,0,
0,16,56,108,0,124,198,198,198,198,198,124,0,0,0,0,
0,0,246,130,130,130,226,130,130,130,135,0,0,0,0,0,
0,0,247,129,129,129,231,132,132,132,135,0,0,0,0,0,
0,0,247,129,129,129,227,129,129,129,135,0,0,0,0,0,
0,0,245,133,133,133,231,129,129,129,129,0,0,0,0,0,
0,0,247,132,132,132,231,129,129,129,135,0,0,0,0,0,
0,0,247,132,132,132,231,133,133,133,135,0,0,0,0,0,
0,0,247,129,129,130,226,130,132,132,132,0,0,0,0,0,
0,0,242,133,133,133,226,133,133,133,130,0,0,0,0,0,
0,0,247,133,133,133,231,129,129,129,135,0,0,0,0,0,
0,0,224,160,160,160,160,160,160,160,224,0,0,0,0,0,
0,0,0,0,0,198,108,56,56,108,198,0,0,0,0,0,
0,14,27,24,24,24,126,24,24,24,216,112,0,0,0,0,
0,24,48,96,0,120,12,124,204,204,204,118,0,0,0,0,
0,12,24,48,0,56,24,24,24,24,24,60,0,0,0,0,
0,24,48,96,0,124,198,198,198,198,198,124,0,0,0,0,
0,24,48,96,0,204,204,204,204,204,204,118,0,0,0,0,
129,129,195,102,44,56,24,28,20,54,34,98,194,129,129,129,
0,0,7,5,5,5,7,4,4,4,4,0,0,0,0,0,
0,0,0,0,0,0,229,165,165,165,247,0,0,0,0,0,
0,0,64,64,64,80,64,80,80,80,80,0,0,0,0,0,
0,0,224,128,128,128,238,138,138,138,143,0,0,0,0,0,
0,0,0,0,0,0,169,207,137,137,137,0,0,0,0,0,
0,0,0,0,0,0,169,207,137,137,137,0,0,0,0,0,
0,0,0,32,64,0,231,164,164,164,247,0,0,0,0,0,
0,0,0,0,0,0,184,168,168,168,188,0,0,0,0,0,
0,0,24,24,0,24,24,24,60,60,60,24,0,0,0,0,
0,0,0,0,0,54,108,216,108,54,0,0,0,0,0,0,
0,0,0,0,0,216,108,54,108,216,0,0,0,0,0,0,
17,68,17,68,17,68,17,68,17,68,17,68,17,68,17,68,
85,170,85,170,85,170,85,170,85,170,85,170,85,170,85,170,
0,0,0,0,0,0,0,24,24,0,0,0,0,0,0,0,
192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,192,
24,24,24,24,24,24,24,248,24,24,24,24,24,24,24,24,
96,192,16,56,108,198,198,254,198,198,198,198,0,0,0,0,
124,198,16,56,108,198,198,254,198,198,198,198,0,0,0,0,
12,6,16,56,108,198,198,254,198,198,198,198,0,0,0,0,
0,0,124,130,154,162,162,162,154,130,124,0,0,0,0,0,
54,54,54,54,54,246,6,246,54,54,54,54,54,54,54,54,
54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,
0,0,0,0,0,254,6,246,54,54,54,54,54,54,54,54,
54,54,54,54,54,246,6,254,0,0,0,0,0,0,0,0,
0,0,24,24,124,198,192,192,198,124,24,24,0,0,0,0,
0,0,0,102,102,60,24,126,24,126,24,24,0,0,0,0,
0,0,0,0,0,0,0,248,24,24,24,24,24,24,24,24,
192,192,192,192,192,192,192,192,192,192,192,192,192,192,255,255,
24,24,24,24,24,24,24,255,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,255,24,24,24,24,24,24,24,24,
0,0,0,0,0,0,24,24,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,
255,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,118,220,0,120,12,124,204,204,204,118,0,0,0,0,
118,220,0,56,108,198,198,254,198,198,198,198,0,0,0,0,
54,54,54,54,54,55,48,63,0,0,0,0,0,0,0,0,
255,128,128,128,128,128,143,143,143,128,128,128,128,128,128,255,
255,1,1,1,1,1,241,241,241,1,1,1,1,1,1,255,
0,0,0,3,12,16,32,32,32,32,16,12,3,0,0,0,
0,0,0,192,48,8,4,4,4,4,8,48,192,0,0,0,
255,255,192,192,192,192,192,192,192,192,192,192,192,192,192,192,
255,255,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
0,0,0,0,198,124,198,198,198,198,124,198,0,0,0,0,
16,16,16,16,16,16,16,255,16,16,16,16,16,16,16,16,
0,0,0,0,0,0,0,255,16,16,16,16,16,16,16,16,
56,108,0,254,102,98,104,120,104,98,102,254,0,0,0,0,
16,16,16,16,16,16,16,255,0,0,0,0,0,0,0,0,
0,255,192,192,192,192,192,192,192,192,192,192,192,192,255,0,
0,255,1,1,1,1,1,1,1,1,1,1,1,1,255,0,
12,24,0,60,24,24,24,24,24,24,24,60,0,0,0,0,
0,255,192,192,192,200,200,196,196,194,194,193,193,192,255,0,
0,255,1,1,9,17,17,33,65,129,129,1,1,1,255,0,
1,1,1,1,1,1,1,1,1,1,1,1,1,1,255,255,
0,0,0,0,0,0,0,255,0,0,0,0,0,0,0,0,
255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
0,0,0,3,12,16,35,39,39,35,16,12,3,0,0,0,
0,0,0,192,48,8,196,228,228,196,8,48,192,0,0,0,
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
255,128,128,128,128,128,128,128,128,128,128,128,128,128,128,255,
24,48,0,124,198,198,198,198,198,198,198,124,0,0,0,0,
0,0,120,204,204,204,216,204,198,198,198,204,0,0,0,0,
56,108,0,124,198,198,198,198,198,198,198,124,0,0,0,0,
48,24,0,124,198,198,198,198,198,198,198,124,0,0,0,0,
0,0,118,220,0,124,198,198,198,198,198,124,0,0,0,0,
118,220,0,124,198,198,198,198,198,198,198,124,0,0,0,0,
0,0,0,0,0,102,102,102,102,102,102,124,96,96,192,0,
0,0,224,96,96,124,102,102,102,102,102,124,96,96,240,0,
0,0,240,96,124,102,102,102,102,124,96,240,0,0,0,0,
24,48,0,198,198,198,198,198,198,198,198,124,0,0,0,0,
56,108,0,198,198,198,198,198,198,198,198,124,0,0,0,0,
48,24,0,198,198,198,198,198,198,198,198,124,0,0,0,0,
0,12,24,48,0,198,198,198,198,198,198,126,6,12,248,0,
16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,
0,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,12,24,48,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,254,0,0,0,0,0,0,0,0,
0,0,0,0,24,24,126,24,24,0,0,126,0,0,0,0,
0,0,119,68,68,68,119,65,65,65,119,0,0,0,0,0,
0,0,240,128,128,128,128,128,128,128,240,0,0,0,0,0,
0,0,231,148,148,148,151,148,148,148,231,0,0,0,0,0,
0,0,128,128,128,128,128,128,128,128,240,0,0,0,0,0,
0,0,0,0,0,24,0,126,0,24,0,0,0,0,0,0,
0,0,124,130,130,130,198,170,146,130,130,130,124,0,0,0,
0,0,0,60,60,60,255,255,255,60,60,60,0,0,0,0,
0,119,69,69,71,69,117,0,71,69,69,69,69,119,0,0,
0,238,168,168,238,130,142,0,234,138,138,140,138,234,0,0,
0,149,213,181,149,149,151,0,71,69,69,69,69,119,0,0,
0,136,216,168,136,136,136,0,234,138,138,140,138,234,0,0,
0,0,233,77,77,75,75,75,73,73,233,0,0,0,0,0,
0,0,224,128,128,128,224,32,32,32,224,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
begin
r.ah:=$11;
r.al:=$10;
r.bl:=16;
r.bh:=16;
r.cx:=256;
r.dx:=0;
r.es:=seg(tabel[1]);
r.bp:=ofs(tabel[1]);
intr($10,r);
end;
(***************************************************************************)
Procedure Carrega_normfonte;
const tabel : array [1..16*256] of char=(
#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#126,#129,#165,#129,#129,#189,#153,#129,#129,#126,#0,#0,#0,#0,
#0,#0,#126,#255,#219,#255,#255,#195,#231,#255,#255,#126,#0,#0,#0,#0,
#0,#0,#0,#0,#108,#254,#254,#254,#254,#124,#56,#16,#0,#0,#0,#0,
#0,#0,#0,#0,#16,#56,#124,#254,#124,#56,#16,#0,#0,#0,#0,#0,
#0,#0,#0,#24,#60,#60,#231,#231,#231,#24,#24,#60,#0,#0,#0,#0,
#0,#0,#0,#24,#60,#126,#255,#255,#126,#24,#24,#60,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#24,#60,#60,#24,#0,#0,#0,#0,#0,#0,
#255,#255,#255,#255,#255,#255,#231,#195,#195,#231,#255,#255,#255,#255,#255,#255,
#0,#0,#0,#0,#0,#60,#102,#66,#66,#102,#60,#0,#0,#0,#0,#0,
#255,#255,#255,#255,#255,#195,#153,#189,#189,#153,#195,#255,#255,#255,#255,#255,
#0,#0,#30,#14,#26,#50,#120,#204,#204,#204,#204,#120,#0,#0,#0,#0,
#0,#0,#60,#102,#102,#102,#102,#60,#24,#126,#24,#24,#0,#0,#0,#0,
#0,#0,#63,#51,#63,#48,#48,#48,#48,#112,#240,#224,#0,#0,#0,#0,
#0,#0,#127,#99,#127,#99,#99,#99,#99,#103,#231,#230,#192,#0,#0,#0,
#0,#0,#0,#24,#24,#219,#60,#231,#60,#219,#24,#24,#0,#0,#0,#0,
#0,#128,#192,#224,#240,#248,#254,#248,#240,#224,#192,#128,#0,#0,#0,#0,
#0,#2,#6,#14,#30,#62,#254,#62,#30,#14,#6,#2,#0,#0,#0,#0,
#0,#0,#24,#60,#126,#24,#24,#24,#126,#60,#24,#0,#0,#0,#0,#0,
#0,#0,#102,#102,#102,#102,#102,#102,#102,#0,#102,#102,#0,#0,#0,#0,
#0,#0,#127,#219,#219,#219,#123,#27,#27,#27,#27,#27,#0,#0,#0,#0,
#0,#124,#198,#96,#56,#108,#198,#198,#108,#56,#12,#198,#124,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#0,#254,#254,#254,#254,#0,#0,#0,#0,
#0,#0,#24,#60,#126,#24,#24,#24,#126,#60,#24,#126,#0,#0,#0,#0,
#0,#0,#24,#60,#126,#24,#24,#24,#24,#24,#24,#24,#0,#0,#0,#0,
#0,#0,#24,#24,#24,#24,#24,#24,#24,#126,#60,#24,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#24,#12,#254,#12,#24,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#48,#96,#254,#96,#48,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#192,#192,#192,#254,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#40,#108,#254,#108,#40,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#16,#56,#56,#124,#124,#254,#254,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#254,#254,#124,#124,#56,#56,#16,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#24,#60,#60,#60,#24,#24,#24,#0,#24,#24,#0,#0,#0,#0,
#0,#102,#102,#102,#36,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#108,#108,#254,#108,#108,#108,#254,#108,#108,#0,#0,#0,#0,
#24,#24,#124,#198,#194,#192,#124,#6,#6,#134,#198,#124,#24,#24,#0,#0,
#0,#0,#0,#0,#194,#198,#12,#24,#48,#96,#198,#134,#0,#0,#0,#0,
#0,#0,#56,#108,#108,#56,#118,#220,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#48,#48,#48,#96,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#12,#24,#48,#48,#48,#48,#48,#48,#24,#12,#0,#0,#0,#0,
#0,#0,#48,#24,#12,#12,#12,#12,#12,#12,#24,#48,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#102,#60,#255,#60,#102,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#24,#24,#126,#24,#24,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#0,#0,#24,#24,#24,#48,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#254,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#24,#24,#0,#0,#0,#0,
#0,#0,#0,#0,#2,#6,#12,#24,#48,#96,#192,#128,#0,#0,#0,#0,
#0,#0,#56,#108,#198,#198,#214,#214,#198,#198,#108,#56,#0,#0,#0,#0,
#0,#0,#24,#56,#120,#24,#24,#24,#24,#24,#24,#126,#0,#0,#0,#0,
#0,#0,#124,#198,#6,#12,#24,#48,#96,#192,#198,#254,#0,#0,#0,#0,
#0,#0,#124,#198,#6,#6,#60,#6,#6,#6,#198,#124,#0,#0,#0,#0,
#0,#0,#12,#28,#60,#108,#204,#254,#12,#12,#12,#30,#0,#0,#0,#0,
#0,#0,#254,#192,#192,#192,#252,#6,#6,#6,#198,#124,#0,#0,#0,#0,
#0,#0,#56,#96,#192,#192,#252,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#254,#198,#6,#6,#12,#24,#48,#48,#48,#48,#0,#0,#0,#0,
#0,#0,#124,#198,#198,#198,#124,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#124,#198,#198,#198,#126,#6,#6,#6,#12,#120,#0,#0,#0,#0,
#0,#0,#0,#0,#24,#24,#0,#0,#0,#24,#24,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#24,#24,#0,#0,#0,#24,#24,#48,#0,#0,#0,#0,
#0,#0,#0,#6,#12,#24,#48,#96,#48,#24,#12,#6,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#126,#0,#0,#126,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#96,#48,#24,#12,#6,#12,#24,#48,#96,#0,#0,#0,#0,
#0,#0,#124,#198,#198,#12,#24,#24,#24,#0,#24,#24,#0,#0,#0,#0,
#0,#0,#0,#124,#198,#198,#222,#222,#222,#220,#192,#124,#0,#0,#0,#0,
#0,#0,#16,#56,#108,#198,#198,#254,#198,#198,#198,#198,#0,#0,#0,#0,
#0,#0,#252,#102,#102,#102,#124,#102,#102,#102,#102,#252,#0,#0,#0,#0,
#0,#0,#60,#102,#194,#192,#192,#192,#192,#194,#102,#60,#0,#0,#0,#0,
#0,#0,#248,#108,#102,#102,#102,#102,#102,#102,#108,#248,#0,#0,#0,#0,
#0,#0,#254,#102,#98,#104,#120,#104,#96,#98,#102,#254,#0,#0,#0,#0,
#0,#0,#254,#102,#98,#104,#120,#104,#96,#96,#96,#240,#0,#0,#0,#0,
#0,#0,#60,#102,#194,#192,#192,#222,#198,#198,#102,#58,#0,#0,#0,#0,
#0,#0,#198,#198,#198,#198,#254,#198,#198,#198,#198,#198,#0,#0,#0,#0,
#0,#0,#60,#24,#24,#24,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#0,#0,#30,#12,#12,#12,#12,#12,#204,#204,#204,#120,#0,#0,#0,#0,
#0,#0,#230,#102,#102,#108,#120,#120,#108,#102,#102,#230,#0,#0,#0,#0,
#0,#0,#240,#96,#96,#96,#96,#96,#96,#98,#102,#254,#0,#0,#0,#0,
#0,#0,#198,#238,#254,#254,#214,#198,#198,#198,#198,#198,#0,#0,#0,#0,
#0,#0,#198,#230,#246,#254,#222,#206,#198,#198,#198,#198,#0,#0,#0,#0,
#0,#0,#124,#198,#198,#198,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#252,#102,#102,#102,#124,#96,#96,#96,#96,#240,#0,#0,#0,#0,
#0,#0,#124,#198,#198,#198,#198,#198,#198,#214,#222,#124,#12,#14,#0,#0,
#0,#0,#252,#102,#102,#102,#124,#108,#102,#102,#102,#230,#0,#0,#0,#0,
#0,#0,#124,#198,#198,#96,#56,#12,#6,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#126,#126,#90,#24,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#0,#0,#198,#198,#198,#198,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#198,#198,#198,#198,#198,#198,#198,#108,#56,#16,#0,#0,#0,#0,
#0,#0,#198,#198,#198,#198,#214,#214,#214,#254,#238,#108,#0,#0,#0,#0,
#0,#0,#198,#198,#108,#124,#56,#56,#124,#108,#198,#198,#0,#0,#0,#0,
#0,#0,#102,#102,#102,#102,#60,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#0,#0,#254,#198,#134,#12,#24,#48,#96,#194,#198,#254,#0,#0,#0,#0,
#0,#0,#60,#48,#48,#48,#48,#48,#48,#48,#48,#60,#0,#0,#0,#0,
#0,#0,#0,#128,#192,#224,#112,#56,#28,#14,#6,#2,#0,#0,#0,#0,
#0,#0,#60,#12,#12,#12,#12,#12,#12,#12,#12,#60,#0,#0,#0,#0,
#16,#56,#108,#198,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#255,#0,#0,
#0,#48,#24,#12,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#120,#12,#124,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#0,#224,#96,#96,#120,#108,#102,#102,#102,#102,#124,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#124,#198,#192,#192,#192,#198,#124,#0,#0,#0,#0,
#0,#0,#28,#12,#12,#60,#108,#204,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#124,#198,#254,#192,#192,#198,#124,#0,#0,#0,#0,
#0,#0,#28,#54,#50,#48,#120,#48,#48,#48,#48,#120,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#118,#204,#204,#204,#204,#204,#124,#12,#204,#120,#0,
#0,#0,#224,#96,#96,#108,#118,#102,#102,#102,#102,#230,#0,#0,#0,#0,
#0,#0,#24,#24,#0,#56,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#0,#0,#6,#6,#0,#14,#6,#6,#6,#6,#6,#6,#102,#102,#60,#0,
#0,#0,#224,#96,#96,#102,#108,#120,#120,#108,#102,#230,#0,#0,#0,#0,
#0,#0,#56,#24,#24,#24,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#236,#254,#214,#214,#214,#214,#198,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#220,#102,#102,#102,#102,#102,#102,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#124,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#220,#102,#102,#102,#102,#102,#124,#96,#96,#240,#0,
#0,#0,#0,#0,#0,#118,#204,#204,#204,#204,#204,#124,#12,#12,#30,#0,
#0,#0,#0,#0,#0,#220,#118,#102,#96,#96,#96,#240,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#124,#198,#96,#56,#12,#198,#124,#0,#0,#0,#0,
#0,#0,#16,#48,#48,#252,#48,#48,#48,#48,#54,#28,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#204,#204,#204,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#198,#198,#198,#198,#198,#108,#56,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#198,#198,#214,#214,#214,#254,#108,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#198,#108,#56,#56,#56,#108,#198,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#198,#198,#198,#198,#198,#198,#126,#6,#12,#248,#0,
#0,#0,#0,#0,#0,#254,#204,#24,#48,#96,#198,#254,#0,#0,#0,#0,
#0,#0,#14,#24,#24,#24,#112,#24,#24,#24,#24,#14,#0,#0,#0,#0,
#0,#0,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#0,#0,#0,#0,
#0,#0,#112,#24,#24,#24,#14,#24,#24,#24,#24,#112,#0,#0,#0,#0,
#0,#118,#220,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#16,#56,#108,#198,#198,#198,#254,#0,#0,#0,#0,#0,
#0,#0,#60,#102,#194,#192,#192,#192,#192,#194,#102,#60,#24,#112,#0,#0,
#0,#0,#204,#0,#0,#204,#204,#204,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#12,#24,#48,#0,#124,#198,#254,#192,#192,#198,#124,#0,#0,#0,#0,
#0,#16,#56,#108,#0,#120,#12,#124,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#0,#204,#0,#0,#120,#12,#124,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#96,#48,#24,#0,#120,#12,#124,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#56,#108,#56,#0,#120,#12,#124,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#124,#198,#192,#192,#192,#198,#124,#24,#112,#0,#0,
#0,#16,#56,#108,#0,#124,#198,#254,#192,#192,#198,#124,#0,#0,#0,#0,
#0,#0,#198,#0,#0,#124,#198,#254,#192,#192,#198,#124,#0,#0,#0,#0,
#0,#96,#48,#24,#0,#124,#198,#254,#192,#192,#198,#124,#0,#0,#0,#0,
#0,#0,#102,#0,#0,#56,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#0,#24,#60,#102,#0,#56,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#0,#96,#48,#24,#0,#56,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#0,#198,#0,#16,#56,#108,#198,#198,#254,#198,#198,#198,#0,#0,#0,#0,
#56,#108,#56,#16,#56,#108,#198,#198,#254,#198,#198,#198,#0,#0,#0,#0,
#12,#24,#0,#254,#102,#98,#104,#120,#104,#98,#102,#254,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#236,#54,#54,#126,#216,#216,#110,#0,#0,#0,#0,
#0,#0,#62,#108,#204,#204,#254,#204,#204,#204,#204,#206,#0,#0,#0,#0,
#0,#16,#56,#108,#0,#124,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#198,#0,#0,#124,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#96,#48,#24,#0,#124,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#48,#120,#204,#0,#204,#204,#204,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#96,#48,#24,#0,#204,#204,#204,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#0,#198,#0,#0,#198,#198,#198,#198,#198,#198,#126,#6,#12,#120,#0,
#0,#198,#0,#124,#198,#198,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#198,#0,#198,#198,#198,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#124,#206,#222,#246,#230,#198,#124,#0,#0,#0,#0,
#0,#56,#108,#100,#96,#240,#96,#96,#96,#96,#230,#252,#0,#0,#0,#0,
#0,#4,#124,#206,#206,#214,#214,#214,#214,#230,#230,#124,#64,#0,#0,#0,
#0,#0,#0,#0,#0,#198,#108,#56,#56,#108,#198,#0,#0,#0,#0,#0,
#0,#14,#27,#24,#24,#24,#126,#24,#24,#24,#216,#112,#0,#0,#0,#0,
#0,#24,#48,#96,#0,#120,#12,#124,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#12,#24,#48,#0,#56,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#0,#24,#48,#96,#0,#124,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#24,#48,#96,#0,#204,#204,#204,#204,#204,#204,#118,#0,#0,#0,#0,
#0,#0,#118,#220,#0,#220,#102,#102,#102,#102,#102,#102,#0,#0,#0,#0,
#118,#220,#0,#198,#230,#246,#254,#222,#206,#198,#198,#198,#0,#0,#0,#0,
#0,#0,#60,#108,#108,#62,#0,#126,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#56,#108,#108,#56,#0,#124,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#48,#48,#0,#48,#48,#96,#192,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#124,#130,#178,#170,#178,#170,#170,#130,#124,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#254,#6,#6,#6,#6,#0,#0,#0,#0,#0,
#0,#96,#224,#98,#102,#108,#24,#48,#96,#220,#134,#12,#24,#62,#0,#0,
#0,#96,#224,#98,#102,#108,#24,#48,#102,#206,#154,#63,#6,#6,#0,#0,
#0,#0,#24,#24,#0,#24,#24,#24,#60,#60,#60,#24,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#54,#108,#216,#108,#54,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#216,#108,#54,#108,#216,#0,#0,#0,#0,#0,#0,
#17,#68,#17,#68,#17,#68,#17,#68,#17,#68,#17,#68,#17,#68,#17,#68,
#85,#170,#85,#170,#85,#170,#85,#170,#85,#170,#85,#170,#85,#170,#85,#170,
#221,#119,#221,#119,#221,#119,#221,#119,#221,#119,#221,#119,#221,#119,#221,#119,
#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,
#24,#24,#24,#24,#24,#24,#24,#248,#24,#24,#24,#24,#24,#24,#24,#24,
#96,#192,#16,#56,#108,#198,#198,#254,#198,#198,#198,#198,#0,#0,#0,#0,
#124,#198,#16,#56,#108,#198,#198,#254,#198,#198,#198,#198,#0,#0,#0,#0,
#12,#6,#16,#56,#108,#198,#198,#254,#198,#198,#198,#198,#0,#0,#0,#0,
#0,#0,#124,#130,#154,#162,#162,#162,#154,#130,#124,#0,#0,#0,#0,#0,
#54,#54,#54,#54,#54,#246,#6,#246,#54,#54,#54,#54,#54,#54,#54,#54,
#54,#54,#54,#54,#54,#54,#54,#54,#54,#54,#54,#54,#54,#54,#54,#54,
#0,#0,#0,#0,#0,#254,#6,#246,#54,#54,#54,#54,#54,#54,#54,#54,
#54,#54,#54,#54,#54,#246,#6,#254,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#24,#24,#124,#198,#192,#192,#198,#124,#24,#24,#0,#0,#0,#0,
#0,#0,#0,#102,#102,#60,#24,#126,#24,#126,#24,#24,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#248,#24,#24,#24,#24,#24,#24,#24,#24,
#24,#24,#24,#24,#24,#24,#24,#31,#0,#0,#0,#0,#0,#0,#0,#0,
#24,#24,#24,#24,#24,#24,#24,#255,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#255,#24,#24,#24,#24,#24,#24,#24,#24,
#24,#24,#24,#24,#24,#24,#24,#31,#24,#24,#24,#24,#24,#24,#24,#24,
#0,#0,#0,#0,#0,#0,#0,#255,#0,#0,#0,#0,#0,#0,#0,#0,
#24,#24,#24,#24,#24,#24,#24,#255,#24,#24,#24,#24,#24,#24,#24,#24,
#0,#0,#118,#220,#0,#120,#12,#124,#204,#204,#204,#118,#0,#0,#0,#0,
#118,#220,#0,#56,#108,#198,#198,#254,#198,#198,#198,#198,#0,#0,#0,#0,
#54,#54,#54,#54,#54,#55,#48,#63,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#63,#48,#55,#54,#54,#54,#54,#54,#54,#54,#54,
#54,#54,#54,#54,#54,#247,#0,#255,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#255,#0,#247,#54,#54,#54,#54,#54,#54,#54,#54,
#54,#54,#54,#54,#54,#55,#48,#55,#54,#54,#54,#54,#54,#54,#54,#54,
#0,#0,#0,#0,#0,#255,#0,#255,#0,#0,#0,#0,#0,#0,#0,#0,
#54,#54,#54,#54,#54,#247,#0,#247,#54,#54,#54,#54,#54,#54,#54,#54,
#0,#0,#0,#0,#198,#124,#198,#198,#198,#198,#124,#198,#0,#0,#0,#0,
#0,#0,#52,#24,#44,#6,#62,#102,#102,#102,#102,#60,#0,#0,#0,#0,
#0,#0,#248,#108,#102,#102,#246,#102,#102,#102,#108,#248,#0,#0,#0,#0,
#56,#108,#0,#254,#102,#98,#104,#120,#104,#98,#102,#254,#0,#0,#0,#0,
#0,#198,#0,#254,#102,#98,#104,#120,#104,#98,#102,#254,#0,#0,#0,#0,
#48,#24,#0,#254,#102,#98,#104,#120,#104,#98,#102,#254,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#56,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#12,#24,#0,#60,#24,#24,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#60,#102,#0,#60,#24,#24,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#0,#102,#0,#60,#24,#24,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#24,#24,#24,#24,#24,#24,#24,#248,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#31,#24,#24,#24,#24,#24,#24,#24,#24,
#255,#255,#255,#255,#255,#255,#255,#255,#255,#255,#255,#255,#255,#255,#255,#255,
#0,#0,#0,#0,#0,#0,#0,#255,#255,#255,#255,#255,#255,#255,#255,#255,
#0,#24,#24,#24,#24,#24,#0,#0,#24,#24,#24,#24,#24,#0,#0,#0,
#48,#24,#0,#60,#24,#24,#24,#24,#24,#24,#24,#60,#0,#0,#0,#0,
#255,#255,#255,#255,#255,#255,#255,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#24,#48,#0,#124,#198,#198,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#120,#204,#204,#204,#216,#204,#198,#198,#198,#204,#0,#0,#0,#0,
#56,#108,#0,#124,#198,#198,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#48,#24,#0,#124,#198,#198,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#118,#220,#0,#124,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#118,#220,#0,#124,#198,#198,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#102,#102,#102,#102,#102,#102,#124,#96,#96,#192,#0,
#0,#0,#224,#96,#96,#124,#102,#102,#102,#102,#102,#124,#96,#96,#240,#0,
#0,#0,#240,#96,#124,#102,#102,#102,#102,#124,#96,#240,#0,#0,#0,#0,
#24,#48,#0,#198,#198,#198,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#56,#108,#0,#198,#198,#198,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#48,#24,#0,#198,#198,#198,#198,#198,#198,#198,#198,#124,#0,#0,#0,#0,
#0,#12,#24,#48,#0,#198,#198,#198,#198,#198,#198,#126,#6,#12,#248,#0,
#12,#24,#0,#102,#102,#102,#102,#60,#24,#24,#24,#60,#0,#0,#0,#0,
#0,#255,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#12,#24,#48,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#254,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#24,#24,#126,#24,#24,#0,#0,#126,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#255,#0,#255,#0,
#0,#224,#48,#98,#54,#236,#24,#48,#102,#206,#154,#63,#6,#6,#0,#0,
#0,#0,#127,#219,#219,#219,#123,#27,#27,#27,#27,#27,#0,#0,#0,#0,
#0,#124,#198,#96,#56,#108,#198,#198,#108,#56,#12,#198,#124,#0,#0,#0,
#0,#0,#0,#0,#0,#24,#0,#126,#0,#24,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#24,#12,#120,#0,#0,
#0,#56,#108,#108,#56,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#198,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#24,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#24,#56,#24,#24,#24,#60,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#124,#6,#60,#6,#6,#124,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#60,#102,#12,#24,#50,#126,#0,#0,#0,#0,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#126,#126,#126,#126,#126,#126,#126,#0,#0,#0,#0,#0,
#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0);
var
 r : registers;
begin
 r.ah:=$11;
 r.al:=$10;
 r.bl:=16;
 r.bh:=16;
 r.cx:=256;
 r.dx:=0;
 r.es:=seg(tabel[1]);
 r.bp:=ofs(tabel[1]);
 intr($10,r);
end;
(***************************************************************************
 DEFINE DE UMA Sà VEZ OS HINTS DE UM MENU
(***************************************************************************)
Procedure SetHint(LongHint : string);
var
 i : byte;
 j : byte;
begin
   Limpa_hints;
   j:=1;
   for i:=1 to length(LongHint) do
   begin
      if longHint[i]<>'@' then
      Hints[j]:=Hints[j]+LongHint[i];
      if LongHint[i]='@' then j:=j+1;
   end;
end;
(***************************************************************************
Fast most by Rudolfo
(***************************************************************************)
procedure most(x,y,c,f:byte;st:string);
var
 i : byte;
begin
	for i:=1 to byte(addr(st[0])^) do
    	begin
         	mem[$b800:((x-1)*2)+((y-1)*160)+(i-1)*2]:=byte(addr(st[i])^);
		mem[$b800:((x-1)*2)+((y-1)*160)+(i-1)*2+1]:=f*16+c;
	end;
end;
(***************************************************************************
NOVO DELAY - ESPERA TEMPO MILISEGUNDOS
(***************************************************************************)
Procedure Gdelay(tempo : integer);
var
  h1,m1,s1,c1 : word;
  h2,m2,s2,c2 : word;
begin
   gettime(h1,m1,s1,c1);
   repeat
       gettime(h2,m2,s2,c2);
   until (s2*1000+c2)-(s1*1000+c1)>=tempo;
end;
(***************************************************************************)
Procedure imprima(frase : string);
begin
    writeln(lst,frase);
end;
(***************************************************************************)
procedure preencha(c1,c2 : byte; st : char);
var
 i,j : byte;
begin
   textbackground(c2);
   if c2>7 then
   textcolor(c1+16)
   else
   textcolor(c1);
   clrscr;
   for i:=1 to 80 do
   for j:=25 downto 1 do
   begin
       gotoxy(i,j);
        write(st);
   end;
end;
(***************************************************************************)
begin
end.
