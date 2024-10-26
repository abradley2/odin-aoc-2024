package lib

import "core:log"
import "core:os"

create_logger :: proc() -> (logger: log.Logger, err: os.Error) {
	os.remove("debug.txt")
	fh := os.open("debug.txt", os.O_RDWR + os.O_CREATE, os.S_IRWXU) or_return
	logger = log.create_file_logger(fh)
	return
}

destroy_logger :: proc(logger: log.Logger) {
	log.destroy_file_logger(logger)
}
