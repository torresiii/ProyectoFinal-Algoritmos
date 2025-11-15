
Unit UnitMenuAlumnos;

{$CODEPAGE UTF8}

Interface

Uses 
crt, SysUtils, UnitAlumnos, UnitProceduresAlumnos;

Procedure Menu_Alumnos;

Implementation

Procedure Menu_Alumnos;

Var 
  a: T_Alumnos;
  dni: string;
  pos, opcion, encontrados: integer;
  codigo_cap: string;
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
                         writeln('El alumno ya esta inscrito.');
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
