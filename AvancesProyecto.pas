
Program AvancesProyecto;

Uses crt, CargasYMuestras, UnitMenuAlumnos, UnitMenuCapacitaciones,
UnitMenuListados, UnitMenuEstadisticas, UnitMenuPrincipal;

Var 
  opcion: integer;

Begin
  Repeat
    Mostramos_Menu_Principal;
    readln(opcion);
    Case opcion Of 
      1: Menu_Capacitaciones;
      2: Menu_Alumnos;
      3: Menu_Listados;
      4: Menu_Estadisticas;
      0:
         Begin
           clrscr;
           writeln('Saliendo del programa...');
           delay(1000);
           //delay le agrega tiempo al mostrar
         End;
      Else
        Begin
          clrscr;
          writeln('Opcion invalida.');
          writeln('Presione una tecla para volver...');
          readkey;
        End;
    End;
  Until opcion = 0;

End.
