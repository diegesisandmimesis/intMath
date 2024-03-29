#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the intMath library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include <date.h>
#include <bignum.h>

versionInfo: GameID;

gameMain:       GameMainDef
	newGame() {
		runTest();
	}
	runTest() {
		local d, i, n, t0, v;

		// Number of test passes
		n = 100000;

		// Get the current timestamp
		t0 = timestamp();

		"Running <<toString(n)>> passes:\n ";

		// Run n calls to sqrtInt()
		for(i = 1; i <= n; i++) {
			v = sqrtInt(i);
			// NOP so the compiler doesn't complain that we're
			// not using v for anything
			if(v) {}
		}

		// Report the elapsed time
		d = timestamp() - t0;
		"\tsqrtInt() took <<toString(d)>> ms\n ";
	

		// Run n calls to BigNumber().sqrt()
		for(i = 1; i <= n; i++) {
			v = new BigNumber(i).sqrt();
			if(v) {}
		}

		// Report the elapsed time
		d = timestamp() - t0;
		"\tBigNumber().sqrt() took <<toString(d)>> ms\n ";
	}
	sayGoodbye() {}
;

timestamp() {
	//return(getTime()[9]);
	return(getTime(GetTimeTicks));
}
