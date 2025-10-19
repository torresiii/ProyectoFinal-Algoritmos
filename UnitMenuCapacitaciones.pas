
Unit UnitMenuCapacitaciones;

Interface

Uses crt, CargasYMuestras;

Procedure Menu_Capacitaciones;

Var 
  Archivo_Capacitaciones: file Of T_Capacitaciones;

Implementation

Procedure Menu_Capacitaciones;

Var 
  c: T_Capacitaciones;
  opcion: integer;

Begin
  clrscr;
  assign(Archivo_Capacitaciones,'capacitaciones.dat');
  {$I-}
  reset(Archivo_Capacitaciones);{$I-}
  If ioresult <> 0 Then
    rewrite(Archivo_Capacitaciones);
  Repeat
    clrscr;
    TextColor(Yellow);
    writeln('==================================== ');
    TextColor(LightCyan);
    writeln('        MENU CAPACITACIONES       ');
    TextColor(Yellow);
    writeln('==================================== ');
    TextColor(LightCyan);
    writeln('1. Agregar capacitacion');
    writeln('2. Listar capacitaciones');
    writeln('0. Volver al menu principal');
    write('Opcion: ');
    readln(opcion);
    Case opcion Of 
      1:
         Begin
           Cargar_Capacitacion(c);
           seek(Archivo_Capacitaciones, filesize(Archivo_Capacitaciones));
           write(Archivo_Capacitaciones, c);
           writeln('Capacitacion Agregada');
           writeln('Presione cualquier tecla para volver...');
           readkey;
         End;

      2:
         Begin
           clrscr;
           reset(Archivo_Capacitaciones);
           While Not eof(Archivo_Capacitaciones) Do
             Begin
               read(Archivo_Capacitaciones, c);
               Mostrar_Capacitacion(c);
             End;
           readkey;
         End;
    End;
    writeln('Presione cualquier tecla para volver...');
  Until opcion = 0;
  close(Archivo_Capacitaciones);
End;

End.
