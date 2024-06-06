const std = @import("std");
var prng = std.rand.DefaultPrng.init(44);
const randomGenerator = prng.random();

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
    const dt = 0.01;
    const t_max = 50.0;
    const n_steps: usize = @intFromFloat(t_max / dt);
    const D = 0.2;
    const eta = 2.0;
    const n_trajectories = 500;
    const fs = std.fs.cwd();

    // Define the path of the directory to be created
    const dir_name = "data";

    // Create the directory
    try fs.makeDir(dir_name);

    var X: [n_trajectories][n_steps]f64 = undefined;
    for (0..n_trajectories) |i| {
        X[i][0] = 1.0;
    }

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

    // Write results to the file
    for (0..n_trajectories) |i| {
        try writer.print("{},", .{i});
    }
    try writer.print("\n", .{});
    for (0..n_steps) |i| {
        for (0..n_trajectories) |j| {
            try writer.print("{},", .{X[j][i]});
        }
        // Add a newline at the end of each row
        try writer.print("\n", .{});
    }
}
