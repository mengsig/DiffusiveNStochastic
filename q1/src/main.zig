// Here i just import the standard library
const std = @import("std");
// Creating a random number generator
var prng = std.rand.DefaultPrng.init(44);
const randomGenerator = prng.random();

// Creating a function for gaussian noise that follows your requirements
// FYI: @sqrt and @log and @floatFromInt are inherent function calls in zig.
fn randomGaussian() f64 {
    var g1: f64 = 0;
    var g2: f64 = 0;
    var s: f64 = 0;
    while (s >= 1.0 or s == 0.0) {
        const k1: f64 = randomGenerator.float(f64);
        const k2: f64 = randomGenerator.float(f64);
        g1 = 2.0 * k1 - 1.0;
        g2 = 2.0 * k2 - 1.0;
        s = g1 * g1 + g2 * g2;
    }
    const tempvar: f64 = -2.0 * @log(s) / s;
    const scale = @sqrt(tempvar);
    return g1 * scale;
}

pub fn main() !void {
    // Defining the variables
    // Here, when I do not assign a type like f32, u32 i32... etc.
    // What is happening is that I am setting the type to type COMPTIME.
    // This means, that during compilation, it gets inlined and the memory is never stored!
    // This is a very cool feature of Zig (you can also do comptime for loops etc.)
    const dt = 0.01;
    const t_max = 50.0;
    const n_steps: usize = @intFromFloat(t_max / dt);
    const D = 0.2;
    const eta = 2.0;
    const n_trajectories = 500;

    // Using the standard library for the cwd sys call
    const fs = std.fs.cwd();

    // Define the path of the directory to be created
    const dir_name = "data";

    // Create the directory
    try fs.makeDir(dir_name);

    // Creating a 2D array of float16 - try f32, f64 for more accuracy.
    // For floats we can only do f16, f32, f64 because of syscalls. But, in Zig
    // with other types, you have FULL memory management - e.g. you can create
    // an array of u3 or array of u13 or whatever you want!
    var X: [n_trajectories][n_steps]f64 = undefined;
    // setting initial values to 1.0 (this is also done in comptime)
    for (0..n_trajectories) |i| {
        X[i][0] = 1.0;
    }

    // The main loop
    for (1..n_steps) |i| {
        for (0..n_trajectories) |j| {
            const dX = (-((X[j][i - 1] * X[j][i - 1] * X[j][i - 1]) - X[j][i - 1] + 1.0) / eta * dt) + std.math.sqrt(2.0 * D * dt) * randomGaussian();
            X[j][i] = X[j][i - 1] + dX;
        }
    }

    // Open the file for writing
    var file = try std.fs.cwd().createFile("data/file1.txt", .{});
    defer file.close();
    var writer = file.writer();

    // Create column labels
    for (0..n_trajectories) |i| {
        try writer.print("{},", .{i});
    }
    // Write results to the file
    try writer.print("\n", .{});
    for (0..n_steps) |i| {
        for (0..n_trajectories) |j| {
            try writer.print("{},", .{X[j][i]});
        }
        // Add a newline at the end of each row
        try writer.print("\n", .{});
    }
}
