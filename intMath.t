#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

// Module ID for the library
IntMathModuleID: ModuleID {
        name = 'intMath Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

// Return the integer equal to floor(sqrt(v)) without using division or
// floating point.
//
// We figure out how wide, in bits, the value we're finding the root for
// is.  TADS3 ints are 32, so we just use 32, but we could in theory
// figure the width of any specific value we're passed.  We start out
// guessing the root is zero, and at each step with left shift the
// guess by one bit.  We then tack a one onto the righthand side (of the
// guess) and see if that would cause us to overshoot the root.  If it
// doesn't, that's our new estimate.  If it does, then we revert to
// the value we got after shifting.
//
// A worked example (we only show the least significant bits for simplicity)
//
// sqrtInt(36):
//
//	operation		current guess, r	binary representation
//
//	initial guess		0				0000
//
//	left shift		0 				0000 
//	add 1			1				0001
//	r * r < 36?		true
//	new guess		1				0001
//
//	left shift		2				0010
//	add 1			3				0011
//	r * r < 36?		true
//	new guess		3
//
//	left shift		6				0110
//	add 1			7				0111
//	r * r < 36?		FALSE
//	revert guess		6
//	
// This is substantially faster than using TADS3's BigNumber.sqrt() and
// converting the result to an integer.
sqrtInt(v) {
	local c, r, shift;

	// shift is just the width of the input value, in bits
	// We could theoretically determine the actual width of the passed
	// value, but instead we just always assume our number is the
	// full width of a TADS3 integer.
	// This is predicated on the assumption that doing bitwise operations
	// in TADS3 isn't as efficient as doing them in C, so any speedup we'd
	// get out of skipping a few iterations would be lost to the overhead
	// of computing the "real" bit width.
	shift = 32;

	// Make sure the shift is a multiple of 2.  Unnecessary unless we
	// use a "dymanic" shift instead of a hardcoded value.
	shift += shift & 1;

	// Initialize our estimate of the root to zero
	r = 0;

	// Iterate while we haven't shifted through the whole width
	while(shift > 0) {
		// We step by two bits at a time
		shift -= 2;

		// Left shift our root by one bit
		r <<= 1;

		// Figure out what our shifted (above) value plus one would
		// be
		c = r + 1;

		// See if adding one makes us overshoot.  If it doesn't, then
		// that's our new estimate.
		if((c * c) <= (v >> shift))
			r = c;
	}

	// Return our estimate
	return(r);
}

// Returns the width of an integer in bits
bitWidthInt(v) {
	local r;

	if(v < 0)
		return(-1);

	r = 2;
	while((v >> r) != 0)
		r += 2;

	return(r);
}
