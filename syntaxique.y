%{
#include <stdio.h>
#include <stdlib.h>
#include<string.h>



extern char *yytext;
extern int nb_ligne;
extern int nb_colone;
extern int yylex();
int yywrap();
void yyerror(const char *s);
/////////////////////////////////////quad /////////////////////////////////////////////////////

char tmp[20];
 extern void initPile(Pile *p);


        // Tampon pour la conversion des étiquettes
int fin_if = 0;       // Étiquette pour la fin d'un `if`
int deb_else = 0;     // Étiquette pour le début du bloc `else`
int i ;
Quadruplet quad[MAX_QUADRUPELTS];
int qc = 0;  // Compteur pour suivre le nombre de quadruplets

// Fonction pour ajouter un quadruplet à la table
void quadr(char opr[], char op1[], char op2[], char res[]) {
    strcpy(quad[qc].oper, opr);
    strcpy(quad[qc].op1, op1);
    strcpy(quad[qc].op2, op2);
    strcpy(quad[qc].res, res);
    qc++;
}

// Fonction pour mettre à jour un quadruplet spécifique
void updateQuad(int num_quad, int colon_quad, char val[]) {
    if (colon_quad == 0) strcpy(quad[num_quad].oper, val);
    else if (colon_quad == 1) strcpy(quad[num_quad].op1, val);
    else if (colon_quad == 2) strcpy(quad[num_quad].op2, val);
    else if (colon_quad == 3) strcpy(quad[num_quad].res, val);
}

// Fonction pour afficher tous les quadruplets générés
void afficher_qdr() {
    printf("********************* Les Quadruplets ***********************\n");
    printf("_____________________________________________________________\n");
    for ( i = 0; i < qc; i++) {
        printf("\n %d - ( %s , %s , %s , %s )\n", i, quad[i].oper, quad[i].op1, quad[i].op2, quad[i].res);
        printf("-------------------------------------------------------------\n");
    }
}

*/

// Variables pour sauvegarder les résultats intermédiaires
char save_type[20];
char tempValeur[20];
char *tempValeur2;
  
int sauvIntConst;
int sauvIntSConst;
float sauvFltConst;
float sauvFltSConst;

int resultExpr;      
    
int resultFacteur;   


int sauvIntConst;  
int sauvIntSConst2;
int sauvIntConst;  
int sauvIntSConst2;      
%}

%union {
    int INTEGER;
    float FLOAT;
    char* str;
}
%left or
%left and
%right neg
%left add sub
%left mul divide
      
%nonassoc sup inf supEqual infEqual Equal diff 

%token mc_prg mc_var mc_begin mc_end mc_if mc_else mc_for mc_while
%token mc_read mc_write <str>mc_integer <str>mc_float mc_const
%token <FLOAT> float_const float_const_signee
%token <INTEGER> int_const <INTEGER>int_const_signee
%token <str>idf 
%token pvg vg aff add sub mul divide
%token mc_acld_ouv mc_acld_ferm mc_croch_ouv mc_croch_ferm and or neg
%token sup inf supEqual infEqual Equal diff mc_
%token par_ouv par_ferm





%%

S:
    mc_prg idf DECL mc_begin CORPS mc_end
    {
        printf("Syntaxe correcte.\n");
        YYACCEPT;
    }
;

DECL:
    mc_var FORM_DECL
    |
;

FORM_DECL:
    mc_acld_ouv LISTE_DECL mc_acld_ferm
;

LISTE_DECL:
    DECLARATION pvg LISTE_DECL
    | DECLARATION pvg
;

DECLARATION:
    TYPE LISTE_IDF
    | TYPE LISTE_IDF aff EXPRESS
    | TYPE LISTE_TAB
    | mc_const TYPE LISTE_DEC_CONST
;
LISTE_IDF:
    idf { 
      if(constValeur($1) == 1 ) printf("semantic error, constante %s a deja unevaler  on the line % d\n",$1, nb_ligne);
    if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line %d\n",
	nb_ligne);
	}
    | idf vg LISTE_IDF {if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line % d\n", nb_ligne);
	}
