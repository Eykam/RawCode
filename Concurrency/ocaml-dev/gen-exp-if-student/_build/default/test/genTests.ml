open Fun
open OUnit2
open Adder

let eval, gen = Gen.eval, Gen.gen_exp

let test_you_small ctx =
  for i = 0 to 3 do
    for j = i to 3 do
      for n = 0 to 100 do
        let e = gen i j n in  
        let msg = [%derive.show: exp] e in
        assert_equal ~printer:[%derive.show: (int option)] ~msg:msg (Some n) (Gen.eval e)
      done
    done
  done


let test_you ctx =
  for i = 0 to 8 do
    for j = i to 8 do
      for n = 0 to 100 do
        let e = gen i j n in  
        let msg = [%derive.show: exp] e in
        assert_equal ~printer:[%derive.show: (int option)] ~msg:msg (Some n) (Gen.eval e)
      done
    done
  done

let tests =
  [ "pbt_your_gen_and_eval_small" >:: test_you_small
  ; "pbt_your_gen_and_eval" >:: test_you]

let suite =
  "genTests" >::: tests

let _ = run_test_tt_main suite
