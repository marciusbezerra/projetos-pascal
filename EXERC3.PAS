program vandik;
uses crt;
var
   c : char;
   result, meunumero1, meunumero2 : real;

function calculadora(op : integer; meunumero1, meunumero2 : real) : real;
begin
     case op of
          1: calculadora := meunumero1 + meunumero2;
          2: calculadora := meunumero1 - meunumero2;
          3: calculadora := meunumero1 * meunumero2;
          4: calculadora := meunumero1 / meunumero2;
     end;
end;

begin
     repeat
     clrscr;
     writeln('**************************************************');
     writeln('4 operaá‰es');
     writeln('**************************************************');
     writeln;
     writeln('Selecione uma operaá∆o:');
     writeln;
     writeln('1. Soma');
     writeln('2. Subtraá∆o');
     writeln('3. Multiplicaá∆o');
     writeln('4. Divis∆o');
     c := Readkey;
     until (c = '1') or (c = '2') or (c = '3') or (c = '4');
     writeln;
     write('Operador 1: ');
     readln(meunumero1);
     repeat
           write('Operador 2: ');
           readln(meunumero2);
           if ((c = '4') and (meunumero2 = 0)) then
           begin
                writeln;
                writeln('Operador 2 n∆o pode ser zero.');
                writeln;
           end;
     until not ((c = '4') and (meunumero2 = 0));
     writeln('--------------------------------');
     case c of
          '1': writeln('Resultado: ', calculadora(1, meunumero1, meunumero2):0:2);
          '2': writeln('Resultado: ', calculadora(2, meunumero1, meunumero2):0:2);
          '3': writeln('Resultado: ', calculadora(3, meunumero1, meunumero2):0:2);
          '4': writeln('Resultado: ', calculadora(4, meunumero1, meunumero2):0:2);
     end;
     readln;
end.
