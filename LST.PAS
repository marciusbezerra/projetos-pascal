unit LST;
interface
type registro = record
     info : string;
     lig  : integer;
     end;

type lista = record
     rec : array[1..100] of registro;
     dispo, prim : integer;
     end;

procedure init(var l : lista);
procedure Insere(var l : lista; texto : string);
function Remove(var l : lista; texto : string) : boolean;
procedure Imprime(var l : lista);

implementation

procedure obter_no(var l : lista; var item : integer);

begin
     item := l.dispo;
     l.dispo := l.rec[l.dispo].lig;
end;

procedure devolver_no(var l : lista; item : integer);
begin
     l.rec[item].lig := l.dispo;
     l.dispo := item;
end;

procedure init(var l : lista);
var
   id : integer;
begin
     l.dispo := 1;
     l.prim := 0;
     for id := 1 to 99 do
         l.rec[id].lig := id + 1;
     l.rec[100].lig := 0;
end;

procedure Insere(var l : lista; texto : string);
var
   n1, n2, n3 : integer;
begin
     obter_no(l, n1);
     l.rec[n1].info := texto;
     if (l.prim = 0) then
     begin
          l.rec[n1].lig := 0;
          l.prim := 1;
     end
     else
     begin
         if (texto < (l.rec[l.prim].info)) then
         begin
              l.rec[n1].lig := l.prim;
              l.prim := n1;
         end
         else
         begin
              n3 := l.prim;
              n2 := n3;
              while l.rec[n3].lig <> 0 do
              begin
                   if texto > l.rec[l.rec[n3].lig].info then
                   begin
                        n3 := l.rec[n3].lig;
                        n2 := n3;
                   end
                   else
                       n3 := l.rec[n3].lig;
             end;
             l.rec[n1].lig := l.rec[n2].lig;
             l.rec[n2].lig := n1;
         end;
     end;
end;
function Remove(var l : lista; texto : string) : boolean;
var
   n1, n2, n3 : integer;
begin
     remove := true;
     if (l.prim = 0) or (texto < (l.rec[l.prim].info)) then
        remove := false
     else
     if l.rec[l.prim].info = texto then
     begin
          n1 := l.prim;
          l.prim := l.rec[l.prim].lig;
          devolver_no(l, n1);
     end
     else
     begin
          n3 := l.prim;
          while (l.rec[n3].info <> texto) and (l.rec[n3].lig <> 0) do
          begin
               n2 := n3;
               n3 := l.rec[n3].lig;
          end;
          if l.rec[n3].info = texto then
          begin
               l.rec[n2].lig := l.rec[n3].lig;
               n1 := n3;
               devolver_no(l, n1);
          end
          else
              remove := false;
     end;
end;


procedure Imprime(var l : lista);
var
   n1, n2 : integer;
begin
     n2 := l.prim;
     n1 := n2;
     while l.rec[n2].lig <> 0 do
     begin
          writeln(l.rec[n2].info);
          n2 := l.rec[n2].lig;
          n1 := n2;
     end;
     if l.prim <> 0 then
        writeln(l.rec[n2].info);
end;

{inicializa‡Æo}
begin
end.
