/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    IF = 258,                      /* IF  */
    THEN = 259,                    /* THEN  */
    ELIF = 260,                    /* ELIF  */
    ELSE = 261,                    /* ELSE  */
    FI = 262,                      /* FI  */
    TIME = 263,                    /* TIME  */
    FOR = 264,                     /* FOR  */
    IN = 265,                      /* IN  */
    UNTIL = 266,                   /* UNTIL  */
    WHILE = 267,                   /* WHILE  */
    DO = 268,                      /* DO  */
    DONE = 269,                    /* DONE  */
    CASE = 270,                    /* CASE  */
    ESAC = 271,                    /* ESAC  */
    COPROC = 272,                  /* COPROC  */
    SELECT = 273,                  /* SELECT  */
    FUNCTION = 274,                /* FUNCTION  */
    EQUAL = 275,                   /* EQUAL  */
    PIPE = 276,                    /* PIPE  */
    AMP = 277,                     /* AMP  */
    SEMI = 278,                    /* SEMI  */
    LT = 279,                      /* LT  */
    GT = 280,                      /* GT  */
    BANG = 281,                    /* BANG  */
    DOLLAR = 282,                  /* DOLLAR  */
    DOLLAR_BRACED = 283,           /* DOLLAR_BRACED  */
    LBRACE = 284,                  /* LBRACE  */
    RBRACE = 285,                  /* RBRACE  */
    LPAREN = 286,                  /* LPAREN  */
    RPAREN = 287,                  /* RPAREN  */
    LDBRACKET = 288,               /* LDBRACKET  */
    RDBRACKET = 289,               /* RDBRACKET  */
    ID = 290,                      /* ID  */
    STRING = 291,                  /* STRING  */
    NUMBER = 292,                  /* NUMBER  */
    SHEBANG = 293,                 /* SHEBANG  */
    WS = 294,                      /* WS  */
    NEWLINE = 295                  /* NEWLINE  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define IF 258
#define THEN 259
#define ELIF 260
#define ELSE 261
#define FI 262
#define TIME 263
#define FOR 264
#define IN 265
#define UNTIL 266
#define WHILE 267
#define DO 268
#define DONE 269
#define CASE 270
#define ESAC 271
#define COPROC 272
#define SELECT 273
#define FUNCTION 274
#define EQUAL 275
#define PIPE 276
#define AMP 277
#define SEMI 278
#define LT 279
#define GT 280
#define BANG 281
#define DOLLAR 282
#define DOLLAR_BRACED 283
#define LBRACE 284
#define RBRACE 285
#define LPAREN 286
#define RPAREN 287
#define LDBRACKET 288
#define RDBRACKET 289
#define ID 290
#define STRING 291
#define NUMBER 292
#define SHEBANG 293
#define WS 294
#define NEWLINE 295

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
