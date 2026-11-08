%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

extern void error_line(int line, const char *msg);

static int read_single_quote(void);
static int read_double_quote(void);
%}

%option yylineno noyywrap
%x BODY

ID      [A-Za-z_][A-Za-z0-9_]*
NUM     [0-9]+
WORD    [^ \t\n|&;<>(){}[\]"'`$\\]+

%%
"#!/bin/bash"[ \t]*\n  { BEGIN(BODY); return SHEBANG; }
"#!/bin/bash"[ \t]*    { BEGIN(BODY); return SHEBANG; }
"#!/bin/bash".*        { error_line(1, "extra text in shebang"); exit(1); }
.                      { error_line(1, "missing shebang"); exit(1); }
\n                     { error_line(1, "missing shebang"); exit(1); }
<INITIAL><<EOF>>       { error_line(1, "missing shebang"); exit(1); }

<BODY>[ \t]+                    { }
<BODY>#.*                       { }

<BODY>"if"                      { return IF; }
<BODY>"then"                    { return THEN; }
<BODY>"elif"                    { return ELIF; }
<BODY>"else"                    { return ELSE; }
<BODY>"fi"                      { return FI; }
<BODY>"while"                   { return WHILE; }
<BODY>"until"                   { return UNTIL; }
<BODY>"do"                      { return DO; }
<BODY>"done"                    { return DONE; }
<BODY>"for"                     { return FOR; }
<BODY>"select"                  { return SELECT; }
<BODY>"in"                      { return IN; }
<BODY>"case"                    { return CASE; }
<BODY>"esac"                    { return ESAC; }
<BODY>"function"                { return FUNCTION; }
<BODY>"local"                   { return LOCAL; }

<BODY>"2>&1"                    { return REDIR_ERR_OUT; }
<BODY>"2>"                      { return REDIR_ERR; }
<BODY>">>"                      { return DGREAT; }
<BODY>"&&"                      { return AND; }
<BODY>"||"                      { return OR; }
<BODY>";;"                      { return DSEMI; }

<BODY>"|"                       { return PIPE; }
<BODY>"&"                       { return AMP; }
<BODY>";"                       { return SEMI; }
<BODY>"<"                       { return LT; }
<BODY>">"                       { return GT; }
<BODY>"("                       { return LPAREN; }
<BODY>")"                       { return RPAREN; }
<BODY>"{"                       { return LBRACE; }
<BODY>"}"                       { return RBRACE; }
<BODY>"["                       { return LBRACK; }
<BODY>"]"                       { return RBRACK; }

<BODY>"$(("[0-9A-Za-z+\-*/%<>=!&|^ ]+"))"  { return ARITH; }

<BODY>"$("                      { return DOLLAR_LPAREN; }
<BODY>"${"{ID}"}"               { return DOLLAR_BRACE; }
<BODY>"${!"{ID}"}"              { return DOLLAR_BRACE; }
<BODY>"${"{ID}"["{NUM}"]}"      { return DOLLAR_BRACE; }
<BODY>"${"{ID}"["{ID}"]}"       { return DOLLAR_BRACE; }
<BODY>"${"{ID}"["[@*]"]}"       { return DOLLAR_BRACE; }
<BODY>"${"                      { error_line(yylineno, NULL); exit(1); }
<BODY>"$#"|"$@"|"$*"|"$$"|"$?"  { return DOLLAR_SPECIAL; }
<BODY>"$"{ID}                   { return DOLLAR_ID; }
<BODY>"$"[0-9]+                 { return DOLLAR_NUM; }
<BODY>"$"                       { error_line(yylineno, NULL); exit(1); }

<BODY>{ID}={WORD}               { return ASSIGN; }
<BODY>{ID}=                     { return ASSIGN; }
<BODY>{ID}                      { return ID; }
<BODY>{WORD}                    { return WORD; }

<BODY>'                         { return read_single_quote(); }
<BODY>\"                        { return read_double_quote(); }

<BODY>\n                        { return NL; }

<BODY>.                         { error_line(yylineno, NULL); exit(1); }

%%

static int read_single_quote(void)
{
    int start_line = yylineno;
    int c;

    while ((c = input()) != 0) {
        if (c == '\'')
            return STRING;
    }

    error_line(start_line, "unterminated single quote");
    exit(1);
}

static int read_double_quote(void)
{
    int start_line = yylineno;
    int c;
    int escaped = 0;

    while ((c = input()) != 0) {
        if (escaped) {
            escaped = 0;
            continue;
        }
        if (c == '\\') {
            escaped = 1;
            continue;
        }
        if (c == '"')
            return STRING;
    }

    error_line(start_line, "unterminated double quote");
    exit(1);
}
