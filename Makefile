CFLAGS   := $(shell luvit-config --cflags)

all: build/date.luvit

build/date.luvit: src/date.c
	mkdir -p build
	gcc -shared -g $(CFLAGS) -o $@ $^

test: all
	checkit test/date.lua

.PHONY: all test
.SILENT:
