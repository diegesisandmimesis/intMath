#charset "us-ascii"
//
// gcdTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Noninteractive test of the gcd() function.
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
	// Several test cases.
	// The first two columns of each of the row are the
	// integers to find the greatest common divisor of, and the
	// third column is the correct gcd.
	_tests = static [
		[ 8, 12, 4 ],
		[ 48, 18, 6 ],
		[ 54, 24, 6 ],
		[ 252, 105, 21 ],
		[ 423, 111, 3 ]
	]

	newGame() {
		local err, i, v;

		err = 0;
		i = 0;
		_tests.forEach(function(o) {
			i += 1;
			v = gcd(o[1], o[2]);
			if(v != o[3]) {
				"ERROR:  test <<toString(i)>> failed,
					gcd(<<toString(o[1])>>,
					<<toString(o[2])>>) returned
					<<toString(v)>>, not
					<<toString(o[3])>>\n ";
				err += 1;
			}
		});
		if(err == 0)
			"passed all <<toString(i)>> tests\n ";
		else
			"FAILED <<toString(err)>> of <<toString(i)>> tests\n ";
			
	}
;

