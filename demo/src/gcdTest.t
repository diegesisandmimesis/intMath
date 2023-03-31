#charset "us-ascii"
//
// gcdTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the intMath library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f gcdTest.t3m
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
		[ 8, 12, 4 ],
		[ 48, 18, 6 ],
		[ 54, 24, 6 ],
		[ 252, 105, 21 ],
		[ 423, 111, 3 ]
	]
	newGame() {
		local v;

		_tests.forEach(function(o) {
			v = gcd(o[1], o[2]);
			"<<((v == o[3]) ? 'passed' : 'FAILED')>> 
			\tgcd(<<toString(o[1])>>, <<toString(o[2])>>)
				= <<toString(v)>>\n ";
		});
	}
;

