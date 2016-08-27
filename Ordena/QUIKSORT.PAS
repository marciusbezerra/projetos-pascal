Program ordena;
uses crt;
const k=100;
type vet = array [1..k] of integer;
var L,A,B:vet;
    p,inicio, fm, f, n : integer;


Function particao(var A:vet; ii:integer; fi:integer):integer;
var x,i,j,temp:integer;
begin
     x:=A[ii];
     i:=ii -1;
     j:=fi +1;
     while true do
     begin
           repeat j:=j-1 until A[j] <= x;
           repeat i:=i+1 until A[i] >= x;
           if i <j then
           begin
              temp:=A[i];
              A[i]:=A[j];
              A[j]:=temp;
           end
           else
           begin
                particao:=j;
                exit;
           end;
     end;
end;

Procedure Quiksort(var B:vet; ini:integer; fim:integer);
var p:integer;
begin
     if fim > ini then
        begin
             p:= particao (B,ini, fim);
             Quiksort(B,ini,p);
             Quiksort(B,p+1,fim);
       end;
end;

begin
     clrscr;
     write('Entre com o tamanho do vetor : ');
     readln(fm);writeln;
     for f:=1 to fm do
     begin
          write(' L [ ', f ,' ]= ');
          readln(L[f]);
     end;
     writeln;inicio:=1;
     Quiksort(L,inicio,fm);
     writeln(' Vetor ordenado : ');writeln;
     for f:=1 to fm do
       writeln(' L [ ', f , ' ] = ', L[f]);
     readkey;
end.















































































































































































































