/* F++ saikyou da, monku aru ka kuso yarou. Kono ripo wa mou houchi suru. */
#ifndef FPP_LANG_H
#define FPP_LANG_H

typedef struct {
    const char *jp;
    int tok;
} FppKeyword;

static const FppKeyword fpp_keywords[] = {
    /* Onislemci (#) */
    {"torikomu",     TOK_INCLUDE},  /* #include */
    {"teigi",        TOK_DEFINE},   /* #define */
    {"moshiteigi",   TOK_IFDEF},    /* #ifdef */
    {"moshimiteigi", TOK_IFNDEF},   /* #ifndef */
    {"owari",        TOK_ENDIF},    /* #endif */

    /* Tipler */
    {"seisu",        TOK_INT},      /* int */
    {"moji",         TOK_CHAR},     /* char */
    {"fudo",         TOK_FLOAT},    /* float */
    {"baiseido",     TOK_DOUBLE},   /* double */
    {"kara",         TOK_VOID},     /* void */
    {"mijikai",      TOK_SHORT},    /* short */
    {"nagai",        TOK_LONG},     /* long */
    {"fugonashi",    TOK_UNSIGNED}, /* unsigned */
    {"teisu",        TOK_CONST1},    /* const */
    {"kozotai",      TOK_STRUCT},   /* struct */
    {"katateigi",    TOK_TYPEDEF},  /* typedef */
    {"saizu",        TOK_SIZEOF},   /* sizeof */

    /* Kontrol Akisi */
    {"moshi",        TOK_IF},       /* if */
    {"soreigai",     TOK_ELSE},     /* else */
    {"aida",         TOK_WHILE},    /* while */
    {"jikko",        TOK_DO},       /* do */
    {"kurikaesu",    TOK_FOR},      /* for */
    {"bunki",        TOK_SWITCH},   /* switch */
    {"baai",         TOK_CASE},     /* case */
    {"kitei",        TOK_DEFAULT},  /* default */
    {"nukeru",       TOK_BREAK},    /* break */
    {"tsuzukeru",    TOK_CONTINUE}, /* continue */
    {"modoru",       TOK_RETURN},   /* return */
    {NULL, 0}
};

static int fpp_is_english_keyword(int t)
{
    switch (t) {
    case TOK_INCLUDE: case TOK_DEFINE: case TOK_IFDEF: case TOK_IFNDEF: case TOK_ENDIF:
    case TOK_INT: case TOK_VOID: case TOK_CHAR: case TOK_SHORT: case TOK_LONG:
    case TOK_FLOAT: case TOK_DOUBLE: case TOK_SIGNED1: case TOK_UNSIGNED:
    case TOK_CONST1: case TOK_VOLATILE1: case TOK_STATIC: case TOK_EXTERN:
    case TOK_AUTO: case TOK_REGISTER: case TOK_STRUCT: case TOK_UNION:
    case TOK_ENUM: case TOK_TYPEDEF: case TOK_SIZEOF:
    case TOK_IF: case TOK_ELSE: case TOK_WHILE: case TOK_DO: case TOK_FOR:
    case TOK_SWITCH: case TOK_CASE: case TOK_DEFAULT:
    case TOK_BREAK: case TOK_CONTINUE: case TOK_RETURN: case TOK_GOTO:
        return 1;
    default:
        return 0;
    }
}

static int fpp_translate_token(int t, const char *filename)
{
    const char *name;
    size_t len;
    int i;

    if (t < TOK_IDENT || !filename)
        return t;

    len = strlen(filename);
    if (len <= 4 || strcmp(filename + len - 4, ".fpp") != 0)
        return t;

    if (fpp_is_english_keyword(t))
        tcc_error("F++ (.fpp) ichi de Eigo C tango wa tsukaemasen: '%s'", get_tok_str(t, NULL));

    name = get_tok_str(t, NULL);
    if (!name)
        return t;

    if (strcmp(name, "shu") == 0)
        return tok_alloc("main", 4)->tok;

    for (i = 0; fpp_keywords[i].jp != NULL; i++) {
        if (strcmp(name, fpp_keywords[i].jp) == 0)
            return fpp_keywords[i].tok;
    }
    return t;
}

#endif
