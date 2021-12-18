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
#include "assembler.h"
#include "Function.h"
#include "Opcode.h"
#include "Label.h"
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdio.h>
#include <inttypes.h>

/*
 * Main function of MIPS Assembler. This function runs the whole program
 * and generate output.
 * */

int main(int argc, char **argv)
{
	if (argc == 3)
	{
		char *dtrslt = FillLabels(argv[1]);

		FILE *In = fopen(argv[1], "r");
		if (In == NULL)
		{
			printf("Could not find input file!!");
			return -1;
		}

		FILE *Out = fopen(argv[2], "w");

		int16_t lineNum = 1;
		char *line_buf = (char *)calloc(257, sizeof(char));
		size_t buf_size = 256;
		ssize_t line_len;
		line_len = getline(&line_buf, &buf_size, In);

		while (line_len >= 0)
		{
			char *comment = strchr(line_buf, '#');

			if (comment != NULL)
			{
				int idx = (int)(comment - line_buf);

				if (idx > 0)
				{
					char *temp = (char *)calloc(idx + 1, sizeof(char));
					strncpy(temp, line_buf, idx);
					free(line_buf);
					line_buf = temp;
					line_len = strlen(line_buf);
				}
				else
				{
					line_len = 0;
				}
			}

			if (line_len > 0)
			{
				char *temp = (char *)calloc(line_len + 1, sizeof(char));
				sscanf(line_buf, " %[^\n]", temp);
				free(line_buf);
				line_buf = temp;
				line_len = strlen(line_buf);
			}

			if (line_len > 1)
			{
				bool header = (strchr(line_buf, '.') != NULL);
				bool label = (strchr(line_buf, ':') != NULL);

				if (!(header || label))
				{
					int extraLines = parseInstruction(line_buf, Out, lineNum);
					lineNum++;
					lineNum = lineNum + extraLines;
				}
			}
			free(line_buf);
			line_buf = (char *)calloc(257, sizeof(char));
			line_len = getline(&line_buf, &buf_size, In);
		}

		fprintf(Out, "\n%s", dtrslt);
		free(line_buf);
		fclose(In);
		fclose(Out);
		ClearTable();
		free(dtrslt);
	}
	else if (argc == 4)
	{
		char *dResult = FillLabels(argv[1]);
		FILE *Out = fopen(argv[2], "w");
		int fill = GetNumFilled();
		for (int i = 0; i < fill; i++)
		{
			Label *label = GetElement(i);
			fprintf(Out, "0x0000%04" PRIX16 "  %s\n", label->Offset, label->LabelName);
		}
		free(dResult);
		fclose(Out);
		ClearTable();
	}
	return 0;
}

/*
 * This function parses the instructions
 * */

