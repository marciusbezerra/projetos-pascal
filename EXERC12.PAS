program vandik;
uses
    crt;

var
   meunumero1, meunumero2, i, soma : integer;
begin
     repeat
     clrscr;
     soma := 0;
     writeln('**************************************************');
     writeln('Soma dos pares lidos no teclado');
     writeln('**************************************************');
     writeln;
     write('Digite o n£mero menor: ');
     readln(meunumero1);
     until meunumero1 >= 0;
     repeat
     write('Digite o n£mero maior: ');
     readln(meunumero2);
     if meunumero1 >= meunumero2 then
     begin
        writeln;
        write('O segundo n£mero deve ser maior que o primeiro.');
        readln;
        writeln;
     end;
     until ((meunumero1) < meunumero2);
     for i := (meunumero1 + 1) to (meunumero2 - 1) do
     begin
          if i mod 2 = 0 then
             soma := soma + i;
     end;
     writeln('------------------------------------------------');
     if soma = 0 then
        writeln('Entre ', meunumero1, ' e ', meunumero2, ' nÆo existem pares.')
     else
         writeln('A soma dos pares entre ', meunumero1, ' e ', meunumero2, ' ‚ ', soma);
end.
