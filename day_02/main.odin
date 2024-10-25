package day_02

import "../lib"
import "core:fmt"
import "core:mem"
import "core:os"

main :: proc() {
	err := run()
	if err != nil {
		fmt.eprintf("Error: %v\n", err)
	}
}

Err :: union {
	os.Error,
}

run :: proc() -> (err: Err) {
	tracking_allocator: ^mem.Tracking_Allocator
	context.allocator, tracking_allocator = lib.init_tracking_allocator()
	defer lib.check_leaks(tracking_allocator)

	file_handle := os.open("day_02/input.txt", os.O_RDONLY) or_return

	defer os.close(file_handle)

	input_data, _ := os.read_entire_file_from_handle(file_handle)
	input_str := string(input_data)
	defer delete(input_str)

	parsed_input, parse_input_success := parse_input(input_str)

	part_1(parsed_input) or_return
	part_2(input_str) or_return
	return
}

Cube_Color :: enum {
	Red   = 1,
	Green = 2,
	Blue  = 3,
}

Parsed_Input :: struct {
	games: [100]Game,
	len:   int,
}

Game :: struct {
	rounds: [5]Round,
	len:    int,
}

Round :: struct {
	red_count:   u8,
	green_count: u8,
	blue_count:  u8,
}

part_1 :: proc(parsed_input: Parsed_Input) -> (err: Err) {
	fmt.printf("Part 1: %s\n", "Not Implemented")
	return
}

part_2 :: proc(input: string) -> (err: Err) {
	fmt.printf("Part 2: %s\n", "Not Implemented")
	return
}
