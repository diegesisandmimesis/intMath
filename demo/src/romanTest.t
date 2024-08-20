#charset "us-ascii"
//
// romanTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Noninteractive test of the isPrime() function.
//
// It can be compiled via the included makefile with
//
//	# t3make -f romanTest.t3m
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
	_tests = static [
		39 -> 'XXXIX',
		246 -> 'CCXLVI',
		789 -> 'DCCLXXXIX',
		2421 -> 'MMCDXXI',
		160 -> 'CLX',
		207 -> 'CCVII',
		1009 -> 'MIX',
		1066 -> 'MLXVI',
		1776 -> 'MDCCLXXVI',
		1918 -> 'MCMXVIII',
		1944 -> 'MCMXLIV',
		2024 -> 'MMXXIV'
	]
	_reverse = perInstance(new LookupTable())

	_testRoman(n) {
		local v;

		v = toRoman(n);
		"<<toString(n)>> = <<toString(v)>>: ";
		if(v == _tests[n])
			"success\n ";
		else
			"FAILED\n ";
	}

	_testReverse(str) {
		local v;

		v = romanToInteger(str);
		"<<toString(str)>> = <<toString(v)>>: ";
		if(v == _reverse[str])
			"success\n ";
		else
			"FAILED\n ";
	}

	newGame() {
		_tests.keysToList().forEach({ x: _reverse[_tests[x]] = x });
		_tests.keysToList().forEach({ x: _testRoman(x) });
		_reverse.keysToList().forEach({ x: _testReverse(x) });
	}
;

