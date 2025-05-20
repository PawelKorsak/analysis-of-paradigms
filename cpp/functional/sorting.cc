
#include "fileOperators.hh"
#include <algorithm>
#include <regex>
#include <string>
#include <vector>

enum class SortDataType { STRING, DOUBLE };

const std::regex isDoubleRegex(R"(^[+-]?(?:\d+\.?\d*|\.\d+)([eE][+-]?\d+)?$)");

const SortDataType determineVectorType(const std::vector<std::string> &lines,
                                       size_t index = 0) {
  if (index >= lines.size()) {
    return SortDataType::DOUBLE;
  }

  if (!std::regex_match(lines[index], isDoubleRegex)) {
    return SortDataType::STRING;
  }

  return determineVectorType(lines, index + 1); // Recurse
}

std::vector<std::string> quicksort(const std::vector<std::string> &input) {
  if (input.size() <= 1) {
    return input; // Base case: already sorted
  }

  const std::string &pivot = input[0]; // Choose first element as pivot

  // Partition the rest into less and greater vectors
  std::vector<std::string> less;
  std::vector<std::string> greater;

  for (size_t i = 1; i < input.size(); ++i) {
    if (input[i] <= pivot) {
      less.push_back(input[i]);
    } else {
      greater.push_back(input[i]);
    }
  }

  // Recurse and concatenate results: quicksort(less) + pivot +
  // quicksort(greater)
  std::vector<std::string> result;
  std::vector<std::string> sortedLess = quicksort(less);
  std::vector<std::string> sortedGreater = quicksort(greater);

  result.reserve(sortedLess.size() + 1 + sortedGreater.size());
  result.insert(result.end(), sortedLess.begin(), sortedLess.end());
  result.push_back(pivot);
  result.insert(result.end(), sortedGreater.begin(), sortedGreater.end());

  return result;
}

int main() {
  const std::vector<std::string> linesString =
      readFileLines("datasets/random_char_strings.csv");
  const SortDataType dataTypeString = determineVectorType(linesString);
  std::vector<std::string> sortedLinesString;
  switch (dataTypeString) {
  case SortDataType::STRING:
    sortedLinesString = quicksort(std::move(linesString));
    break;
  case SortDataType::DOUBLE:
    sortedLinesString = quicksort(std::move(linesString));
    break;
  }
  writeFileLines("./sorted_lines_string.txt", sortedLinesString);

  const std::vector<std::string> linesDouble =
      readFileLines("datasets/random_double_floats.csv");
  const SortDataType dataTypeDouble = determineVectorType(linesDouble);
  std::vector<std::string> sortedLinesDouble;
  switch (dataTypeDouble) {
  case SortDataType::STRING:
    sortedLinesDouble = quicksort(std::move(linesDouble));
    break;
  case SortDataType::DOUBLE:
    sortedLinesDouble = quicksort(std::move(linesDouble));
    break;
  }
  writeFileLines("./sorted_lines_double.txt", std::move(sortedLinesDouble));
  return EXIT_SUCCESS;
}