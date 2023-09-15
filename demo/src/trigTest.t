#charset "us-ascii"
//
// trigTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Noninteractive test of the trig approximation functions.
//
// It can be compiled via the included makefile with
//
//	# t3make -f trigTest.t3m
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

gameMain:       GameMainDef
	newGame() {
	}
;

