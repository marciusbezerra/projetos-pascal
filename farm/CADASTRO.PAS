(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
***********************************************************************)
unit Cadastro;
(***********************************************************************)
interface
(***********************************************************************)
uses crt;
(***********************************************************************)
const
	  Caixa_de_clientes = 1;
     Caixa_de_remedios = 2;
     Caixa_de_fornecs = 3;
     Caixa_de_Medicos = 7;
     Caixa_de_Operads = 5;
     Caixa_de_Conv = 4;
     Caixa_de_Grupos = 6;
     notValidCod = 32767;
(***********************************************************************)
Function caixa(const tipo_de_caixa : byte) : integer;
Function le_codigo (const x,y,Tipo_de_Caixa : byte) : integer;
(***********************************************************************)
implementation
(***********************************************************************)
uses
	 kcrt,clientes,remedios,fornecs,operads,medicos,conv,grupos;
(***********************************************************************)
const
     maximo = 500; (*MAXIMO DE REGISTROS SUPORTADOS*)
     char_max = 10;
	  Classifica_Por_Codigo = 1;
	  Classifica_Por_Nome = 2;
	  Classifica_Por_Sobrenome = 3;
(***********************************************************************)
type
	 TTabela = record
		cod  : integer;
		nome : string[char_max];
	 end;
var
   tabela : array [0..maximo] of TTabela;
	contador,num_reg,num_reg_ativos : integer;
	st6          : string[28];
	tipo_de_classificacao,lin_atual : byte;
	range1,range2 : string; (*da caixa, para fazer SQL por range*)
	filtro : string;       (*da caixa, para fazer filtro por nome*)
