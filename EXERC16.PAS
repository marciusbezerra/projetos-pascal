program vandik;

uses
    crt, strings;

type Dados = record
     Nome : string[40];
     Fone : string[8];
     Endereco : string[50];
     CEP : string[8];
     Bairro : string[25];
     Cidade : string[25];
     UF : string [2];
end;

var
   Catalogo : array[1..15] of Dados;
   Item : Dados;
   i : integer;
   nome : string;

function caixa_alta(vTex : string) : string;
var
   i, tam : integer;
   temp : string;
begin
     temp := '';
     tam := length(vTex);
     for i := 1 to tam do
     begin
          temp := temp + upcase(vTex[i]);
     end;
     caixa_alta := temp;
end;

procedure ordbin(inicio, quantidade : integer);
var
    i, j : integer;
    x : string;
    temp : Dados;
begin
    j := quantidade; i := inicio;
    x := Catalogo[trunc((inicio + quantidade) / 2)].Nome;
    repeat
    while (Catalogo[i].Nome < x) and (i < quantidade) do i := i + 1;
    while (Catalogo[j].Nome > x) and (j > inicio) do j := j - 1;
        if (i <= j) then
        begin
            temp := Catalogo[i];
            Catalogo[i] := Catalogo[j];
            Catalogo[j] := temp;
            i := i + 1; j := j - 1;
        end;
    until (i > j);
    if (inicio < j) then ordbin(inicio, j);
    if (i < quantidade) then ordbin(i, quantidade);
end;

function busc(var ret : Dados; nome : string) : boolean;
var
    Menor, Maior, Meio : integer;
begin
    Menor := 1;
    Maior := 15;

    While (true) do
    begin
        Meio := trunc((Menor + Maior) / 2);
        ret := Catalogo[Meio];
        If Maior < Menor Then
        begin
            busc := false;
            Exit;
        End;
        if caixa_alta(nome) > caixa_alta(ret.nome) then
        begin
            Menor := Meio + 1;
        end
        Else
        begin
            if caixa_alta(nome) < caixa_alta(ret.nome) then
            begin
                Maior := Meio - 1;
            end
            Else
            begin
                busc := true;
                Exit;
            End;
        End;
    end;
End;


procedure adcn(Posicao : integer; vNome, vFone, vEndereco, vCEP, vBairro, vCidade, vUF : string);
begin
     with Catalogo[Posicao] do
     begin
          Nome := vNome;
          Fone := vFone;
          Endereco := vEndereco;
          CEP := vCEP;
          Bairro := vBairro;
          Cidade := vCidade;
          UF := vUF;
     end;
end;

begin
     adcn(1, 'Arnold Schwarzennegger', '655.6274', 'Rua 24 de maio', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(2, 'Sylvester Stallone', '655.0658', 'Rua das dores', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(3, 'Eddie Murphi', '655.1265', 'Rua das flores', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(4, 'Julia Roberts', '123.3960', 'Av. do contorno', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(5, 'Francis Ford Coppola', '321.1849', 'Av. Teradentes', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(6, 'Robert de Niro', '123.1276', 'Av. Santos Dumont', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(7, 'Al Pacino', '321.0987', 'Av. Olimpio', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(8, 'Bruce Lee', '444.3478', 'Av. Beira mar', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(9, 'John Woo', '444.9856', 'R. dos rosarios', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(10, 'Antonio Bandeiras', '555.1243', 'Casa dos brinquedos', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(11, 'Salma Hayek', '555.0001', 'Av. Elvis Presley', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(12, 'Quentin Tarantino', '555.3958', 'Travessa num. 1', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(13, 'Steven Spielberg', '121.0183', 'Travessa num. 2', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(14, 'Oliver Stone', '212.1947', 'Travessa num. 3', '62100000', 'Centro', 'Sobral', 'CE');
     adcn(15, 'David Lynch', '223.2001', 'Travessa num. 4', '62100000', 'Centro', 'Sobral', 'CE');
     clrscr;
     writeln('**************************************************');
     writeln('Simula‡Æo de agenda');
     writeln('**************************************************');
     writeln;
     ordbin(1, 15);
     writeln('Agenda ordenada:');
     writeln;
     for i := 1 to 15 do
         writeln(Catalogo[i].Nome:40, ' ',Catalogo[i].Fone:8, ' ', Catalogo[i].Cidade:25, ' ', Catalogo[i].UF:2);
     writeln;
     write('Pesquisa por nome: ');
     readln(nome);
     writeln;
     if busc(Item, nome) then
     begin
          writeln('Item localizado');
          writeln;
          writeln('Nome.....: ', Item.Nome);
          writeln('Fone.....: ', Item.Fone);
          writeln('Endereco.: ', Item.Endereco);
          writeln('CEP......: ', Item.CEP);
          writeln('Bairro...: ', Item.Bairro);
          writeln('Cidade...: ', Item.Cidade);
          writeln('UF.......: ', Item.UF);
     end
     else
         writeln('ITEM NÇO LOCALIZADO.');
     write('(Pressione algo para sair)');
     readln;
end.
