(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
***********************************************************************)
unit Clientes;
(***********************************************************************)
interface
(***********************************************************************)
uses
  crt,Kcrt;
(***********************************************************************)
type
    String39 = string [39]; (*por causa do sobrenomeie_cli*)
    Tcliente = record
		codigo      : integer;
		ai          : char;
		data        : string[10];
		nome        : string39;
		nasc        : string[10];
      FisJur      : string[1];
		sexo        : string[1];
      EstCivil    : string[15];
		endereco    : string[39];
		cidade      : string[19];
		cep         : string[10];
		estado      : string[2];
		telefone    : string[14];
		profissao   : string[19];
		empresa     : string[29];
		identidade  : string[12];
		cpf         : string[12];
		convenio    : string[39];
		email       : string[39];
		observacao  : string[39];
		end;
var
	Fclientes : file of TCliente;
	Bclientes : TCliente;
	Num_clientes : integer;
(***********************************************************************)
Procedure open_Fclientes;
Procedure close_Fclientes;
Procedure Cria_Fclientes;
Procedure zera_cli;
procedure sobrenomeie_cli(var st2 : string39);
Procedure menu_cli;
Procedure mostra_cli;
Procedure leit_cli(inc :boolean; var se_inclui : boolean);
Procedure exclui_cli (registro : integer);
(***********************************************************************)
implementation
(***********************************************************************)
uses
   conv;
