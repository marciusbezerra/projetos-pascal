program vandik;
uses crt;

var meunumero : integer;

function fato( meunumero : integer ): real;
var
   fat : real;
   contador : integer;
begin
     fat := 1;
     if meunumero >= 0 then
     begin
          for contador := 1 to meunumero do
              fat := fat * contador ;
          fato := fat;
     end
        else
            fato := -1;
end;

begin
     clrscr;
     writeln('**************************************************');
     writeln('Fatorial do n£mero');
     writeln('**************************************************');
     writeln;
     write('Digite um n£mero: ');
     readln(meunumero);
     writeln;
     if fato(meunumero) < 0 then
        writeln('O seu fatorial nÆo existe.')
     else
         writeln('O seu fatorial ‚ ', fato(meunumero):0:0);
     readln;
end.
