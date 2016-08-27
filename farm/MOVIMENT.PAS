(*****************************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
*****************************************************************************)
Unit Moviment;
(***************************************************************************)
interface
(***************************************************************************)
const
   ctprazo = 1;
   ctcheque = 2;
   ctconvenio = 3;
(***************************************************************************)
Procedure Saidas;
Procedure Entradas;
Procedure terminal_cliente;
Procedure conta(const tipo : byte);
(****************************************************************************)
Implementation
(****************************************************************************)
uses printer,Notas,cadastro,clientes,remedios,kcrt,crt,operads,entrad,fornecs;
(****************************************************************************)
Procedure Leit_Nota_Saida;
var
   linha,proc,flag : byte;
   cont : integer;
   qtdade : string;
   sobqtdade : byte;
   subtotal,total,icms  : real;
   cod_now : integer;
   selpag,retpag : byte;
   st1 : string;
   retst1 : byte;
begin
 repeat (*DO CLIENTE ATE SER ZERO*)
   for cont:=1 to 10 do
   begin
    BNotas.medicamento[cont].codigo:=0;
    BNotas.medicamento[cont].quantidade:=0;
   end;
   {atualiza num_notas}
   open_Fnotas;
   close_Fnotas;
   (*ESCREVE NUMERO DA NOTA*)
   textbackground(fmenu);
   if fmenu>7 then
      textcolor(cmenu+16)
      else
      textcolor(cmenu);
   gotoxy(18,5);
   write(num_Notas);
   (*ZERA TOTAL*)
   total:=0.0;
   icms :=0.0;
   (*ATRIBUI NUMERO DA NOTA*)
   Bnotas.NumNF:=Num_notas; (*se for inclusÆo*)
   (*DEFINE DATA E HORA DA NOTA*)
   Bnotas.data:=date;
   most(20,7,cmenu,fmenu,Bnotas.data);
   Bnotas.hora:=time;
   most(40,7,cmenu,fmenu,Bnotas.hora);
  (*Leitura do c¢digo do Cliente*)
   repeat
       status('Digite c¢digo do cliente - ” Lista');
       Bnotas.codCliente:=le_codigo(18,6,caixa_de_clientes);
       if BNotas.codCliente=0 then exit;
   until Bnotas.codCliente<>notValidcod;
   remost(18,6,cmenu,fmenu,inttostr(BClientes.codigo),5);
   most(26,6,cmenu,fmenu,Bclientes.nome); (*NÆo precisa ler novamente*)

   (*LEITURA DO OPERADOR*)
   repeat
       status('Digite c¢digo do Operador - ” Lista');
       Bnotas.codOperad:=le_codigo(38,5,caixa_de_Operads);
       if BNotas.codOperad=0 then most(45,5,cmenu,fmenu,'Geral');
   until Bnotas.codOperad<>notValidcod;
   remost(38,5,cmenu,fmenu,inttostr(BOperads.codigo),5);
   most(45,5,cmenu,fmenu,BOperads.nome); (*NÆo precisa ler novamente*)

    {  most(26,5,cmenu,fmenu,Bclientes.observacao);}
   (*Leitura dos c¢digos dos Medicamentos*)
   (*REPETE ATE 10 ITEMS OU ENTER OU ESC OU ZERO*)
   linha:=1; (*CONTROLA A LINHA P/ MOSTRAR E O ARRAY DOS MEDICAMENTOS*)
   {sel_mov:=1;  (*DA BARRA DE ROLAGEM DA NOTA*)}
   repeat
       most(4,linha+10,cmenu,fmenu,(inttostr(linha)));
       (*LEITURA E REMOST DO CODIGO E DESCRICAO DO MEDICAMENTO*)
       (*APAGA O ESTOQUE DA TELA*)
       most(70,7,cmenu,fmenu,'     ');
       status('Digite c¢digo do medicamento - ” Lista');
       cod_now:=le_codigo(7,linha+10,caixa_de_remedios);
       (*PROCURA SE PRODUTO Jµ ESTµ NA NOTA*)
       if linha>1 then
       begin
         flag:=0;
         proc:=0;
         repeat
            proc:=proc+1;
            if Bnotas.medicamento[proc].codigo=cod_now then
            begin
              erro('Produto j  est  na nota');
              flag:=1;
              break;
            end;
         until proc=linha-1;
         if flag=1 then continue;
       end;
       Bnotas.medicamento[linha].codigo:=cod_now;
       if BNotas.medicamento[linha].codigo=0 then break;
        if Bnotas.medicamento[linha].codigo=notvalidcod then continue;
       (*MOSTRA QTDADE EM ESTOQUE*)
       most(50,7,cmenu,fmenu,'Qtdade em Estoque : '+Bremedios.estoque);
       (*MOSTRA A DESCRICAO*)
       remost(14,linha+10,cmenu,fmenu,Bremedios.nome,36); (*NÆo precisa ler novamente*)
       (*REMOSTRA O CODIGO*)
       remost(7,linha+10,cmenu,fmenu,inttostr(Bremedios.codigo),5); (*NÆo precisa ler novamente*)
       (*MOSTRA O PRECO UNITARIO DE VENDA*)
       most(62,linha+10,cmenu,fmenu,Bremedios.precovenda);
       (*MOSTRA A UNIDADE*)
       most(51,linha+10,cmenu,fmenu,Bremedios.unidade);
       (*LEITURA E REMOST DA QTDADE*)
       status('Digite quantidade');
       repeat
       qtdade:='';
       inputstring(qtdade,4,4,56,linha+10,'N',sobqtdade);
       if qtdade='0' then erro('Quantidade nÆo permitida');
       until qtdade<>'0';
       (*REMOSTRA QTDADE*)
       remost(56,linha+10,cmenu,fmenu,qtdade,5);
       if sobqtdade=0 then continue;  (*QUER DIZER QUE APERTEI UPARROW NA QUANTIDADE*)
       if (strtoint(qtdade)>strtoint(Bremedios.estoque)) or (*ESTOQUE ACIMA DO ATUAL*)
          (qtdade='') then (*SE APERTEI ESC NA QUANTIDADE ENTAO VOLTA E APAGA*)
       begin
        if qtdade<>'' then erro('Quantidade acima do estoque atual');
        (*APAGA TODA A LINHA DA NOTA*)
        remost(14,linha+10,cmenu,fmenu,'',36); (*apaga descri‡Æo*)
        remost(51,linha+10,cmenu,fmenu,'',4); (*apaga unid venda*)
        remost(62,linha+10,cmenu,fmenu,'',7); (*apaga preco*)
        remost(56,linha+10,cmenu,fmenu,'',5); (*apaga qtdade*)
        continue;
       end;
       Bnotas.medicamento[linha].quantidade:=strtoint(qtdade);
       (*MOSTRA SUBTOTAL E ATUALIZA TOTAL*)
       subtotal:=Bnotas.medicamento[linha].quantidade*(strtoreal(Bremedios.precovenda));
       icms:=icms+subtotal*strtoreal(Bremedios.icm)/100.0;
       most(70,linha+10,cmenu,fmenu,realtostr(subtotal));
       total:=total+subtotal;
       most(71,22,cmenu,fmenu,realtostr(total));
       most(55,22,cmenu,fmenu,realtostr(icms));
       (*INCRMENTA LINA QUE SOMA UM NO ARRAY E NA LINHA DA TELA*)
       linha:=linha+1;
   until linha=11; (*REPEAT DOS REMEDIOS*)
   (*SE APERTEI ESC SEM NADA*)
   if linha=1 then begin volta_tela(3,true); continue; end;
   (*apaga ultima linha*)
   if linha<>11 then
   begin
    remost(7,linha+10,cmenu,fmenu,'',5);
    remost(2,linha+10,cmenu,fmenu,'',4);
   end;
   (*CONFIRMA*)
   if not ok then begin volta_tela(3,true);  continue; end;
   (*IMPRIMIR*)
{   imprima('------------------------------------------------------------------------');
   imprima(' FARMµCIA PAULI * PERSONAL FARM - SISTEMA DE CONTROLE DE FARMµCIAS');
   imprima('------------------------------------------------------------------------');
   imprima('CLIENTE : '+Bclientes.nome);
   imprima('VENDEDOR : '+Boperads.nome);
   imprima('DATA : '+date+' HORA : '+time);
   imprima('------------------------------------------------------------------------');
   for cont:=1 to linha-1 do
   begin
      open_Fremedios;
      seek(Fremedios,Bnotas.medicamento[cont].codigo);
      read(Fremedios,bremedios);
      close_Fremedios;
      imprima(inttostr(Bnotas.medicamento[cont].quantidade)+' '+
             Bremedios.nome+' * R$ '+
             realtostr(Bnotas.medicamento[cont].quantidade*strtoreal(bremedios.precovenda)));
   end;
   imprima('------------------------------------------------------------------------');
   imprima('TOTAL : R$ '+realtostr(total));
   imprima('------------------------------------------------------------------------');}
   (*ABRE OS REMEDIOS PARA ATUALIZAR ESTOQUE*)
   open_Fremedios;
   cont:=1;
   repeat
     (*LE O REMEDIOS POSICIONANDO NO CODIGO GUARDADO NO ARRAY*)
     seek(Fremedios,BNotas.medicamento[cont].codigo);
     read(Fremedios,Bremedios);
     (*DIMINUI DO ESTOQUE DE REMEDIOS A QUANTIDADE NO ARRAY*)
     Bremedios.estoque:=inttostr(
     strtoint(Bremedios.estoque)-
     BNotas.medicamento[cont].quantidade);
     (*ATUALIZA ULTIMA SAIDA DO REMEDIO*)
     Bremedios.ultsaida:=date;
     (*GRAVA O REMEDIO COM ESTOQUE E SAIDAS ATUALIZADO*)
     seek(Fremedios,BNotas.medicamento[cont].codigo);
     write(Fremedios,Bremedios);
     inc(cont,1);
   until (BNotas.medicamento[cont].codigo=0) or (cont=11);
   close_Fremedios;
   menu(10,10,25,16,cmenu,fmenu,'Pagamento');
   square(12,11,cmenu,fmenu,'A vista@A prazo@Cheque@CartÆo@Convˆnio');
   sethint('');
   status('Escolha condi‡Æo de pagamento');
   selpag:=1;
   role(12,11,24,15,cbarra,fbarra,cmenu,fmenu,selpag,retpag);
   if selpag=1 then bnotas.pagto:='A VISTA';

   if selpag=2 then
   begin
     menu(18,11,55,15,cmenu,fmenu,'DATA');
     st1:='';
     most(20,13,cmenu,fmenu,'Digite data(s) pagto');
     inputstring(st1,20,20,32,14,'T',retst1);
     Bnotas.pagto:='PRAZO '+st1;
   end;
   if selpag=3 then
   begin
     menu(18,11,55,15,cmenu,fmenu,'DATA DO CHEQUE');
     st1:='';
     most(20,13,cmenu,fmenu,'Digite data do cheque');
     inputstring(st1,10,10,32,14,'T',retst1);
     Bnotas.pagto:='CHEQUE '+st1;
   end;
   if selpag=5 then
   begin
     menu(18,11,55,15,cmenu,fmenu,'CONVÒNIO');
     status('Digite c¢digo do convˆnio - ” Lista');
     Bnotas.pagto:=inttostr(le_codigo(22,13,caixa_de_conv));
     Bnotas.pagto:='CONVÒNIO '+Bnotas.pagto;
   end;
   (*Grava a Nota Fiscal*)
   open_Fnotas;
   seek(Fnotas,Bnotas.numNf);
   write(Fnotas,Bnotas);
   close_Fnotas;


   volta_tela(3,true);
 until Bnotas.codcliente=0; (*REPEAT DO CLIENTE ATE 0*)
