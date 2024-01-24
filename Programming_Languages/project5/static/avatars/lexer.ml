open TokenTypes


let re_num = Str.regexp "-?[0-9]+" 
let re_bool = Str.regexp "true|false"
let re_id = Str.regexp "[a-zA-Z][a-zA-Z0-9]*"
let re_for = Str.regexp "for"
let re_from = Str.regexp "from"
let re_to = Str.regexp "to"
let re_while = Str.regexp "while"
let re_int_type = Str.regexp "int"
let re_bool_type = Str.regexp "bool"
let re_sub = Str.regexp "-"
let re_semi = Str.regexp ";"
let re_rparen = Str.regexp ")"
let re_rbrace = Str.regexp "}"
let re_print = Str.regexp "printf"
let re_pow = Str.regexp "\\^"
let re_add = Str.regexp "\\+"
let re_or = Str.regexp "||"
let re_nequal = Str.regexp "!="
let re_not = Str.regexp "!"
let re_mult = Str.regexp "\\*"
let re_main = Str.regexp "main"
let re_lesseq = Str.regexp "<="
let re_less = Str.regexp "<"
let re_lparen = Str.regexp "("
let re_lbrace = Str.regexp "{"
let re_if = Str.regexp "if"
let re_gequal = Str.regexp ">="
let re_great = Str.regexp ">"
let re_equal = Str.regexp "=="
let re_else = Str.regexp "else"
let re_div = Str.regexp "/"
let re_assign = Str.regexp "="
let re_and = Str.regexp "&&"
let re_space = Str.regexp "[ \n\r\t]+"

exception IllegalExpression of string 

let tokenize input =
  let rec tok pos s =
    if pos >= String.length s then
      [EOF]
    else
      if (Str.string_match re_num s pos) then  (*check again*)
        let token = Str.matched_string s in
          (Tok_Int (int_of_string token))::(tok (pos+(String.length token)) s)
      else if (Str.string_match re_bool s pos) then
        if (Str.matched_string s) = "true" then
          Tok_Bool true ::(tok (pos+4) s)
        else 
          Tok_Bool false ::(tok (pos+5) s)
      else if (Str.string_match re_for s pos) then
        Tok_For::(tok (pos+3) s)
      else if (Str.string_match re_from s pos) then
        Tok_From::(tok (pos+4) s)
      else if (Str.string_match re_to s pos) then
        Tok_To::(tok (pos+2) s)
      else if (Str.string_match re_while s pos) then
        Tok_While::(tok (pos+5) s)
      else if (Str.string_match re_int_type s pos) then
        Tok_Int_Type::(tok (pos+3) s)
      else if (Str.string_match re_bool_type s pos) then
        Tok_Bool_Type::(tok (pos+4) s)
      else if (Str.string_match re_sub s pos) then
        Tok_Sub::(tok (pos+1) s)
      else if (Str.string_match re_semi s pos) then
        Tok_Semi::(tok (pos+1) s)
      else if (Str.string_match re_rparen s pos) then
        Tok_RParen::(tok (pos+1) s)
      else if (Str.string_match re_rbrace s pos) then
        Tok_RBrace::(tok (pos+1) s)
      else if (Str.string_match re_print s pos) then
        Tok_Print::(tok (pos+6) s)
      else if (Str.string_match re_pow s pos) then
        Tok_Pow::(tok (pos+1) s)
      else if (Str.string_match re_add s pos) then 
        Tok_Add::(tok (pos+1) s)
      else if (Str.string_match re_or s pos) then
        Tok_Or::(tok (pos+2) s)
      else if (Str.string_match re_nequal s pos) then
        Tok_NotEqual::(tok (pos+2) s)
      else if (Str.string_match re_not s pos) then
        Tok_Not::(tok (pos+1) s)
      else if (Str.string_match re_mult s pos) then
        Tok_Mult::(tok (pos+1) s)
      else if (Str.string_match re_main s pos) then
        Tok_Main::(tok (pos+4) s)
      else if (Str.string_match re_lesseq s pos) then
        Tok_LessEqual::(tok (pos+2) s)
      else if (Str.string_match re_less s pos) then
        Tok_Less::(tok (pos+1) s)
      else if (Str.string_match re_lparen s pos) then
        Tok_LParen::(tok (pos+1) s)
      else if (Str.string_match re_lbrace s pos) then
        Tok_LBrace::(tok (pos+1) s)
      else if (Str.string_match re_if s pos) then
        Tok_If::(tok (pos+2) s)
      else if (Str.string_match re_gequal s pos) then
        Tok_GreaterEqual::(tok (pos+2) s)
      else if (Str.string_match re_great s pos) then
        Tok_Greater::(tok (pos+1) s)
      else if (Str.string_match re_equal s pos) then
        Tok_Equal::(tok (pos+2) s)
      else if (Str.string_match re_else s pos) then
        Tok_Else::(tok (pos+4) s)
      else if (Str.string_match re_div s pos) then
        Tok_Div::(tok (pos+1) s)
      else if (Str.string_match re_assign s pos) then
        Tok_Assign::(tok (pos+1) s)
      else if (Str.string_match re_and s pos) then
        Tok_And::(tok (pos+2) s)
      else if (Str.string_match re_id s pos) then  (*check again*)
        let token = Str.matched_string s in
          (Tok_ID token)::(tok (pos+(String.length token)) s)
      else if (Str.string_match re_space s pos) then
        let token = Str.matched_string s in
          (tok (pos+(String.length token)) s)
      else
        raise (IllegalExpression "tokenize")
  in tok 0 input
  