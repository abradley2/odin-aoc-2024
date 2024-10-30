package day_03

import "core:fmt"
import "core:mem"
import "core:strings"
import "core:text/scanner"

Parse_Input_Err :: struct {
	err: string,
	col: int,
	row: int,
}

Symbol :: struct {
	char: rune,
	col:  u8,
	row:  u8,
}

Value :: struct {
	val: u32,
	len: u8,
	col: u8,
	row: u8,
}

Parsed_Input_Unit :: union {
	Symbol,
	Value,
}

Parsed_Input_Line :: struct {
	len:   int,
	units: [140]Parsed_Input_Unit,
}

Parsed_Input :: struct {
	len:   int,
	lines: [140]Parsed_Input_Line,
}

parse_input :: proc(input: string) -> (success: bool) {
	success = true

	context.allocator = context.temp_allocator
	defer free_all(context.allocator)

	lines := strings.split(input, "\n")
	for line in lines {
		s: scanner.Scanner
		tokenizer := scanner.init(&s, line)
		parsed_input_line := parse_input_line(tokenizer) or_return
	}

	return
}

parse_input_line :: proc(
	tokenizer: ^scanner.Scanner,
) -> (
	parsed_input_line: Parsed_Input_Line,
	success: bool,
) {
	success = true

	r: rune

	loop_line: for {
		r = scanner.scan(tokenizer)
		if r == scanner.EOF {
			break loop_line
		}

		fmt.printf("token = %s", scanner.token_text(tokenizer))
		fmt.printf(" | token type = %v\n", scanner.token_string(r, context.allocator))
	}


	return

}
