#include <stdio.h>
#include <strings.h>

#include "ExIntegers.h"
#include "Reals.h"

mp_int Integer::LogZero;
Real Integer::One;
Real Integer::Two;
Real Integer::Zero;
short Integer::Cnt;
bool Integer::initialized = false;


int Integer::MaxBits()
{
	int bits = (int)Real::numberOfBits();
	return (bits & (~0x3));					// multiple of four bits
}

Real Integer::Max ()
{	
	return (Real::power(Two, Real::Long(MaxBits())) - One);
}

void Integer::Init()
{
	if(initialized)
		return;
		
	initialized = true;

	Real::Init();
	
	Zero = Real(0l);
	One = Real(1l);
	Two = Real(2l);
	mp_init_set_int(&LogZero, 0);
}


/*
 * Private methods
 */
//inline unsigned Integer::AndSet(unsigned op1, unsigned op2)
//{
//	return op1 & op2;
//}
//
//inline unsigned Integer::NandSet(unsigned op1, unsigned op2)
//{
//	return ~(op1 & op2);
//}
//
//inline unsigned Integer::AndNotSet(unsigned op1, unsigned op2)
//{
//	return op1 & ~op2;
//}
//
//
//inline unsigned Integer::OrSet(unsigned op1, unsigned op2)
//{
//	return op1 | op2;
//}
//
//inline unsigned Integer::NorSet(unsigned op1, unsigned op2)
//{
//	return ~(op1 | op2);
//}
//
//inline unsigned Integer::XorSet(unsigned op1, unsigned op2)
//{
//	return op1 ^ op2;
//}
//
//inline unsigned Integer::NotSet(unsigned op1, unsigned op2)
//{
//	return ~op1;
//}

inline bool Integer::IsZero(const Real& x)
{
	return Real::sign(x) == 0;
}

	
/* Misc. local functions */
void Integer::ConstrainNum(Real& Number)
{
	Real MaxNumber = Max();
	Real MinNumber = -MaxNumber-One;
		
	if (Real::cmp(Number, MaxNumber) > 0)
		Number = Real::Copy(MaxNumber);
	else if (Real::cmp(Number, MinNumber) < 0)
		Number = Real::Copy(MinNumber);
}


void Integer::NumToLogical(const Real& Numb, mp_int& logical)
{
	logical = Numb.Integer();
//	Real DivScale;
//	Real Scale;
//	Real Temp;
//	Real Temp2;
//	Real iNumb(Numb);
//	short LogCnt;
//	
//	ConstrainNum(iNumb);
//	if (Real::sign(iNumb) < 0) iNumb = Max() + iNumb + One; 
//	
//	Scale = Real::Long(65536);
//	DivScale = Real::div(One, Scale);
//	
//	LogCnt = 0;
//	for (int i = 0; i <= LogicalSize; i++) logical[i] = LogZero[i];
//	while(!IsZero(iNumb))
//	{
//		Temp2 = Real::entier(Real::mul(iNumb, DivScale));
//		Temp = Real::sub(iNumb, Real::mul(Temp2, Scale));
//		if (LogCnt > LogicalSize) return;
//		logical[LogCnt] = (unsigned) Real::Short(Temp);
//		iNumb = Temp2;
//		LogCnt++;
//	}
}


void Integer::LogicalToNum(const mp_int& logical, Real& Numb)
{
//	Real Scale(65536.0);
//	short LogCnt;
//	int INumb;
//	
//	// determine the maximum representable bits in current Reals
//	int words = MaxBits() / 16;
//	
//	Numb = Real::Copy(Zero);
//	for (LogCnt = words-1; LogCnt >= 0; LogCnt--) {
//		Numb = Real::mul(Numb, Scale);
//		INumb = logical[LogCnt];
//		if (INumb < 0) INumb += 0x10000;
//		Numb = Real::add(Numb, Real::Long(INumb));
//	}
	Numb = Real(logical);
}


