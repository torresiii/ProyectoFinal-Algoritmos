
Unit UnitMenuCapacitaciones;

{$CODEPAGE UTF8}

Interface

Uses 
crt, SysUtils, DateUtils, UnitCapacitaciones, UnitProceduresCapacitaciones;

Procedure Menu_Capacitaciones;

Implementation

Uses UnitArbolCapacitaciones;

Procedure Menu_Capacitaciones;

Var 
  c: T_Capacitaciones;
  codigo_cap: string;
  opcion: integer;
  resp: char;
  salir: boolean;
  nodo: PNodoCap;
Begin
  clrscr;
  Assign(Archivo_Capacitaciones, 'capacitaciones.dat');

  {$I-}
  Reset(Archivo_Capacitaciones);
  {$I+}
  If IOResult <> 0 Then
    Rewrite(Archivo_Capacitaciones);

  // Inicializar y cargar ABB desde el archivo
  InicializarArbolCap(raiz);
  Seek(Archivo_Capacitaciones, 0);
  While Not EOF(Archivo_Capacitaciones) Do
    Begin
      Read(Archivo_Capacitaciones, c);
      InsertarCapacitacion(raiz, c);
    End;


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
        nodo := BuscarCapacitacionArbol(raiz, codigo_cap);

        If nodo = Nil Then
          Begin
            Writeln('Capacitación no encontrada.');
            Write('¿Agregarla? (S/N): ');
            Readln(resp);

            If UpCase(resp) = 'S' Then
              Begin
                Cargar_Capacitacion(c);
                c.Codigo_Capacitacion := codigo_cap;
                c.Estado_Capacitacion := True;

                // Insertar en ABB y guardar archivo completo
                InsertarCapacitacion(raiz, c);
                GuardarArbolEnArchivo('capacitaciones.dat');

                textcolor(LightCyan);
                Writeln('Capacitación agregada.');
                textcolor(white);
                ReadKey;
              End;
          End
        Else
          Begin
            Repeat
              nodo := BuscarCapacitacionArbol(raiz, codigo_cap);
              If nodo = Nil Then
                Begin
                  writeln('Error: la capacitación dejó de existir.');
                  Break;
                End;
              c := nodo^.Dato;

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
                1: Modificar_Capacitacion_Codigo(codigo_cap);
                2: If c.Estado_Capacitacion Then DarDeBaja_Codigo(codigo_cap);
                3: If Not c.Estado_Capacitacion Then DarDeAlta_Codigo(codigo_cap
                     );
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
  LiberarArbolCap(raiz);
End;

End.
