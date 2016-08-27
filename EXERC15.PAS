program vandik;
uses
    crt;
var
   v : array[1..30] of integer;
   i, meunumero : integer;

procedure ordbin(inicio, quantidade : integer);
var
    i, j : integer;
    x, temp : integer;
begin
    j := quantidade; i := inicio;
    x := v[trunc((inicio + quantidade) / 2)];
    repeat
    while (v[i] < x) and (i < quantidade) do i := i + 1;
    while (v[j] > x) and (j > inicio) do j := j - 1;
        if (i <= j) then
        begin
            temp := v[i];
            v[i] := v[j];
            v[j] := temp;
            i := i + 1; j := j - 1;
        end;
    until (i > j);
    if (inicio < j) then ordbin(inicio, j);
    if (i < quantidade) then ordbin(i, quantidade);
end;

function busc(meunumero : integer) : boolean;
var
    ItemMeio, Menor, Maior, Meio : integer;
begin
    Menor := 1;
    Maior := 30;

    While (true) do
    begin
        Meio := trunc((Menor + Maior) / 2);
        ItemMeio := v[Meio];
        If Maior < Menor Then
        begin
            busc := false;
            Exit;
        End;
        If meunumero > ItemMeio Then
        begin
            Menor := Meio + 1;
        end
        Else
        begin
            If meunumero < ItemMeio Then
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

begin
     clrscr;
     writeln('**************************************************');
     writeln('Ordena‡Æo e pesquisa bin ria');
     writeln('**************************************************');
     writeln;
     for i := 1 to 30 do
     begin
          write('Digite o n£mero ', i, ': ');
          readln(v[i]);
     end;
     ordbin(1, 30);
     write('Ordenado: ');
     for i := 1 to 30 do
         write(v[i], ' ');
     writeln;
     write('Pesquisar por: ');
     readln(meunumero);
     if busc(meunumero) then
        writeln('Est  contido.')
     else
         writeln('NÆo est  contido.');
     write('Pressione algo.');
     readln;
end.
