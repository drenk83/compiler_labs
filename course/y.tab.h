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
    SHEBANG = 258,                 /* SHEBANG  */
    IF = 259,                      /* IF  */
    THEN = 260,                    /* THEN  */
    ELIF = 261,                    /* ELIF  */
    ELSE = 262,                    /* ELSE  */
    FI = 263,                      /* FI  */
    WHILE = 264,                   /* WHILE  */
    UNTIL = 265,                   /* UNTIL  */
    DO = 266,                      /* DO  */
    DONE = 267,                    /* DONE  */
    FOR = 268,                     /* FOR  */
    IN = 269,                      /* IN  */
    CASE = 270,                    /* CASE  */
    ESAC = 271,                    /* ESAC  */
    FUNCTION = 272,                /* FUNCTION  */
    LOCAL = 273,                   /* LOCAL  */
    ID = 274,                      /* ID  */
    WORD = 275,                    /* WORD  */
    STRING = 276,                  /* STRING  */
    ASSIGN = 277,                  /* ASSIGN  */
    DOLLAR_ID = 278,               /* DOLLAR_ID  */
    DOLLAR_NUM = 279,              /* DOLLAR_NUM  */
    DOLLAR_SPECIAL = 280,          /* DOLLAR_SPECIAL  */
    DOLLAR_BRACE = 281,            /* DOLLAR_BRACE  */
    DOLLAR_LPAREN = 282,           /* DOLLAR_LPAREN  */
    LBRACK = 283,                  /* LBRACK  */
    RBRACK = 284,                  /* RBRACK  */
    LBRACE = 285,                  /* LBRACE  */
    RBRACE = 286,                  /* RBRACE  */
    LPAREN = 287,                  /* LPAREN  */
    RPAREN = 288,                  /* RPAREN  */
    PIPE = 289,                    /* PIPE  */
    AND = 290,                     /* AND  */
    OR = 291,                      /* OR  */
    AMP = 292,                     /* AMP  */
    SEMI = 293,                    /* SEMI  */
    DSEMI = 294,                   /* DSEMI  */
    NL = 295,                      /* NL  */
    LT = 296,                      /* LT  */
    GT = 297,                      /* GT  */
    DGREAT = 298,                  /* DGREAT  */
    REDIR_ERR = 299,               /* REDIR_ERR  */
    REDIR_ERR_OUT = 300            /* REDIR_ERR_OUT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define SHEBANG 258
#define IF 259
#define THEN 260
#define ELIF 261
#define ELSE 262
#define FI 263
#define WHILE 264
#define UNTIL 265
#define DO 266
#define DONE 267
#define FOR 268
#define IN 269
#define CASE 270
#define ESAC 271
#define FUNCTION 272
#define LOCAL 273
#define ID 274
#define WORD 275
#define STRING 276
#define ASSIGN 277
#define DOLLAR_ID 278
#define DOLLAR_NUM 279
#define DOLLAR_SPECIAL 280
#define DOLLAR_BRACE 281
#define DOLLAR_LPAREN 282
#define LBRACK 283
#define RBRACK 284
#define LBRACE 285
#define RBRACE 286
#define LPAREN 287
#define RPAREN 288
#define PIPE 289
#define AND 290
#define OR 291
#define AMP 292
#define SEMI 293
#define DSEMI 294
#define NL 295
#define LT 296
#define GT 297
#define DGREAT 298
#define REDIR_ERR 299
#define REDIR_ERR_OUT 300

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
