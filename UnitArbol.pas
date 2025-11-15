
Unit unitarbol;

Interface

Uses crt, UnitCapacitaciones;

Type 
  t_dato = T_Capacitaciones;
  t_punt = ^t_nodo;
  t_nodo = Record
    info: t_dato;
    sai, sad: t_punt;
  End;

Procedure crear_arbol(Var raiz: t_punt);
Procedure agregar(Var raiz: t_punt; x: t_dato);
Function arbol_vacio(raiz: t_punt): boolean;
Function arbol_lleno(raiz: t_punt): boolean;
Procedure suprime(Var raiz: t_punt; x: t_dato);
Procedure inorden(Var raiz: t_punt);
Procedure preorden(raiz: t_punt; buscado: char; Var enc: boolean; Var x: t_dato);

Var 
  raiz: t_punt;

Implementation

Procedure crear_arbol(Var raiz: t_punt);
Begin
  raiz := Nil;
End;

Procedure agregar(Var raiz: t_punt; x: t_dato);
Begin
  If raiz = Nil Then
    Begin
      new(raiz);
      raiz^.info := x;
      raiz^.sai := Nil;
      raiz^.sad := Nil;
    End
  Else If raiz^.info > x Then agregar(raiz^.sai, x)
  Else agregar(raiz^.sad, x);
End;

Function arbol_vacio(raiz: t_punt): boolean;
Begin
  arbol_vacio := raiz = Nil;
End;

Function arbol_lleno(raiz: t_punt): boolean;
Begin
  arbol_lleno := getheapstatus.totalfree < sizeof(t_nodo);
End;

Function suprime_min(Var raiz: t_punt): t_dato;

Var dir: t_punt;
Begin
  If raiz^.sai = Nil Then
    Begin
      suprime_min := raiz^.info;
      dir := raiz;
      raiz := raiz^.sad;
      dispose(dir);
    End
  Else
    suprime_min := suprime_min(raiz^.sai);
End;

Procedure suprime(Var raiz: t_punt; x: t_dato);
Begin
  If raiz <> Nil Then
    If x < raiz^.info Then
      suprime(raiz^.sai, x)
  Else If x > raiz^.info Then
         suprime(raiz^.sad, x)
  Else If (raiz^.sai = Nil) And (raiz^.sad = Nil) Then
         raiz := Nil
  Else If raiz^.sai = Nil Then
         raiz := raiz^.sad
  Else If raiz^.sad = Nil Then
         raiz := raiz^.sai
  Else
    raiz^.info := suprime_min(raiz^.sad);
End;

Procedure preorden(raiz: t_punt; buscado: char; Var enc: boolean; Var x: t_dato);
Begin
  If raiz = Nil Then enc := false
  Else If raiz^.info = buscado Then
         Begin
           enc := true;
           x := raiz^.info;
         End
  Else If raiz^.info > buscado Then
         preorden(raiz^.sai, buscado, enc, x)
  Else
    preorden(raiz^.sad, buscado, enc, x);
End;

Procedure inorden(Var raiz: t_punt);
Begin
  If raiz <> Nil Then
    Begin
      inorden(raiz^.sai);
      writeln(raiz^.info);
      inorden(raiz^.sad);
    End;
End;

End.