//void Integer::LOp(Real& Result, const Real& op1, LogicalProc Oper, const Real& op2)
//{
//	short i;
//	Logical Lop1, Lop2;
//	
//	NumToLogical(op1, Lop1);
//	NumToLogical(op2, Lop2);
//	
//	for(i = 0 ; i <= LogicalSize ; i++)
//		Lop2[i] = Oper(Lop1[i], Lop2[i]);
//		
//	LogicalToNum(Lop2, Result);
//}
//
//void Integer::LOp1(Real& Result, LogicalProc Oper, const Real& op)
//{
//	short i;
//	Logical Lop;
//	
//	NumToLogical(op, Lop);
//	
//	for(i = 0 ; i <= LogicalSize ; i++)
//		Lop[i] = Oper(Lop[i], 0);
//		
//	LogicalToNum(Lop, Result);
//}

//void Integer::LBit(Real& Result, const Real& number, LogicalProc Oper, short bitnum)
//{
//	Real inumber(number);
//	ConstrainNum(inumber);
//	
//	if(bitnum > MaxBits())
//	{
//		Result = inumber;
//		return;
//	}
//	
//	LOp(Result, inumber, Oper, Real::power(Two, Real::Long(bitnum)));
//}


bool Integer::Bit(Real& number, short bitnum)
{
	if (bitnum >= MaxBits()) return false;
	And(number, number, Real::power(Two, Real((long)bitnum)));
	return !IsZero(number);
}


void Integer::LShift(Real& Result, const Real& number, ExNumbProc ExOper, short bits)
{
	Real inumber(number);
	ConstrainNum(inumber);
	
	if (bits > MaxBits()) {
		Result = Real::Copy(Zero);
		return;
	}
	
	Result = ExOper(inumber, Real::power(Two, Real::Long(bits)));
	
	ConstrainNum(Result);
}


void Integer::LRotate(Real& Result, const Real& number, bool Shiftright, short bits)
{
	short ShiftCnt;
	bool SavedBit;
	Real Half;
	Real inumber(number);
	
	ConstrainNum(inumber);
	
	bits = bits % (MaxBits() + 1);
	Half = Real::Long(0.5);
	
	for(ShiftCnt = 1 ; ShiftCnt <= bits ; ShiftCnt++)
	{
		if(Shiftright) {
			SavedBit = Bit(inumber, 0);
			
			inumber = Real::entier(Real::mul(inumber, Half));
			if(SavedBit)
				SetBit(inumber, inumber, MaxBits() - 1);
		} else {
			SavedBit = Bit(inumber, MaxBits() - 1);
			
			inumber = Real::mul(inumber, Two);
			
			if(SavedBit)
				SetBit(inumber, inumber, 0);
		}
	}
	
	Result = inumber;
	ConstrainNum(Result);
}



/*
 * Public methods
 */
 
void Integer::Fib(Real& Result, const Real& number)
{
	Real rp(Zero), rn, u = Real::entier(number);
	if (Real::sign(u) <= 0)
		Result = Zero;
	else {
		// iterative Fibonacci series
		Result = One;
		for (;;) {
			u = u - One;
			if (Real::sign(u) == 0) break;
			rn = Result + rp;
			rp = Result; Result = rn;
		}
	}
}

void Integer::GCD(Real& Result, const Real& op1, const Real& op2)
{
	mp_int int1 = op1.Integer();
	mp_int int2 = op2.Integer();
	mp_gcd(&int1, &int2, &int1);
	Result = Real(int1);
	mp_clear_multi(&int2, &int1, NULL);
}

void Integer::SetBit(Real& Result, const Real& number, short bitnum)
{
	mp_int int1 = number.Integer();
	mp_int twoPower;
	mp_init(&twoPower);
	mp_2expt(&twoPower, bitnum);
	mp_or(&twoPower, &int1, &int1);
	Result = Real(int1);
	mp_clear_multi(&twoPower, &int1, NULL);
}


