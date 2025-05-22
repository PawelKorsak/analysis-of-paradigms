const std = @import("std");
const fmt = std.fmt;
const fs = std.fs;
const heap = std.heap;
const SortDataType = enum { StringType, DoubleType };

pub fn main() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Process strings dataset
    const lines_string = try readFileLines(allocator, "datasets/random_char_strings.csv");
    _ = try determineDataType(lines_string);
    const sorted_string = try quicksort(allocator, lines_string);
    try writeFileLines("sorted_lines_string.txt", sorted_string);

    // Process doubles dataset
    const lines_double = try readFileLines(allocator, "datasets/random_double_floats.csv");
    _ = try determineDataType(lines_double);
    const sorted_double = try quicksort(allocator, lines_double);
    try writeFileLines("sorted_lines_double.txt", sorted_double);
}

// Read lines from a file
fn readFileLines(allocator: std.mem.Allocator, filename: []const u8) ![][]const u8 {
    const file = try fs.cwd().openFile(filename, .{});
    defer file.close();
    var reader = file.reader();
    var lines = std.ArrayList([]const u8).init(allocator);
    var buffer = std.ArrayList(u8).init(allocator);
    defer buffer.deinit();

    while (reader.streamUntilDelimiter(buffer.writer(), '\n', null)) {
        const line = try buffer.toOwnedSlice();
        try lines.append(line);
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }
    return lines.toOwnedSlice();
}

// Write lines to a file
fn writeFileLines(filename: []const u8, lines: [][]const u8) !void {
    const file = try fs.cwd().createFile(filename, .{});
    defer file.close();
    var writer = file.writer();
    for (lines) |line| {
        try writer.print("{s}\n", .{line});
    }
}

// Check if lines are doubles (simplified without regex)
fn determineDataType(lines: [][]const u8) !SortDataType {
    for (lines) |line| {
        _ = fmt.parseFloat(f64, line) catch return .StringType;
    }
    return .DoubleType;
}

// Procedural quicksort
fn quicksort(allocator: std.mem.Allocator, lines: [][]const u8) ![][]const u8 {
    if (lines.len <= 1) return lines;
    const pivot = lines[0];
    var less = std.ArrayList([]const u8).init(allocator);
    var greater = std.ArrayList([]const u8).init(allocator);

    for (lines[1..]) |line| {
        if (std.mem.order(u8, line, pivot) != .gt) {
            try less.append(line);
        } else {
            try greater.append(line);
        }
    }

    const sorted_less = try quicksort(allocator, less.items);
    const sorted_greater = try quicksort(allocator, greater.items);
    const result = try std.mem.concat(allocator, []const u8, &.{ sorted_less, &[_][]const u8{pivot}, sorted_greater });
    return result;
}
