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
		local i, v;

		for(i = 1; i <= 100000; i++) {
			//v = new BigNumber(i).sqrt();
			v = sqrtInt(i);
			if(v) {}
		}
		"Ran <<toString(i - 1)>> passes\n ";
	}
	sayGoodbye() {}
;
