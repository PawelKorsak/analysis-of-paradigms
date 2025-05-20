#include <iostream>

class PIDController {
private:
    double k_p, k_i, k_d;
    double integral = 0.0;
    double prev_error = 0.0;

public:
    PIDController(double p, double i, double d) : k_p(p), k_i(i), k_d(d) {}

    double compute_force(double error, double dt) {
        integral += error * dt;
        double derivative = (error - prev_error) / dt;
        prev_error = error;
        return k_p * error + k_i * integral + k_d * derivative;
    }
};

class MassSimulator {
private:
    double mass;
    double position;
    double velocity = 0.0;
    PIDController& controller;

public:
    MassSimulator(double m, double initial_pos, PIDController& pid)
        : mass(m), position(initial_pos), controller(pid) {}

    void step(double target, double dt) {
        double error = target - position;
        double force = controller.compute_force(error, dt);
        double acceleration = force / mass;
        velocity += acceleration * dt;
        position += velocity * dt;
    }

    double get_position() const { return position; }
};

int main() {
    const double M = 2.0;       // Mass
    const double P_i = 0.0;     // Initial position
    const double P_t = 10.0;    // Target position
    const double k_p = 0.5, k_i = 0.1, k_d = 0.2;
    const double dt = 0.1;      // Time interval
    const int s = 1000;          // Steps

    PIDController pid(k_p, k_i, k_d);
    MassSimulator simulator(M, P_i, pid);

    for (int step = 0; step < s; ++step) {
        simulator.step(P_t, dt);
        // std::cout << "Step " << step + 1 << ": Position = " << simulator.get_position() << std::endl;
    }

    return 0;
}