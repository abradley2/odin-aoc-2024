package day_02

import "../lib"
import "core:bytes"
import "core:fmt"
import "core:mem"
import "core:os"


main :: proc() {
	err := run()
	if err != nil {
		fmt.eprintf("Error: %v\n", err)
	}
}

Err :: union #shared_nil {
	os.Error,
}

run :: proc() -> (err: Err) {
	tracking_allocator: ^mem.Tracking_Allocator
	context.allocator, tracking_allocator = lib.init_tracking_allocator()
	defer lib.check_leaks(tracking_allocator)

	file_handle := os.open("day_00/input.txt", os.O_RDONLY) or_return

	defer os.close(file_handle)

	input_data := os.read_entire_file_from_handle_or_err(file_handle) or_return
	defer delete(input_data)

	part_1(input_data) or_return
	part_2(input_data) or_return
	return
}

part_1 :: proc(input: []u8) -> (err: Err) {
	fmt.printf("Part 1: %s\n", "Not Implemented")
	return
}

part_2 :: proc(input: []u8) -> (err: Err) {
	fmt.printf("Part 2: %s\n", "Not Implemented")
	return
}
