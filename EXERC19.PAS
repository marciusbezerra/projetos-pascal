program vandik;
uses crt;
var
   c : char;
   result, meunumero1, meunumero2 : real;

procedure menu_de_controle;
begin
     writeln('Selecione uma operaá∆o:');
     writeln;
     writeln('1. Soma');
     writeln('2. Subtraá∆o');
     writeln('3. Multiplicaá∆o');
     writeln('4. Divis∆o');
end;

procedure pegav;
begin
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
end;

function retornav : real;
var
   op : integer;
begin
     case c of
          '1': op := 1;
          '2': op := 2;
          '3': op := 3;
          '4': op := 4;
     end;
     case op of
          1: retornav := meunumero1 + meunumero2;
          2: retornav := meunumero1 - meunumero2;
          3: retornav := meunumero1 * meunumero2;
          4: retornav := meunumero1 / meunumero2;
     end;

end;

begin
     repeat
     clrscr;
     writeln('**************************************************');
     writeln('Calculadora');
     writeln('**************************************************');
     writeln;
     menu_de_controle;
     c := Readkey;
     until (c = '1') or (c = '2') or (c = '3') or (c = '4');
     pegav;
     writeln('Resultado: ', retornav:0:2);
     readln;
end.
