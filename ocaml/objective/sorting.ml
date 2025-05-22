type sort_data_type = StringType | DoubleType

class sorter (lines : string list) = object (self)
  val mutable data_type = DoubleType
  val mutable sorted_lines = []

  method determine_data_type =
    let rec check = function
      | [] -> data_type <- DoubleType
      | line :: rest ->
          try
            let _ = float_of_string line in
            check rest
          with Failure _ ->
            data_type <- StringType
    in
    check lines

  method sort =
    let rec quicksort = function
      | [] -> []
      | pivot :: rest ->
          let less = List.filter (fun x -> x <= pivot) rest in
          let greater = List.filter (fun x -> x > pivot) rest in
          quicksort less @ [pivot] @ quicksort greater
    in
    sorted_lines <- quicksort lines

  method write_to_file filename =
    let oc = open_out filename in
    List.iter (fun line -> Printf.fprintf oc "%s\n" line) sorted_lines;
    close_out oc
end

let read_file_lines filename =
  let ic = open_in filename in
  let rec read_lines acc =
    try read_lines (input_line ic :: acc) with End_of_file -> close_in ic; List.rev acc
  in
  read_lines []

let () =
  (* Process strings dataset *)
  let lines_string = read_file_lines "datasets/random_char_strings.csv" in
  let sorter_string = new sorter lines_string in
  sorter_string#determine_data_type;
  sorter_string#sort;
  sorter_string#write_to_file "./sorted_lines_string.txt";

  (* Process doubles dataset *)
  let lines_double = read_file_lines "datasets/random_double_floats.csv" in
  let sorter_double = new sorter lines_double in
  sorter_double#determine_data_type;
  sorter_double#sort;
  sorter_double#write_to_file "./sorted_lines_double.txt"