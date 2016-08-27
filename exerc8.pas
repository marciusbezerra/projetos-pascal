program vandik;

uses
    crt;

var
   x : integer;
   xstr : string;

function funcao_extenso(meunumero : real; financeiro : boolean) : string;
var
    cc, Ntamanho : Integer;
    Cvalor, Cparte, Cfinal, meunumerostr : String;
    gru, txt : array[1..4] of String;
    uni : array[0..19] of String;
    dez, cen : array[0..9] of String;

function esq(vTex : string; inicio, tamanho : integer) : string;
var
   ret : string;
   contador : integer;
begin
     if inicio > length(vTex) then
     begin
          esq := '';
          exit;
     end;
     if ((inicio - 1) + tamanho) > length(vTex) then
          tamanho := length(vTex) - inicio + 1;

     ret := '';

     for contador := inicio to inicio - 1 + tamanho do
          ret := ret + vTex[contador];

     esq := ret;
end;

function frmt(meunumero : real) : string;
var
 meunumerostr : string;
 len, contador : integer;
begin
     str(meunumero:0:2, meunumerostr);
     if length(meunumerostr) < 13 then
     begin
          len := 13 - length(meunumerostr);
          for contador := 1 to len do
              meunumerostr := '0' + meunumerostr;
     end;
     frmt := meunumerostr;
end;

function vlr(vTex : string) : real;
var
   ret : real;
   cd  : integer;
begin
     val(vTex, ret, cd);
     vlr := ret;
end;

