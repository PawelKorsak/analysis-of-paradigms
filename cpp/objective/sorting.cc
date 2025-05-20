#include "fileOperators.hh"
#include <regex>
#include <string>
#include <vector>
#include <memory>

enum class SortDataType { STRING, DOUBLE };

const std::regex isDoubleRegex(R"(^[+-]?(?:\d+\.?\d*|\.\d+)([eE][+-]?\d+)?$)");

// Interface for sorting strategies
class Sorter {
public:
  virtual ~Sorter() = default;
  virtual void sort(std::vector<std::string>& data) = 0;
};

// Sort as strings (lexicographical comparison)
class StringSorter : public Sorter {
public:
  void sort(std::vector<std::string>& data) override {
    quicksort(data, 0, data.size() - 1);
  }

private:
  void quicksort(std::vector<std::string>& data, int low, int high) {
    if (low < high) {
      int pi = partition(data, low, high);
      quicksort(data, low, pi - 1);
      quicksort(data, pi + 1, high);
    }
  }

  int partition(std::vector<std::string>& data, int low, int high) {
    std::string pivot = data[high];
    int i = low - 1;
    for (int j = low; j <= high - 1; j++) {
      if (data[j] <= pivot) {
        std::swap(data[++i], data[j]);
      }
    }
    std::swap(data[i + 1], data[high]);
    return i + 1;
  }
};

// Sort as doubles (numeric comparison)
class DoubleSorter : public Sorter {
public:
  void sort(std::vector<std::string>& data) override {
    quicksort(data, 0, data.size() - 1);
  }

private:
  void quicksort(std::vector<std::string>& data, int low, int high) {
    if (low < high) {
      int pi = partition(data, low, high);
      quicksort(data, low, pi - 1);
      quicksort(data, pi + 1, high);
    }
  }

  int partition(std::vector<std::string>& data, int low, int high) {
    double pivot = std::stod(data[high]);
    int i = low - 1;
    for (int j = low; j <= high - 1; j++) {
      if (std::stod(data[j]) <= pivot) {
        std::swap(data[++i], data[j]);
      }
    }
    std::swap(data[i + 1], data[high]);
    return i + 1;
  }
};

class DataProcessor {
private:
  std::vector<std::string> lines;
  std::unique_ptr<Sorter> sorter;

  void determineType() {
    for (const auto& line : lines) {
      if (!std::regex_match(line, isDoubleRegex)) {
        sorter = std::make_unique<StringSorter>();
        return;
      }
    }
    sorter = std::make_unique<DoubleSorter>();
  }

public:
  DataProcessor(const std::string& filename) {
    lines = readFileLines(filename);
    determineType();
  }

  void sortData() { sorter->sort(lines); }

  void writeSortedData(const std::string& filename) {
    writeFileLines(filename, lines);
  }
};

int main() {
  DataProcessor stringProcessor("datasets/random_char_strings.csv");
  stringProcessor.sortData();
  stringProcessor.writeSortedData("./sorted_lines_string.txt");

  DataProcessor doubleProcessor("datasets/random_double_floats.csv");
  doubleProcessor.sortData();
  doubleProcessor.writeSortedData("./sorted_lines_double.txt");

  return EXIT_SUCCESS;
}