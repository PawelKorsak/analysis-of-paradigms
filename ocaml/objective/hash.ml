class hasher key =
  object (self)
    val mutable rand = Random.State.make_self_init ()

    method generate_salt ?(length=16) () =
      let salt = Buffer.create length in
      for _ = 1 to length do
        let byte = Random.State.int rand 256 in
        Buffer.add_string salt (Printf.sprintf "%02x" byte)
      done;
      Buffer.contents salt

    method xor_hash input =
      let buffer = Buffer.create (String.length input * 2) in
      String.iter (fun c ->
        let hashed_byte = Char.code c lxor key in
        Buffer.add_string buffer (Printf.sprintf "%02x" hashed_byte)
      ) input;  (* Fixed: Added closing parenthesis here *)
      Buffer.contents buffer
  end

let () =
  let hasher = new hasher 0xAA in
  let password = "password123" in
  let salt = hasher#generate_salt () in
  let salted_input = password ^ salt in
  let hash = hasher#xor_hash salted_input in
  Printf.printf "Salt: %s\nHash: %s\n" salt hash