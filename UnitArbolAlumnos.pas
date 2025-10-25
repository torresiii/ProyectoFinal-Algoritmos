
Unit UnitArbolAlumnos;

Interface

Uses CargasYMuestras, crt;

// Nodo y operaciones para árbol binario de alumnos (clave: DNI)

Type 
  PNodoAlu = ^TNodoAlu;
  TNodoAlu = Record
    Dato: T_Alumnos;
    Izq, Der: PNodoAlu;
  End;

  TAccionAlu = Procedure (Const a: T_Alumnos);

Procedure InicializarArbolAlu(Var raiz: PNodoAlu);
Procedure InsertarAlumno(Var raiz: PNodoAlu; Const a: T_Alumnos);
Function BuscarAlumnoArbol(raiz: PNodoAlu; Const dni: String): PNodoAlu;
Procedure RecorrerEnOrdenAlu(raiz: PNodoAlu; accion: TAccionAlu);
Procedure LiberarArbolAlu(Var raiz: PNodoAlu);

Implementation

Procedure InicializarArbolAlu(Var raiz: PNodoAlu);
Begin
  raiz := Nil;
End;

Procedure InsertarAlumno(Var raiz: PNodoAlu; Const a: T_Alumnos);
Begin
  If raiz = Nil Then
    Begin
      New(raiz);
      raiz^.Dato := a;
      raiz^.Izq := Nil;
      raiz^.Der := Nil;
    End
  Else If a.DNI < raiz^.Dato.DNI Then
         InsertarAlumno(raiz^.Izq, a)
  Else If a.DNI > raiz^.Dato.DNI Then
         InsertarAlumno(raiz^.Der, a)
  Else
  ;
  // duplicado: ignorar o actualizar según convenga
End;

Function BuscarAlumnoArbol(raiz: PNodoAlu; Const dni: String): PNodoAlu;
Begin
  If raiz = Nil Then
    BuscarAlumnoArbol := Nil
  Else If dni = raiz^.Dato.DNI Then
         BuscarAlumnoArbol := raiz
  Else If dni < raiz^.Dato.DNI Then
         BuscarAlumnoArbol := BuscarAlumnoArbol(raiz^.Izq, dni)
  Else
    BuscarAlumnoArbol := BuscarAlumnoArbol(raiz^.Der, dni);
End;

Procedure RecorrerEnOrdenAlu(raiz: PNodoAlu; accion: TAccionAlu);
Begin
  If raiz = Nil Then Exit;
  RecorrerEnOrdenAlu(raiz^.Izq, accion);
  accion(raiz^.Dato);
  RecorrerEnOrdenAlu(raiz^.Der, accion);
End;

Procedure LiberarArbolAlu(Var raiz: PNodoAlu);
Begin
  If raiz = Nil Then Exit;
  LiberarArbolAlu(raiz^.Izq);
  LiberarArbolAlu(raiz^.Der);
  Dispose(raiz);
  raiz := Nil;
End;

End.
