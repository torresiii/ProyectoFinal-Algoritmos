
Unit UnitProceduresCapacitaciones;

{$CODEPAGE UTF8}

Interface

Uses 
crt, SysUtils, DateUtils, UnitCapacitaciones;

Var 
  Archivo_Capacitaciones: file Of T_Capacitaciones;

Procedure DarDeAlta(pos: integer);
Procedure DarDeBaja(pos: integer);
Procedure Modificar_Capacitacion(pos: integer);
Function Buscar_Capacitacion(codigo: String): integer;

// Operaciones basadas en ABB (por codigo)
Procedure DarDeAlta_Codigo(codigo: String);
Procedure DarDeBaja_Codigo(codigo: String);
Procedure Modificar_Capacitacion_Codigo(codigo: String);

Implementation

Uses UnitArbolCapacitaciones;

// ----------------------------
// Procedimientos y funciones (archivo)
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
  // Mantener sincronizado el ABB
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
  // Mantener sincronizado el ABB
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
  // Mantener sincronizado el ABB
  nodo := BuscarCapacitacionArbol(raiz, c.Codigo_Capacitacion);
  If nodo <> Nil Then
    nodo^.Dato := c;
End;

// ----------------------------
// Operaciones basadas en ABB (por codigo)
// ----------------------------
Procedure DarDeAlta_Codigo(codigo: String);

Var nodo: PNodoCap;
  c: T_Capacitaciones;
  FechaInicio, FechaFin, Hoy: TDateTime;
  DiasTranscurridos: integer;
  ok1, ok2: boolean;
Begin
  nodo := BuscarCapacitacionArbol(raiz, codigo);
  If nodo = Nil Then
    Begin
      Writeln('Capacitación no encontrada.');
      Exit;
    End;
  c := nodo^.Dato;

  Hoy := Date;
  ok1 := TryStrToDate(c.Fecha_Inicio, FechaInicio);
  ok2 := TryStrToDate(c.Fecha_Fin, FechaFin);
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
          Writeln('No se puede dar alta: pasaron más de 5 días del inicio.');
          Exit;
        End
      Else
        Writeln('Capacitación en curso, dentro del plazo permitido.');
    End;

  If Not c.Estado_Capacitacion Then
    Begin
      c.Estado_Capacitacion := True;
      nodo^.Dato := c;
      GuardarArbolEnArchivo('capacitaciones.dat');
      Writeln('Capacitación dada de alta correctamente.');
    End
  Else
    Writeln('La capacitación ya está activa.');
End;

Procedure DarDeBaja_Codigo(codigo: String);

Var nodo: PNodoCap;
  c: T_Capacitaciones;
Begin
  nodo := BuscarCapacitacionArbol(raiz, codigo);
  If nodo = Nil Then
    Begin
      Writeln('Capacitación no encontrada.');
      Exit;
    End;
  c := nodo^.Dato;
  If Not c.Estado_Capacitacion Then
    Writeln('La capacitación ya estaba dada de baja.')
  Else
    Begin
      c.Estado_Capacitacion := False;
      nodo^.Dato := c;
      GuardarArbolEnArchivo('capacitaciones.dat');
      Writeln('Capacitación dada de baja correctamente.');
    End;
End;

Procedure Modificar_Capacitacion_Codigo(codigo: String);

Var nodo: PNodoCap;
  c: T_Capacitaciones;
  opcion: integer;
Begin
  nodo := BuscarCapacitacionArbol(raiz, codigo);
  If nodo = Nil Then
    Begin
      Writeln('Capacitación no encontrada.');
      Exit;
    End;
  c := nodo^.Dato;
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
  nodo^.Dato := c;
  GuardarArbolEnArchivo('capacitaciones.dat');
  textcolor(LightCyan);
  Writeln('Datos modificados.');
  textcolor(white);
End;

End.

Unit UnitArbolCapacitaciones;

{$CODEPAGE UTF8}

Interface

Uses UnitCapacitaciones, crt;

Type 
  PNodoCap = ^TNodoCap;
  TNodoCap = Record
    Dato: T_Capacitaciones;
    Izq, Der: PNodoCap;
  End;

  TAccionCap = Procedure (Const c: T_Capacitaciones);

  Unit UnitProceduresCapacitaciones;

{$CODEPAGE UTF8}

  Interface

  Uses 
  crt, SysUtils, DateUtils, UnitCapacitaciones;

Var 
  Archivo_Capacitaciones: file Of T_Capacitaciones;

Procedure DarDeAlta(pos: integer);
Procedure DarDeBaja(pos: integer);
Procedure Modificar_Capacitacion(pos: integer);
Function Buscar_Capacitacion(codigo: String): integer;

// Operaciones basadas en ABB (por codigo)
Procedure DarDeAlta_Codigo(codigo: String);
Procedure DarDeBaja_Codigo(codigo: String);
Procedure Modificar_Capacitacion_Codigo(codigo: String);

Implementation

Uses UnitArbolCapacitaciones;

// ----------------------------
// Procedimientos y funciones (archivo)
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
  // Mantener sincronizado el ABB
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
  // Mantener sincronizado el ABB
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
  // Mantener sincronizado el ABB
  nodo := BuscarCapacitacionArbol(raiz, c.Codigo_Capacitacion);
  If nodo <> Nil Then
    nodo^.Dato := c;
