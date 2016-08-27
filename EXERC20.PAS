program vandik;
uses
    crt;
var
   f : text;
   i : integer;
   frase : string;
begin
     repeat
     clrscr;
     writeln('**************************************************');
     writeln('Codificador');
     writeln('**************************************************');
     writeln;
     write('Frase a ser condificada: ');
     readln(Frase);
     until frase > '                     ';
     assign(f, 'COD.TXT');
     rewrite(f);
     for i := 1 to length(frase) do
         write(f, ord(frase[i]), ' ');
     close(f);
end.
