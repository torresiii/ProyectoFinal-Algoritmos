
Unit UnitMenuPrincipal;

{$CODEPAGE UTF8}

Interface

Uses crt;

Procedure Mostramos_Menu_Principal;

Implementation

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

End.
