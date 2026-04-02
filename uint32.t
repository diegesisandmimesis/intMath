#charset "us-ascii"
//
//	unit32.t
//
//	Unsigned 32 bit integer implementation.
//
//
#include <adv3.h>
#include <en_us.h>

#include "intMath.h"

class Uint32: object
	val = 0		// value

	_hi = nil	// high 16 bits
	_lo = nil	// low 16 bits

	_b0 = nil	// 1st byte
	_b1 = nil	// 2nd byte
	_b2 = nil	// 3rd byte
	_b3 = nil	// 4th byte

	// Two invocations:  single arg is the value, two args are the
	// high and low 16 bit halves.
	construct(v0, v1?) {
		if(v1 == nil) {
			val = v0;
			_split();
			_quadSplit();
		} else {
			_hi = v0;
			_lo = v1;
			val = _unsplit();
			_quadSplit();
		}
	}

	// Merges the high and low 16 bit halves, returning the result.
	_unsplit() {
		if(_hi >= 0x8000)
			return(((_hi - 0x10000) * 0x10000) + _lo);
		return((_hi * 0x10000) + _lo);
	}

	// Convert the value into high and low 16 bit halves.
	_split() {
		_lo = val & 0xffff;
		_hi = (val >>> 16) & 0xffff;
	}

	// Convert the value into 4 byte blocks.
	_quadSplit() {
		_b0 = val & 0xff;
		_b1 = (val >>> 8) & 0xff;
		_b2 = (val >>> 16) & 0xff;
		_b3 = (val >>> 24) & 0xff;
	}

	// Returns the sum of this uint32 and the argument uint32.
	add(v) {
		local hi, lo;

		if((v == nil) || !v.ofKind(Uint32))
			return(nil);

		lo = _lo + v._lo;
		hi = (_hi + v._hi) + ((lo >>> 16) & 1);

		return(new Uint32(hi & 0xffff, lo & 0xffff));
	}

	// Returns the difference of this uint32 and the argument uint32.
	subtract(v) {
		local b, hi, lo;

		if((v == nil) || !v.ofKind(Uint32))
			return(nil);

		lo = _lo - v._lo;
		b = (lo < 0) ? 1 : 0;
		lo &= 0xffff;

		hi = (_hi - v._hi) - b;
		hi &= 0xffff;

		return(new Uint32(hi, lo));
	}

	// Returns the product of this uint32 and the argument uint32.
	multiply(v) {
		local hi, lo, t0, t1, t2, t3;

		// Partial products for each byte.
		t0 = _b0 * v._b0;
		t1 = _b0 * v._b1 + _b1 * v._b0;
		t2 = _b0 * v._b2 + _b1 * v._b1 + _b2 * v._b0;
		t3 = _b0 * v._b3 + _b1 * v._b2 + _b2 * v._b1 + _b3 * v._b0;

		// Handle the carries.
		t1 += (t0 >>> 8);
		t0 &= 0xff;

		t2 += (t1 >>> 8);
		t1 &= 0xff;

		t3 += (t2 >> 8);
		t2 &= 0xff;
		t3 &= 0xff;

		hi = t3 * 0x100 + t2;
		lo = t1 * 0x100 + t0;

		return(new Uint32(hi, lo));
	}

	// Divide this uint32 by the argument uint32.
	divide(v) {
		local q_hi, q_lo, r_hi, r_lo, i, bit, n_lo, b, top;

		if((v == nil) || !v.ofKind(Uint32))
			return(nil);

		// Division by zero is undefined.
		if((v._hi == 0) && (v._lo == 0))
			return(nil);

		q_hi = 0;
		q_lo = 0;
		r_hi = 0;
		r_lo = 0;

		// If the high 16 bits are zero we can skip half the
		// iterations.
		top = (_hi != 0) ? 31 : 15;

		for(i = top; i >= 0; i--) {
			// Remainder.
			r_hi = ((r_hi << 1) | ((r_lo >>> 15) & 1)) & 0xffff;
			r_lo = (r_lo << 1) & 0xffff;

			// Figure out which half we're working on,
			// get next bit of divident.
			if(i >= 16)
				bit = (_hi >>> (i - 16)) & 1;
			else
				bit = (_lo >>> i) & 1;

			r_lo = r_lo | bit;

			// If the remainder is greater than the divisor
			// we subtract it and twiddle the quotient.
			if((r_hi > v._hi)
				|| ((r_hi == v._hi) && (r_lo >= v._lo))) {
				n_lo = r_lo - v._lo;
				b = (n_lo < 0) ? 1 : 0;
				r_lo = n_lo & 0xffff;
				r_hi = (r_hi - v._hi - b) & 0xffff;

				// Check which half we're working on,
				// twiddle the quotient.
				if(i >= 16)
					q_hi = q_hi | (1 << (i - 16));
				else
					q_lo = q_lo | (1 << i);
			}
		}

		return(new Uint32(q_hi & 0xffff, q_lo & 0xffff));
	}

	clone() { return(new Uint32(_hi, _lo)); }

	operator +(x) { return(add(x)); }
	operator -(x) { return(subtract(x)); }
	operator *(x) { return(multiply(x)); }
	operator /(x) { return(divide(x)); }

	rotateLeft(n?) {
		local hi, lo, n_hi, n_lo, tmp;

		n = ((n != nil) ? n : 1);
		if(n == 0)
			return(clone());

		hi = _hi;
		lo = _lo;

		if(n >= 16) {
			tmp = hi;
			hi = lo;
			lo = tmp;
			n -= 16;
		}
		if(n == 0)
			return(new Uint32(hi, lo));

		n_hi = ((hi << n) | (lo >>> (16 - n))) & 0xffff;
		n_lo = ((lo << n) | (hi >>> (16 - n))) & 0xffff;

		return(new Uint32(n_hi, n_lo));
	}

	rotateRight(x) { return(rotateLeft(32 - x)); }

	operator <<(x) { return(rotateLeft(x)); }
	operator >>(x) { return(rotateRight(x)); }

	log() {
		"\nval = <<toString(val)>>\n ";
		"\n\thi = <<toString(_hi)>>\n ";
		"\n\tlo = <<toString(_lo)>>\n ";
	}
;
