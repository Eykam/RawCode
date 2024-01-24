open Common
open Plsolution
(* PUT ANY HELPER FUNCTIONS YOU WANT UP HERE! *)

let rec map_tup f list =
  match list with
  [] -> []
  |(a,b) :: remainder -> (f a, f b) :: map_tup f remainder

let rec unify constraints =
  match constraints with
    [] -> Some([])
  | (s,t)::rem_constraints ->
    (* Delete *)
    if s = t then unify rem_constraints
    else
      (match s
       with TyVar n -> 
          (let occ = occurs n t in
            match occ with true -> None
            |false ->
              let subs1 = map_tup (monoTy_lift_subst [(n,t)]) rem_constraints in
              let subst = unify subs1 in
              (match subst with None -> None
              |Some(x) -> 
                let j = monoTy_lift_subst x t in
                Some((n,j)::x)   
              )
          )

         | TyConst(c,args) ->  (* Orient and Decompose*)
           (match t
            with TyVar x -> unify ((t,s)::rem_constraints)
            |TyConst(b, args1) ->
              let new_consts = List.combine args args1 in
              if c = b then unify (new_consts@rem_constraints)
              else None)


  (* Filling in the block above. *)



  )



