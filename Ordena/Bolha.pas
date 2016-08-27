program aula;
uses crt;
type
    vet = array [1..10] of integer;
var
   a: vet;
   k, x, lsup, bolha: integer;

begin
     clrscr;
     for k:= 1 to 10 do
     begin
          writeln ('Digite o N£mero: ');
          read (a[k]);
          lsup :=10;
     end;
          while (lsup>1) do
          begin
               bolha:=0;
               for k:= 1 to (lsup -1) do
               begin
                   if (a[k])>(a[k+1]) then
                   begin
                        x:= a[k];
                        a[k]:= a[k+1];
                        a[k+1]:=x;
                        bolha:=k;
                   end;
                   lsup:= bolha;
               end;
          lsup:=lsup -1;
          end;
     for k:=1 to 10 do
     writeln (a[k]);
end.