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

#include "Opcode.h"
#include <string.h>

static Opcode OpTable[23] = {
	{"add", "000000"},
	{"addi", "001000"},
	{"nor", "000000"},
	{"slti", "001010"},
	{"syscall", "000000"},
	{"lw", "100011"},
	{"mul", "011100"},
	{"mult", "000000"},
	{"beq", "000100"},
	{"bne", "000101"},
	{"sw", "101011"},
	{"lui", "001111"},
	{"addiu", "001001"},
	{"addu", "000000"},
	{"nop", "000000"},
	{"sll", "000000"},
	{"slt", "000000"},
	{"sra", "000000"},
	{"srav", "000000"},
	{"sub", "000000"},
	{"bgtz", "000111"},
	{"blez", "000110"},
	{"j", "000010"}};

char *GetOpCode(const char *const Str)
{

	size_t length = strlen(Str);

	for (int i = 0; i < 23; i++)
	{
		Opcode check = OpTable[i];
		if (length == strlen(check.Str) && strncmp(Str, check.Str, length) == 0)
		{
			return check.Number;
		}
	}
	return NULL;
}
