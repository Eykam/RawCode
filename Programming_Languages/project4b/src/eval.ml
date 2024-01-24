open SmallCTypes
open EvalUtils
open TokenTypes


exception TypeError of string
exception DeclareError of string
exception DivByZeroError

let rec check_var env var =
  match env with
  | (name, v)::t -> if var = name then true else check_var t var
  | [] -> false

let rec matcher env var =
    match env with
    | (name, v)::t -> if var = name then v else matcher t var
    | [] -> raise (DeclareError "No Var")
  
  
let rec eval_expr env t =
  match t with
  | Bool(a) -> Bool_Val(a)
  | ID(a) -> matcher env a
  | Int(a) -> Int_Val(a)


  | Sub(n1, n2) ->
    let a = (eval_expr env n1) in
    let b = (eval_expr env n2) in (
    match a with
    | Int_Val(c) -> (
      match b with
      | Int_Val(d) -> Int_Val(c - d)
      | _ -> raise (TypeError ""))
    | _ -> raise (TypeError ""))


  | Add(n1, n2) ->
    let a = (eval_expr env n1) in
    let b = (eval_expr env n2) in (
    match a with
    | Int_Val(c) -> (
      match b with
      | Int_Val(d) -> Int_Val(c + d)
      | _ -> raise (TypeError ""))
    | _ -> raise (TypeError ""))


  | Pow(n1, n2) ->
    let a = eval_expr env n1 in
    let b  = eval_expr env n2 in
    (match a with
    | Int_Val(c) ->
      (match b  with
      | Int_Val(d) -> Int_Val(int_of_float((float_of_int c) ** (float_of_int d)))
      | _ -> raise (TypeError ""))
    | _ -> raise (TypeError ""))


  | Mult(n1, n2) ->
    let a = (eval_expr env n1) in
    let b = (eval_expr env n2) in
    (match a with
    | Int_Val(c) ->
      (match b with
      | Int_Val(d) -> Int_Val(c * d)
      | _ -> raise (TypeError ""))
    | _ -> raise (TypeError ""))


  | Div(n1, n2) ->
    let a = (eval_expr env n1) in
    let b = (eval_expr env n2) in
    (match a with
    | Int_Val(c) ->
      (match b with
      | Int_Val(d) ->
        if d != 0 then Int_Val(c / d) 
        else raise (DivByZeroError)
      | _ -> raise (TypeError ""))
    | _ -> raise (TypeError ""))


  | And(n1, n2) ->
    let a = (eval_expr env n1) in
    let b  = (eval_expr env n2) in
    (match a with
    | Bool_Val(c) ->
      (match b  with
      | Bool_Val(d) -> Bool_Val(c && d)
      | _ -> raise (TypeError ""))
    | _ -> raise (TypeError ""))


  | Not(x) ->
    let a = (eval_expr env x) in
    (match a with
    | Bool_Val(c) -> Bool_Val(not c)
    | _ -> raise (TypeError ""))


  | Or(n1, n2) ->
    let a = (eval_expr env n1) in
    let b  = (eval_expr env n2) in
    (match a with
    | Bool_Val(c) ->
      (match b  with
      | Bool_Val(d) -> Bool_Val(c || d)
      | _ -> raise (TypeError ""))
    | _ -> raise (TypeError ""))

  | Equal(n1, n2) ->
    let a = (eval_expr env n1) in
    let b  = (eval_expr env n2) in
    (match a with
    | Bool_Val(c) ->
      (match b  with
      | Bool_Val(d) -> Bool_Val(d = c)
      | _ -> raise (TypeError ""))
    | Int_Val(c) ->
      (match b  with
      | Int_Val(d) -> Bool_Val(c = d)
      | _ -> raise (TypeError "")))


  | NotEqual(n1, n2) ->
    let a = (eval_expr env n1) in
    let b  = (eval_expr env n2) in
    (match a with
    | Bool_Val(c) ->
      (match b  with
      | Bool_Val(d) -> Bool_Val(d <> c)
      | _ -> raise (TypeError ""))
    | Int_Val(c) ->
      (match b  with
      | Int_Val(d) -> Bool_Val(d <> c)
      | _ -> raise (TypeError "")))


  | Greater(n1, n2) ->
    let a = (eval_expr env n1) in
    let b  = (eval_expr env n2) in
    (match a with
    | Int_Val(c) ->
      (match b  with
      | Int_Val(d) -> Bool_Val(d < c)
      | _ -> raise (TypeError ""))
    | _ -> raise (TypeError ""))


  | GreaterEqual(n1, n2) ->
    let a = (eval_expr env n1) in
    let b  = (eval_expr env n2) in
    (match a with
    | Int_Val(c) ->
      (match b  with
      | Int_Val(d) -> Bool_Val(d <= c)
      | _ -> raise (TypeError ""))
    | _ -> raise (TypeError ""))


  | Less(n1, n2) ->
    let a = (eval_expr env n1) in
    let b  = (eval_expr env n2) in
    (match a with
    | Int_Val(c) ->
      (match b  with
      | Int_Val(d) -> Bool_Val(c < d)
      | _ -> raise (TypeError ""))
    | _ -> raise (TypeError ""))


  | LessEqual(n1, n2) ->
    let a = (eval_expr env n1) in
    let b  = (eval_expr env n2) in
    (match a with
    | Int_Val(c) ->
      (match b  with
      | Int_Val(d) -> Bool_Val(d >= c)
      | _ -> raise (TypeError ""))
    | _ -> raise (TypeError ""))



let rec eval_stmt env s =
  match s with
  | NoOp -> env
  | Seq(n1, n2) ->
    let env = eval_stmt env n1 in
    let env = eval_stmt env n2 in
    env


  | While(n1, n2) ->
    (
    match (eval_expr env n1) with
    | Bool_Val(x) ->
      if x= true then
        let env = eval_stmt env n2 in
        eval_stmt env s
      else env
    | _ -> raise (TypeError "")
    )


  | Assign(n, x) ->
    if (check_var env n) = false then raise (DeclareError "")
    else
      let prev_val = matcher env n in
      let val_to_assign = eval_expr env x in
      let env = List.remove_assoc n env in
      (
      match (prev_val, val_to_assign) with
      | Bool_Val(x), Bool_Val(y) -> (n, val_to_assign)::env
      | Int_Val(x), Int_Val(y) -> (n, val_to_assign)::env
      | _ -> raise (TypeError "")
      )


  | Declare(a, n) ->
    if (check_var env n) = true then raise (DeclareError "")
    else
    (match a with
    | Bool_Type -> (n, Bool_Val(false))::env
    | Int_Type -> (n, Int_Val(0))::env)
  