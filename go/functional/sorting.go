package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
)

type SortDataType int

const (
	StringType SortDataType = iota
	DoubleType
)

var isDoubleRegex = regexp.MustCompile(`^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$`)

// Pure function to read lines
func readFileLines(filename string) ([]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	return scannerToSlice(scanner), scanner.Err()
}

// Helper: Convert scanner to slice (functional style)
func scannerToSlice(scanner *bufio.Scanner) []string {
	var lines []string
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines
}

// Pure function to write lines
func writeFileLines(filename string, lines []string) error {
	file, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer file.Close()

	writer := bufio.NewWriter(file)
	for _, line := range lines {
		_, err := writer.WriteString(line + "\n")
		if err != nil {
			return err
		}
	}
	return writer.Flush()
}

// Predicate to check if a line is a double
func isDouble(line string) bool {
	return isDoubleRegex.MatchString(line)
}

// Recursive quicksort with functional composition
func quicksort(lines []string) []string {
	if len(lines) <= 1 {
		return lines
	}

	pivot := lines[0]
	less, greater := partition(lines[1:], pivot)

	return append(append(quicksort(less), pivot), quicksort(greater)...)
}

// Partition using anonymous function
func partition(lines []string, pivot string) ([]string, []string) {
	return filter(lines, func(line string) bool { return line <= pivot }),
		filter(lines, func(line string) bool { return line > pivot })
}

// Generic filter function
func filter(lines []string, test func(string) bool) []string {
	var result []string
	for _, line := range lines {
		if test(line) {
			result = append(result, line)
		}
	}
	return result
}

func main() {
	// Process datasets using function chaining
	processDataset := func(filename string, output string) {
		lines, err := readFileLines(filename)
		if err != nil {
			fmt.Println("Error reading file:", err)
			return
		}

		if err := writeFileLines(output, quicksort(lines)); err != nil {
			fmt.Println("Error writing file:", err)
		}
	}

	processDataset("datasets/random_char_strings.csv", "./sorted_lines_string.txt")
	processDataset("datasets/random_double_floats.csv", "./sorted_lines_double.txt")
}
