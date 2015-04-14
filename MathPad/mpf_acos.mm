/* LibTomFloat, multiple-precision floating-point library
 *
 * LibTomFloat is a library that provides multiple-precision
 * floating-point artihmetic as well as trigonometric functionality.
 *
 * This library requires the public domain LibTomMath to be installed.
 * 
 * This library is free for all purposes without any express
 * gurantee it works
 *
 * Tom St Denis, tomstdenis@iahu.ca, http://float.libtomcrypt.org
 */
#include "tomfloat.h"

int  mpf_acos(mp_float *a, mp_float *b)
{
	mp_float t, one;
	int      err, ires;
	
	/* ensure -1 <= a <= 1 */
	if ((err = mpf_cmp_d(a, -1, &ires)) != MP_OKAY) {
		return err;
	}
	if (ires == MP_LT) {
		return MP_VAL;
	}
	if ((err = mpf_cmp_d(a, 1, &ires)) != MP_OKAY) {
		return err;
	}
	if (ires == MP_GT) {
		return MP_VAL;
	}
	
	if ((err = mpf_abs(a, &t)) != MP_OKAY)			{ goto __ERR; }
	if ((err = mpf_const_d(&one, 1)) != MP_OKAY)	{ goto __ERR; }
	
	if ((err = mpf_mul(&t, &t, &t)) != MP_OKAY)		{ goto __ERR; }
	if ((err = mpf_sub(&t, &one, &t)) != MP_OKAY)	{ goto __ERR; }
	if ((err = mpf_sqrt(&t, &t)) != MP_OKAY)		{ goto __ERR; }
	if ((err = mpf_div(&t, a, &t)) != MP_OKAY)		{ goto __ERR; }
	if ((err = mpf_atan(&t, b)) != MP_OKAY)			{ goto __ERR; }
	
__ERR:	mpf_clear_multi(&one, &t, NULL);
	return MP_OKAY;
}
