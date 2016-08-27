program vandik;
uses
    crt;
var
   expl : string;
   c : char;
begin
     expl := '';
     repeat
     clrscr;
     writeln('**************************************************');
     writeln('Ajuda para fun‡äes');
     writeln('**************************************************');
     writeln;
     writeln('Selecione um procedimento:');
     writeln;
     writeln('   1. Str');
     writeln('   2. Length');
     writeln('   3. Val');
     writeln('   4. Copy');
     writeln('   5. Rewrite');
     writeln('   6. Append');
     writeln('   7. Assign');
     writeln('   8. Reset');
     writeln('   0. (Para finalizar)');
     writeln;
     writeln('------------------------------------------------------');
     writeln;
     writeln('Explica‡Æo: ', expl);
     repeat
     c := readkey;
     until c in ['1', '2', '3', '4', '5', '6', '7', '8', '0'];
     case c of
          '1': expl := 'Converte um valor num‚rico para uma string.';
          '2': expl := 'Retorna o tamanho dinamico de uma string.';
          '3': expl := 'Converte o valor de uma string para a sua representa‡Æo num‚rica.';
          '4': expl := 'Copia uma parte de uma string.';
          '5': expl := 'Criar e abre um novo arquivo.';
          '6': expl := 'Abre um arquivo existente para a adi‡Æo de dados.';
          '7': expl := 'Atribui a uma variavel, o nome de um arquivo externo.';
          '8': expl := 'Abre um arquivo existente.';
          '0': clrscr;
     end;
     until c = '0';
end.
