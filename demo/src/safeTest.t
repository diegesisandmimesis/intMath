#charset "us-ascii"
//
// safeTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Noninteractive test of the toIntegerSafe() function.
//
// It can be compiled via the included makefile with
//
//	# t3make -f safeTest.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

versionInfo: GameID;

gameMain: GameMainDef
	_ints = static [
		1, 10, 10000, 123123123123
	]

	newGame() {
		runTests();
	}

	runTests() {
		_ints.forEach(function(i) {
			"Integer = <<toString(toIntegerSafe(i))>>\n ";
		});
	}
;

