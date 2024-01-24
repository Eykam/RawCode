open List
open Sets

(*********)
(* Types *)
(*********)

type ('q, 's) transition = 'q * 's option * 'q

type ('q, 's) nfa_t = {
  sigma: 's list;
  qs: 'q list;
  q0: 'q;
  fs: 'q list;
  delta: ('q, 's) transition list;
}

(***********)
(* Utility *)
(***********)

(* explode converts a string to a character list *)
let explode (s: string) : char list =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l)
  in
  exp (String.length s - 1) []


let rec fold_right f xs a = match xs with
| [] -> a
| x :: xt -> f x (fold_right f xt a)

let rec fold f a xs = match xs with
| [] -> a
| x :: xt -> fold f (f a x) xt

let in_list lst target =
fold (fun acc x -> if x = target then 1+acc else acc) 0 lst


let uniq lst =
fold (fun acc x -> match acc with
	 []-> [x]
	 |h::t-> if h = x then acc else if in_list acc x > 0 then acc else x::acc ) [] lst


(****************)
(* Part 1: NFAs *)
(****************)
let rec reverse_helper lst a = match lst with
  []->a
  |h::t -> reverse_helper t (h::a)
let rec reverse lst =
  reverse_helper lst []

let move (nfa: ('q,'s) nfa_t) (qs: 'q list) (s: 's option) : 'q list =
  reverse(match s with
  |Some x -> if Sets.elem x nfa.sigma = false then [] else
    fold_right (fun a acc -> 
    match a with 
    |(start, Some char, en) -> if (Sets.elem start qs, x = char, elem en acc) = (true,true,false) then en::acc else acc
    |(start, None, en) -> acc
    ) nfa.delta []
  |None -> 
    fold_right (fun a acc ->
    match a with 
    |(start, None, en) -> if (Sets.elem start qs, elem en acc) = (true, false) then en::acc else acc
    |(start, Some char, en) -> acc
    ) nfa.delta [])


(*****************************)
let e_closure (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list =
  uniq ((move nfa qs None)@qs)

(* let accept (nfa: ('q,char) nfa_t) (s: string) : bool =
  let x = nfa_to_dfa nfa in
  let y = x.q0 in
  match (explode s) with
  |h::t -> match nfa.delta with
    |(y, h, last)-> let y = last in if (subset last x.fs) = true then true else false
  |h::[] -> match nfa.delta with
    |(y, h, last)-> if (subset last x.fs) = true then true else false *)


(*******************************)
(* Part 2: Subset Construction *)
(*******************************)

let new_states (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list list =
  List.map (fun x ->e_closure nfa (move nfa qs (Some x))) nfa.sigma

let new_trans (nfa: ('q,'s) nfa_t) (qs: 'q list) : ('q list, 's) transition list =
  List.map (fun x ->(qs,Some x,e_closure nfa (move nfa qs (Some x)))) nfa.sigma

let new_finals (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list list =
  if (fold (fun acc x -> if (Sets.elem x nfa.fs) = true then acc + 1 else acc) 0 qs) > 0 then [qs] else []

let rec work_list (nfa: ('q,'s) nfa_t) (work: 'q list list): ('q list list) = 
  match work with
  |h::t ->Sets.union work (new_states nfa h)
  |[]->[]

  
let rec nfa_to_dfa_step (nfa: ('q,'s) nfa_t) (dfa: ('q list, 's) nfa_t) 
    (work: 'q list list) : ('q list, 's) nfa_t =
    match work with 
    |h::t -> let ret = 
    {
      sigma = dfa.sigma;
      q0=dfa.q0;
      qs = h::dfa.qs ;
      delta = (new_trans nfa h)@dfa.delta;
      fs = (new_finals nfa h)@dfa.fs
    } in nfa_to_dfa_step nfa ret t
    |[]->dfa

let nfa_to_dfa (nfa: ('q,'s) nfa_t) : ('q list, 's) nfa_t =
  let dfa = 
  { sigma = nfa.sigma;
    q0 = e_closure nfa [nfa.q0];
    qs = [];
    delta = [];
    fs = []
  } in nfa_to_dfa_step nfa dfa ([[nfa.q0]]@(work_list nfa (new_states nfa [nfa.q0])))

let mapper (dfa: ('q list, 's) nfa_t) (s: string) : bool list = 
let str = explode s in
(List.map (fun z -> if Sets.subset [z] dfa.fs then true else false) (fold_left (fun acc y-> 
    match (move dfa acc (Some y)) with
      |h::t-> if Sets.eq [] h then acc else h::acc
      |[]->acc
    ) [dfa.q0] str))

let accept (nfa: ('q,char) nfa_t) (s: string) : bool =
  let x = nfa_to_dfa nfa in fold_right (fun y acc-> if y = true then acc && true else acc = false) (mapper x s) true
  
