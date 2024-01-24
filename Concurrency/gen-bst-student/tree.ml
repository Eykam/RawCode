type bst = Leaf
         | Node of int * bst * bst

let string_of_bst bst =
  let rec aux t pre =
    match t with
    | Leaf -> pre ^ "*"
    | Node(i, Leaf, Leaf) ->
       Printf.sprintf "%s(%s * *)"
         pre (string_of_int i)
    | Node(i, t1, t2) ->
       Printf.sprintf "%s(%s\n%s\n%s)"
         pre (string_of_int i)
         (aux t1 (pre ^ "  "))
         (aux t2 (pre ^ "  "))
  in aux bst "" ^ "\n"                