end;
(****************************************************************************)
Procedure Menu_Nota_Saida;
var
  linha : byte;
begin
   menu(1,4,78,23,cmenu,fmenu,'Venda');
   most(3,5,cmenu,fmenu,'Nota Fiscal : [      ] Operador : [     ]');
   most(3,6,cmenu,fmenu,'Cliente     : [     ]');
   most(3,7,cmenu,fmenu,'Data EmissÆo  : [          ] Hora : [     ]');
   most(2,8,cmenu,fmenu,'ÚÚÚÚÑÚÚÚÚÚÚÑÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÑÚÚÚÚÑÚÚÚÚÚÑÚÚÚÚÚÚÚÑÚÚÚÚÚÚÚÚ');
   most(2,9,cmenu,fmenu,'ItemíC¢digoí Descri‡Æo                          íUnidíQuantíPre‡oUníSubTotal');
   most(2,10,cmenu,fmenu,'ÚÚÚÚĞÚÚÚÚÚÚĞÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚĞÚÚÚÚĞÚÚÚÚÚĞÚÚÚÚÚÚÚĞÚÚÚÚÚÚÚÚ');
  for linha:=11 to 20 do
  most(2,linha,cmenu,fmenu,'    í      í                                    í    í     í       í        ');
  most(2,21,cmenu,fmenu,'ÚÚÚÚÓÚÚÚÚÚÚÓÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÓÚÚÚÚÓÚÚÚÚÚÓÚÚÚÚÚÚÚÓÚÚÚÚÚÚÚÚ');
  most(62,22,cmenu,fmenu,'Total :');
  most(47,22,cmenu,fmenu,'Icms :');
