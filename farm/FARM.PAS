(**************************************************************************
 Personal Farm
 Software Avan‡ado de Controle de Farmacias
 Guinther de Bitencourt Pauli - Todos os direitos reservados
 guinther@unifra.br - guinther@clubedelphi.com.br
 Participacacao : rudolfo@cpd.ufsm.br
***************************************************************************)
{$M 16384,8192,124360}
{$F+,L+,N+}
(**************************************************************************)
Program Farm;
(**************************************************************************)
uses report,moviment,especial,cadastro,kcrt,dos,crt,welc,grp;
(**************************************************************************)
const
    Max_mem = 10;
	 esquerda = 4;
	 direita = 6;
	 esc = 1;
	 Alt_C = 46;
	 Alt_M = 50;
	 Alt_R = 19;
  	 Alt_I = 23;
	 Alt_E = 18;
	 Alt_A = 30;
    ScF2  = 60;
    ScF3  = 61;
    ScF4  = 62;
    ScF5  = 63;
    ScAltx = 45;
    Cadastros = 1;
    Movimentos = 2;
    Relatorios = 3;
    Informacoes = 4;
    Especiais = 5;
    Ajuda = 6;
(**************************************************************************)
(* todo o caminho dessas teclas de Alt*)
(* var da inkey, proc. inkey, role, aqui *)
(**************************************************************************)
var
	 sel_cadastro,sel_movimentos,sel_relatorios,
	 sel_informacoes,sel_especiais,sel_ajuda,
	 Ret_Sel : byte;
    Coluna : byte;
(**************************************************************************
 FAZ O MENU SUSPENSO
**************************************************************************)
procedure menu_aereo;
begin
	  most(1,2,0,15,' Cadastros  Movimentos   Relat¢rios   Informa‡äes   Especiais   Ajuda           ');
	  textcolor(28); textbackground(15);
	  wri(2,2,'C');  wri(13,2,'M'); wri(26,2,'R');
	  wri(39,2,'I'); wri(53,2,'E'); wri(65,2,'A');
end;
(**************************************************************************
 INICIALIZA AMBIENTE DO FARM - FONTES,BLINKS,DESKTOP,VARIAVEIS DE CORES
 **************************************************************************)
procedure inicializa;
var
  arq : file;
  i_tela : byte;
  x_date : byte;
  r : registers;
begin
     r.ah:=$01;
     r.bl:=$01;
     intr($33,r);

     textmode(80);
     { delay(500);}
	  getscreentype;
     cls;
     load; (*carrega cores*)
	  sel_cadastro:=1;
     sel_movimentos:=1;
     sel_relatorios:=1;
	  sel_informacoes:=1;
     sel_especiais:=1;
     sel_ajuda:=1;
	  gotoxy(1,3);
	  if fdesk>7 then textcolor(cdesk+16)
		else textcolor(cdesk);
	  textbackground(fdesk);
	  for i_tela:=1 to 252 do
      write('¨ª«¬¥¦§');
     {  write('        '); }
 	  (*Isso abaixo Faz parte do menu a‚reo*)
	  most(1,1,15,9,'ÉÊ   Personal Farm  í Operador : Guinther                                        ');
     x_date:=80-length(Date);
	  most(x_date,1,15,9,date);
	  most(4,1,12,9,'ø');
	  menu_aereo;
end;
(**************************************************************************
 FINALIZA O FARM LIBERANDO AS CORES E FONTES
**************************************************************************)
procedure finaliza;
begin
	  cores($70);
	  clrscr;
	  blink_on;
	  on;
     carrega_normfonte;
	  halt(0);
end;
(**************************************************************************
 APAGA O MENU SUSPENSO PARA DEPOIS SER REPOSTO COM OUTAR SELECAO
**************************************************************************)
procedure apaga_o_menu;
var
  i_tela : byte;
begin
	  gotoxy(1,3);
	 if fdesk>7 then textcolor(cdesk+16)
		else textcolor(cdesk);
	  textbackground(fdesk);
	  for  i_tela:=1 to 150 do
	 write('¨ª«¬¥¦§');
{    write('        ');}
	  menu_aereo;
