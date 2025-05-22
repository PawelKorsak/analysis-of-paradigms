class pid_controller target mass k_p k_i k_d dt =
  object (self)
    val mutable position = 0.0
    val mutable velocity = 0.0
    val mutable integral = 0.0
    val mutable prev_error = 0.0

    method simulate total_steps =
      for step = 0 to total_steps - 1 do
        let error = target -. position in
        let derivative = (error -. prev_error) /. dt in
        let force = (k_p *. error) +. (k_i *. integral) +. (k_d *. derivative) in
        let acceleration = force /. mass in

        velocity <- velocity +. acceleration *. dt;
        position <- position +. velocity *. dt;
        integral <- integral +. error *. dt;
        prev_error <- error;

        (* Print step (uncomment if needed)
        Printf.printf "Step %d: Position = %.2f\n%!" (step + 1) position *)
      done

    method get_position = position
  end

let () =
  let controller = new pid_controller 10.0 2.0 0.5 0.1 0.2 0.1 in
  controller#simulate 1000;
  Printf.printf "Final position: %.2f\n" controller#get_position