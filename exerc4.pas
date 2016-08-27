program vandik;
uses crt;

type Alunos = record
     nome: string[20];
     matricula: string[20];
     nota: array [1..4] of real;
     end;

var
   v: array[1..10] of alunos;
   var contador, j : integer;

function nula(nome : string) : boolean;
var contador : integer;
begin
     nula := true;
     for contador := 1 to length(nome) do
          if nome[contador] <> ' ' then
          begin
               nula := false;
               exit;
          end;
end;

procedure lsta;
var contador, j : integer;
begin
     clrscr;
     writeln('________________________');

     writeln('Lintagem:');
     for contador := 1 to 10 do
     begin
     writeln('Aluno: ', v[contador].nome, ' - Matricula: ', v[contador].matricula);
     write('Notas: ', v[contador].nota[1]:10:1, v[contador].nota[2]:10:1);
     writeln(v[contador].nota[3]:10:1, v[contador].nota[4]:10:1);
     end;
end;

begin
     clrscr;
     writeln('**************************************************');
     writeln('10 alunos no vetor');
     writeln('**************************************************');
     writeln;
     for contador := 1 to 10 do
     begin
          repeat
                write('matricula do aluno ', contador, ': ');
                readln(v[contador].matricula);
          until not nula(v[contador].matricula);
          repeat
                write('nome do aluno ', contador, ': ');
                readln(v[contador].nome);
          until not nula(v[contador].nome);
          for j := 1 to 4 do
          begin
               write('Nota ', j, ' do aluno ', v[contador].nome, ': ');
               readln(v[contador].nota[j]);
          end;
     end;
     lsta;
     readln;
end.
