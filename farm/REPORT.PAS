(**************************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
**************************************************************************)
Unit report;
(*************************************************************************)
Interface
(*************************************************************************)
Const
(*************************************************************************)
 rlClientes = 1;
 rlMedicamentos = 2;
 rlFornecedores = 3;
(*************************************************************************)
Procedure listagem(const cadastro : byte);
Procedure preenche(var st1 : string; const tam : byte);
Procedure etiquetas (tipo : byte);
Procedure carta (tipo : byte);
Procedure recibo;
Procedure relat_entradas;
Procedure relat_saidas;
(*************************************************************************)
Implementation
(*************************************************************************)
uses kcrt,crt,clientes,remedios,fornecs;
(**************************************************************************
 FAZ LISTAGEM DE REGISTROS SEQUENCIAL, CADASTRO ê O TIPO DA LISTAGEM
**************************************************************************)
Procedure listagem(const cadastro : byte);
var
  filename : string;
  filevar  : text;
  options  : string;
  relpos : integer;
  st1,st2,st3,st4,st5,st6 : string;
  stfinal : string;

Procedure escreve;
begin
  stfinal:='';
  if options[1]='1' then stfinal:=stfinal+st1;
  if options[2]='1' then stfinal:=stfinal+st2;
  if options[3]='1' then stfinal:=stfinal+st3;
  if options[4]='1' then stfinal:=stfinal+st4;
  if options[5]='1' then stfinal:=stfinal+st5;
  writeln(filevar,stfinal);
end;

begin
    salva_tela(3);
    filename:=randomiza_arquivo;
    assign(filevar,filename);
    rewrite(filevar);
    status('Escolha campos a imprimir - use Espaáo, PGUP e PGDN - Enter sai');
    case cadastro of
    rlclientes :
    begin
       menu(10,5,70,15,cmenu,fmenu,'Listagem de Clientes');
       most(12,7,cmenu,fmenu,'Selecione os campos a imprimir :');
       square(15,9,cmenu,fmenu,'Nome@Endereáo@RG@Cpf@Telefone');
       options:='110010';
       checkbox(12,9,5,options);
       if ok then
       begin
           relpos:=1;
           status('Aguarde.Gerando relat¢rio ...');
           open_Fclientes;
           if num_clientes=1 then
           begin
           close_Fclientes; close(filevar); erase(Filevar); erro('Nao h† clientes cadastrados !'); Volta_tela(3,false);
           exit;
           end;
           while not eof(Fclientes) do
           begin
           seek(Fclientes,relpos);
           read(Fclientes,Bclientes);
           inc(relpos,1);
           st1:=Bclientes.nome; preenche(st1,40);
           st2:=Bclientes.endereco; Preenche(st2,40);
           st3:=Bclientes.identidade; Preenche(st3,12);
           st4:=Bclientes.cpf; preenche(st4,12);
           st5:=Bclientes.telefone; preenche(st5,14);
           escreve;
           end;
           close_Fclientes;
           close(filevar);
           quickreport(filename,'Listagem de Clientes');
       end;
    end;

    rlmedicamentos :
    begin
       menu(10,5,70,15,cmenu,fmenu,'Listagem de Medicamentos');
       most(12,7,cmenu,fmenu,'Selecione os campos a imprimir :');
       square(15,9,cmenu,fmenu,'Descriá∆o@Preáo de Compra@Preáo de Venda@Estoque atual');
       options:='111100';
       checkbox(12,9,4,options);
       if ok then
       begin
           status('Aguarde.Gerando relat¢rio ...');
           relpos:=1;
           open_Fremedios;
           if num_remedios=1 then
           begin
           close_Fremedios; close(filevar);  erase(Filevar); erro('N∆o h† medicamentos cadastrados !');   Volta_tela(3,false);
           exit;
           end;
           while not eof(Fremedios) do
           begin
           seek(Fremedios,relpos);
           read(Fremedios,Bremedios);
           inc(relpos,1);
           st1:=Bremedios.nome; preenche(st1,40);
           st2:=Bremedios.precocompra; Preenche(st2,7);
           st3:=Bremedios.precovenda; preenche(st3,7);
           st4:=Bremedios.estoque; preenche(st4,4);
           escreve;
           end;
           close_Fclientes;
           close(filevar);
           quickreport(filename,'Listagem de Medicamentos');
       end;
    end;

    rlfornecedores :
    begin
       menu(10,5,70,15,cmenu,fmenu,'Listagem de Fornecedores');
       most(12,7,cmenu,fmenu,'Selecione os campos a imprimir :');
       square(15,9,cmenu,fmenu,'Nome@Endereáo@Nome Fantasia');
       options:='111000';
       checkbox(12,9,3,options);
       if ok then
       begin
           open_Ffornecs;
           if num_remedios=1 then
           begin
           close_Ffornecs;  close(filevar);  erase(Filevar); erro('Nao h† fornecedores cadastrados !');   Volta_tela(3,false);
           exit;
           end;
           status('Aguarde.Gerando relat¢rio ...');
           relpos:=1;
           while not eof(Ffornecs) do
           begin
           seek(Ffornecs,relpos);
           read(Ffornecs,Bfornecs);
           inc(relpos,1);
           st1:=Bfornecs.nome; preenche(st1,40);
           st2:=Bfornecs.endereco; Preenche(st2,7);
           st3:=Bfornecs.fantasia; preenche(st3,7);
           escreve;
           end;
           close_Ffornecs;
           close(filevar);
           quickreport(filename,'Listagem de Fornecedores');
       end;
    end;
    end;
    erase(Filevar);
    Volta_tela(3,false);
