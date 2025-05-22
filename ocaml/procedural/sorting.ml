
type sort_data_type = StringType | DoubleType


let read_file_lines filename =
  let ic = open_in filename in
  let rec read_lines acc =
    try
      let line = input_line ic in
      read_lines (line :: acc)
    with End_of_file ->
      close_in ic;
      List.rev acc
  in
  read_lines []

let write_file_lines filename lines =
  let oc = open_out filename in
  List.iter (fun line -> output_string oc (line ^ "\n")) lines;
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
      let less = List.filter (fun x -> x <= pivot) rest in
      let greater = List.filter (fun x -> x > pivot) rest in
      quicksort less @ [pivot] @ quicksort greater

let () =
  (* Przetwórz plik ze stringami *)
  let lines_string = read_file_lines "datasets/random_char_strings.csv" in
  let _ = determine_data_type lines_string in (* Typ jest ignorowany w sortowaniu *)
  let sorted_string = quicksort lines_string in
  write_file_lines "./sorted_lines_string.txt" sorted_string;

  (* Przetwórz plik z liczbami *)
  let lines_double = read_file_lines "datasets/random_double_floats.csv" in
  let _ = determine_data_type lines_double in
  let sorted_double = quicksort lines_double in
  write_file_lines "./sorted_lines_double.txt" sorted_double