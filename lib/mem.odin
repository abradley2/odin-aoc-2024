package lib

import "core:fmt"
import "core:mem"
import "core:mem/virtual"
import "core:os"

tracking_allocator: ^mem.Tracking_Allocator

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

init_allocator :: proc() -> (allocator: mem.Allocator, err: os.Error) {
	_init_log() or_return
	tracking_allocator = new(mem.Tracking_Allocator)
	mem.tracking_allocator_init(tracking_allocator, context.allocator)
	allocator = mem.tracking_allocator(tracking_allocator)
	return
}

deinit_allocator :: proc() {
	if len(tracking_allocator.allocation_map) > 0 {
		for _, entry in tracking_allocator.allocation_map {
			missing_free_loc := fmt.aprintfln("- %v bytes @ %v\n", entry.size, entry.location)
			defer delete(missing_free_loc)
			log(missing_free_loc)
		}
	}
	if len(tracking_allocator.bad_free_array) > 0 {
		for entry in tracking_allocator.bad_free_array {
			bad_free_loc := fmt.aprintfln("- %p @ %v\n", entry.memory, entry.location)
			defer delete(bad_free_loc)
			log(bad_free_loc)
		}
	}
	mem.tracking_allocator_destroy(tracking_allocator)
	_close_log()
}
