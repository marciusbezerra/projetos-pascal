(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
(***********************************************************************)
unit saver;
(***********************************************************************)
interface
(***********************************************************************)
uses crt;
(***********************************************************************)
procedure screen_saver1(mensagem : string);
procedure screen_saver2(mensagem : string);
(***********************************************************************)
implementation
(***********************************************************************)
procedure screen_saver1(mensagem : string);

type
	 let = record
		st : array [1..5] of string[6];
		end;
var
	letras : array [1..32] of let;
	a,b,c,k,l : integer;
	frase : array [1..1900,1..5] of char;
	st1 : string;
	ch1,ch2 : char;
begin
	 for a:=1 to 1900 do
	  for b:=1 to 5 do
	frase[a,b]:=' ';
	textcolor(15);
	textbackground(0);

	  clrscr;
	  with letras[1] do
	  begin
			 st[1]:='ллллл ';
			 st[2]:='л   л ';
			 st[3]:='ллллл ';
			 st[4]:='л   л ';
			 st[5]:='л   л ';

	  end;
	  with letras[2] do
	  begin
			 st[1]:='лллл  ';
			 st[2]:='л   л ';
			 st[3]:='ллллл ';
			 st[4]:='л   л ';
			 st[5]:='лллл  ';
	  end;
	  with letras[3] do
	  begin
			 st[1]:='ллллл ';
			 st[2]:='л     ';
			 st[3]:='л     ';
			 st[4]:='л     ';
			 st[5]:='ллллл ';
	  end;
	  with letras[4] do
	  begin
			 st[1]:='лллл  ';
			 st[2]:='л   л ';
			 st[3]:='л   л ';
			 st[4]:='л   л ';
			 st[5]:='лллл  ';
	  end;
	  with letras[5] do
	  begin
			 st[1]:='ллллл ';
			 st[2]:='л     ';
			 st[3]:='лллл  ';
			 st[4]:='л     ';
			 st[5]:='ллллл ';
	  end;
	  with letras[6] do
	  begin
			 st[1]:='ллллл ';
			 st[2]:='л     ';
			 st[3]:='лллл  ';
			 st[4]:='л     ';
			 st[5]:='л     ';
	  end;
	  with letras[7] do
	  begin
			 st[1]:='ллллл ';
			 st[2]:='л     ';
			 st[3]:='л  лл ';
			 st[4]:='л   л ';
			 st[5]:='ллллл ';
	  end;
	  with letras[8] do
	  begin
			 st[1]:='л   л ';
			 st[2]:='л   л ';
			 st[3]:='ллллл ';
			 st[4]:='л   л ';
			 st[5]:='л   л ';
	  end;
	  with letras[9] do
	  begin
			 st[1]:='  ллл ';
			 st[2]:='   л  ';
			 st[3]:='   л  ';
			 st[4]:='   л  ';
			 st[5]:='  ллл ';
	  end;
	  with letras[10] do
	  begin
			 st[1]:='    л ';
			 st[2]:='    л ';
			 st[3]:='    л ';
			 st[4]:='л   л ';
			 st[5]:='ллллл ';
	  end;
	  with letras[11] do
	  begin
			 st[1]:='л  л  ';
			 st[2]:='л л   ';
			 st[3]:='лл    ';
			 st[4]:='л л   ';
			 st[5]:='л  л  ';
	  end;
	  with letras[12] do
	  begin
			 st[1]:='л     ';
			 st[2]:='л     ';
			 st[3]:='л     ';
			 st[4]:='л     ';
			 st[5]:='ллллл ';
	  end;
	  with letras[13] do
	  begin
			 st[1]:='л   л ';
			 st[2]:='лл лл ';
			 st[3]:='л л л ';
			 st[4]:='л   л ';
			 st[5]:='л   л ';
	  end;
	  with letras[14] do
	  begin
			 st[1]:='л   л ';
			 st[2]:='лл  л ';
			 st[3]:='л л л ';
			 st[4]:='л  лл ';
			 st[5]:='л   л ';
	  end;
	  with letras[15] do
	  begin
			 st[1]:='ллллл ';
			 st[2]:='л   л ';
			 st[3]:='л   л ';
			 st[4]:='л   л ';
			 st[5]:='ллллл ';
	  end;
	  with letras[16] do
	  begin
			 st[1]:='ллллл ';
			 st[2]:='л   л ';
			 st[3]:='ллллл ';
			 st[4]:='л     ';
			 st[5]:='л     ';
	  end;
	  with letras[17] do
	  begin
			 st[1]:='лллл  ';
			 st[2]:='л  л  ';
			 st[3]:='л  л  ';
			 st[4]:='л  л  ';
			 st[5]:='ллллл ';
	  end;
	  with letras[18] do
	  begin
			 st[1]:='лллл  ';
			 st[2]:='л   л ';
			 st[3]:='лллл  ';
			 st[4]:='л л   ';
			 st[5]:='л  л  ';
	  end;
	  with letras[19] do
	  begin
			 st[1]:='ллллл ';
			 st[2]:='л     ';
			 st[3]:='ллллл ';
			 st[4]:='    л ';
			 st[5]:='ллллл ';
	  end;
	  with letras[20] do
	  begin
			 st[1]:='  ллл ';
			 st[2]:='   л  ';
			 st[3]:='   л  ';
			 st[4]:='   л  ';
			 st[5]:='   л  ';
	  end;
	  with letras[21] do
	  begin
			 st[1]:='л   л ';
			 st[2]:='л   л ';
			 st[3]:='л   л ';
			 st[4]:='л   л ';
			 st[5]:='ллллл ';
	  end;
	  with letras[22] do
	  begin
			 st[1]:='л   л ';
			 st[2]:='л   л ';
			 st[3]:=' л л  ';
			 st[4]:=' л л  ';
			 st[5]:='  л   ';
	  end;
	  with letras[23] do
	  begin
			 st[1]:='л   л ';
			 st[2]:='л   л ';
			 st[3]:='л л л ';
			 st[4]:='лл лл ';
			 st[5]:='л   л ';
	  end;
	  with letras[24] do
	  begin
			 st[1]:='л   л ';
			 st[2]:=' л л  ';
			 st[3]:='  л   ';
			 st[4]:=' л л  ';
			 st[5]:='л   л ';
	  end;
	  with letras[25] do
	  begin
			 st[1]:='л   л ';
			 st[2]:=' л л  ';
			 st[3]:='  л   ';
			 st[4]:='  л   ';
			 st[5]:='  л   ';
	  end;

		with letras[26] do
	  begin
			 st[1]:='лллл  ';
			 st[2]:='   л  ';
			 st[3]:='  л   ';
			 st[4]:=' л    ';
			 st[5]:='лллл  ';
	  end;
	  with letras[27] do
	  begin
			 st[1]:='      ';
			 st[2]:='      ';
			 st[3]:='      ';
			 st[4]:='      ';
			 st[5]:='      ';
	  end;
	  st1:=mensagem;
	  for a:=0 to length(st1)-1 do
		  for c:=1 to 5 do
				for b:=1 to 6 do
				frase[a*6+b+80,c]:=letras[ord(st1[a+1])-64].st[c][b];
	  repeat
			for c:=1 to 5 do
				frase[length(st1)*7+80,c]:=frase[1,c];
			 for a:=1 to length(st1)*7+80 do
				for c:=1 to 5 do
					frase[a,c]:=frase[a+1,c];
				(*mostra_frase*)
				textcolor(15);
				textbackground(0);

				for a:=1 to 80 do
				begin
					  for b:=1 to 5 do
					  begin
						  gotoxy(a,b+8);
						  write(frase[a,b]);
					  end;
				end;
				textcolor(0);
				textbackground(0);
				{gdelay(1);}
	  until keypressed;
	  ch2:=#0;
	  ch1:=readkey;
	  if ch1=#0 then
		ch2:=readkey;
end;
(***********************************************************************)
procedure screen_saver2(mensagem : string);
var
x,y,a,b : integer;
ch1,ch2 : char;
begin
	  textbackground(0);
	  clrscr;
	  x:=1;
	  y:=1;
	  a:=1;
	  b:=1;


  repeat
				gotoxy(x,y);
				textcolor(31);
				textbackground(9);
                                write(MENSAGEM);
				{Gdelay(150);}
				gotoxy(x,y);
				textcolor(15);
				textbackground(0);
				write('                 ');
				x:=x+a;
				y:=y+b;
				if x=60 then a:=-1;
				if y=25 then b:=-1;
				if x=1 then a:=1;
				if y=1 then b:=1;
	 until keypressed;
		  ch2:=#0;
	  ch1:=readkey;
	  if ch1=#0 then
		ch2:=readkey;
end;
(***********************************************************************)
begin
end.
