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
    FUNC_DEF = 258,                /* FUNC_DEF  */
    VAR_ASSIGN_ZERO = 259,         /* VAR_ASSIGN_ZERO  */
    NUMBER = 260,                  /* NUMBER  */
    OPTION = 261,                  /* OPTION  */
    VAR_ASSIGN = 262,              /* VAR_ASSIGN  */
    STRING_CONTENT = 263,          /* STRING_CONTENT  */
    IDENT = 264,                   /* IDENT  */
    GE = 265,                      /* GE  */
    GT = 266,                      /* GT  */
    LT = 267,                      /* LT  */
    IF = 268,                      /* IF  */
    THEN = 269,                    /* THEN  */
    ELIF = 270,                    /* ELIF  */
    ELSE = 271,                    /* ELSE  */
    FI = 272,                      /* FI  */
    TIME = 273,                    /* TIME  */
    FOR = 274,                     /* FOR  */
    IN = 275,                      /* IN  */
    UNTIL = 276,                   /* UNTIL  */
    WHILE = 277,                   /* WHILE  */
    DO = 278,                      /* DO  */
    DONE = 279,                    /* DONE  */
    CASE = 280,                    /* CASE  */
    ESAC = 281,                    /* ESAC  */
    COPROC = 282,                  /* COPROC  */
    SELECT = 283,                  /* SELECT  */
    FUNCTION = 284,                /* FUNCTION  */
    READONLY = 285,                /* READONLY  */
    ECHO = 286,                    /* ECHO  */
    LOCAL = 287,                   /* LOCAL  */
    EXIT = 288,                    /* EXIT  */
    READ = 289,                    /* READ  */
    DOUBLE_SEMI = 290,             /* DOUBLE_SEMI  */
    LS = 291,                      /* LS  */
    PWD = 292,                     /* PWD  */
    CD = 293,                      /* CD  */
    MKDIR = 294,                   /* MKDIR  */
    TOUCH = 295,                   /* TOUCH  */
    CP = 296,                      /* CP  */
    MV = 297,                      /* MV  */
    RM = 298,                      /* RM  */
    CAT = 299,                     /* CAT  */
    LBRACE = 300,                  /* LBRACE  */
    RBRACE = 301,                  /* RBRACE  */
    LBRACK = 302,                  /* LBRACK  */
    RBRACK = 303,                  /* RBRACK  */
    DBL_LBRACK = 304,              /* DBL_LBRACK  */
    DBL_RBRACK = 305,              /* DBL_RBRACK  */
    BANG = 306,                    /* BANG  */
    PIPE = 307,                    /* PIPE  */
    AMPERSAND = 308,               /* AMPERSAND  */
    SEMICOLON = 309,               /* SEMICOLON  */
    LPAREN = 310,                  /* LPAREN  */
    RPAREN = 311,                  /* RPAREN  */
    LT_SYM = 312,                  /* LT_SYM  */
    GT_SYM = 313,                  /* GT_SYM  */
    DOLLAR = 314,                  /* DOLLAR  */
    QUOTE = 315,                   /* QUOTE  */
    ASSIGN = 316,                  /* ASSIGN  */
    PLUS = 317,                    /* PLUS  */
    MINUS = 318,                   /* MINUS  */
    MULT = 319,                    /* MULT  */
    DIV = 320,                     /* DIV  */
    DOTDOT = 321,                  /* DOTDOT  */
    DBL_LPAREN = 322,              /* DBL_LPAREN  */
    DBL_RPAREN = 323,              /* DBL_RPAREN  */
    SHEBANG = 324,                 /* SHEBANG  */
    COMMENT = 325,                 /* COMMENT  */
    STRING_UNTERMINATED = 326,     /* STRING_UNTERMINATED  */
    OTHER = 327,                   /* OTHER  */
    NEWLINE = 328                  /* NEWLINE  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define FUNC_DEF 258
#define VAR_ASSIGN_ZERO 259
#define NUMBER 260
#define OPTION 261
#define VAR_ASSIGN 262
#define STRING_CONTENT 263
#define IDENT 264
#define GE 265
#define GT 266
#define LT 267
#define IF 268
#define THEN 269
#define ELIF 270
#define ELSE 271
#define FI 272
#define TIME 273
#define FOR 274
#define IN 275
#define UNTIL 276
#define WHILE 277
#define DO 278
#define DONE 279
#define CASE 280
#define ESAC 281
#define COPROC 282
#define SELECT 283
#define FUNCTION 284
#define READONLY 285
#define ECHO 286
#define LOCAL 287
#define EXIT 288
#define READ 289
#define DOUBLE_SEMI 290
#define LS 291
#define PWD 292
#define CD 293
#define MKDIR 294
#define TOUCH 295
#define CP 296
#define MV 297
#define RM 298
#define CAT 299
#define LBRACE 300
#define RBRACE 301
#define LBRACK 302
#define RBRACK 303
#define DBL_LBRACK 304
#define DBL_RBRACK 305
#define BANG 306
#define PIPE 307
#define AMPERSAND 308
#define SEMICOLON 309
#define LPAREN 310
#define RPAREN 311
#define LT_SYM 312
#define GT_SYM 313
#define DOLLAR 314
#define QUOTE 315
#define ASSIGN 316
#define PLUS 317
#define MINUS 318
#define MULT 319
#define DIV 320
#define DOTDOT 321
#define DBL_LPAREN 322
#define DBL_RPAREN 323
#define SHEBANG 324
#define COMMENT 325
#define STRING_UNTERMINATED 326
#define OTHER 327
#define NEWLINE 328

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 9 "pars_bash.y"

    char *str;

#line 217 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