End;

// ----------------------------
// Operaciones basadas en ABB (por codigo)
// ----------------------------
Procedure DarDeAlta_Codigo(codigo: String);

Var nodo: PNodoCap;
  c: T_Capacitaciones;
  FechaInicio, FechaFin, Hoy: TDateTime;
  DiasTranscurridos: integer;
  ok1, ok2: boolean;
Begin
  nodo := BuscarCapacitacionArbol(raiz, codigo);
  If nodo = Nil Then
    Begin
      Writeln('Capacitación no encontrada.');
      Exit;
    End;
  c := nodo^.Dato;

  Hoy := Date;
  ok1 := TryStrToDate(c.Fecha_Inicio, FechaInicio);
  ok2 := TryStrToDate(c.Fecha_Fin, FechaFin);
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
          Writeln('No se puede dar alta: pasaron más de 5 días del inicio.');
          Exit;
        End
      Else
        Writeln('Capacitación en curso, dentro del plazo permitido.');
    End;

  If Not c.Estado_Capacitacion Then
    Begin
      c.Estado_Capacitacion := True;
      nodo^.Dato := c;
      GuardarArbolEnArchivo('capacitaciones.dat');
      Writeln('Capacitación dada de alta correctamente.');
    End
  Else
    Writeln('La capacitación ya está activa.');
End;

Procedure DarDeBaja_Codigo(codigo: String);

Var nodo: PNodoCap;
  c: T_Capacitaciones;
Begin
  nodo := BuscarCapacitacionArbol(raiz, codigo);
  If nodo = Nil Then
    Begin
      Writeln('Capacitación no encontrada.');
      Exit;
    End;
  c := nodo^.Dato;
  If Not c.Estado_Capacitacion Then
    Writeln('La capacitación ya estaba dada de baja.')
  Else
    Begin
      c.Estado_Capacitacion := False;
      nodo^.Dato := c;
      GuardarArbolEnArchivo('capacitaciones.dat');
      Writeln('Capacitación dada de baja correctamente.');
    End;
End;

Procedure Modificar_Capacitacion_Codigo(codigo: String);

Var nodo: PNodoCap;
  c: T_Capacitaciones;
  opcion: integer;
Begin
  nodo := BuscarCapacitacionArbol(raiz, codigo);
  If nodo = Nil Then
    Begin
      Writeln('Capacitación no encontrada.');
      Exit;
    End;
  c := nodo^.Dato;
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
  nodo^.Dato := c;
  GuardarArbolEnArchivo('capacitaciones.dat');
  textcolor(LightCyan);
  Writeln('Datos modificados.');
  textcolor(white);
End;

End.
Writeln('La capacitación ya está activa.');
End;

Procedure DarDeBaja_Codigo(codigo: String);

Var nodo: PNodoCap;
  c: T_Capacitaciones;
Begin
  nodo := BuscarCapacitacionArbol(raiz, codigo);
  If nodo = Nil Then
    Begin
      Writeln('Capacitación no encontrada.');
      Exit;
    End;
  c := nodo^.Dato;
  If Not c.Estado_Capacitacion Then
    Writeln('La capacitación ya estaba dada de baja.')
  Else
    Begin
      c.Estado_Capacitacion := False;
      nodo^.Dato := c;
      GuardarArbolEnArchivo('capacitaciones.dat');
      Writeln('Capacitación dada de baja correctamente.');
    End;
End;

Procedure Modificar_Capacitacion_Codigo(codigo: String);

Var nodo: PNodoCap;
  c: T_Capacitaciones;
  opcion: integer;
Begin
  nodo := BuscarCapacitacionArbol(raiz, codigo);
  If nodo = Nil Then
    Begin
      Writeln('Capacitación no encontrada.');
      Exit;
    End;
  c := nodo^.Dato;
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
  nodo^.Dato := c;
  GuardarArbolEnArchivo('capacitaciones.dat');
  textcolor(LightCyan);
  Writeln('Datos modificados.');
  textcolor(white);
End;

Procedure RecorrerEnOrdenCap(raiz: PNodoCap; accion: TAccionCap);
Begin
  If raiz = Nil Then Exit;
  RecorrerEnOrdenCap(raiz^.Izq, accion);
  accion(raiz^.Dato);
  RecorrerEnOrdenCap(raiz^.Der, accion);
End;

Procedure LiberarArbolCap(Var raiz: PNodoCap);
Begin
  If raiz = Nil Then Exit;
  LiberarArbolCap(raiz^.Izq);
  LiberarArbolCap(raiz^.Der);
  Dispose(raiz);
  raiz := Nil;
End;

Procedure GuardarArbolEnArchivo(Const nombre: String);

Var 
  f: file Of T_Capacitaciones;
Procedure Escribir(Const c: T_Capacitaciones);
Begin
  Write(f, c);
End;
Begin
  Assign(f, nombre);
  {$I-}
  Rewrite(f);
  {$I+}
  If IOResult <> 0 Then
    Exit;
  RecorrerEnOrdenCap(raiz, @Escribir);
  Close(f);
End;

End.
