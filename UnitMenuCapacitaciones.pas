
Unit UnitMenuCapacitaciones;

{$CODEPAGE UTF8}

Interface

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
      textcolor(LightCyan);
      Writeln('Fecha inválida. Use DD/MM/AAAA.');
      textcolor(white);
      Exit;
    End;

  If Hoy > FechaFin Then
    Begin
      textcolor(LightCyan);
      Writeln('No se puede dar de alta: la capacitación ya finalizó.');
      textcolor(white);
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
  textcolor(LightCyan);
  Writeln('Datos actuales:');
  textcolor(white);
  Mostrar_Capacitacion(c);
  Writeln;

  textcolor(yellow);
  Writeln('0. Codigo');
  Writeln('1. Nombre');
  Writeln('2. Fecha de inicio');
  Writeln('3. Fecha de fin');
  Writeln('4. Tipo');
  Writeln('5. Cantidad de horas');
  Writeln('6. Docentes');
  Writeln('7. Cantidad de alumnos');
  Writeln('8. Area');
  Writeln('9. Cancelar');
  textcolor(LightGreen);
  Write('Opción: ');
  textcolor(white);
  Readln(opcion);

  Case opcion Of 
    0:
       Begin
         textcolor(LightGreen);
         Write('Nuevo codigo: ');
         textcolor(white);
         Readln(c.Codigo_Capacitacion);
       End;
    1:
       Begin
         textcolor(LightGreen);
         Write('Nuevo nombre: ');
         textcolor(white);
         Readln(c.Nombre_Capacitacion);
       End;
    2:
       Begin
         textcolor(LightGreen);
         Write('Nueva fecha de inicio (DD/MM/AAAA): ');
         textcolor(white);
         Readln(c.Fecha_Inicio);
       End;
    3:
       Begin
         textcolor(LightGreen);
         Write('Nueva fecha de fin (DD/MM/AAAA): ');
         textcolor(white);
         Readln(c.Fecha_Fin);
       End;
    4:
       Begin
         textcolor(LightGreen);
         Write('Nuevo tipo: ');
         textcolor(white);
         Readln(c.Tipo_Capacitacion);
       End;
    5:
       Begin
         textcolor(LightGreen);
         Write('Nueva cantidad de horas: ');
         textcolor(white);
         Readln(c.Cantidad_Horas);
       End;
    6:
       Begin
         textcolor(LightGreen);
         Write('Nuevos docentes: ');
         textcolor(white);
         Readln(c.Docentes);
       End;
    7:
       Begin
         textcolor(LightGreen);
         Write('Nueva cantidad de alumnos: ');
         textcolor(white);
         Readln(c.Cantidad_Alumnos);
       End;
    8:
       Begin
         textcolor(LightGreen);
         Write('Nueva area: ');
         textcolor(white);
         Readln(c.Area);
       End;
  End;

  Seek(Archivo_Capacitaciones, pos);
  Write(Archivo_Capacitaciones, c);
  textcolor(LightCyan);
  Writeln('Datos modificados.');
  textcolor(white);
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

                textcolor(LightCyan);
                Writeln('Capacitación agregada.');
                textcolor(white);
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

        textcolor(LightGreen);
        Writeln('Presione una tecla para continuar...');
        textcolor(white);
        ReadKey;
      End;

  Until salir;

  Close(Archivo_Capacitaciones);
End;

End.
