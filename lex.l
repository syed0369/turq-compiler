%{
    #include "y.tab.h"
%}

%%

"print"         { return PRINT; }
"read"          { return READ; }
"while"         { return WHILE; }
"if"            { return IF; }
"right"         { return RIGHT; }
"left"          { return LEFT; }
"inc"           { return INC; }
"dec"           { return DEC; }
"halt"          { return HALT; }

"=="            { return EQ; }
"!="            { return NEQ; }
">"             { return GT; }
"<"             { return LT; }

[0-9]+          { yylval.num = atoi(yytext); return NUM; }

"//"[^\n]*      { }
[ \t\n]+        { }

.               { return yytext[0]; }

%%

int yywrap() { 
    return 1;
}