;
/*
LISTE_DEC_CONST:
    idf aff int_const vg LISTE_DEC_CONST {sprintf(tempValeur,"%d",$3);insererConstante($1 ,tempValeur)}
    | idf aff float_const vg LISTE_DEC_CONST {sprintf(tempValeur,"%d",$3);insererConstante($1 , $3)}
    | idf aff int_const_signee vg LISTE_DEC_CONST {sprintf(tempValeur,"%d",$3);insererConstante($1 , $3)}
    | idf aff float_const_signee vg LISTE_DEC_CONST {sprintf(tempValeur,"%d",$3);insererConstante($1 , $3)}
    | idf vg LISTE_DEC_CONST {insererConstante($1 , "")}
    | idf aff int_const {sprintf(tempValeur,"%d",$3);insererConstante($1 , $3)}
    | idf aff int_const_signee {sprintf(tempValeur,"%d",$3);insererConstante($1 , $3)}
    | idf aff float_const {sprintf(tempValeur,"%d",$3);insererConstante($1 , $3)}
    | idf aff float_const_signee {sprintf(tempValeur,"%d",$3);insererConstante($1 , $3)}
    | idf {insererConstante($1 , "")}
; */

LISTE_DEC_CONST:
    idf aff int_const vg LISTE_DEC_CONST { 
     if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line %d\n",
	nb_ligne);
	
        sprintf(tempValeur, "%d", $3); 
        insererConstante($1, tempValeur); 

    }
    | idf aff float_const vg LISTE_DEC_CONST { 
     if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line %d\n",
	nb_ligne);
	
        sprintf(tempValeur, "%f", $3); 
        insererConstante($1, tempValeur); 

    }
    | idf aff int_const_signee vg LISTE_DEC_CONST { 
     if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line %d\n",
	nb_ligne);
	
        sprintf(tempValeur, "%d", $3); 
        insererConstante($1, tempValeur); 
                mettreAJourValeur($1 , $3);
    }
    | idf aff float_const_signee vg LISTE_DEC_CONST { 
     if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line %d\n",
	nb_ligne);
	
        sprintf(tempValeur, "%f", $3); 
        insererConstante($1, tempValeur); 

    }
    | idf vg LISTE_DEC_CONST { 
     if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line %d\n",
	nb_ligne);
	
        insererConstante($1, ""); 

    }
    | idf aff int_const { 
     if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line %d\n",
	nb_ligne);
	
        sprintf(tempValeur, "%d", $3); 
        insererConstante($1, tempValeur); 

    }
    | idf aff int_const_signee { 
     if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line %d\n",
	nb_ligne);
	
        sprintf(tempValeur, "%d", $3); 
        insererConstante($1, tempValeur); 

    }
    | idf aff float_const { 
     if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line %d\n",
	nb_ligne);
	
        sprintf(tempValeur, "%f", $3); 
        insererConstante($1, tempValeur); 

    }
    | idf aff float_const_signee { 
     if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line %d\n",
	nb_ligne);
	
        sprintf(tempValeur, "%f", $3); 
        insererConstante($1, tempValeur); 

    }
    | idf { 
     if (verifierDeclaration($1)==0) mettreAJourType($1,save_type);
	else printf("semantic error, idf double declared on the line %d\n",
	nb_ligne);
	
        insererConstante($1, ""); 

    }
;



TAB:
    idf mc_croch_ouv int_const mc_croch_ferm {if (verifierDeclaration($1)==0) {mettreAJourType($1,save_type); insertTaille($1 , $3);}
	else printf("semantic error, idf double declared on the line % d\n", nb_ligne);
	}
   
    | idf mc_croch_ouv int_const_signee mc_croch_ferm
    {
        if (sauvIntSConst <= 0) {
            yyerror("Erreur sémantique : Taille de tableau invalide (<= 0)");
            YYABORT;
        }
    }
;

LISTE_TAB:
    TAB
    | TAB vg LISTE_TAB
;



TYPE:
    mc_integer {strcpy(save_type,$1);}
    | mc_float {strcpy(save_type,$1);}

;

CORPS:
    INST CORPS
    |
;

INST:
    AFFECT pvg
    | CONDITION
    | BOUCLE
    | IO