int parseInstruction(char *pInstr, FILE *Output, int16_t lineNum)
{

	int extraLines = 0;
	char *name = (char *)calloc(8, sizeof(char));
	sscanf(pInstr, "%s", name);
	char *arg1 = (char *)calloc(33, sizeof(char));
	char *arg2 = (char *)calloc(33, sizeof(char));
	char *arg3 = (char *)calloc(33, sizeof(char));
	char *opcode = GetOpCode(name);
	char *funcVal = GetFunction(name);

	if (strlen(name) == 2 && strncmp("la", name, 2) == 0)
	{
		char *rd = (char *)calloc(6, sizeof(char));
		char *label = (char *)calloc(33, sizeof(char));
		sscanf(pInstr, "%*s %[^,], %s", rd, label);
		int16_t offset = GetLabel(label);
		char *pseudo = (char *)calloc(36, sizeof(char));
		sprintf(pseudo, "addi %s, $zero, %" PRIi16 "", rd, offset);
		parseInstruction(pseudo, Output, lineNum);
		free(rd);
		free(label);
		free(pseudo);
	}
	else if (strlen(name) == 4 && strncmp("move", name, 4) == 0)
	{
		char *rd = (char *)calloc(6, sizeof(char));
		char *rs = (char *)calloc(6, sizeof(char));
		sscanf(pInstr, "%*s %[^,], %s", rd, rs);
		char *pseudo = (char *)calloc(31, sizeof(char));
		sprintf(pseudo, "addu %s, $zero, %s", rd, rs);
		parseInstruction(pseudo, Output, lineNum);
		free(pseudo);
		free(rd);
		free(rs);
	}

	else if (strlen(name) == 2 && strncmp("li", name, 2) == 0)
	{
		char *rt = (char *)calloc(6, sizeof(char));
		int16_t imm;
		sscanf(pInstr, "%*s %[^,], %" PRIi16 "", rt, &imm);
		char *pseudo = (char *)calloc(41, sizeof(char));
		sprintf(pseudo, "addiu %s, $zero, %" PRIi16 "", rt, imm);
		parseInstruction(pseudo, Output, lineNum);
		free(pseudo);
		free(rt);
	}

	else if (strlen(name) == 3 && strncmp("blt", name, 3) == 0)
	{
		extraLines = 1;
		char *rs = (char *)calloc(6, sizeof(char));
		char *rt = (char *)calloc(6, sizeof(char));
		char *label = (char *)calloc(33, sizeof(char));
		sscanf(pInstr, "%*s %[^,], %[^,], %s", rs, rt, label);
		char *pseudo1 = (char *)calloc(26, sizeof(char));
		char *pseudo2 = (char *)calloc(51, sizeof(char));
		sprintf(pseudo1, "slt $at, %s, %s", rs, rt);
		sprintf(pseudo2, "bne $at, $zero, %s", label);
		parseInstruction(pseudo1, Output, lineNum);
		parseInstruction(pseudo2, Output, lineNum + 1);
		free(pseudo1);
		free(pseudo2);
		free(rs);
		free(rt);
		free(label);
	}

	else if (strlen(name) == 2 && strncmp("lw", name, 2) == 0 && strchr(pInstr, '(') == NULL)
	{
		char *rt = (char *)calloc(6, sizeof(char));
		char *label = (char *)calloc(33, sizeof(char));
		sscanf(pInstr, "%*s %[^,], %s", rt, label);
		int16_t offset = GetLabel(label);
		char *pseudo = (char *)calloc(31, sizeof(char));
		sprintf(pseudo, "lw %s, %" PRIi16 "($zero)", rt, offset);
		parseInstruction(pseudo, Output, lineNum);
		free(rt);
		free(label);
		free(pseudo);
	}

	else
	{
		if (funcVal != NULL)
		{
			int nArgs = sscanf(pInstr, "%*s %[^,], %[^,\n], %s", arg1, arg2, arg3);
			if (nArgs == 3)
			{
				int8_t imm;
				int isNumber = sscanf(arg3, "%" PRIi8 "", &imm);
				if (isNumber == 1)
				{
					char *binary = convertToBinary5(imm);
					fprintf(Output, "%s00000%s%s%s%s\n", opcode, GetRegisterNumber(arg2), GetRegisterNumber(arg1), binary, funcVal);
					free(binary);
				}
				else
				{
					if (strlen(name) == 4 && strncmp("srav", name, 4) == 0)
					{
						fprintf(Output, "%s%s%s%s00000%s\n", opcode, GetRegisterNumber(arg3), GetRegisterNumber(arg2), GetRegisterNumber(arg1), funcVal);
					}
					else
					{
						fprintf(Output, "%s%s%s%s00000%s\n", opcode, GetRegisterNumber(arg2), GetRegisterNumber(arg3), GetRegisterNumber(arg1), funcVal);
					}
				}
			}
			else if (nArgs == 2)
			{
				fprintf(Output, "%s%s%s0000000000%s\n", opcode, GetRegisterNumber(arg1), GetRegisterNumber(arg2), funcVal);
			}
			else
			{
				fprintf(Output, "%s00000000000000000000%s\n", opcode, funcVal);
			}
		}
		else
		{
			bool special = (strchr(pInstr, '(') != NULL);
			int nArgs;

			if (special)
			{
				nArgs = sscanf(pInstr, "%*s %[^,], %[^(](%[^)])", arg1, arg3, arg2);
			}
			else
			{
				nArgs = sscanf(pInstr, "%*s %[^,], %[^,\n], %s", arg1, arg2, arg3);
			}

			if (nArgs == 3)
			{
				int16_t imm;
				int isNumber = sscanf(arg3, "%" PRIi16 "", &imm);

				if (isNumber == 1)
				{
					char *binary = convertToBinary16(imm);
					fprintf(Output, "%s%s%s%s\n", opcode, GetRegisterNumber(arg2), GetRegisterNumber(arg1), binary);
					free(binary);
				}
				else
				{
					imm = (GetLabel(arg3) / 4) - lineNum;
					char *binary = convertToBinary16(imm);
					fprintf(Output, "%s%s%s%s\n", opcode, GetRegisterNumber(arg1), GetRegisterNumber(arg2), binary);
					free(binary);
				}
			}
			else if (nArgs == 2)
			{
				int16_t imm;
				int isNumber = sscanf(arg2, "%" PRIi16 "", &imm);

				if (isNumber == 1)
				{
					char *binary = convertToBinary16(imm);
					fprintf(Output, "%s00000%s%s\n", opcode, GetRegisterNumber(arg1), binary);
					free(binary);
				}
				else
				{
					imm = (GetLabel(arg2) / 4) - lineNum;
					char *binary = convertToBinary16(imm);
					fprintf(Output, "%s%s00000%s\n", opcode, GetRegisterNumber(arg1), binary);
					free(binary);
				}
			}
			else
			{
				char *binary = convertToBinary16(GetLabel(arg1) / 4);
				fprintf(Output, "%s0000000000%s\n", opcode, binary);
				free(binary);
			}
		}
	}

	free(name);
	free(arg1);
	free(arg2);
	free(arg3);
	return extraLines;
}

