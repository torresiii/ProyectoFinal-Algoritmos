
Unit UnitMenuCapacitaciones;

Interface

Uses crt, CargasYMuestras;

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

// MENÚ PRINCIPAL DE CAPACITACIONES
Procedure Menu_Capacitaciones;

Var 
  c: T_Capacitaciones;
  codigo_cap: string;
  pos, opcion: integer;
  resp: char;
Begin
  clrscr;
  assign(Archivo_Capacitaciones, 'capacitaciones.dat');
  {$I-}
  reset(Archivo_Capacitaciones);
  {$I+}
  If ioresult <> 0 Then
    rewrite(Archivo_Capacitaciones);

  Repeat
    clrscr;
    // Pedimos el código al abrir el menú
    write('Ingrese el codigo de la capacitacion: ');
    readln(codigo_cap);
    pos := Buscar_Capacitacion(codigo_cap);

    If pos = -1 Then
      Begin
        writeln('Capacitacion no encontrada.');
        write('Desea darla de alta? (S/N): ');
        readln(resp);
        If UpCase(resp) = 'S' Then
          Begin
            Cargar_Capacitacion(c);
            seek(Archivo_Capacitaciones, filesize(Archivo_Capacitaciones));
            write(Archivo_Capacitaciones, c);
            writeln('Capacitacion agregada correctamente.');
          End
        Else
          writeln('No se realizo ninguna accion.');
      End
    Else
      Begin
        seek(Archivo_Capacitaciones, pos);
        read(Archivo_Capacitaciones, c);
        clrscr;
        writeln('Capacitacion encontrada:');
        Mostrar_Capacitacion(c);
        writeln;
        writeln('1. Modificar');
        writeln('2. Dar de baja');
        writeln('0. Volver');
        write('Opcion: ');
        readln(opcion);

        Case opcion Of 
          1: Modificar_Capacitacion(pos);
          2: DarDeBaja(pos);
        End;
      End;

    writeln('Presione cualquier tecla para continuar...');
    readkey;

  Until false;
  // se puede cambiar por una opción de salir si querés
  close(Archivo_Capacitaciones);
End;

End.
