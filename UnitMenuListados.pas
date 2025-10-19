
Unit UnitMenuListados;

Interface

Uses crt;

Procedure Menu_Listados;

Implementation

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

End.
