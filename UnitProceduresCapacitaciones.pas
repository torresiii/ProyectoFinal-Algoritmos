
Unit UnitProceduresCapacitaciones;

{$CODEPAGE UTF8}

Interface

Uses 
crt, SysUtils, DateUtils, UnitCapacitaciones, UnitArbolCapacitaciones;

Var 
  Archivo_Capacitaciones: file Of T_Capacitaciones;

Procedure DarDeAlta(pos: integer);
Procedure DarDeBaja(pos: integer);
Procedure Modificar_Capacitacion(pos: integer);
Function Buscar_Capacitacion(codigo: String): integer;

// Operaciones basadas en ABB (por código)
Procedure DarDeAlta_Codigo(codigo: String);
Procedure DarDeBaja_Codigo(codigo: String);
Procedure Modificar_Capacitacion_Codigo(codigo: String);

Implementation

// ----------------------------
// Función para buscar capacitación en archivo
// ----------------------------
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

// ----------------------------
// Procedimientos de archivo
// ----------------------------
Procedure DarDeAlta(pos: integer);

Var 
  c: T_Capacitaciones;
  FechaInicio, FechaFin, Hoy: TDateTime;
  DiasTranscurridos: integer;
  ok1, ok2: boolean;
  nodo: PNodoCap;
Begin
  Seek(Archivo_Capacitaciones, pos);
  Read(Archivo_Capacitaciones, c);

  Hoy := Date;
  ok1 := TryStrToDate(c.Fecha_Inicio, FechaInicio);
  ok2 := TryStrToDate(c.Fecha_Fin, FechaFin);

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
          Writeln('No se puede dar alta: pasaron más de 5 días del inicio.');
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

  // Sincronizar ABB
  nodo := BuscarCapacitacionArbol(raiz, c.Codigo_Capacitacion);
  If nodo <> Nil Then
    nodo^.Dato := c;
End;

Procedure DarDeBaja(pos: integer);

Var 
  c: T_Capacitaciones;
  nodo: PNodoCap;
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

  // Sincronizar ABB
  nodo := BuscarCapacitacionArbol(raiz, c.Codigo_Capacitacion);
  If nodo <> Nil Then
    nodo^.Dato := c;
End;

Procedure Modificar_Capacitacion(pos: integer);

Var 
  c: T_Capacitaciones;
  opcion: integer;
  nodo: PNodoCap;
Begin
  Seek(Archivo_Capacitaciones, pos);
  Read(Archivo_Capacitaciones, c);

  Mostrar_Capacitacion(c);

  Writeln('0. Codigo  1. Nombre  2. Fecha inicio  3. Fecha fin  4. Tipo');
  Writeln('5. Cantidad horas 6. Docentes 7. Cantidad alumnos 8. Area 9. Cancelar');
  Write('Opción: ');
  Readln(opcion);

  Case opcion Of 
    0: Readln(c.Codigo_Capacitacion);
    1: Readln(c.Nombre_Capacitacion);
    2: Readln(c.Fecha_Inicio);
    3: Readln(c.Fecha_Fin);
    4: Readln(c.Tipo_Capacitacion);
    5: Readln(c.Cantidad_Horas);
    6: Readln(c.Docentes);
    7: Readln(c.Cantidad_Alumnos);
    8: Readln(c.Area);
  End;

  Seek(Archivo_Capacitaciones, pos);
  Write(Archivo_Capacitaciones, c);

  // Sincronizar ABB
  nodo := BuscarCapacitacionArbol(raiz, c.Codigo_Capacitacion);
  If nodo <> Nil Then
    nodo^.Dato := c;
End;

// ----------------------------
// Procedimientos basados en ABB
// ----------------------------
Procedure DarDeAlta_Codigo(codigo: String);

Var nodo: PNodoCap;
Begin
  nodo := BuscarCapacitacionArbol(raiz, codigo);
  If nodo = Nil Then
    Begin
      Writeln('Capacitación no encontrada.');
      Exit;
    End;
  DarDeAlta(Buscar_Capacitacion(codigo));
End;

Procedure DarDeBaja_Codigo(codigo: String);

Var nodo: PNodoCap;
Begin
  nodo := BuscarCapacitacionArbol(raiz, codigo);
  If nodo = Nil Then
    Begin
      Writeln('Capacitación no encontrada.');
      Exit;
    End;
  DarDeBaja(Buscar_Capacitacion(codigo));
End;

Procedure Modificar_Capacitacion_Codigo(codigo: String);

Var nodo: PNodoCap;
Begin
  nodo := BuscarCapacitacionArbol(raiz, codigo);
  If nodo = Nil Then
    Begin
      Writeln('Capacitación no encontrada.');
      Exit;
    End;
  Modificar_Capacitacion(Buscar_Capacitacion(codigo));
End;

End.
