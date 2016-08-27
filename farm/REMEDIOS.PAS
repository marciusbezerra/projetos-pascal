(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
***********************************************************************)
unit Remedios;
(***********************************************************************)
interface
(***********************************************************************)
uses
	Kcrt,crt;
(***********************************************************************)
type
    String39 = string [39]; (*por causa do sobrenomeie_remedio*)
    Tremedios = record
		codigo      : integer;
		ai          : char;
		nome        : string39;
      classe      : string[30];
      precocompra : string[7];
      desconto    : string[2];
      lucro       : string[3];
      precovenda  : string[7];
      unidade     : string[4];
		estoque     : string[5];
      estmin      : string[5];
      estmax      : string[5];
      icm         : string[2];
      ultentrada  : string[10];
      ultsaida    : string[10];
		barras      : string[16];
		end;
var
	Fremedios : file of Tremedios;
	Bremedios : TRemedios;
	Num_remedios : integer;
(***********************************************************************)
Procedure open_Fremedios;
Procedure close_Fremedios;
Procedure cria_Fremedios;
Procedure zera_remed;
procedure sobrenomeie_remed(var st2 : string39);
Procedure menu_remed;
Procedure mostra_remed;
Procedure leit_remed(inc :boolean; var se_inclui : boolean);
Procedure exclui_remed (registro : integer);
(***********************************************************************)
implementation
(***********************************************************************)
uses grupos;
(***********************************************************************)
Procedure menu_remed;
begin
	  most(12,5,cmenu,fmenu,'C¢digo      : [     ]  ');
{	  most(39,5,cmenu,fmenu,'Data da ficha : [          ]'); }
	  most(12,6,cmenu,fmenu,'Descri‡Æo   : [                                       ]');
     most(12,7,cmenu,fmenu,'Grupo/Classe: [  ] -> ');
	  most(12,8,cmenu,fmenu,'Pre‡o Compra: [       ]');
     most(12,9,cmenu,fmenu,'Desconto    : [  %]');
     most(12,10,cmenu,fmenu,'Lucro       : [   %]');
     most(12,11,cmenu,fmenu,'Pre‡o Venda : [       ]');
     most(12,12,cmenu,fmenu,'Unidade     : [    ]');
	  most(12,13,cmenu,fmenu,'Estoq atual : [     ]');
     most(12,14,cmenu,fmenu,'Estoque Min : [     ]');
     most(12,15,cmenu,fmenu,'Estoque Max : [     ]');
     most(12,16,cmenu,fmenu,'Tribut ICMS : [  %]');
	  most(12,17,cmenu,fmenu,'Cod Barras  : [                ]');
     most(12,18,cmenu,fmenu,'Ult Entrada : [          ]');
     most(12,19,cmenu,fmenu,'Ult Sa¡da   : [          ]');
end;
(**************************************************************************)
Procedure mostra_remed;
begin
{	  remost(56,5,cmenu,fmenu,Bremedios.data,10); }
 	  remost(27,5,cmenu,fmenu,inttostr(Bremedios.codigo),5);
	  remost(27,6,cmenu,fmenu,Bremedios.nome,39);
     remost(27,7,cmenu,fmenu,Bremedios.classe,2);
     remost(27,8,cmenu,fmenu,Bremedios.precocompra,7);
     remost(27,9,cmenu,fmenu,Bremedios.desconto,2);
     remost(27,10,cmenu,fmenu,Bremedios.lucro,3);
     remost(27,11,cmenu,fmenu,Bremedios.precovenda,7);
     remost(27,12,cmenu,fmenu,Bremedios.unidade,2);
     remost(27,13,cmenu,fmenu,Bremedios.estoque,2);
     remost(27,14,cmenu,fmenu,Bremedios.estmin,5);
     remost(27,15,cmenu,fmenu,Bremedios.estmax,5);
     remost(27,16,cmenu,fmenu,Bremedios.icm,2);
     remost(27,17,cmenu,fmenu,Bremedios.barras,16);
     remost(27,18,cmenu,fmenu,Bremedios.ultentrada,10);
     remost(27,19,cmenu,fmenu,Bremedios.ultsaida,10);
