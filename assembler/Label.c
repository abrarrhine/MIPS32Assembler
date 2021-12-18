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

#include "Label.h"
#include <string.h>
#include <stdlib.h>

static Label *LabelTable[100];

static int NumFilled = 0;
static int MaxFill = 100;

int GetNumFilled()
{
	return NumFilled;
}

Label *GetElement(int idx)
{
	return LabelTable[idx];
}

int16_t GetLabel(const char *const LabelName)
{

	size_t length = strlen(LabelName);

	for (int i = 0; i < NumFilled; i++)
	{
		Label *label = LabelTable[i];
		if (length == strlen(label->LabelName) && strncmp(LabelName, label->LabelName, length) == 0)
		{
			return label->Offset;
		}
	}
	return -1;
}

void InsertLabel(const char *const LabelName, const int16_t const Offset)
{
	if (NumFilled < MaxFill)
	{
		Label *next = (Label *)calloc(1, sizeof(Label));
		next->LabelName = LabelName;
		next->Offset = Offset;
		LabelTable[NumFilled] = next;
		NumFilled = NumFilled + 1;
	}
}

void ClearTable()
{
	for (int i = 0; i < NumFilled; i++)
	{
		Label *next = LabelTable[i];
		free(next->LabelName);
		free(next);
	}
}
