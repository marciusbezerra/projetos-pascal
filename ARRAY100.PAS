Program ArrayDe100;

uses CRT;

Type
     Vet = array[1..100] of string[10];
Label Fim;
var
     Vetor       : Vet;
     Pos, J, Num : integer;
     Texto       : string[10];
Procedure Mostra;
var N,N1,N2 : integer;
Begin
     clrscr;
     N1 := 1;
     N2 := 1;
     for N := 1 to 50 do
     begin
     gotoxy(N1,N2);
     write(N, ' ', vetor[n]);
     if (N mod 20) = 0 then
     begin
     N2 := N2 - N;
     N1 := N1 + 15;
     end;
     N2 := N2 + 1;
     end;
end;
begin
     Num := 0;
     repeat
     clrscr;
     gotoxy(1,1) ; write('Posi‡Æo: '); readln(Pos);
     clrscr;
     if pos = 0 then exit;
     If (Pos > 100) Or (Pos < 1) then
     begin
          clrscr;
          Writeln('Entre 1 e 100 ou zero para finalizar');
          goto Fim;
     end;
     gotoxy(1,1) ; write('Texto..: '); readln(Texto);
     clrscr;
     If Vetor[Pos] <> '' Then
     begin
          If Vetor[100] <> '' Then
          begin
               clrscr;
               Writeln('Posi‡Æo Inv lida. Tente outra.');
               GoTo Fim;
          end;
               For J := 100 DownTo Pos + 1 do
                   Vetor[J] := Vetor[J - 1];
               Vetor[Pos] := Texto;
     end
     Else
         Vetor[Pos] := Texto;
     Mostra;
     Fim:
     readln;
     until pos = 0;
end.

