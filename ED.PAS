program ED;
const MAX = 100;
type registro = record
     info  : string;
     ant   : integer;
     lig   : i
     end;
type lista = record
     nelem : integer;
     a : array[1..MAX] of registro;
     end;

var
   L : lista;