end;
(**************************************************************************
 Preenche uma string com tam caracteres p/ impress∆o
**************************************************************************)
Procedure preenche(var st1 : string; const tam : byte);
var
 cont : byte;
begin
    for cont:=1 to tam-length(st1) do
        st1:=st1+' ';
end;
(*************************************************************************)
Procedure etiquetas (tipo : byte);
var
 st1 : string;
 sob : byte;
begin
   salva_tela(1);
{   case tipo of
   rlclientes : menu(10,5,70,15,cmenu,fmenu,'Etiqueta para Clientes');
   rlMedicamentos : menu(10,5,70,15,cmenu,fmenu,'Etiqueta para Medicamentos');
   rlFornecedores : menu(10,5,70,15,cmenu,fmenu,'Etiqueta para Fornecedores');
   end; }
   menu(15,10,65,20,cmenu,fmenu,'Etiquetas');
   most(17,12,cmenu,fmenu,'Colunas por folha: [  ]');
   most(17,13,cmenu,fmenu,'Tamanho LxC (cm) : [     X     ]');
   st1:='';
   inputstring(st1,2,2,37,12,'N',sob);
   st1:='';
   inputstring(st1,5,5,37,13,'N',sob);
   st1:='';
   inputstring(st1,5,5,43,13,'N',sob);
   ok;
    volta_tela(1,false);
end;

(**************************************************************************)
Procedure carta (tipo : byte);
begin
     CASE tipo OF
     1 : quickreport('atraso.txt','Aviso de Pagamento');
     2 : quickreport('CHEQUE.txt','Cheque');
     3 : quickreport('NIVER.txt','Aniversarios');
     4 : quickreport('comp.txt','Comparecimento');
     end;

end;
(*************************************************************************)
Procedure recibo;
begin
     quickreport('recibo.txt','RECIBO');
end;
(*************************************************************************)
Procedure relat_saidas;
begin
    salva_tela(3);
    volta_tela(3,false);
end;


(*************************************************************************)
Procedure relat_entradas;
begin
    salva_tela(3);
    volta_tela(3,false);
end;


(*************************************************************************
 BLOCO PRINCIPAL
(**************************************************************************)

begin
end.