program AvancesProyecto;

uses crt;

type

  T_Capacitaciones = Record
    Codigo_Capacitacion: string[10]; // Unico identificador
    Nombre_Capacitacion: string[50];
    Fecha_Inicio: string[10]; // Formato DD/MM/AAAA
    Fecha_Fin: string[10];
    Tipo_Capacitacion: string[10]; // Curso/taller/seminario
    Cantidad_Horas: integer;
    Docentes: string[100]; // Lista separada por comas(,)
    Cantidad_Alumnos: integer;
    Area: string[10]; // ISI, LOI, ELECTRO, Civil o General
    Estado_Capacitacion: boolean;
  End;

  T_Alumnos = Record
    Codigo_Capacitacion_Alumno: string[10]; // Unico identificador
    DNI: string[15];
    Apellido_Nombre: string[50];
    Fecha_Nacimiento: string[10]; // Formato DD/MM/AAAA
    Docente_UTN: string [3]; // Si o no
    Condicion: string[10]; // Aprobado/Asistencia
    Estado_Alumno: boolean
  End;

var
    opcion: integer;

Procedure Cargar_Capacitacion (Var c: T_Capacitaciones);
var
  Opcion_Estado: char;
begin
  clrscr;
  writeln('--- Carga de Capacitacion ---');
  write('Codigo: '); readln(c.Codigo_Capacitacion);
  write('Nombre: '); readln(c.Nombre_Capacitacion);
  write('Fecha de inicio (DD/MM/AAAA): '); readln(c.Fecha_Inicio);
  write('Fecha de fin (DD/MM/AAAA): '); readln(c.Fecha_Fin);
  write('Tipo (curso/taller/seminario): '); readln(c.Tipo_Capacitacion);
  write('Cantidad de horas: '); readln(c.Cantidad_Horas);
  write('Docentes (separados por coma): '); readln(c.Docentes);
  write('Cantidad de alumnos inscriptos: '); readln(c.Cantidad_Alumnos);
  write('Area (ISI/LOI/Civil/Electro/General): '); readln(c.Area);
  repeat
    write('Estado (A = activo / N = no activo): ');
    readln(Opcion_Estado);
    Opcion_Estado := upcase(Opcion_Estado); // upcase pone todo el mayus
  until (Opcion_Estado = 'A') or (Opcion_Estado = 'N'); 
  c.Estado_Capacitacion := Opcion_Estado = 'A'; //si es A es true y si es N es false
end;

Procedure Mostrar_Capacitacion (Var c:T_Capacitaciones);
begin
  writeln('Codigo: ', c.Codigo_Capacitacion);
  writeln('Nombre: ', c.Nombre_Capacitacion);
  writeln('Fecha inicio: ', c.Fecha_Inicio);
  writeln('Fecha fin: ', c.Fecha_Fin);
  writeln('Tipo: ', c.Tipo_Capacitacion);
  writeln('Horas: ', c.Cantidad_Horas);
  writeln('Docentes: ', c.Docentes);
  writeln('Alumnos inscriptos: ', c.Cantidad_Alumnos);
  writeln('Area: ', c.Area);
    if c.Estado_Capacitacion then
      writeln('Estado: Activo')
    else
      writeln('Estado: No activo');
      writeln('-------------------------------');
end;

Procedure Mostramos_Menu_Principal;
begin
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
end;


Procedure Menu_Capacitaciones;
var 
  Archivo_Capacitaciones: file of T_Capacitaciones;
  c: T_Capacitaciones;
  opcion: integer;

begin
  clrscr;
  assign(Archivo_Capacitaciones,'capacitaciones.dat');
  {$I-}reset(Archivo_Capacitaciones);{$I-}
    if ioresult <> 0 then
    rewrite(Archivo_Capacitaciones);
      repeat
        clrscr;
        writeln('==================================== ');
        TextColor(LightCyan);
        writeln('        MENU CAPACITACIONES       ');
        TextColor(Yellow);
        writeln('==================================== ');
        writeln('1. Agregar capacitacion');
        writeln('2. Listar capacitaciones');
        writeln('0. Volver al menu principal');
        write('Opcion: '); readln(opcion);
        case opcion of
          1: begin
              Cargar_Capacitacion(c);
              seek(Archivo_Capacitaciones, filesize(Archivo_Capacitaciones));
              write(Archivo_Capacitaciones, c);
              writeln('Capacitacion Agregada');
              writeln('Presione cualquier tecla para volver...');
              readkey;
            End;

          2: begin
              clrscr;
              reset(Archivo_Capacitaciones);
              while not eof(Archivo_Capacitaciones) do 
              begin
                read(Archivo_Capacitaciones, c);
                Mostrar_Capacitacion(c);
              end;
              readkey;
            end;
        end;
        writeln('Presione cualquier tecla para volver...');
     until opcion = 0;
  close(Archivo_Capacitaciones);
end;

Procedure Menu_Alumnos;
begin
  clrscr;
  Writeln('Ingrese el codigo de Capacitacion');
  Writeln('Ingrese DNI');
  Writeln('Para volver presione la tecla 0');
  readkey();
//1 si no se encuentra hay que crear la opcion de:
//darlo de alta -alta
//2 si se encuentra hay que mostrar:
//-Muestra Datos(consulta)
//   -Darlo de baja
//   -Modificacion 
//   -Volver atras
end;

Procedure Menu_Listados;
begin
  clrscr;
  Writeln('Para volver presione la tecla 0');
  readkey();
//1 Por area y nombre de todas las capacitaciones
//2 Capacitaciones de un alumno
//3 Alumnos aprobados en una capacitacion
//4 Generar certificado de aprobacion(capacitacion/alumno)
//5 Volver
end;

Procedure Menu_Estadisticas;
begin
  clrscr;
  readkey();
//1 Cantidad de capacitaciones entre fechas
//2 Porcentaje de capacitaciones por area
//3 Opcion a eleccion
//4 Volver
end;

begin
  repeat
    Mostramos_Menu_Principal; 
    readln(opcion);
    case opcion of
      1: Menu_Capacitaciones;
      2: Menu_Alumnos;
      3: Menu_Listados;
      4: Menu_Estadisticas;
      0: begin
           clrscr;
           writeln('Saliendo del programa...');
           delay(1000);
         end;
    else
      begin
        clrscr;
        writeln('Opcion invalida.');
        writeln('Presione una tecla para continuar...');
        readkey;
      end;
    end;
  until opcion = 0;
end.