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

#include <bignum.h>

versionInfo:    GameID
        name = 'intMath Library Demo Game'
        byline = 'Diegesis & Mimesis'
        desc = 'Demo game for the intMath library. '
        version = '1.0'
        IFID = '12345'
	// No ABOUT because we're never interactive
	showAbout() {}
;

gameMain:       GameMainDef
	newGame() {
		runTest();
	}
	runTest() {
		local d, i, n, t0, v;

		// Number of test passes
		n = 10000;

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
		"\tsqrtInt() took <<toString(d)>> seconds\n ";
	

		// Run n calls to BigNumber().sqrt()
		for(i = 1; i <= n; i++) {
			v = new BigNumber(i).sqrt();
			if(v) {}
		}

		// Report the elapsed time
		d = timestamp() - t0;
		"\tBigNumber().sqrt() took <<toString(d)>> seconds\n ";
	}
	sayGoodbye() {}
;
