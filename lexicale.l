%{
#include "syntaxique.tab.h"
#include "ts.h"
#include <stdio.h>
int nb_ligne = 1;
int nb_colone = 1;
extern YYSTYPE yylval;
%}

lettres [a-zA-Z]
chiffres [0-9]
chiffres_signee \(-?[0-9]+\)
idf {lettres}(({lettres}|{chiffres})|_{lettres}|_{chiffres})*
cst {chiffres}+
cst_signee {chiffres_signee}
flt {chiffres}+"."{chiffres}+
flt_signee {chiffres_signee}"."{chiffres}+

%%
"PROGRAMME" { 
    nb_colone += yyleng; 
    insert(yytext, "mc_prg", "", "", 0, 2); 
    return mc_prg; 
}

"VAR" { 
    nb_colone += yyleng; 
    insert(yytext, "mc_var", "", "", 0, 2); 
    return mc_var; 
}

"BEGIN" { 
    nb_colone += yyleng; 
    insert(yytext, "mc_begin", "", "", 0, 2); 
    return mc_begin; 
}

"END" { 
    nb_colone += yyleng; 
    insert(yytext, "mc_end", "", "", 0, 2); 
    return mc_end; 
}

"IF" { 
    nb_colone += yyleng; 
    insert(yytext, "mc_if", "", "", 0, 2); 
    return mc_if; 
}

"ELSE" { 
    nb_colone += yyleng; 
    insert(yytext, "mc_else", "", "", 0, 2); 
    return mc_else; 
}

"FOR" { 
    nb_colone += yyleng; 
    insert(yytext, "mc_for", "", "", 0, 2); 
    return mc_for; 
}

"WHILE" { 
    nb_colone += yyleng; 
    insert(yytext, "mc_while", "", "", 0, 2); 
    return mc_while; 
}

"READLN" { 
    nb_colone += yyleng; 
    insert(yytext, "mc_read", "", "", 0, 2); 
    return mc_read; 
}

"WRITELN" { 
    nb_colone += yyleng; 
    insert(yytext, "mc_write", "", "", 0, 2); 
    return mc_write; 
}

"INTEGER" { 
    nb_colone += yyleng; 
    yylval.str = strdup(yytext);
    insert(yytext, "mc_integer", "", "", 0, 2); 
    return mc_integer; 
}

"FLOAT" { 
    nb_colone += yyleng; 
    yylval.str = strdup(yytext);
    insert(yytext, "mc_float", "", "", 0, 2); 
    return mc_float; 
}

"CONST" { 
    nb_colone += yyleng; 
    insert(yytext, "mc_const", "", "constant", 0, 2); 
    return mc_const; 
}

{idf} {
    if (yyleng <= 7) {
        nb_colone += yyleng;
        yylval.str = strdup(yytext);
        insert(yytext, "idf", "", "", 0, 0); // Identifiant
        return idf;
    } else {
        printf("Erreur lexicale: longueur (%s) > 7 à la ligne %d et colonne %d\n", yytext, nb_ligne, nb_colone);
        return idf;
    }
}

{flt} { 
    nb_colone += yyleng; 
    yylval.FLOAT = atof(yytext); 
   // insert(yytext, "float_const", "float", "", atof(yytext), 0); 
    return float_const; 
}

{cst} { 
    yylval.INTEGER = atoi(yytext); 
    nb_colone += yyleng; 
    //insert(yytext, "int_const", "integer", "", atoi(yytext), 0); 
    return int_const; 
}

{cst_signee} {
    int valeur = atoi(yytext);
    nb_colone += yyleng;

    if (valeur <= 32767 && valeur >= -32768) {
   //     insert(yytext, "int_const_signee", "integer", "", valeur, 0); 
        return int_const_signee;
    } else {
        printf("Erreur lexicale: entité trop grande à la ligne %d et colonne %d\n", nb_ligne, nb_colone);
        return -1;
    }
}

{flt_signee} { 
    nb_colone += yyleng; 
  //  insert(yytext, "float_const_signee", "float", "", atof(yytext), 0); 
    return float_const_signee; 
}

