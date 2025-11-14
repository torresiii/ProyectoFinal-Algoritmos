
Unit UnitAlumnos;

Interface

Uses crt;

Type 
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

Procedure Cargar_Alumnos(Var a: T_Alumnos);
Procedure Mostrar_Alumno(Var a: T_Alumnos);

Implementation

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
