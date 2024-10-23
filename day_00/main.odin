package day_02

import "../lib"
import "core:bytes"
import "core:fmt"
import "core:mem"
import "core:os"


main :: proc() {
	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	context.allocator = mem.tracking_allocator(&track)
	err := run()
	if err != nil {
		fmt.eprintf("Error: %v\n", err)
	}
	lib.mem_debug(&track)
}

Part_1_Err :: enum {
	None,
}

Part_2_Err :: enum {
	None,
}

Err :: union {
	os.Error,
	Part_1_Err,
	Part_2_Err,
}

run :: proc() -> (err: Err) {
	file_handle := os.open("day_00/input.txt", os.O_RDONLY) or_return

	defer os.close(file_handle)

	input_data, _ := os.read_entire_file_from_handle(file_handle)
	defer delete(input_data)

	part_1(input_data) or_return
	part_2(input_data) or_return
	return
}

part_1 :: proc(input: []u8) -> (err: Part_1_Err) {
	fmt.printf("Part 1: %s\n", "Not Implemented")
	return
}

part_2 :: proc(input: []u8) -> (err: Part_2_Err) {
	fmt.printf("Part 2: %s\n", "Not Implemented")
	return
}