"," { 
    nb_colone++; 
    insert(yytext, "vg", "", "", 0, 1); 
    return vg; 
}

";" { 
    nb_colone++; 
    insert(yytext, "pvg", "", "", 0, 1); 
    return pvg; 
}

"=" { 
    nb_colone++; 
    insert(yytext, "aff", "", "", 0, 1); 
    return aff; 
}

\+ { 
    nb_colone++; 
    insert(yytext, "add", "", "", 0, 1); 
    return add; 
}         

\- { 
    nb_colone++; 
    insert(yytext, "sub", "", "", 0, 1); 
    return sub; 
}         

\* { 
    nb_colone++; 
    insert(yytext, "mul", "", "", 0, 1); 
    return mul; 
}         

\/ { 
    nb_colone++; 
    insert(yytext, "divide", "", "", 0, 1); 
    return divide; 
}

"{" { 
    nb_colone++; 
    insert(yytext, "mc_acld_ouv", "", "", 0, 1); 
    return mc_acld_ouv; 
}

"}" { 
    nb_colone++; 
    insert(yytext, "mc_acld_ferm", "", "", 0, 1); 
    return mc_acld_ferm; 
}

"&&" { 
    nb_colone += 2; 
    insert(yytext, "and", "", "", 0, 2); 
    return and; 
}

"||" { 
    nb_colone += 2; 
    insert(yytext, "or", "", "", 0, 2); 
    return or; 
}

"!" { 
    nb_colone++; 
    insert(yytext, "neg", "", "", 0, 1); 
    return neg; 
}

">" { 
    nb_colone++; 
    insert(yytext, "sup", "", "", 0, 1); 
    return sup; 
}

"<" { 
    nb_colone++; 
    insert(yytext, "inf", "", "", 0, 1); 
    return inf; 
}

">=" { 
    nb_colone += 2; 
    insert(yytext, "supEqual", "", "", 0, 2); 
    return supEqual; 
}

"<=" { 
    nb_colone += 2; 
    insert(yytext, "infEqual", "", "", 0, 2); 
    return infEqual; 
}

"==" { 
    nb_colone += 2; 
    insert(yytext, "Equal", "", "", 0, 2); 
    return Equal; 
}

"!=" { 
    nb_colone += 2; 
    insert(yytext, "diff", "", "", 0, 2); 
    return diff; 
}

"(" { 
    nb_colone++; 
    insert(yytext, "par_ouv", "", "", 0, 1); 
    return par_ouv; 
}

")" { 
    nb_colone++; 
    insert(yytext, "par_ferm", "", "", 0, 1); 
    return par_ferm; 
}

":" { 
    nb_colone++; 
    insert(yytext, "mc_", "", "", 0, 1); 
    return mc_; 
}

"[" { 
    nb_colone++; 
    insert(yytext, "mc_croch_ouv", "", "", 0, 1); 
    return mc_croch_ouv; 
}

"]" { 
    nb_colone++; 
    insert(yytext, "mc_croch_ferm", "", "", 0, 1); 
    return mc_croch_ferm; 
}

"//".* { 
    nb_colone += 2; 
    insert(yytext, "comment", "", "", 0, 2); 
}

"/*"([^*]|\*+[^*/])*\*+"/" {
    for (int i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] == '\n') {
            nb_ligne++;
            nb_colone = 1;
        } else {
            nb_colone++;
        }
    }
    insert(yytext, "block_comment", "", "", 0, strlen(yytext));
}

[ \t] { 
    nb_colone += yyleng; 
    insert(yytext, "whitespace", "", "", 0, yyleng);
}

[\n] { 
    nb_ligne++; 
    nb_colone = 1; 
    insert(yytext, "newline", "", "", 0, 1);
}
. { 
    printf("Erreur lexicale a la ligne %d, colonne %d : a l'entite '%s'\n", nb_ligne, nb_colone, yytext); 
    nb_colone += yyleng; 
}

%%

int yywrap() {
    return 1;
}

