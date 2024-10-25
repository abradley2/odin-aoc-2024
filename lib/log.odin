package lib

import "core:fmt"
import "core:mem/virtual"
import "core:os"

log_file :: "debug.txt"

log_fh: Maybe(os.Handle)

_init_log :: proc() -> (err: os.Error) {
	os.remove(log_file)
	if log_fh != nil {
		return
	}

	log_fh = os.open(log_file, os.O_RDWR + os.O_CREATE, 777) or_return
	return
}

_close_log :: proc() -> (err: os.Error) {
	if fh, ok := log_fh.?; ok {
		err = os.close(fh)
		return
	}
	return
}

log :: proc(str: string) {
	if log_fh == nil {
		_init_log()
	}
	if fh, ok := log_fh.?; ok {
		os.write_string(fh, str)
	}
}

logf :: proc(str: string, args: ..any) {
	arena: virtual.Arena
	buffer: [256]byte
	alloc, _ := fba(buffer[:], &arena)

	log_str := fmt.aprintfln(str, ..args, allocator = alloc)
	log(log_str)
}
