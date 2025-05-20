#include <iostream>
#include <fstream>
#include <string>
#include <vector>

inline std::vector<std::string> readFileLines(const std::string& filePath) {
    std::vector<std::string> lines;
    std::ifstream file(filePath);

    if (!file) {
        throw std::runtime_error("Could not open file: " + filePath);
        return lines; // Return empty vector if file can't be opened
    }

    std::string line;
    while (std::getline(file, line)) {
        lines.push_back(line);
    }

    file.close();
    return lines;
}


inline void writeFileLines(const std::string& filePath, const std::vector<std::string>& lines) {
    std::ofstream file(filePath);

    if (!file) {
        throw std::runtime_error("Could not open file: " + filePath);
    }

    for (const auto& line : lines) {
        file << line << '\n';
    }

    file.close();
}