program vandik;
uses crt;
var
 meunumerostr: string;
 contador, meunumero, cd, ret, soma: integer;
begin
     clrscr;
     soma := 0;
     writeln('**************************************************');
     writeln('Soma de d¡gitos');
     writeln('**************************************************');
     writeln;
     write('Digite um n£mero: ');
     readln(meunumero);
     if meunumero < 0 then
        meunumero := meunumero * -1;
     str(meunumero, meunumerostr);
     for contador := 1 to length(meunumerostr) do
     begin
         val(meunumerostr[contador], ret, cd);
         soma := soma + ret;
     end;
     writeln('A soma dos digitos ‚: ', soma);
     readln;
end.
