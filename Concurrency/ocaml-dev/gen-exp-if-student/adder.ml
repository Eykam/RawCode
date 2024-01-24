let some = Option.some
let none = Option.none

let (let*) a b = Option.bind a b

type typ =
  | TBool
  | TInt
[@@deriving show]

type exp =
  | Bool of bool
  | Size of (int list)
  | Int of int
  | If of (exp * exp * exp)
  | Add of (exp * exp)
  | IsZero of exp
[@@deriving show]

let rec count_depth = function
  | Bool _ | Int _ | Size _ -> 0
  | If (e1, e2, e3) ->
     1 + (max (count_depth e1) @@ max (count_depth e2) (count_depth e3))
  | Add (e1, e2) ->
     1 + max (count_depth e1) (count_depth e2)
  | IsZero e ->
     1 + count_depth e

let rec typing : exp -> typ option = function
  | Bool _ -> some TBool
  | Int _ | Size _ -> some TInt
  | IsZero e ->
     let* t = typing e in
     if t = TInt then some TBool else none
  | If (e1, e2, e3) -> 
     let* t1 = typing e1 in
     if t1 = TBool
     then let* t2 = typing e2 in
          let* t3 = typing e3 in
          if t2 = t3 then some t2 else none
     else none
  | Add (e1, e2) ->
     let* t1 = typing e1 in 
     let* t2 = typing e2 in
     if t1 = TInt && t1 = t2 then some TInt else none
