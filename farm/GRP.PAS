(* por rudolfo pauli - rudolfo@cpd.ufsm.br *)
unit grp;

interface
procedure grafico(a:array of real;tipo:byte;ss:string);
procedure demogrp;
implementation

uses crt, graph,dos;


(****************************************************************************)
{procedure graficocomparativo(a,b:array of real;ss:string);
var
	x,y,i:integer;
	esc,r1,r2,alfa1,alfa2:real;
begin
	x:=0;y:=0;
	initgraph(x,y,'\\rudolfo\c\pas');
	a[0]:=1;
	b[0]:=1;
	for i:=1 to 31 do
	begin
		if a[i]>a[0] then
			a[0]:=a[i];
		if b[i]>b[0] then
			b[0]:=b[i];
	end;
	esc:=360/a[0];
	if b[0]>a[0] then
		esc:=360/b[0];


	setlinestyle(0,2,1);
	for i:=1 to 31 do
	begin
		if i<=30 then
		begin
			alfa1:=((a[i+1]-a[i])/20*esc)*-1;
			alfa2:=((b[i+1]-b[i])/20*esc)*-1;
			for x:=0 to 19 do
			begin   (******** a ***********)
				setcolor(1);
				if a[i]>a[i+1] then
					for y:=trunc((460-a[i]*esc)+(alfa1*x)) to trunc((460-a[i]*esc)+(alfa1*(x+1))) do
					begin
						line((i*20)+x,y,(i*20)+x+1,y);
						delay(2);
					end
				else
					for y:=trunc((460-a[i]*esc)+(alfa1*x)) downto trunc((460-a[i]*esc)+(alfa1*(x+1))) do
					begin
						line((i*20)+x,y,(i*20)+x+1,y);
						delay(2);
					end;
					(*********** b *************)
				setcolor(4);
				if b[i]>b[i+1] then
					for y:=trunc((460-b[i]*esc)+(alfa2*x)) to trunc((460-b[i]*esc)+(alfa2*(x+1))) do
					begin
						line((i*20)+x,y,(i*20)+x+1,y);
						delay(2);
					end
				else
					for y:=trunc((460-b[i]*esc)+(alfa2*x)) downto trunc((460-b[i]*esc)+(alfa2*(x+1))) do
					begin
						line((i*20)+x,y,(i*20)+x+1,y);
						delay(2);
					end;
			end;
			setcolor(1);
			setfillstyle(1,1);
			pieslice(i*20,trunc(int(460-a[i]*esc)),0,360,3);
			setcolor(4);
			setfillstyle(1,4);
			pieslice(i*20,trunc(int(460-b[i]*esc)),0,360,3);

		end;
	end;
	setcolor(1);
	setfillstyle(1,1);
	pieslice(620,trunc(int(460-a[31]*esc)),0,360,3);
	setcolor(4);
	setfillstyle(1,4);
	pieslice(620,trunc(int(460-b[31]*esc)),0,360,3);
	readkey;
	closegraph;
end;
}
(****************************************************************************)
(****************************************************************************)
procedure grafico(a:array of real;tipo:byte;ss:string);
const
	grade_bar3d=9;
	cor_linhas_fundo=1;
	textura_torta=9;
var
	x,y,i,j: integer;
	esc,r,ai:real;
	st:string;
(****************************************************************************)
procedure graficoxy;
var
	x,y:integer;
begin
	setlinestyle(0,2,3);
	if i<31 then
	begin
		r:=((a[i+1]-a[i])/20*esc)*-1;
		for x:=0 to 19 do
			if a[i]>a[i+1] then
			begin
				for y:=trunc((460-a[i]*esc)+(r*x)) to trunc((460-a[i]*esc)+(r*(x+1))) do
				begin
					if r>1.5 then
						setcolor(4)
					else
						setcolor(14);
					{y:=trunc((460-a[i]*esc)+(r*x));}
					line((i*20)+x,y,(i*20)+x+1,y);
					delay(2);
					while keypressed do
						readkey;
				end;
			end
			else
				for y:=trunc((460-a[i]*esc)+(r*x)) downto trunc((460-a[i]*esc)+(r*(x+1))) do
				begin
					{y:=trunc((460-a[i]*esc)+(r*x));}
					setcolor(2);
					line((i*20)+x,y,(i*20)+x+1,y);
					delay(2);
					while keypressed do
						readkey;
				end;

		{line(i*20,trunc(int(460-a[i]*esc)),(i+1)*20,trunc(int(460-a[i+1]*esc)));}
	end;
	setcolor(11);
	setfillstyle(1,11);
	pieslice(i*20,trunc(int(460-a[i]*esc)),0,360,3);
	setcolor(15);
