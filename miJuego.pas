
Program miJuego;

Uses Crt;

Var horizontalIndex, verticalIndex, xPlayer, yPlayer : Integer;

Var tecla : Char;
Begin
  xPlayer := 4;
  yPlayer := 8;
  While True Do
    Begin
      For horizontalIndex:= 1 To 8 Do
        Begin
          For verticalIndex:= 1 To 14 Do
            Begin
              If (horizontalIndex = xPlayer) And (verticalIndex = yPlayer) Then
                write('O')
              Else
                write('*');
              write(' ')
            End;
          writeLn('')
        End;
      writeLn('Press key');
      tecla := Readkey;
      If tecla = 'w' Then
        xPlayer := xPlayer-1;
      If tecla = 's' Then
        xPlayer := xPlayer+1;
      If tecla = 'd' Then
        yPlayer := yPlayer+1;
      If tecla = 'a' Then
        yPlayer := yPlayer-1;
      writeLn(tecla);
      ClrScr;
    End;
End.
