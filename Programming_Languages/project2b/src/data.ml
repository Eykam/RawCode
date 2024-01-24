open Funs

(***********************)
(* Part 2: Integer BST *)
(***********************)

type int_tree =
  | IntLeaf
  | IntNode of int * int_tree * int_tree

let empty_int_tree = IntLeaf

let rec int_insert x t =
  match t with
  | IntLeaf -> IntNode(x, IntLeaf, IntLeaf)
  | IntNode (y, l, r) when x > y -> IntNode (y, l, int_insert x r)
  | IntNode (y, l, r) when x = y -> t
  | IntNode (y, l, r) -> IntNode (y, int_insert x l, r)

let rec int_mem x t =
  match t with
  | IntLeaf -> false
  | IntNode (y, l, r) when x > y -> int_mem x r
  | IntNode (y, l, r) when x = y -> true
  | IntNode (y, l, r) -> int_mem x l

(* Implement the functions below. *)

let rec int_size t =
match t with
IntLeaf -> 0
|IntNode (y,l,r) -> 1 + int_size l + int_size r


let rec int_max t = 
if int_size t = 0 then raise (invalid_arg("int_max")) else
match t with
|IntNode (y,l,r) -> if r = IntLeaf then y else int_max r

let rec int_common t x y =
if int_size t = 0 || int_mem x t = false || int_mem y t = false then
raise (invalid_arg("int_common")) else
match t with
|IntNode (curr,l,r) -> if (curr >= x && curr <= y) || (curr >= y && curr <= x) then curr 
else if curr > x && curr > y then int_common l x y 
else int_common r x y

(***************************)
(* Part 3: Polymorphic BST *)
(***************************)

type 'a atree =
    Leaf
  | Node of 'a * 'a atree * 'a atree
type 'a compfn = 'a -> 'a -> int
type 'a ptree = 'a compfn * 'a atree

let empty_ptree f : 'a ptree = (f,Leaf)

(* Implement the functions below. *)

let rec ainsert v tree f =
match tree with
Leaf -> Node(v,Leaf,Leaf)
|Node(y,l,r) when (f v y) < 0 -> Node (y,ainsert v l f,r)
|Node(y,l,r) when (f v y) > 0 -> Node (y,l, ainsert v r f)
|Node(y,l,r) when (f v y) = 0 -> tree
let rec pinsert x t =
match t with 
(a,Leaf) -> (a,Node (x,Leaf,Leaf))
|(a,Node (y,l,r)) when (a x y) < 0 -> (a,Node(y,ainsert x l a,r))
|(a,Node (y,l,r)) when (a x y) > 0 -> (a,Node(y,l,ainsert x r a))
|(a,Node (y,l,r)) when (a x y) = 0 -> t

let rec pmem x t = 
match t with (a,b) ->
match b with
Leaf -> false
|Node (y,l,r) when a x y < 0 -> pmem x (a,l)
|Node (y,l,r) when a x y = 0 -> true
|Node (y,l,r) when a x y > 0 -> pmem x (a,r)

let rec pinsert_all lst t =
match lst with
[]-> t
|h::tail -> pinsert_all tail (pinsert h t)

let rec list_maker lst x =
match x with
Leaf -> lst
|Node (y,l,r) -> list_maker ((list_maker lst l)@[y]) r
let rec p_as_list t = 
match t with (a,b) -> list_maker [] b

let pmap f t =
match t with (a,b)->
pinsert_all (map f (p_as_list t)) (a,Leaf)

(***************************)
(* Part 4: Variable Lookup *)
(***************************)

type  lookup_table = 
|Nil
|Table of ((string * int) list) * lookup_table * bool


let empty_table () : lookup_table = Nil

let push_scope (table: lookup_table) : lookup_table = 
match table with 
|Nil -> Table([],Nil,true)
|Table (vars,parent,first) -> Table([],table,false)

let pop_scope (table: lookup_table) : lookup_table = 
match table with
|Nil -> failwith "No scopes remain!"
|Table (_,table,first) when first = true -> Nil
|Table (_,table,first) when first = false -> table

let add_var name value (table: lookup_table) : lookup_table =
match table with
|Nil-> failwith "There are no scopes to add a variable to!"
|Table (vs,par,first) -> Table(((name,value)::vs),par,first)

let rec lookup_helper name lst =
match lst with
|[]-> failwith "Variable not found!"
|(a,b)::t -> if a = name then b else lookup_helper name t
let rec lookup name (table: lookup_table) =
match table with
|Nil -> failwith "Variable not found!"
|Table (vs,par,first) -> lookup_helper name vs
