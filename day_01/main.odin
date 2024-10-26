package day_01

import "../lib"
import "core:bytes"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:slice"

main :: proc() {
	err := run()
	if err != nil {
		fmt.println(err)
	}
}

Err :: union {
	os.Error,
}

run :: proc() -> (err: Err) {
	tracking_allocator: ^mem.Tracking_Allocator
	context.logger = lib.create_logger() or_return
	defer lib.destroy_logger(context.logger)
	context.allocator, tracking_allocator = lib.init_tracking_allocator()
	defer lib.check_leaks(tracking_allocator)

	file_handle := os.open("day_01/input.txt", os.O_RDONLY) or_return

	defer os.close(file_handle)

	input_data, _ := os.read_entire_file_from_handle(file_handle)
	defer delete(input_data)

	part_1(input_data)
	part_2(input_data)
	return
}

part_1 :: proc(input: []u8) {
	allocator := context.temp_allocator
	defer free_all(allocator)

	lines := bytes.split(input, []byte{'\n'}, allocator)

	total: i64
	for line in lines {
		first_val, second_val := check_line(line)
		retval := (first_val.? * 10) + second_val.?
		total = total + i64(retval)
	}

	fmt.printf("Part 1: %d\n", total)
}

part_2 :: proc(input: []u8) {
	allocator := context.temp_allocator
	defer free_all(allocator)

	lines := bytes.split(input, []byte{'\n'}, allocator)

	total: i64
	for line in lines {
		first_val, second_val := check_line(line, true)
		retval := (first_val.? * 10) + second_val.?
		total = total + i64(retval)
	}

	fmt.printf("Part 2: %d\n", total)
}

check_line :: proc(line: []byte, include_words: bool = false) -> (Maybe(u8), Maybe(u8)) {
	first_number: Maybe(u8)
	first_number_ptr := &first_number

	last_number: Maybe(u8)
	last_number_ptr := &last_number

	left_idx := 0
	right_idx := len(line)

	for {
		number_ptr: ^Maybe(u8)

		if first_val, ok := first_number_ptr^.?; ok {
			number_ptr = last_number_ptr
		} else {
			number_ptr = first_number_ptr
		}

		search_slice := line[left_idx:right_idx]
		if slice.has_prefix(search_slice, []u8{'1'}) {
			number_ptr^ = 1
		} else if slice.has_prefix(search_slice, []u8{'2'}) {
			number_ptr^ = 2
		} else if slice.has_prefix(search_slice, []u8{'3'}) {
			number_ptr^ = 3
		} else if slice.has_prefix(search_slice, []u8{'4'}) {
			number_ptr^ = 4
		} else if slice.has_prefix(search_slice, []u8{'5'}) {
			number_ptr^ = 5
		} else if slice.has_prefix(search_slice, []u8{'6'}) {
			number_ptr^ = 6
		} else if slice.has_prefix(search_slice, []u8{'7'}) {
			number_ptr^ = 7
		} else if slice.has_prefix(search_slice, []u8{'8'}) {
			number_ptr^ = 8
		} else if slice.has_prefix(search_slice, []u8{'9'}) {
			number_ptr^ = 9
		} else if include_words && slice.has_prefix(search_slice, []u8{'o', 'n', 'e'}) {
			number_ptr^ = 1
		} else if include_words && slice.has_prefix(search_slice, []u8{'t', 'w', 'o'}) {
			number_ptr^ = 2
		} else if include_words && slice.has_prefix(search_slice, []u8{'t', 'h', 'r', 'e', 'e'}) {
			number_ptr^ = 3
		} else if include_words && slice.has_prefix(search_slice, []u8{'f', 'o', 'u', 'r'}) {
			number_ptr^ = 4
		} else if include_words && slice.has_prefix(search_slice, []u8{'f', 'i', 'v', 'e'}) {
			number_ptr^ = 5
		} else if include_words && slice.has_prefix(search_slice, []u8{'s', 'i', 'x'}) {
			number_ptr^ = 6
		} else if include_words && slice.has_prefix(search_slice, []u8{'s', 'e', 'v', 'e', 'n'}) {
			number_ptr^ = 7
		} else if include_words && slice.has_prefix(search_slice, []u8{'e', 'i', 'g', 'h', 't'}) {
			number_ptr^ = 8
		} else if include_words && slice.has_prefix(search_slice, []u8{'n', 'i', 'n', 'e'}) {
			number_ptr^ = 9
		}
		left_idx += 1
		if left_idx == right_idx {
			break
		}
	}

	if last_number_ptr^ == nil {
		return first_number_ptr^, first_number_ptr^
	}

	return first_number_ptr^, last_number_ptr^
}
