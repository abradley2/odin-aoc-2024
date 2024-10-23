package day_02

import "../lib"
import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:text/scanner"

Parse_Input_Err :: enum {
	None,
	Parse_Input_Err_Too_Many_Games,
	Parse_Input_Err_Invalid_Token,
}

parse_input :: proc(
	input: string,
) -> (
	parsed_input: Parsed_Input,
	pos: scanner.Position,
	err: Err,
) {
	context.allocator = context.temp_allocator
	defer free_all(context.allocator)

	lines := strings.split(input, "\n")

	parsed_input.len = len(lines)
	if parsed_input.len > len(parsed_input.games) {
		err = .Parse_Input_Err_Too_Many_Games
		return
	}

	parse_err := new(string)
	for line, game_idx in lines {
		s: scanner.Scanner
		tokenizer := scanner.init(&s, input)
		game: Game
		game, err = tokenize_input(line, parse_err, tokenizer)
		if err != .None {
			lib.logf("error: %v, at pos: %s", err, scanner.position_to_string(tokenizer.pos))
		}
	}

	return
}

tokenize_input :: proc(
	input: string,
	parse_err: ^string,
	tokenizer: ^scanner.Scanner,
) -> (
	game: Game,
	err: Parse_Input_Err,
) {
	r := scanner.scan(tokenizer)

	if r == scanner.Ident && scanner.token_text(tokenizer) == "Game" {
		r = scanner.scan(tokenizer)
	} else {
		err = .Parse_Input_Err_Invalid_Token
		return
	}

	if r == scanner.Int {
		r = scanner.scan(tokenizer)
	} else {
		err = .Parse_Input_Err_Invalid_Token
		return
	}

	if r == ':' && scanner.token_text(tokenizer) == ":" {
		r = scanner.scan(tokenizer)
	} else {
		err = .Parse_Input_Err_Invalid_Token
		return
	}

	loop_rounds: for {
		round: Round
		round_idx: int
		loop_draws: for {
			count: u8
			if r == scanner.Int {
				count = u8(strconv.atoi(scanner.token_text(tokenizer)))
				r = scanner.scan(tokenizer)
			} else {
				err = .Parse_Input_Err_Invalid_Token
				return
			}

			if r == scanner.Ident {
				switch scanner.token_text(tokenizer) {
				case "blue":
					round.blue_count = round.blue_count + count
				case "red":
					round.red_count = round.red_count + count
				case "green":
					round.green_count = round.green_count + count
				}
				r = scanner.scan(tokenizer)
			} else {
				err = .Parse_Input_Err_Invalid_Token
				return
			}

			if r == ',' {
				r = scanner.scan(tokenizer)
				continue loop_draws
			}

			if r == ';' {
				r = scanner.scan(tokenizer)
				break loop_draws
			}

			if r == scanner.EOF {
				break loop_rounds
			}

			err = .Parse_Input_Err_Invalid_Token
			return
		}

		game.rounds[round_idx] = round
		round_idx = round_idx + 1

		break
	}


	r = scanner.scan(tokenizer)
	return
}
