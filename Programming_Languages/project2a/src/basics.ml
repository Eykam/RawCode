(***********************************)
(* Part 1: Non-Recursive Functions *)
(***********************************)

(*-----------*)
let rev_tup tup = let (a,b,c) = tup in (c,b,a)

(*------------*)
let abs x = if x >= 0 then x else x *(-1)

(*------------*)
let area x y =
let (a,b) = x in
let (c,d) = y in
let x = (c-a)*(d-b) in
if x >= 0 then x else x*(-1)

(*------------*)
let volume x y =
let (a,b,c) = x in
let (d,e,f) = y in
let x = (d-a)*(e-b)*(f-c) in
if x >= 0 then x else x*(-1)

(*-------------*)
let equiv_frac (a, b) (x, y) =
if b = 0 || y = 0
then false
else
let a = (float_of_int a) in
let b = (float_of_int b) in
let x = (float_of_int x) in
let y = (float_of_int y) in
if a/.b = x/.y  then true else false



(*******************************)
(* Part 2: Recursive Functions *)
(*******************************)

let rec factorial x =
if x = 0 then 1
else
x * factorial(x-1) 

let rec pow x y =
if y = 0 then 1
else
x * pow x (y-1)

let rec tail x num =
let y = pow 10 num in
if x < y then x
else if num = 0 then 0
else if x < y then x
else x mod y

let rec len x =
if x = 0 then 0
else
1 + len(x/10)

let rec contains sub x =
if sub > x then false
else if x = 0 && sub <> 0 then false
else if x = 0 && sub = 0 then true
else if (x-sub) mod (pow 10 (len(sub))) = 0 then true
else contains sub (x/10)

(*****************)
(* Part 3: Lists *)
(*****************)

let rec get idx lst =
match lst with
|[] -> failwith "Out of bounds"
|h::t -> if idx = 0 then h else get (idx-1) t


let rec combine lst1 lst2 =
match lst1 with
|[]->lst2
|h::t-> h::combine t lst2

let rec reverse_helper lst a = match lst with
[]->a
|h::t -> reverse_helper t (h::a)
let rec reverse lst =
reverse_helper lst []

let rec reverse_helper lst a = match lst with
[]->a
|h::t -> reverse_helper t (h::a)
let rec reverse lst =
reverse_helper lst []
let rec append lst1 lst2 = 
match lst1 with
|h::t-> h::append t lst2
|[]->lst2
let rec rotate_helper shift lst a =
let shift = shift mod (List.length lst) in
if shift = 0 then append lst (reverse a) 
else
match lst with
[]->a
|h::t -> rotate_helper (shift-1) t (h::a)
let rec rotate shift lst =
rotate_helper shift lst []

let is_prime h = 
match h with
1 -> false 
|2 -> true
|3 -> true
|4 -> false
|5 -> true
let rec prime_squared lst a= 
	match lst with
	[] -> a
	|h::t -> if is_prime h then prime_squared t (h,h*h)::a
         else prime_squared t a
