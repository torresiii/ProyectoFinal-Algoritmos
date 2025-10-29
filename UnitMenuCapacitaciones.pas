
Unit UnitMenuCapacitaciones;

Interface
{$CODEPAGE UTF8}
Uses crt, CargasYMuestras, SysUtils, DateUtils;

Procedure Menu_Capacitaciones;

Var 
  Archivo_Capacitaciones: file Of T_Capacitaciones;

Implementation
// Buscar capacitación por código
Function Buscar_Capacitacion(codigo: String): integer;

Var 
  c: T_Capacitaciones;
  pos: integer;
Begin
  reset(Archivo_Capacitaciones);
  pos := -1;
  While (Not eof(Archivo_Capacitaciones)) And (pos = -1) Do
    Begin
      read(Archivo_Capacitaciones, c);
      If c.Codigo_Capacitacion = codigo Then
        pos := filepos(Archivo_Capacitaciones) - 1;
    End;
  Buscar_Capacitacion := pos;
End;

// Dar de alta
Procedure DarDeAlta(pos: integer);
Var 
  c: T_Capacitaciones;
  FechaInicio, FechaFin, Hoy: TDateTime;
  DiasTranscurridos: Integer;
  FechaPermitida: boolean;
Begin
  seek(Archivo_Capacitaciones, pos);
  read(Archivo_Capacitaciones, c);

  Hoy := Date;
  FechaPermitida := true;
  FechaInicio := 0;
  FechaFin := 0;

  // Validamos formato y conversion de fecha de inicio
  if Length(c.Fecha_Inicio) = 10 then
    FechaInicio := StrToDate(c.Fecha_Inicio)
  else
    FechaPermitida := false;

  // Validamos formato y conversion de fecha de fin
  if Length(c.Fecha_Fin) = 10 then
    FechaFin := StrToDate(c.Fecha_Fin)
  else
    FechaPermitida := false;

  if not FechaPermitida then
    writeln('Formato de fecha inválido. Use DD/MM/AAAA.')
  else
    begin
      // se verifica si el curso ya termino
      if Hoy > FechaFin then
        writeln('No se puede dar de alta: la capacitación ya finalizó.')
      else
        begin
          if Hoy < FechaInicio then
            writeln('La capacitación aún no comenzó, puede inscribirse.')
          else
            begin
              // Si la capacitacion empezo, controla si pasaron mas de 5 dias
              DiasTranscurridos := DaysBetween(FechaInicio, Hoy);
              if DiasTranscurridos <= 5 then
                writeln('Capacitación en curso, dentro del plazo permitido para dar de alta.')
              else
                writeln('No se puede dar de alta: ya pasaron más de 5 días desde el inicio.');
            end;
        end;

      // Se da de alta solo si la capacitación esta inactiva y la fecha es valida
      if (c.Estado_Capacitacion = false) and (Hoy <= FechaFin) then
        begin
          c.Estado_Capacitacion := true;
          seek(Archivo_Capacitaciones, pos);
          write(Archivo_Capacitaciones, c);
          writeln('Capacitación dada de alta correctamente.');
        end
      else if c.Estado_Capacitacion = true then
        writeln('La capacitación ya está activa.');
    end;
End;

// Dar de baja
Procedure DarDeBaja(pos: integer);

Var 
  c: T_Capacitaciones;
Begin
  seek(Archivo_Capacitaciones, pos);
  read(Archivo_Capacitaciones, c);
  If c.Estado_Capacitacion = false Then
    writeln('La capacitacion ya estaba dada de baja.')
  Else
    Begin
      c.Estado_Capacitacion := false;
      seek(Archivo_Capacitaciones, pos);
      write(Archivo_Capacitaciones, c);
      writeln('Capacitacion dada de baja correctamente.');
    End;
End;

// Modificar capacitación
Procedure Modificar_Capacitacion(pos: integer);

Var 
  c: T_Capacitaciones;
  opcion: integer;
