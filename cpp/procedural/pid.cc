#include <iostream>

int main() {
    const double M = 2.0;       // Mass
    const double P_i = 0.0;     // Initial position
    const double P_t = 10.0;    // Target position
    const double k_p = 0.5, k_i = 0.1, k_d = 0.2;
    const double dt = 0.1;      // Time interval
    const int s = 1000;          // Steps

    double position = P_i;
    double velocity = 0.0;
    double integral = 0.0;
    double prev_error = 0.0;

    for (int step = 0; step < s; ++step) {
        double error = P_t - position;
        integral += error * dt;
        double derivative = (error - prev_error) / dt;
        double force = k_p * error + k_i * integral + k_d * derivative;

        double acceleration = force / M;
        velocity += acceleration * dt;
        position += velocity * dt;
        prev_error = error;

        // std::cout << "Step " << step + 1 << ": Position = " << position << std::endl;
    }

    return 0;
}