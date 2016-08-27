(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br


  Cadastro Entrads de Entradas
  Cont‚m os procedimentos para :
  abertura,fechamento do cadastro de Entrads de Entradas
  define os tipos e vari veis da Entrad fiscal de Entrada
***********************************************************************)
unit Entrad;
(***********************************************************************)
interface
(***********************************************************************)
uses
	Kcrt,crt;
(****************************************************************************)
type
  TMedicamento = record
   Codigo     : integer;
   preco      : string[7];
   quantidade : integer;
   PG         : boolean;
  end;
  TEntrad = record
   NumNf (*Codigo*) : longint;
   numero           : string[8];
   AI               : char;
   codfornecedor    : integer;
   dataentrad       : string[10];
   dataemissao      : string[10];
   codfiscal        : string[3];
   frete            : string[7];
   serie            : string[5];
   total            : string[7];
   CodCliente       : integer;
   Medicamento      : array [1..10] of Tmedicamento;
 end;
(****************************************************************************)
Procedure Cria_FEntrad;
Procedure Open_FEntrad;
Procedure Close_FEntrad;
(****************************************************************************)
var
  FEntrad : File of TEntrad;
  BEntrad : TEntrad;
  Num_Entrad : Longint;
(****************************************************************************)
Implementation
(***************************************************************************)
Procedure zera_Entrad;
begin
	  with BEntrad do
	  begin
			 NumNf:=0;
			 ai    :='I';
          CodCliente:=0;
          {codMedicamento:=0;}
	  end;
end;
(****************************************************************************)
Procedure Cria_FEntrad;
begin
	  zera_Entrad;
	  rewrite(FEntrad);
	  seek(FEntrad,0);
	  write(FEntrad,BEntrad);
	  close(FEntrad);
end;
(****************************************************************************)
Procedure open_FEntrad;
var
	io : integer;
	vo : boolean;
begin
	  vo:=false;
	  assign(FEntrad,'Entrad.dat');
	  {$i-}
	  repeat
				reset(FEntrad);
				io:=ioresult;
				if io<>0 then
				begin
						if not(vo) then (* s¢ mostra a primeira vez*)
						status('Aguarde libera‡Æo de arquivo...');
						vo:=true;
				end;
				if io=2 then
				begin
					  cria_FEntrad;
					  reset(FEntrad);
				end;
	  until (io=0);

	  {$i+}
	  num_Entrad:=filesize(FEntrad);
end;
(***************************************************************************)
Procedure close_FEntrad;
begin
	  close(FEntrad);
end;
(***************************************************************************)
begin
end.