end;
(****************************************************************************)
Procedure Saidas; (*Menu Principal*)
begin
   Salva_tela(2);
   Menu_nota_Saida;
   salva_tela(3);
   Leit_Nota_Saida;
   Volta_tela(3,false);
   Volta_tela(2,false);
end;
(****************************************************************************)
(****************************************************************************)
(****************************************************************************)
(****************************************************************************)
Procedure Leit_Nota_Entrada;
var
   linha,proc,flag : byte;
   cont : integer;
   qtdade : string;
   sobqtdade : byte;
   subtotal,total,icms  : real;
   cod_now : integer;
   st1 : string;
   sob : byte;
   preco : string;
   sobpreco : byte;

begin
 repeat (*DO CLIENTE ATE SER ZERO*)
   for cont:=1 to 10 do
   begin
    Bentrad.medicamento[cont].codigo:=0;
    Bentrad.medicamento[cont].quantidade:=0;
   end;
   {atualiza num_notas}
   open_Fentrad;
   close_Fentrad;
   (*DEFINE DATA DA NOTA*)
   BEntrad.dataentrad:=date;
   most(38,6,cmenu,fmenu,BEntrad.dataEntrad);

   (*LE NUMERO DA NOTA*)
   textbackground(fmenu);
   st1:='';
   inputstring(st1,6,6,18,4,'T',sob);
   remost(18,4,cmenu,fmenu,st1,6);
   Bentrad.numero:=st1;
   if st1='' then exit;
   (*LE SERIE DA NOTA*)
   st1:='';
   inputstring(st1,5,5,35,4,'T',sob);
   remost(35,4,cmenu,fmenu,st1,5);
   Bentrad.serie:=st1;
   (*LE COD FISCAL*)
   st1:='';
   inputstring(st1,3,3,53,4,'T',sob);
   remost(53,4,cmenu,fmenu,st1,3);
   Bentrad.codfiscal:=st1;

   (*ZERA TOTAL*)
   total:=0.0;
   icms :=0.0;
   (*ATRIBUI NUMERO DA NOTA*)
   BEntrad.NumNF:=Num_Entrad; (*se for inclusÆo*)
   (*Leitura do c¢digo do Cliente*)
   repeat
       status('Digite c¢digo do fornecedor - ” Lista');
       Bentrad.codfornecedor:=le_codigo(18,5,caixa_de_fornecs);
   until (Bentrad.codfornecedor<>notValidcod) and
         (Bentrad.codfornecedor<>0);
   remost(18,5,cmenu,fmenu,inttostr(Bfornecs.codigo),5);
   most(25,5,cmenu,fmenu,Bfornecs.Fantasia); (*NÆo precisa ler novamente*)

   (*LE data*)
   st1:='';
   inputstring(st1,10,10,15,6,'T',sob);
   remost(15,6,cmenu,fmenu,st1,10);
   Bentrad.dataentrad:=st1;

   (*LE frete*)
   st1:='';
   inputstring(st1,7,7,12,7,'N',sob);
   remost(12,7,cmenu,fmenu,st1,7);
   Bentrad.frete:=st1;

   (*LE outros*)
   st1:='';
   inputstring(st1,7,7,31,7,'N',sob);
   remost(31,7,cmenu,fmenu,st1,7);
   Bentrad.total:=st1;


   (*REPETE ATE 10 ITEMS OU ENTER OU ESC OU ZERO*)
   linha:=1; (*CONTROLA A LINHA P/ MOSTRAR E O ARRAY DOS MEDICAMENTOS*)
   {sel_mov:=1;  (*DA BARRA DE ROLAGEM DA NOTA*)}
   repeat
       most(4,linha+10,cmenu,fmenu,(inttostr(linha)));
       (*LEITURA E REMOST DO CODIGO E DESCRICAO DO MEDICAMENTO*)
       (*APAGA O ESTOQUE DA TELA*)
       most(70,7,cmenu,fmenu,'     ');
       status('Digite c¢digo do medicamento - ” Lista');
       cod_now:=le_codigo(7,linha+10,caixa_de_remedios);
       (*PROCURA SE PRODUTO Jµ ESTµ NA NOTA*)
       if linha>1 then
       begin
         flag:=0;
         proc:=0;
         repeat
            proc:=proc+1;
            if Bentrad.medicamento[proc].codigo=cod_now then
            begin
              erro('Produto j  est  na nota');
              flag:=1;
              break;
            end;
         until proc=linha-1;
         if flag=1 then continue;
       end;
       Bentrad.medicamento[linha].codigo:=cod_now;
       if Bentrad.medicamento[linha].codigo=0 then break;
        if Bentrad.medicamento[linha].codigo=notvalidcod then continue;
       (*MOSTRA A DESCRICAO*)
       remost(14,linha+10,cmenu,fmenu,Bremedios.nome,36); (*NÆo precisa ler novamente*)
       (*REMOSTRA O CODIGO*)
       remost(7,linha+10,cmenu,fmenu,inttostr(Bremedios.codigo),5); (*NÆo precisa ler novamente*)
       (*MOSTRA A UNIDADE*)
       most(51,linha+10,cmenu,fmenu,Bremedios.unidade);
       (*LEITURA E REMOST DA QTDADE*)
       status('Digite quantidade');
       repeat
       qtdade:='';
       inputstring(qtdade,4,4,56,linha+10,'N',sobqtdade);
       if qtdade='0' then erro('Quantidade nÆo permitida');
       until qtdade<>'0';
       (*REMOSTRA QTDADE*)
       remost(56,linha+10,cmenu,fmenu,qtdade,5);
       if sobqtdade=0 then continue;  (*QUER DIZER QUE APERTEI UPARROW NA QUANTIDADE*)
       Bentrad.medicamento[linha].quantidade:=strtoint(qtdade);
       (*LEITURA DO PRECO UNITARIO*)
        status('Digite pre‡o unit rio');
       repeat
        preco:='';
       inputstring(preco,7,7,62,linha+10,'N',sobpreco);
       if preco='0' then erro('Pre‡o nÆo permitido');
       until preco<>'0';
       Bentrad.medicamento[linha].preco:=preco;
       remost(62,linha+10,cmenu,fmenu,Bentrad.medicamento[linha].preco,7);
       (*MOSTRA SUBTOTAL E ATUALIZA TOTAL*)
       subtotal:=Bentrad.medicamento[linha].quantidade*(strtoreal(preco));
       most(70,linha+10,cmenu,fmenu,realtostr(subtotal));
       total:=total+subtotal;
       most(71,22,cmenu,fmenu,realtostr(total));
       (*INCRMENTA LINA QUE SOMA UM NO ARRAY E NA LINHA DA TELA*)
       linha:=linha+1;
   until linha=11; (*REPEAT DOS REMEDIOS*)
   (*SE APERTEI ESC SEM NADA*)
   if linha=1 then begin volta_tela(3,true); continue; end;
   (*apaga ultima linha*)
   if linha<>11 then
   begin
    remost(7,linha+10,cmenu,fmenu,'',5);
    remost(2,linha+10,cmenu,fmenu,'',4);
   end;
   if not ok then begin volta_tela(3,true);  continue; end;
   (*Grava a Nota Fiscal*)
   open_Fentrad;
   seek(Fentrad,Bentrad.numNf);
   write(Fentrad,Bentrad);
   close_Fentrad;
   (*ABRE OS REMEDIOS PARA ATUALIZAR ESTOQUE*)
   open_Fremedios;
   cont:=1;
   repeat
     (*LE O REMEDIOS POSICIONANDO NO CODIGO GUARDADO NO ARRAY*)
     seek(Fremedios,Bentrad.medicamento[cont].codigo);
     read(Fremedios,Bremedios);
     (*DIMINUI DO ESTOQUE DE REMEDIOS A QUANTIDADE NO ARRAY*)
     Bremedios.estoque:=inttostr(
     strtoint(Bremedios.estoque)+
     Bentrad.medicamento[cont].quantidade);
     (*ATUALIZA ULTIMA SAIDA DO REMEDIO*)
     Bremedios.precocompra:=Bentrad.medicamento[cont].preco;
     Bremedios.ultentrada:=Bentrad.dataentrad;
     (*GRAVA O REMEDIO COM ESTOQUE E SAIDAS ATUALIZADO*)
     seek(Fremedios,Bentrad.medicamento[cont].codigo);
     write(Fremedios,Bremedios);
     inc(cont,1);
   until (Bentrad.medicamento[cont].codigo=0) or (cont=11);
   close_Fremedios;
   volta_tela(3,true);
 until Bentrad.codfornecedor=0; (*REPEAT DO CLIENTE ATE 0*)