Begin
  seek(Archivo_Capacitaciones, pos);
  read(Archivo_Capacitaciones, c);
  clrscr;
  writeln('Datos actuales:');
  Mostrar_Capacitacion(c);
  writeln;
  writeln('Seleccione el dato a modificar:');
  writeln('1. Nombre');
  writeln('2. Fecha de inicio');
  writeln('3. Fecha de fin');
  writeln('4. Tipo');
  writeln('5. Cantidad de horas');
  writeln('6. Docentes');
  writeln('7. Cantidad de alumnos');
  writeln('8. Area');
  writeln('0. Cancelar');
  write('Opcion: ');
  readln(opcion);

  Case opcion Of 
    1:
       Begin
         write('Nuevo nombre: ');
         readln(c.Nombre_Capacitacion);
       End;
    2:
       Begin
         write('Nueva fecha de inicio (DD/MM/AAAA): ');
         readln(c.Fecha_Inicio);
       End;
    3:
       Begin
         write('Nueva fecha de fin (DD/MM/AAAA): ');
         readln(c.Fecha_Fin);
       End;
    4:
       Begin
         write('Nuevo tipo: ');
         readln(c.Tipo_Capacitacion);
       End;
    5:
       Begin
         write('Nueva cantidad de horas: ');
         readln(c.Cantidad_Horas);
       End;
    6:
       Begin
         write('Nuevos docentes: ');
         readln(c.Docentes);
       End;
    7:
       Begin
         write('Nueva cantidad de alumnos: ');
         readln(c.Cantidad_Alumnos);
       End;
    8:
       Begin
         write('Nueva area: ');
         readln(c.Area);
       End;
  End;

  seek(Archivo_Capacitaciones, pos);
  write(Archivo_Capacitaciones, c);
  writeln('Datos modificados correctamente.');
End;

// MENÚ PRINCIPAL DE CAPACITACIONES (sin break)
Procedure Menu_Capacitaciones;

Var 
  c: T_Capacitaciones;
  codigo_cap: string;
  pos, opcion: integer;
  resp: char;
  salir: boolean;
Begin
  clrscr;
  assign(Archivo_Capacitaciones, 'capacitaciones.dat');
  {$I-}
  reset(Archivo_Capacitaciones);
  {$I+}
  If ioresult <> 0 Then
    rewrite(Archivo_Capacitaciones);

  salir := false;
  Repeat
    clrscr;
    textcolor(yellow);
    write('Ingrese el codigo de la capacitacion (0 para salir): ');
    textcolor(white);
    readln(codigo_cap);

    If codigo_cap = '0' Then
      salir := true
    Else
      Begin
        pos := Buscar_Capacitacion(codigo_cap);

        If pos = -1 Then
          Begin
            writeln('Capacitacion no encontrada.');
            write('Desea darla de alta? (S/N): ');
            readln(resp);
            If UpCase(resp) = 'S' Then
              Begin
                Cargar_Capacitacion(c);
                c.Codigo_Capacitacion := codigo_cap;
                // aseguramos mismo código ingresado
                c.Estado_Capacitacion := true;
                seek(Archivo_Capacitaciones, filesize(Archivo_Capacitaciones));
                write(Archivo_Capacitaciones, c);
                writeln('Capacitacion agregada correctamente.');
              End;
          End
        Else
          Begin
            Repeat
              seek(Archivo_Capacitaciones, pos);
              read(Archivo_Capacitaciones, c);

              clrscr;
              writeln('Capacitacion encontrada:');
              textcolor(green);
              Mostrar_Capacitacion(c);
              writeln;
              textcolor(yellow);
              writeln('1. Modificar');

              If c.Estado_Capacitacion then 
                writeln('2. Dar de baja')
              Else
                writeln('3. Dar de alta');

              writeln('0. Volver a ingresar otro codigo o salir');
              write('Opcion: ');
              readln(opcion);

              Case opcion Of 
                1: Modificar_Capacitacion(pos);
                2: DarDeBaja(pos);
                3: DarDeAlta(pos);
              End;

            Until opcion = 0;
          End;

        textcolor(red);
        writeln('Presione cualquier tecla para continuar...');
        readkey;
      End;

  Until salir = true;

  close(Archivo_Capacitaciones);
End;

End.
