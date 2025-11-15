
Unit UnitCapacitaciones;

{$CODEPAGE UTF8}

Interface

Uses crt;

Type 
  T_Capacitaciones = Record
    Codigo_Capacitacion: string[10];
    // Unico identificador
    Nombre_Capacitacion: string[50];
    Fecha_Inicio: string[10];
    // Formato DD/MM/AAAA
    Fecha_Fin: string[10];
    Tipo_Capacitacion: string[10];
    // Curso/taller/seminario
    Cantidad_Horas: integer;
    Docentes: string[100];
    // Lista separada por comas(,)
    Cantidad_Alumnos: integer;
    Area: string[10];
    // ISI, LOI, ELECTRO, Civil o General
    Estado_Capacitacion: boolean;
  End;

Procedure Cargar_Capacitacion(Var c: T_Capacitaciones);
Procedure Mostrar_Capacitacion(Var c: T_Capacitaciones);

Implementation

Procedure Cargar_Capacitacion (Var c: T_Capacitaciones);

Var 
  Opcion_Estado: char;
Begin
  clrscr;
  textcolor(LightCyan);
  writeln('--- Carga de Capacitacion ---');
  textcolor(LightGreen);
  write('Codigo: ');
  textcolor(white);
  readln(c.Codigo_Capacitacion);

  textcolor(LightGreen);
  write('Nombre: ');
  textcolor(white);
  readln(c.Nombre_Capacitacion);

  textcolor(LightGreen);
  write('Fecha de inicio (DD/MM/AAAA): ');
  textcolor(white);
  readln(c.Fecha_Inicio);

  textcolor(LightGreen);
  write('Fecha de fin (DD/MM/AAAA): ');
  textcolor(white);
  readln(c.Fecha_Fin);

  textcolor(LightGreen);
  write('Tipo (curso/taller/seminario): ');
  textcolor(white);
  readln(c.Tipo_Capacitacion);

  textcolor(LightGreen);
  write('Cantidad de horas: ');
  textcolor(white);
  readln(c.Cantidad_Horas);

  textcolor(LightGreen);
  write('Docentes (separados por coma): ');
  textcolor(white);
  readln(c.Docentes);

  textcolor(LightGreen);
  write('Cantidad de alumnos inscriptos: ');
  textcolor(white);
  readln(c.Cantidad_Alumnos);

  textcolor(LightGreen);
  write('Area (ISI/LOI/Civil/Electro/General): ');
  textcolor(white);
  readln(c.Area);
  Repeat
    write('Estado (A = activo / N = no activo): ');
    readln(Opcion_Estado);
    Opcion_Estado := upcase(Opcion_Estado);
    // upcase pone todo el mayus
  Until (Opcion_Estado = 'A') Or (Opcion_Estado = 'N');
  c.Estado_Capacitacion := Opcion_Estado = 'A';
  //si es A es true y si es N es false
End;

Procedure Mostrar_Capacitacion (Var c:T_Capacitaciones);
Begin
  textcolor(LightCyan);
  writeln('--- Capacitacion ---');
  textcolor(white);
  writeln('Codigo: ', c.Codigo_Capacitacion);
  writeln('Nombre: ', c.Nombre_Capacitacion);
  writeln('Fecha inicio: ', c.Fecha_Inicio);
  writeln('Fecha fin: ', c.Fecha_Fin);
  writeln('Tipo: ', c.Tipo_Capacitacion);
  writeln('Horas: ', c.Cantidad_Horas);
  writeln('Docentes: ', c.Docentes);
  writeln('Alumnos inscriptos: ', c.Cantidad_Alumnos);
  writeln('Area: ', c.Area);
  If c.Estado_Capacitacion Then
    writeln('Estado: Activo')
  Else
    writeln('Estado: No activo');
  textcolor(yellow);
  writeln('-------------------------------');
  textcolor(white);
End;

End.