(***********************************************************************
MENU DO CLIENTE
(**************************************************************************)
Procedure menu_cli;
begin
	  most(12,5,cmenu,fmenu,'C¢digo      : [     ]  ');
	  most(39,5,cmenu,fmenu,'Data da ficha : [          ]');
	  most(12,6,cmenu,fmenu,'Nome        : [                                       ]');
	  most(12,7,cmenu,fmenu,'Data nascim : [          ]');
	  most(12,8,cmenu,fmenu,'F°sica/Jurid: [ ] Sexo : [ ]');
     most(12,9,cmenu,fmenu,'Estado Civil: [               ]');
	  most(12,10,cmenu,fmenu,'Endereáo    : [                                       ]');
	  most(12,11,cmenu,fmenu,'Cidade      : [                   ]');
	  most(12,12,cmenu,fmenu,'Estado      : [  ]');
	  most(12,13,cmenu,fmenu,'Cep         : [          ]');
	  most(12,14,cmenu,fmenu,'Telefone    : [              ]');
	  most(12,15,cmenu,fmenu,'Profiss∆o   : [                   ]');
	  most(12,16,cmenu,fmenu,'Empresa     : [                             ]');
	  most(12,17,cmenu,fmenu,'Identidade  : [          ]');
	  most(12,18,cmenu,fmenu,'Cpf         : [            ]');
	  most(12,19,cmenu,fmenu,'Convànio    : [  ] ->');
	  most(12,20,cmenu,fmenu,'E-mail      : [                                       ]');
	  most(12,21,cmenu,fmenu,'Observaá∆o  : [                                       ]');
end;
(**************************************************************************
MOSTRA MEMORIA
(**************************************************************************)
Procedure mostra_cli;
begin
	  remost(56,5,cmenu,fmenu,Bclientes.data,10);
	  remost(27,5,cmenu,fmenu,inttostr(Bclientes.codigo),5);
	  remost(27,6,cmenu,fmenu,Bclientes.nome,39);
	  remost(27,7,cmenu,fmenu,Bclientes.nasc,10);
     remost(27,8,cmenu,fmenu,Bclientes.FisJur,1);
     remost(38,8,cmenu,fmenu,Bclientes.sexo,1);
     remost(27,9,cmenu,fmenu,Bclientes.EstCivil,15);
	  remost(27,10,cmenu,fmenu,Bclientes.endereco,39);
	  remost(27,11,cmenu,fmenu,Bclientes.cidade,19);
	  remost(27,12,cmenu,fmenu,Bclientes.estado,2);
	  remost(27,13,cmenu,fmenu,Bclientes.cep,10);
	  remost(27,14,cmenu,fmenu,Bclientes.telefone,14);
	  remost(27,15,cmenu,fmenu,Bclientes.profissao,19);
	  remost(27,16,cmenu,fmenu,Bclientes.empresa,29);
	  remost(27,17,cmenu,fmenu,Bclientes.identidade,10);
	  remost(27,18,cmenu,fmenu,Bclientes.cpf,12);
	  remost(27,19,cmenu,fmenu,Bclientes.convenio,2);
	  remost(27,20,cmenu,fmenu,Bclientes.email,39);
	  remost(27,21,cmenu,fmenu,Bclientes.observacao,39);
end;
(**************************************************************************
1VERIFICAR ESTADO
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
(* Le clientes - se inc for verdadeiro entao e inclusao
(* Se_inclui - retorna verdadeiro se cliente foi incluido
(**************************************************************************)
Procedure veja(ret_inp : byte;var sob : byte);
begin
	  if ret_inp=0 then sob:=sob-1;
	  if ret_inp=255 then sob:=255;
	  if ret_inp=1 then sob:=sob+1;
	  if sob=0 then sob:=1;
end;
(**************************************************************************)
(* Atualiza o c¢digo do cliente se dois est∆o sendo incluidos
(**************************************************************************)
Procedure atualiza;
begin
	 open_Fclientes;
	 gotoxy(27,5);
	 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
	 textbackground(fmenu);
	 write(Num_clientes);
	 close_Fclientes;
end;
(**************************************************************************
LEITURA
(**************************************************************************)
Procedure leit_cli(inc : boolean; var se_inclui : boolean);
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
			 open_Fclientes;
			 close_Fclientes;
			 zera_cli;
			 Bclientes.AI:='A';
			 Bclientes.codigo:=num_clientes;
			 gotoxy(27,5);
			 if fmenu>7 then textcolor(cmenu+16) else textcolor(cmenu);
			 textbackground(fmenu);
			 write(Bclientes.codigo);
			 Bclientes.data:=date;
	  end;
	  most(56,5,cmenu,fmenu,Bclientes.data);
	  sob:=1;
repeat {do YNC}
   YNC_leit:=0;
  repeat {do sob}
 	  if sob=1 then
	  begin
	  status('Digite nome completo do cliente');
	  st1:=Bclientes.nome;
	  inputstring(st1,39,39,27,6,'T',ret_inp);
	  Bclientes.nome:=st1;
	  remost(27,6,cmenu,fmenu,Bclientes.nome,39);
	  if st1='' then exit;
	  veja(ret_inp,sob);
	  (*se apertei pra cima sob:=sob-1*)
	  if inc then atualiza; (*rede*)
		end;

	  if sob=2 then
	  begin
	  status('Digite data de nascimento sem usar /   Ex. 290478');
	  most(27,7,cmenu,fmenu,'          ');
	  st1:=Bclientes.nasc;
	  if length(st1)=10 then
	  begin
			 delete(st1,3,1);
			 delete(st1,5,3);
	  end;
	  repeat
			  inputstring(st1,6,6,27,7,'N',ret_inp);
	  until (data_verify(st1)) or (st1='');
	  if (st1<>'') and (length(st1)=6) then
	  begin
			 insert('/19',st1,5);
			 insert('/',st1,3);
	  end;
	  Bclientes.nasc:=st1;
	  remost(27,7,cmenu,fmenu,Bclientes.nasc,10);
 {	  dt:=Bclientes.nasc;
	  delete(dt,7,2);
	  DayWeek(dt,DayNum,DayName);
	  most(40,7,cmenu,fmenu,dayname); }
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

     if sob=3 then
	  begin
     if inc then status('Escolha F°sica ou Jur°dica') else
     	  status('Digite F-F°sica ou J-Jur°dica');
     if (inc) and (Bclientes.FisJur='') then
        st1:=caixinha(25,7,'F÷SICA@JUR÷DICA')
     else
     begin
	  st1:=Bclientes.FisJur;
	  repeat
	  inputstring(st1,1,1,27,8,'T',ret_inp);
	  until (st1='F') or (st1='f') or (st1='J') or (st1='j') or (st1='');
     end;
	  Bclientes.FisJur:=st1;
	  remost(27,8,cmenu,fmenu,Bclientes.FisJur,1);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

     if sob=4 then
	  begin
	  if inc then status('Escolha sexo') else status('Digite sexo M-masculino ou F-feminino');
     if (inc) and (Bclientes.sexo='') then
       st1:=caixinha(35,7,'MASCULINO@FEMININO')
     else
     begin
	  st1:=Bclientes.sexo;
	  repeat
	  inputstring(st1,1,1,38,8,'T',ret_inp);
	  until (st1='M') or (st1='F') or (st1='m') or (st1='f') or (st1='');
     end;
	  Bclientes.sexo:=st1;
	  remost(38,8,cmenu,fmenu,Bclientes.sexo,1);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

     if sob=5 then
	  begin
     if inc then status('Escolha estado civil') else status('Digite estado civil');
     if (inc) and (Bclientes.estcivil='') then
       st1:=caixinha(25,8,'CASADO@SOLTEIRO@VIUVO@NOIVO@DIVORCIADO@COMPANHEIRO@SEPARADO@OUTROS')
     else
     begin
	  status('Digite Estado Civil do Cliente');
	  st1:=Bclientes.EstCivil;
	  inputstring(st1,15,15,27,9,'T',ret_inp);
     end;
	  Bclientes.EstCivil:=st1;
	  remost(27,9,cmenu,fmenu,Bclientes.EstCivil,15);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=6 then
	  begin
	  status('Digite endereáo completo (rua,n£mero,apto e bairro)');
	  st1:=Bclientes.endereco;
	  inputstring(st1,39,39,27,10,'T',ret_inp);
	  Bclientes.endereco:=st1;
	  remost(27,10,cmenu,fmenu,Bclientes.endereco,39);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=7 then
	  begin
	  status('Digite cidade em que reside o cliente (sem o estado)');
	  st1:=Bclientes.cidade;
	  inputstring(st1,19,19,27,11,'T',ret_inp);
  {  if st1='' then st1:='SANTIAGO';}
 	  Bclientes.cidade:=st1;
	  remost(27,11,cmenu,fmenu,Bclientes.cidade,19);
 	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=8 then
	  begin
	  status('Digite estado em que reside o Cliente');
	  st1:=Bclientes.estado;
	  repeat
	  inputstring(st1,2,2,27,12,'T',ret_inp);
 	  until (ver_estado(st1)) or (st1='');
	{ if st1='' then st1:='RS'; }
	  Bclientes.estado:=st1;
	  remost(27,12,cmenu,fmenu,Bclientes.estado,2);
 	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=9 then
	  begin
	  status('Digite o CEP da cidade ( N«O utilize . ou - )   Ex. 97700000');
	  most(27,13,cmenu,fmenu,'          ');
	  st1:=Bclientes.cep;
	  delete(st1,3,1);
	  delete(st1,6,1);
	  inputstring(st1,8,8,27,13,'N',ret_inp);
	  if (st1<>'') or (trunc(length(st1))=8) then
	  begin
			 insert('-',st1,3);
			 insert('.',st1,7);
	  end;
	{ if st1='' then st1:='97-700.000'; }
	  Bclientes.cep:=st1;
	  remost(27,13,cmenu,fmenu,Bclientes.cep,10);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;


	  if sob=10 then
	  begin
	  status('Digite telefone ( N«O utilize . ou - )   Ex. 0552511299');
	  most(27,14,cmenu,fmenu,'              ');
	  st1:=Bclientes.telefone;
	  delete(st1,1,1);
	  delete(st1,4,2);
	  delete(st1,7,1);
	  inputstring(st1,10,10,27,14,'N',ret_inp);
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
	  Bclientes.telefone:=st1;
	  remost(27,14,cmenu,fmenu,Bclientes.telefone,14);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=11 then
	  begin
	  status('Digite profiss∆o do cliente');
	  st1:=Bclientes.profissao;
	  inputstring(st1,19,19,27,15,'T',ret_inp);
	  Bclientes.profissao:=st1;
     remost(27,15,cmenu,fmenu,Bclientes.profissao,19);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

  	  if sob=12 then
	  begin
	  status('Digite empresa em que trabalha o cliente');
	  st1:=Bclientes.empresa;
	  inputstring(st1,29,29,27,16,'T',ret_inp);
 	  Bclientes.empresa:=st1;
	  remost(27,16,cmenu,fmenu,Bclientes.empresa,29);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=13 then
	  begin
	  status(' Digite RG da carteira de identidade');
	  st1:=Bclientes.identidade;
	  repeat
   	  inputstring(st1,10,10,27,17,'N',ret_inp);
	  until (st1='') or (length(st1)=10);
	  Bclientes.identidade:=st1;
	  remost(27,17,cmenu,fmenu,Bclientes.identidade,10);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=14 then
	  begin
	  status('Digite Numero do CPF e N«O utilize o "-" (traáo)');
	  st1:=Bclientes.cpf;
	  if st1<>'' then
		  delete(st1,10,1);
	  most(27,18,cmenu,fmenu,'            ');
	  repeat
	  inputstring(st1,11,11,27,18,'N',ret_inp);
	  until (st1='') or (length(st1)=11);
	  Bclientes.cpf:=st1;
	  if st1<>'' then
		  insert('-',Bclientes.cpf,10);
	  remost(27,18,cmenu,fmenu,Bclientes.cpf,12);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

	  if sob=15 then
	  begin
	  status('Digite c¢digo do convànio');
	  st1:=Bclientes.convenio;
	  inputstring(st1,2,2,27,19,'T',ret_inp);
	  Bclientes.convenio:=st1;
 	  remost(27,19,cmenu,fmenu,Bclientes.convenio,2);
	  veja(ret_inp,sob);
     open_FConv;
     if strtoint(st1)<Num_Conv then
     begin
     seek(FConv,strtoint(st1));
     read(FConv,BConv);
     end
     else
      erro('C¢digo de convànio inv†lido!');
    close_FConv;
    remost(33,19,cmenu,fmenu,BConv.nome,35);

	  if inc then atualiza; (*rede*)
	  end;

     if sob=16 then
	  begin
	  status('Digite o e-mail do cliente');
	  st1:=Bclientes.email;
	  inputstring(st1,39,39,27,20,'T',ret_inp);
	  Bclientes.email:=st1;
  	  remost(27,20,cmenu,fmenu,Bclientes.email,39);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

     if sob=17 then
	  begin
	  status('Digite uma observaá∆o qualquer para a ficha');
	  st1:=Bclientes.observacao;
	  inputstring(st1,39,39,27,21,'T',ret_inp);
	  Bclientes.observacao:=st1;
  	  remost(27,21,cmenu,fmenu,Bclientes.observacao,39);
	  veja(ret_inp,sob);
	  if inc then atualiza; (*rede*)
	  end;

 until (sob=18) or (sob=255); {do sob}
     YNC_leit:=YNC;
 	  if Bclientes.nome<>'' then
	  begin
			 case YNC_leit of
          YES :  begin
					   se_inclui:=true;
				 	   open_Fclientes;
					   if inc then Bclientes.codigo:=num_clientes; (*rede*)
					   seek(Fclientes,Bclientes.codigo);
					   write(Fclientes,Bclientes);
					   close_Fclientes;
			        end;
            NO : sob:=1;
            CANCEL : exit;
           end;
		end;
until (Bclientes.nome='') or (YNC_leit <> NO);
                             {se for NO volta a ler o mesmo de novo}
end;
(***************************************************************************
ZERA MEMORIA
(***************************************************************************)
Procedure zera_cli;
begin
	  with Bclientes do
	  begin
			 codigo      :=0;
			 ai          :='I';
			 data        :='';
       	 nome        :='';
          nasc        :='';
          fisjur      :='';
			 sexo        :='';
          estcivil    :='';
			 endereco    :='';
			 cidade      :='';
			 cep         :='';
			 estado      :='';
			 telefone    :='';
			 profissao   :='';
			 empresa     :='';
			 identidade  :='';
			 cpf         :='';
			 convenio    :='';
			 observacao  :='';
	  end;
end;
(***************************************************************************
CRIA ARQUIVO
(***************************************************************************)

Procedure Cria_Fclientes;
begin
	  zera_cli;
{	  assign(Fclientes,'clientes.dat'); }
	  rewrite(Fclientes);
	  seek(Fclientes,0);
	  write(Fclientes,Bclientes);
	  close(Fclientes);
end;
(***************************************************************************
ABRE ARQUIVO
(***************************************************************************)
Procedure open_Fclientes;
var
	io : integer;
	vo : boolean;
begin
	  vo:=false;
	  assign(Fclientes,'clientes.dat');
	  {$i-}
	  repeat
				reset(Fclientes);
				io:=ioresult;
				if io<>0 then
				begin
						if not(vo) then (* s¢ mostra a primeira vez*)
						status('Aguarde liberaá∆o de arquivo...');
						vo:=true;
				end;
				if io=2 then
				begin
					  cria_Fclientes;
					  reset(Fclientes);
				end;
	  until (io=0);

	  {$i+}
	  num_clientes:=filesize(Fclientes);
end;
(***************************************************************************
FECHA ARQUIVO
(***************************************************************************)
Procedure close_Fclientes;
begin
	  close(Fclientes);
end;
(***************************************************************************
PASSA O SOBRENOME PARA FRENTE
(***************************************************************************)
procedure sobrenomeie_cli(var st2 : string39); {passa o sobren p/ frente}
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
EXCLUIR UM CLIENTE
(***************************************************************************)
Procedure exclui_cli (registro : integer);
begin
	open_Fclientes;
  	seek(Fclientes,registro);
   read(Fclientes,Bclientes);
	Bclientes.AI:='I';
	seek(Fclientes,registro);
  	write(Fclientes,Bclientes);
	close(Fclientes);
end;
(***************************************************************************)
(***************************************************************************)
(***************************************************************************)
begin

end.