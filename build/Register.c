// On my honor:
//
// - I have not discussed the C language code in my program with
// anyone other than my instructor or the teaching assistants
// assigned to this course.
//
// - I have not used C language code obtained from another student,
// the Internet, or any other unauthorized source, either modified
// or unmodified.
//
// - If any C language code or documentation used in my program
// was obtained from an authorized source, such as a text book or
// course notes, that has been clearly noted with a proper citation
// in the comments of my program.
//
// - I have not designed this program in such a way as to defeat or
// interfere with the normal operation of the grading code.
//
// <Abrar Islam>
// <abrarr18>

#include "Register.h"
#include <string.h>

static Register RegTable[33] = {
	{"$v0", "00010"},
	{"$v1", "00011"},
	{"$s0", "10000"},
	{"$s1", "10001"},
	{"$s2", "10010"},
	{"$s3", "10011"},
	{"$s4", "10100"},
	{"$s5", "10101"},
	{"$s6", "10110"},
	{"$s7", "10111"},
	{"$zero", "00000"},
	{"$r0", "00000"},
	{"$at", "00001"},
	{"$a0", "00100"},
	{"$a1", "00101"},
	{"$a2", "00110"},
	{"$a3", "00111"},
	{"$t0", "01000"},
	{"$t1", "01001"},
	{"$t2", "01010"},
	{"$t3", "01011"},
	{"$t4", "01100"},
	{"$t5", "01101"},
	{"$t6", "01110"},
	{"$t7", "01111"},
	{"$t8", "11000"},
	{"$t9", "11001"},
	{"$k0", "11010"},
	{"$k1", "11011"},
	{"$gp", "11100"},
	{"$sp", "11101"},
	{"$fp", "11110"},
	{"$ra", "11111"}};

char *GetRegisterNumber(const char *const RegName)
{

	size_t length = strlen(RegName);
	for (int i = 0; i < 33; i++)
	{
		Register check = RegTable[i];
		if (length == strlen(check.RegName) && strncmp(RegName, check.RegName, length) == 0)
		{
			return check.Number;
		}
	}
	return NULL;
}