/*
 * Converts Integer (int16) to binary
 * */
char *convertToBinary16(int16_t number)
{

	char *result = (char *)calloc(17, sizeof(char));

	for (int i = 15; i >= 0; i--)
	{
		if (number & 1)
		{
			result[i] = '1';
		}
		else
		{
			result[i] = '0';
		}
		number = number >> 1;
	}
	return result;
}

/*
 * Converts Integer (int32) to binary
 * */

char *convertToBinary32(int32_t number)
{

	char *result = (char *)calloc(33, sizeof(char));

	for (int i = 31; i >= 0; i--)
	{
		if (number & 1)
		{
			result[i] = '1';
		}
		else
		{
			result[i] = '0';
		}
		number = number >> 1;
	}
	return result;
}

/*
 * Converts Integer (int8) to binary
 * */

char *convertToBinary5(int8_t number)
{
	char *result = (char *)calloc(6, sizeof(char));
	for (int i = 4; i >= 0; i--)
	{
		if (number & 1)
		{
			result[i] = '1';
		}
		else
		{
			result[i] = '0';
		}
		number = number >> 1;
	}
	return result;
}

char *convertToBinary8(char number)
{
	char *result = (char *)calloc(9, sizeof(char));
	for (int i = 7; i >= 0; i--)
	{
		if (number & 1)
		{
			result[i] = '1';
		}
		else
		{
			result[i] = '0';
		}
		number = number >> 1;
	}
	return result;
}

