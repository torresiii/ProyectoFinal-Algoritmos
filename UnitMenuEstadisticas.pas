
Unit UnitMenuEstadisticas;

Interface

Uses crt;

Procedure Menu_Estadisticas;

Implementation

Procedure Menu_Estadisticas;

Var 
  opcion: integer;
Begin
  Repeat
    clrscr;
    textcolor(yellow);
    writeln('=======================================');
    textcolor(LightCyan);
    writeln('         MENU DE ESTADISTICAS         ');
    textcolor(yellow);
    writeln('=======================================');
    textcolor(white);
    writeln('1) Cantidad de capacitaciones entre fechas');
    writeln('2) Porcentaje de capacitaciones por area');
    writeln('3) Estadistica a eleccion');
    writeln('4) Volver al menu anterior');
    writeln('---------------------------------------');
    write('Ingrese una opcion: ');
    readln(opcion);

    clrscr;
    Case opcion Of 
      1:
         Begin
           writeln('>> Cantidad de capacitaciones entre fechas');
           writeln('Aca llamariamos al procedimiento...');
         End;

      2:
         Begin
           writeln('>> Porcentaje de capacitaciones por area');
           writeln('Aca llamariamos al procedimiento...');
         End;

      3:
         Begin
           writeln('>> Estadistica a eleccion');
           writeln('Aca llamariamos al procedimiento...');
         End;

      4: writeln('Volviendo al menu anterior...');
      Else
        writeln('Opcion incorrecta, intente nuevamente.');
    End;

    If opcion <> 4 Then
      Begin
        writeln;
        writeln('Presione ENTER para continuar...');
        readln;
      End;

  Until opcion = 4;
End;

End.
