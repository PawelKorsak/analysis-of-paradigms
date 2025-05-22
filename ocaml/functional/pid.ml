type state = {
  position : float;
  velocity : float;
  integral : float;
  prev_error : float;
}

let rec simulate_pid state target mass k_p k_i k_d dt step total_steps =
  if step >= total_steps then state
  else
    let error = target -. state.position in
    let derivative = (error -. state.prev_error) /. dt in
    let force = (k_p *. error) +. (k_i *. state.integral) +. (k_d *. derivative) in
    let acceleration = force /. mass in

    let new_velocity = state.velocity +. acceleration *. dt in
    let new_position = state.position +. new_velocity *. dt in
    let new_integral = state.integral +. error *. dt in

    let next_state = {
      position = new_position;
      velocity = new_velocity;
      integral = new_integral;
      prev_error = error;
    } in

    (* Print step (uncomment if needed)
    Printf.printf "Step %d: Position = %.2f\n%!" (step + 1) next_state.position; *)

    simulate_pid next_state target mass k_p k_i k_d dt (step + 1) total_steps

let () =
  let initial_state = { position = 0.0; velocity = 0.0; integral = 0.0; prev_error = 0.0 } in
  let final_state = simulate_pid initial_state 10.0 2.0 0.5 0.1 0.2 0.1 0 1000 in
  Printf.printf "Final position: %.2f\n" final_state.position