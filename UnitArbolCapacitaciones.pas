
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

Procedure InicializarArbolCap(Var raiz: PNodoCap);
Procedure InsertarCapacitacion(Var raiz: PNodoCap; Const c: T_Capacitaciones);
Function BuscarCapacitacionArbol(raiz: PNodoCap; Const codigo: String): PNodoCap;
Procedure RecorrerEnOrdenCap(raiz: PNodoCap; accion: TAccionCap);
Procedure LiberarArbolCap(Var raiz: PNodoCap);

Var 
  raiz: PNodoCap;

Procedure GuardarArbolEnArchivo(Const nombre: String);

Implementation

Var 
  f: file Of T_Capacitaciones;

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

Procedure EscribirEnArchivo(Const c: T_Capacitaciones);
Begin
  Write(f, c);
End;

Procedure GuardarArbolEnArchivo(Const nombre: String);
Begin
  Assign(f, nombre);
  {$I-}
  Rewrite(f);
  {$I+}
  If IOResult <> 0 Then
    Exit;
  RecorrerEnOrdenCap(raiz, @EscribirEnArchivo);
  Close(f);
End;

End.
