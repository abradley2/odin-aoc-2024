package day_02

import "core:fmt"
import "core:log"
import "core:strconv"
import "core:strings"
import "core:text/scanner"


parse_input :: proc(input: string) -> (parsed_input: Parsed_Input, success: bool) {
	success = true

	context.allocator = context.temp_allocator
	defer free_all(context.allocator)

	lines := strings.split(input, "\n")

	parsed_input.len = len(lines)
	if parsed_input.len > len(parsed_input.games) {
		log.errorf("Exceeded maximum number of games: %d", len(lines))
		success = false
		return
	}

	parse_err := new(string)
	for line, game_idx in lines {
		s: scanner.Scanner
		tokenizer := scanner.init(&s, line)
		game, err := parse_input_line(tokenizer)
		if err != nil {
			log.errorf("error: %v, at line: %d, column: %d", err, game_idx, tokenizer.column)
			success = false
			return
		}
		parsed_input.games[game_idx] = game
		parsed_input.len = game_idx + 1
	}

	return
}

parse_input_line :: proc(tokenizer: ^scanner.Scanner) -> (game: Game, err: Maybe(string)) {
	r := scanner.scan(tokenizer)

	if r == scanner.Ident && scanner.token_text(tokenizer) == "Game" {
		r = scanner.scan(tokenizer)
	} else {
		err = fmt.aprintf("Expected game identifier, found: %s", scanner.token_text(tokenizer))
		return
	}

	if r == scanner.Int {
		r = scanner.scan(tokenizer)
	} else {
		err = fmt.aprintf("expected game int, found: %s", scanner.token_text(tokenizer))
		return
	}

	if r == ':' && scanner.token_text(tokenizer) == ":" {
		r = scanner.scan(tokenizer)
	} else {
		err = fmt.aprintf("expected : delimiter, found: %s", scanner.token_text(tokenizer))
		return
	}

	round_idx: int
	loop_rounds: for {
		round: Round

		loop_draws: for {
			count: u8
			if r == scanner.Int {
				count = u8(strconv.atoi(scanner.token_text(tokenizer)))
				r = scanner.scan(tokenizer)
			} else {
				err = fmt.aprintf(
					"expected int for draw count, found: %s",
					scanner.token_text(tokenizer),
				)
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
				case:
					err = fmt.aprintf(
						"expected identifier for color, found: %s",
						scanner.token_text(tokenizer),
					)
					return
				}
				r = scanner.scan(tokenizer)
			} else {
				err = fmt.aprintf(
					"expected identifier for color, found: %s",
					scanner.token_text(tokenizer),
				)
				return
			}

			game.len = round_idx + 1
			game.rounds[round_idx] = round

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

			err = fmt.aprintf("expected delimiter, found: %s", scanner.token_text(tokenizer))
			return
		}

		round_idx = round_idx + 1
	}

	return
}
