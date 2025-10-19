
Unit UnitMenuAlumnos;

Interface

Uses crt, CargasYMuestras;

Procedure Menu_Alumnos;

Var 
  Archivo_Alumnos: file Of T_Alumnos;

Implementation

Procedure Menu_Alumnos;

Var 
  a: T_Alumnos;
  opcion: integer;

Begin
  clrscr;
  assign(Archivo_Alumnos,'alumnos.dat');
  {$I-}
  reset(Archivo_Alumnos); {$I-}
  If ioresult <> 0 Then
    rewrite(Archivo_Alumnos);

  Repeat
    clrscr;
    TextColor(Yellow);
    writeln('====================================');
    TextColor(LightCyan);
    writeln('           MENU ALUMNOS            ');
    TextColor(Yellow);
    writeln('====================================');
    TextColor(LightCyan);
    writeln('1. Agregar alumno');
    writeln('2. Listar alumnos');
    writeln('0. Volver al menu principal');
    write('Opcion: ');
    readln(opcion);

    Case opcion Of 
      1:
         Begin
           Cargar_Alumnos(a);
           seek(Archivo_Alumnos, filesize(Archivo_Alumnos));
           write(Archivo_Alumnos, a);
           writeln('Alumno agregado.');
           writeln('Presione cualquier tecla para volver...');
           readkey;
         End;

      2:
         Begin
           clrscr;
           reset(Archivo_Alumnos);
           While Not eof(Archivo_Alumnos) Do
             Begin
               read(Archivo_Alumnos, a);
               Mostrar_Alumno(a);
             End;
           readkey;
         End;
    End;
    writeln('Presione cualquier tecla para volver...');
  Until opcion = 0;
  close(Archivo_Alumnos);
End;

End.