end;
(**************************************************************************)
(* Le remedios - se inc for verdadeiro entao e inclusao
(* Se_inclui - retorna verdadeiro se remedente foi incluido
(**************************************************************************)
Procedure veja(ret_inp : byte;var sob : byte);
begin
	  if ret_inp=0 then sob:=sob-1;
	  if ret_inp=255 then sob:=255;
	  if ret_inp=1 then sob:=sob+1;
	  if sob=0 then sob:=1;
end;
(**************************************************************************)
(* Atualiza o c¢digo do remedente se dois estÆo sendo incluidos
(**************************************************************************)
Procedure atualiza;
begin
	 open_Fremedios;
	 gotoxy(27,5);
	 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
	 textbackground(fmenu);
	 write(Num_remedios);
	 close_Fremedios;
end;
(**************************************************************************)
Procedure leit_remed(inc : boolean; var se_inclui : boolean);
const
   YES = 1;
   NO  = 2;
   CANCEL = 3;
var
	ret_inp,sob : byte;
	st1 : string;
	(*ai Guinther, tu chama a input com o sob
	  se tu colocou pra baixo incrementa os sob*)
{	dt : string[8];
	dayname : str3;
	DayNum: integer; }
   pc,pv : real; (*PRECO DE COMPRA E VENDA*)
   l,d  : integer; (*lucro,desconto*)
   YNC_leit  : byte;
begin

	  if inc then   (*se for inclusao*)
	  begin
			 open_Fremedios;
			 close_Fremedios;
			 zera_remed;
			 Bremedios.AI:='A';
			 Bremedios.codigo:=num_remedios;
			 gotoxy(27,5);
			 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
			 textbackground(fmenu);
			 write(Bremedios.codigo);
{			 Bremedios.data:=date; }
	  end;
{	  most(56,5,cmenu,fmenu,Bremedios.data); }
	  sob:=1;
repeat {do YNC}
   YNC_leit:=0;

  repeat (*DO SOB*)
     if sob=1 then
	  begin
	  status('Digite nome/descri‡Æo do medicamento');
	  st1:=Bremedios.nome;
	  inputstring(st1,39,39,27,6,'T',ret_inp);
	  Bremedios.nome:=st1;
	  remost(27,6,cmenu,fmenu,Bremedios.nome,39);
	  if st1='' then exit;
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
		end;

     if sob=2 then
	  begin
	  status('Digite grupo do medicamento');
	  st1:=Bremedios.classe;
	  inputstring(st1,2,2,27,7,'N',ret_inp);
	  Bremedios.classe:=st1;
	  remost(27,7,cmenu,fmenu,Bremedios.classe,2);
	  veja(ret_inp,sob);
     open_Fgrupos;
     if strtoint(st1)<Num_grupos then
     begin
     seek(Fgrupos,strtoint(st1));
     read(Fgrupos,Bgrupos);
     end
     else
      erro('C¢digo de grupo inv lido!');
    close_Fgrupos;
     remost(33,7,cmenu,fmenu,Bgrupos.nome,37);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
		end;

     if sob=3 then
	  begin
	  status('Digite pre‡o de compra');
	  st1:=Bremedios.precocompra;
	  inputstring(st1,7,7,27,8,'N',ret_inp);
	  Bremedios.precocompra:=st1;
	  remost(27,8,cmenu,fmenu,Bremedios.precocompra,7);
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
		end;

    if sob=4 then
	  begin
	  status('Digite desconto sobre o rem‚dio');
	  st1:=Bremedios.desconto;
	  inputstring(st1,2,2,27,9,'N',ret_inp);
	  Bremedios.desconto:=st1;
	  remost(27,9,cmenu,fmenu,Bremedios.desconto,2);
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
		end;

     if sob=5 then
	  begin
	  status('Digite o lucro que a empresa recebe sobre o medicamento');
	  st1:=Bremedios.lucro;
	  inputstring(st1,3,3,27,10,'N',ret_inp);
	  Bremedios.lucro:=st1;
	  remost(27,10,cmenu,fmenu,Bremedios.lucro,3);
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	end;

     if sob=6 then
	  begin
     status('Este ‚ pre‡o de venda sugerido, podendo ser alterado');
     if inc then
     begin
        pc:=strtoreal(Bremedios.precocompra);
        l:=strtoint(Bremedios.lucro);
        d:=strtoint(Bremedios.desconto);
        pv:=pc+(pc*l/100.0);
        if d<>0 then
        pv:=pv-(pv*d/100.0);
        st1:=realtostr(pv);
     end
     else
	    st1:=Bremedios.precovenda;
	  inputstring(st1,7,7,27,11,'N',ret_inp);
	  Bremedios.precovenda:=st1;
	  remost(27,11,cmenu,fmenu,Bremedios.precovenda,7);
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	end;

     if sob=7 then
	  begin
     if (inc) and (Bremedios.unidade='') then
     begin
      st1:=caixinha(25,11,'VIDR@CXA@UNID@ENVL@PECA@PACT@TUBO@POTE@FRAS');
      status('Escolha unidade de venda medicamento');
     end
     else
     begin
     status('Digite unidade de venda do medicamento');
	  st1:=Bremedios.unidade;
	  inputstring(st1,4,4,27,12,'T',ret_inp);
     end;
	  Bremedios.unidade:=st1;
	  remost(27,12,cmenu,fmenu,Bremedios.unidade,4);
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	end;

     if sob=8 then
	  begin
     status('Digite o estoque atual');
	  st1:=Bremedios.estoque;
	  inputstring(st1,5,5,27,13,'N',ret_inp);
	  Bremedios.estoque:=st1;
	  remost(27,13,cmenu,fmenu,Bremedios.estoque,5);
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	end;


     if sob=9 then
	  begin
     status('Digite o estoque m¡nimo para este medicamento');
	  st1:=Bremedios.estmin;
	  inputstring(st1,5,5,27,14,'N',ret_inp);
	  Bremedios.estmin:=st1;
	  remost(27,14,cmenu,fmenu,Bremedios.estmin,5);
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	end;

    if sob=10 then
	  begin
     status('Digite o estoque m ximo para este medicamento');
     st1:=Bremedios.estmax;
	  inputstring(st1,5,5,27,15,'N',ret_inp);
	  Bremedios.estmax:=st1;
	  remost(27,15,cmenu,fmenu,Bremedios.estmax,5);
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	end;

    if sob=11 then
	  begin
     status('Digite o ICM sobre o medicamento');
	  st1:=Bremedios.icm;
	  inputstring(st1,2,2,27,16,'N',ret_inp);
	  Bremedios.icm:=st1;
	  remost(27,16,cmenu,fmenu,Bremedios.icm,2);
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	end;

    if sob=12 then
	  begin
     status('Passe o leitor de c¢digo de barras no medicamento ou digite-o');
	  st1:=Bremedios.barras;
	  inputstring(st1,16,16,27,17,'N',ret_inp);
	  Bremedios.barras:=st1;
	  remost(27,17,cmenu,fmenu,Bremedios.barras,16);
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	end;

until (sob=13) or (sob=255);

   YNC_leit:=YNC;
  	  if Bremedios.nome<>'' then
	  begin
          case ync_leit of
			 YES: begin
					se_inclui:=true;
					open_Fremedios;
					if inc then Bremedios.codigo:=num_remedios; (*rede*)
					seek(Fremedios,Bremedios.codigo);
					write(Fremedios,Bremedios);
					close_Fremedios;
			     end;
            NO : sob:=1;
            CANCEL : exit;
        end;
     end;
   until (Bremedios.nome='') or (YNC_leit <> NO);
end;
(***************************************************************************)
Procedure zera_remed;
begin
	  with Bremedios do
	  begin
		 codigo:=0;
	    ai    :='I';
		 nome  :='';
       classe :='';
       precocompra :='';
       desconto:='';
       lucro:='';
       precovenda:='';
       unidade:='';
       estoque:='';
       estmin:='';
       estmax:='';
       icm:='';
       barras:='';


    end;
end;
(***************************************************************************)
Procedure cria_Fremedios;
begin
	  zera_remed;
{	  assign(Fremedios,'remedios.dat'); }
	  rewrite(Fremedios);
	  seek(Fremedios,0);
	  write(Fremedios,Bremedios);
	  close(Fremedios);
end;
(***************************************************************************)
Procedure open_Fremedios;
var
	io : integer;
	vo : boolean;
begin
	  vo:=false;
	  assign(Fremedios,'remedios.dat');
	  {$i-}
	  repeat
				reset(Fremedios);
				io:=ioresult;
				if io<>0 then
				begin
						if not(vo) then (* s¢ mostra a primeira vez*)
						status('Aguarde libera‡Æo de arquivo... (Remedios.Dat)');
						vo:=true;
				end;
				if io=2 then
				begin
					  cria_Fremedios;
					  reset(Fremedios);
				end;
	  until (io=0);
	  {$i+}
	  num_remedios:=filesize(Fremedios);
end;
(***************************************************************************)
Procedure close_Fremedios;
begin
	  close(Fremedios);
end;
(***************************************************************************)
procedure sobrenomeie_remed(var st2 : string39); {passa o sobren p/ frente}
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
(***************************************************************************)
Procedure exclui_remed (registro : integer);
begin
		open_Fremedios;
  	seek(Fremedios,registro);
	  read(Fremedios,Bremedios);
		Bremedios.AI:='I';
		seek(Fremedios,registro);
  	write(Fremedios,Bremedios);
		close(Fremedios);
end;


begin
end.