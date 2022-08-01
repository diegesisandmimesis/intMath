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

// Return the integer equal to floor(sqrt(v))
sqrtInt(v) {
	local c, r, shift;

	shift = 32;
	shift += shift & 1;
	r = 0;
	while(shift > 0) {
		shift -= 2;
		r <<= 1;
		c = r + 1;
		if((c * c) <= (v >> shift))
		r = c;
	}
	return(r);
}
