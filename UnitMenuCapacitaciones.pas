
Unit UnitMenuCapacitaciones;

Interface
{$CODEPAGE UTF8}

Uses crt, UnitCapacitaciones, SysUtils, DateUtils;

Procedure Menu_Capacitaciones;

Var 
  Archivo_Capacitaciones: file Of T_Capacitaciones;

Implementation


Function Buscar_Capacitacion(codigo: String): integer;

Var 
  c: T_Capacitaciones;
Begin
  Seek(Archivo_Capacitaciones, 0);
  Buscar_Capacitacion := -1;

  While Not EOF(Archivo_Capacitaciones) Do
    Begin
      Read(Archivo_Capacitaciones, c);
      If c.Codigo_Capacitacion = codigo Then
        Begin
          Buscar_Capacitacion := FilePos(Archivo_Capacitaciones) - 1;
          Exit;
        End;
    End;
End;

Procedure DarDeAlta(pos: integer);

Var 
  c: T_Capacitaciones;
  FechaInicio, FechaFin, Hoy: TDateTime;
  DiasTranscurridos: integer;
  ok1, ok2: boolean;
Begin
  Seek(Archivo_Capacitaciones, pos);
  Read(Archivo_Capacitaciones, c);

  Hoy := Date;

  ok1 := TryStrToDate(c.Fecha_Inicio, FechaInicio);
  ok2 := TryStrToDate(c.Fecha_Fin,     FechaFin);

  If (Not ok1) Or (Not ok2) Then
    Begin
      Writeln('Fecha inválida. Use DD/MM/AAAA.');
      Exit;
    End;

  If Hoy > FechaFin Then
    Begin
      Writeln('No se puede dar de alta: la capacitación ya finalizó.');
      Exit;
    End;

  If Hoy < FechaInicio Then
    Writeln('La capacitación aún no comenzó, puede inscribirse.')
  Else
    Begin
      DiasTranscurridos := DaysBetween(FechaInicio, Hoy);
      If DiasTranscurridos > 5 Then
        Begin
          Writeln(





               'No se puede dar de alta: ya pasaron más de 5 días del inicio.'
          );
          Exit;
        End
      Else
        Writeln('Capacitación en curso, dentro del plazo permitido.');
    End;

  If Not c.Estado_Capacitacion Then
    Begin
      c.Estado_Capacitacion := True;
      Seek(Archivo_Capacitaciones, pos);
      Write(Archivo_Capacitaciones, c);
      Writeln('Capacitación dada de alta correctamente.');
    End
  Else
    Writeln('La capacitación ya está activa.');
End;

Procedure DarDeBaja(pos: integer);

Var 
  c: T_Capacitaciones;
Begin
  Seek(Archivo_Capacitaciones, pos);
  Read(Archivo_Capacitaciones, c);

  If Not c.Estado_Capacitacion Then
    Writeln('La capacitación ya estaba dada de baja.')
  Else
    Begin
      c.Estado_Capacitacion := False;
      Seek(Archivo_Capacitaciones, pos);
      Write(Archivo_Capacitaciones, c);
      Writeln('Capacitación dada de baja correctamente.');
    End;
End;

Procedure Modificar_Capacitacion(pos: integer);

Var 
  c: T_Capacitaciones;
  opcion: integer;
Begin
  Seek(Archivo_Capacitaciones, pos);
  Read(Archivo_Capacitaciones, c);

  clrscr;
  Writeln('Datos actuales:');
  Mostrar_Capacitacion(c);
  Writeln;

  Writeln('1. Nombre');
  Writeln('2. Fecha de inicio');
  Writeln('3. Fecha de fin');
  Writeln('4. Tipo');
  Writeln('5. Cantidad de horas');
  Writeln('6. Docentes');
  Writeln('7. Cantidad de alumnos');
  Writeln('8. Area');
  Writeln('0. Cancelar');
  Write('Opción: ');
  Readln(opcion);

  Case opcion Of 
    1:
       Begin
         Write('Nuevo nombre: ');
         Readln(c.Nombre_Capacitacion);
       End;
    2:
       Begin
         Write('Nueva fecha de inicio (DD/MM/AAAA): ');
         Readln(c.Fecha_Inicio);
       End;
    3:
       Begin
         Write('Nueva fecha de fin (DD/MM/AAAA): ');
         Readln(c.Fecha_Fin);
       End;
    4:
       Begin
         Write('Nuevo tipo: ');
         Readln(c.Tipo_Capacitacion);
       End;
    5:
       Begin
         Write('Nueva cantidad de horas: ');
         Readln(c.Cantidad_Horas);
       End;
    6:
       Begin
         Write('Nuevos docentes: ');
         Readln(c.Docentes);
       End;
    7:
       Begin
         Write('Nueva cantidad de alumnos: ');
         Readln(c.Cantidad_Alumnos);
       End;
    8:
       Begin
         Write('Nueva area: ');
         Readln(c.Area);
       End;
  End;

  Seek(Archivo_Capacitaciones, pos);
  Write(Archivo_Capacitaciones, c);
  Writeln('Datos modificados.');
End;

Procedure Menu_Capacitaciones;

Var 
  c: T_Capacitaciones;
  codigo_cap: string;
  pos, opcion: integer;
  resp: char;
  salir: boolean;
Begin
  clrscr;
  Assign(Archivo_Capacitaciones, 'capacitaciones.dat');

  {$I-}
  Reset(Archivo_Capacitaciones);
  {$I+}
  If IOResult <> 0 Then
    Rewrite(Archivo_Capacitaciones);

  salir := False;

  Repeat
    clrscr;
    textcolor(yellow);
    Write('Ingrese el código de la capacitación (0 para salir): ');
    textcolor(white);
    Readln(codigo_cap);

    If codigo_cap = '0' Then
      salir := True
    Else
      Begin
        pos := Buscar_Capacitacion(codigo_cap);

        If pos = -1 Then
          Begin
            Writeln('Capacitación no encontrada.');
            Write('¿Agregarla? (S/N): ');
            Readln(resp);

            If UpCase(resp) = 'S' Then
              Begin
                Cargar_Capacitacion(c);
                c.Codigo_Capacitacion := codigo_cap;
                c.Estado_Capacitacion := True;

                Seek(Archivo_Capacitaciones, FileSize(Archivo_Capacitaciones));
                Write(Archivo_Capacitaciones, c);

                Writeln('Capacitación agregada.');
                ReadKey;
              End;
          End
        Else
          Begin
            Repeat
              Seek(Archivo_Capacitaciones, pos);
              Read(Archivo_Capacitaciones, c);

              clrscr;
              Writeln('Capacitación encontrada:');
              Mostrar_Capacitacion(c);
              Writeln;

              Writeln('1. Modificar');

              If c.Estado_Capacitacion Then
                Writeln('2. Dar de baja')
              Else
                Writeln('3. Dar de alta');

              Writeln('0. Volver');
              Write('Opción: ');
              Readln(opcion);

              Case opcion Of 
                1: Modificar_Capacitacion(pos);
                2: If c.Estado_Capacitacion Then
                     Begin
                       DarDeBaja(pos);
                       ReadKey;
                     End;
                3: If Not c.Estado_Capacitacion Then
                     Begin
                       DarDeAlta(pos);
                       ReadKey;
                     End;
              End;

            Until opcion = 0;
          End;

        textcolor(red);
        Writeln('Presione una tecla para continuar...');
        ReadKey;
      End;

  Until salir;

  Close(Archivo_Capacitaciones);
End;

End.