;
/*
AFFECT:
    idf aff EXPRESS {
        if (verifierDeclaration($1) == 0) {
            printf("semantic error idf %s not declared \n", $1);
        } else {
            // Ajoutez une fonction ici pour mettre à jour la valeur dans la table
            char valueStr[20];
            sprintf(valueStr, "%d", resultExpr); // Si c'est un INTEGER
            mettreAJourValeur($1, valueStr);
        }
    }
    | idf mc_croch_ouv EXPRESS mc_croch_ferm aff EXPRESS {
        if (verifierDeclaration($1) == 0) {
            printf("semantic error idf %s not declared \n", $1);
        } else {
            // Mettez à jour la valeur pour un tableau (ajustez selon vos besoins)
            char valueStr[20];
            sprintf(valueStr, "%d", resultExpr); 
            mettreAJourValeurTableau($1, indexExpr, valueStr);
        }
    }
; */

AFFECT:
    idf aff EXPRESS {if (verifierDeclaration($1)==0) {
    
    
 if   ( estCompatible($1 , resultExpr) == 0 ){
 printf("semantic error type nor compatible in lin e %d \n",nb_ligne);
 }
       

//mettreAJourValeur($1, resultExpr);
printf("semantic error idf %s not declared \n",$1);
}}

    | idf mc_croch_ouv int_const mc_croch_ferm aff EXPRESS {if (verifierDeclaration($1)==0)
    

printf("semantic error idf %s not declared \n",$1);


if (depassRange($1 , $3) == 1 ) printf("semantic error : case invalide dans la ligne %d  \n" , nb_ligne);

}
;


/*
EXPRESS:
    TERME
    {
        resultExpr = resultTerme;
    }
    | EXPRESS add TERME
    {
        if ((resultExpr > 0 && resultTerme > 0 && resultExpr > 32767 - resultTerme) ||
            (resultExpr < 0 && resultTerme < 0 && resultExpr < -32768 - resultTerme)) {
            yyerror("Erreur sémantique : Dépassement des bornes pour une addition INTEGER");
           // YYABORT;
        }
        resultExpr = resultExpr + resultTerme;
    }
    | EXPRESS sub TERME
    {
        if ((resultExpr > 0 && resultTerme < 0 && resultExpr > 32767 + resultTerme) ||
            (resultExpr < 0 && resultTerme > 0 && resultExpr < -32768 + resultTerme)) {
            yyerror("Erreur sémantique : Dépassement des bornes pour une soustraction INTEGER");
           // YYABORT;
        }
        resultExpr = resultExpr - resultTerme;
    }
;

TERME:
    FACTEURE
    {
        resultTerme = resultFacteur;
    }
    | TERME mul FACTEURE
    {
        if ((resultTerme > 0 && resultFacteur > 0 && resultTerme > 32767 / resultFacteur) ||
            (resultTerme < 0 && resultFacteur < 0 && resultTerme < 32767 / resultFacteur) ||
            (resultTerme > 0 && resultFacteur < 0 && resultFacteur < -32768 / resultTerme) ||
            (resultTerme < 0 && resultFacteur > 0 && resultTerme < -32768 / resultFacteur)) {
            yyerror("Erreur sémantique : Dépassement des bornes pour une multiplication INTEGER");
           // YYABORT;
        }
        resultTerme = resultTerme * resultFacteur;
    }
    | TERME divide FACTEURE
    {
        if (resultFacteur == 0) {
            yyerror("Erreur sémantique : Division par zéro");
          //  YYABORT;
        }
        resultTerme = resultTerme / resultFacteur;
    }
;

FACTEURE:
    idf {
            resultFacteur = 0;
    if (verifierDeclaration($1)==0)

printf("semantic error idf %s not declared \n",$1);

     }
    | idf mc_croch_ouv EXPRESS mc_croch_ferm
    {

        resultFacteur = 0; 
         if (verifierDeclaration($1)==0)

printf("semantic error idf %s not declared \n",$1);
    }
    | int_const
    {
        sauvConst = $1;
        resultFacteur = sauvConst;
    }
    | float_const
    {
        
        resultFacteur = (int)$1;
    }
    | int_const_signee
    {
        sauvConst = $1;
        sauvConst2  = $1;
        resultFacteur = sauvConst;
    }
    | float_const_signee
    {
        resultFacteur = (int)$1;
    }
    | par_ouv EXPRESS par_ferm
    {
        if (resultExpr == 0) { // Vérifie si l'expression entre parenthèses est zéro
            resultFacteur = 0;
        } else {
            resultFacteur = resultExpr; // Sinon, prend le résultat calculé
        }
    }
    	
;

*/
EXPRESS:
    FACTEUR
    {
        resultExpr = resultFacteur;
    }
    | EXPRESS add FACTEUR
    {
        resultExpr = resultExpr + resultFacteur;
    }
    | EXPRESS sub FACTEUR
    {
        resultExpr = resultExpr - resultFacteur;
    }
    | EXPRESS mul FACTEUR
    {
        resultExpr = resultExpr * resultFacteur;
    }
    | EXPRESS divide FACTEUR
    {
        if (resultFacteur == 0) {
            yyerror("Erreur : Division par zéro");
            YYABORT;
        }
        resultExpr = resultExpr / resultFacteur;
    }
