%{
    #include <stdio.h>
    #include <stdlib.h>

    void yyerror(const char *s);
    int yylex();

    int label_count = 0;
    int new_label() { 
        return label_count++; 
    }
%}

%union {
    int num;
    int l;
}

%token PRINT READ WHILE IF RIGHT LEFT INC DEC HALT
%token EQ NEQ GT LT
%token <num> NUM

%type <l> while_head if_head

%%

program
    :
      {
          printf("section .bss\n");
          printf("    cells resb 30000\n\n");
          printf("section .text\n");
          printf("global _start\n");
          printf("_start:\n");
          printf("    mov rbx, cells    ; rbx = tape head pointer\n\n");
      }
      stmts
    ;

stmts
    : stmts stmt
    | /* empty */
    ;

stmt
    : RIGHT
      {
          printf("\n    ; right\n");
          printf("    inc rbx\n");
      }

    | LEFT
      {
          printf("\n    ; left\n");
          printf("    dec rbx\n");
      }

    | INC NUM
      {
          printf("\n    ; inc %d\n", $2);
          printf("    add byte [rbx], %d\n", $2);
      }

    | DEC NUM
      {
          printf("\n    ; dec %d\n", $2);
          printf("    sub byte [rbx], %d\n", $2);
      }

    | PRINT
      {
          printf("\n    ; print\n");
          printf("    lea rsi, [rbx]\n");
          printf("    mov rax, 1\n");
          printf("    mov rdi, 1\n");
          printf("    mov rdx, 1\n");
          printf("    syscall\n");
      }

    | READ
      {
          printf("\n    ; read\n");
          printf("    lea rsi, [rbx]\n");
          printf("    mov rax, 0\n");
          printf("    mov rdi, 0\n");
          printf("    mov rdx, 1\n");
          printf("    syscall\n");
      }

    | while_head '{' stmts '}'
      {
          int L = $1;
          printf("\n    jmp .loop%d\n", L);
          printf(".loop%d_end:\n", L);
      }

    | if_head '{' stmts '}'
      {
          int L = $1;
          printf(".if%d_end:\n", L);
      }
    | HALT
      {
          printf("\n    ; exit\n");
          printf("    mov rax, 60\n");
          printf("    xor rdi, rdi\n");
          printf("    syscall\n");
      }
    ;

while_head
    : WHILE NEQ NUM
      {
          int L = new_label();
          printf("\n    ; while != %d\n", $3);
          printf(".loop%d:\n", L);
          printf("    cmp byte [rbx], %d\n", $3);
          printf("    je  .loop%d_end\n", L);
          $$ = L;
      }
    | WHILE EQ NUM
      {
          int L = new_label();
          printf("\n    ; while == %d\n", $3);
          printf(".loop%d:\n", L);
          printf("    cmp byte [rbx], %d\n", $3);
          printf("    jne .loop%d_end\n", L);
          $$ = L;
      }
    | WHILE GT NUM
      {
          int L = new_label();
          printf("\n    ; while > %d\n", $3);
          printf(".loop%d:\n", L);
          printf("    cmp byte [rbx], %d\n", $3);
          printf("    jbe .loop%d_end\n", L);
          $$ = L;
      }
    | WHILE LT NUM
      {
          int L = new_label();
          printf("\n    ; while < %d\n", $3);
          printf(".loop%d:\n", L);
          printf("    cmp byte [rbx], %d\n", $3);
          printf("    jae .loop%d_end\n", L);
          $$ = L;
      }
    ;

if_head
    : IF EQ NUM
      {
          int L = new_label();
          printf("\n    ; if == %d\n", $3);
          printf("    cmp byte [rbx], %d\n", $3);
          printf("    jne .if%d_end\n", L);
          $$ = L;
      }
    | IF NEQ NUM
      {
          int L = new_label();
          printf("\n    ; if != %d\n", $3);
          printf("    cmp byte [rbx], %d\n", $3);
          printf("    je  .if%d_end\n", L);
          $$ = L;
      }
    | IF GT NUM
      {
          int L = new_label();
          printf("\n    ; if > %d\n", $3);
          printf("    cmp byte [rbx], %d\n", $3);
          printf("    jbe .if%d_end\n", L);
          $$ = L;
      }
    | IF LT NUM
      {
          int L = new_label();
          printf("\n    ; if < %d\n", $3);
          printf("    cmp byte [rbx], %d\n", $3);
          printf("    jae .if%d_end\n", L);
          $$ = L;
      }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) { perror(argv[1]); return 1; }
        extern FILE *yyin;
        yyin = f;
    }
    yyparse();
    return 0;
}