(***********************************************************************)
(* Help da caixa
(***********************************************************************)
procedure help;
const
  cmenuHelp = 15;
  fmenuhelp = 2;
begin
	  salva_tela(15);
	  status('Estas sÆo as teclas que podem ser usadas na caixa de registros');
	  menu(20,4,65,23,15,2,'Ajuda da Caixa de registros');
	  most(22,5,cmenuHelp,fmenuhelp,'” Ajuda do Contexto [AltH] Ajuda do menu');
	  most(22,6,cmenuHelp,fmenuhelp,'• Consulta registro selecionado');
	  most(22,7,cmenuHelp,fmenuhelp,'ýþInclui registro');
	  most(22,8,cmenuHelp,fmenuhelp,'ôõExclui registro selecionado');
	  most(22,9,cmenuHelp,fmenuhelp,'– Altera registro selecionado');
	  most(22,10,cmenuHelp,fmenuhelp,'— Imprimi ficha do registro selecionado');
     most(22,11,cmenuHelp,fmenuhelp,'˜ Filtra nomes por letras');
     most(22,12,cmenuHelp,fmenuhelp,'™ Filtra nomes por intervalo de c¢digo');
	  most(22,13,cmenuHelp,fmenuhelp,'š Classifica registros por c¢digo');
	  most(22,14,cmenuHelp,fmenuhelp,'› Classifica registros por nome');
	  most(22,15,cmenuHelp,fmenuhelp,'œ Classifica registros por sobrenome');
	  most(22,16,cmenuHelp,fmenuhelp,'”Data/Hora [ENTER] Aceita c¢digo');
	  most(22,17,cmenuHelp,fmenuhelp,'òóSai  [BkSpace] Reseta caixa de registros');
	  most(22,18,cmenuHelp,fmenuhelp,+#25+' Desce a barra  '+#24+' Sobe a barra');
	  most(22,19,cmenuHelp,fmenuhelp,'[HOME] Vai p/ o in¡cio [END] Vai p/ o final');
	  most(22,20,cmenuHelp,fmenuhelp,'[A..Z] Procura instantƒnea por letras');
	  most(22,21,cmenuHelp,fmenuhelp,'[0..9] Procura inst. por c¢digo');
	  most(22,22,cmenuHelp,fmenuhelp,'[PGUP] Volta p gina [PGDN] Passa p gina');
	  pesc;
	  volta_tela(15,false);
end;
(***********************************************************************)
(* Le dados dos arquivos e carrega na tabela
(***********************************************************************)
Procedure le_dados(tipo_de_caixa : byte);
var
	i:byte;
	rangeint1,rangeint2 : integer;
	h1,s1,m1,c1,
	h2,s2,m2,c2 :  word;
begin
	  status('Lendo Registros. Aguarde...');
	  rangeint1:=strtoint(range1);
	  rangeint2:=strtoint(range2);
	  (*para zerar vetor de ordena‡Æo*)
	  (*e para nÆo dar BUG na hora de trocar de tipo de caixa*)

	  for num_reg:=0 to maximo do
	  begin
			 tabela[num_reg].cod:=0;
			 tabela[num_reg].nome:='';
	  end;

	  num_reg_ativos:=0;
	  case tipo_de_caixa of

	  Caixa_de_clientes  :
	  begin
		  open_Fclientes;
		  seek(Fclientes,0);
		  for num_reg:=0 to num_clientes-1 do
		  begin
			 seek(Fclientes,num_reg);
			 read(Fclientes,Bclientes);
			 if Bclientes.AI='A' then
				if (filtro='') or (pos(maiuscula(filtro),maiuscula(Bclientes.nome))=1) then
				 if (rangeint1=0) or
					 ((Bclientes.codigo>=RangeInt1) and
					 (Bclientes.codigo<=RangeInt2)) then
					 begin
						num_reg_ativos:=num_reg_ativos+1;
						 tabela[num_reg_ativos].cod:=Bclientes.codigo;
						 if tipo_de_classificacao=Classifica_por_Sobrenome then
							sobrenomeie_cli(Bclientes.nome);
						  tabela[num_reg_ativos].nome:=Bclientes.nome;
					end;
			  end;
			 close_Fclientes;
			end;

    Caixa_de_remedios :
	  begin
		  open_Fremedios;
		  seek(Fremedios,0);
		  for num_reg:=0 to num_remedios-1 do
		  begin
			 seek(Fremedios,num_reg);
			 read(Fremedios,Bremedios);
			 if Bremedios.AI='A' then
				if (filtro='') or (pos(maiuscula(filtro),maiuscula(Bremedios.nome))=1) then
				 if (rangeint1=0) or
					 ((Bremedios.codigo>=RangeInt1) and
					 (Bremedios.codigo<=RangeInt2)) then
					 begin
						num_reg_ativos:=num_reg_ativos+1;
						 tabela[num_reg_ativos].cod:=Bremedios.codigo;
						 if tipo_de_classificacao=Classifica_por_Sobrenome then
							sobrenomeie_remed(Bremedios.nome);
						  tabela[num_reg_ativos].nome:=Bremedios.nome;
					end;
			  end;
			 close_Fremedios;
			end;

     Caixa_de_fornecs :
	  begin
		  open_Ffornecs;
		  seek(Ffornecs,0);
		  for num_reg:=0 to num_fornecs-1 do
		  begin
			 seek(Ffornecs,num_reg);
			 read(Ffornecs,Bfornecs);
			 if Bfornecs.AI='A' then
				if (filtro='') or (pos(maiuscula(filtro),maiuscula(Bfornecs.fantasia))=1) then
				 if (rangeint1=0) or
					 ((Bfornecs.codigo>=RangeInt1) and
					 (Bfornecs.codigo<=RangeInt2)) then
					 begin
						num_reg_ativos:=num_reg_ativos+1;
						 tabela[num_reg_ativos].cod:=Bfornecs.codigo;
						 if tipo_de_classificacao=Classifica_por_Sobrenome then
							sobrenomeie_fornec(BFornecs.fantasia);
						  tabela[num_reg_ativos].nome:=BFornecs.fantasia;
					end;
			  end;
			 close_Ffornecs;
			end;

    Caixa_de_operads :
	  begin
		  open_FOperads;
		  seek(FOperads,0);
		  for num_reg:=0 to num_Operads-1 do
		  begin
			 seek(FOperads,num_reg);
			 read(FOperads,BOperads);
			 if BOperads.AI='A' then
				if (filtro='') or (pos(maiuscula(filtro),maiuscula(BOperads.nome))=1) then
				 if (rangeint1=0) or
					 ((BOperads.codigo>=RangeInt1) and
					 (BOperads.codigo<=RangeInt2)) then
					 begin
						num_reg_ativos:=num_reg_ativos+1;
						 tabela[num_reg_ativos].cod:=BOperads.codigo;
						 if tipo_de_classificacao=Classifica_por_Sobrenome then
							sobrenomeie_operad(BOperads.nome);
						  tabela[num_reg_ativos].nome:=BOperads.nome;
					end;
			  end;
			 close_FOperads;
			end;

     Caixa_de_medicos :
	  begin
		  open_Fmedicos;
		  seek(Fmedicos,0);
		  for num_reg:=0 to num_medicos-1 do
		  begin
			 seek(Fmedicos,num_reg);
			 read(Fmedicos,Bmedicos);
			 if Bmedicos.AI='A' then
				if (filtro='') or (pos(maiuscula(filtro),maiuscula(Bmedicos.nome))=1) then
				 if (rangeint1=0) or
					 ((Bmedicos.codigo>=RangeInt1) and
					 (Bmedicos.codigo<=RangeInt2)) then
					 begin
						num_reg_ativos:=num_reg_ativos+1;
						 tabela[num_reg_ativos].cod:=Bmedicos.codigo;
						 if tipo_de_classificacao=Classifica_por_Sobrenome then
							sobrenomeie_medicos(Bmedicos.nome);
						  tabela[num_reg_ativos].nome:=Bmedicos.nome;
					end;
			  end;
			 close_Fmedicos;
			end;


     Caixa_de_Conv :
	  begin
		  open_FConv;
		  seek(FConv,0);
		  for num_reg:=0 to num_Conv-1 do
		  begin
			 seek(FConv,num_reg);
			 read(FConv,BConv);
			 if BConv.AI='A' then
				if (filtro='') or (pos(maiuscula(filtro),maiuscula(BConv.nome))=1) then
				 if (rangeint1=0) or
					 ((BConv.codigo>=RangeInt1) and
					 (BConv.codigo<=RangeInt2)) then
					 begin
						num_reg_ativos:=num_reg_ativos+1;
						 tabela[num_reg_ativos].cod:=BConv.codigo;
						 if tipo_de_classificacao=Classifica_por_Sobrenome then
							sobrenomeie_Conv(BConv.nome);
						  tabela[num_reg_ativos].nome:=BConv.nome;
					end;
			  end;
			 close_FConv;
			end;

     Caixa_de_Grupos :
	  begin
		  open_FGrupos;
		  seek(FGrupos,0);
		  for num_reg:=0 to num_Grupos-1 do
		  begin
			 seek(FGrupos,num_reg);
			 read(FGrupos,BGrupos);
			 if BGrupos.AI='A' then
				if (filtro='') or (pos(maiuscula(filtro),maiuscula(BGrupos.nome))=1) then
				 if (rangeint1=0) or
					 ((BGrupos.codigo>=RangeInt1) and
					 (BGrupos.codigo<=RangeInt2)) then
					 begin
						num_reg_ativos:=num_reg_ativos+1;
						 tabela[num_reg_ativos].cod:=BGrupos.codigo;
						 if tipo_de_classificacao=Classifica_por_Sobrenome then
							sobrenomeie_Grupos(BGrupos.nome);
						  tabela[num_reg_ativos].nome:=BGrupos.nome;
					end;
			  end;
			 close_FGrupos;
			end;


  end; {fim case}
  (*PARA TRANSFORMAR TUDO NA TABELA EM LETRA MAIUSCULA*)
  for num_reg:=0 to Num_reg_ativos do
  begin
		 for i:=1 to length(tabela[num_reg].nome) do
		 tabela[num_reg].nome[i]:=upcase(tabela[num_reg].nome[i]);
  end;
end;
(***********************************************************************)
(* Classifica os dados lidos por le_dados
(***********************************************************************)
Procedure classifica;
var
	gap,i,j,k,x : integer;
begin
	 status('Classificando registros. Aguarde...');
	 gap := num_reg_ativos div 2;
	 while gap>0 do
	 begin
			for i:=(gap+1) to num_reg_ativos do
			begin
				  j:=i-gap;
				  while j>0 do
				  begin
						 k:=j+gap;
						 if tabela[j].nome<=tabela[k].nome then
							 j:=0
						 else
						 begin
								tabela[0]  := tabela[j];
								tabela[j] := tabela[k];
								tabela[k] := tabela[0];
								j:=j-gap;
						 end;
				  end;
			 end;
			 gap:=gap div 2;
			 end;
end;
(***************************************************************************)
(* Mostra 19 nomes e ‚ chamado pela caixa
(***************************************************************************)
procedure mostra20(tipo_de_caixa : byte;pos_atual : integer);
var
	 y : byte;
	 i,t : integer;
	 codigo : integer;
begin
	 y:=4; (*linha inicial do quadro*)
	 t:=pos_atual; (*t vai variar 20 unidades*)
			  (* pos_atual indica o registro atual *)
	 if lin_atual=19 then t:=pos_atual-18;
	 for i:=t to (t+18) do
	 begin
			most(11,y+1,cmenu,fmenu,'                                  ');
			if i<=maximo then
			if tabela[i].cod<>0 then
			begin
				  case tipo_de_caixa of
				  Caixa_de_clientes :
				  begin
						open_Fclientes;
						seek(Fclientes,tabela[i].cod);
						read(Fclientes,Bclientes);
						close_Fclientes;
						if tipo_de_classificacao=classifica_por_sobrenome then
							 sobrenomeie_cli(Bclientes.nome);
						st6:=Bclientes.nome;
						codigo:=Bclientes.codigo;
						end;

             Caixa_de_remedios :
				  begin
						open_Fremedios;
{                  writeln('Ola',i);}
						seek(Fremedios,tabela[i].cod);
						read(Fremedios,Bremedios);
						close_Fremedios;
						if tipo_de_classificacao=classifica_por_sobrenome then
							 sobrenomeie_remed(Bremedios.nome);
						st6:=Bremedios.nome;
						codigo:=Bremedios.codigo;
						end;

              Caixa_de_fornecs :
				  begin
						open_FFornecs;
						seek(FFornecs,tabela[i].cod);
						read(FFornecs,BFornecs);
						close_FFornecs;
						if tipo_de_classificacao=classifica_por_sobrenome then
							 sobrenomeie_Fornec(BFornecs.fantasia);
						st6:=BFornecs.fantasia;
						codigo:=BFornecs.codigo;
					end;

              Caixa_de_Operads :
				  begin
						open_FOperads;
						seek(FOperads,tabela[i].cod);
						read(FOperads,BOperads);
						close_FOperads;
						if tipo_de_classificacao=classifica_por_sobrenome then
							 sobrenomeie_Operad(BOperads.nome);
						st6:=BOperads.nome;
						codigo:=BOperads.codigo;
					end;

             Caixa_de_Medicos :
				  begin
						open_FMedicos;
						seek(FMedicos,tabela[i].cod);
						read(FMedicos,BMedicos);
						close_FMedicos;
						if tipo_de_classificacao=classifica_por_sobrenome then
							 sobrenomeie_Medicos(BMedicos.nome);
						st6:=BMedicos.nome;
						codigo:=BMedicos.codigo;
					end;

            Caixa_de_Conv :
				  begin
						open_FConv;
						seek(FConv,tabela[i].cod);
						read(FConv,BConv);
						close_FConv;
						if tipo_de_classificacao=classifica_por_sobrenome then
							 sobrenomeie_Conv(BConv.nome);
						st6:=BConv.nome;
						codigo:=BConv.codigo;
					end;


            Caixa_de_Grupos :
				  begin
						open_FGrupos;
						seek(FGrupos,tabela[i].cod);
						read(FGrupos,BGrupos);
						close_FGrupos;
						if tipo_de_classificacao=classifica_por_sobrenome then
							 sobrenomeie_Grupos(BGrupos.nome);
						st6:=BGrupos.nome;
						codigo:=BGrupos.codigo;
					end;

				 end; {fim case}
				  most(17,y+1,cmenu,fmenu,st6);
              most(11,y+1,cmenu,fmenu,inttostr(codigo));
				end;
			y:=y+1;
	 end;
end;
(**************************************************************************)
(* Constroi o menu de cadastro do tipo passado por tipo_de-caixa
(**************************************************************************)
Procedure Build_menu(Tipo_de_caixa : byte);
begin
    case tipo_de_caixa of
    Caixa_de_clientes : menu(9,4,70,22,cmenu,fmenu,'Ficha de Cliente');
    Caixa_de_remedios : menu(9,4,70,21,cmenu,fmenu,'Ficha de Medicamentos');
    Caixa_de_fornecs  : menu(9,4,70,18,cmenu,fmenu,'Ficha de Fornecedores');
    Caixa_de_Operads  : menu(9,4,70,20,cmenu,fmenu,'Ficha de Operadores');
    Caixa_de_Medicos  : menu(9,4,70,10,cmenu,fmenu,'Ficha de M‚dicos');
    Caixa_de_Conv     : menu(9,4,70,7,cmenu,fmenu,'Ficha de Convˆnio');
    Caixa_de_Grupos   : menu(9,4,70,7,cmenu,fmenu,'Ficha de Grupos');
    end; {fim case}
end;
(**************************************************************************)
(* Procedimento central dos cadastros - abre uma caixa de manuten‡ao
(**************************************************************************)
Function caixa(const tipo_de_caixa : byte) : integer;
var
	cont : byte;
	functionkey : boolean;
	caracter : char;
	se_inclui : boolean;
	ret_inp : byte;
	rei : boolean;
	Guarda_letras,St_Guarda_numeros,St_Pega_numeros_tab      : string;
	pos_atual : integer;
begin
	  salva_tela(7);
	  tipo_de_classificacao:=classifica_por_nome;
	  filtro:='';
	  range1:='';
	  range2:='';
  repeat
	  rei:=false; (* para reiniciar a caixa *)
   { Cronometro.inicia;}
	  le_dados(tipo_de_caixa);
    { Cronometro.finaliza;
    Cronometro.mostra; }
	  if tipo_de_classificacao<>classifica_por_codigo then
       classifica;
    case tipo_de_caixa of
	 Caixa_de_clientes : menu(10,4,45,24,cmenu,fmenu,'Clientes');
    Caixa_de_remedios : menu(10,4,45,24,cmenu,fmenu,'Medicamentos');
    Caixa_de_Fornecs  : menu(10,4,45,24,cmenu,fmenu,'Fornecedores');
    Caixa_de_Operads  : menu(10,4,45,24,cmenu,fmenu,'Operadores');
    Caixa_de_Medicos  : menu(10,4,45,24,cmenu,fmenu,'M‚dicos');
    Caixa_de_Conv     : menu(10,4,45,24,cmenu,fmenu,'Convˆnios');
    Caixa_de_Grupos   : menu(10,4,45,24,cmenu,fmenu,'Grupos');
     end; {fim case}
    status('');
    pos_atual:=1;
    Guarda_letras:='';
    St_Guarda_numeros:='';
    St_Pega_numeros_tab:='';
    lin_atual:=1;
	  mostra20(tipo_de_caixa,pos_atual);
	  repeat
			  status('ýþInclui ôõExclui • Consulta – Altera š › œ Ordena‡äes Alt+H Ajuda');
			  (*selecao*)
			  if num_reg_ativos>0 then
			  begin
					 if fbarra>7 then textcolor(cbarra+16)
					 else textcolor(cbarra);
					 textbackground(fbarra);
					 for cont:=11 to 44 do
					 begin
							if cont>16 then
							if fbarra>7 then textcolor(cbarra+16) else textcolor(cbarra);
							gotoxy(cont,lin_atual+4);
							write(getchar);
					 end;
			  end;
           off;
			  inkey(functionkey,caracter);

			  (*para apagar antiga selecao*)
			{  if not(key in [F1,f2,f3,F4,f5,f6,f7,f8,f9,f10,AltH,bksp,insertkey,Deletekey,space,enter]) then}
        if key in[uparrow,Downarrow,PgDn,PgUp,EndKey,HomeKey] then
			  begin
					 if fmenu>7 then textcolor(cmenu+16)
					 else textcolor(cmenu);
					 textbackground(fmenu);
					 for cont:=11 to 44 do
					 begin
							if cont>16 then
							if fmenu>7 then textcolor(cmenu+16) else
							textcolor(cmenu);
							gotoxy(cont,lin_atual+4);
							write(getchar);
					 end;
			  end;

			  (* para carregar na memoria a ficha antes de operar*)
			  if key in [f2,f3,f4,deletekey,enter] then (*CONSULTA,ALTERACAO,IMPRESSAO,EXCLUSAO*)
			  begin
					 case tipo_de_caixa of
					 Caixa_de_clientes  :
					 begin
						  open_Fclientes;
						  seek(Fclientes,tabela[pos_atual].cod);
						  read(Fclientes,Bclientes);
						  close(Fclientes);
					 end;

                Caixa_de_remedios  :
					 begin
						  open_Fremedios;
						  seek(Fremedios,tabela[pos_atual].cod);
						  read(Fremedios,Bremedios);
						  close(Fremedios);
					 end;

                Caixa_de_Fornecs :
					 begin
						  open_FFornecs;
						  seek(FFornecs,tabela[pos_atual].cod);
						  read(FFornecs,BFornecs);
						  close(FFornecs);
					 end;

                Caixa_de_Operads :
					 begin
						  open_FOperads;
						  seek(FOperads,tabela[pos_atual].cod);
						  read(FOperads,BOperads);
						  close(FOperads);
					 end;

                Caixa_de_Medicos :
					 begin
						  open_FMedicos;
						  seek(FMedicos,tabela[pos_atual].cod);
						  read(FMedicos,BMedicos);
						  close(FMedicos);
					 end;

                 Caixa_de_Conv :
					 begin
						  open_FConv;
						  seek(FConv,tabela[pos_atual].cod);
						  read(FConv,BConv);
						  close(FConv);
					 end;

                Caixa_de_Grupos :
					 begin
						  open_FGrupos;
						  seek(FGrupos,tabela[pos_atual].cod);
						  read(FGrupos,BGrupos);
						  close(FGrupos);
					 end;

				 end; {fim case}
			  end;

			  (*CONSULTA*)
			  if (key=f2) and (num_reg_ativos>0) then
			  begin
					 salva_tela(10);
                Build_menu(Tipo_de_caixa);
					 case tipo_de_caixa of
					 Caixa_de_clientes  :
					 begin
						  menu_cli;
						  mostra_cli;
					 end;

                Caixa_de_remedios  :
					 begin
						  menu_remed;
						  mostra_remed;
					 end;

                Caixa_de_Fornecs :
					 begin
						  menu_Fornec;
						  mostra_Fornec;
					 end;

                Caixa_de_Operads :
					 begin
						  menu_Operad;
						  mostra_Operad;
					 end;

                Caixa_de_Medicos :
					 begin
						  menu_Medicos;
						  mostra_Medicos;
					 end;

               Caixa_de_Conv :
					 begin
						  menu_Conv;
						  mostra_Conv;
					 end;

               Caixa_de_Grupos :
					 begin
						  menu_Grupos;
						  mostra_Grupos;
					 end;

  					 end; {fim case}
      		    status('Pressione ESC para sair');
       		    pesc;

					 key:=nullkey;
					 volta_tela(10,false);
				end;

			  (*Help Procs*)
			  if key=altH then
              	help;

        (*Help Context*)
      {  if key=f1 then
        begin
          erro('Ainda em contru‡Æo');
          key:=nullkey;
        end; }

			  (*BS - Reset*)
			  if key=BkSp then
			  begin
					Guarda_letras:='';
					filtro:='';
					Range1:='';
					Range2:='';
					tipo_de_classificacao:=classifica_por_nome;
					rei:=true;
					key:=Nullkey;
			  end;

   		  (*F5 - Filtro*)
			  if key=f5 then
			  begin
				  salva_tela(10);
              status('Ser  mostrado na tela somente os registros q iniciam c/ essas letras');
				  menu(20,10,63,15,cmenu,fmenu,'Filtro');
				  most(22,12,cmenu,fmenu,'Digite letras :');
				  inputstring(filtro,40,40,22,13,'T',ret_inp);
				  volta_tela(10,false);
				  rei:=true;
				  key:=nullkey;
			  end;

			  (*F6 - Filtro por cod ou letras*)
			  if key=f6 then
			  begin
				  salva_tela(10);
              status('Ser  mostrado na tela somente os registros entre o intervalo digitado');
				  menu(20,10,62,16,cmenu,fmenu,'Filtro');
				  most(22,12,cmenu,fmenu,'Do c¢digo :');
				  most(22,14,cmenu,fmenu,'Ao c¢digo :');
				  inputstring(range1,4,4,22,13,'N',ret_inp);
				  if range1<>'' then
				  inputstring(range2,4,4,22,15,'N',ret_inp);
				  rei:=true;
				  key:=nullkey;
				  volta_Tela(10,false);
			  end;

			  (*INCLUSAO*)
			  if key=insertkey then
			  begin
					 salva_tela(12);
		{			 if Num_clientes>maximo then
					 begin
						 erro('Registro cheio, entre em contato !');
						 volta_tela(12,false);
             continue;
					 end; }
					 se_inclui:=false;
					 Build_menu(Tipo_de_caixa);
   				 case tipo_de_caixa of
					 Caixa_de_clientes  :
					 repeat
						  menu_cli;
						  leit_cli(true,se_inclui);
					 until Bclientes.nome='';

                Caixa_de_remedios :
					 repeat
						  menu_remed;
						  leit_remed(true,se_inclui);
					 until Bremedios.nome='';

                Caixa_de_Fornecs :
					 repeat
						  menu_Fornec;
						  leit_Fornec(true,se_inclui);
					 until Bfornecs.fantasia='';

                Caixa_de_Operads :
					 repeat
						  menu_Operad;
						  leit_Operad(true,se_inclui);
					 until BOperads.nome='';

                Caixa_de_Medicos :
					 repeat
						  menu_Medicos;
						  leit_Medicos(true,se_inclui);
					 until BMedicos.nome='';

                Caixa_de_Conv :
					 repeat
						  menu_Conv;
						  leit_Conv(true,se_inclui);
					 until BConv.nome='';

               Caixa_de_Grupos :
					 repeat
						  menu_Grupos;
						  leit_Grupos(true,se_inclui);
					 until BGrupos.nome='';

					 end; {fim case}
					 if se_inclui then rei:=true;
					 key:=nullkey;
					 volta_tela(12,false);
			  end;

			  (*ALTERACAO*)
			  if (key=f3) and (num_reg_ativos>0) then
			  begin
					 salva_tela(10);
					 se_inclui:=false;
                Build_menu(Tipo_de_caixa);
					 case tipo_de_caixa of

					 Caixa_de_clientes :
					 begin
						  menu_cli;
						  mostra_cli;
						  leit_cli(false,se_inclui);
					 end;

                Caixa_de_remedios :
					 begin
						  menu_remed;
						  mostra_remed;
						  leit_remed(false,se_inclui);
					 end;

                Caixa_de_Fornecs :
					 begin
						  menu_fornec;
						  mostra_fornec;
						  leit_fornec(false,se_inclui);
					 end;

                Caixa_de_Operads :
					 begin
						  menu_Operad;
						  mostra_Operad;
						  leit_Operad(false,se_inclui);
					 end;

                Caixa_de_Medicos :
					 begin
						  menu_Medicos;
						  mostra_Medicos;
						  leit_Medicos(false,se_inclui);
					 end;

                Caixa_de_Conv :
					 begin
						  menu_Conv;
						  mostra_Conv;
						  leit_Conv(false,se_inclui);
					 end;

                Caixa_de_Grupos :
					 begin
						  menu_Grupos;
						  mostra_Grupos;
						  leit_Grupos(false,se_inclui);
					 end;


               end; {fim case}
					 if se_inclui then
						 rei:=true;
					 key:=nullkey;
					 volta_tela(10,false);
			  end;

			  (*EXCLUSAO*)
			  if (key=deletekey) and (num_reg_ativos>0) then
			  begin
					 salva_tela(10);
                Build_menu(Tipo_de_caixa);
					 case tipo_de_caixa of

					 Caixa_de_clientes :
					 begin
						  menu_cli;
						  mostra_cli;
						  if ok then
						  begin
							 exclui_cli(tabela[pos_atual].cod);
                      rei:=true;
						  end;
					 end;

                Caixa_de_remedios :
					 begin
						  menu_remed;
						  mostra_remed;
						  if ok then
                    begin
                    exclui_remed(tabela[pos_atual].cod);
                    rei:=true;
						  end;
					 end;

                Caixa_de_fornecs :
					 begin
						  menu_fornec;
						  mostra_fornec;
						  if ok then
                    begin
                    exclui_fornec(tabela[pos_atual].cod);
                    rei:=true;
						  end;
					 end;

                Caixa_de_Operads :
					 begin
						  menu_Operad;
						  mostra_Operad;
						  if ok then
                    begin
                    exclui_Operad(tabela[pos_atual].cod);
                    rei:=true;
						  end;
					 end;

               Caixa_de_Medicos :
					 begin
						  menu_Medicos;
						  mostra_Medicos;
						  if ok then
                    begin
                    exclui_Medicos(tabela[pos_atual].cod);
                    rei:=true;
						  end;
					 end;

               Caixa_de_Conv :
					 begin
						  menu_Conv;
						  mostra_Conv;
						  if ok then
                    begin
                    exclui_Conv(tabela[pos_atual].cod);
                    rei:=true;
						  end;
					 end;

               Caixa_de_Grupos :
					 begin
						  menu_Grupos;
						  mostra_Grupos;
						  if ok then
                    begin
                    exclui_Grupos(tabela[pos_atual].cod);
                    rei:=true;
						  end;
					 end;


					end; {fim case}
					key:=nullkey;
					volta_tela(10,false);
			  end;

			  (*IMPRESSAO*)
			  if (key=f4) then
			  begin
          erro('Ainda em contru‡Æo');
          status('Este menu ainda est  em fase de codifica‡Æo');
          key:=nullkey;
        {
			  salva_tela(10);
			  case tipo_de_caixa of
			  Caixa_de_clientes :
			  begin
				  {aqui imprimi
			  end;
			  end;
			  key:=nullkey;
			  volta_tela(10,false);}
			  end;

			  (*PARA BAIXO*)
			  if (key=downarrow) and (pos_atual<num_reg_ativos) then
			  begin
					 pos_atual:=pos_atual+1;
					 lin_atual:=lin_atual+1;
			  end;

			  (*PARA CIMA*)
			  if (key=uparrow) and (pos_atual>1) then
			  begin
					 pos_atual:=pos_atual-1;
					 lin_atual:=lin_atual-1;
			  end;

			  (*PAGE UP*)
			  if (key=pgup) then
			  begin
           if pos_atual>1 then
					 if (pos_atual<=19) then begin lin_atual:=0; pos_atual:=1; end;
					 if (pos_atual>19) then begin lin_atual:=0; pos_atual:=pos_atual-19; end;

			  end;

			  (*PAGE DOWN*)
			  if (key=pgdn) then
			  begin
					{ if (pos_atual+18>=num_reg_ativos) then begin lin_atual:=0; pos_atual:=num_reg_ativos; end;}
    		  if (pos_atual+18<num_reg_ativos) then begin lin_atual:=20; pos_atual:=pos_atual+19; end;
			  end;

			  (*HOME*)
			  if (key=homekey) and (pos_atual>1) then
			  begin
  				 lin_atual:=0;
					 pos_atual:=1;
			  end;

			  (*END*)
			  if (key=endkey) then
			  begin
					 lin_atual:=0;
					 pos_atual:=num_reg_ativos;
			  end;

			  (*CLASSIFICA POR CODIGO*)
			  if (key=f7) then
			  begin
					 tipo_de_classificacao:=classifica_por_codigo;
					 rei:=true;
			  end;

			  (*CLASSIFICA POR ORDEM ALFABETICA*)
			  if (key=f8) then
			  begin
					 tipo_de_classificacao:=classifica_por_nome;
					 rei:=true;
			  end;

			  (*CLASSIFICA POR SOBRENOME*)
			  if (key=f9) then
			  begin
					 tipo_de_classificacao:=classifica_por_sobrenome;
					 rei:=true;
			  end;

			  (*F10*)
			  if (key=f10) then
					 relogio;

			  (*A..Z*)
			  if (key IN [textkey,space]) and (num_reg_ativos>0) then
			  begin
					 Guarda_letras:=Guarda_letras+upcase(caracter);
					 contador:=0;
					 repeat
							 contador:=contador+1;
					 until (pos(Guarda_letras,tabela[contador].nome)=1) or (contador>=num_reg_ativos);
					 if (pos(Guarda_letras,tabela[contador].nome)=1) then
					 begin
							lin_atual:=0;
							pos_atual:=contador;
					 end;
			  end;

			  (*0..9*)
			  if (key=numberkey) and (num_reg_ativos>0) then
			  begin
					 St_Guarda_numeros:=St_Guarda_numeros+caracter;
					 contador:=0;
					 repeat
							 contador:=contador+1;
							 str(tabela[contador].cod,St_Pega_numeros_tab);
					 until ((pos(St_Guarda_numeros,St_Pega_numeros_tab)>0) and
							  (length(St_Guarda_numeros)=length(St_Pega_numeros_tab)))
							 or (contador>=num_reg_ativos);
					 if (pos(St_Guarda_numeros,St_Pega_numeros_tab)>0) then
					 begin
							lin_atual:=0;
							pos_atual:=contador;
					 end;
			  end;

			  if not(key in [textkey,space]) then	Guarda_letras:='';
			  if not(key=numberkey) then St_Guarda_numeros:='';
			  if (lin_atual<1) then
			  begin
					 lin_atual:=1;
					 mostra20(tipo_de_caixa,pos_atual);
			  end;
			  if (lin_atual>19) then
			  begin
					 lin_atual:=19;
					 mostra20(tipo_de_caixa,pos_atual);
			  end;
	 until (key in [esc,enter]) or (rei);
	 pos_atual:=tabela[pos_atual].cod;
	 if key=esc then pos_atual:=0;
	until not(rei);
	volta_tela(7,false);
	caixa:=pos_atual;
end;
(**************************************************************************
 LEITURA DE CODIGO DE UM REGISTRO QUE PODE CHAMAR A CAIXA
 ELA PRàPRIA Dµ O ERRO SE :
 CàDIGO DIGITADO > = 32767
 REGISTRO REFERENTE AO CàDIGO ESTµ COM AI='I'
 CàDIGO > ULTIMO_REGISTRO
 OBS1 -> SE DER ERRO NA FUNCAO, POR QUALQUER UM DOS MOTIVOS ACIMA
  ELA RETORANA COM VALOR 32767 (notValidCod)
 SE APERTEI ESC OU ENTER SEM NADA DIGITADO RETORNA 0
 OBS2 -> QUEM CHAMOU ESTA FUNCAO NÇO PRECISA LER O REGISTRO NOVAMENTE
 SE APERTAR F1 :
  SE SELECIONEI ALGUEM SAI DA FUN€ÇO
  SE DEI ESC NA CAIXA ELE FICA NA FUN€ÇO
 **************************************************************************)
Function le_codigo (const x,y,Tipo_de_Caixa : byte) : integer;
var
   stcod_temp : string;
   cod_temp   : integer;
   caracter : char;
   functionkey : boolean;
   coluna : byte;
   isValidCod : boolean;
   Old_key : Keys;
   var_erro : integer;
   val_real : real;
Procedure remost;
begin
   textcolor(15);
   textbackground(0);
   gotoxy(x,y);
   write(' ':5);
   gotoxy(x,y);
   write(stcod_Temp);
end;
begin
   cod_temp:=0;
   stcod_temp:='';
   coluna:=x;
   Isvalidcod:=true;
   remost;
   repeat
      gotoxy(coluna,y);
      on;
      inkey(functionkey,caracter);
      if (key=BkSp)  then
      begin
         if (coluna-x<=0) then
              continue;
         delete(stcod_temp,coluna-x,1);
         coluna:=coluna-1;
         remost;
      end;
     if key=f1 then (*Chamar a caixa*)
      begin
         Old_key:=key; (*pois a caixa sobrepäes a key*)
         cod_temp:=caixa(Tipo_de_caixa);
         if cod_temp<>0 then
         begin
           le_codigo:=cod_temp;
           stcod_temp:=inttostr(Cod_temp);
           remost;
           exit;
         end;
         key:=Old_Key;
      end;
      if key=numberkey then
      begin
        stcod_temp:=stcod_temp+caracter;
        remost;
        coluna:=coluna+1;
      end;
   until ((stcod_temp='') or
          (key in [Esc,Enter]) or
          (stcod_temp='0') or
          (length(stcod_temp)=5)) and
          (not (key in [BkSp,f1]));

   val(stcod_temp,val_real,var_erro);

   if val_real>=32767.0 then
   begin
      erro('C¢digo Inv lido >= 32767');
      (*QUER DIZER QUE DIGITEI CODIGO ERRADO
        E QUE A FUN€ÇO VOLTA COM O VALOR 32767*)
      le_codigo:=notValidCod;
      exit;
   end;
   cod_temp:=strtoint(stcod_temp);
   if (stcod_temp='') or
      (stcod_temp='0') or
      (key=esc) or
      (cod_temp=0) then
   begin
     le_codigo:=0;
     exit;
   end;
   (*VERFICAR SE REGISTRO ESTA ATIVO OU SE CàDIGO  MAIOR QUE O ULTIMO*)
   case tipo_de_caixa of

   caixa_de_clientes :
   begin
     open_Fclientes;
     if cod_temp>=num_clientes then
     begin
       isValidCod:=false;
       erro('C¢digo Inv lido');
     end
     else
     begin
       seek(Fclientes,cod_temp);
       read(Fclientes,Bclientes);
       if Bclientes.AI='I' then
       begin
         isValidCod:=false;
         erro('Cliente exclu¡do !');
       end;
     end;
      close_Fclientes;
   end;

   caixa_de_remedios :
   begin
     open_Fremedios;
     if cod_temp>=num_remedios then
     begin
       isValidCod:=false;
       erro('C¢digo Inv lido');
     end
     else
     begin
       seek(Fremedios,cod_temp);
       read(Fremedios,Bremedios);
       if Bremedios.AI='I' then
       begin
         isValidCod:=false;
         erro('Medicamento exclu¡do !');
       end;
     end;
      close_Fremedios;
    end;

   caixa_de_operads :
   begin
     open_Foperads;
     if cod_temp>=num_operads then
     begin
       isValidCod:=false;
       erro('C¢digo Inv lido');
     end
     else
     begin
       seek(Foperads,cod_temp);
       read(Foperads,Boperads);
       if Boperads.AI='I' then
       begin
         isValidCod:=false;
         erro('Operador exclu¡do !');
       end;
     end;
      close_Foperads;
   end;

   caixa_de_fornecs :
   begin
     open_Ffornecs;
     if cod_temp>=num_fornecs then
     begin
       isValidCod:=false;
       erro('C¢digo Inv lido');
     end
     else
     begin
       seek(Ffornecs,cod_temp);
       read(Ffornecs,Bfornecs);
       if Bfornecs.AI='I' then
       begin
         isValidCod:=false;
         erro('Fornecedor exclu¡do !');
       end;
     end;
     close_Ffornecs;
   end;


   end; (*fim Case*)
   if isValidCod then
      le_codigo:=cod_temp
   else
     le_codigo:=notValidCod; (*QUER DIZER QUE DIGITEI CODIGO ERRADO*)
end;
(**************************************************************************)
begin
end.
