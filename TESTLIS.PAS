program testa;
uses crt, lst;
var x : lista;
begin
     clrscr;
     init(x);
     insere(x, 'sapo');
     insere(x, 'cobra');
     insere(x, 'cabra');
     insere(x, 'livro');
     imprime(x);
     readln;
end.