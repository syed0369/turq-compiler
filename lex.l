%{
    #include "y.tab.h"
    void yyerror(const char* msg);
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
[{}]            { return yytext[0]; }

"=="            { return EQ; }
"!="            { return NEQ; }
">"             { return GT; }
"<"             { return LT; }

-?[0-9]+        { yylval.num = atoi(yytext); return NUM; }

"//"[^\n]*       { }
[ \t\n]+        { }

.               { yyerror("invalid character"); }

%%

int yywrap() { 
    return 1;
}
