(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
***********************************************************************)
unit Grupos;
(***********************************************************************)
interface
(***********************************************************************)
uses
	Kcrt,crt;
(***********************************************************************)
type
    String39 = string [39]; (*por causa do sobrenomeie*)
    TGrupos = record
		codigo      : integer;
		ai          : char;
      nome        : string39;
		end;
var
	FGrupos : file of TGrupos;
	BGrupos : TGrupos;
	Num_Grupos : integer;
(***********************************************************************)
Procedure open_FGrupos;
Procedure close_FGrupos;
Procedure Cria_FGrupos;
Procedure zera_Grupos;
procedure sobrenomeie_Grupos(var st2 : string39);
Procedure menu_Grupos;
Procedure mostra_Grupos;
Procedure leit_Grupos(inc :boolean; var se_inclui : boolean);
Procedure exclui_Grupos (registro : integer);
implementation
(***********************************************************************
MENU DO operad
(**************************************************************************)
Procedure menu_Grupos;
begin
	  most(12,5,cmenu,fmenu,'C¢digo       : [     ]  ');
	  most(12,6,cmenu,fmenu,'Grupo tipo   : [                                       ]');
end;
(**************************************************************************
MOSTRA MEMORIA
(**************************************************************************)
Procedure mostra_Grupos;
begin
 	  remost(28,5,cmenu,fmenu,inttostr(BGrupos.codigo),5);
	  remost(28,6,cmenu,fmenu,BGrupos.nome,39);
end;
(**************************************************************************)
(* Le Grupos - se inc for verdadeiro entao e inclusao
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
	 open_FGrupos;
	 gotoxy(28,5);
	 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
	 textbackground(fmenu);
	 write(Num_Grupos);
	 close_FGrupos;
end;
(**************************************************************************
LEITURA
(**************************************************************************)
Procedure leit_Grupos(inc : boolean; var se_inclui : boolean);
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
			 open_FGrupos;
			 close_FGrupos;
			 zera_Grupos;
			 BGrupos.AI:='A';
			 BGrupos.codigo:=num_Grupos;
			 gotoxy(28,5);
			 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
			 textbackground(fmenu);
			 write(BGrupos.codigo);
	  end;
	  sob:=1;

repeat {do YNC}

  YNC_leit:=0;
  repeat {do sob}

 	  if sob=1 then
	  begin
	  status('Digite nome do Grupo');
	  st1:=BGrupos.nome;
	  inputstring(st1,39,39,28,6,'T',ret_inp);
	  BGrupos.nome:=st1;
	  remost(28,6,cmenu,fmenu,BGrupos.nome,39);
     if st1='' then exit;
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	 end;

until (sob=2) or (sob=255); {do sob}
                   (*ESC*)
     YNC_leit:=YNC;
 	  if BGrupos.nome<>'' then
	  begin
			 case YNC_leit of
          YES :  begin
					   se_inclui:=true;
				 	   open_FGrupos;
					   if inc then BGrupos.codigo:=num_Grupos; (*rede*)
					   seek(FGrupos,BGrupos.codigo);
					   write(FGrupos,BGrupos);
					   close_FGrupos;
			        end;
            NO : sob:=1;
            CANCEL : exit;
           end;
		end;
until (BGrupos.nome='') or (YNC_leit <> NO);
                             {se for NO volta a ler o mesmo de novo}
end;
(***************************************************************************
ZERA MEMORIA
(***************************************************************************)
Procedure zera_Grupos;
begin
	  with BGrupos do
	  begin
			 codigo      :=0;
			 ai          :='I';
          nome    :='';
	  end;
end;
(***************************************************************************
CRIA ARQUIVO
(***************************************************************************)
Procedure Cria_FGrupos;
begin
	  zera_Grupos;
{	  assign(FGrupos,'Grupos.dat'); }
	  rewrite(FGrupos);
	  seek(FGrupos,0);
	  write(FGrupos,BGrupos);
	  close(FGrupos);
end;
(***************************************************************************
ABRE ARQUIVO
(***************************************************************************)
Procedure open_FGrupos;
var
	io : integer;
	vo : boolean;
begin
	  vo:=false;
	  assign(FGrupos,'Grupos.dat');
	  {$i-}
	  repeat
				reset(FGrupos);
				io:=ioresult;
				if io<>0 then
				begin
						if not(vo) then (* s¢ mostra a primeira vez*)
						status('Aguarde libera‡Æo de arquivo...');
						vo:=true;
				end;
				if io=2 then
				begin
					  cria_FGrupos;
					  reset(FGrupos);
				end;
	  until (io=0);
	  {$i+}
	  num_Grupos:=filesize(FGrupos);
end;
(***************************************************************************
FECHA ARQUIVO
(***************************************************************************)
Procedure close_FGrupos;
begin
	  close(FGrupos);
end;
(***************************************************************************
PASSA O SOBRENOME PARA FRENTE
(***************************************************************************)
procedure sobrenomeie_Grupos(var st2 : string39); {passa o sobren p/ frente}
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
EXCLUIR
(***************************************************************************)
Procedure exclui_Grupos (registro : integer);
begin
	open_FGrupos;
  	seek(FGrupos,registro);
   read(FGrupos,BGrupos);
	BGrupos.AI:='I';
	seek(FGrupos,registro);
  	write(FGrupos,BGrupos);
	close(FGrupos);
end;
(***************************************************************************)
(***************************************************************************)
(***************************************************************************)
begin

end.