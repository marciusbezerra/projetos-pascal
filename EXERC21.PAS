program vandik;
uses
    crt;
var
   f : text;
   i, meunumero, cd : integer;
   frase, Retmeunumero, RetFrase : string;
begin
     Retmeunumero := '';
     RetFrase := '';
     clrscr;
     writeln('**************************************************');
     writeln('Decodificador');
     writeln('**************************************************');
     writeln;
     assign(f, 'COD.TXT');
     reset(f);
     readln(f, frase);
     close(f);
     for i := 1 to length(frase) do
     begin
          if Frase[i] <> ' ' then
          begin
          Retmeunumero := Retmeunumero + Frase[i];
          end
          else
          begin
               val(Retmeunumero, meunumero, cd);
               RetFrase := RetFrase + chr(meunumero);
               Retmeunumero := '';
          end;
     end;
     writeln('Frase resultado: ', RetFrase);
     assign(f, 'DECOD.TXT');
     rewrite(f);
     writeln(f, RetFrase);
     close(f);
     readkey;
end.