end;
(**************************************************************************
 RETORNA VERDADEIRO SE ALGUMA TECLA VALIDA FOI APERTADA
 VERIFICA TBEM SHORTCUTS
***************************************************************************)
Function ver_teclas : boolean;
begin
	 Ver_teclas:=Ret_Sel in [Alt_C,Alt_M,Alt_R,
								Alt_I,Alt_E,Alt_A,
								esc,esquerda,direita];
	 (*para nao piscar os menus*)
	 if ((Ret_Sel=Alt_C) and (Coluna=Cadastros)) or
       ((Ret_Sel=Alt_M) and (Coluna=Movimentos)) or
       ((Ret_Sel=Alt_R) and (Coluna=Relatorios)) or
       ((Ret_Sel=Alt_I) and (Coluna=Informacoes)) or
		 ((Ret_Sel=Alt_E) and (Coluna=Especiais)) or
       ((Ret_Sel=Alt_A) and (Coluna=Ajuda)) then
			Ver_teclas:=false;
    (*SHORTCUTS*)
    if ret_sel=ScF2 then caixa(1); {shortcut para caixa de clientes}
    if ret_sel=ScF3 then caixa(2); {shortcut para caixa de clientes}
    if ret_sel=ScF5 then saidas;
   if ret_sel=ScAltX then
      if ok then Finaliza; {ESC p/ Sair}
end;
(**************************************************************************
 MENU DE CADASTROS
***************************************************************************)
procedure menu_cadastros;
begin
     most(2,2,15,4,'Cadastros');
	{ most(1,2,12,4,'C');}
	  menu(2,3,18,13,cmenu,fmenu,'');
	  item(3,4,'&Clientes     <F2>');
	  item(3,5,'&Medicamentos <F3>');
	  item(3,6,'&Fornecedores');
	  item(3,7,'Con&vˆnios');
	  item(3,8,'&Operadores');
	  item(3,9,'&Grupos');
	  item(3,10,'M‚&dicos');
{	  item(3,11,'C&idades'); }
	  item(3,11,'ÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚ');
	  item(3,12,'&Sair      <Alt+X>');
	  status('Escolha op‡Æo');
	  repeat
         SetHint('Cadastro de Clientes@Cadastro de Medicamentos'+
                 '@Cadastro de Fornecedores@Cadastro de Convˆnios@Cadastro de Operadores'+
                 '@Cadastro de Grupos@Cadastro de M‚dicos@@Sair do Programa');
        role(3,4,17,12,cbarra,fbarra,cmenu,fmenu,sel_cadastro,Ret_Sel);
		  if (Ret_Sel=0) and
           (sel_cadastro in [1..7]) then
   			  caixa(sel_cadastro);
 	  until (ver_teclas) or (sel_cadastro=9);
end;
(**************************************************************************
 MENU MOVIMENTOS
***************************************************************************)
Procedure submenu_contas;
var
 ret,sel : byte;
begin
   (*Hints*)
    salva_tela(2);
    menu(34,5,45,9,cmenu,fmenu,'');
    item(36,6,'&Prazo');
    item(36,7,'&Cheques');
    item(36,8,'Con&vˆnios');
    sel:=1;
    repeat
         SetHint('');
         role(36,6,44,8,cbarra,fbarra,cmenu,fmenu,sel,Ret);
         if ret=0 then conta(sel);
    until ret=1; (*ESC*)
    volta_tela(2,false);
end;

