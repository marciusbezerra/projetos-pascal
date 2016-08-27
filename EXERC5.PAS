program vandik;
uses crt;
var
   primo : boolean;
   contador, meunumero : integer;
begin
     primo := true;
     clrscr;
     writeln('**************************************************');
     writeln('Primo ou n∆o');
     writeln('**************************************************');
     writeln;
     write('Digite um n£mero: ');
     readln(meunumero);
     writeln;
     for contador := 2 to (meunumero - 1) do
     begin
         if meunumero mod contador = 0 then
         begin
              primo := false;
         end;
     end;
     if primo then
        writeln('ê primo.')
     else
         writeln('N∆o Ç primo.');
         readln;
end.
