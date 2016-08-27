(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
***********************************************************************)
unit Operads;
(***********************************************************************)
interface
(***********************************************************************)
uses
	Kcrt,crt;
(***********************************************************************)
type
    String39 = string [39]; (*por causa do sobrenomeie*)
    Toperads = record
		codigo      : integer;
		ai          : char;
      nome        : string39;
		senha       : string[10];
		nivel       : string[10];
      comissao    : string[6];
		end;
var
	Foperads : file of Toperads;
	Boperads : Toperads;
	Num_operads : integer;
(***********************************************************************)
Procedure open_Foperads;
Procedure close_Foperads;
Procedure Cria_Foperads;
Procedure zera_operad;
procedure sobrenomeie_operad(var st2 : string39);
Procedure menu_operad;
Procedure mostra_operad;
Procedure leit_operad(inc :boolean; var se_inclui : boolean);
Procedure exclui_operad (registro : integer);
implementation
(***********************************************************************
MENU DO operad
(**************************************************************************)
Procedure menu_operad;
begin
	  most(12,5,cmenu,fmenu,'C¢digo       : [     ]  ');
	  most(12,6,cmenu,fmenu,'Nome Operador: [                                       ]');
     most(12,7,cmenu,fmenu,'Senha        : [          ]');
	  most(12,8,cmenu,fmenu,'N°vel        : [            ]');
	  most(12,9,cmenu,fmenu,'Comiss∆o     : [      ]');
     most(12,10,cmenu,fmenu,'Permiss‰es   :');
     square(14,11,cmenu,fmenu,'Manutená∆o de clientes@Manutená∆o de medicamentos'+
     '@Manutená∆o de operadores@Emitir Compras@Emitir Vendas@Relat¢rios@Listagens@Acesso remoto@Configurar sistema');
     square(11,11,cmenu,fmenu,'‘’@‘’@‘’@‘’@‘’@‘’@‘’@‘’@‘’@');

end;
(**************************************************************************
MOSTRA MEMORIA
(**************************************************************************)
Procedure mostra_operad;
begin
 	  remost(28,5,cmenu,fmenu,inttostr(Boperads.codigo),5);
	  remost(28,6,cmenu,fmenu,Boperads.nome,39);
     remost(28,7,cmenu,fmenu,Boperads.senha,10);
	  remost(28,8,cmenu,fmenu,Boperads.nivel,10);
	  remost(28,9,cmenu,fmenu,Boperads.comissao,6);
end;
(**************************************************************************)
(* Le operads - se inc for verdadeiro entao e inclusao
(* Se_inclui - retorna verdadeiro se operad foi incluido
(**************************************************************************)
Procedure veja(ret_inp : byte;var sob : byte);
begin
	  if ret_inp=0 then sob:=sob-1;
	  if ret_inp=255 then sob:=255;
	  if ret_inp=1 then sob:=sob+1;
	  if sob=0 then sob:=1;
end;
(**************************************************************************)
(* Atualiza o c¢digo do operad se dois est∆o sendo incluidos
(**************************************************************************)
Procedure atualiza;
begin
	 open_Foperads;
	 gotoxy(28,5);
	 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
	 textbackground(fmenu);
	 write(Num_operads);
	 close_Foperads;
end;
(**************************************************************************
LEITURA
(**************************************************************************)
Procedure leit_operad(inc : boolean; var se_inclui : boolean);
const
   YES = 1;
   NO  = 2;
   CANCEL = 3;
var
	ret_inp,sob : byte;
	st1 : string;
   YNC_leit  : byte;
	(*ai Guinther, tu chama a input com o sob
	  se tu colocou pra baixo incrementa os sob*)
{	dt : string[8];
	dayname : str3;
	DayNum: integer; }
begin
	  if inc then   (*se for inclusao*)
	  begin
			 open_Foperads;
			 close_Foperads;
			 zera_operad;
			 Boperads.AI:='A';
			 Boperads.codigo:=num_operads;
			 gotoxy(28,5);
			 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
			 textbackground(fmenu);
			 write(Boperads.codigo);
	  end;
	  sob:=1;

repeat {do YNC}

  YNC_leit:=0;
  repeat {do sob}

 	  if sob=1 then
	  begin
	  status('Digite nome do operador');
	  st1:=Boperads.nome;
	  inputstring(st1,39,39,28,6,'T',ret_inp);
	  Boperads.nome:=st1;
	  remost(28,6,cmenu,fmenu,Boperads.nome,39);
     if st1='' then exit;
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	 end;

	  if sob=2 then
	  begin
	  status('Digite senha do operadedor');
     st1:=Boperads.senha;
	  inputstring(st1,10,10,28,7,'T',ret_inp);
	  Boperads.senha:=st1;
	  remost(28,7,cmenu,fmenu,Boperads.senha,10);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
     end;

	  if sob=3 then
	  begin
	  status('Digite nivel do operador');
	  st1:=Boperads.nivel;
 	  inputstring(st1,10,10,28,8,'T',ret_inp);
	  Boperads.nivel:=st1;
	  remost(28,8,cmenu,fmenu,Boperads.nivel,10);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=4 then
	  begin
	  status('Digite comiss∆o por venda do operador');
	  st1:=Boperads.comissao;
	  inputstring(st1,6,6,28,9,'T',ret_inp);
 	  Boperads.comissao:=st1;
	  remost(28,9,cmenu,fmenu,Boperads.comissao,6);
 	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

     status('Utilize PGUP e PGDN - Espaáo marca - Para encerrar ESC');
     if sob=5 then
     begin
          if inc then Boperads.nivel:='00000000000';
          st1:=Boperads.nivel;
          checkBox (11,11,9,st1);
          Boperads.nivel:=st1;
          sob:=sob+1;
     end;

 until (sob=6) or (sob=255); {do sob}
                   (*ESC*)
     YNC_leit:=YNC;
 	  if Boperads.nome<>'' then
	  begin
			 case YNC_leit of
          YES :  begin
					   se_inclui:=true;
				 	   open_Foperads;
					   if inc then Boperads.codigo:=num_operads; (*rede*)
					   seek(Foperads,Boperads.codigo);
					   write(Foperads,Boperads);
					   close_Foperads;
			        end;
            NO : sob:=1;
            CANCEL : exit;
           end;
		end;
until (Boperads.nome='') or (YNC_leit <> NO);
                             {se for NO volta a ler o mesmo de novo}
end;
(***************************************************************************
ZERA MEMORIA
(***************************************************************************)
Procedure zera_operad;
begin
	  with Boperads do
	  begin
			 codigo      :=0;
			 ai          :='I';
          nome    :='';
       	 senha   :='';
      	 nivel   :='';
			 comissao:='';
	  end;
end;
(***************************************************************************
CRIA ARQUIVO
(***************************************************************************)
Procedure Cria_Foperads;
begin
	  zera_operad;
{	  assign(Foperads,'operads.dat'); }
	  rewrite(Foperads);
	  seek(Foperads,0);
	  write(Foperads,Boperads);
	  close(Foperads);
end;
(***************************************************************************
ABRE ARQUIVO
(***************************************************************************)
Procedure open_Foperads;
var
	io : integer;
	vo : boolean;
begin
	  vo:=false;
	  assign(Foperads,'operads.dat');
	  {$i-}
	  repeat
				reset(Foperads);
				io:=ioresult;
				if io<>0 then
				begin
						if not(vo) then (* s¢ mostra a primeira vez*)
						status('Aguarde liberaá∆o de arquivo...');
						vo:=true;
				end;
				if io=2 then
				begin
					  cria_Foperads;
					  reset(Foperads);
				end;
	  until (io=0);
	  {$i+}
	  num_operads:=filesize(Foperads);
end;
(***************************************************************************
FECHA ARQUIVO
(***************************************************************************)
Procedure close_Foperads;
begin
	  close(Foperads);
end;
(***************************************************************************
PASSA O SOBRENOME PARA FRENTE
(***************************************************************************)
procedure sobrenomeie_operad(var st2 : string39); {passa o sobren p/ frente}
var
	a : byte;
	cai : boolean;
	st1 : string;
begin
	  cai:=false;
	  for a:=length(st2) downto 1 do
	  begin
			 if (st2[a]=' ') and (not(cai)) then
			 begin
					st1:=copy(st2,a+1,length(st2));
					delete(st2,a,length(st2)-a+1);
					st2:=st1+','+st2;
					cai:=true;
			  end;
	  end;
end;
(***************************************************************************
EXCLUIR UM operad
(***************************************************************************)
Procedure exclui_operad (registro : integer);
begin
	open_Foperads;
  	seek(Foperads,registro);
   read(Foperads,Boperads);
	Boperads.AI:='I';
	seek(Foperads,registro);
  	write(Foperads,Boperads);
	close(Foperads);
end;
(***************************************************************************)
(***************************************************************************)
(***************************************************************************)
begin

end.