struct State {
    position: f64,
    velocity: f64,
    integral: f64,
    prev_error: f64,
}

fn simulate_pid(
    state: &mut State,
    target: f64,
    mass: f64,
    k_p: f64,
    k_i: f64,
    k_d: f64,
    dt: f64,
    total_steps: usize,
) {
    for step in 0..total_steps {
        let error = target - state.position;
        let derivative = (error - state.prev_error) / dt;
        let force = k_p * error + k_i * state.integral + k_d * derivative;
        
        let acceleration = force / mass;
        state.velocity += acceleration * dt;
        state.position += state.velocity * dt;
        state.integral += error * dt;
        state.prev_error = error;

        // Uncomment for debugging:
        // println!("Step {}: Position = {:.2}", step + 1, state.position);
    }
}

fn main() {
    let mut state = State {
        position: 0.0,
        velocity: 0.0,
        integral: 0.0,
        prev_error: 0.0,
    };
    
    simulate_pid(
        &mut state,
        10.0,   // Target
        2.0,    // Mass
        0.5, 0.1, 0.2, // PID gains
        0.1,    // dt
        1000,   // Steps
    );
    
    println!("Final position: {:.2}", state.position);
}