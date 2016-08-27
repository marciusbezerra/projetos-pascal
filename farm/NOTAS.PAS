(***********************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
***********************************************************************)
unit Notas;
(***********************************************************************)
interface
(***********************************************************************)
uses
	Kcrt,crt;
(****************************************************************************)
type
  TMedicamento = record
   Codigo     : integer;
   quantidade : integer;
   PG         : boolean;
  end;
  Tnota = record
   NumNf (*Codigo*) : longint;
   AI               : char;
   data             : string[10];
   hora             : string[5];
   CodOperad        : integer;
   CodCliente       : integer;
   Medicamento      : array [1..10] of Tmedicamento;
   pagto            : string[20];
 end;
(****************************************************************************)
Procedure Cria_FNotas;
Procedure Open_Fnotas;
Procedure Close_FNotas;
(****************************************************************************)
var
  FNotas : File of TNota;
  BNotas : TNota;
  Num_notas : Longint;
(****************************************************************************)
Implementation
(***************************************************************************)
Procedure zera_Notas;
begin
	  with BNotas do
	  begin
			 NumNf:=0;
			 ai    :='I';
          CodCliente:=0;
          {codMedicamento:=0;}
	  end;
end;
(****************************************************************************)
Procedure Cria_FNotas;
begin
	  zera_Notas;
{	  assign(FNotas,'Notas.dat'); }
	  rewrite(FNotas);
	  seek(FNotas,0);
	  write(FNotas,BNotas);
	  close(FNotas);
end;
(****************************************************************************)
Procedure open_FNotas;
var
	io : integer;
	vo : boolean;
begin
	  vo:=false;
	  assign(FNotas,'Notas.dat');
	  {$i-}
	  repeat
				reset(FNotas);
				io:=ioresult;
				if io<>0 then
				begin
						if not(vo) then (* s¢ mostra a primeira vez*)
						status('Aguarde libera‡Æo de arquivo...');
						vo:=true;
				end;
				if io=2 then
				begin
					  cria_FNotas;
					  reset(FNotas);
				end;
	  until (io=0);

	  {$i+}
	  num_Notas:=filesize(FNotas);
end;
(***************************************************************************)
Procedure close_FNotas;
begin
	  close(FNotas);
end;
(***************************************************************************)
begin
end.