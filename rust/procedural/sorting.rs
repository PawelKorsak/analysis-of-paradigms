use std::fs::{File, read_to_string};
use std::io::{BufRead, BufReader, BufWriter, Write};

#[derive(Debug, PartialEq)]
enum SortDataType { StringType, DoubleType }

// Read lines from a file (procedural)
fn read_file_lines(filename: &str) -> Vec<String> {
    let file = File::open(filename).unwrap();
    let reader = BufReader::new(file);
    let mut lines = Vec::new();
    for line in reader.lines() {
        lines.push(line.unwrap());
    }
    lines
}

// Write lines to a file (procedural)
fn write_file_lines(filename: &str, lines: &[String]) {
    let file = File::create(filename).unwrap();
    let mut writer = BufWriter::new(file);
    for line in lines {
        writeln!(writer, "{}", line).unwrap();
    }
}

// Check if all lines are doubles via parsing
fn determine_data_type(lines: &[String]) -> SortDataType {
    for line in lines {
        if line.parse::<f64>().is_err() {
            return SortDataType::StringType;
        }
    }
    SortDataType::DoubleType
}

// Quicksort with explicit loops and mutation
fn quicksort(lines: &[String]) -> Vec<String> {
    if lines.len() <= 1 {
        return lines.to_vec();
    }
    let pivot = lines[0].clone();
    let mut less = Vec::new();
    let mut greater = Vec::new();
    
    for line in lines.iter().skip(1) {
        if line <= &pivot {
            less.push(line.clone());
        } else {
            greater.push(line.clone());
        }
    }
    
    let mut sorted = quicksort(&less);
    sorted.push(pivot);
    sorted.extend(quicksort(&greater));
    sorted
}

fn main() {
    // Process strings dataset
    let lines_string = read_file_lines("datasets/random_char_strings.csv");
    let sorted_string = quicksort(&lines_string);
    write_file_lines("./sorted_lines_string.txt", &sorted_string);

    // Process doubles dataset
    let lines_double = read_file_lines("datasets/random_double_floats.csv");
    let sorted_double = quicksort(&lines_double);
    write_file_lines("./sorted_lines_double.txt", &sorted_double);
}