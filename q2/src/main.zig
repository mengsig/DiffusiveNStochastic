const std = @import("std");
var prng = std.rand.DefaultPrng.init(44);
const randomGenerator = prng.random();

pub fn main() !void {
    // Defining Parameters
    // Get the current filesystem object
    const fs = std.fs.cwd();

    // Define the path of the directory to be created
    const dir_name = "data";

    // Create the directory
    try fs.makeDir(dir_name);

    const alpha: f32 = 2.5;
    const epsilon: f32 = 0.01;
    const gamma: f32 = 1.0;
    const Omega: f32 = 100.0;
    const initial_infected: f32 = 1.0;
    const max_time: f32 = 100.0;
    const sim_number: u32 = 100;

    // Defining my allocator for filewriting (name)
    const allocator = std.heap.page_allocator;

    // writing to the file
    // Yes... I do realize now that we do not need many simulations... but,
    // I coded it like this first, and thought I might as well keep it!
    for (0..sim_number) |i| {
        const filename = try std.fmt.allocPrint(allocator, "data/file_{}.txt", .{i});
        var file = try fs.createFile(filename, .{});
        defer file.close();
        var writer = file.writer();
        try writer.print("t,N\n", .{});

        // Reset these values to one and zero respectively
        var N: f32 = initial_infected;
        var t: f32 = 0.0;

        while (t < max_time) {
            const rate_infection = alpha * N / Omega * (Omega - N) + epsilon * (Omega - N);
            const rate_recovery = gamma * N;
            const total_rate = rate_infection + rate_recovery;

            if (total_rate == 0.0) break;

            // Time until next event
            const r1 = randomGenerator.float(f32);
            const delta_t = -@log(r1) / total_rate;
            t += delta_t;

            // Determine which event happens
            const r2 = randomGenerator.float(f32);
            if (r2 < rate_infection / total_rate) {
                N += 1; // Infection event
            } else {
                N -= 1; // Recovery event
            }

            try writer.print("{},{}\n", .{ t, N });
        }
    }
}
