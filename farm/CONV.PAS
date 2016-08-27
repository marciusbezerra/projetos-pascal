(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
***********************************************************************)
unit Conv;
(***********************************************************************)
interface
(***********************************************************************)
uses
	crt,Kcrt;
(***********************************************************************)
type
    String39 = string [39]; (*por causa do sobrenomeie*)
    TConv = record
		codigo      : integer;
		ai          : char;
      nome        : string39;
		end;
var
	FConv : file of TConv;
	BConv : TConv;
	Num_Conv : integer;
(***********************************************************************)
Procedure open_FConv;
Procedure close_FConv;
Procedure Cria_FConv;
Procedure zera_Conv;
procedure sobrenomeie_Conv(var st2 : string39);
Procedure menu_Conv;
Procedure mostra_Conv;
Procedure leit_Conv(inc :boolean; var se_inclui : boolean);
Procedure exclui_Conv (registro : integer);
implementation
(***********************************************************************
MENU DO operad
(**************************************************************************)
Procedure menu_Conv;
begin
	  most(12,5,cmenu,fmenu,'C¢digo       : [     ]  ');
	  most(12,6,cmenu,fmenu,'Nome         : [                                       ]');
end;
(**************************************************************************
MOSTRA MEMORIA
(**************************************************************************)
Procedure mostra_Conv;
begin
 	  remost(28,5,cmenu,fmenu,inttostr(BConv.codigo),5);
	  remost(28,6,cmenu,fmenu,BConv.nome,39);
end;
(**************************************************************************)
(* Le Conv - se inc for verdadeiro entao e inclusao
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
(* Atualiza o c¢digo do operad se dois estÆo sendo incluidos
(**************************************************************************)
Procedure atualiza;
begin
	 open_FConv;
	 gotoxy(28,5);
	 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
	 textbackground(fmenu);
	 write(Num_Conv);
	 close_FConv;
end;
(**************************************************************************
LEITURA
(**************************************************************************)
Procedure leit_conv(inc : boolean; var se_inclui : boolean);
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
			 open_FConv;
			 close_FConv;
			 zera_conv;
			 BConv.AI:='A';
			 BConv.codigo:=num_Conv;
			 gotoxy(28,5);
			 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
			 textbackground(fmenu);
			 write(BConv.codigo);
	  end;
	  sob:=1;

repeat {do YNC}

  YNC_leit:=0;
  repeat {do sob}

 	  if sob=1 then
	  begin
	  status('Digite nome do convˆnio');
	  st1:=BConv.nome;
	  inputstring(st1,39,39,28,6,'T',ret_inp);
	  BConv.nome:=st1;
	  remost(28,6,cmenu,fmenu,BConv.nome,39);
     if st1='' then exit;
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	 end;

until (sob=2) or (sob=255); {do sob}
                   (*ESC*)
     YNC_leit:=YNC;
 	  if BConv.nome<>'' then
	  begin
			 case YNC_leit of
          YES :  begin
					   se_inclui:=true;
				 	   open_FConv;
					   if inc then BConv.codigo:=num_Conv; (*rede*)
					   seek(FConv,BConv.codigo);
					   write(FConv,BConv);
					   close_FConv;
			        end;
            NO : sob:=1;
            CANCEL : exit;
           end;
		end;
until (BConv.nome='') or (YNC_leit <> NO);
                             {se for NO volta a ler o mesmo de novo}
end;
(***************************************************************************
ZERA MEMORIA
(***************************************************************************)
Procedure zera_conv;
begin
	  with BConv do
	  begin
			 codigo      :=0;
			 ai          :='I';
          nome    :='';
	  end;
end;
(***************************************************************************
CRIA ARQUIVO
(***************************************************************************)
Procedure Cria_FConv;
begin
	  zera_conv;
{	  assign(FConv,'Conv.dat'); }
	  rewrite(FConv);
	  seek(FConv,0);
	  write(FConv,BConv);
	  close(FConv);
end;
(***************************************************************************
ABRE ARQUIVO
(***************************************************************************)
Procedure open_FConv;
var
	io : integer;
	vo : boolean;
begin
	  vo:=false;
	  assign(FConv,'Conv.dat');
	  {$i-}
	  repeat
				reset(FConv);
				io:=ioresult;
				if io<>0 then
				begin
						if not(vo) then (* s¢ mostra a primeira vez*)
						status('Aguarde libera‡Æo de arquivo...');
						vo:=true;
				end;
				if io=2 then
				begin
					  cria_FConv;
					  reset(FConv);
				end;
	  until (io=0);
	  {$i+}
	  num_Conv:=filesize(FConv);
end;
(***************************************************************************
FECHA ARQUIVO
(***************************************************************************)
Procedure close_FConv;
begin
	  close(FConv);
end;
(***************************************************************************
PASSA O SOBRENOME PARA FRENTE
(***************************************************************************)
procedure sobrenomeie_conv(var st2 : string39); {passa o sobren p/ frente}
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
Procedure exclui_conv (registro : integer);
begin
	open_FConv;
  	seek(FConv,registro);
   read(FConv,BConv);
	BConv.AI:='I';
	seek(FConv,registro);
  	write(FConv,BConv);
	close(FConv);
end;
(***************************************************************************)
(***************************************************************************)
(***************************************************************************)
begin

end.