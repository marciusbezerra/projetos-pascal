program teste;

uses crt, dos;

type item = record
     chave : integer;
     valor : string;
     end;

type indice = 1..10;
type vetor = array[1..10] of item;

var a : vetor;
    b : vetor;
    i : integer;
    h,m,s,mm,h1,m1,s1,mm1 : word;



Procedure Selecao (var A:vetor);
var i,j,Min:indice;
    x      :item;
    n      :integer;
begin
n := 10;
for i:=1 to n-1 do
 begin
 min:=i;
 for j:=i+1 to n do if A[j].chave<A[min].Chave then Min:=j;
 x:=A[Min];A[Min]:=A[i];A[i]:=x;
 end;
end;



Procedure Insercao (var A:vetor);
var i,j:indice;
    x:item;
    n : integer;
begin
n := 10;
for i:=2 to n do
    begin
    x:=A[i];
    j:=i-1;
    A[1]:=x;
while x.chave<A[j].chave do
 begin
 A[j+1]:=A[j];
 j:=j-1;
 end;
 A[j+1]:=x;
 end;
end;



Procedure Shellsort (var A:vetor);
label 999;
var i,j,h:integer;
    x:item;
    n   : integer;
begin
 n := 10;
 h:=1;
 repeat h:=3*h+1 until h>n;
 repeat
   h:=h div 3;
   for i:=h+1 to n do
     begin
     x:=A[i];
     j:=i;
     while A[j-h].chave>x.chave do
      begin
      A[j]:=a[j-h];
      j:=j-h;
      if j < h then goto 999;
      end;
     999:A[j]:=x;
     end;
   until h=1;
 end;



 Procedure particao (esq, dir:indice; var i,j:indice);
 var x,w:item;
 begin
  i:=esq; j:=dir;
  x:=A[(i+j) div 2];
  repeat
    while x.chave > A[i].chave do i:=i+1;
    while x.chave < A[j].chave do j:=j-1;
    if i<j
    then begin
          w:=A[i]; A[i]:=A[j]; A[j]:=w;
          i:=i+1;j:=j-1;
          end;
  until i > j;
end;



{Procedure Quicksort (var A:vetor);
procedure ordena (esq,dir:indice);
var i,j:indice;
    n    : integer;
begin
 n := 10;
 particao (esq,dir,i,j);
 if esq < j then ordena (esq,j);
 if i < dir then ordena (i,dir);
end;
begin
ordena (1,n);
end;}

begin
     clrscr;
     writeln('*******************************************');
     writeln(' CONTAGEM DE TEMPO DE FUN€åES DE ORDENA€ÇO');
     writeln('*******************************************');
     writeln;
{     for i := 1 to 10 do
     begin
          write('Chave ',i,' (Inteiro): ');
          readln(a[i].chave);
          write('Valor ',i,' (Texto)..: ');
          readln(a[i].valor);
          writeln;
     end;}
     a[1].chave := 5;
     a[1].valor := 'Mario';
     a[2].chave := 3;
     a[2].valor := 'Pl cido';
     a[3].chave := 7;
     a[3].valor := 'Julia';
     a[4].chave := 8;
     a[4].valor := 'Dianete';
     a[5].chave := 1;
     a[5].valor := 'Paula';
     a[6].chave := 2;
     a[6].valor := 'Maria';
     a[7].chave := 9;
     a[7].valor := 'Ana';
     a[8].chave := 4;
     a[8].valor := 'JoÆo';
     a[9].chave := 4;
     a[9].valor := 'Carlos';
     a[10].chave := 10;
     a[10].valor := 'Alberto';

     b := a;
     gettime(h,m,s,mm);
     selecao(b);
     gettime(h1,m1,s1,mm1);
     writeln('PROCEDIMENTO SELE€ÇO');
     writeln('*****************************');
     writeln;
     writeln('Tempo: ', s1-s, ' segundo(s) e ', mm1-mm, ' mil‚simo(s)');
     writeln;
     writeln('Resultado da ordena‡Æo: ');
     writeln;
     for i := 1 to 10 do
         writeln('Chave: ',b[i].chave:10, '     | Valor: ', b[i].valor);
     writeln;
     write('Tecle algo para continuar ...');
     readln;
     writeln;
{************************************}
     b := a;
     gettime(h,m,s,mm);
     insercao(b);
     gettime(h1,m1,s1,mm1);
     writeln('PROCEDIMENTO INSER€ÇO');
     writeln('*****************************');
     writeln;
     writeln('Tempo: ', s1-s, ' segundo(s) e ', mm1-mm, ' mil‚simo(s)');
     writeln;
     writeln('Resultado da ordena‡Æo: ');
     writeln;
     for i := 1 to 10 do
         writeln('Chave: ',b[i].chave:10, '     | Valor: ', b[i].valor);
     writeln;
     write('Tecle algo para continuar ...');
     readln;
     writeln;
{************************************}
     b := a;
     gettime(h,m,s,mm);
     shellsort(b);
     gettime(h1,m1,s1,mm1);
     writeln('PROCEDIMENTO SHELLSORT');
     writeln('*****************************');
     writeln;
     writeln('Tempo: ', s1-s, ' segundo(s) e ', mm1-mm, ' mil‚simo(s)');
     writeln;
     writeln('Resultado da ordena‡Æo: ');
     writeln;
     for i := 1 to 10 do
         writeln('Chave: ',b[i].chave:10, '     | Valor: ', b[i].valor);
     writeln;
     write('Tecle algo para continuar ...');
     readln;
     writeln;

end.

