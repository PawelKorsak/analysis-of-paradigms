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

// Read lines from a file
func readFileLines(filename string) ([]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}

// Write lines to a file
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

// Determine if all lines are numeric (double)
func determineDataType(lines []string) SortDataType {
	for _, line := range lines {
		if !isDoubleRegex.MatchString(line) {
			return StringType
		}
	}
	return DoubleType
}

// Quicksort implementation (lexicographical order)
func quicksort(lines []string) []string {
	if len(lines) <= 1 {
		return lines
	}

	pivot := lines[0]
	var less, greater []string

	for _, line := range lines[1:] {
		if line <= pivot {
			less = append(less, line)
		} else {
			greater = append(greater, line)
		}
	}

	// Recurse and concatenate
	return append(append(quicksort(less), pivot), quicksort(greater)...)
}

func main() {
	// Process strings dataset
	linesString, err := readFileLines("datasets/random_char_strings.csv")
	if err != nil {
		fmt.Println("Error reading strings file:", err)
		return
	}

	determineDataType(linesString)
	sortedLinesString := quicksort(linesString)

	if err := writeFileLines("./sorted_lines_string.txt", sortedLinesString); err != nil {
		fmt.Println("Error writing strings file:", err)
	}

	// Process doubles dataset
	linesDouble, err := readFileLines("datasets/random_double_floats.csv")
	if err != nil {
		fmt.Println("Error reading doubles file:", err)
		return
	}

	determineDataType(linesDouble)
	sortedLinesDouble := quicksort(linesDouble)

	if err := writeFileLines("./sorted_lines_double.txt", sortedLinesDouble); err != nil {
		fmt.Println("Error writing doubles file:", err)
	}
}
