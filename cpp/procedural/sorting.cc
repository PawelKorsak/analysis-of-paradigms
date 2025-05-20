#include "fileOperators.hh"
#include <algorithm>
#include <regex>
#include <string>
#include <vector>

enum class SortDataType { STRING, DOUBLE };

const std::regex isDoubleRegex(R"(^[+-]?(?:\d+\.?\d*|\.\d+)([eE][+-]?\d+)?$)");

SortDataType determineVectorType(const std::vector<std::string>& lines) {
  for (const auto& line : lines) {
    if (!std::regex_match(line, isDoubleRegex)) {
      return SortDataType::STRING;
    }
  }
  return SortDataType::DOUBLE;
}

// In-place quicksort for procedural version
void quicksort(std::vector<std::string>& vec, int low, int high) {
  if (low < high) {
    std::string pivot = vec[high];
    int i = low - 1;

    // Partitioning
    for (int j = low; j <= high - 1; j++) {
      if (vec[j] <= pivot) {
        i++;
        std::swap(vec[i], vec[j]);
      }
    }
    std::swap(vec[i + 1], vec[high]);
    int partition_index = i + 1;

    // Recursive calls
    quicksort(vec, low, partition_index - 1);
    quicksort(vec, partition_index + 1, high);
  }
}

int main() {
  // Process strings dataset
  std::vector<std::string> linesString = 
      readFileLines("datasets/random_char_strings.csv");
  quicksort(linesString, 0, linesString.size() - 1);
  writeFileLines("./sorted_lines_string.txt", linesString);

  // Process doubles dataset
  std::vector<std::string> linesDouble = 
      readFileLines("datasets/random_double_floats.csv");
  quicksort(linesDouble, 0, linesDouble.size() - 1);
  writeFileLines("./sorted_lines_double.txt", linesDouble);

  return EXIT_SUCCESS;
}