begin
    If meunumero < 0 then
       meunumero := meunumero * -1;
    if (meunumero > 9999999.99) or (meunumero = 0) Then
    begin
         funcao_extenso := '';
         exit;
    end;
    uni[0] := '';
    uni[1] := 'um '; uni[2] := 'dois '; uni[3] := 'tres ';
    uni[4] := 'quatro '; uni[5] := 'cinco '; uni[6] := 'seis '; uni[7] := 'sete ';
    uni[8] := 'oito '; uni[9] := 'nove '; uni[10] := 'dez '; uni[11] := 'onze ';
    uni[12] := 'doze '; uni[13] := 'treze '; uni[14] := 'quatorze '; uni[15] := 'quinze ';
    uni[16] := 'dezesseis '; uni[17] := 'dezessete '; uni[18] := 'dezoito '; uni[19] := 'dezenove ';

    dez[0] := '';
    dez[1] := 'dez '; dez[2] := 'vinte '; dez[3] := 'trinta '; dez[4] := 'quarenta ';
    dez[5] := 'cinquenta '; dez[6] := 'sessenta '; dez[7] := 'setenta '; dez[8] := 'oitenta ';
    dez[9] := 'noventa ';

    cen[0] := '';
    cen[1] := 'cento '; cen[2] := 'duzentos '; cen[3] := 'tezentos '; cen[4] := 'quatrocentos ';
    cen[5] := 'quinhentos '; cen[6] := 'seiscentos '; cen[7] := 'setecentos '; cen[8] := 'oitocentos ';
    cen[9] := 'novecentos ';

    meunumerostr := frmt(meunumero);

    gru[1] := esq(meunumerostr, 2, 3);
    gru[2] := esq(meunumerostr, 5, 3);
    gru[3] := esq(meunumerostr, 8, 3);
    gru[4] := '0' + esq(meunumerostr, 12, 2);

    txt[1] := '';
    txt[2] := '';
    txt[3] := '';
    txt[4] := '';

    for cc := 1 To 4 do
    begin
        Cparte  := gru[cc];

        if vlr(Cparte) < 10 then
        begin
           Ntamanho := 1
        end
        else if vlr(Cparte) < 100 then
        begin
             Ntamanho := 2
        end
        else if vlr(Cparte) < 1000 then
        begin
             Ntamanho := 3
        end;
        If Ntamanho = 3 Then
            If esq(Cparte, length(Cparte) - 1, 15) <> '00' Then
            begin
                txt[cc] := txt[cc] + cen[trunc(vlr(esq(Cparte, 1, 1)))] + 'e ';
                Ntamanho := 2;
            end
            Else
                if esq(Cparte, 1, 1) = '1' then
                   txt[cc] := txt[cc] + 'cem '
                else
                    txt[cc] := txt[cc] + cen[trunc(vlr(esq(Cparte, 1, 1)))];
        If Ntamanho = 2 Then
        begin
            If vlr(esq(Cparte, length(Cparte) - 1, 15)) < 20 Then
                txt[cc] := txt[cc] + uni[trunc(vlr(esq(Cparte, length(Cparte) - 1, 15)))]
            Else
            begin
                txt[cc] := txt[cc] + dez[trunc(vlr(esq(Cparte, 2, 1)))];
                If esq(Cparte, length(Cparte), 15) <> '0' Then
                begin
                    txt[cc] := txt[cc] + 'e ';
                    Ntamanho := 1;
                End;
            End;
        end;
        If Ntamanho = 1 Then
            txt[cc] := txt[cc] + uni[trunc(vlr(esq(Cparte, length(Cparte), 15)))];
    end;

        If ((vlr(gru[1]) + vlr(gru[2]) + vlr(gru[3])) = 0) And (vlr(gru[4]) <> 0) Then
        begin
            If vlr(gru[4]) = 1 then
            begin
                 if financeiro then
                    Cfinal := txt[4] + 'centavo '
                 else
                     Cfinal := txt[4] + 'quebrado ';
            end
            else
            begin
                 if financeiro then
                    Cfinal := txt[4] + 'centavos '
                 else
                     Cfinal := txt[4] + 'quebrados ';
            end;
        end
        Else
        begin
            Cfinal := '';
            If vlr(gru[1]) <> 0 then
            begin
               If vlr(gru[1]) > 1 then
                  Cfinal := Cfinal + txt[1] + 'milhäes '
               else
                   Cfinal := Cfinal + txt[1] + 'milhÆo '
            end
            else
            begin
                 Cfinal := Cfinal;
            end;
            If (vlr(gru[2]) + vlr(gru[3])) = 0 Then
                Cfinal := Cfinal + 'de '
            Else
                If vlr(gru[2]) <> 0 then
                   Cfinal := Cfinal + txt[2] + 'mil '
                else
                    Cfinal := Cfinal;

            If ((vlr(gru[1]) + vlr(gru[2]) + vlr(gru[3])) = 1) then
            begin
                 if financeiro then
                    Cfinal := Cfinal + txt[3] + 'real '
                 else
                     Cfinal := Cfinal + txt[3];
            end
            else
            begin
                 if financeiro then
                    Cfinal := Cfinal + txt[3] + 'reais '
                 else
                     Cfinal := Cfinal + txt[3];
            end;

            If vlr(gru[4]) <> 0 then
            begin
               If vlr(gru[4]) = 1 then
               begin
                    if financeiro then
                       Cfinal := Cfinal + 'e ' + txt[4] + 'centavo '
                    else
                        Cfinal := Cfinal + 'e ' + txt[4] + 'quebrado ';
               end
               else
               begin
                    if financeiro then
                       Cfinal := Cfinal + 'e ' + txt[4] + 'centavos '
                    else
                        Cfinal := Cfinal + 'e ' + txt[4] + 'quebrados ';
               end;
            end
            else
                Cfinal := Cfinal;
        End;
        funcao_extenso := Cfinal;
End;

begin
     repeat
     clrscr;
     writeln('**************************************************');
     writeln('N£mero de dois d¡gitos por extenso');
     writeln('**************************************************');
     writeln;
     write('Digite um valor numerico (0 a 99): ');
     readln(x);
     str(x:0, xstr);
     if length(xstr) > 2 then
     begin
          write('M ximo de dois d¡gitos num‚ricos!');
          readln;
     end;
     until (length(xstr) <= 2);
     writeln;
     if x = 0 then
     begin
        writeln('Voce digitou zero.');
     end
     else
     begin
          if x < 0 then
             writeln('Voce digitou ', funcao_extenso(x, false), '(negativo).')
          else
              writeln('Voce digitou ', funcao_extenso(x, false), '.');
     end;
     readln;
end.
