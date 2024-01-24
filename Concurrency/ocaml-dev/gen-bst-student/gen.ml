open Tree

let rec gen_bst l r =
  Random.self_init()
  let x = (r - l + 1) in
  let y = Random.int x in
  let z = l + y in
  Node(z,gen_bst)