void Integer::ClearBit(Real& Result, const Real& number, short bitnum)
{
	mp_int int1 = number.Integer();
	mp_int twoPower, mask;
	mp_init_multi(&twoPower, &mask, NULL);
	mp_2expt(&twoPower, bitnum);		 // twoPower = 2^bitnum
	mp_2expt(&mask, MaxBits());			 // mask = 2^MaxBits - 1
	mp_sub_d(&mask, 1, &mask);
	mp_xor(&twoPower, &mask, &mask);	// twoPower = not(2^bitnum)
	mp_and(&mask, &int1, &int1);		// finally clear the bit
	Result = Real(int1);
	mp_clear_multi(&twoPower, &mask, NULL);
}


void Integer::ToggleBit(Real& Result, const Real& number, short bitnum)
{
	mp_int int1 = number.Integer();
	mp_int twoPower;
	mp_init(&twoPower);
	mp_2expt(&twoPower, bitnum);
	mp_xor(&twoPower, &int1, &int1);
	Result = Real(int1);
	mp_clear_multi(&twoPower, &int1, NULL);
}


void Integer::And(Real& Result, const Real& op1, const Real& op2)
{
	mp_int int1, int2, result;
	mp_init(&result);
	int1 = op1.Integer();
	int2 = op2.Integer();
	mp_and(&int1, &int2, &result);
	Result = Real(result);
	mp_clear_multi(&result, &int1, &int2, NULL);
}

void Integer::Nand(Real& Result, const Real& op1, const Real& op2)
{
	And(Result, op1, op2);
	OnesComp(Result, Result);
}

void Integer::Or(Real& Result, const Real& op1, const Real& op2)
{
	mp_int int1, int2, result;
	int1 = op1.Integer();
	int2 = op2.Integer();
	mp_or(&int1, &int2, &result);
	Result = Real(result);
}

void Integer::Nor(Real& Result, const Real& op1, const Real& op2)
{
	Or(Result, op1, op2);
	OnesComp(Result, Result);
}

void Integer::Xor(Real& Result, const Real& op1, const Real& op2)
{
	mp_int int1, int2, result;
	int1 = op1.Integer();
	int2 = op2.Integer();
	mp_xor(&int1, &int2, &result);
	Result = Real(result);
}

void Integer::Count(Real& Result, const Real& op1)
{
//	long bcnt = 0;
//	Real number(op1);
//	Logical lop;
//	
//	NumToLogical(number, lop);
//	for (int i = 0 ; i <= LogicalSize ; i++) {
//		for (int j = 0; j < 16; j++)
//			if (lop[i] & (1 << j)) bcnt++;
//	}
//	Result = Real(bcnt);
	mp_int int1 = op1.Integer();
	Result = Real((long)mp_count_bits(&int1));
}

void Integer::IntDiv(Real& Result, const Real& op1, const Real& op2)
{
//	Real lop1(op1);
//	Real lop2(op2);
//	ConstrainNum(lop1);
//	ConstrainNum(lop2);
//	Result = Real::entier(Real::div(lop1, lop2));
	mp_int int1 = op1.Integer();
	mp_int int2 = op2.Integer();
	mp_int div;
	mp_div(&int1, &int2, &div, NULL);
	Result = Real(div);
}


void Integer::Mod(Real& Result, const Real& op1, const Real& op2)
{
	mp_int int1 = op1.Integer();
	mp_int int2 = op2.Integer();
	mp_int div;
	mp_int mod;
	mp_div(&int1, &int2, &div, &mod);
	Result = Real(mod);
}


void Integer::OnesComp(Real& Result, const Real& number)
{
	mp_int int1 = number.Integer();
	mp_int mask;
	mp_init(&mask);
	mp_2expt(&mask, MaxBits());		// mask = 2^MaxBits - 1
	mp_sub_d(&mask, 1, &mask);
	mp_xor(&int1, &mask, &int1);	// not = mask xor number
	Result = Real(int1);
}


