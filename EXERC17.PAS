program vandik;
uses
    crt;

type dados = record
     Nome : string[40];
     Nota : array[1..4] of real;
     Idade : integer;
     Media : real;
end;

var
   aluno : array[1..100] of dados;
   c : char;
   cont, i : integer;

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

procedure ordbin(inicio, quantidade : integer; tipo : integer);
var
    i, j, x3 : integer;
    x1 : string;
    x2 : real;
    temp : dados;
begin
    j := quantidade; i := inicio;
    if tipo = 1 then
       x1 := aluno[trunc((inicio + quantidade) / 2)].Nome;
    if tipo = 2 then
       x2 := aluno[trunc((inicio + quantidade) / 2)].Media;
    if tipo = 3 then
       x3 := aluno[trunc((inicio + quantidade) / 2)].Idade;
    repeat
    if tipo = 1 then
    begin
         while (caixa_alta(aluno[i].Nome) < caixa_alta(x1)) and (i < quantidade) do i := i + 1;
         while (caixa_alta(aluno[j].Nome) > caixa_alta(x1)) and (j > inicio) do j := j - 1;
    end;
    if tipo = 2 then
    begin
         while (aluno[i].media < x2) and (i < quantidade) do i := i + 1;
         while (aluno[j].media > x2) and (j > inicio) do j := j - 1;
    end;
    if tipo = 3 then
    begin
         while (aluno[i].idade < x3) and (i < quantidade) do i := i + 1;
         while (aluno[j].idade > x3) and (j > inicio) do j := j - 1;
    end;
        if (i <= j) then
        begin
            temp := aluno[i];
            aluno[i] := aluno[j];
            aluno[j] := temp;
            i := i + 1; j := j - 1;
        end;
    until (i > j);
    if (inicio < j) then ordbin(inicio, j, tipo);
    if (i < quantidade) then ordbin(i, quantidade, tipo);
end;

procedure impr(tipo : integer);
var
   i : integer;
   c : char;
begin
     writeln('Tecle <enter> para o pr¢ximo aluno ou <esc> para o menu');
     writeln;
     if tipo = 1 then
     begin
          for i := 1 to cont do
          begin
              write(aluno[i].nome:40, ' ', aluno[i].Idade:3, ' ', aluno[i].nota[1]:6:2);
              write(aluno[i].nota[2]:6:2, aluno[i].nota[3]:6:2, aluno[i].nota[4]:6:2);
              writeln(aluno[i].media:6:2);
              c := readkey;
              if c = chr(27) then exit;
          end;
     end
     else
     begin
          for i := cont downto 1 do
          begin
              write(aluno[i].nome:40, ' ', aluno[i].Idade:3, ' ', aluno[i].nota[1]:6:2);
              write(aluno[i].nota[2]:6:2, aluno[i].nota[3]:6:2, aluno[i].nota[4]:6:2);
              writeln(aluno[i].media:6:2);
              c := readkey;
              if c = chr(27) then exit;
          end;
     end;
end;

begin
     cont := 0;
     repeat
     clrscr;
     writeln('**************************************************');
     writeln('Cadastro de alunos');
     writeln('**************************************************');
     writeln;
     writeln('Menu de controle');
     writeln;
     writeln('1. Inserir aluno');
     writeln('2. Alunos por ordem alfab‚tica');
     writeln('3. Alunos por ordem decrescente de m‚dia');
     writeln('4. Alunos por ordem crescente de idade');
     writeln('0. (Finalizar programa)');
     writeln;
     c := readkey;
     case c of
     '1':
     begin
          cont := cont + 1;
          writeln('----------------------------------------');
          writeln('Inserir aluno');
          writeln('=============');
          writeln;
          repeat
          write('Nome...: ');
          readln(aluno[cont].nome);
          if aluno[cont].nome <= '                                        ' then
             writeln('O nome ‚ obrigat¢rio.');
          until aluno[cont].nome > '                                        ';
          repeat
          write('Idade..: ');
          readln(aluno[cont].Idade);
             if aluno[cont].Idade <= 0 then
                writeln('A idade deve ser maior que 0.');
          until aluno[cont].Idade > 0;
          aluno[cont].media := 0;
          for i := 1 to 4 do
          begin
               repeat
               write(i, '¦ Nota: ');
               readln(aluno[cont].Nota[i]);
               if aluno[cont].Nota[i] < 0 then
                  writeln('A nota do aluno nÆo pode ser negativa.');
               until aluno[cont].Nota[i] >= 0;
               aluno[cont].media := (aluno[cont].media + aluno[cont].Nota[i]);
          end;
          aluno[cont].media := aluno[cont].media / 4;
     end;
     '2':
     begin
          if cont = 0 then
          begin
               write('Sem dados para imprimir. ');
          end
          else
          begin
               ordbin(1, cont, 1);
               impr(1);
          end;
     end;
     '3':
     begin
          if cont = 0 then
          begin
               write('Sem dados para imprimir. ');
          end
          else
          begin
               ordbin(1, cont, 2);
               impr(0);
          end;
     end;
     '4':
     begin
          if cont = 0 then
          begin
               write('Sem dados para imprimir. ');
          end
          else
          begin
               ordbin(1, cont, 3);
               impr(1);
          end;
     end;
     end;
     if c <> '0' then
     begin
          writeln('Tecle algo para voltar ao menu.');
          readln;
     end;
     until c = '0';
     clrscr;
end.
