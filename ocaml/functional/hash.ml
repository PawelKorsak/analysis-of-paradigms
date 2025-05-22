let generate_salt ?(length=16) () =
  let rand = Random.State.make_self_init () in
  List.init length (fun _ -> Random.State.int rand 256)
  |> List.map (Printf.sprintf "%02x")
  |> String.concat ""

let simple_xor_hash ~key input =
  input
  |> String.map (fun c -> Char.chr (Char.code c lxor key))
  |> String.to_seq
  |> Seq.map (fun c -> Printf.sprintf "%02x" (Char.code c))
  |> Seq.fold_left (^) ""

let () =
  let password = "password123" in
  let salt = generate_salt () in
  let salted_input = password ^ salt in
  let hash = simple_xor_hash ~key:0xAA salted_input in
  Printf.printf "Salt: %s\nHash: %s\n" salt hash