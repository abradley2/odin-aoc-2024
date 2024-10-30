package day_03

import "../lib"
import "core:bytes"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:strings"


main :: proc() {
	err := run()
	if err != nil {
		fmt.eprintf("Error: %v\n", err)
	}
}

Err :: union #shared_nil {
	os.Error,
	mem.Allocator_Error,
}

run :: proc() -> (err: Err) {
	tracking_allocator: ^mem.Tracking_Allocator
	context.logger = lib.create_logger() or_return
	defer lib.destroy_logger(context.logger)
	context.allocator, tracking_allocator = lib.init_tracking_allocator()
	defer lib.check_leaks(tracking_allocator)

	file_handle := os.open("day_03/input.txt", os.O_RDONLY) or_return

	defer os.close(file_handle)

	input_data := os.read_entire_file_from_handle_or_err(file_handle) or_return
	input_data_str := string(input_data)
	defer delete(input_data_str)

	parse_input_err: Maybe(string)

	builder := strings.builder_make_none() or_return
	parse_input(input_data_str)
	res := strings.to_string(builder)
	fmt.println(res)

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