;


FACTEUR:
    idf {
        if (verifierDeclaration($1) == 0)
            printf("semantic error idf %s not declared \n", $1);
            
           
 
        resultFacteur = 0;
    }
    | idf mc_croch_ouv EXPRESS mc_croch_ferm
    {
        resultFacteur = resultExpr; 
    }
    | int_const
    {	
        resultFacteur = $1;
    }
    | float_const
    {
        resultFacteur = $1;
    }
    | int_const_signee
    {sauvIntSConst = $1;
        resultFacteur = $1;
    }
    | float_const_signee
    {
        resultFacteur = $1;
    }
    | par_ouv EXPRESS par_ferm
    {
        resultFacteur = resultExpr;  
    }
;

CONDITION:
    mc_if par_ouv CONDITION_EXPR par_ferm mc_acld_ouv CORPS mc_acld_ferm
    | mc_if par_ouv CONDITION_EXPR par_ferm mc_acld_ouv CORPS mc_acld_ferm mc_else mc_acld_ouv CORPS mc_acld_ferm
;

CONDITION_EXPR:
    EXPRESS sup EXPRESS
    | EXPRESS inf EXPRESS
    | EXPRESS supEqual EXPRESS
    | EXPRESS infEqual EXPRESS
    | EXPRESS Equal EXPRESS
    | EXPRESS diff EXPRESS
    | par_ouv CONDITION_EXPR par_ferm
    | CONDITION_EXPR and CONDITION_EXPR
    | CONDITION_EXPR or CONDITION_EXPR
    | neg CONDITION_EXPR
    
   
;


