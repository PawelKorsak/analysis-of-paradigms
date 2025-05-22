type sort_data_type = StringType | DoubleType


let read_file_lines filename =
  let ic = open_in filename in
  let rec read_lines acc =
    try read_lines (input_line ic :: acc) with End_of_file -> close_in ic; List.rev acc
  in
  read_lines []

let write_file_lines filename lines =
  let oc = open_out filename in
  List.iter (fun line -> Printf.fprintf oc "%s\n" line) lines;
  close_out oc

  let is_double line =
    try
      let _ = float_of_string line in true
    with Failure _ -> false
  
  let determine_data_type lines =
    List.fold_left (fun acc line ->
      if acc = StringType then StringType
      else if is_double line then DoubleType
      else StringType
    ) DoubleType lines
  

let rec quicksort = function
  | [] -> []
  | pivot :: rest ->
      let less, greater = List.partition (fun x -> x <= pivot) rest in
      quicksort less @ [pivot] @ quicksort greater

let process_dataset input output =
  let lines = read_file_lines input in
  let _ = determine_data_type lines in
  let sorted = quicksort lines in
  write_file_lines output sorted

let () =
  process_dataset "datasets/random_char_strings.csv" "./sorted_lines_string.txt";
  process_dataset "datasets/random_double_floats.csv" "./sorted_lines_double.txt"