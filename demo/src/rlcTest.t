#charset "us-ascii"
//
// rlcTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Noninteractive test of the rlc() function.
//
// It can be compiled via the included makefile with
//
//	# t3make -f rlcTest.t3m
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
	// 
	_tests = static [
		[
			[ 17, -2, 11 ],
			[ 7, 11 ]
		], [
			[ 272, 256, 1009 ],
			[ 179, 1009 ]
		], [
			[ 98, 105, 1001 ],
			[ 93, 143 ]
		]
	]

	newGame() {
		runTests();
	}

	runTests() {
		local err, i, q, r, v;

		err = 0;
		i = 0;
		_tests.forEach(function(o) {
			q = o[1];
			r = o[2];

			i += 1;

			v = rlc(q[1], q[2], q[3]);
			if((v[1] != r[1]) || (v[2] != r[2])) {
				"ERROR:  test <<toString(i)>> failed:
					<<toString(q[1])>>x ~=
					<<toString(q[2])>>
					(mod <<toString(q[3])>>) [original]
					\n\tx ~= <<toString(v[1])>>
					(mod <<toString(v[2])>>) [computed]
					\n\tx ~= <<toString(r[1])>>
					(mod <<toString(r[2])>>) [correct]
					\n ";
				err += 1;
			}
		});
		if(err == 0)
			"passed all <<toString(i)>> tests\n ";
		else
			"FAILED <<toString(err)>> of <<toString(i)>> tests\n ";
			
	}
;

