unit Listas;
interface
uses crt;
type lista= ^rec;
      rec = record
         info:string;
         lig: lista;
       end;
var Registro, i :integer;
    ListaAtual  :lista;

procedure Inserir(var lst : lista; texto : string);
function Remover(var lst : lista; texto : string) : boolean;
procedure Imprimir(lst : lista);
procedure Init(lst : lista);

implementation

procedure Inserir(var lst : lista; texto : string);

var j, p :lista;

    begin
         new(j);
         j^.info:=texto;
         if (lst = nil) or (texto < lst^.info) then
         begin
              j^.lig := lst;
              lst := j;
         end
         else
         begin
              p := lst;
              while (p^.lig <> nil) and (texto > p^.lig^.info) do
              begin
                   p := p^.lig;
                   j^.lig := p^.lig;
                   p^.lig := j;
              end;
         end;
    end;

function Remover(var lst : lista; texto : string) : boolean;

var p, v : lista;

begin
     Remover := true;
    if (lst = nil) or (texto < lst^.info) then
       Remover := false
    else
        if (texto = lst^.info) then
        begin
             p := lst;
             lst := lst^.lig;
             Dispose(p);
        end
        else
        begin
            v:=lst;
            while (v^.info <> texto) and (v <> nil) do
            begin
                 p:=v;
                 v:=v^.lig;
            end;
            if  (v^.info = texto) then
            begin
                 p^.lig:=v^.lig;
                 Dispose(v);
            end
            else
                Remover := false;
        end;
end;

procedure Imprimir(lst : lista);
var x : lista;
begin
     x := lst;
     while (x <> nil) do
     begin
          writeln(x^.info);
          x := x^.lig;
     end;
end;

procedure Init(lst : lista);
begin
     lst := nil;
end;

begin
end.