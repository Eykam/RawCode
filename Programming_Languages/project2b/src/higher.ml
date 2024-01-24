open Funs

(********************************)
(* Part 1: High Order Functions *)
(********************************)

let count_occ lst target =
fold(fun x y -> x+y) 0 (map (fun x -> if x = target then 1 else 0) lst)

let in_list lst target =
fold (fun acc x -> if x = target then 1+acc else acc) 0 lst
let uniq lst =
fold (fun acc x -> match acc with
	 []-> [x]
	 |h::t-> if h = x then acc else if in_list acc x > 0 then acc else x::acc ) [] lst

let in_list lst target = 
fold (fun acc x -> if x = target then 1+acc else acc) 0 lst
let assoc_list lst = 
let x = uniq lst in
map (fun y -> (y,in_list lst y)) x