void Integer::Shl(Real& Result, const Real& number, short numbits)
{
	LShift(Result, number, Real::mul, numbits);
	
	Result = Real::abs(Result);
	if (Bit(Result, MaxBits() - 1))
		Result = Real::negate(Result);
}


void Integer::Rol(Real& Result, const Real& number, short numbits)
{
	LRotate(Result, number, Left, numbits);
}


void Integer::Shr(Real& Result, const Real& number, short numbits)
{
	LShift(Result, number, Real::div, numbits);
	Result = Real::abs(Result);
}


void Integer::Ashr(Real& Result, const Real& number, short numbits)
{
	short ShiftCnt;
	bool SavedBit;
	Real inumber(number);
	
	ConstrainNum(inumber);
	
	if (numbits > MaxBits()) {
		Result = Real::Copy(One);
		return;
	}
	
	SavedBit = (Real::cmp(inumber, Zero) < 0);
	
	for (ShiftCnt = 1 ; ShiftCnt <= numbits ; ShiftCnt++) {
		inumber = Real::div(inumber, Two);
		
		if(SavedBit)
			SetBit(inumber, inumber, MaxBits() - 1);
	}
	
	Result = Real::entier(inumber);
}


void Integer::Ror(Real& Result, const Real& number, short numbits)
{
	LRotate(Result, number, Right, numbits);
}


static unsigned DigitIs(const char *S, long& InCnt, BaseType Base)
{
	unsigned Digits;

	if(S[InCnt] > '9')
		Digits = S[InCnt] - 'A' + 10;
	else
		Digits = S[InCnt] - '0';

	InCnt++;
	if(Digits >= Base)
	{
		Real::err = errIllegalNumber;
		return 0;
	}
	
	return Digits;
}

void Integer::StrToInt(const char *S, BaseType Base, Real& A)
{
	long EndCnt, InCnt;
	Real Scale;

	A = Real::Copy(Zero);
	InCnt = 0;
	EndCnt = strlen(S);
	Scale = Real::Long(Base);
	
	while((InCnt < EndCnt) && (S[InCnt] == ' '))
		InCnt++;
		
	while((InCnt < EndCnt) && (Real::err != errIllegalNumber))
		A = Real::add(Real::mul(A, Scale), Real::Long(DigitIs(S, InCnt, Base)));
}

static void PutDigits(long Numb, BaseType Base, char *S)
{
	long dig;
	short rc;
	char Working[strlen(S)+32];
	
	for (rc = 3 ; rc >= 0 ; rc--) {
		dig = Numb % Base;
		if (dig > 9)
			Working[rc] = dig - 10 + 'A';
		else
			Working[rc] = dig + '0';
		Numb /= Base;
	}
	Working[4] = '\0';
	strcat(Working, S);
	strcpy(S, Working);
}

void Integer::IntToStr(const Real& A, BaseType Base, char *S)
{
	short InCnt;
	Real Scale, Temp, Temp2, iA(A);
	char s[strlen(S)+10];
	
	ConstrainNum(iA);
	s[0] = 0;
	if (Real::sign(iA) < 0) iA = Max() + iA + One;
	InCnt = 0;
	Scale = Real::power(Real::Long(Base), Real::Long(4));
	
	do {
		Temp2 = Real::entier(Real::div(iA, Scale));
		Temp = Real::sub(iA, Real::mul(Temp2, Scale));
		
		PutDigits((long) Real::Short(Temp), Base, s);
		
		iA = Temp2;
	} while (!IsZero(iA));
	
	InCnt = 0;
	while((InCnt < strlen(s)-1) && (s[InCnt] == '0')) InCnt++; // s.Remove(0, 1);
	
	if (s[InCnt] > '9') {
		if (InCnt > 0) InCnt--;
	}
	strcpy(S, &s[InCnt]);
}
