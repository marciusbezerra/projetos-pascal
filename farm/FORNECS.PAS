(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
***********************************************************************)
unit Fornecs;
(***********************************************************************)
interface
(***********************************************************************)
uses
	Kcrt,crt;
(***********************************************************************)
type
    String39 = string [39]; (*por causa do sobrenomeie*)
    Tfornec = record
		codigo      : integer;
		ai          : char;
      fantasia    : string39;
      nome        : string[39];
		endereco    : string[39];
		cidade      : string[19];
		cep         : string[10];
		estado      : string[2];
      telefone    : string[14];
      cgc         : string[15];
      inscest     : string[15];
      email       : string[39];
      observacao  : string[39];
		end;
var
	Ffornecs : file of Tfornec;
	Bfornecs : Tfornec;
	Num_fornecs : integer;
(***********************************************************************)
Procedure open_Ffornecs;
Procedure close_Ffornecs;
Procedure Cria_Ffornecs;
Procedure zera_fornec;
procedure sobrenomeie_fornec(var st2 : string39);
Procedure menu_fornec;
Procedure mostra_fornec;
Procedure leit_fornec(inc :boolean; var se_inclui : boolean);
Procedure exclui_fornec (registro : integer);
implementation
(***********************************************************************
MENU DO fornec
(**************************************************************************)
Procedure menu_fornec;
begin
	  most(12,5,cmenu,fmenu,'C¢digo       : [     ]  ');
	  most(12,6,cmenu,fmenu,'Nome Fantasia: [                                       ]');
     most(12,7,cmenu,fmenu,'Raz∆o Social : [                                       ]');
	  most(12,8,cmenu,fmenu,'Endereáo     : [                                       ]');
	  most(12,9,cmenu,fmenu,'Cidade       : [                   ]');
	  most(12,10,cmenu,fmenu,'Estado       : [  ]');
	  most(12,11,cmenu,fmenu,'Cep          : [          ]');
	  most(12,12,cmenu,fmenu,'Telefone     : [              ]');
     most(12,13,cmenu,fmenu,'CGC          : [               ]');
	  most(12,14,cmenu,fmenu,'Insc.Estadual: [               ]');
	  most(12,15,cmenu,fmenu,'E-mail       : [                                       ]');
	  most(12,16,cmenu,fmenu,'Observaá∆o   : [                                       ]');
end;
(**************************************************************************
MOSTRA MEMORIA
(**************************************************************************)
Procedure mostra_fornec;
begin
 	  remost(28,5,cmenu,fmenu,inttostr(Bfornecs.codigo),5);
     remost(28,6,cmenu,fmenu,Bfornecs.fantasia,39);
	  remost(28,7,cmenu,fmenu,Bfornecs.nome,39);
	  remost(28,8,cmenu,fmenu,Bfornecs.endereco,39);
	  remost(28,9,cmenu,fmenu,Bfornecs.cidade,19);
	  remost(28,10,cmenu,fmenu,Bfornecs.estado,2);
	  remost(28,11,cmenu,fmenu,Bfornecs.cep,10);
	  remost(28,12,cmenu,fmenu,Bfornecs.telefone,14);
     remost(28,13,cmenu,fmenu,Bfornecs.cgc,15);
	  remost(28,14,cmenu,fmenu,Bfornecs.inscest,15);
	  remost(28,15,cmenu,fmenu,Bfornecs.email,39);
	  remost(28,16,cmenu,fmenu,Bfornecs.observacao,39);
end;
(**************************************************************************
VERIFICAR ESTADO
(**************************************************************************)
Function ver_estado(st1 : string) : boolean;
var
	i : byte;
begin
	  ver_estado:=false;
	  for i:=1 to length(st1) do
			st1[i]:=upcase(st1[i]);
	  if (st1='RS') or  (st1='SC') or (st1='PR') or  (st1='SP') or
		  (st1='RJ') or  (st1='MS') or (st1='MT') or  (st1='ES') or
		  (st1='TO') or  (st1='AL') or (st1='PA') or  (st1='PI') or
		  (st1='RN') or  (st1='RO') or (st1='RR') or  (st1='GO') or
		  (st1='AP') or  (st1='PE') or (st1='SE') or  (st1='DF') then
		  ver_estado:=true;
end;
(**************************************************************************)
(* Le fornecs - se inc for verdadeiro entao e inclusao
(* Se_inclui - retorna verdadeiro se fornec foi incluido
(**************************************************************************)
Procedure veja(ret_inp : byte;var sob : byte);
begin
	  if ret_inp=0 then sob:=sob-1;
	  if ret_inp=255 then sob:=255;
	  if ret_inp=1 then sob:=sob+1;
	  if sob=0 then sob:=1;
end;
(**************************************************************************)
(* Atualiza o c¢digo do fornec se dois est∆o sendo incluidos
(**************************************************************************)
Procedure atualiza;
begin
	 open_Ffornecs;
	 gotoxy(28,5);
	 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
	 textbackground(fmenu);
	 write(Num_fornecs);
	 close_Ffornecs;
end;
(**************************************************************************
LEITURA
(**************************************************************************)
Procedure leit_fornec(inc : boolean; var se_inclui : boolean);
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
			 open_Ffornecs;
			 close_Ffornecs;
			 zera_fornec;
			 Bfornecs.AI:='A';
			 Bfornecs.codigo:=num_fornecs;
			 gotoxy(28,5);
			 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
			 textbackground(fmenu);
			 write(Bfornecs.codigo);
	  end;
	  sob:=1;

repeat {do YNC}

  YNC_leit:=0;
  repeat {do sob}

 	  if sob=1 then
	  begin
	  status('Digite nome fantasia do fornecedor');
	  st1:=Bfornecs.fantasia;
	  inputstring(st1,39,39,28,6,'T',ret_inp);
	  Bfornecs.fantasia:=st1;
	  remost(28,6,cmenu,fmenu,Bfornecs.fantasia,39);
     if st1='' then exit;
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
	 end;

	  if sob=2 then
	  begin
	  status('Digite nome/raz∆o social do fornecedor');
     st1:=Bfornecs.nome;
	  inputstring(st1,39,39,28,7,'T',ret_inp);
	  Bfornecs.nome:=st1;
	  remost(28,7,cmenu,fmenu,Bfornecs.nome,39);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
     end;

	  if sob=3 then
	  begin
	  status('Digite endereáo completo (rua,n£mero,apto e bairro)');
	  st1:=Bfornecs.endereco;
 	  inputstring(st1,39,39,28,8,'T',ret_inp);
	  Bfornecs.endereco:=st1;
	  remost(28,8,cmenu,fmenu,Bfornecs.endereco,39);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=4 then
	  begin
	  status('Digite cidade');
	  st1:=Bfornecs.cidade;
	  inputstring(st1,19,19,28,9,'T',ret_inp);
 	  Bfornecs.cidade:=st1;
	  remost(28,9,cmenu,fmenu,Bfornecs.cidade,19);
 	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=5 then
	  begin
	  status('Digite estado');
	  st1:=Bfornecs.estado;
	  repeat
	  inputstring(st1,2,2,28,10,'T',ret_inp);
 	  until (ver_estado(st1)) or (st1='');
	  Bfornecs.estado:=st1;
	  remost(28,10,cmenu,fmenu,Bfornecs.estado,2);
 	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=6 then
	  begin
	  status('Digite o CEP da cidade ( N«O utilize . ou - )   Ex. 97700000');
	  most(28,11,cmenu,fmenu,'          ');
	  st1:=Bfornecs.cep;
	  delete(st1,3,1);
	  delete(st1,6,1);
	  inputstring(st1,8,8,28,11,'N',ret_inp);
	  if (st1<>'') or (trunc(length(st1))=8) then
	  begin
			 insert('-',st1,3);
			 insert('.',st1,7);
	  end;
	  Bfornecs.cep:=st1;
	  remost(28,11,cmenu,fmenu,Bfornecs.cep,10);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;


	  if sob=7 then
	  begin
	  status('Digite telefone ( N«O utilize . ou - )   Ex. 0552511299');
	  most(28,12,cmenu,fmenu,'              ');
	  st1:=Bfornecs.telefone;
	  delete(st1,1,1);
	  delete(st1,4,2);
	  delete(st1,7,1);
	  inputstring(st1,10,10,28,12,'N',ret_inp);
	  if length(st1)=7 then
		  insert('055',st1,1);
	  if length(st1)=4 then
		  insert('055251',st1,1);
	  if st1<>'' then
	  begin
			 if st1[1]='0' then
			 begin
					insert('(',st1,1);
					insert(') ',st1,5);
					insert('.',st1,10);
			 end;
	  end;
	  Bfornecs.telefone:=st1;
	  remost(28,12,cmenu,fmenu,Bfornecs.telefone,14);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

     if sob=8 then
	  begin
	  status('Digite cgc do fornecedor');
	  st1:=Bfornecs.cgc;
	  inputstring(st1,15,15,28,13,'T',ret_inp);
	  Bfornecs.cgc:=st1;
  	  remost(28,13,cmenu,fmenu,Bfornecs.cgc,15);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

     if sob=9 then
	  begin
	  status('Digite Inscriá∆o Estadual do fornecedor');
	  st1:=Bfornecs.inscest;
	  inputstring(st1,15,15,28,14,'T',ret_inp);
	  Bfornecs.inscest:=st1;
  	  remost(28,14,cmenu,fmenu,Bfornecs.inscest,15);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

     if sob=10 then
	  begin
	  status('Digite E-Mail do fornecedor');
	  st1:=Bfornecs.email;
	  inputstring(st1,39,39,28,15,'T',ret_inp);
	  Bfornecs.email:=st1;
  	  remost(28,15,cmenu,fmenu,Bfornecs.email,39);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

     if sob=11 then
	  begin
	  status('Digite uma observaá∆o qualquer para a ficha');
	  st1:=Bfornecs.observacao;
	  inputstring(st1,39,39,28,16,'T',ret_inp);
	  Bfornecs.observacao:=st1;
  	  remost(28,16,cmenu,fmenu,Bfornecs.observacao,39);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;


 until (sob=12) or (sob=255); {do sob}
                   (*ESC*)
     YNC_leit:=YNC;
 	  if Bfornecs.fantasia<>'' then
	  begin
			 case YNC_leit of
          YES :  begin
					   se_inclui:=true;
				 	   open_Ffornecs;
					   if inc then Bfornecs.codigo:=num_fornecs; (*rede*)
					   seek(Ffornecs,Bfornecs.codigo);
					   write(Ffornecs,Bfornecs);
					   close_Ffornecs;
			        end;
            NO : sob:=1;
            CANCEL : exit;
           end;
		end;
until (Bfornecs.fantasia='') or (YNC_leit <> NO);
                             {se for NO volta a ler o mesmo de novo}
end;
(***************************************************************************
ZERA MEMORIA
(***************************************************************************)
Procedure zera_fornec;
begin
	  with Bfornecs do
	  begin
			 codigo      :=0;
			 ai          :='I';
          fantasia    :='';
       	 nome        :='';
      	 endereco    :='';
			 cidade      :='';
			 cep         :='';
			 estado      :='';
			 telefone    :='';
          cgc :='';
          inscest:='';
          email:='';
			 observacao  :='';
	  end;
end;
(***************************************************************************
CRIA ARQUIVO
(***************************************************************************)
Procedure Cria_Ffornecs;
begin
	  zera_fornec;
{	  assign(Ffornecs,'fornecs.dat'); }
	  rewrite(Ffornecs);
	  seek(Ffornecs,0);
	  write(Ffornecs,Bfornecs);
	  close(Ffornecs);
end;
(***************************************************************************
ABRE ARQUIVO
(***************************************************************************)
Procedure open_Ffornecs;
var
	io : integer;
	vo : boolean;
begin
	  vo:=false;
	  assign(Ffornecs,'fornecs.dat');
	  {$i-}
	  repeat
				reset(Ffornecs);
				io:=ioresult;
				if io<>0 then
				begin
						if not(vo) then (* s¢ mostra a primeira vez*)
						status('Aguarde liberaá∆o de arquivo...');
						vo:=true;
				end;
				if io=2 then
				begin
					  cria_Ffornecs;
					  reset(Ffornecs);
				end;
	  until (io=0);
	  {$i+}
	  num_fornecs:=filesize(Ffornecs);
end;
(***************************************************************************
FECHA ARQUIVO
(***************************************************************************)
Procedure close_Ffornecs;
begin
	  close(Ffornecs);
end;
(***************************************************************************
PASSA O SOBRENOME PARA FRENTE
(***************************************************************************)
procedure sobrenomeie_fornec(var st2 : string39); {passa o sobren p/ frente}
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
EXCLUIR UM fornec
(***************************************************************************)
Procedure exclui_fornec (registro : integer);
begin
	open_Ffornecs;
  	seek(Ffornecs,registro);
   read(Ffornecs,Bfornecs);
	Bfornecs.AI:='I';
	seek(Ffornecs,registro);
  	write(Ffornecs,Bfornecs);
	close(Ffornecs);
end;
(***************************************************************************)
(***************************************************************************)
(***************************************************************************)
begin

end.