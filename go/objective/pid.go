package main

import "fmt"

type State struct {
	Position  float64
	Velocity  float64
	Integral  float64
	PrevError float64
}

type PIDController struct {
	State      // Embedded struct (fields promoted to PIDController)
	Target     float64
	Mass       float64
	KP, KI, KD float64
	Dt         float64
}

func NewPIDController(initial State, target, mass, kP, kI, kD, dt float64) *PIDController {
	return &PIDController{
		State:  initial, // Initialize embedded State
		Target: target,
		Mass:   mass,
		KP:     kP,
		KI:     kI,
		KD:     kD,
		Dt:     dt,
	}
}

func (c *PIDController) Step() {
	error := c.Target - c.Position // Now works (c.Position promoted)
	derivative := (error - c.PrevError) / c.Dt
	force := c.KP*error + c.KI*c.Integral + c.KD*derivative

	acceleration := force / c.Mass
	c.Velocity += acceleration * c.Dt
	c.Position += c.Velocity * c.Dt
	c.Integral += error * c.Dt
	c.PrevError = error
}

func main() {
	controller := NewPIDController(
		State{Position: 0.0},
		10.0,          // Target
		2.0,           // Mass
		0.5, 0.1, 0.2, // PID gains
		0.1, // dt
	)

	for step := 0; step < 1000; step++ {
		controller.Step()
	}
	fmt.Printf("Final position: %.2f\n", controller.Position)
}
