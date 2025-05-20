#include <iostream>

struct State {
    double position;
    double velocity;
    double integral;
    double prev_error;
};

void simulate_pid(
    State current,
    double target,
    double mass,
    double k_p,
    double k_i,
    double k_d,
    double dt,
    int step,
    int total_steps
) {
    if (step >= total_steps) return;

    double error = target - current.position;
    double derivative = (error - current.prev_error) / dt;
    double force = k_p * error + k_i * current.integral + k_d * derivative;

    double acceleration = force / mass;
    double new_velocity = current.velocity + acceleration * dt;
    double new_position = current.position + new_velocity * dt;
    double new_integral = current.integral + error * dt;

    std::cout << "Step " << step + 1 << ": Position = " << new_position << std::endl;

    State next = {new_position, new_velocity, new_integral, error};
    simulate_pid(next, target, mass, k_p, k_i, k_d, dt, step + 1, total_steps);
}

int main() {
    const double M = 2.0;       // Mass
    const double P_i = 0.0;     // Initial position
    const double P_t = 10.0;    // Target position
    const double k_p = 0.5, k_i = 0.1, k_d = 0.2;
    const double dt = 0.1;      // Time interval
    const int s = 1000;          // Steps

    State initial = {P_i, 0.0, 0.0, 0.0};
    simulate_pid(initial, P_t, M, k_p, k_i, k_d, dt, 0, s);

    return 0;
}