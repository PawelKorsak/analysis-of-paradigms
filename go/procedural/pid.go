package main

import "fmt"

type State struct {
	Position  float64
	Velocity  float64
	Integral  float64
	PrevError float64
}

func simulatePID(current State, target, mass, kP, kI, kD, dt float64, steps int) State {
	for step := 0; step < steps; step++ {
		error := target - current.Position
		derivative := (error - current.PrevError) / dt
		force := kP*error + kI*current.Integral + kD*derivative

		acceleration := force / mass
		current.Velocity += acceleration * dt
		current.Position += current.Velocity * dt
		current.Integral += error * dt
		current.PrevError = error

		// fmt.Printf("Step %d: Position = %.2f\n", step+1, current.Position)
	}
	return current
}

func main() {
	initial := State{Position: 0.0}
	params := map[string]float64{
		"mass":   2.0,
		"target": 10.0,
		"kP":     0.5,
		"kI":     0.1,
		"kD":     0.2,
		"dt":     0.1,
		"steps":  1000,
	}

	final := simulatePID(initial, params["target"], params["mass"],
		params["kP"], params["kI"], params["kD"], params["dt"], int(params["steps"]))
	fmt.Printf("Final position: %.2f\n", final.Position)
}
