const std = @import("std");
const zap = @import("zap");

fn getCurrentTimestamp(buffer: []u8) ![]const u8 {
    const timestamp = std.time.timestamp();
    const epoch_seconds = @as(u64, @intCast(timestamp));

    // Convert to human-readable format (ISO 8601)
    const epoch_day = std.time.epoch.EpochSeconds{ .secs = epoch_seconds };
    const day_seconds = epoch_day.getDaySeconds();
    const year_day = epoch_day.getEpochDay().calculateYearDay();
    const month_day = year_day.calculateMonthDay();

    return try std.fmt.bufPrint(buffer,
        "{d:0>4}-{d:0>2}-{d:0>2}T{d:0>2}:{d:0>2}:{d:0>2}Z",
        .{
            year_day.year,
            month_day.month.numeric(),
            month_day.day_index + 1,
            day_seconds.getHoursIntoDay(),
            day_seconds.getMinutesIntoHour(),
            day_seconds.getSecondsIntoMinute(),
        },
    );
}

pub fn helloHandler(r: zap.Request) !void {
    // Set content type to JSON
    try r.setContentType(.JSON);

    // Get current timestamp
    var timestamp_buffer: [64]u8 = undefined;
    const timestamp_str = try getCurrentTimestamp(&timestamp_buffer);

    var buffer: [256]u8 = undefined;
    const json_response = try std.fmt.bufPrint(&buffer,
        \\{{
        \\  "message": "Hello, World!",
        \\  "status": "success",
        \\  "timestamp": "{s}"
        \\}}
    , .{timestamp_str});

    try r.sendJson(json_response);
}