/*
CONDITION:
      C mc_acld_ouv CORPS mc_acld_ferm
      {
          // R4 : Compléter la fin de la condition avec les bonnes étiquettes
           fin_if=depiler(&mapile);
          sprintf(tmp, "%d", qc); // Étiquette pour le quadruplet final
          updateQuad(fin_if, 2, tmp); // Mise à jour du saut final
          afficher_qdr();
      }
    ;

C:
      B mc_else
      {
        
          sprintf(tmp, "%d", qc);
          fin_if=depiler(&mapile);
          deb_else=depiler(&mapile) ;
           empiler(&mapile,fin_if);
         // Étiquette pour début `else`
          updateQuad(deb_else, 2, tmp);   // Mise à jour du quadruplet précédent
      }
    ;

B:
      A mc_acld_ouv CORPS mc_acld_ferm
      {
          // R2 : Marquer le début du bloc `else`
           quadr("BR", "", "vide", "vide");
           fin_if=qc;
           empiler(&mapile,fin_if);
          
         
         
      }
    ;

A:
      mc_if par_ouv CONDITION_EXPR par_ferm
      {
          // R1 : Générer le quadruplet pour la condition du `if`
          quadr("BZ", "", "vide", "vide");
          deb_else=qc; // Saut conditionnel si faux
          empiler(&mapile,deb_else) ;                        // Enregistrer l'étiquette
      }
    ;

CONDITION_EXPR:
    EXPRESS sup EXPRESS {
        // Transformation de x > 5 en x - 5 > 0
        sprintf(tmp, "T%d", qc);
        quadr("-", $1, $3, tmp);  // Soustraction x - 5
        sprintf(tmp, "T%d", qc);
        quadr(">", tmp, "0", tmp);  // Comparaison avec zéro (x - 5 > 0)
        $$ = strdup(tmp);  // Résultat de la condition
    }
    | EXPRESS inf EXPRESS {
        // Transformation de x < 5 en x - 5 < 0
        sprintf(tmp, "T%d", qc);
        quadr("-", $1, $3, tmp);  // Soustraction x - 5
        sprintf(tmp, "T%d", qc);
        quadr("<", tmp, "0", tmp);  // Comparaison avec zéro (x - 5 < 0)
        $$ = strdup(tmp);  // Résultat de la condition
    }
    | EXPRESS supEqual EXPRESS {
        // Transformation de x >= 5 en x - 5 >= 0
        sprintf(tmp, "T%d", qc);
        quadr("-", $1, $3, tmp);  // Soustraction x - 5
        sprintf(tmp, "T%d", qc);
        quadr(">=", tmp, "0", tmp);  // Comparaison avec zéro (x - 5 >= 0)
        $$ = strdup(tmp);  // Résultat de la condition
    }
    | EXPRESS infEqual EXPRESS {
        // Transformation de x <= 5 en x - 5 <= 0
        sprintf(tmp, "T%d", qc);
        quadr("-", $1, $3, tmp);  // Soustraction x - 5
        sprintf(tmp, "T%d", qc);
        quadr("<=", tmp, "0", tmp);  // Comparaison avec zéro (x - 5 <= 0)
        $$ = strdup(tmp);  // Résultat de la condition
    }
    | EXPRESS Equal EXPRESS {
        // Transformation de x == 5 en x - 5 == 0
        sprintf(tmp, "T%d", qc);
        quadr("-", $1, $3, tmp);  // Soustraction x - 5
        sprintf(tmp, "T%d", qc);
        quadr("==", tmp, "0", tmp);  // Comparaison avec zéro (x - 5 == 0)
        $$ = strdup(tmp);  // Résultat de la condition
    }
    | EXPRESS diff EXPRESS {
        // Transformation de x != 5 en x - 5 != 0
        sprintf(tmp, "T%d", qc);
        quadr("-", $1, $3, tmp);  // Soustraction x - 5
        sprintf(tmp, "T%d", qc);
        quadr("!=", tmp, "0", tmp);  // Comparaison avec zéro (x - 5 != 0)
        $$ = strdup(tmp);  // Résultat de la condition
    }
    | par_ouv CONDITION_EXPR par_ferm {
        // Parenthèses autour de l'expression conditionnelle
        $$ = $2;
    }
    | CONDITION_EXPR and CONDITION_EXPR {
        // Opérateur logique AND
        sprintf(tmp, "T%d", qc);
        quadr("AND", $1, $3, tmp);
        $$ = strdup(tmp);
    }
    | CONDITION_EXPR or CONDITION_EXPR {
        // Opérateur logique OR
        sprintf(tmp, "T%d", qc);
        quadr("OR", $1, $3, tmp);
        $$ = strdup(tmp);
    }
    | neg CONDITION_EXPR {
        // Négation d'une expression conditionnelle
        sprintf(tmp, "T%d", qc);
        quadr("NEG", $2, "vide", tmp);
        $$ = strdup(tmp);
    }
;

*/

BOUCLE:
    mc_while par_ouv CONDITION_EXPR par_ferm mc_acld_ouv CORPS mc_acld_ferm
    | mc_for par_ouv AFFECT mc_ CONDITION_EXPR mc_ AFFECT par_ferm mc_acld_ouv CORPS mc_acld_ferm
;

IO:
    mc_read par_ouv idf par_ferm pvg
    | mc_write par_ouv EXPRESS par_ferm pvg
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur syntaxique à la ligne %d, colonne %d : %s, trouvé '%s'\n", 
            nb_ligne, nb_colone, s, yytext);
}

int main() {
    yyparse();
	afficherTablesSymboles();
	//afficher_qdr();
    return 0;
}

