program vandik;
uses crt;
var
    v : array[1..10] of string;
    i : integer;
    nome : string[50];

procedure pega(nome : string; i : integer);
begin
     v[i] := nome;
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
     for i := 1 to 10 do
         writeln(v[i]);
end;

begin
     clrscr;
     writeln('**************************************************');
     writeln('Receber 10 nome, joga-los num vetor e exibi-los');
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
     pega(nome, i);
     end;
     until i = 10;
     lsta;
     readln;
end.


