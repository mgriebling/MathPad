#ifndef REALS_H
#define REALS_H

#include "Errors.h"
#include "tomfloat.h"

/* internally-used error codes */
typedef enum errType errCodes;

class Real {
	public:
		/* numeric precision-setting constants */
		static const long maxDigits = 200;                      // initial precision level in digits
		static const long outDigits = 56;                       // initial output precision level in digits
		static const long log10eps = 10-maxDigits;              // log10 of initial eps level
		static double digsPerWord;  							// number of digits per word
		static const long maxMant = (maxDigits*200/722+1)/2+1;	// hardcoded maximum mantissa words
		static const long maxExp = 2000000;                     // maximum exponent
	
		static int err;
		static short sigDigs;
		static short debug;
		static Real eps;
		static Real ln2;
		static Real pi;
		static Real ln10;
		static Real one;
		static Real zero;
	
		/* Constructors/destructors */		
		Real(void);
		Real(const Real& x);  	// copy constructor
		Real(const char *str);
		Real(double x);
		Real(long x);
		Real(mp_int x);
		~Real(void);
	
		/* Overloaded operators */	
		Real& operator = (const Real& x);
//		float & operator [] (int index);
//		float operator [] (int index) const;
		Real operator + (const Real& x) const;
		Real operator - (const Real& x) const;
		Real operator * (const Real& x) const;
		Real operator / (const Real& x) const;
		Real operator - (void) const;
		
		// access the number's characteristics
		int exponent() const;
		mp_int Integer(void) const;

		/*
		 * User routines
		 */	
		static Real Long(double x);
		static Real Copy(const Real& a);
		static Real ToReal(const char *str);
		static long numberOfBits(void);
		
		// I/O routines
//		static void Read(const Preference *r, const char *name, Real&x);
//		static void Write(Preference *w, const char *name, const Real& x);
	
		/* Conversion routines */	
		static void ToString(const Real& a, char *str, long n, long dp, char mode);
		static double Short(const Real& q);
		static Real entier(const Real& q);
		static Real fraction(const Real& q);
	
		/* Basic math routines */	
		static Real add(const Real& z1, const Real& z2);
		static Real sub(const Real& z1, const Real& z2);
		static Real mul(const Real& z1, const Real& z2);
		static Real div(const Real& z1, const Real& z2);
		static Real abs(const Real& z);
		static Real negate(const Real& z);
		static long sign(const Real& z);
		static long cmp(const Real& a, const Real& b);
		static void round(Real & z);
	
		/* Power and transcendental routines */
		static Real power(const Real& x, const Real& exp);
		static Real root(const Real& z, long n);
		static Real sqrt(const Real& z);
		static Real exp(const Real& z);
		static Real ln(const Real& z);
		static Real log(const Real& z, const Real& base);
		static Real sin(const Real& z);
		static Real cos(const Real& z);
		static void sincos(const Real& z, Real &sin, Real &cos);
		static Real tan(const Real& z);
		static Real arcsin(const Real& z);
		static Real arccos(const Real& z);
		static Real arctan(const Real& z);
		static Real arctan2(const Real& xn, const Real& xd);
		static void sinhcosh(const Real& z, Real &sinh, Real &cosh);
		static Real sinh(const Real& z);
		static Real cosh(const Real& z);
		static Real tanh(const Real& z);
		
		/* Misc. routines */	
		static Real factorial(const Real& x);
		static Real permutations(const Real& n, const Real& r);
		static Real combinations(const Real& n, const Real& r);
		static Real random(void);
		
		// module-related routines -- apply to class		
		static void Init(void);
		static void SetDigits(long digits);
		
	private:		
		// other internal constants
		static const bool DEBUG1 = true;     	// set to false in production code
		static double ZERO;
		static double ONE;
		static double HALF;
		static double invLn2;
		static double Ln2;
		static double Ln10;
		static const long MaxFactorial = 388006;
		
		// internal scaling constants
//		static double mpbbx;
//		static double radix;
//		static double mpbx2;
//		static double mprbx;
//		static double invRadix;
//		static double mprx2;
//		static double mprxx;
		
		// internal number storage
		mp_float val;
	
		// internal variables
		static bool initialized;
		static short numBits;
		static Real seed;		
		
		// private constructor
		Real(mp_float *x);
		
		// Private methods
		static long Sign(float x, float y);
		static void Zero(float *x);
		static long Int(double x);
		static double ipower(double x, short base);
		static void Reduce(double &a, long &exp);
		static void OutReal(Real& n);
		static void OutFloat(mp_float& n);
		static char GetDigit(mp_float*frac, long pos, long digs);
		static void Test(void);
		
	protected:
		/*
		 * Internal (non-user) routines
		 */
		static void toReal(const char *str, mp_float *b);
		static void nfactorial(long &prevn, long &currentn, mp_float *Result);
//		static void copy(const float *a, float *b);
//		static void OutRealDesc(const float *n);
//		static void WriteReal(const float *q);
		static void Round(mp_float *a);
//		static void Normalize(double *d, float *a);
		static double Short(const mp_float* q);
		static void RealToNumbExp(const mp_float *a, double &b, long &n);
		static void NumbExpToReal(double a, long n, mp_float *b);
//		static void Add(float *c, const float *a, const float *b);
//		static void Sub(float *c, const float *a, const float *b);
//		static void Mul(float *c, const float *a, const float *b);
//		static void Muld(float *c, const float *a, double b, long n);
//		static void Div(float *c, const float *a, const float *b);
//		static void Divd(float *c, const float *a, double b, long n);
//		static void Abs(float *z, const float *x);
		static void IntPower(mp_float *b, const mp_float *arg_a, long n);
//		static long Cmp(const float *a, const float *b);
//		static void Sqrt(float *b, const float *a);
//		static void Root(float *b, const float *a, long n);
//		static void Pi(float *pi);
		static void Entier(mp_float *b, const mp_float *a);
//		static void RoundInt(float *b, const float *a);
//		static void Exp(float *b, const float *a);
//		static void Ln(float *b, const float *a);
		static void SinCos(mp_float *sin, float *cos, const mp_float *a);
		static void SinhCosh(mp_float *sinh, mp_float *cosh, const mp_float *a);
		static void ATan2(mp_float *a, const mp_float *x, const mp_float *y);
};

#endif
