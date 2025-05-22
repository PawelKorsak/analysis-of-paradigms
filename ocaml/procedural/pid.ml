type state = {
  mutable position : float;
  mutable velocity : float;
  mutable integral : float;
  mutable prev_error : float;
}

type params = {
  target : float;
  mass : float;
  k_p : float;
  k_i : float;
  k_d : float;
  dt : float;
  total_steps : int;
}

let simulate_pid state target mass k_p k_i k_d dt total_steps =
  for step = 0 to total_steps - 1 do
    let error = target -. state.position in
    let derivative = (error -. state.prev_error) /. dt in
    let force = (k_p *. error) +. (k_i *. state.integral) +. (k_d *. derivative) in
    let acceleration = force /. mass in

    state.velocity <- state.velocity +. acceleration *. dt;
    state.position <- state.position +. state.velocity *. dt;
    state.integral <- state.integral +. error *. dt;
    state.prev_error <- error
  done

let () =
  let initial_state = { position = 0.0; velocity = 0.0; integral = 0.0; prev_error = 0.0 } in
  let params = {
    target = 10.0;
    mass = 2.0;
    k_p = 0.5;
    k_i = 0.1;
    k_d = 0.2;
    dt = 0.1;
    total_steps = 1000
  } in
  
  simulate_pid initial_state params.target params.mass params.k_p params.k_i params.k_d params.dt params.total_steps;
  Printf.printf "Final position: %.2f\n" initial_state.position