
Unit UnitMenuAlumnos;

{$CODEPAGE UTF8}

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
  codigo_cap: string;
  encontrados: integer;
  temp: T_Alumnos;
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
    textcolor(LightGreen);
    writeln('Ingrese DNI del alumno (0 para salir): ');
    textcolor(white);
    readln(dni);

    dni := Trim(dni);
    // evita que entradas con espacios provoquen que el menu no salga 
    If dni <> '0' Then
      Begin
        // Contar cuantas capacitaciones tiene este alumno
        reset(Archivo_Alumnos);
        encontrados := 0;
        While Not eof(Archivo_Alumnos) Do
          Begin
            read(Archivo_Alumnos, temp);
            If temp.DNI = dni Then
              Inc(encontrados);
          End;

        If encontrados = 0 Then
          Begin
            clrscr;
            textcolor(LightCyan);
            writeln('Alumno no encontrado.');
            textcolor(white);
            textcolor(LightGreen);
            writeln('¿Desea cargarlo en una capacitacion? (S/N): ');
            textcolor(white);
            If UpCase(readkey) = 'S' Then
              Begin
                Cargar_Alumnos(a);
                a.DNI := dni;
                a.Estado_Alumno := true;
                seek(Archivo_Alumnos, filesize(Archivo_Alumnos));
                write(Archivo_Alumnos, a);
                writeln;
                textcolor(LightCyan);
                writeln('Alumno cargado correctamente.');
                textcolor(white);
                readkey;
              End;
          End
        Else
          Begin
            Repeat
              clrscr;
              textcolor(yellow);
              writeln('=======================================');
              textcolor(LightCyan);
              writeln('CAPACITACIONES DEL ALUMNO (DNI: ', dni, ')');
              textcolor(yellow);
              writeln('=======================================');
              textcolor(white);

              // Mostrar todas las capacitaciones del alumno
              reset(Archivo_Alumnos);
              pos := 0;
              While Not eof(Archivo_Alumnos) Do
                Begin
                  read(Archivo_Alumnos, temp);
                  If temp.DNI = dni Then
                    Begin
                      writeln;
                      writeln('Capacitacion: ', temp.Codigo_Capacitacion_Alumno)
                      ;
                      writeln('Condicion: ', temp.Condicion);
                      writeln('Docente UTN: ', temp.Docente_UTN);
                      If temp.Estado_Alumno Then
                        writeln('Estado: Activo')
                      Else
                        writeln('Estado: Inactivo');
                    End;
                End;

              writeln;
              textcolor(yellow);
              writeln('1. Agregar a otra capacitacion');
              writeln('2. Modificar una inscripcion');
              writeln('3. Dar de baja una inscripcion');
              writeln('0. Volver');
              textcolor(LightGreen);
              write('Opcion: ');
              textcolor(white);
              readln(opcion);

              Case opcion Of 
                1:
                   Begin
                     clrscr;
                     textcolor(LightGreen);
                     write('Ingrese codigo de la nueva capacitacion: ');
                     textcolor(white);
                     readln(codigo_cap);
                     codigo_cap := Trim(codigo_cap);

                     // Verificar que no esté ya inscrito en esa capacitacion
                     reset(Archivo_Alumnos);
                     encontrados := 0;
                     While Not eof(Archivo_Alumnos) Do
                       Begin
                         read(Archivo_Alumnos, temp);
                         If (temp.DNI = dni) And (temp.
                            Codigo_Capacitacion_Alumno = codigo_cap) Then
                           Inc(encontrados);
                       End;

                     If encontrados > 0 Then
                       Begin
                         textcolor(LightCyan);
                         writeln(



                               'El alumno ya esta inscrito en esa capacitacion.'
                         );
                         textcolor(white);
                         readkey;
                       End
                     Else
                       Begin
                         Cargar_Alumnos(a);
                         a.DNI := dni;
                         a.Codigo_Capacitacion_Alumno := codigo_cap;
                         a.Estado_Alumno := true;
                         seek(Archivo_Alumnos, filesize(Archivo_Alumnos));
                         write(Archivo_Alumnos, a);
                         writeln;
                         textcolor(LightCyan);
                         writeln('Alumno inscrito correctamente.');
                         textcolor(white);
                         readkey;
                       End;
                   End;
                2:
                   Begin
                     clrscr;
                     textcolor(LightGreen);
                     write('Ingrese codigo de la capacitacion a modificar: ');
                     textcolor(white);
                     readln(codigo_cap);
                     codigo_cap := Trim(codigo_cap);

                     reset(Archivo_Alumnos);
                     pos := -1;
                     While Not eof(Archivo_Alumnos) Do
                       Begin
                         read(Archivo_Alumnos, temp);
                         If (temp.DNI = dni) And (temp.
                            Codigo_Capacitacion_Alumno = codigo_cap) Then
                           Begin
                             pos := filepos(Archivo_Alumnos) - 1;
                             break;
                           End;
                       End;

                     If pos = -1 Then
                       Begin
                         textcolor(LightCyan);
                         writeln('Inscripcion no encontrada.');
                         textcolor(white);
                         readkey;
                       End
                     Else
                       Begin
                         Modificar_Alumno(pos);
                       End;
                   End;
                3:
                   Begin
                     clrscr;
                     textcolor(LightGreen);
                     write('Ingrese codigo de la capacitacion a dar de baja: ');
                     textcolor(white);
                     readln(codigo_cap);
                     codigo_cap := Trim(codigo_cap);

                     reset(Archivo_Alumnos);
                     pos := -1;
                     While Not eof(Archivo_Alumnos) Do
                       Begin
                         read(Archivo_Alumnos, temp);
                         If (temp.DNI = dni) And (temp.
                            Codigo_Capacitacion_Alumno = codigo_cap) Then
                           Begin
                             pos := filepos(Archivo_Alumnos) - 1;
                             break;
                           End;
                       End;

                     If pos = -1 Then
                       Begin
                         textcolor(LightCyan);
                         writeln('Inscripcion no encontrada.');
                         textcolor(white);
                         readkey;
                       End
                     Else
                       Begin
                         DarDeBaja_Alumno(pos);
                         readkey;
                       End;
                   End;
              End;

            Until opcion = 0;
          End;
      End;

  Until dni = '0';

  close(Archivo_Alumnos);
End;

End.
