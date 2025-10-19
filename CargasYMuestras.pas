
Unit CargasYMuestras;

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

  T_Alumnos = Record
    Codigo_Capacitacion_Alumno: string[10];
    // Unico identificador
    DNI: string[15];
    Apellido_Nombre: string[50];
    Fecha_Nacimiento: string[10];
    // Formato DD/MM/AAAA
    Docente_UTN: string [3];
    // Si o no
    Condicion: string[10];
    // Aprobado/Asistencia
    Estado_Alumno: boolean
  End;


Procedure Cargar_Capacitacion(Var c: T_Capacitaciones);
Procedure Mostrar_Capacitacion(Var c: T_Capacitaciones);
Procedure Cargar_Alumnos(Var a: T_Alumnos);
Procedure Mostrar_Alumno(Var a: T_Alumnos);


Implementation

Procedure Cargar_Capacitacion (Var c: T_Capacitaciones);

Var 
  Opcion_Estado: char;
Begin
  clrscr;
  writeln('--- Carga de Capacitacion ---');
  write('Codigo: ');
  readln(c.Codigo_Capacitacion);
  write('Nombre: ');
  readln(c.Nombre_Capacitacion);
  write('Fecha de inicio (DD/MM/AAAA): ');
  readln(c.Fecha_Inicio);
  write('Fecha de fin (DD/MM/AAAA): ');
  readln(c.Fecha_Fin);
  write('Tipo (curso/taller/seminario): ');
  readln(c.Tipo_Capacitacion);
  write('Cantidad de horas: ');
  readln(c.Cantidad_Horas);
  write('Docentes (separados por coma): ');
  readln(c.Docentes);
  write('Cantidad de alumnos inscriptos: ');
  readln(c.Cantidad_Alumnos);
  write('Area (ISI/LOI/Civil/Electro/General): ');
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
  writeln('-------------------------------');
End;

Procedure Cargar_Alumnos(Var a: T_Alumnos);

Var 
  Opcion_Estado: char;
Begin
  clrscr;
  writeln('--- Carga de Alumno ---');
  write('Codigo de capacitacion: ');
  readln(a.Codigo_Capacitacion_Alumno);
  write('DNI: ');
  readln(a.DNI);
  write('Apellido y Nombre: ');
  readln(a.Apellido_Nombre);
  write('Fecha de nacimiento (DD/MM/AAAA): ');
  readln(a.Fecha_Nacimiento);
  write('Docente UTN (Si/No): ');
  readln(a.Docente_UTN);
  write('Condicion (Aprobado/Asistencia): ');
  readln(a.Condicion);
  Repeat
    write('Estado (A = activo / N = no activo): ');
    readln(Opcion_Estado);
    Opcion_Estado := upcase(Opcion_Estado);
  Until (Opcion_Estado = 'A') Or (Opcion_Estado = 'N');
  a.Estado_Alumno := Opcion_Estado = 'A';
End;

Procedure Mostrar_Alumno(Var a: T_Alumnos);
Begin
  writeln('Codigo de capacitacion: ', a.Codigo_Capacitacion_Alumno);
  writeln('DNI: ', a.DNI);
  writeln('Apellido y Nombre: ', a.Apellido_Nombre);
  writeln('Fecha de nacimiento: ', a.Fecha_Nacimiento);
  writeln('Docente UTN: ', a.Docente_UTN);
  writeln('Condicion: ', a.Condicion);
  If a.Estado_Alumno Then
    writeln('Estado: Activo')
  Else
    writeln('Estado: No activo');
  writeln('-------------------------------');
End;

End.
