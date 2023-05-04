%option noyywrap
%{
	#include<stdio.h>
	#include<stdlib.h>
	int lineno = 1;
	void ret_print(char *token_type);
	void yyerror();
	/*[a-z] {printf("Single lowercase char\n");}
	. {printf("Not lowercase char\n");}
	\n {return 0;}*/

%}

STRING			(\"[^\"\n]*\")|(\'[^\'\n]*\')
RESERVED		go[ ]to|exit|if|then|else|case|endcase|while|do|endwhile|repeat|until|loop|forever|for|to|by|endfor|input|output|array|node|call|return|stop|end|procedure
ARITHMETIC_OPS	[\+\-\*\/\^]
LOGICAL_OPS		and|or|not
RELATIONAL_OPS	\<|\<\=|\>|\>\=|\==|!\=|:\=
IDENTIFIERS		[a-zA-Z_][a-zA-Z_0-9]*
INTEGERS		[0-9]+
PUNCTUATORS		[\(\)\[\]:\,\"\'\.\;]


%%

{STRING}			{ ret_print("STRING"); }
{RESERVED}			{ ret_print("RESERVED"); }
"="				{ ret_print("ASSIGNMENT_OPS"); }
{ARITHMETIC_OPS}	{ ret_print("ARITHMETIC_OPS"); }
{LOGICAL_OPS}		{ ret_print("LOGICAL_OPS"); }
{RELATIONAL_OPS}	{ ret_print("RELATIONAL_OPS"); }
{IDENTIFIERS}		{ ret_print("IDENTIFIERS"); }
{INTEGERS}+			{ ret_print("INTEGERS"); }
"\n"				{ lineno++; }
[ \t\r\f\s]+		/* eat up whitespace */
{PUNCTUATORS}		/* eat up punctuators */
.			{ yyerror("Unrecognized character.");}

%%

void ret_print(char *token_type){
	printf("<%s,%s>\n", token_type, yytext);
}

void yyerror(char *message){
	printf("Error: \"%s\" in line %d. Token = %s\n", message, lineno, yytext);
	exit(1);
}

int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	return 0;
}