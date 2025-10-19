
Program AvancesProyecto;

Uses crt, CargasYMuestras, UnitMenuAlumnos, UnitMenuCapacitaciones,
UnitMenuListados, UnitMenuEstadisticas;

Var 
  opcion: integer;

Procedure Mostramos_Menu_Principal;
Begin
  //textbackground cambia color de fondo hasta un clrscr
  //textcolor cambia color de texto siguiente
  clrscr;
  TextColor(Yellow);
  writeln('============================ ');
  TextColor(LightCyan);
  writeln('        MENU PRINCIPAL       ');
  TextColor(Yellow);
  writeln('============================ ');
  TextColor(LightCyan);
  writeln('1. Capacitaciones            ');
  writeln('2. Alumnos                  ');
  writeln('3. Listados                  ');
  writeln('4. Estadisticas                  ');
  writeln('0. Salir                     ');
  writeln('---------------------------- ');
  TextColor(LightGreen);
  writeln('Ingrese una opcion:          ');
  TextColor(White);
End;

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
         End;
      Else
        Begin
          clrscr;
          writeln('Opcion invalida.');
          writeln('Presione una tecla para continuar...');
          readkey;
        End;
    End;
  Until opcion = 0;
End.