char *FillLabels(const char *const file)
{

	FILE *In = fopen(file, "r");
	if (In == NULL)
	{
		printf("Could not find input file!!");
		return NULL;
	}

	char *dataResult = (char *)calloc(1, sizeof(char));
	bool isData = false;
	bool isText = false;
	int16_t lineOffset = 0;
	char *line_buf = (char *)calloc(257, sizeof(char));
	size_t buf_size = 256;
	ssize_t line_len;
	line_len = getline(&line_buf, &buf_size, In);
	while (line_len >= 0)
	{
		char *comment = strchr(line_buf, '#');
		if (comment != NULL)
		{
			int idx = (int)(comment - line_buf);
			if (idx > 0)
			{
				char *temp = (char *)calloc(idx + 1, sizeof(char));
				strncpy(temp, line_buf, idx);
				free(line_buf);
				line_buf = temp;
				line_len = strlen(line_buf);
			}
			else
			{
				line_len = 0;
			}
		}
		if (line_len > 0)
		{
			char *temp = (char *)calloc(line_len + 1, sizeof(char));
			sscanf(line_buf, " %[^\n]", temp);
			free(line_buf);
			line_buf = temp;
			line_len = strlen(line_buf);
		}
		if (line_len > 1)
		{
			bool header = (strchr(line_buf, '.') != NULL);
			bool label = (strchr(line_buf, ':') != NULL);

			if (header && !label)
			{
				char *section = (char *)calloc(5, sizeof(char));
				sscanf(line_buf, " .%s", section);

				if (strncmp("data", section, 4) == 0)
				{
					isData = true;
				}
				else if (strncmp("text", section, 4) == 0)
				{
					int numPadding = 4 - (lineOffset % 4);

					if (numPadding != 4)
					{
						for (int i = 0; i < numPadding; i++)
						{
							dataResult = (char *)strncat(dataResult, "00000000", 9);
							lineOffset++;
						}
						dataResult = (char *)strncat(dataResult, "\n", 2);
					}

					isText = true;
					isData = false;
					lineOffset = 0;
				}

				free(section);
			}
			else if (isData)
			{

				if (label)
				{
					char *name = (char *)calloc(33, sizeof(char));
					char *type = (char *)calloc(7, sizeof(char));
					char *data = (char *)calloc(257, sizeof(char));
					sscanf(line_buf, " %[^:]: .%s %[^\n]", name, type, data);

					if (strlen(type) == 4 && strncmp("word", type, 4) == 0)
					{
						int numPadding = 4 - (lineOffset % 4);
						if (numPadding != 4)
						{
							for (int i = 0; i < numPadding; i++)
							{
								dataResult = (char *)strncat(dataResult, "00000000", 9);
								lineOffset++;
							}
							dataResult = (char *)strncat(dataResult, "\n", 2);
						}

						bool range = (strchr(data, ':') != NULL);
						bool array = (strchr(data, ',') != NULL);

						if (range)
						{
							int count;
							int32_t init;
							sscanf(data, "%" PRIi32 ":%i", &init, &count);
							InsertLabel(name, lineOffset + 0x2000);
							char *initStr = convertToBinary32(init);

							for (int i = 0; i < count; i++)
							{
								size_t len = strlen(dataResult);
								dataResult = (char *)realloc(dataResult, len + 34);
								dataResult = (char *)strncat(dataResult, initStr, 32);
								dataResult = (char *)strncat(dataResult, "\n", 2);
								lineOffset = lineOffset + 4;
							}
							free(initStr);
						}
						else if (array)
						{
							InsertLabel(name, lineOffset + 0x2000);

							while (array)
							{
								int32_t init;
								char *temp = (char *)calloc(257, sizeof(char));
								sscanf(data, "%" PRIi32 ", %[^\n]", &init, temp);
								free(data);
								data = temp;
								array = (strchr(data, ',') != NULL);
								lineOffset = lineOffset + 4;
								size_t len = strlen(dataResult);
								char *initStr = convertToBinary32(init);
								dataResult = (char *)realloc(dataResult, len + 34);
								dataResult = (char *)strncat(dataResult, initStr, 32);
								dataResult = (char *)strncat(dataResult, "\n", 2);
								free(initStr);
							}

							int32_t init;
							sscanf(data, "%" PRIi32 "", &init);
							char *initStr = convertToBinary32(init);
							size_t len = strlen(dataResult);
							dataResult = (char *)realloc(dataResult, len + 34);
							dataResult = (char *)strncat(dataResult, initStr, 32);
							dataResult = (char *)strncat(dataResult, "\n", 2);
							lineOffset = lineOffset + 4;
							free(initStr);
						}

						else
						{
							int32_t init;
							sscanf(data, "%" PRIi32 "", &init);
							char *initStr = convertToBinary32(init);
							InsertLabel(name, lineOffset + 0x2000);
							size_t len = strlen(dataResult);
							dataResult = (char *)realloc(dataResult, len + 34);
							dataResult = (char *)strncat(dataResult, initStr, 32);
							dataResult = (char *)strncat(dataResult, "\n", 2);
							lineOffset = lineOffset + 4;
							free(initStr);
						}
					}

					else if (strlen(type) == 6 && strncmp("asciiz", type, 6) == 0)
					{

						char *string = (char *)calloc(257, sizeof(char));
						sscanf(data, "\"%[^\"]\"", string);
						InsertLabel(name, lineOffset + 0x2000);

						size_t len = strlen(string);

						for (int i = 0; i < len; i++)
						{

							if ((lineOffset % 4) == 0)
							{
								dataResult = (char *)realloc(dataResult, strlen(dataResult) + 34);
							}
							char letter = string[i];
							char *binary = convertToBinary8(letter);
							dataResult = (char *)strncat(dataResult, binary, 8);
							free(binary);
							lineOffset++;

							if ((lineOffset % 4) == 0)
							{
								dataResult = (char *)strncat(dataResult, "\n", 2);
							}
						}
						if ((lineOffset % 4) == 0)
						{
							dataResult = (char *)realloc(dataResult, strlen(dataResult) + 34);
						}
						dataResult = (char *)strncat(dataResult, "00000000", 9);
						lineOffset++;
						if ((lineOffset % 4) == 0)
						{
							dataResult = (char *)strncat(dataResult, "\n", 2);
						}
						free(string);
					}
					free(type);
					free(data);
				}
			}
			else if (isText)
			{
				if (label)
				{
					char *name = (char *)calloc(33, sizeof(char));
					sscanf(line_buf, " %[^:]", name);
					InsertLabel(name, lineOffset * 4);
				}
				else
				{
					char *name = (char *)calloc(8, sizeof(char));
					sscanf(line_buf, "%s", name);
					if (strlen(name) == 3 && strncmp(name, "blt", 3) == 0)
					{
						lineOffset++;
					}
					lineOffset++;
					free(name);
				}
			}
		}
		free(line_buf);
		line_buf = (char *)calloc(257, sizeof(char));
		line_len = getline(&line_buf, &buf_size, In);
	}
	free(line_buf);
	fclose(In);
	return dataResult;
}
