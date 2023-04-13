#charset "us-ascii"
//
// crtTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the intMath library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f crtTest.t3m
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
		[
			[ [ 1, 2 ], [ 2, 3 ], [ 3, 5 ] ],
			[ 23, 30 ]
		], [
			[ [ 2, 5 ], [ 3, 7 ], [ 10, 11 ] ],
			[ 87, 385 ]
		], [
			[ [ 2, 3 ], [ 3, 5 ], [ 2, 7 ] ],
			[ 23, 105 ]
		], [
			[ [ 3, 7 ], [ 2, 5 ], [ 1, 3 ] ],
			[ 52, 105 ]
		]
	]
	newGame() {
		runTests();
	}
	runTests() {
		local a, err, i, q, v;

		err = 0;
		i = 0;
		_tests.forEach(function(o) {
			i += 1;

			q = o[1];		// query
			a = o[2];		// correct response

			if((v = crt(q)) == nil) {
				err += 1;
				return;
			}

			if((v[1] != a[1]) || (v[2] != a[2])) {
				"ERROR:  wrong result for test
					<<toString(i)>>
					\n\t<<toString(v[1])>>
					(mod <<toString(v[2])>>) [computed]
					\n\t<<toString(a[1])>>
					(mod <<toString(a[2])>>) [correct]
					\n ";
				err += 1;
			}
		});
		if(err == 0) {
			"passed all <<toString(i)>> tests\n ";
		} else {
			"FAILED <<toString(err)>> of <<toString(i)>> tests\n ";
		}
	}
;

