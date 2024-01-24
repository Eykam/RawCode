open Adder

module Eval =
  struct
    let ( let* ) a b = Option.bind a b

    let rec eval (e : exp) : int option = 
      None
  end
let eval = Eval.eval 


(** Generator Module *)
module G =                     
  struct 
    type 'a t = unit -> 'a

    (** return the encapsulated object (run the generator) *)
    let run g = g ()

    (** create an generator that only generates [a]

        Caveat: OCaml is CBV, [a] is evaluated first before it's wrapped as an
        generator. So, there're some differences between writing [ret a] and
        [fun () -> a].  
     *)
    let ret a = fun () -> a

    (** binding operator 

        [val (>>=) : 'a t -> ('a -> 'b t) -> 'b t] 
     *)
    let (>>=) m f : 'b t = fun () -> run m |> f |> run

    (** carry out both computation in sequence but only return the result from
        the second object
     *)
    let (>>) m1 m2 = fun () -> let _ = run m1 in run m2

    (** syntax sugar *)
    let ( let* ) = (>>=)

    (** generate a number between \[low, high\) *)
    let choose low high : int t =
      failwith "unimplemented"

    (** pick one of the following generators *)
    let one_of (gs : 'a t list) : 'a t =
      failwith "unimplemented"
           
    (** lift generator on an empty list *)
    let gen_list (g : 'a t) n : 'a list t =
      failwith "unimplemented"
  end

let gen_exp depth_bot depth_top target : exp =
  let open G in
  let rec gen_int_exp depth value : exp t =
    failwith "unimplemented"
  and gen_bool_exp depth : (exp * bool) t =
    failwith "unimplemented"
  in gen_int_exp 0 target