end;
(****************************************************************************)
Procedure Menu_Nota_Entrada;
var
  linha : byte;
begin
   menu(1,3,78,23,cmenu,fmenu,'Compras');
   most(3,4,cmenu,fmenu,'Nota Fiscal : [      ] S‚rie : [     ] CodFisc : [   ]');
   most(3,5,cmenu,fmenu,'Fornecedor  : [     ]');
   most(3,6,cmenu,fmenu,'EmissÆo  : [          ] Entrada : [          ]');
   most(3,7,cmenu,fmenu,'Frete : [        ] Outros: [       ]');
   most(2,8,cmenu,fmenu,'ÚÚÚÚÑÚÚÚÚÚÚÑÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÑÚÚÚÚÑÚÚÚÚÚÑÚÚÚÚÚÚÚÑÚÚÚÚÚÚÚÚ');
   most(2,9,cmenu,fmenu,'ItemíC¢digoí Descri‡Æo                          íUnidíQuantíPre‡oUníSubTotal');
   most(2,10,cmenu,fmenu,'ÚÚÚÚĞÚÚÚÚÚÚĞÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚĞÚÚÚÚĞÚÚÚÚÚĞÚÚÚÚÚÚÚĞÚÚÚÚÚÚÚÚ');
  for linha:=11 to 20 do
  most(2,linha,cmenu,fmenu,'    í      í                                    í    í     í       í        ');
  most(2,21,cmenu,fmenu,'ÚÚÚÚÓÚÚÚÚÚÚÓÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÓÚÚÚÚÓÚÚÚÚÚÓÚÚÚÚÚÚÚÓÚÚÚÚÚÚÚÚ');
  most(62,22,cmenu,fmenu,'Total :');
