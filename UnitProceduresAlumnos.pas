
Unit UnitProceduresAlumnos;

{$CODEPAGE UTF8}

Interface

Uses 
crt, SysUtils, UnitAlumnos;

Var 
  Archivo_Alumnos: file Of T_Alumnos;

Procedure DarDeAlta_Alumno(pos: integer);
Procedure DarDeBaja_Alumno(pos: integer);
Procedure Modificar_Alumno(pos: integer);
Function Buscar_Alumno(dni: String): integer;

Implementation

// ----------------------------
// Funciones y procedimientos
// ----------------------------

Function Buscar_Alumno(dni: String): integer;

Var 
  a: T_Alumnos;
  pos: integer;
Begin
  reset(Archivo_Alumnos);
  pos := -1;
  While (Not eof(Archivo_Alumnos)) And (pos = -1) Do
    Begin
      read(Archivo_Alumnos, a);
      If a.DNI = dni Then
        pos := filepos(Archivo_Alumnos) - 1;
    End;
  Buscar_Alumno := pos;
End;

Procedure DarDeBaja_Alumno(pos: integer);

Var 
  a: T_Alumnos;
Begin
  seek(Archivo_Alumnos, pos);
  read(Archivo_Alumnos, a);
  If a.Estado_Alumno = false Then
    writeln('El alumno ya estaba eliminado.')
  Else
    Begin
      a.Estado_Alumno := false;
      seek(Archivo_Alumnos, pos);
      write(Archivo_Alumnos, a);
      writeln('Alumno eliminado correctamente.');
    End;
End;

Procedure DarDeAlta_Alumno(pos: integer);

Var 
  a: T_Alumnos;
Begin
  seek(Archivo_Alumnos, pos);
  read(Archivo_Alumnos, a);
  If a.Estado_Alumno = true Then
    writeln('El alumno ya esta activo.')
  Else
    Begin
      a.Estado_Alumno := true;
      seek(Archivo_Alumnos, pos);
      write(Archivo_Alumnos, a);
      writeln('Alumno reactivado correctamente.');
    End;
End;

Procedure Modificar_Alumno(pos: integer);

Var 
  a: T_Alumnos;
  opcion: integer;
Begin
  seek(Archivo_Alumnos, pos);
  read(Archivo_Alumnos, a);

  Repeat
    clrscr;
    writeln('Datos actuales del alumno:');
    Mostrar_Alumno(a);
    writeln;
    writeln('1. Modificar Codigo de Capacitacion');
    writeln('2. Modificar Apellido y Nombre');
    writeln('3. Modificar fecha de nacimiento');
    writeln('4. Modificar Docente UTN (SI/NO)');
    writeln('5. Modificar condicion (Aprobado/Asistencia)');
    writeln('0. Volver');
    write('Opcion: ');
    readln(opcion);

    Case opcion Of 
      1:
         Begin
           write('Nuevo codigo de capacitacion: ');
           readln(a.Codigo_Capacitacion_Alumno);
         End;
      2:
         Begin
           write('Nuevo Apellido y Nombre: ');
           readln(a.Apellido_Nombre);
         End;
      3:
         Begin
           write('Nueva fecha nacimiento (DD/MM/AAAA): ');
           readln(a.Fecha_Nacimiento);
         End;
      4:
         Begin
           write('Docente UTN (SI/NO): ');
           readln(a.Docente_UTN);
         End;
      5:
         Begin
           write('Condicion: ');
           readln(a.Condicion);
         End;
    End;

    seek(Archivo_Alumnos, pos);
    write(Archivo_Alumnos, a);

  Until opcion = 0;

  writeln('Datos actualizados correctamente.');
  writeln('Presione cualquier tecla para volver.');
  readkey;
End;

End.
