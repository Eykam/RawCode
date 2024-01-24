open SmallCTypes
open Utils
open TokenTypes

(* Parsing helpers (you don't need to modify these) *)

(* Return types for parse_stmt and parse_expr *)
type stmt_result = token list * stmt
type expr_result = token list * expr

(* Return the next token in the token list, throwing an error if the list is empty *)
let lookahead (toks : token list) : token =
  match toks with
  | [] -> raise (InvalidInputException "No more tokens")
  | h::_ -> h

(* Matches the next token in the list, throwing an error if it doesn't match the given token *)
let match_token (toks : token list) (tok : token) : token list =
  match toks with
  | [] -> raise (InvalidInputException(string_of_token tok))
  | h::t when h = tok -> t
  | h::_ -> raise (InvalidInputException(
      Printf.sprintf "Expected %s from input %s, got %s"
        (string_of_token tok)
        (string_of_list string_of_token toks)
        (string_of_token h)
    ))

(* Parsing (TODO: implement your code below) *)

let rec parse_expr toks : expr_result =
    parse_OrExpr toks
  and parse_OrExpr toks : expr_result =
    let (toks, a) = (parse_AndExpr toks) in
    match (lookahead toks) with
    | Tok_Or -> let toks = (match_token toks Tok_Or) in 
      let (toks,b) = (parse_OrExpr toks) in (toks, Or(a,b))
    | _ -> (toks,a)
  and parse_AndExpr toks : expr_result = 
    let (toks, a) = (parse_EqualityExpr toks) in
    match (lookahead toks) with
    | Tok_And -> let toks = (match_token toks Tok_And) in 
      let (toks, b) = (parse_AndExpr toks) in (toks, And(a,b))
    | _ -> (toks,a)
  and parse_EqualityExpr toks : expr_result = 
    let (toks, a) = (parse_RelationalExpr toks) in
    match (lookahead toks) with
    | Tok_Equal -> let toks = (match_token toks Tok_Equal) in 
      let (toks,b) = (parse_EqualityExpr toks) in (toks,Equal(a,b))
    | _ -> (toks,a)
  and parse_RelationalExpr toks : expr_result = 
    let (toks,a) = (parse_AdditiveExpr toks) in 
    match (lookahead toks) with
    | Tok_Less -> let toks = (match_token toks Tok_Less) in 
        let (toks,b) = (parse_RelationalExpr toks) in (toks, Less(a,b))
    | Tok_LessEqual -> let toks = (match_token toks Tok_LessEqual) in 
      let (toks,b) = (parse_RelationalExpr toks) in (toks, LessEqual(a,b))
    | Tok_Greater -> let toks = (match_token toks Tok_Greater) in 
      let (toks,b) = (parse_RelationalExpr toks) in (toks, Greater(a,b))
    | Tok_GreaterEqual -> let toks = (match_token toks Tok_GreaterEqual) in 
      let (toks,b) = (parse_RelationalExpr toks) in (toks, GreaterEqual(a,b))
    | _ -> (toks,a)
  and parse_AdditiveExpr toks : expr_result = 
    let (toks,a) = (parse_MultiplicativeExpr toks) in
    match (lookahead toks) with
    | Tok_Add -> let toks = (match_token toks Tok_Add) in 
     let (toks,b) = (parse_AdditiveExpr toks) in (toks, Add(a,b))
    | Tok_Sub -> let toks = (match_token toks Tok_Sub) in 
      let (toks,b) = (parse_AdditiveExpr toks) in (toks, Sub(a,b))
    | _ -> (toks,a)
  and parse_MultiplicativeExpr toks : expr_result = 
    let (toks,a) = (parse_PowerExpr toks)  in
    match (lookahead toks) with
    | Tok_Mult -> let toks = (match_token toks Tok_Mult) in 
      let (toks,b) = (parse_MultiplicativeExpr toks) in (toks, Mult(a,b))
    | Tok_Div -> let toks = (match_token toks Tok_Div) in 
      let (toks,b) = (parse_MultiplicativeExpr toks) in (toks, Div(a,b))
    | _ -> (toks,a)
  and parse_PowerExpr toks : expr_result = 
    let (toks,a) = (parse_UnaryExpr toks) in
    match (lookahead toks) with
    | Tok_Pow -> let toks = (match_token toks Tok_Pow) in 
      let (toks,b) = (parse_RelationalExpr toks) in (toks, Pow(a,b))
    | _ -> (toks,a)
  and parse_UnaryExpr toks : expr_result = 
    match (lookahead toks) with
    | Tok_Not -> let toks = (match_token toks Tok_Not) in 
      let (toks,unary) = (parse_UnaryExpr toks) in (toks, Not(unary))
    | _ -> parse_PrimaryExpr (toks)
  and parse_PrimaryExpr (toks : token list) : expr_result = 
    match (lookahead toks) with
    | Tok_Int x -> ((match_token toks (Tok_Int x)),Int x)
    | Tok_Bool b -> ((match_token toks (Tok_Bool b)), Bool b)
    | Tok_ID s -> ((match_token toks (Tok_ID s)), ID s)
    | Tok_LParen -> let toks = (match_token toks Tok_LParen) in
        let (toks,e) = (parse_expr toks) in
        let toks = (match_token toks Tok_RParen) in
        (toks,e)
    | _ -> raise (InvalidInputException("parse_primary failed"))

    (*********************************************************************************************)




let rec parse_stmt toks : stmt_result =
  match (lookahead toks) with
  | Tok_Int_Type -> let toks = (match_token toks Tok_Int_Type) in (
    match (lookahead toks) with
    | Tok_ID s -> let toks = (match_token toks (Tok_ID s)) in
      let toks = (match_token toks Tok_Semi) in
      let (toks,stmt) = parse_stmt toks in 
        (toks,Seq(Declare(Int_Type, s), stmt))
    | _ -> raise (InvalidInputException(""))
  )
  | Tok_Bool_Type -> let toks = (match_token toks Tok_Bool_Type) in (
    match (lookahead toks) with
    | Tok_ID s -> let toks = (match_token toks (Tok_ID s)) in
      let toks = (match_token toks Tok_Semi) in 
      let (toks,stmt) = parse_stmt toks in
        (toks,Seq(Declare(Bool_Type, s), stmt))
    | _ -> raise (InvalidInputException(""))
  )
  | Tok_ID s -> let toks = (match_token toks (Tok_ID s)) in
    let toks = (match_token toks Tok_Assign) in
    let (toks,e) = (parse_expr toks) in
    let toks = (match_token toks Tok_Semi) in 
    let (toks, stmt) = parse_stmt toks in
    (toks, Seq(Assign(s, e), stmt))
  | Tok_Print -> let toks = (match_token toks Tok_Print)in
    let toks = (match_token toks Tok_LParen) in
      let (toks, e) = (parse_expr toks) in
      let toks = (match_token toks Tok_RParen)in
      let toks = (match_token toks Tok_Semi) in
      let (toks,stmt) = parse_stmt toks in
      (toks,Seq(Print(e), stmt))
  | Tok_If -> let toks = (match_token toks Tok_If) in
     let toks = (match_token toks Tok_LParen) in
      let (toks,e) = (parse_expr toks) in
      let toks = (match_token toks Tok_RParen) in
      let toks = (match_token toks Tok_LBrace) in
      let (toks,s1) = (parse_stmt toks) in 
      let toks = (match_token toks Tok_RBrace) in (
      match (lookahead toks) with
      | Tok_Else -> let toks = (match_token toks Tok_Else) in
        let toks = (match_token toks Tok_LBrace) in
          let (toks,s2) = (parse_stmt toks) in
          let toks = (match_token toks Tok_RBrace) in
          let (toks,stmt) = parse_stmt toks in
          (toks,Seq(If(e, s1, s2), stmt))
      | _ -> let (toks,s) = parse_stmt toks in (toks, Seq(If(e, s1, NoOp), s)) 
      )
  | Tok_For -> let toks = (match_token toks Tok_For) in let toks = (match_token toks Tok_LParen) in (
    match (lookahead toks) with 
    | Tok_ID s -> let toks = (match_token toks (Tok_ID s)) in 
      let toks = (match_token toks Tok_From) in
        let (toks, e1) = (parse_expr toks) in
        let toks = (match_token toks Tok_Int_Type) in
        let (toks, e2) = (parse_expr toks) in
        let toks = (match_token toks Tok_RParen) in
        let toks = (match_token toks Tok_LBrace) in
        let (toks,s1) = (parse_stmt toks) in
        let toks = (match_token toks Tok_RBrace) in
        let (toks,s2) = parse_stmt toks in
        (toks,Seq(For(s, e1, e2, s1), s2))
    | _ ->  raise (InvalidInputException(""))
  )
  | Tok_While -> let toks = (match_token toks Tok_While) in
      let toks = (match_token toks Tok_LParen) in
      let (toks,e) = parse_expr toks in
      let toks = (match_token toks Tok_RParen) in
      let toks = (match_token toks Tok_LBrace) in
      let (toks,s1) = (parse_stmt toks) in
      let toks = (match_token toks Tok_RBrace) in
      let (toks,stmt) = parse_stmt toks in
      (toks,Seq(While(e, s1), stmt))
  | Tok_RBrace -> (toks,NoOp)
  | _ -> raise (InvalidInputException("")) 



  (**************************************************************************************************)
let parse_main toks : stmt =
  let toks = (match_token toks Tok_Int_Type) in
  let toks = (match_token toks Tok_Main) in
  let toks = (match_token toks Tok_LParen) in
  let toks = (match_token toks Tok_RParen) in
  let toks = (match_token toks Tok_LBrace) in
  let (toks,stmt) = parse_stmt toks in
  let toks = (match_token toks Tok_RBrace) in
  let toks = (match_token toks EOF) in
  stmt

