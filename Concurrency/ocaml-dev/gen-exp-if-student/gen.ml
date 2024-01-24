open Random
open Adder

let rec eval_bool (e:exp) : bool option = 
  match e with
  Bool i -> Some(i)
  |IsZero i -> 
    let evaled = (eval i) in
    (match evaled with
      None -> None
      |Some(x) -> if x == 0 then Some(true)
      else Some(false)
    )
  |If(x1,x2,x3) -> 
    let check = eval_bool x1 in 
    (match check with
      None -> None
      |Some(x) -> 
        if x then
          eval_bool x2
        else eval_bool x3
    )
  |_ -> None

and eval (e : exp) : int option = 
  match e with
  Bool i -> None
  |Int i -> Some(i)
  |If(x1,x2,x3) -> 
    let check = eval_bool x1 in
    (match check with
      None -> None
      |Some(i) ->
        if (i) then 
          eval x2
        else
          eval x3
    ) 
  |Add(x1,x2) -> 
    (let sum = (eval x1, eval x2) in
      match sum with
      (Some a1, Some a2) -> Some(a1+a2)
      |_ -> None
    )
  |IsZero i -> None
  |Size i -> Some(List.length i)




let rec helper x = 
  (*Incase depth = 0*)
  if x == 0 then
    Some(Int (Random.int 100))

  (*Base case when depth = 1*)
  else if x == 1 then 
    let rand = Random.int 6 in
    
    (*Bool Exp*)
    if rand == 0 then
      if Random.int 2 == 0 then
        Some(Bool true)
      else
        Some(Bool false)
      
    (*Int Exp*)
    else if rand == 1 then
      let rand_int = Random.int 100 in
      Some(Int rand_int)
      
    (*If Exp*)
    else if rand == 2 then
      let rand_int = Random.int 100 in
      let rand_int2 = Random.int 100 in
      let rand_int3 = Random.int 2 in (* Coin flip for if statement to be true/false*)
      let rand_int4 = Random.int 2 in (* Coin flip for whether output is Int or Bool*)
      let rand_int5 = Random.int 2 in (* Coin flip for whether Bool output is true / false*)

      if rand_int3 == 0 && rand_int4 == 0 then
        Some(If(Bool true,Int rand_int,Int rand_int2))

      else if rand_int3 == 0 && rand_int4 == 1 then
        if rand_int5 == 0 then
          Some(If(Bool true,Bool true,Bool true))
        else 
          Some(If(Bool true,Bool false,Bool true))

      else if rand_int3 == 1  && rand_int4 == 0 then
        Some(If(Bool false,Int rand_int,Int rand_int2))

      else
        if rand_int5 == 0 then
          Some(If(Bool false,Bool true,Bool true))
        else 
          Some(If(Bool false,Bool false,Bool false))

    (*Add Exp*)
    else if rand == 3 then
      let rand_int = Random.int 100 in
      let rand_int2 = Random.int 100 in
      Some(Add(Int rand_int, Int rand_int2))
      
      (*IsZero Exp*)
    else if rand == 4 then
      let coin_flip = Random.int 2 in
      if coin_flip == 0 then
        Some(Bool true)
      else
        Some(Bool false)

      (*Size Exp*)
    else 
        let length = Random.int 100 in
        if length == 0 then
          let length = 1 in 
          let new_list = List.init length (fun x->0) in
          Some(Size new_list)
        else
          let new_list = List.init length (fun x->0) in
          Some(Size new_list)

  (*Recursive case when depth > 1*)
  else 
    let rand_int = Random.int 3 in

    (*If statement with depth > 1*)
    if rand_int == 0 then
        let rand_oc = Random.int x in
        let rand_oc2 = Random.int x in
        let ran_pick = Random.int 3 in
        let y = 
          if ran_pick == 0 then
            (helper (x-1), helper rand_oc, helper rand_oc2) 
          else if ran_pick ==1 then
            (helper rand_oc, helper (x-1), helper rand_oc2) 
          else
            (helper rand_oc, helper rand_oc2, helper (x-1)) in
        match y with
        (Some x1,Some x2, Some x3) -> 
          (let typ = eval_bool x1 in
          match typ with
          Some x6 -> Some(If(x1,x2,x3))
          |None -> helper x)
        |_-> helper x

    (*Add statement with depth > 1*)
    else if rand_int == 1 then
      let rand_oc = Random.int x in
        let ran_pick = Random.int 2 in
        let y = 
          if ran_pick == 0 then
            (helper (x-1), helper rand_oc)
          else 
            (helper rand_oc, helper (x-1)) in
      match y with 
      (Some x1, Some x2) -> 
        (let (typ1,typ2) = (eval x1, eval x2) in
          match (typ1,typ2) with
          (Some var1,Some var2) ->  Some(Add(x1,x2))
          |_-> helper x
        )
      |_ -> helper x

    (*IsZero statement with depth > 1*)
    else 
      let y = helper (x-1) in
      (match y with
       Some(x1) -> 
        let typ1 = eval x1 in
        (match typ1 with
        Some(x3) -> Some(IsZero(x1))
        |_ -> helper x)
      |_-> helper x)


(*Helper to get depth*)
let rec depth_choice depth_bot depth_top= 
  Random.self_init();
  let x = depth_bot + (Random.int ((depth_top - depth_bot) + 1)) in 
  x


let rec gen_exp (depth_bot : int) (depth_top : int) (target : int) : exp =
  Random.self_init();

    let depth = depth_choice depth_bot depth_top in
    if depth == 0 then
      Int target
    else
      let new_exp = helper (depth) in
      match new_exp with 
      None -> gen_exp depth_bot depth_top target
      |Some x -> 
        let check = eval x in
        match check with
        None -> gen_exp depth_bot depth_top target
        |Some evaled -> 
          if evaled == target then 
            x
          else 
          gen_exp depth_bot depth_top target

