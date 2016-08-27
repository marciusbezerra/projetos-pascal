program vandik;
uses
    crt;
var
   cont, soma, i : integer;
   media : real;
   f : text;
   linha: string;

function EPrimo(meunumero : integer) : boolean;
var
   i : integer;
begin
     EPrimo := true;
     for i := 2 to (meunumero - 1) do
     begin
         if meunumero mod i = 0 then
         begin
              EPrimo := false;
              exit;
         end;
     end;
end;

begin
     clrscr;
     soma := 0;
     media := 0;
     cont := 0;
     Assign(f, 'primo.txt');
     Rewrite(f);
     writeln('**************************************************');
     writeln('Arquivo com n£meros primos');
     writeln('**************************************************');
     writeln;
     writeln(f, 'Seu Nome');
     for i := 0 to 100 do
     begin
          if EPrimo(i) then
          begin
               write(f, i, ' ');
               soma := soma + i;
               cont := cont + 1;
          end;
     end;
     media := soma / cont;
     writeln(f);
     writeln(f, 'Soma: ', soma);
     writeln(f, 'Media: ', media:0:2);
     close(f);
     Reset(f);
     while not Eof(f) do
     begin
          Readln(f, linha);
          Writeln(linha);
     end;
     close(f);
end.
