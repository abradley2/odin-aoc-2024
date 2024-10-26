package day_02

import "../lib"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:sys/unix"

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
	context.logger = lib.create_logger() or_return
	defer lib.destroy_logger(context.logger)
	context.allocator, tracking_allocator = lib.init_tracking_allocator()
	defer lib.check_leaks(tracking_allocator)

	file_handle := os.open("day_02/input.txt", os.O_RDONLY) or_return
	defer os.close(file_handle)

	input_data, _ := os.read_entire_file_from_handle(file_handle)
	input_str := string(input_data)
	defer delete(input_str)

	parsed_input, parse_success := parse_input(input_str)
	if !parse_success {
		return
	}

	part_1(parsed_input) or_return
	part_2(parsed_input) or_return
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
	rounds: [10]Round,
	len:    int,
}

Round :: struct {
	red_count:   u8,
	green_count: u8,
	blue_count:  u8,
}

part_1 :: proc(parsed_input: Parsed_Input) -> (err: Err) {
	total: int

	games := parsed_input.games
	for game, game_idx in games[0:parsed_input.len] {
		game_id := game_idx + 1
		rounds := game.rounds

		valid := true
		for round in rounds[0:game.len] {
			if round.red_count > 12 || round.green_count > 13 || round.blue_count > 14 {
				valid = false
			}
		}
		if valid {
			total = total + game_id
		}
	}

	fmt.printf("Part 1: %d\n", total)
	return
}

part_2 :: proc(parsed_input: Parsed_Input) -> (err: Err) {
	total_power: int

	games := parsed_input.games
	for game in games[0:parsed_input.len] {
		min_red: u8
		min_blue: u8
		min_green: u8
		rounds := game.rounds
		for round in rounds[0:game.len] {
			if min_red < round.red_count {
				min_red = round.red_count
			}
			if min_blue < round.blue_count {
				min_blue = round.blue_count
			}
			if min_green < round.green_count {
				min_green = round.green_count
			}
		}
		game_power := int(min_red) * int(min_blue) * int(min_green)
		total_power = total_power + game_power
	}

	fmt.printf("Part 2: %d\n", total_power)
	return
}
