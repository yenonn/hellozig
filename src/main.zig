const std = @import("std");
const zap = @import("zap");

fn helloHandler(r: zap.Request) !void {
    // Set content type to JSON
    try r.setContentType(.JSON);

    // Send JSON response
    const json_response =
        \\{
        \\  "message": "Hello, World!",
        \\  "status": "success",
        \\  "timestamp": 1699430400
        \\}
    ;

    try r.sendJson(json_response);
}

pub fn main() !void {
    // Create a listener for the /hello endpoint
    var listener = zap.HttpListener.init(.{
        .port = 8080,
        .on_request = onRequest,
        .log = true,
    });

    try listener.listen();

    std.debug.print("HTTP server listening on http://127.0.0.1:8080\n", .{});
    std.debug.print("Try: curl http://127.0.0.1:8080/hello\n", .{});

    // Start the server
    zap.start(.{
        .threads = 3,
        .workers = 2,
    });
}

fn onRequest(r: zap.Request) !void {
    // Check if the path is /hello
    if (r.path) |path| {
        if (std.mem.eql(u8, path, "/hello")) {
            try helloHandler(r);
            return;
        }
    }

    // Return 404 for other paths
    r.setStatus(.not_found);
    try r.sendBody("404 Not Found");
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}
