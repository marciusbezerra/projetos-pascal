program vandik;
uses crt;
type Tabela = record
     Nome : string[20];
     Nota1 : real;
     Nota2 : real;
     Nota3 : real;
     Nota4 : real;
     end;

var
    v : array[1..8] of tabela;
    i : integer;
    nome : string;
    nota1, nota2, nota3, nota4 : real;

procedure pega(nome : string; nota1, nota2, nota3, nota4 : real; i : integer);
begin
     v[i].nome := nome;
     v[i].nota1 := nota1;
     v[i].nota2 := nota2;
     v[i].nota3 := nota3;
     v[i].nota4 := nota4;
end;

function nula(nome : string) : boolean;
var i : integer;
begin
     nula := true;
     for i := 1 to length(nome) do
          if nome[i] <> ' ' then
          begin
               nula := false;
               exit;
          end;
end;

procedure lsta;
var i : integer;
begin
     writeln;
     writeln('---------------------------------------');
     writeln;
     writeln('Listagem:');
     writeln;
     writeln;
     writeln(' Num   Nome                    N1    N2    N3    N4');
     writeln('___________________________________________________');
     for i := 1 to 8 do
         writeln(i:4,' - ', v[i].nome:20, v[i].nota1:6:1, v[i].nota2:6:1, v[i].nota3:6:1, v[i].nota4:6:1);
end;

begin
     clrscr;
     writeln('**************************************************');
     writeln('4 notas de 8 alunos');
     writeln('**************************************************');
     writeln;
     i := 0;
     repeat
     begin
     i := i + 1;
     repeat
     write('Digite o nome (', i, '): ');
     readln(nome);
     until not nula(nome);
     write('Digite a 1§ nota de ', nome, ': ');
     readln(nota1);
     write('Digite a 2§ nota de ', nome, ': ');
     readln(nota2);
     write('Digite a 3§ nota de ', nome, ': ');
     readln(nota3);
     write('Digite a 4§ nota de ', nome, ': ');
     readln(nota4);
     pega(nome, nota1, nota2, nota3, nota4, i);
     end;
     until i = 8;
     lsta;
     readln;
end.
