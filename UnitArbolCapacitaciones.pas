
Unit UnitArbolCapacitaciones;

Interface

Uses CargasYMuestras, crt;



// Nodo y operaciones para árbol binario de capacitaciones (clave: Codigo_Capacitacion)

Type 
  PNodoCap = ^TNodoCap;
  TNodoCap = Record
    Dato: T_Capacitaciones;
    Izq, Der: PNodoCap;
  End;

  TAccionCap = Procedure (Const c: T_Capacitaciones);

Procedure InicializarArbolCap(Var raiz: PNodoCap);
Procedure InsertarCapacitacion(Var raiz: PNodoCap; Const c: T_Capacitaciones);
Function BuscarCapacitacionArbol(raiz: PNodoCap; Const codigo: String): PNodoCap
;
Procedure RecorrerEnOrdenCap(raiz: PNodoCap; accion: TAccionCap);
Procedure LiberarArbolCap(Var raiz: PNodoCap);

Implementation

Procedure InicializarArbolCap(Var raiz: PNodoCap);
Begin
  raiz := Nil;
End;

Procedure InsertarCapacitacion(Var raiz: PNodoCap; Const c: T_Capacitaciones);
Begin
  If raiz = Nil Then
    Begin
      New(raiz);
      raiz^.Dato := c;
      raiz^.Izq := Nil;
      raiz^.Der := Nil;
    End
  Else If c.Codigo_Capacitacion < raiz^.Dato.Codigo_Capacitacion Then
         InsertarCapacitacion(raiz^.Izq, c)
  Else If c.Codigo_Capacitacion > raiz^.Dato.Codigo_Capacitacion Then
         InsertarCapacitacion(raiz^.Der, c)
  Else
  ;
  // clave duplicada: no se inserta (puede actualizarse si se desea)
End;

Function BuscarCapacitacionArbol(raiz: PNodoCap; Const codigo: String): PNodoCap
;
Begin
  If raiz = Nil Then
    BuscarCapacitacionArbol := Nil
  Else If codigo = raiz^.Dato.Codigo_Capacitacion Then
         BuscarCapacitacionArbol := raiz
  Else If codigo < raiz^.Dato.Codigo_Capacitacion Then
         BuscarCapacitacionArbol := BuscarCapacitacionArbol(raiz^.Izq, codigo)
  Else
    BuscarCapacitacionArbol := BuscarCapacitacionArbol(raiz^.Der, codigo);
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

End.
