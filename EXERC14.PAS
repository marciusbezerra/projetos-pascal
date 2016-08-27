program vandik;
uses
    crt;
var
   c : char;
   Base, Altura, Lado, Comprimento, raio, ret : real;

function elavado(meunumero : real; n : integer) : real;
var
   i : integer;
   ret, vl : real;
begin
     if n = 0 then
     begin
        elavado := 1;
        exit;
     end;
     vl := meunumero;
     for i := 1 to (n - 1) do
         meunumero := vl * meunumero;
     elavado := meunumero;
end;

function ma(Base, Altura, Lado, Comprimento, Raio : real; figura : integer) : real;
begin
     case figura of
          1: ma := (Base * Altura) / 2;
          2: ma := elavado(Lado, 2);
          3: ma := Comprimento * Altura;
          4: ma := pi * elavado(raio, 2);
     end;
end;

begin
     repeat
     clrscr;
     writeln('**************************************************');
     writeln('µrea de figuras geom‚tricas');
     writeln('**************************************************');
     writeln;
     writeln('Selecione uma das op‡äes para obter a  rea:');
     writeln('1. Triƒngulo');
     writeln('2. Quadrado');
     writeln('3. Retƒngulo');
     writeln('4. C¡rculo');
     writeln('0. (Finaliza o programa)');
     c := readkey;
     writeln;
     until c in ['1', '2', '3', '4', '0'];
     case c of
          '1':
          begin
               repeat
                     write('Base...: ');
                     readln(Base);
                     if Base <= 0 then
                        writeln('A base deve ser maior que zero.');
               until Base > 0;
               repeat
                     write('Altura.: ');
                     readln(Altura);
                     if Altura <= 0 then
                        writeln('A altura deve ser maior que zero.');
               until Altura > 0;
               ret := ma(Base, Altura, 0, 0, 0, 1);
          end;
          '2':
          begin
               repeat
                     write('Lado...: ');
                     readln(Lado);
                     if Lado <= 0 then
                        writeln('O lado deve ser maior que zero.');
               until Lado > 0;
               ret := ma(0, 0, Lado, 0, 0, 2);
          end;
          '3':
               begin
               repeat
                     write('Altura.: ');
                     readln(Altura);
                     if Altura <= 0 then
                        writeln('A altura deve ser maior que zero.');
               until Altura > 0;
               repeat
                     write('Comprimento: ');
                     readln(Comprimento);
                     if Comprimento <= 0 then
                        writeln('O comprimento deve ser maior que zero.');
               until Comprimento > 0;
               ret := ma(0, Altura, 0, Comprimento, 0, 3);
          end;
          '4':
          begin
               repeat
                     write('Raio...: ');
                     readln(Raio);
                     if Raio <= 0 then
                        writeln('O raio deve ser maior que zero.');
               until Raio > 0;
               ret := ma(0, 0, 0, 0, Raio, 4);
          end;
          '0':
          begin
               clrscr;
               halt;
          end;
     end;
     writeln('----------------------------------');
     writeln('A  rea ‚: ', ret:0:2);
end.