procedure menu_movimentos;
begin
     Limpa_Hints;
	  most(13,2,15,4,'Movimentos');
	 { most(13,2,12,4,'M');}
	  menu(13,3,32,8,cmenu,fmenu,'');
	  item(15,4,'&Sa¡das         <F5>');
	  item(15,5,'&Entradas');
	  item(15,6,'&Contas          '#16);
	  item(15,7,'&Terminal Cliente');
	  status('Escolha op‡Æo');
	  repeat
       SetHint('Digitar Sa¡da (Venda)@Digitar Entrada (Compra)'+
       '@Movimento de Contas@Acionar terminal Cliente');
		 role(14,4,31,7,cbarra,fbarra,cmenu,fmenu,sel_movimentos,Ret_Sel);
       if Ret_Sel=0 then
       begin
         if sel_movimentos=1 then saidas;
         if sel_movimentos=2 then entradas;
         if sel_movimentos=3 then subMenu_contas;
         if sel_movimentos=4 then terminal_cliente;
       end;
 	  until ver_teclas;
end;

(**************************************************************************
 MENU RELATORIOS
**************************************************************************)
procedure menu_relatorios;

Procedure submenu_listagens;
var
 ret,sel : byte;
begin
   (*Hints*)
    salva_tela(2);
    menu(45,6,65,10,cmenu,fmenu,'');
    item(47,7,'&Clientes');
    item(47,8,'&Medicamentos');
    item(47,9,'&Fornecedores');
    sel:=1;
    repeat
         SetHint('');
         role(47,7,64,9,cbarra,fbarra,cmenu,fmenu,sel,Ret);
         if ret=0 then
         case sel of
         1 : listagem(rlClientes);
         2 : listagem(rlMedicamentos);
         3 : listagem(rlFornecedores);
         end;
    until ret=1; (*ESC*)
    volta_tela(2,false);
end;

Procedure submenu_cartas;
var
 ret,sel : byte;
begin
   (*Hints*)
    salva_tela(2);
    menu(45,6,67,12,cmenu,fmenu,'');
    item(47,7,'&Atraso de Pagamento');
    item(47,8,'&Cheque sem fundo');
    item(47,9,'C&ongratulacoes');
    item(47,10,'Co&mparecimento');
    item(47,11,'&Ordens');
    sel:=1;
    repeat
         SetHint('');
         role(47,7,66,11,cbarra,fbarra,cmenu,fmenu,sel,Ret);
         if ret=0 then
         carta(sel);
    until ret=1; (*ESC*)
    volta_tela(2,false);
end;


Procedure submenu_etiquetas;
var
 ret,sel : byte;
begin
   (*Hints*)
    salva_tela(2);
    menu(45,5,65,9,cmenu,fmenu,'');
    item(47,6,'&Clientes');
    item(47,7,'&Medicamentos');
    item(47,8,'&Fornecedores');
    sel:=1;
    repeat
         SetHint('');
         role(47,6,64,8,cbarra,fbarra,cmenu,fmenu,sel,Ret);
         if ret=0 then
          case sel of
          1 : etiquetas(rlClientes);
          2 : etiquetas(rlMedicamentos);
          3 : etiquetas(rlFornecedores);
         end;
    until ret=1; (*ESC*)
    volta_tela(2,false);
end;

begin
     Limpa_Hints;
	  most(26,2,15,4,'Relat¢rios');
	  {most(26,2,12,4,'R');}
	  menu(26,3,43,8,cmenu,fmenu,'');
	  item(27,4,'&Listagens      '#16);
     item(27,5,'&Etiquetas      '#16);
	  item(27,6,'&Cartas         '#16);
	  item(27,7,'&Recibos');
	  status('Escolha op‡Æo');
	  repeat
		 role(27,4,42,7,cbarra,fbarra,cmenu,fmenu,sel_relatorios,Ret_Sel);
           if (ret_sel=0) then
           begin
            if sel_relatorios=1 then submenu_listagens;
            if sel_relatorios=2 then submenu_etiquetas;
            if sel_relatorios=3 then submenu_cartas;
            if sel_relatorios=4 then recibo;
            if sel_relatorios=5 then relat_saidas;
            if sel_relatorios=6 then relat_entradas;
          end;
	  until ver_teclas;
end;
(***************************************************************************
 MENU DE INFORMACOES
(**************************************************************************)
procedure menu_informacoes;
begin
    Limpa_Hints;
	  most(39,2,15,4,'Informa‡äes');
	 { most(39,2,12,4,'I');}
	  menu(39,3,54,5,cmenu,fmenu,'');
	  item(40,4,'&Gr ficos');
	  status('Escolha op‡Æo');
	  repeat
{      sel_informacoes:=1; }
		role(40,4,53,4,cbarra,fbarra,cmenu,fmenu,sel_informacoes,Ret_Sel);
      if ret_sel=0 then
       case sel_informacoes of
       1 : begin salva_tela(3); demogrp;
          inicializa; sel_informacoes:=1;  volta_tela(3,false);end;
       end;
	  until ver_teclas;
end;
(**************************************************************************
 MENU DE FUNCOES ESPECIAIS
**************************************************************************)
Procedure menu_especiais;
{Submenu configura‡äes}
Procedure submenu_configuracoes;
var
 ret_sel_cores,sel_esp_cores : byte;
begin
   (*Hints*)
    salva_tela(2);
    menu(29,5,50,12,cmenu,fmenu,'');
    item(31,6,'&Cores');
    item(31,7,'&Fontes');
    item(31,8,'&Sons');
    item(31,9,'&Data e Hora');
    item(31,10,'&Impressoras');
    item(31,11,'&Rede');
    sel_esp_cores:=1;
    repeat
         SetHint('Configura as cores do programa'+
         '@Configura as fontes (tipo de letra) do programa@Configura sons'+
         '@Configura Data e Hora do Sistema@Configura a Impressora@Configura a rede');
         role(30,6,49,11,cbarra,fbarra,cmenu,fmenu,sel_esp_cores,Ret_Sel_cores);
        if (sel_esp_cores=1) and (ret_sel_cores=0) then menu_cores;
        if (sel_esp_cores=2) and (ret_sel_cores=0) then menu_fontes;
    until ret_sel_cores=1; (*ESC*)
    volta_tela(2,false);
end;

begin
     most(53,2,15,4,'Especiais');
	  {most(53,2,12,4,'E');}
	  menu(53,3,69,5,cmenu,fmenu,'');
	  item(54,4,'&Configura‡äes '+#16);
	  status('Escolha op‡Æo');
	  repeat
           Limpa_Hints;
           Hints[1]:='Configura cor, fonte, sons, data e hora, impressora e rede';
			  role(54,4,68,4,cbarra,fbarra,cmenu,fmenu,sel_especiais,Ret_Sel);
			  if (sel_especiais=1) and (Ret_Sel=0) then submenu_configuracoes;
	  until ver_teclas;
end;
(**************************************************************************
 MENU AJUDA
**************************************************************************)
procedure menu_ajuda;
begin
     Limpa_Hints;
     Hints[1]:='Sobre o programa';
     most(65,2,15,4,'Ajuda');
	  {most(65,2,12,4,'A');}
	  menu(65,3,78,5,cmenu,fmenu,'');
	  item(66,4,'&Sobre...');
	  status('Escolha op‡Æo');
	  repeat
			  role(66,4,77,4,cbarra,fbarra,cmenu,fmenu,sel_ajuda,Ret_Sel);
           if (ret_sel=0) and (sel_ajuda=1) then
           begin
            salva_tela(3);
            menu(15,5,65,15,cmenu,fmenu,'Personal Farm');
           square(17,7,cmenu,fmenu,'Sistema de Controle de Farm cias@'+
           ' @Guinther de Bitencourt Pauli'+'@ @Farm cia Pauli - Sta Cruz - RS');
            pesc;
            volta_tela(3,false);
           end;

	  until ver_teclas;
end;
(**************************************************************************
 CHAMADO PARA CALCULAR NOVA COLUNA
**************************************************************************)
Procedure veja_Coluna; {chamado pelo leit para ver qual cadastro ‚ selecionado}
begin
	  if Ret_Sel=esquerda then Coluna:=Coluna-1; {esquerda}
	  if Ret_Sel=direita then Coluna:=Coluna+1; {direita}
	  if Ret_Sel=Alt_C then Coluna:=Cadastros;
	  if Ret_Sel=Alt_M then Coluna:=Movimentos;
	  if Ret_Sel=Alt_R then Coluna:=Relatorios;
	  if Ret_Sel=Alt_I then Coluna:=Informacoes;
	  if Ret_Sel=Alt_E then Coluna:=Especiais;
	  if Ret_Sel=Alt_A then Coluna:=Ajuda;
	  if Coluna=7 then Coluna:=Cadastros; {volta para esquerda}
	  if Coluna=0 then Coluna:=Ajuda; {volta para direita}
end;
(**************************************************************************)
procedure leit;
begin
	  Coluna:=Cadastros;
	  repeat
	    repeat
			   case Coluna of
			   Cadastros  : menu_cadastros;
			   Movimentos : menu_movimentos;
			   Relatorios : menu_relatorios;
			   Informacoes: menu_informacoes;
			   Especiais  : menu_especiais;
			   Ajuda      : menu_ajuda;
			  end;
			  veja_Coluna;
       	  apaga_o_menu;
	    until (Ret_Sel=esc) or ((sel_cadastro=9) and (Ret_Sel=0));
	  until ok;
end;
(**************************************************************************)
procedure senha;
var
 st1 : string;
 sob : byte;
begin
   salva_tela(3);
   status('Digite nome e senha');
   menu(20,10,60,16,cmenu,fmenu,'Senha');
   square(22,12,cmenu,fmenu,'Operador : @ @Senha :');
   st1:='';
   inputstring(st1,15,15,33,12,'T',sob);
   st1:='';
   inputstring(st1,15,15,30,14,'T',sob);
   volta_tela(3,false);
end;
(**************************************************************************)
begin
     welcome;
	  inicializa;
     senha;
	  leit;
	  finaliza;
end.

(* Ret_Sel = Variavel de retorno do barra de rolagem. Vale
	 0 : normal (enter)
	 1 : se apertei ESC
	 6 : se apertei para direita
	 4 : se apertei para esquerda

   Coluna = Variavel do menu suspenso

  Sel(1..9) = Var da barra de rolagem e representa a linha em
	 que deve estar a sele‡Æo

-> Regra geral - Depois de usar inkey em um procedimento que
	s¢ precise de vari vel dentro dele, isto ‚, quem chamou nÆo
	precisa saber que tecla pertou, zerar key com Key:=NullKey