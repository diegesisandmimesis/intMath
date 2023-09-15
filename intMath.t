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

// Compute the greatest common divisor using Euclid's algorithm.
// This relies on the fact that gcd(v0, v1) = gcd(v0, (v0 - v1)).
// That is, any two numbers will share a greatest common divisor with
// their difference.  So we just subtract the smaller number from
// the bigger number, get rid of the bigger number, compare what was
// the smaller number to the difference (we can't predict if the
// difference will be larger or smaller than the original smaller number),
// and repeat the process until the the two numbers we're left with are
// equal.  That number is the greatest common divisor of the original
// two numbers (and all of the intermediate values as well).
gcd(v0, v1) {
	local v;

	// Make a vector containing the two values.
	v = new Vector([ v0, v1 ]);

	// We make v0 the largest value we currently have, and v1 is the
	// smallest.  We continue until v0 and v1 are the same.
	while((v0 = v[v.indexOfMax()]) != (v1 = v[v.indexOfMin()])) {
		// We put the difference in the vector.
		v.append(v0 - v1);

		// We remove the largest of the three values we
		// currently have, which is going to be v0 (because
		// we already checked v1 is smaller at the start of
		// the loop, and v0 > (v0 - v1).
		v.removeElement(v0);
	}

	return(v0);
}

// Extended Euclidean algorithm.
// Here we compute the greatest common divisor as well as the Bezout
// coefficients.  The Bezout coefficients are integers x and y such that:
//
//	ax + by = gcd(a, b)
//
// The return value is an array containing five elements: the gcd, the
// two Bezout coefficients, and finally the quotients of the the Bezout
// coefficients and the gcd.
gcdX(v0, v1) {
	local f, q, r, r0, r1, s, s0, s1, t, t0, t1;

	// Set our initial "remainders" to be the arguments.  Note if
	// we flipped the order.
	if(v0 > v1) {
		r0 = v0;
		r1 = v1;
		f = nil;
	} else {
		r1 = v0;
		r0 = v1;
		f = true;
	}

	// Initialize the Bezout coefficients.
	s0 = 1;
	s1 = 0;
	t0 = 0;
	t1 = 1;

	// We keep going while the remainder is nonzero.
	while(r1 != 0) {
		// Compute the quotient of the remainders from the last
		// iteration.
		q = r0 / r1;

		// Compute the new remainder.
		r = r0 - (r1 * q);

		// Compute the new Bezout coefficients.
		s = s0 - (s1 * q);
		t = t0 - (t1 * q);

		// We always keep track of the values from two iterations,
		// the 1-indexed ones are the "new" ones and the 0-indexed
		// ones are the "old" ones.  Here we make the "new" values
		// from the iteration we just finished the "old" values for
		// the next iteration.
		r0 = r1;
		s0 = s1;
		t0 = t1;

		// And we make the values we just computed the "new" values
		// for the next iteration.
		r1 = r;
		s1 = s;
		t1 = t;
	}

	// Figure out if we need to correct the sign on the
	// quotients.  Just to make life easier for callers.
	if(((v0 < 0) ? -1 : 1) != ((s1 < 0) ? -1 : 1)) s1 *= -1;
	if(((v1 < 0) ? -1 : 1) != ((t1 < 0) ? -1 : 1)) t1 *= -1;

	// Return the remainder (which will be the GCD) and the
	// Bezout coefficients from the iteration before we got a
	// zero remainder.
	// We check the flag to see if we had to re-order the args, and
	// swap the order of the coefficients if we did, so they match
	// the order of the args.
	if(f == true)
		return([ r0, t0, s0, s1, t1 ]);
	else
		return([ r0, s0, t0, s1, t1 ]);
}

// Reduce a congruence in the form:
//
//	ax ~= b (mod m)
//
// ...to...
//
//	x ~= r (mod m)
//
// Note:  We normalize the results so that the remainder is
// in [ 0, m ).
rlc(a, b, m) {
	local ar, r;

	// Get the GCD and the Bezout coefficients.
	ar = gcdX(a, m);

	// Sanity check.
	if(b % ar[1])
		return(nil);

	// Divide the remainder and the modulus by the GCD.
	b /= ar[1];
	m /= ar[1];

	// Compute the modular multiplicative inverse with the Bezout
	// coefficient we got from the extended Euclidean algorithm.
	r = (b * ar[2]) % m;

	// Normalize the remainder.
	while(r > m) r += m;
	while(r < 0) r += m;

	// Return the reduced remainder and modulus.
	return([ r, m ]);
}

// Chinese remainder theorem implementation.
// Input is an array of 2-element arrays.  Each 2-element array is
// one of the modular congruences that is being solved for, in the form
// [ remainder, modulus ].
//
// So to solve the system...
//
//	x ~= 1 (mod 2)
//	x ~= 2 (mod 3)
//	x ~= 3 (mod 5)
//
// ...the argument should be [ [ 1, 2 ], [ 2, 3 ], [ 3, 5 ] ]
crt(ar) {
	local i, m, n, r, s, v;

	// Make sure the argument is valid.
	if((ar == nil) || !ar.ofKind(Collection))
		return(nil);

	// First, we multiply the modulus of each congruence together
	// to get their product, n.
	for(i = 1, n = 1; i <= ar.length; i++) {
		v = ar[i];
		if((v == nil) || !v.ofKind(Collection) || (v.length != 2))
			return(nil);
		n *= v[2];
	}

	// Create an array containing the quotient of n by the modulus
	// for each congruence.
	m = new Vector(ar.length);
	ar.forEach(function(o) { m.append(n / o[2]); });

	// Create an array containing the product of the m value computed
	// above and its Bezout coefficient.
	r = new Vector(ar.length);
	for(i = 1; i <= ar.length; i++) {
		r.append(gcdX(m[i], ar[i][2])[2] * m[i]);
	}

	// Sum the products of values of r computed above and the remainder
	// of each congruence.
	for(i = 1, s = 0; i <= ar.length; i++) { s += r[i] * ar[i][1]; }

	// Normalize.
	while(s > n) s -= n;
	while(s < 0) s += n;

	// Return the result.
	return([ s, n ]);
}

// Test the argument for primality in a semi-performant-for-small-values
// manner.
isPrime(v) {
	local i;

	if(v == nil) return(nil);
	if(v <= 3) return(v > 1);
	if(((v % 2) == 0) || (v % 3) == 0) return(nil);
	for(i = 5; i * i <= v; i += 6)
		if(((v % i) == 0) || ((v % (i + 2)) == 0)) return(nil);
	return(true);
}
