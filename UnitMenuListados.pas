
Unit UnitMenuListados;

Interface

Uses crt;

Procedure Menu_Listados;

Implementation

Procedure Menu_Listados;

Var 
  opcion: integer;
Begin
  Repeat
    clrscr;
    textcolor(yellow);
    writeln('=======================================');
    textcolor(LightCyan);
    writeln('            MENU DE LISTADOS           ');
    textcolor(yellow);
    writeln('=======================================');
    textcolor(white);
    writeln('1) Listado de todas las capacitaciones por area y nombre');
    writeln('2) Listado de las capacitaciones de un alumno');
    writeln('3) Listado de alumnos aprobados en una capacitacion');
    writeln('4) Generar certificado de aprobacion (capacitacion/alumno)');
    writeln('5) Volver al menu anterior');
    writeln('---------------------------------------');
    write('Ingrese una opcion: ');
    readln(opcion);

    clrscr;
    Case opcion Of 
      1:
         Begin
           writeln('>> Listado de capacitaciones por area y nombre');
           writeln('Aca llamariamos al procedimiento...');
         End;

      2:
         Begin
           writeln('>> Listado de capacitaciones de un alumno');
           writeln('Aca llamariamos al procedimiento...');
         End;

      3:
         Begin
           writeln('>> Listado de alumnos aprobados en una capacitacion');
           writeln('Aca llamariamos al procedimiento...');
         End;

      4:
         Begin
           writeln('>> Generar certificado de aprobacion');
           writeln('Aca llamariamos al procedimiento...');
         End;

      5: writeln('Volviendo al menu anterior...');
      Else
        writeln('Opcion incorrecta, intente nuevamente.');
    End;

    If opcion <> 5 Then
      Begin
        writeln;
        writeln('Presione ENTER para continuar...');
        readln;
      End;

  Until opcion = 5;
End;

End.
