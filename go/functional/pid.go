package main

import "fmt"

type State struct {
	Position  float64
	Velocity  float64
	Integral  float64
	PrevError float64
}

func simulatePID(current State, target, mass, kP, kI, kD, dt float64, step, totalSteps int) State {
	if step >= totalSteps {
		return current
	}

	error := target - current.Position
	derivative := (error - current.PrevError) / dt
	force := kP*error + kI*current.Integral + kD*derivative

	acceleration := force / mass
	newVelocity := current.Velocity + acceleration*dt
	newPosition := current.Position + newVelocity*dt
	newIntegral := current.Integral + error*dt

	next := State{
		Position:  newPosition,
		Velocity:  newVelocity,
		Integral:  newIntegral,
		PrevError: error,
	}

	// fmt.Printf("Step %d: Position = %.2f\n", step+1, next.Position)
	return simulatePID(next, target, mass, kP, kI, kD, dt, step+1, totalSteps)
}

func main() {
	initial := State{Position: 0.0}
	final := simulatePID(initial, 10.0, 2.0, 0.5, 0.1, 0.2, 0.1, 0, 1000)
	fmt.Printf("Final position: %.2f\n", final.Position)
}
