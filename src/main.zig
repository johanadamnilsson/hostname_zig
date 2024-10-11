const std = @import("std");
const sd = @cImport({
    @cInclude("systemd/sd-bus.h");
});

pub fn main() !void {
    std.debug.print("Starting\n", .{});

    var bus: ?*sd.sd_bus = null;
    if (0 > sd.sd_bus_open_system(&bus)) {
        std.debug.print("Unable to open dbus\n", .{});
    }

    var bus_error: sd.sd_bus_error = undefined;
    bus_error.name = null;
    bus_error.message = null;
    bus_error._need_free = 0;

    var hostname: [*c]u8 = null;
    if (0 > sd.sd_bus_get_property_string(bus, "org.freedesktop.hostname1", "/org/freedesktop/hostname1", "org.freedesktop.hostname1", "Hostname", &bus_error, &hostname)) {
        std.debug.print("Unable to get hostname: {s} \n", .{bus_error.message});
        return;
    }

    std.debug.print("Hostname {s}\n", .{hostname});
}
