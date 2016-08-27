program vandik;
uses
    crt;
var
   cont : integer;
   soma, meunumero : real;
begin
     soma := 0;
     cont := 0;
     clrscr;
     writeln('**************************************************');
     writeln('M‚dia de n£meros lidos no teclado');
     writeln('**************************************************');
     writeln;
     repeat
     cont := cont + 1;
     write('Digite o ', cont, '§ n£mero (negativo finaliza): ');
     readln(meunumero);
     if meunumero >= 0 then
        soma := soma + meunumero;
     until meunumero < 0;
     cont := cont - 1;
     writeln('--------------------------------------------');
     if cont > 0 then
        writeln('A m‚dia ‚: ', (soma / cont):0:2);
     writeln;
     writeln('Programa finalizado. pressione algo.');
     readln;
end.
