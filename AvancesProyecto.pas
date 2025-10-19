
Program AvancesProyecto;

Uses crt, CargasYMuestras;

Var 
  Archivo_Capacitaciones: file Of T_Capacitaciones;
  Archivo_Alumnos: file Of T_Alumnos;
  opcion: integer;

Procedure Mostramos_Menu_Principal;
Begin
  //textbackground cambia color de fondo hasta un clrscr
  //textcolor cambia color de texto siguiente
  clrscr;
  TextColor(Yellow);
  writeln('============================ ');
  TextColor(LightCyan);
  writeln('        MENU PRINCIPAL       ');
  TextColor(Yellow);
  writeln('============================ ');
  TextColor(LightCyan);
  writeln('1. Capacitaciones            ');
  writeln('2. Alumnos                  ');
  writeln('3. Listados                  ');
  writeln('4. Estadisticas                  ');
  writeln('0. Salir                     ');
  writeln('---------------------------- ');
  TextColor(LightGreen);
  writeln('Ingrese una opcion:          ');
  TextColor(White);
End;


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


Procedure Menu_Listados;
Begin
  clrscr;
  Writeln('Para volver presione la tecla 0');
  readkey();
  //1 Por area y nombre de todas las capacitaciones
  //2 Capacitaciones de un alumno
  //3 Alumnos aprobados en una capacitacion
  //4 Generar certificado de aprobacion(capacitacion/alumno)
  //5 Volver
End;

Procedure Menu_Estadisticas;
Begin
  clrscr;
  readkey();
  //1 Cantidad de capacitaciones entre fechas
  //2 Porcentaje de capacitaciones por area
  //3 Opcion a eleccion
  //4 Volver
End;

Begin
  Repeat
    Mostramos_Menu_Principal;
    readln(opcion);
    Case opcion Of 
      1: Menu_Capacitaciones;
      2: Menu_Alumnos;
      3: Menu_Listados;
      4: Menu_Estadisticas;
      0:
         Begin
           clrscr;
           writeln('Saliendo del programa...');
           delay(1000);
         End;
      Else
        Begin
          clrscr;
          writeln('Opcion invalida.');
          writeln('Presione una tecla para continuar...');
          readkey;
        End;
    End;
  Until opcion = 0;
End.