end;
(****************************************************************************)
procedure graficoarea;
var
	j:integer;
begin
	setlinestyle(0,2,3);
	setcolor(9);
	if i<31 then
		line(i*20,trunc(int(460-a[i]*esc)),(i+1)*20,trunc(int(460-a[i+1]*esc)))
	else
		begin
			setfillstyle(9,9);
			line(620,trunc(int(460-a[31]*esc)),620,460);
			line(620,460,20,460);
			line(20,trunc(int(460-a[1]*esc)),20,460);
			for j:=1 to 30 do
				if trunc(int(460-a[j]*esc))<458 then
					floodfill((j*20)+2,458,9);
			if trunc(int(460-a[31]*esc))<458 then
			floodfill(618,458,9);
			setcolor(15);
		end;
	delay(50);
	while keypressed do
			readkey;
end;
(****************************************************************************)
procedure graficotorta;
var
	i,k:integer;
	coord:ArcCoordsType;
begin
	setcolor(15);
	settextjustify(0,1);
	settextstyle(7,0,2);
	outtextxy(15,10,ss);
	settextjustify(2,1);
	settextstyle(0,0,1);
	for i:=2 to 33 do
		line(10,i*14,112,i*14);
	line(10,28,10,462);
	line(40,28,40,462);
	line(112,28,112,462);
	ai:=0;
	for i:=1 to 31 do
		if a[i]<>0 then
		begin
			setfillstyle(0,0);
			setcolor(0);
			pieslice(380,240,trunc(ai),trunc(ai+(a[i]/r*360)),210);
			getarccoords(coord);

			setcolor((trunc(a[i]/a[0]*100) div 7)+1);
			setfillstyle(textura_torta,(trunc(a[i]/a[0]*100) div 7)+1);
			pieslice(380,240,trunc(ai),trunc(ai+(a[i]/r*360)),200);
			setcolor(15);
			str(i,st);
			if coord.xstart<>380 then
				with coord do
					outtextxy(trunc((xstart+xend)/2),trunc((ystart+yend)/2),st);
			ai:=ai+a[i]/r*360;

			setcolor((trunc(a[i]/a[0]*100) div 7)+1);
			str(i,st);
			outtextxy(35,i*14+22,st);
			str(a[i]:2:1,st);
			st[ord(st[0])-1]:=',';
			outtextxy(110,i*14+22,st);

		delay(100);
		while keypressed do
			readkey;
	end;
	readkey;
end;
(****************************************************************************)
procedure graficotorta3d;
type
	xytype=record
	x,y:integer;
	end;
const
	xo=380;
	yo=240;
	h=50;
	altura=45;
	largura=250;
var
	i,k:integer;
	xyc:array[1..31]of xytype;
	coord,coordaux:ArcCoordsType;
begin
	setcolor(15);
	settextjustify(0,1);
	settextstyle(7,0,2);
	outtextxy(15,10,ss);
	settextjustify(2,1);
	settextstyle(0,0,1);
	for i:=2 to 33 do
		line(10,i*14,112,i*14);
	line(10,28,10,462);
	line(40,28,40,462);
	line(112,28,112,462);
	setcolor(0);
	ai:=0;
	for k:=1 to 31 do
	begin
		ellipse(xo,yo,trunc(ai),trunc(ai+(a[k]/r*360)),largura-4,altura-3);
		getarccoords(coord);
		with coord do
		begin
			xyc[k].x:=trunc((xstart+xend)/2);
			xyc[k].y:=trunc((ystart+yend)/2);
		end;
		ai:=ai+a[k]/r*360;
	end;

	ai:=0;
	for k:=1 to 31 do
	begin
		(****a propria*****)

		setcolor((trunc(a[k]/a[0]*100) div 7)+1);
		setfillstyle(1,(trunc(a[k]/a[0]*100) div 7)+1);
		setlinestyle(0,2,3);
		ellipse(xo,yo,trunc(ai),trunc(ai+(a[k]/r*360)),largura,altura);
		getarccoords(coordaux);
		setlinestyle(0,2,1);
		line(xo,yo,coordaux.xstart,coordaux.ystart);
		line(xo,yo,coordaux.xend,coordaux.yend);
		if getpixel(xyc[k].x,xyc[k].y)=0 then
			floodfill(xyc[k].x,xyc[k].y,(trunc(a[k]/a[0]*100) div 7)+1);
		ai:=ai+a[k]/r*360;
		(*valor quadro*)
		str(k,st);
		if a[0]<>0 then
			setcolor((trunc(a[k]/a[0]*100) div 7)+1);
		outtextxy(35,k*14+22,st);
		str(a[k]:2:1,st);
		st[ord(st[0])-1]:=',';
		outtextxy(110,k*14+22,st);

		delay(120);

	end;
	(*****Pinta altura**********)
	setcolor(1);
	setfillstyle(1,9);
	line(xo-largura,yo,xo-largura,yo+h);
	line(xo+largura,yo,xo+largura,yo+h);
	ellipse(xo,yo,180,360,largura,altura);
	ellipse(xo,yo+h,179,361,largura,altura);
	floodfill(xo,yo+altura+2,1);
	setcolor(0);
	line(xo-largura,yo,xo-largura,yo+h);
	line(xo+largura,yo,xo+largura,yo+h);
	ellipse(xo,yo,180,360,largura,altura);
	ellipse(xo,yo+h,179,361,largura,altura);
	readkey;
