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

// Sorter struct encapsulates data and methods
type Sorter struct {
	lines    []string
	dataType SortDataType
}

// Constructor
func NewSorter(lines []string) *Sorter {
	return &Sorter{lines: lines}
}

// Method to determine data type
func (s *Sorter) DetermineDataType() {
	for _, line := range s.lines {
		if !isDoubleRegex.MatchString(line) {
			s.dataType = StringType
			return
		}
	}
	s.dataType = DoubleType
}

// Method to sort lines
func (s *Sorter) Sort() {
	s.lines = quicksort(s.lines)
}

// Internal quicksort
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

	return append(append(quicksort(less), pivot), quicksort(greater)...)
}

// Method to write sorted data to file
func (s *Sorter) WriteToFile(filename string) error {
	file, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer file.Close()

	writer := bufio.NewWriter(file)
	for _, line := range s.lines {
		_, err := writer.WriteString(line + "\n")
		if err != nil {
			return err
		}
	}
	return writer.Flush()
}

func main() {
	// Process strings dataset
	linesString, err := readFileLines("datasets/random_char_strings.csv")
	if err != nil {
		fmt.Println("Error reading strings file:", err)
		return
	}

	sorterString := NewSorter(linesString)
	sorterString.DetermineDataType()
	sorterString.Sort()
	sorterString.WriteToFile("./sorted_lines_string.txt")

	// Process doubles dataset
	linesDouble, err := readFileLines("datasets/random_double_floats.csv")
	if err != nil {
		fmt.Println("Error reading doubles file:", err)
		return
	}

	sorterDouble := NewSorter(linesDouble)
	sorterDouble.DetermineDataType()
	sorterDouble.Sort()
	sorterDouble.WriteToFile("./sorted_lines_double.txt")
}

// Helper: Read lines from file (reused from procedural)
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
