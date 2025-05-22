use std::fs::File;
use std::io::{BufRead, BufReader, BufWriter, Write};

#[derive(Debug, PartialEq)]
enum SortDataType { StringType, DoubleType }

// Read lines from a file (functional style)
fn read_file_lines(filename: &str) -> Vec<String> {
    BufReader::new(File::open(filename).unwrap())
        .lines()
        .map(|l| l.unwrap())
        .collect()
}

// Write lines to a file (functional style)
fn write_file_lines(filename: &str, lines: &[String]) {
    BufWriter::new(File::create(filename).unwrap())
        .write_all(lines.join("\n").as_bytes())
        .unwrap();
}

// Check if all lines are doubles using parse::<f64>()
fn determine_data_type(lines: &[String]) -> SortDataType {
    if lines.iter().all(|line| line.parse::<f64>().is_ok()) {
        SortDataType::DoubleType
    } else {
        SortDataType::StringType
    }
}

// Quicksort with iterators and recursion
fn quicksort(lines: &[String]) -> Vec<String> {
    match lines {
        [] | [_] => lines.to_vec(),
        [pivot, rest @ ..] => {
            let (less, greater): (Vec<String>, Vec<String>) = rest.iter()
                .cloned()
                .partition(|line| line <= pivot);
            [quicksort(&less), vec![pivot.clone()], quicksort(&greater)].concat()
        }
    }
}

fn main() {
    // Process datasets
    let process_dataset = |input: &str, output: &str| {
        let lines = read_file_lines(input);
        let sorted = quicksort(&lines);
        write_file_lines(output, &sorted);
    };

    process_dataset("datasets/random_char_strings.csv", "./sorted_lines_string.txt");
    process_dataset("datasets/random_double_floats.csv", "./sorted_lines_double.txt");
}