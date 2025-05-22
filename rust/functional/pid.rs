#[derive(Clone, Copy)]
struct State {
    position: f64,
    velocity: f64,
    integral: f64,
    prev_error: f64,
}

fn simulate_pid(
    state: State,
    target: f64,
    mass: f64,
    k_p: f64,
    k_i: f64,
    k_d: f64,
    dt: f64,
    step: usize,
    total_steps: usize,
) -> State {
    if step >= total_steps {
        return state;
    }

    let error = target - state.position;
    let derivative = (error - state.prev_error) / dt;
    let force = k_p * error + k_i * state.integral + k_d * derivative;
    
    let acceleration = force / mass;
    let new_velocity = state.velocity + acceleration * dt;
    let new_position = state.position + new_velocity * dt;
    let new_integral = state.integral + error * dt;

    let next_state = State {
        position: new_position,
        velocity: new_velocity,
        integral: new_integral,
        prev_error: error,
    };

    // Uncomment for debugging:
    // println!("Step {}: Position = {:.2}", step + 1, next_state.position);
    
    simulate_pid(next_state, target, mass, k_p, k_i, k_d, dt, step + 1, total_steps)
}

fn main() {
    let initial_state = State {
        position: 0.0,
        velocity: 0.0,
        integral: 0.0,
        prev_error: 0.0,
    };
    
    let final_state = simulate_pid(
        initial_state,
        10.0,   // Target
        2.0,    // Mass
        0.5, 0.1, 0.2, // PID gains
        0.1,    // dt
        0,      // Start step
        1000,   // Total steps
    );
    
    println!("Final position: {:.2}", final_state.position);
}