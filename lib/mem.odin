package lib

import "core:fmt"
import "core:log"
import "core:mem"
import "core:mem/virtual"
import "core:os"

fba :: proc(
	buffer: []u8,
	arena: ^virtual.Arena,
) -> (
	allocator: mem.Allocator,
	err: virtual.Allocator_Error,
) {
	virtual.arena_init_buffer(arena, buffer) or_return
	allocator = virtual.arena_allocator(arena)
	return
}

init_tracking_allocator :: proc(
) -> (
	allocator: mem.Allocator,
	tracking_allocator: ^mem.Tracking_Allocator,
) {
	tracking_allocator = new(mem.Tracking_Allocator)
	mem.tracking_allocator_init(tracking_allocator, context.allocator)
	allocator = mem.tracking_allocator(tracking_allocator)
	return
}

check_leaks :: proc(tracking_allocator: ^mem.Tracking_Allocator) {
	if len(tracking_allocator.allocation_map) > 0 {
		for _, entry in tracking_allocator.allocation_map {
			missing_free_loc := fmt.aprintfln(
				"leaked - %v bytes @ %v\n",
				entry.size,
				entry.location,
			)
			defer delete(missing_free_loc)
			log.error(missing_free_loc)
		}
	}
	if len(tracking_allocator.bad_free_array) > 0 {
		for entry in tracking_allocator.bad_free_array {
			bad_free_loc := fmt.aprintfln("double free - %p @ %v\n", entry.memory, entry.location)
			defer delete(bad_free_loc)
			log.error(bad_free_loc)
		}
	}
	mem.tracking_allocator_destroy(tracking_allocator)
}
