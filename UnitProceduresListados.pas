
Unit UnitProceduresListados;

{$CODEPAGE UTF8}

Interface

Uses 
crt, SysUtils, UnitCapacitaciones, UnitAlumnos;

Procedure Listado_Capacitaciones_Por_Area_Nombre;
Procedure Listado_Capacitaciones_Por_Alumno;

Implementation

Var 
  Archivo_Capacitaciones: file Of T_Capacitaciones;
  Archivo_Alumnos: file Of T_Alumnos;

Procedure Listado_Capacitaciones_Por_Area_Nombre;

Var 
  c: T_Capacitaciones;
  areas: Array[1..5] Of String;
  i, contador: integer;
  encontrada: boolean;
Begin
  areas[1] := 'ISI';
  areas[2] := 'LOI';
  areas[3] := 'ELECTRO';
  areas[4] := 'Civil';
  areas[5] := 'General';

  clrscr;
  assign(Archivo_Capacitaciones, 'capacitaciones.dat');
  {$I-}
  reset(Archivo_Capacitaciones); {$I+}
  If ioresult <> 0 Then
    Begin
      textcolor(LightCyan);
      writeln('No se pudo abrir el archivo de capacitaciones.');
      textcolor(LightGreen);
      writeln('Presione ENTER para volver...');
      textcolor(white);
      readln;
      Exit;
    End;

  For i := 1 To 5 Do
    Begin
      reset(Archivo_Capacitaciones);
      encontrada := false;
      contador := 0;

      While Not eof(Archivo_Capacitaciones) Do
        Begin
          read(Archivo_Capacitaciones, c);
          If c.Area = areas[i] Then
            Begin
              If Not encontrada Then
                Begin
                  textcolor(yellow);
                  writeln;
                  writeln('====== AREA: ', areas[i], ' ======');
                  textcolor(white);
                  encontrada := true;
                End;
              inc(contador);
              writeln(contador, '. ', c.Nombre_Capacitacion, ' (', c.
                      Codigo_Capacitacion, ')');
              writeln('   Tipo: ', c.Tipo_Capacitacion, ' | Horas: ', c.
                      Cantidad_Horas);
              If c.Estado_Capacitacion Then
                writeln('   Estado: Activo')
              Else
                writeln('   Estado: No activo');
            End;
        End;
    End;

  textcolor(yellow);
  writeln;
  writeln('=======================================');
  textcolor(LightGreen);
  writeln('Presione ENTER para volver...');
  textcolor(white);
  readln;

  close(Archivo_Capacitaciones);
End;


Procedure Listado_Capacitaciones_Por_Alumno;

Var 
  dni: string;
  a: T_Alumnos;
  c: T_Capacitaciones;
  encontrado: boolean;
  contador: integer;
Begin
  clrscr;
  assign(Archivo_Alumnos, 'alumnos.dat');
  {$I-}
  reset(Archivo_Alumnos); {$I+}
  If ioresult <> 0 Then
    Begin
      textcolor(LightCyan);
      writeln('No se pudo abrir el archivo de alumnos.');
      textcolor(white);
      readln;
      Exit;
    End;

  assign(Archivo_Capacitaciones, 'capacitaciones.dat');
  {$I-}
  reset(Archivo_Capacitaciones); {$I+}
  If ioresult <> 0 Then
    Begin
      textcolor(LightCyan);
      writeln('No se pudo abrir el archivo de capacitaciones.');
      textcolor(white);
      readln;
      close(Archivo_Alumnos);
      Exit;
    End;

  // Solicitar DNI del alumno
  textcolor(LightGreen);
  write('Ingrese el DNI del alumno: ');
  textcolor(white);
  readln(dni);
  dni := Trim(dni);

  clrscr;
  encontrado := false;
  contador := 0;

  While Not eof(Archivo_Alumnos) Do
    Begin
      read(Archivo_Alumnos, a);
      If (a.DNI = dni) And (a.Estado_Alumno) Then
        Begin
          If Not encontrado Then
            Begin
              textcolor(LightCyan);
              writeln('============ CAPACITACIONES DEL ALUMNO ============');
              textcolor(yellow);
              writeln('Nombre: ', a.Apellido_Nombre);
              writeln('DNI: ', a.DNI);
              textcolor(white);
              writeln('-----------------------------------------------------');
              encontrado := true;
            End;

          reset(Archivo_Capacitaciones);
          While Not eof(Archivo_Capacitaciones) Do
            Begin
              read(Archivo_Capacitaciones, c);
              If c.Codigo_Capacitacion = a.Codigo_Capacitacion_Alumno Then
                Begin
                  inc(contador);
                  textcolor(yellow);
                  writeln;
                  writeln(contador, '. ', c.Nombre_Capacitacion);
                  textcolor(white);
                  writeln('   Codigo: ', c.Codigo_Capacitacion);
                  writeln('   Area: ', c.Area);
                  writeln('   Tipo: ', c.Tipo_Capacitacion);
                  writeln('   Horas: ', c.Cantidad_Horas);
                  writeln('   Docentes: ', c.Docentes);
                  writeln('   Condicion del alumno: ', a.Condicion);
                  writeln('   Docente UTN: ', a.Docente_UTN);
                  break;
                End;
            End;
        End;
    End;

  If Not encontrado Then
    Begin
      textcolor(LightCyan);
      writeln('No se encontró alumno con DNI: ', dni);
      textcolor(white);
    End
  Else
    Begin
      textcolor(yellow);
      writeln;
      writeln('=====================================================');
      writeln('Total de capacitaciones: ', contador);
      textcolor(white);
    End;

  writeln;
  textcolor(LightGreen);
  writeln('Presione ENTER para volver...');
  textcolor(white);
  readln;

  close(Archivo_Alumnos);
  close(Archivo_Capacitaciones);
End;

End.
