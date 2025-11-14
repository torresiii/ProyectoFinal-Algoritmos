
Unit UnitMenuAlumnos;

Interface

Uses crt, UnitAlumnos, SysUtils;

Procedure Menu_Alumnos;

Var 
  Archivo_Alumnos: file Of T_Alumnos;
  a: T_Alumnos;

Implementation

// Buscar alumno por DNI
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

// Dar de baja alumno
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

// Dar de alta alumno
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

// Modificar datos del alumno
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

// MENÚ PRINCIPAL ALUMNOS
Procedure Menu_Alumnos;

Var 
  a: T_Alumnos;
  dni: string;
  pos, opcion: integer;
Begin
  clrscr;
  assign(Archivo_Alumnos,'alumnos.dat');
  {$I-}
  reset(Archivo_Alumnos);
  {$I+}
  If ioresult <> 0 Then
    rewrite(Archivo_Alumnos);

  Repeat
    clrscr;
    writeln('Ingrese DNI del alumno (0 para salir): ');
    readln(dni);

    dni := Trim(dni);
    // evita que entradas con espacios provoquen que el menu no salga 
    If dni <> '0' Then
      Begin
        pos := Buscar_Alumno(dni);

        If pos = -1 Then
          Begin
            writeln('Alumno no encontrado.');
            writeln('¿Desea cargarlo? (S/N): ');
            If UpCase(readkey) = 'S' Then
              Begin
                Cargar_Alumnos(a);
                a.DNI := dni;
                a.Estado_Alumno := true;
                seek(Archivo_Alumnos, filesize(Archivo_Alumnos));
                write(Archivo_Alumnos, a);
                writeln;
                writeln('Alumno cargado correctamente.');
                readkey;
              End;
          End
        Else
          Begin
            Repeat
              seek(Archivo_Alumnos, pos);
              read(Archivo_Alumnos, a);
              clrscr;
              Mostrar_Alumno(a);
              writeln;
              writeln('1. Modificar datos');
              If a.Estado_Alumno Then
                writeln('2. Dar de baja')
              Else
                writeln('3. Dar de alta');

              writeln('0. Volver');
              write('Opcion: ');
              readln(opcion);

              Case opcion Of 
                1: Modificar_Alumno(pos);
                2: If a.Estado_Alumno Then DarDeBaja_Alumno(pos);
                3: If Not a.Estado_Alumno Then DarDeAlta_Alumno(pos);
              End;

            Until opcion = 0;
          End;
      End;

  Until dni = '0';

  close(Archivo_Alumnos);
End;

End.
