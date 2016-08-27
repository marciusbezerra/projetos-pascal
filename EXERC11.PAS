program vandik;
uses
    crt;
var
   i, meunumero : integer;
   f : text;
   linha: string;

function funcao_extenso(meunumero : real; financeiro : boolean) : string; {MODIFICADA}
var
    cc, Ntamanho : Integer;
    Cvalor, Cparte, Cfinal, meunumerostr : String;
    gru, txt : array[1..4] of String;
    uni : array[0..19] of String;
    dez : array[0..9] of String;

function esq(vTex : string; inicio, tamanho : integer) : string;
var
   ret : string;
   i : integer;
begin
     if inicio > length(vTex) then
     begin
          esq := '';
          exit;
     end;
     if ((inicio - 1) + tamanho) > length(vTex) then
          tamanho := length(vTex) - inicio + 1;

     ret := '';

     for i := inicio to inicio - 1 + tamanho do
          ret := ret + vTex[i];

     esq := ret;
end;

function frmt(meunumero : real) : string;
var
 meunumerostr : string;
 len, i : integer;
begin
     str(meunumero:0:2, meunumerostr);
     if length(meunumerostr) < 13 then
     begin
          len := 13 - length(meunumerostr);
          for i := 1 to len do
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
                  Cfinal := Cfinal + txt[1] + 'milh‰es '
               else
                   Cfinal := Cfinal + txt[1] + 'milh∆o '
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
     clrscr;
     Assign(f, 'extenso.txt');
     Rewrite(f);
     writeln('**************************************************');
     writeln('Arquivo de texto por extenso');
     writeln('**************************************************');
     writeln;
     writeln(f, 'Seu Nome');
     writeln(f);
     for i := 1 to 10 do
     begin
          repeat
          write('Escreva o n£mero (', i, '): ');
          readln(meunumero);
          if (meunumero < 0) or (meunumero > 99) then
          begin
               writeln;
               write('N£meros de 0 a 99! (pressione algo)');
               writeln;
               readln;
          end;
          until (meunumero >= 0) and (meunumero <= 99);
          if meunumero = 0 then
             writeln(f, meunumero, ' - zero')
          else
              writeln(f, meunumero, ' - ' + funcao_extenso(meunumero, false));
     end;
     close(f);
     Reset(f);
     while not Eof(f) do
     begin
          Readln(f, linha);
          Writeln(linha);
     end;
     close(f);
end.
