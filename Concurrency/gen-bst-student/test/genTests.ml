open Fun
open OUnit2
open Tree

let () = Random.self_init ()

let gen = Gen.gen_bst


let report_trees l r n nut = 
  Printf.sprintf
    "%s\nNumber of different trees: [%d / %d] \nRange: [%d, %d]"
    "Too few unique trees"
    n nut l r

let test_gen m nut = 
  let l = 300 in
  let r = l + m - 1 in
  let trees = List.(init 1000 (fun _ -> gen l r) |> sort_uniq Stdlib.compare) in
  let n = List.length trees in
  assert_bool (report_trees l r n nut) (n >= nut);
  (l, r, trees)

let test_gen3 _ = let _ = test_gen 3 5 in ()

let tests =
  [ "test_gen3" >:: test_gen3 ]

let suite =
  "genTests" >::: tests

let _ =
  run_test_tt_main suite
