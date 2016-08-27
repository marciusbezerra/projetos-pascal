(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
***********************************************************************)
unit especial;
(***********************************************************************)
interface
(***********************************************************************)
uses fontes,crt,kcrt,dos;
(***********************************************************************)
Procedure menu_cores;
Procedure menu_fontes;
(***********************************************************************)
implementation
(***********************************************************************)
Procedure faz_modelo;
begin
		(*janela*)
		menu(43,6,64,13,cmenu,fmenu,'T﹀ulo');
		(*item*)
		textcolor(cmenu);
		textbackground(fmenu);
		item(46,8,'&Menu');
		item(46,9,'M&enu');
		(*barra de rolagem*)
		most(46,10,cbarra,fbarra,'Barra');
		most(44,12,Cstatus,fstatus,'Status             ');
		(*desktop*)
		most(44,17,cdesk,fdesk,'它夾帚型 它夾帚型');
		(*erro*)
		menu(43,19,64,21,cerro,ferro,'');
		most(45,20,cerro,ferro,'Mensagem de erro');
end;
(***********************************************************************)
Procedure setinha(lin : byte);
var
caracter    : char;
functionkey : boolean;
y : byte;
begin

	  case lin of
	  1 : y:=cmenu;
	  2 : y:=fmenu;
	  3 : y:=cbarra;
	  4 : y:=fbarra;
	  5 : y:=cdestaque;
	  6 : y:=cstatus;
	  7 : y:=fstatus;
	  8 : y:=ctitulo;
	  9 : y:=ftitulo;
	  10 : y:=cerro;
	  11 : y:=ferro;
	  12 : y:=cdesk;
	  13 : y:=fdesk;
	  end;
	 repeat
			  faz_modelo;
			  (*seleciona*)
			  gotoxy(36,y+6);
			  cores($f7);
			  write(Getchar);
			  inkey(functionkey,caracter);
			  (*apaga*)
			  gotoxy(36,y+6);
			  cores($77);
			  write(Getchar);
			  if (key=downarrow) and (y+6<21) then y:=y+1;
			  if (key=uparrow) and (y+6>6) then y:=y-1;
				case lin of
				1 : cmenu:=y;
				2 : fmenu:=y;
				3 : cbarra:=y;
				4 : fbarra:=y;
				5 : cdestaque:=y;
				6 : cstatus:=y;
				7 : fstatus:=y;
				8:  ctitulo:=y;
				9 : ftitulo:=y;
				10 : cerro:=y;
				11 : ferro:=y;
				12 : cdesk:=y;
				13 : fdesk:=y;
				end;
	until (key=esc) or (key=enter);
end;
(***********************************************************************)
Procedure menu_cores;
var
	x,y : byte;
	selc,retc,selb,retb : byte;
	regs:registers;
	i:integer;
begin
	  salva_tela(13);
	  menu(10,4,68,23,0,7,'Cores do Sistema');
	  square(12,6,15,7,'Frente do Menu@Fundo do Menu@Frente da Barra'+
				'@Fundo da Barra@Frente Destacada@Frente da StatusBar'+
				'@Fundo da Status Bar@Frente do t﹀ulo@Fundo do t﹀ulo'+
				'@Frente do erro@Janela de erro@Frente Area Trab@Fundo Area Trab');
	  for y:=6 to 21 do
	  begin
			 textcolor(y-6);
			 gotoxy(38,y);
			 write('詗');
	  end;

	 textcolor(7);
	 textbackground(7);
	 for y:=6 to 21 do
	 begin
		 gotoxy(36,y);
		 write(#26);
	 end;
	  selb:=1;
	  selc:=1;
	  faz_modelo;
     sethint('');
     status('Selecione item e pressione Enter p/ mudar sua cor');
	  repeat
			 role(12,6,30,18,31,16,15,7,selb,retb);
			 if retb<>1 then
			 setinha(selb);
	  until (retb=1);
	  if ok then
	  begin
	     save;
	     cls;
        textcolor(11);
		  writeln('Digite FARM para retornar ao Personal Farm vs Beta...');
        on;
        halt(0);
	  end
	  else
	  load;
	  volta_tela(13,false);
end;
(***********************************************************************
 FONTES GERADAS PARA DOS - RUDOLFO
(***********************************************************************)
Procedure menu_fontes;
var
ret_font,sel_font : byte;
begin
    salva_tela(14);
    menu(23,5,44,21,cmenu,fmenu,'Fontes');
    square(25,7,cmenu,fmenu,'Normal@Currier New@Comic@Future@Galla@Script@Funny@Elegant@Times New Roman@Arial@Tahoma'+
    '@Italic@Impact@Segs');
    setHint('');
    status('Escolha sua fonte e aperte <ENTER> para aceitar,覷 Sai ');
    sel_font:=1;
    repeat
      role(24,7,43,20,cbarra,fbarra,cmenu,fmenu,sel_font,ret_font);
     if ret_font=0 then
      (*PARA CHAMAR FONTE SELECIONADA*)
      case sel_font of
       1 : begin Tfont_normal;  font:=1; end;
       2 : begin Tfont_currier; font:=2; end;
       3 : begin Tfont_comic;   font:=3; end;
       4 : begin Tfont_future;  font:=4; end;
       5 : begin Tfont_galla;   font:=5; end;
       6 : begin Tfont_script;  font:=6; end;
       7 : begin Tfont_funny;   font:=7; end;
       8 : begin Tfont_elegant; font:=8; end;
       9 : begin Tfont_times;   font:=9; end;
      10 : begin Tfont_arial;   font:=10; end;
      11 : begin Tfont_tahoma;  font:=11; end;
      12 : begin Tfont_Italic;  font:=12; end;
      13 : begin Tfont_impact;  font:=13; end;
      14 : begin Tfont_segs;  font:=14; end;
      end;
    until ret_font=1; (*ESC*)
    (*PARA GRAVAR NO ARQUIVO FARM.DSK*)
    save;
    volta_tela(14,false);
end;
(***********************************************************************)
(***********************************************************************)
(***********************************************************************)
begin
end.