end;
(****************************************************************************)
procedure graficobarras;
var
	j:integer;
begin
	setcolor((trunc(a[i]/a[0]*100) div 7)+1);
	setfillstyle(1,(trunc(a[i]/a[0]*100) div 7)+1);
	if a[i]<>0 then
	begin
		for j:=460 downto trunc(int(460-a[i]*esc)) do
			begin
				ellipse(i*20,j,0,360,7,3);
				floodfill(i*20,j,getcolor);
				delay(2);
				while keypressed do
					readkey;
			end;
	end;
	{******* PERCENTAGEM *********}
	settextjustify(1,1);
	settextstyle(2,0,4);
	setcolor(0);
	str(trunc(a[i]/a[0]*100),st);
	outtextxy((i*20),j+3,st);
	setcolor(15);
end;
(****************************************************************************)
procedure graficobar3d;
begin
	setcolor((trunc(a[i]/a[0]*100) div 7)+1);
	setfillstyle(grade_bar3d,(trunc(a[i]/a[0]*100) div 7)+1);
	if a[i]<>0 then
	begin
		bar3d(i*20-5,trunc(int(460-a[i]*esc)),i*20+3,460,4,true);
		delay(100);
		while keypressed do
			readkey;
	end;
	setcolor(15);
end;
(****************************************************************************)
begin
	x:=0;y:=0;
	initgraph(x,y,'');
	setbkcolor(0);
	ai:=0;r:=0;
	for i:=1 to 31 do
		r:=r+a[i];

	a[0]:=1;
	for i:=1 to 31 do
		if a[i]>a[0] then
			a[0]:=a[i];
	case tipo of
	5:graficotorta;
	6:graficotorta3d;
	else
	begin
	settextjustify(1,1);
	settextstyle(7,0,2);
	setcolor(15);
	outtextxy(320,10,ss);
	{***** GRADE *******}
	setcolor(cor_linhas_fundo);
	setlinestyle(0,0,0);
	for x:=1 to 63 do
		line(x*10,30,x*10,460);
	for j:=3 to 46 do
		line(10,j*10,630,j*10);
	esc:=360/a[0];
	{***** ESCALA ********}
	settextjustify(0,0);
	settextstyle(0,0,0);
	setcolor(15);
	str(1/esc:2:2,st);
	st[byte(st[0])-2]:=#44;
	outtextxy(0,15,'Escala : 1 = R$ '+st);

	if tipo=4 then
		for i:=1 to 31 do
			graficoarea;
	for i:=1 to 31 do
	begin
		if tipo=1 then
			graficobarras;
		if tipo=2 then
			graficoxy;
		if tipo=3 then
			graficobar3d;
		(***NUMERO LADO***)
		settextjustify(1,0);
		settextstyle(7,1,1);
		str(a[i]:2:1,st);
		st[byte(st[0])-1]:=#44;
		outtextxy((i*20)-5,trunc(int(460-a[i]*esc))-8,st);
		settextjustify(1,1);
		settextstyle(2,0,4);
		setcolor(15);
		str(i,st);
		outtextxy((i*20),470,st);
	end;
	readkey;
	end;
	end;
	closegraph;
end;
(**************************************************************************)
procedure demogrp;
const b:array[1..31] of real=
	(10,51,95,35,54,14,44,55,98,68,21,97,20,37,38,20,54,85,33,42,71,55,87,77,23,85,12,74,77,10,5);
var
	l:integer;
	aray:array[0..31] of real;
begin
	randomize;
	for l:=1 to 31 do
		aray[l]:=b[l];
	grafico(aray,1,'Barras');
	grafico(aray,2,'Xy');
	grafico(aray,3,'Bar3d');
	grafico(aray,4,'Area');
	grafico(aray,5,'Torta');
	grafico(aray,6,'Torta3d Bruxo');
end;
(**************************************************************************)
(**************************************************************************)
end.
