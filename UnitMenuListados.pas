
Unit UnitMenuListados;

{$CODEPAGE UTF8}

Interface

Uses 
crt, SysUtils, UnitProceduresListados;

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
    textcolor(LightGreen);
    write('Ingrese una opcion: ');
    textcolor(white);
    readln(opcion);

    clrscr;
    Case opcion Of 
      1: Listado_Capacitaciones_Por_Area_Nombre;
      2: Listado_Capacitaciones_Por_Alumno;
      3: writeln('Opcion en desarrollo...');
      4: writeln('Opcion en desarrollo...');
      5: writeln('Volviendo al menu anterior...');
      Else writeln('Opcion incorrecta, intente nuevamente.');
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
