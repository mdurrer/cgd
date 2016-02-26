#!/bin/sh
suffix=asm
for arg in $@
	do
		echo `wine dasm.exe $arg -f3 -o${arg%.*}.bin`
	done
