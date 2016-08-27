program tela;
uses crt;
label inicio;
var i, ini, fim : integer; c : char;
begin
ini := 0; fim := 16;
inicio:
textbackground(black);
clrscr;
textbackground(3);
textcolor(yellow);
writeln( 'ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป');
writeln( 'บ           C เ D I G O   A S C I I   por Marcius Carneiro Bezerra            บ');
writeln( 'ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ');
writeln( 'ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ Use as setas ', chr(24), ' ', chr(25) , ' do tecla numerico | ESC Finaliza');
writeln( '                                                                               ');
textbackground(0);
{201, 205, 187, 200, 188}
for i := ini to fim do
    if i in [0,7,8,9,10,13] then
    begin
       textcolor(7); write(i:10, ' =  '); write(i+51:10, ' = ');
       textcolor(white); write(chr(i+51)); textcolor(7); write(i+102:10, ' = '); textcolor(white); write(chr(i+102));
       textcolor(7); write(i+153:10, ' = '); textcolor(white); write(chr(i+153)); textcolor(7); write(i+204:10, ' = ');
       textcolor(white); writeln(chr(i+204), '         ');
    end
    else
    begin
       textcolor(7); write(i:10, ' = '); textcolor(white); write(chr(i)); textcolor(7); write(i+51:10, ' = ');
       textcolor(white); write(chr(i+51)); textcolor(7); write(i+102:10, ' = '); textcolor(white); write(chr(i+102));
       textcolor(7); write(i+153:10, ' = '); textcolor(white); write(chr(i+153)); textcolor(7); write(i+204:10, ' = ');
       textcolor(white); writeln(chr(i+204), '         ');
    end;
textbackground(3);
textcolor(yellow);
writeln( 'ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ');
writeln( '     Os caracteres de cขdigo 0, 7, 8, 9, 10, 13, 255 sฦo respectivamente:      ');
  write( ' Nulo (ou EOF), Beep, Backspace, Tab, Retorno de carro, Avano de linha, Nulo  ');
c := readkey;
 if ord(c) = 50 then
 begin
    if ini = 35 then
    begin
         sound(350);
         delay(200);
         nosound;
         goto inicio;
    end
    else
    begin
         ini := ini + 1;
         fim := fim + 1;
         goto inicio;
    end;
 end
 else if ord(c) = 56 then
 begin
    if ini = 0 then
    begin
         sound(350);
         delay(200);
         nosound;
         goto inicio;
    end
    else
    begin
         ini := ini - 1;
         fim := fim - 1;
         goto inicio;
    end;
 end
 else if ord(c) = 27 then
 begin
      textbackground(0);
      textcolor(7);
      clrscr;
      halt;
 end
 else
     goto inicio;
end.