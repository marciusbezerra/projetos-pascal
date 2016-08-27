(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
***********************************************************************)
unit Medicos;
(***********************************************************************)
interface
(***********************************************************************)
uses
	Kcrt,crt;
(***********************************************************************)
type
    String39 = string [39]; (*por causa do sobrenomeie*)
    TMedicos = record
		codigo      : integer;
		ai          : char;
      nome        : string39;
		endereco    : string[39];
		fone        : string[10];
      reg         : string[10];
		end;
var
	FMedicos : file of TMedicos;
	BMedicos : TMedicos;
	Num_Medicos : integer;
(***********************************************************************)
Procedure open_FMedicos;
Procedure close_FMedicos;
Procedure Cria_FMedicos;
Procedure zera_medicos;
procedure sobrenomeie_medicos(var st2 : string39);
Procedure menu_medicos;
Procedure mostra_medicos;
Procedure leit_medicos(inc :boolean; var se_inclui : boolean);
Procedure exclui_medicos (registro : integer);
implementation
(***********************************************************************
MENU DO operad
(**************************************************************************)
Procedure menu_medicos;
begin
	  most(12,5,cmenu,fmenu,'C¢digo       : [     ]  ');
	  most(12,6,cmenu,fmenu,'Nome      Dr.: [                                       ]');
     most(12,7,cmenu,fmenu,'Endere‡o     : [                                       ]');
	  most(12,8,cmenu,fmenu,'Telefone     : [          ]');
	  most(12,9,cmenu,fmenu,'Registro     : [          ]');
end;
(**************************************************************************
MOSTRA MEMORIA
(**************************************************************************)
Procedure mostra_medicos;
begin
 	  remost(28,5,cmenu,fmenu,inttostr(BMedicos.codigo),5);
	  remost(28,6,cmenu,fmenu,BMedicos.nome,39);
	  remost(28,7,cmenu,fmenu,BMedicos.endereco,39);
	  remost(28,8,cmenu,fmenu,BMedicos.fone,10);
	  remost(28,9,cmenu,fmenu,BMedicos.reg,10);
end;
(**************************************************************************)
(* Le Medicos - se inc for verdadeiro entao e inclusao
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
	 open_FMedicos;
	 gotoxy(28,5);
	 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
	 textbackground(fmenu);
	 write(Num_Medicos);
	 close_FMedicos;
end;
(**************************************************************************
LEITURA
(**************************************************************************)
Procedure leit_medicos(inc : boolean; var se_inclui : boolean);
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
			 open_FMedicos;
			 close_FMedicos;
			 zera_medicos;
			 BMedicos.AI:='A';
			 BMedicos.codigo:=num_Medicos;
			 gotoxy(28,5);
			 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
			 textbackground(fmenu);
			 write(BMedicos.codigo);
	  end;
	  sob:=1;

repeat {do YNC}

  YNC_leit:=0;
  repeat {do sob}

 	  if sob=1 then
	  begin
	  status('Digite nome do m‚dico');
	  st1:=BMedicos.nome;
	  inputstring(st1,39,39,28,6,'T',ret_inp);
	  BMedicos.nome:=st1;
	  remost(28,6,cmenu,fmenu,BMedicos.nome,39);
     if st1='' then exit;
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	 end;

	  if sob=2 then
	  begin
	  status('Digite endere‡o do m‚dico');
     st1:=BMedicos.endereco;
	  inputstring(st1,39,39,28,7,'T',ret_inp);
	  BMedicos.endereco:=st1;
	  remost(28,7,cmenu,fmenu,BMedicos.endereco,39);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
     end;

	  if sob=3 then
	  begin
	  status('Digite telefone do m‚dico');
	  st1:=BMedicos.fone;
 	  inputstring(st1,10,10,28,8,'T',ret_inp);
	  BMedicos.fone:=st1;
	  remost(28,8,cmenu,fmenu,BMedicos.fone,10);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=4 then
	  begin
	  status('Digite registro do m‚dico');
	  st1:=BMedicos.reg;
	  inputstring(st1,10,10,28,9,'T',ret_inp);
 	  BMedicos.reg:=st1;
	  remost(28,9,cmenu,fmenu,BMedicos.reg,10);
 	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;


 until (sob=5) or (sob=255); {do sob}
                   (*ESC*)
     YNC_leit:=YNC;
 	  if BMedicos.nome<>'' then
	  begin
			 case YNC_leit of
          YES :  begin
					   se_inclui:=true;
				 	   open_FMedicos;
					   if inc then BMedicos.codigo:=num_Medicos; (*rede*)
					   seek(FMedicos,BMedicos.codigo);
					   write(FMedicos,BMedicos);
					   close_FMedicos;
			        end;
            NO : sob:=1;
            CANCEL : exit;
           end;
		end;
until (BMedicos.nome='') or (YNC_leit <> NO);
                             {se for NO volta a ler o mesmo de novo}
end;
(***************************************************************************
ZERA MEMORIA
(***************************************************************************)
Procedure zera_medicos;
begin
	  with BMedicos do
	  begin
			 codigo      :=0;
			 ai          :='I';
          nome    :='';
       	 fone   :='';
      	 endereco   :='';
			 reg:='';
	  end;
end;
(***************************************************************************
CRIA ARQUIVO
(***************************************************************************)
Procedure Cria_FMedicos;
begin
	  zera_medicos;
{	  assign(FMedicos,'Medicos.dat'); }
	  rewrite(FMedicos);
	  seek(FMedicos,0);
	  write(FMedicos,BMedicos);
	  close(FMedicos);
end;
(***************************************************************************
ABRE ARQUIVO
(***************************************************************************)
Procedure open_FMedicos;
var
	io : integer;
	vo : boolean;
begin
	  vo:=false;
	  assign(FMedicos,'Medicos.dat');
	  {$i-}
	  repeat
				reset(FMedicos);
				io:=ioresult;
				if io<>0 then
				begin
						if not(vo) then (* s¢ mostra a primeira vez*)
						status('Aguarde libera‡Æo de arquivo...');
						vo:=true;
				end;
				if io=2 then
				begin
					  cria_FMedicos;
					  reset(FMedicos);
				end;
	  until (io=0);
	  {$i+}
	  num_Medicos:=filesize(FMedicos);
end;
(***************************************************************************
FECHA ARQUIVO
(***************************************************************************)
Procedure close_FMedicos;
begin
	  close(FMedicos);
end;
(***************************************************************************
PASSA O SOBRENOME PARA FRENTE
(***************************************************************************)
procedure sobrenomeie_medicos(var st2 : string39); {passa o sobren p/ frente}
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
Procedure exclui_medicos (registro : integer);
begin
	open_FMedicos;
  	seek(FMedicos,registro);
   read(FMedicos,BMedicos);
	BMedicos.AI:='I';
	seek(FMedicos,registro);
  	write(FMedicos,BMedicos);
	close(FMedicos);
end;
(***************************************************************************)
(***************************************************************************)
(***************************************************************************)
begin

end.