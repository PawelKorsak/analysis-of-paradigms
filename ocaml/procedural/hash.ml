let generate_salt ?(length=16) () =
  let rand = Random.State.make_self_init () in
  let buffer = Buffer.create length in
  for _ = 1 to length do
    let byte = Random.State.int rand 256 in  (* 0-255 *)
    Buffer.add_string buffer (Printf.sprintf "%02x" byte)
  done;
  Buffer.contents buffer

let simple_xor_hash ~key input =
  let buffer = Buffer.create (String.length input * 2) in
  String.iter (fun c ->
    let hashed_byte = Char.code c lxor key in
    Buffer.add_string buffer (Printf.sprintf "%02x" hashed_byte)
  ) input;  (* Fixed: Added closing parenthesis here *)
  Buffer.contents buffer

let () =
  let password = "password123" in
  let salt = generate_salt () in
  let salted_input = password ^ salt in
  let hash = simple_xor_hash ~key:0xAA salted_input in
  Printf.printf "Salt: %s\nHash: %s\n" salt hash