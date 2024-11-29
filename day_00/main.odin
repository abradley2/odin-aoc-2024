package day_00

import "../lib"
import "core:fmt"
import "core:log"
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
	context.logger = lib.create_logger() or_return
	defer lib.destroy_logger(context.logger)

	tracking_allocator: ^mem.Tracking_Allocator
	context.allocator, tracking_allocator = lib.init_tracking_allocator()
	defer lib.check_leaks(tracking_allocator)

	input_data := #load("./input.txt")

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