end;
(****************************************************************************)
Procedure Entradas;
begin
   Salva_tela(2);
   Menu_nota_Entrada;
   salva_tela(3);
   Leit_Nota_entrada;
   Volta_tela(3,false);
   Volta_tela(2,false);
end;
(****************************************************************************)
(****************************************************************************)
(****************************************************************************)
Procedure terminal_cliente;
var
 st1 : string;
 sob : byte;
 pont : integer;
begin
   salva_tela(2);
   textbackground(7);
   preencha(1,15,'°');
   status(date);
   menu(1,4,78,10,15,9,'');
   menu(1,13,78,20,15,9,'Produto');
   most(12,5,15,9,'±±± ±±± ±±  ±   ± ±±± ±±± ± ±±±    ÛÛ  ÛÛÛ Û Û Û   Û');
   most(12,6,15,9,'±   ± ± ± ± ±± ±± ± ± ±   ± ± ±    Û Û Û Û Û Û Û   Û');
   most(12,7,15,9,'±±  ±±± ±±  ± ± ± ±±± ±   ± ±±±    ÛÛ  ÛÛÛ Û Û Û   Û');
   most(12,8,15,9,'±   ± ± ± ± ±   ± ± ± ±   ± ± ±    Û   Û Û Û Û Û   Û');
   most(12,9,15,9,'±   ± ± ± ± ±   ± ± ± ±±± ± ± ±    Û   Û Û ÛÛÛ ÛÛÛ Û');
   repeat
   st1:='';
   inputstring(st1,16,16,3,15,'N',sob);
   pont:=1;
   open_Fremedios;
   if Num_remedios>1 then
   repeat
        seek(Fremedios,pont);
        read(Fremedios,Bremedios);
        inc(pont,1);
   until (Bremedios.barras=st1) or (pont=num_remedios);
   close_Fremedios;
   remost(3,17,15,9,'DESCRI€ÇO : '+Bremedios.nome,40);
   remost(3,18,15,9,'UNIDADE   : '+Bremedios.unidade,6);
   remost(3,19,15,9,'PRE€O     : R$ '+Bremedios.precovenda,10);
   until st1='';
   Volta_tela(2,false);
end;
(****************************************************************************)
Procedure conta(const tipo : byte);
var
  filename : string;
  filevar : text;
  i : integer;
begin
  salva_tela(4);
  filename:=randomiza_arquivo;
  assign(filevar,filename);
  rewrite(filevar);
{  reset(filevar); }
  open_fnotas;
  if num_notas=1 then
  begin
    close(filevar); close_fnotas;erase(filevar);
    erro('NÆo h  notas !');
    exit;
  end;
  for i:=1 to num_notas-1 do
  begin
  seek(Fnotas,i);
  read(fnotas,Bnotas);
  if ((pos('PRAZO',Bnotas.pagto)>0) and (tipo=ctprazo)) or
     ((pos('CHEQUE',Bnotas.pagto)>0) and (tipo=ctcheque)) or
     ((pos('CONVÒNIO',Bnotas.pagto)>0) and (tipo=ctconvenio)) then
        writeln(filevar,'CLIENTE ',Bnotas.codcliente,' PAGTO ',Bnotas.pagto);
  end;
  close_fnotas;
  close(filevar);
  quicKreport(filename,'CONTAS (CLIENTE - TIPO DE PAGTO)');
  erase(filevar);
  volta_tela(4,false);
end;
(****************************************************************************)
begin
end.