(***************************************************************************
  Guinther de Bitencourt Pauli - Todos os direitos reservados
  guinther@unifra.br - guinther@clubedelphi.com.br
(***************************************************************************)
Unit welc;
(***************************************************************************)
interface
(***************************************************************************)
Procedure welcome;
(***************************************************************************)
implementation
(***************************************************************************)
uses crt,kcrt,Graph;
(***************************************************************************)
procedure ofoto;
var
  Fbmp : text;
  x,y,c,num : integer;
  line : string;
begin
 assign(Fbmp,'foto.gin');
 reset(Fbmp);
 for x:=1 to 110 do
 begin
      c:=1;
      readln(FBmp,line);
       for y:=1 to 110 do
      begin
          num:=(strtoint(line[c])*10)+strtoint(line[c+1]);
          PutPixel(y+370,x+120,num);
          c:=c+2;
      end;
  end;
end;
(***************************************************************************)
Procedure welcome;
var
   Gd, Gm : Integer;
   color,num,x,y,i,j : integer;
begin
 Gd := detect;
 InitGraph(Gd, Gm, ' ');
 rectangle(100,100, 500,310);
 SetFillStyle(1,1);
 FloodFill(150,150,15);

 setrgbpalette(1,10,220,242);

 settextstyle(1,horizdir,4);

  setcolor(0);
  outtextxy(115,115,'Personal Farm');
  setcolor(15);
  outtextxy(110,110,'Personal Farm');

   {
   settextstyle(1,horizdir,1);
   setcolor(0);
   outtextxy(280,155,'Beta 1.0');
   setcolor(15);
   outtextxy(275,150,'Beta 1.0');}


  settextstyle(2,horizdir,5);
  setcolor(14);
  outtextxy(130,160,'Sistema Avan‡ado');
  outtextxy(130,175,'de Controle de Farm cias');

  settextstyle(1,horizdir,1);

{  setcolor(8);
  outtextxy(122,302,'Farm cia Pauli');
  setcolor(15);
  outtextxy(120,300,'Farm cia Pauli');}


  settextstyle(2,horizdir,4);
  setcolor(15);
  outtextxy(122,212,'Network Client/Server');
  outtextxy(122,232,'Code Bar Tecnology');
  outtextxy(122,252,'Year 2000 Ok');
  outtextxy(122,272,'DB Fast');

  setcolor(11);
{  outtextxy(120,325,'Vera Cruz - RS');}
  outtextxy(335,275,'Programador do Sistema');


   settextstyle(1,horizdir,1);
   setcolor(0);
   outtextxy(337,252,'Guinther Pauli');
   setcolor(15);
   outtextxy(335,250,'Guinther Pauli');
   ofoto;
  repeat
  until keypressed;
  if readkey=#0 then
  readkey;
  CloseGraph;
end;
(***************************************************************************)
begin
end.
