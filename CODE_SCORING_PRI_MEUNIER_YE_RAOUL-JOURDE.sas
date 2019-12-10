							/*---------------------------------------------
   									Création des tables temporaires          
 							  --------------------------------------------- */

							/*---------------------------------------------
	   							Création de la table temporaire SCORING 
	  						  --------------------------------------------- */




/* Insérer le LIBNAME juste en dessous */

LIBNAME scoring "indiquez ici le chemin d'accès à la base de données";


/* Création de la librarie SCORING */

proc format;
 value  copot
 	1="Bon"
 	2="Moyen"
 	3="Mauvais";

 value pandir
	1="Bon"
 	2="Mauvais";

 value $csp
	"00"="Agriculteurs"
	"10"="Industriels - Chef d'entreprise"
	"11"="Artisans"
	"12"="Commerçants"
	"13"="Professions libérales"
	"14"="Représentants"
	"20"="Cadres supérieurs"
	"21"="Ingénieurs"
	"22"="Cadres administratifs supérieurs"
	"30"="Cadres"
	"31"="Techniciens"
	"40"="Employés"
	"41"="Employés de commerce"
	"50"="Ouvriers"
	"51"="Ouvriers spécialisés"
	"62"="Retraités";

 value $etatcivil
	C="Célibataire, Libre"
	D="Divorcé"
	M="Marié"
	S="Séparé"
	U="Union libre, Concubinage ou Pacsé"
	V="Veuf";

 value $modehabi
	F="Logement de fonction"
	H="Hébergé"
	L="Locataire"
	P="Propriétaire";

 value $ind
	O="Oui"
	N="Non";

 value $genreveh
	VP="Véhicule particulier"
	VU="Véhicule utilitaire";

 value $produit
	CB="Crédit Bail"
	CC="Crédit Classique"
	LLD="Location Longue Durée";

 value $quali
	VN="Véhicule neuf"
	VO="Véhicule utilitaire";

 value evpmcopot
	2="Bon"
	4="Moyen"
	6="Mauvais"
	7="Très mauvais"
	9999="Non renseigné";

 value evpa
	4="Moyen"
	6="Mauvais"
	7="Très mauvais"
	9999="Non renseigné";

 value evpmcote
	0="Inconnu"
	1="Très bon"
	2="Bon"
	4="Moyen"
	6="Mauvais"
	7="Très mauvais"
	9999="Non renseigné";

 value $secteur
	AGR="Agriculture"
	ATR="Autres"
	BTP="Bâtiment et Travaux public"
	CDD="Commerce de détail"
	CDG="Commerce de groupe"
	EAE="Enseignement et Auto-école"
	FBC="Biens de consommation"
	FCP="Fabrication Chimie Pharmacie"
	FEM="Industrie"
	HOP="Hôpitaux"
	HRS="Hôtellerie, Restauration"
	LIM="Immobilier"
	LOA="Loueurs"
	MET="Métallurgie"
	RPA="Réparateur automobile"
	SCE="Services"
	TRA="Transport";

 value dt
	1="Janvier"
	2="Février"
	3="Mars"
	4="Avril"
	5="Mai"
	6="Juin"
	7="Juillet"
	8="Août"
	9="Septembre"
	10="Octobre"
	11="Novembre"
	12="Décembre";

run;

/* Création de la table temporaire SCORING */

PROC SQL;
CREATE TABLE work.scoring AS
(SELECT ty_pp "Code usage du véhicule du PP (Personne Physique)",
	no_cnt_crypte "Identifiant du contrat crypté",
	no_par_crypte "Identifiant du client crypté",
	date_gest "Mois de la date de l'entrée en gestion", 
	dt_dmd "Date de la demande",
	month(dt_dmd/86400) AS dt_dmd_month "Mois de la demande" format dt.,
	intck('month',dt_dmd/86400, date_gest) AS periode "Nombre de périodes (en mois) entre la date de demande et la date de gestion" ,
	WE18 "Indicateur de défaut",
	DUREE "Durée prévisionelle du financement (Mois)",
	genre_veh "Genre du véhicule" format $genreveh.,
	MT_DMD/100 as mt_dmd "Montant du financement (en €)" format eurox10.2,
	PC_APPO/100 as PC_APPO "Pourcentage d'apport (%)" format percent8.2,
	produit "Type de produit" format $produit.,
	QUAL_VEH "Qualité du véhicule" format $quali.,
	AGE_VEH "Age du véhicule (Mois)",
	IND_CLI_RNVA "Indicateur client renouvelant" format $ind.,
	nb_imp_tot "Nombre d'impayés total",
	nb_imp_an_0 "Nombre d'impayés des 12 derniers mois",
	EVPM_COPOT_PAI_GLB "Evaluation du comportement de paiement" format evpmcopot.,
	EVPA_PRTC "Indicateur de fichage pour les PRO" format evpa.,
	EVPM_COTE "Evaluation cotation" format evpmcote.,
	COTE_BDF "Cotation de la Banque de France",
	age "Age du client (Années)",
	CSP "Classe socio-professionnelle" format $csp.,
	ETAT_CIVIL "Code état civil" format $etatcivil.,
	MODE_HABI "Code mode d'habitation" format $modehabi.,
	mt_sal_men/100 as mt_sal_men "Montant salaire mensuel (en €)" format eurox10.2,
	rev_men_autr/100 as rev_men_autr "Autre montant mensuel (en €)" format eurox10.2,
	mt_alloc_men/100 as mt_alloc_men "Montant de l'allocatio mensuelle (en €)" format eurox10.2,
	nb_pers_chg "Nombre de personnes à charge",
	mt_rev/100 as mt_rev "Montant revenu mensuel (en €)" format eurox10.2,
	mt_loy_men_mena/100 as mt_loy_men_mena "Montant loyer mensuel menage (en €)" format eurox10.2,
	mt_men_pre_immo/100 as mt_men_pre_immo "Montant mensuel du prêt immobilier (en €)" format eurox10.2,
	mt_men_eng_mena/100 as mt_men_eng_mena "Montant mensuel engagements divers ménage (en €)" format eurox10.2,
	mt_charges/100 as mt_charges "Montant des charges (centimes €)" format eurox10.2,
	ind_fch_fcc "Indicateur de fichage FCC" format $ind.,
	mt_ech/100 as mt_ech "Montant de l'échéance (en €)" format eurox10.2,
	mt_ttc_veh/100 as mt_ttc_veh "Prix du véhicule (en €)" format eurox10.2, 
	part_loyer/100 as part_loyer "Part de l'échéance (%)" format percent8.2,
	anc_emp "Ancienneté emploi (Mois)",
	copot_ "Comportement de paiement" format copot.,
	pan_dir_ "PAN dirigeant" format pandir.,
	secteur_ "Secteur d'activité" format $secteur.,
	diag_fch_cli "Indicateur de fichage pour les PRI" format $ind.,
	IND_IMP_REGU "Nombre d'impayés régularisés sur les derniers mois"
FROM scoring.base_financee_pp);
QUIT;


/* Nous choisissons d'appliquer des LABEL et des FORMAT pour une meilleure lisibilité */

/* ELIMINATION */

data scoring;
 set scoring;
  if periode<0 then delete;
run;


/* CRÉATION DE LA TABLE PRI */

PROC SQL;
CREATE TABLE work.pri AS
(SELECT date_gest, periode, dt_dmd_month, genre_veh, produit, QUAL_VEH, IND_CLI_RNVA, CSP, ETAT_CIVIL, MODE_HABI, ind_fch_fcc, copot_, pan_dir_, secteur_, diag_fch_cli,
	    No_cnt_crypte, No_par_crypte, DUREE, MT_DMD, PC_APPO, AGE_VEH, nb_imp_tot, nb_imp_an_0, age, mt_sal_men, rev_men_autr, mt_alloc_men, nb_pers_chg, MT_REV,
	  	mt_loy_men_mena, mt_men_pre_immo, mt_men_eng_mena, mt_charges, MT_ECH, mt_ttc_veh, part_loyer, anc_emp, we18 
FROM scoring
WHERE ty_pp="PRI");
QUIT;


/* Tri de la table */

/* Taux de souscription sur chaque échantillon : apprentissage (70%) et test (30%) */

PROC SORT data=pri;
  by we18;
RUN;

PROC SURVEYSELECT data=pri
				  outall
                  samprate=.70  				/* Proportion d'observation sélectionnée dans l'échantillon d'apprentissage */
                  out = pri(drop=selectionProb SamplingWeight)
                  method = srs  				/* Sélection équiprobable et sans remise  */
                  seed = 435 					/* Observation de départ puis sélection aléatoire */ 
				  NOPRINT;	
  strata we18;                          		/* Echantillon stratifié par rapport à la REPONSE */
RUN;

data train test (drop=selected);
 set pri;
  if selected=1 then output train;
  else output test;
run;

data defaut1 defaut0;
 set train;
  if we18=1 then output defaut1;
  else output defaut0;
run;

/* Undersampling */

proc sort data=defaut0;
 by etat_civil;
run;

PROC SURVEYSELECT data=defaut0
				  outall
                  samprate=.16233 				/* Proportion d'observation sélectionnée dans l'échantillon d'apprentissage */
                  out = defaut0(drop=selectionProb SamplingWeight)
                  method = srs  				/* Sélection équiprobable et sans remise  */
                  seed = 435 					/* Observation de départ puis sélection aléatoire */ 
				  NOPRINT;	
  strata etat_civil; 	
run;

data defaut0;
 set defaut0;
  if selected=1 then output;
run;

data train;
 set defaut1 defaut0;
run;

					/* ------------------------------------------------------------------- 
  						Analyse bivariée entre la variable à expliquer et les variables 
   						    explicatives candidates (quantitatives & qualitatives)          
 					   ------------------------------------------------------------------- */

					/* -------------------------------------------------------------------  
						  Liaison entre la variable CIBLE et les variables explicatives   
 	 					         qualitatives (test du khi + V de Cramer)                        
 					   ------------------------------------------------------------------- */

/* Significativité */

%macro quali1(data,var);
	title "Variable qualitative &var";
	proc freq data=&data ;
		table &var*we18 /chisq outpct out=freq_&var;
	run;
	
%mend quali1;

/* variables quali : periode dt_dmd_month genre_veh produit QUAL_VEH IND_CLI_RNVA CSP ETAT_CIVIL MODE_HABI ind_fch_fcc
					 copot_ pan_dir_ secteur_ diag_fch_cli */


%quali1(train, periode);				/* Khi-2 pas interprétable : recodage */    
%quali1(train, dt_dmd_month);			/* Non significatif */
%quali1(train, genre_veh);				/* 1 seule modalité sans valeur manquante, on peut donc la supprimer */
%quali1(train, produit);				/* Non significatif */
%quali1(train, qual_veh);				/* Significatif */
%quali1(train, ind_cli_rnva);		    /* Non significatif */
%quali1(train, csp);					/* Significatif */
%quali1(train, etat_civil);				/* Significatif */
%quali1(train, mode_habi);				/* Significatif */
%quali1(train, ind_fch_fcc);		    /* Quasi-complete separetion ,on peut donc la supprimer */
%quali1(train, copot_);		    		/* Significatif */
%quali1(train, pan_dir_);				/* Quasi-complete separetion ,on peut donc la supprimer*/
%quali1(train, secteur_);				/* Khi-2 pas interprétable : recodage */
%quali1(train, diag_fch_cli);	    	/* Quasi-complete separetion ,on peut donc la supprimer */


/* On peut donc déjà supprimer : dt_dmd_month genre_veh produit ind_cli_rnva ind_fch_fcc pan_dir_ diag_fch_cli */

/* Recodage */

proc freq data=train;
 tables periode secteur_ ;
run;


data train (drop=secteur_ periode);
 set train;

   length secteur $10.;
    if secteur_="AGR" then secteur="Primaire";
    if secteur_="BTP" or secteur_="FCP" or secteur_="FEM" then secteur="Secondaire";
    if secteur_="CDD" or secteur_="CDG" or secteur_="EAE"
     or secteur_="FBC" or secteur_="HOP" or secteur_="LOA" or secteur_="SCE" or secteur_="TRA" then secteur="Tertiaire";
    if secteur_="ATR" then secteur="Autres";

   length periodes $4.;
    if periode="0" then periodes="0";
    if periode="1" then periodes="1";
	if periode="2" or periode="3" or periode="4" or periode="5"
	or periode="6" or periode="7" or periode="8" or periode="25" then periodes=">=2";

run;

%quali1(train,secteur); 		/* Significatif */
%quali1(train,periodes);		/* Significatif */

/* On garde donc les variables :
 qual_veh csp secteur periodes etat_civil mode_habi copot_ */



							/* -------------------------------------------- 
											  V de Cramer 
		 					  -------------------------------------------- */



/* Test sur la table train, 

On regarde le degré de corrélation entre les variables qui sont significatives */

ods output ChiSq=ChiSq;

proc freq data=train;
  tables (qual_veh csp secteur periodes etat_civil mode_habi copot_)
        *(qual_veh csp secteur periodes etat_civil mode_habi copot_) / chisq;
run;

ods select all;

data ChiSq(keep=Table abs_V_Cramer);
  set ChiSq;
  where Statistic like '%Cramer%';
  abs_V_Cramer = ABS(Value);
run;

proc sort data=ChiSq; by descending abs_V_Cramer; run;
proc print data=ChiSq; run;


/* CSP et Secteur sont fortement corrélées ainsi que Qual_veh et periodes */

data essaie;
set train (keep=csp secteur);
run;

/* 	On remarque des incohérences entre les 2 variables comme des personnes travaillant dans catégorisé dans Agriculture (CSP) et Tertiaire (Secteur)
	Si on regarde de plus près avec l'ancienne variable secteur_, on remarque que cette personne est codé auto-école.
	Auto-école et Agriculture ne sont pas vraiment liées */

data essaie2;
set train (keep=qual_veh periodes);
run;

proc freq data=train;
 tables qual_veh*periodes;
run;

/* on remarque que pour les véhicules d'occasion, on a rarement une periodes supérieur à 1
   (nous verrons plus tard si nous pouvons les croiser */

/* on regarde la corrélation des variables auprès de we18 la variable de réponse pour savoir qui garder pour la suite */

ods output ChiSq=ChiSq2;

proc freq data=train;
  tables (qual_veh csp secteur periodes etat_civil mode_habi copot_)*we18 / chisq;
run;

ods select all;

data ChiSq2(keep=Table abs_V_Cramer);
 set ChiSq2;
  where Statistic like '%Cramer%';
  abs_V_Cramer = ABS(Value);
run;

proc sort data=ChiSq2; by descending abs_V_Cramer; run;
proc print data=ChiSq2; run;

data Select_quali(keep=Variable abs_V_Cramer Value);
 set ChiSq2;
  length Variable $32.;
  Variable = SCAN (Table,2) ; /* SCAN(Table,2) = 2e mot de la variable "Table" */
run;

proc print data=Select_quali; run;

/* 	On peut donc supprimer la variable secteur */

/* 	On garde donc pour le moment les variables : 
	qual_veh csp periodes etat_civil mode_habi copot_ */


						/* -------------------------------------------------------------------
							 Liaison entre la variable CIBLE et les variables explicatives   
     						  quantitatives (test de Student + Test de Kruskall-Wallis)       
 						   ------------------------------------------------------------------- */

/* Analyse des variables numériques :  

	No_cnt_crypte, No_par_crypte, DUREE, MT_DMD, PC_APPO, AGE_VEH, nb_imp_tot, nb_imp_an_0, age,
	mt_sal_men, rev_men_autr, mt_alloc_men, nb_pers_chg, MT_REV,mt_loy_men_mena, mt_men_pre_immo,
	mt_men_eng_mena, mt_charges, MT_ECH, mt_ttc_veh, part_loyer, anc_emp    */            


/* Analyse des distribution (normalité) : PROC UNIVARIATE */

%macro univ(data,var);
 title "DISTRIBUTION DE LA VARIABLE &VAR";
 proc univariate data=&data;
  var &var;
  histogram / normal    (l=1 color=red)
              cframe     = ligr
                          cfill      = yellow
              cframeside = ligr
              vaxis      = axis1
              name       = '&VAR';
  inset n mode(5.3) mean(5.3) std='Std Dev'(5.3)
        skewness(5.3) KURTOSIS(5.3)
        normal(ksdpval(5.3))
        / pos = ne  header = 'Statistiques' cfill = ywh;
  axis1 label=(a=90 r=0);
run;
title" ";
%mend univ;


%univ(pri,no_cnt_crypte);
%univ(pri,no_par_crypte);
%univ(pri,duree);
%univ(pri,mt_dmd);
%univ(pri,pc_appo);
%univ(pri,age_veh);
%univ(pri,nb_imp_tot);
%univ(pri,nb_imp_an_0);
%univ(pri,age);
%univ(pri,mt_sal_men);
%univ(pri,rev_men_autr);
%univ(pri,mt_alloc_men);
%univ(pri,nb_pers_chg);
%univ(pri,mt_rev);
%univ(pri,mt_loy_men_mena);
%univ(pri,mt_men_pre_immo);
%univ(pri,mt_men_eng_mena);
%univ(pri,mt_charges);
%univ(pri,mt_ech);
%univ(pri,mt_ttc_veh);
%univ(pri,part_loyer);
%univ(pri,anc_emp);


/* Aucune de ces variables ne suivent une loi normale */

/*  Comme les distributions ne suivent pas une loi normale, on utilise 
	le test non paramétrique de Kruskall-Wallis                            */

ods output KruskalWallisTest = kruskal;

proc npar1way Wilcoxon data=train;
  class we18;
  var No_cnt_crypte No_par_crypte DUREE MT_DMD PC_APPO AGE_VEH nb_imp_tot nb_imp_an_0 age
	  mt_sal_men rev_men_autr mt_alloc_men nb_pers_chg MT_REV mt_loy_men_mena
	  mt_men_pre_immo mt_men_eng_mena mt_charges MT_ECH mt_ttc_veh part_loyer anc_emp ;
run;

ods select all;

data kruskal(keep=Variable nValue1 rename=(nValue1=KWallis));
 set kruskal;
  where name1='_KW_';
run;

proc sort data=kruskal; by descending KWallis; run;
proc print data=kruskal; run;

proc means data=train n nmiss median mean min max;
 var nb_imp_tot;
run;

proc freq data=train;
 tables nb_imp_tot nb_imp_an_0;
run;

/* 	No_cnt_crypte : 	Extrêment arbitraire comme variable, on ne la garde pas
	No_par_crypte : 	on ne garde pas
	DUREE : 			on garde
	MT_DMD : 			on garde
	PC_APPO : 			on garde
	AGE_VEH : 			on garde
	nb_imp_tot : 		plus de 50% de valeurs manquantes on supprime
	nb_imp_an_0 : 		plus de 50% de valeurs manquantes on supprime
	age : mt_sal_men : 	on garde
	rev_men_autr : 		on ne garde pas
	mt_alloc_men : 		on garde
	nb_pers_chg :		on recode
	MT_REV : 			on garde
	mt_loy_men_mena : 	on garde
	mt_men_pre_immo : 	on garde
	mt_men_eng_mena : 	on ne garde pas
	mt_charges : 		on recode
	MT_ECH : 			on garde
	mt_ttc_veh : 		on garde
	part_loyer : 		on garde
	anc_emp : 			on garde 															*/



						/* ------------------------------------------------------------- 
						           - Traitement des variables canditates :                   
						           - Discrétisation des variables continues                  
						           - Recodage des variables qualitatives                     
						  ------------------------------------------------------------- */


								/* Discrétisation des variables continues 
								------------------------------------------ */


						/* Solution 1 : Discrétisation de la variable   
             							sans contrainte sur les déciles 
 						-------------------------------------------------- */


%macro discret1(table,var);
proc sort data=&table; by &var.; run;

data &table._bin;
  set &table(where=(&var. ne . and selected=1));
  rank=_n_;
run;

proc rank data=&table._bin groups=10
          out=bin&var.(keep=id rank we18 &var. bin&var.);
  var rank;
  ranks bin&var.;
run;

proc means data=bin&var. min max maxdec=1;
  var &var.;
  class bin&var.;
run;

proc means data=bin&var. mean maxdec=3;
  var we18;
  class bin&var.;
run;

proc freq data=bin&var.;
  table bin&var.*we18 / outpct chisq out=bin&var.2a;
run;

proc gchart data=bin&var.2a;
  vbar3d bin&var. / sumvar=pct_row midpoints=0 to 9 by 1;
  where we18 eq 1;
  title "Taux de souscription par decile sur la variable &var";
run;
quit;

proc delete data=&table._bin; run;
proc delete data=bin&var.; run;
proc delete data=bin&var.2a; run;
%mend discret1;


/* Application de la macro DISCRET1 */


/*%discret1(train,no_cnt_crypte);
%discret1(train,no_par_crypte);*/

%discret1(train,duree);
%discret1(train,mt_dmd);
%discret1(train,pc_appo);
%discret1(train,age_veh);
%discret1(train,age);
%discret1(train,mt_sal_men);
%discret1(train,mt_alloc_men);
%discret1(train,nb_pers_chg);
%discret1(train,mt_rev);
%discret1(train,mt_loy_men_mena);
%discret1(train,mt_men_pre_immo);
%discret1(train,mt_men_eng_mena);
%discret1(train,mt_charges);
%discret1(train,mt_ech);
%discret1(train,mt_ttc_veh);
%discret1(train,part_loyer);
%discret1(train,anc_emp);
%discret1(train,nb_imp_tot);
%discret1(train,nb_imp_an_0);


/* Regroupement de déciles sur les variables quantitatives */

/* On regroupe de manière à avoir des groupes comportant au moins 15% des observations */

data train;
 set train;

  length duree_cl1 $15.;
   if duree<=37 then duree_cl1="inférieur à 37";
   if 37<duree<=49 then duree_cl1="entre 37 et 49";
   if 49<duree<=60 then duree_cl1="entre 49 et 60";
   if duree>60 then duree_cl1="supérieur à 60";

  length mt_dmd_cl1 $25.;
   if mt_dmd<=8325 then mt_dmd_cl1="inférieur à 8325";
   if 8325<mt_dmd<=13000.4 then mt_dmd_cl1="entre 8325 et 13000.4";
   if 13000.4<mt_dmd<=17300 then mt_dmd_cl1="entre 13000.4 et 17300";
   if 17300<mt_dmd<=22000 then mt_dmd_cl1="entre 17300 et 22000";
   if mt_dmd>22000 then mt_dmd_cl1="supérieur à 22000";

  length pc_appo_cl1 $18.;
   if pc_appo<=0.1 then pc_appo_cl1="inférieur à 0.1";
   if 0.1<pc_appo<=0.3 then pc_appo_cl1="entre 0.1 et 0.3";
   if pc_appo>0.3 then pc_appo_cl1="supérieur à 0.3";

  length age_veh_cl1 $15.;
   if age_veh<=14 then age_veh_cl1="inférieur à 14";
   if age_veh>14 then age_veh_cl1="supérieur à 14";

  length age_cl1 $15.;
   if age<=38 then age_cl1="inférieur à 38";
   if 38<age<=45 then age_cl1="entre 38 et 45";
   if 45<age<=51 then age_cl1="entre 45 et 51";
   if 51<age<=57 then age_cl1="entre 51 et 57";
   if age>57 then age_cl1="supérieur à 57";

  length mt_sal_men_cl1 $20.;
   if mt_sal_men<=1275 then mt_sal_men_cl1="inférieur à 1275";
   if 1275<mt_sal_men<=2000 then mt_sal_men_cl1="entre 1275 et 2000";
   if 2000<mt_sal_men<=2900 then mt_sal_men_cl1="entre 2000 et 2900";
   if 2900<mt_sal_men<=4500 then mt_sal_men_cl1="entre 2900 et 4500";
   if mt_sal_men>4500 then mt_sal_men_cl1="supérieur à 4500";

  length mt_alloc_men_cl1 $15.;
   if mt_alloc_men=0 then mt_alloc_men_cl1="égal à 0";
   if mt_alloc_men>0 then mt_alloc_men_cl1="supérieur à 0";

  length nb_pers_chg_cl1 $15.;
   if nb_pers_chg=0 then nb_pers_chg_cl1="égal à 0";
   if nb_pers_chg=1 then nb_pers_chg_cl1="égal à 1";
   if nb_pers_chg=2 then nb_pers_chg_cl1="égal à 2";
   if nb_pers_chg>2 then nb_pers_chg_cl1="supérieur à 2";

  length mt_ech_cl1 $25.;
   if mt_ech<=192.7 then mt_ech_cl1="inférieur à 192.7";
   if 192.7<mt_ech<=264.8 then mt_ech_cl1="entre 192.7 et 264.8";
   if 264.8<mt_ech<=331.6 then mt_ech_cl1="entre 264.8 et 331.6";
   if 331.6<mt_ech<=417.1 then mt_ech_cl1="entre 331.6 et 417.1";
   if mt_ech>417.1 then mt_ech_cl1="supérieur à 417.1";

  length mt_rev_cl1 $20.;
   if mt_rev<1500 then mt_rev_cl1="inférieur à 1500";
   if 1500<mt_rev<=2100 then mt_rev_cl1="entre 1500 et 2100";
   if 2100<mt_rev<=3000 then mt_rev_cl1="entre 2100 et 3000";
   if 3000<mt_rev<=4749 then mt_rev_cl1="entre 3000 et 4749";
   if mt_rev>4749 then mt_rev_cl1="supérieur à 3000";

  length mt_loy_men_mena_cl1 $15.;
   if mt_loy_men_mena<=450 then mt_loy_men_mena_cl1="inférieur à 450";
   if mt_loy_men_mena>450 then mt_loy_men_mena_cl1="supérieur à 450";

  length mt_men_pre_immo_cl1 $15.;
   if mt_men_pre_immo<=500 then mt_men_pre_immo_cl1="inférieur à 500";
   if mt_men_pre_immo>500 then mt_men_pre_immo_cl1="supérieur à 500";

  length mt_men_eng_mena_cl1 $15.;
   if mt_men_eng_mena=0 then mt_men_eng_mena_cl1="égal à 0";
   if mt_men_eng_mena>0 then mt_men_eng_mena_cl1="supérieur à 0";

  length mt_charges_cl1 $20.;
   if mt_charges<=310 then mt_charges_cl1="inférieur à 310";
   if 310<mt_charges<=710 then mt_charges_cl1="entre 310 et 710";
   if mt_charges>710 then mt_charges_cl1="supérieur à 710";

  length mt_ttc_veh_cl1 $25.;
   if mt_ttc_veh<=13213.5 then mt_ttc_veh_cl1="inférieur à 13213.5";
   if 13213.5<mt_ttc_veh<=16716.8 then mt_ttc_veh_cl1="entre 13213.5 et 16716.8";
   if 16716.8<mt_ttc_veh<=20200 then mt_ttc_veh_cl1="entre 16716.8 et 20200";
   if 20200<mt_ttc_veh<=24742.7 then mt_ttc_veh_cl1="entre 20200 et 24742.7";
   if mt_ttc_veh>24742.7 then mt_ttc_veh_cl1="supérieur à 24742.7";

  length part_loyer_cl1 $20.;
   if part_loyer<=0.0170 then part_loyer_cl1="inférieur à 0.0170";
   if part_loyer>0.0170 then part_loyer_cl1="supérieur à 0.0170";

  length anc_emp_cl1 $20.; 
   if anc_emp<=33 then anc_emp_cl1="inférieur à 33";
   if 33<anc_emp<=69 then anc_emp_cl1="entre 33 et 69";
   if 69<anc_emp<=133 then anc_emp_cl1="entre 69 et 133";
   if 133<anc_emp<=253 then anc_emp_cl1="entre 133 et 253";
   if anc_emp>253 then anc_emp_cl1="supérieur à 253";

  length nb_imp_tot_cl1 $15.;
   if nb_imp_tot<=1 then nb_imp_tot_cl1="inférieur à 1";
   if nb_imp_tot>1 then nb_imp_tot_cl1="supérieur à 1";
   if nb_imp_tot=. then nb_imp_tot_cl1="N/A";

  length nb_imp_an_0_cl1 $15.;
   if nb_imp_an_0=0 then nb_imp_an_0_cl1="égal à 0";
   if nb_imp_an_0>0 then nb_imp_an_0_cl1="supérieur à 0";
   if nb_imp_an_0=. then nb_imp_an_0_cl1="N/A";

run;


/* Validation de la pertinence des regroupements opérés */

%macro valid(table,var);
proc freq data=&table noprint;
  table &var.*we18/ outpct out=temp;
run;

proc gchart data=temp;
  vbar3d &var. / sumvar=pct_row ;
  where we18 eq 1;
  title "Taux de souscription selon la variable &var.";
run;
quit;

proc freq data=&table;
  table &var.*we18 / chisq;
run;

proc delete data=temp; run;
%mend valid;

/* Application de la macro VALID */


%valid(train,duree_cl1);					/* Significatif */
%valid(train,mt_dmd_cl1);					/* Significatif */
%valid(train,pc_appo_cl1);					/* Significatif */
%valid(train,age_veh_cl1);					/* Significatif */
%valid(train,age_cl1);						/* Significatif */
%valid(train,mt_sal_men_cl1);				/* Significatif */
%valid(train,mt_alloc_men_cl1);				/* Significatif */
%valid(train,nb_pers_chg_cl1);				/* Significatif */
%valid(train,mt_rev_cl1);					/* Significatif */
%valid(train,mt_loy_men_mena_cl1);			/* Significatif */
%valid(train,mt_men_pre_immo_cl1);			/* Significatif */
%valid(train,mt_men_eng_mena_cl1);			/* Non significatif */
%valid(train,mt_charges_cl1);				/* Significatif */
%valid(train,mt_ech_cl1);					/* Significatif */
%valid(train,mt_ttc_veh_cl1);				/* Significatif */
%valid(train,part_loyer_cl1);				/* Significatif */
%valid(train,anc_emp_cl1);					/* Significatif */
%valid(train,nb_imp_tot_cl1);				/* Significatif */
%valid(train,nb_imp_an_0_cl1);				/* Significatif */


/* On peut donc supprimer mt_men_eng_mena_cl1 */


								/* Solution 2 : Discrétisation de la variable sous  
              									contrainte de déciles sur CIBLE = 1 
  								----------------------------------------------------- */


%macro discret2(table,var);
proc sort data=&table; by &var.; run;

data &table._a forbin;
  set &table(where=(selected=1));
  count=_n_-1;
  output &table._a;
  if &var. ne . and we18=1 then output forbin;
run;

proc sort data=&table._a; by count; run;
proc sort data=forbin;  by count; run;

proc rank data=forbin groups=10
          out=class(keep=id we18 &var. count classes);
  var count;
  ranks classes;
run;

data &table._a;
  retain class_&var.;
  merge &table._a (in=a) class (in=b);
  if a and b then do;
  class_&var.=classes;
  end;
  if a and not b then do;
        if &var. eq . then class_&var.=.;
        end;
  by count;
  if &var. ne . and class_&var.=. then class_&var.=0;
run;

proc means data=&table._a min max maxdec=1;
  var &var ;
  class class_&var;
run;

proc means data=&table._a mean maxdec=3;
  var we18;
  class class_&var;
run;

proc freq data=&table._a;
  table class_&var*we18 / out=freq_&var outpct missing;
run;

proc gchart data=freq_&var;
  vbar3d class_&var / sumvar=pct_row midpoints=0 to 9 by 1;
  where we18=1;
  title1 "Taux de souscription par decile sur la variable &var.";
  title2 "sous contrainte des quantiles calcules sur WE18=1";
run;
quit;

proc delete data=freq_&var; run;
proc delete data=&table._a; run;
proc delete data=forbin; run;
proc delete data=class; run;
%mend discret2;

/* Application de la macro DISCRET2 */

%discret2(train,duree);
%discret2(train,mt_dmd);
%discret2(train,pc_appo);
%discret2(train,age_veh);
%discret2(train,age);
%discret2(train,mt_sal_men);
%discret2(train,mt_alloc_men);
%discret2(train,nb_pers_chg);
%discret2(train,mt_rev);
%discret2(train,mt_loy_men_mena);
%discret2(train,mt_men_pre_immo);
%discret2(train,mt_men_eng_mena);
%discret2(train,mt_charges);
%discret2(train,mt_ech);
%discret2(train,mt_ttc_veh);
%discret2(train,part_loyer);
%discret2(train,anc_emp);
%discret2(train,nb_imp_tot);
%discret2(train,nb_imp_an_0);

/* Regroupement de déciles sur les variables quantitatives */

data train;
set train;
 length duree_cl2 $15.;
  if duree<=37 then duree_cl2="inférieur à 37";
  if 37<duree<=49 then duree_cl2="entre 37 et 49";
  if 49<duree<=60 then duree_cl2="entre 49 et 60";
  if duree>60 then duree_cl2="supérieur à 60";

 length mt_dmd_cl2 $25.;
  if mt_dmd<=8571.1 then mt_dmd_cl2="inférieur à 8571.1";
  if 8571.5<mt_dmd<=12400 then mt_dmd_cl2="entre 8571.1 et 12400";
  if 12400<mt_dmd<=17260.4 then mt_dmd_cl2="entre 12400 et 17260.4";
  if 17260.4<mt_dmd<=22500 then mt_dmd_cl2="entre 17260.4 et 22500";
  if mt_dmd>22500 then mt_dmd_cl2="supérieur à 22500";

 length pc_appo_cl2 $18.;
  if pc_appo<0.1 then pc_appo_cl2="inférieur à 0.1";
  if 0.1<=pc_appo<=0.3 then pc_appo_cl2="entre 0.1 et 0.3";
  if pc_appo>0.3 then pc_appo_cl2="supérieur à 0.3";

 length age_veh_cl2 $15.;
  if age_veh<=12 then age_veh_cl2="inférieur à 12";
  if age_veh>12 then age_veh_cl2="supérieur à 12";

 length age_cl2 $15.;
  if age<=36 then age_cl2="inférieur à 36";
  if 36<age<=45 then age_cl2="entre 36 et 45";
  if 45<age<=51 then age_cl2="entre 45 et 51";
  if 51<age<=59 then age_cl2="entre 51 et 59";
  if age>59 then age_cl2="supérieur à 59";

 length mt_sal_men_cl2 $25.;
  if mt_sal_men<=1216.8 then mt_sal_men_cl2="inférieur à 1216.8";
  if 1216.8<mt_sal_men<=1800 then mt_sal_men_cl2="entre 1216.8 et 1800";
  if 1800<mt_sal_men<=2400 then mt_sal_men_cl2="entre 1800 et 2400";
  if 2400<mt_sal_men<=3500 then mt_sal_men_cl2="entre 2400 et 3500";
  if mt_sal_men>3500 then mt_sal_men_cl2="supérieur à 3500";

 length mt_alloc_men_cl2 $15.;
  if mt_alloc_men=0 then mt_alloc_men_cl2="égal à 0";
  if mt_alloc_men>0 then mt_alloc_men_cl2="supérieur à 0";

 length nb_pers_chg_cl2 $15.;
  if nb_pers_chg=0 then nb_pers_chg_cl2="égal à 0";
  if nb_pers_chg=1 then nb_pers_chg_cl2="égal à 1";
  if nb_pers_chg=2 then nb_pers_chg_cl2="égal à 2";
  if nb_pers_chg>2 then nb_pers_chg_cl2="supérieur à 2";

 length mt_ech_cl2 $25.;
  if mt_ech<=191.3 then mt_ech_cl2="inférieur à 191.3";
  if 191.3<mt_ech<=275.4 then mt_ech_cl2="entre 191.3 et 275.4";
  if 275.4<mt_ech<=340 then mt_ech_cl2="entre 275.4 et 340";
  if 340<mt_ech<=431.9 then mt_ech_cl2="entre 340 et 431.9";
  if mt_ech>431.9 then mt_ech_cl2="supérieur à 431.9";

 length mt_rev_cl2 $25.;
  if mt_rev<1450 then mt_rev_cl2="inférieur à 1450";
  if 1450<mt_rev<=1958.3 then mt_rev_cl2="entre 1450 et 1958.3";
  if 1958.3<mt_rev<=2590 then mt_rev_cl2="entre 1958.3 et 2590";
  if 2590<mt_rev<=3600 then mt_rev_cl2="entre 2590 et 3600";
  if mt_rev>3600 then mt_rev_cl2="supérieur à 3600";

 length mt_loy_men_mena_cl2 $15.;
  if mt_loy_men_mena<=298 then mt_loy_men_mena_cl2="inférieur à 298";
  if mt_loy_men_mena>298 then mt_loy_men_mena_cl2="supérieur à 298";

 length mt_men_pre_immo_cl2 $15.;
  if mt_men_pre_immo<=500 then mt_men_pre_immo_cl2="inférieur à 500";
  if mt_men_pre_immo>500 then mt_men_pre_immo_cl2="supérieur à 500";

 length mt_men_eng_mena_cl2 $15.;
  if mt_men_eng_mena=0 then mt_men_eng_mena_cl2="égal à 0";
  if mt_men_eng_mena>0 then mt_men_eng_mena_cl2="supérieur à 0";

 length mt_charges_cl2 $20.;
  if mt_charges<=222 then mt_charges_cl2="inférieur à 222";
  if 222<mt_charges<=590 then mt_charges_cl2="entre 222 et 590";
  if mt_charges>590 then mt_charges_cl2="supérieur à 590";

 length mt_ttc_veh_cl2 $25.;
  if mt_ttc_veh<=13966.5 then mt_ttc_veh_cl2="inférieur à 13966.5";
  if 13966.5<mt_ttc_veh<=16965.2 then mt_ttc_veh_cl2="entre 13966.5 et 16965.2";
  if 16965.2<mt_ttc_veh<=21070.8 then mt_ttc_veh_cl2="entre 16965.2 et 21070.8";
  if mt_ttc_veh>21070.8 then mt_ttc_veh_cl2="supérieur à 21070.8";

 length part_loyer_cl2 $20.;
  if part_loyer<=0.0170 then part_loyer_cl2="inférieur à 0.0170";
  if part_loyer>0.0170 then part_loyer_cl2="supérieur à 0.0170";

 length anc_emp_cl2 $20.;
  if anc_emp<=30 then anc_emp_cl0="inférieur à 30";
  if 30<anc_emp<=59 then anc_emp_cl2="entre 30 et 59";
  if 59<anc_emp<=102 then anc_emp_cl2="entre 59 et 102";
  if 102<anc_emp<=219 then anc_emp_cl2="entre 102 et 219";
  if anc_emp>219 then anc_emp_cl2="supérieur à 219";

 length nb_imp_tot_cl2 $15.;
  if nb_imp_tot=0 then nb_imp_tot_cl2="égal à 0";
  if nb_imp_tot>2 then nb_imp_tot_cl2="supérieur à 0";
  if nb_imp_tot=. then nb_imp_tot_cl2="N/A";

 length nb_imp_an_0_cl2 $15.;
  if nb_imp_an_0=0 then nb_imp_an_0_cl2="égal à 0";
  if nb_imp_an_0>0 then nb_imp_an_0_cl2="supérieur à 0";
  if nb_imp_an_0=. then nb_imp_an_0_cl2="N/A";

run;


%valid(train,duree_cl2);					/* Significatif */
%valid(train,mt_dmd_cl2);					/* Significatif */
%valid(train,pc_appo_cl2);					/* Significatif */
%valid(train,age_veh_cl2);					/* Significatif */
%valid(train,age_cl2);						/* Significatif */
%valid(train,mt_sal_men_cl2);				/* Significatif */
%valid(train,mt_alloc_men_cl2);				/* Significatif */
%valid(train,nb_pers_chg_cl2);				/* Significatif */
%valid(train,mt_rev_cl2);					/* Significatif */
%valid(train,mt_loy_men_mena_cl2);			/* Significatif */
%valid(train,mt_men_pre_immo_cl2);			/* Significatif */
%valid(train,mt_men_eng_mena_cl2);			/* Non significatif */
%valid(train,mt_charges_cl2);				/* Significatif */
%valid(train,mt_ech_cl2);					/* Significatif */
%valid(train,mt_ttc_veh_cl2);				/* Significatif */
%valid(train,part_loyer_cl2);				/* Significatif */
%valid(train,anc_emp_cl2);					/* Significatif */
%valid(train,nb_imp_tot_cl2);				/* Significatif */
%valid(train,nb_imp_an_0_cl2);				/* Significatif */


/* On peut donc supprimer mt_men_eng_mena_cl2 */

/* quali2 : duree_cl2 mt_dmd_cl2 pc_appo_cl2 age_veh_cl2 age_cl2 mt_sal_men_cl2 mt_alloc_men_cl2 nb_pers_chg_cl2 mt_rev_cl2
			me_men_pre_immo_cl2 mt_loy_men_mena_cl2 mt_charges_cl2 mt_ech_cl2 mt_ttc_veh_cl2 part_loyer_cl2 anc_emp_cl2
		   	nb_imp_tot_cl2 nb_imp_an_0_cl2 */ 


/* On regarde la colinéarité entre les variables quali en ajoutant les variables discrétisées */


/* les varaibles duree_cl2 mt_alloc_men_cl2 nb_pers_chg_cl2  mt_men_pre_immo_cl2 part_loyer_cl2 nb_imp_an_0_cl2
   sont supprimées car discrétisées de la même façon que les cl1 */

ods output ChiSq=ChiSq3;

proc freq data=train;
  tables ( qual_veh csp periodes etat_civil mode_habi copot_

		   duree_cl1 mt_dmd_cl1 pc_appo_cl1 age_veh_cl1 age_cl1 mt_sal_men_cl1 
		   mt_alloc_men_cl1 nb_pers_chg_cl1 mt_rev_cl1 mt_loy_men_mena_cl1
		   mt_men_pre_immo_cl1 mt_charges_cl1 mt_ttc_veh_cl1 part_loyer_cl1 anc_emp_cl1 nb_imp_tot_cl1

		   nb_imp_an_0_cl1 mt_ech_cl1 mt_dmd_cl2 pc_appo_cl2 age_veh_cl2 age_cl2 mt_sal_men_cl2 mt_rev_cl2
		   mt_loy_men_mena_cl2 mt_charges_cl2 mt_ech_cl2 mt_ttc_veh_cl2 anc_emp_cl2 nb_imp_tot_cl2)

    *	( qual_veh csp secteur periodes etat_civil mode_habi copot_

		   duree_cl1 mt_dmd_cl1 pc_appo_cl1 age_veh_cl1 age_cl1 mt_sal_men_cl1
		   mt_alloc_men_cl1 nb_pers_chg_cl1 mt_rev_cl1 mt_loy_men_mena_cl1
		   mt_men_pre_immo_cl1 mt_charges_cl1 mt_ttc_veh_cl1 part_loyer_cl1 anc_emp_cl1 nb_imp_tot_cl1

		   nb_imp_an_0_cl1 mt_ech_cl1 mt_dmd_cl2 pc_appo_cl2 age_veh_cl2 age_cl2 mt_sal_men_cl2 mt_rev_cl2
		   mt_loy_men_mena_cl2 mt_charges_cl2 mt_ech_cl2 mt_ttc_veh_cl2 anc_emp_cl2
		   nb_imp_tot_cl2) / chisq;
run;

ods select all;

data ChiSq3(keep=Table abs_V_Cramer);
 set ChiSq3;
  where Statistic like '%Cramer%';
  abs_V_Cramer = ABS(Value);
run;

proc sort data=ChiSq3; by descending abs_V_Cramer; run;
proc print data=ChiSq3; run;


ods output ChiSq=ChiSq4;

proc freq data=train;
  tables ( qual_veh csp periodes etat_civil mode_habi copot_

		   duree_cl1 mt_dmd_cl1 pc_appo_cl1 age_veh_cl1 age_cl1 mt_sal_men_cl1
		   mt_alloc_men_cl1 nb_pers_chg_cl1 mt_rev_cl1 mt_loy_men_mena_cl1
		   mt_men_pre_immo_cl1 mt_charges_cl1 mt_ttc_veh_cl1 part_loyer_cl1 anc_emp_cl1 nb_imp_tot_cl1

		   nb_imp_an_0_cl1 mt_dmd_cl2 pc_appo_cl2 age_veh_cl2 age_cl2 mt_sal_men_cl2 mt_rev_cl2
		   mt_loy_men_mena_cl2 mt_charges_cl2 mt_ech_cl2 mt_ttc_veh_cl2 anc_emp_cl2
		   nb_imp_tot_cl2 ) * we18 / chisq;
run;

ods select all;

data ChiSq4(keep=Table abs_V_Cramer);
 set ChiSq4;
  where Statistic like '%Cramer%';
  abs_V_Cramer = ABS(Value);
run;

proc sort data=ChiSq4; by descending abs_V_Cramer; run;
proc print data=ChiSq4; run;

data Select_quali2(keep=Variable abs_V_Cramer Value);
 set ChiSq4;
  length Variable $32.;
  Variable = SCAN (Table,2) ; /* SCAN(Table,2) = 2e mot de la variable "Table" */
run;

proc print data=Select_quali2; run;


/* On a un aperçu des variables fortement corrélées avec we18 */

/* On peut déjà se séparer des variables :
 	nb_imp_tot_cl1 pc_appo_cl2 mt_rev_cl2 anc_emp_cl2 mt_dmd_cl2
 	age_cl1 mt_loy_men_mena_cl1 mt_sal_men_cl2
	age_veh_cl2 mt_ttc_veh_cl2 mt_charges_cl1 */



								/* --------------------------------------------
									 Corrélation entre variables qualitatives 
								   -------------------------------------------- */


/* On recommence ce qui a été fait précédement */

ods output ChiSq=ChiSq5;

proc freq data=train;
  tables ( qual_veh csp periodes etat_civil mode_habi copot_

		   duree_cl1 mt_dmd_cl1 pc_appo_cl1 age_veh_cl1 mt_sal_men_cl1 
		   mt_alloc_men_cl1 nb_pers_chg_cl1 mt_rev_cl1 mt_men_pre_immo_cl1
		   mt_ttc_veh_cl1 part_loyer_cl1 anc_emp_cl1 nb_imp_an_0_cl1 

		   age_cl2 mt_sal_men_cl2  mt_loy_men_mena_cl2 mt_charges_cl2 mt_ech_cl2 nb_imp_tot_cl2 )

    *	 ( qual_veh csp periodes etat_civil mode_habi copot_

		   duree_cl1 mt_dmd_cl1 pc_appo_cl1 age_veh_cl1 mt_sal_men_cl1 
		   mt_alloc_men_cl1 nb_pers_chg_cl1 mt_rev_cl1 mt_men_pre_immo_cl1
		   mt_ttc_veh_cl1 part_loyer_cl1 anc_emp_cl1 nb_imp_an_0_cl1

		   age_cl2 mt_loy_men_mena_cl2 mt_charges_cl2 mt_ech_cl2 nb_imp_tot_cl2 ) / chisq;
run;

ods select all;

data ChiSq5(keep=Table abs_V_Cramer);
 set ChiSq5;
  where Statistic like '%Cramer%';
  abs_V_Cramer = ABS(Value);
run;

proc sort data=ChiSq5; by descending abs_V_Cramer; run;
proc print data=ChiSq5; run;

data Select_quali3(keep=Variable1 Variable2 abs_V_Cramer);
 set ChiSq5;
  length Variable1 $32.;
  length Variable2 $32.;
  Variable1 = SCAN (Table,2) ; /* SCAN(Table,2) = 2e mot de la variable "Table" */
  Variable2 = SCAN (Table,3) ; /* SCAN(Table,4) = 4e mot de la variable "Table" */
run;

/* Elimination des paires redondantes */

data Select_quali3;
 set Select_quali3;
  where variable1 < variable2;
run;

proc sort data=Select_quali3;
  by descending abs_V_Cramer;
run;

proc print data=Select_quali3;
  var variable1 variable2 abs_V_Cramer;
run;

/*  mode_habi et mt_loy_men_mena_cl2 					0.89132
	nb_imp_an_0_cl1 et nb_imp_tot_cl2 					0.85281
	mt_charges_cl2 et mt_men_pre_immo_cl1 				0.78277
	mt_rev_cl1 et mt_sal_men_cl1 						0.78024
	qual_veh et age_veh_cl1 							0.77520
	copot_ et nb_imp_tot_cl2 							0.70711
	copot_ et nb_imp_an_cl1 							0.53789
	mt_dmd_cl1 et pc_appo_cl1 							0.53065
	mt_dmd_cl1 et mt_ttc_veh_cl1 						0.51531
	mt_dmd_cl1 et mt_ech_cl 							0.50557
	mt_charges_cl2 et mt_loy_men_mena_cl2				0.50454
	qual_veh et mt_dmd_cl1 								0.47461
	age_veh_cl1 et mt_ttc_veh_cl1 						0.46933
	age_veh_cl1 et mt_dmd_cl1 							0.44234
	mt_ech_cl2 et mt_ttc_veh_cl1 						0.40097 
 	qual_veh et mt_ttc_veh_cl1 							0.39632
	mt_ech_cl2 et pc_appo_cl1 							0.37995
	mt_ech_cl2 et part_loyer_cl1 						0.35911
	mode_habi et mt_charges_cl2 						0.35809
	qual_veh et periodes 								0.33999
	qual_veh et duree_cl1 								0.33509
	part_loyer_cl1 et pc_appo_cl1 						0.32949
	duree_cl1 et pc_appo_cl1 							0.31892
	age_veh_cl1 et mt_ech_cl2 							0.31298
	qual_veh et mt_ech_cl2 								0.31282
*/

/* On croise les variables qual_veh et périodes pour éviter la corrélation */

data train;
set train;

 length qvperiode $ 13.;
  if qual_veh="VN" and periodes="0" then qvperiode="VN periode 0";
  if qual_veh="VN" and periodes="1" then qvperiode="VN periode 1";
  if qual_veh="VN" and periodes=">=2" then qvperiode="VN periode>=2"; 
  if qual_veh="VO" and periodes="0" then qvperiode="VO periode 0";
  if qual_veh="VO" and periodes="1" then qvperiode="VO periode 1";
  if qual_veh="VO" and periodes=">=2" then qvperiode="VO periode>=2";

run;

ods output ChiSq=ChiSq6;

proc freq data=train;
  tables ( csp etat_civil mode_habi copot_ qvperiode

		   duree_cl1 mt_dmd_cl1 pc_appo_cl1 age_veh_cl1 mt_sal_men_cl1 
		   mt_alloc_men_cl1 nb_pers_chg_cl1 mt_rev_cl1 mt_men_pre_immo_cl1
		   mt_ttc_veh_cl1 part_loyer_cl1 anc_emp_cl1 nb_imp_an_0_cl1 

		   age_cl2 mt_loy_men_mena_cl2 mt_charges_cl2 mt_ech_cl2 nb_imp_tot_cl2)

    *	 ( csp etat_civil mode_habi copot_ qvperiode

		   duree_cl1 mt_dmd_cl1 pc_appo_cl1 age_veh_cl1 mt_sal_men_cl1 
		   mt_alloc_men_cl1 nb_pers_chg_cl1 mt_rev_cl1 mt_men_pre_immo_cl1
		   mt_ttc_veh_cl1 part_loyer_cl1 anc_emp_cl1 nb_imp_an_0_cl1

		   age_cl2 mt_loy_men_mena_cl2 mt_charges_cl2 mt_ech_cl2 nb_imp_tot_cl2 ) / chisq;
run;

ods select all;

data ChiSq6(keep=Table abs_V_Cramer);
 set ChiSq6;
  where Statistic like '%Cramer%';
  abs_V_Cramer = ABS(Value);
run;

proc sort data=ChiSq6; by descending abs_V_Cramer; run;
proc print data=ChiSq6; run;

data Select_quali4(keep=Variable1 Variable2 abs_V_Cramer);
 set ChiSq6;
  length Variable1 $32.;
  length Variable2 $32.;
  Variable1 = SCAN (Table,2) ; /* SCAN(Table,2) = 2e mot de la variable "Table" */
  Variable2 = SCAN (Table,3) ; /* SCAN(Table,4) = 4e mot de la variable "Table" */
run;

/* Elimination des paires redondantes
   ---------------------------------- */

data Select_quali4;
 set Select_quali4;
  where variable1 < variable2;
run;

proc sort data=Select_quali4;
  by descending abs_V_Cramer;
run;

proc print data=Select_quali4;
  var variable1 variable2 abs_V_Cramer;
run;

/*  mode_habi et mt_loy_men_mena_cl2 					0.89132
	nb_imp_an_0_cl1 et nb_imp_tot_cl2 					0.85281
	mt_charges_cl2 et mt_men_pre_immo_cl1 				0.78277
	mt_rev_cl1 et mt_sal_men_cl1 						0.78024
	age_veh_cl1 et qvperiode 							0.77565
	copot_ et nb_imp_tot_cl2 							0.70711
	copot_ et nb_imp_an_0_cl1 							0.53789
	mt_dmd_cl1 et pc_appo_cl1 							0.53065
	mt_dmd_cl1 et mt_ttc_veh_cl1 						0.51531
	mt_dmd_cl1 et mt_ech_cl 							0.50557
	mt_charges_cl2 et mt_loy_men_mena_cl2				0.50454
	age_veh_cl1 et mt_ttc_veh_cl1 						0.46933
	age_veh_cl1 et mt_dmd_cl1 							0.44234
	mt_ech_cl2 et mt_ttc_veh_cl1 						0.40097 
	mt_ech_cl2 et pc_appo_cl1 							0.37995
	mt_ech_cl2 et part_loyer_cl1 						0.35911
	mode_habi et mt_charges_cl2 						0.35809
	part_loyer_cl1 et pc_appo_cl1 						0.32949
	duree_cl1 et pc_appo_cl1 							0.31892
	age_veh_cl1 et mt_ech_cl2 							0.31298
*/

/* Importance des varaibles par rapport à la variable WE18 */

ods output ChiSq=ChiSq7;

proc freq data=train;
  tables ( csp etat_civil mode_habi copot_ qvperiode

		   duree_cl1 mt_dmd_cl1 pc_appo_cl1 age_veh_cl1 mt_sal_men_cl1 
		   mt_alloc_men_cl1 nb_pers_chg_cl1 mt_rev_cl1 mt_men_pre_immo_cl1
		   mt_ttc_veh_cl1 part_loyer_cl1 anc_emp_cl1 nb_imp_an_0_cl1

		   age_cl2 mt_loy_men_mena_cl2 mt_charges_cl2 mt_ech_cl2 nb_imp_tot_cl2 )* we18 / chisq;
run;

ods select all;

data ChiSq7(keep=Table abs_V_Cramer);
 set ChiSq7;
  where Statistic like '%Cramer%';
  abs_V_Cramer = ABS(Value);
run;

proc sort data=ChiSq7; by descending abs_V_Cramer; run;
proc print data=ChiSq7; run;

data Select_quali5(keep=Variable abs_V_Cramer);
 set ChiSq7;
  length Variable $32.;
  Variable = SCAN (Table,2) ; /* SCAN(Table,2) = 2e mot de la variable "Table" */
run;


/* 	On peut déjà se séparer des variables :
  	mt_loy_men_mena_cl2 nb_imp_tot_cl2 copot_ mt_men_pre_immo mt_sal_men_cl1 age_veh_cl1
	mt_dmd_cl1 mt_ttc_veh_cl1 mt_ech_cl2	*/



								/* ------------------------------------------ 
   									 Modélisation : régression logistique 
      								   sur choix des variables définies 
								   ------------------------------------------ */


proc logistic data=train;
 class    csp etat_civil mode_habi qvperiode

		   duree_cl1 mt_alloc_men_cl1 nb_pers_chg_cl1 mt_rev_cl1 
		   mt_men_pre_immo_cl1 part_loyer_cl1 anc_emp_cl1 nb_imp_an_0_cl1

		   age_cl2 mt_charges_cl2  / param=ref ;

  model we18(event='1') = csp etat_civil mode_habi qvperiode

		   duree_cl1 mt_alloc_men_cl1 nb_pers_chg_cl1 mt_rev_cl1 
		   mt_men_pre_immo_cl1 part_loyer_cl1 anc_emp_cl1 nb_imp_an_0_cl1

		   age_cl2 mt_charges_cl2	/ selection=stepwise;
run;


/* Le Stepwise nous dit de garder les varaibles : 
 Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1 */



proc logistic data=train;
  class   Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1 / param=ref ;
  model we18(event='1') =  Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1 ;
run;

/* Corrélation */

ods output chisq=chisq8;

proc freq data=train;
tables ( Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1)
*( Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1) / chisq;
run;

ods select all;

data ChiSq8(keep=Table abs_V_Cramer);
 set ChiSq8;
  where Statistic like '%Cramer%';
  abs_V_Cramer = ABS(Value);
run;

data Select_quali6(keep=Variable1 Variable2 abs_V_Cramer);
 set ChiSq8;
  length Variable1 $32.;
  length Variable2 $32.;
  Variable1 = SCAN (Table,2) ; /* SCAN(Table,2) = 2e mot de la variable "Table" */
  Variable2 = SCAN (Table,3) ; /* SCAN(Table,4) = 4e mot de la variable "Table" */
run;


/* Elimination des paires redondantes
   ---------------------------------- */

data Select_quali6;
 set Select_quali6;
  where variable1 < variable2;
run;

proc sort data=Select_quali6;
  by descending abs_V_Cramer;
run;

proc print data=Select_quali6;
  var variable1 variable2 abs_V_Cramer;
run;

/* Plus de corrélation */

/* On garde donc les variables :
 Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1*/


**************************************************************************************************************************************
**************************************************************************************************************************************
**************************************************************************************************************************************
**************************************************************************************************************************************
**************************************************************************************************************************************;


data train;
 set train;
  length duree_cl1 $15.;
   if duree<=37 then duree_cl1="inférieur à 37";
   if 37<duree<=49 then duree_cl1="entre 37 et 49";
   if 49<duree<=60 then duree_cl1="entre 49 et 60";
   if duree>60 then duree_cl1="supérieur à 60";

  length part_loyer_cl1 $20.;
   if part_loyer<=0.0170 then part_loyer_cl1="inférieur à 0.0170";
   if part_loyer>0.0170 then part_loyer_cl1="supérieur à 0.0170";

  length nb_pers_chg_cl1 $15.;
   if nb_pers_chg=0 then nb_pers_chg_cl1="égal à 0";
   if nb_pers_chg=1 then nb_pers_chg_cl1="égal à 1";
   if nb_pers_chg=2 then nb_pers_chg_cl1="égal à 2";
   if nb_pers_chg>2 then nb_pers_chg_cl1="supérieur à 2";

  length anc_emp_cl1 $20.;
   if anc_emp<=33 then anc_emp_cl1="inférieur à 33";
   if 33<anc_emp<=69 then anc_emp_cl1="entre 33 et 69";
   if 69<anc_emp<=133 then anc_emp_cl1="entre 69 et 133";
   if 133<anc_emp<=253 then anc_emp_cl1="entre 133 et 253";
   if anc_emp>253 then anc_emp_cl1="supérieur à 253";

  length nb_imp_an_0_cl1 $15.;
   if nb_imp_an_0=0 then nb_imp_an_0_cl1="égal à 0";
   if nb_imp_an_0>0 then nb_imp_an_0_cl1="supérieur à 0";
   if nb_imp_an_0=. then nb_imp_an_0_cl1="N/A";
run;

 /* On crée la table train avec les variables sélectionnées */

proc sql;
create table work.train as(
select Duree_cl1, part_loyer_cl1, csp, etat_civil, mode_habi, nb_pers_chg_cl1, anc_emp_cl1, nb_imp_an_0_cl1, we18
from work.train);
quit;


/* On discrétise les variables selectionnés dans test */

data test;
 set test;

  length duree_cl1 $15.;
   if duree<=37 then duree_cl1="inférieur à 37";
   if 37<duree<=49 then duree_cl1="entre 37 et 49";
   if 49<duree<=60 then duree_cl1="entre 49 et 60";
   if duree>60 then duree_cl1="supérieur à 60";

  length part_loyer_cl1 $20.;
   if part_loyer<=0.0170 then part_loyer_cl1="inférieur à 0.0170";
   if part_loyer>0.0170 then part_loyer_cl1="supérieur à 0.0170";

  length nb_pers_chg_cl1 $15.;
   if nb_pers_chg=0 then nb_pers_chg_cl1="égal à 0";
   if nb_pers_chg=1 then nb_pers_chg_cl1="égal à 1";
   if nb_pers_chg=2 then nb_pers_chg_cl1="égal à 2";
   if nb_pers_chg>2 then nb_pers_chg_cl1="supérieur à 2";

  length anc_emp_cl1 $20.;
   if anc_emp<=33 then anc_emp_cl1="inférieur à 33";
   if 33<anc_emp<=69 then anc_emp_cl1="entre 33 et 69";
   if 69<anc_emp<=133 then anc_emp_cl1="entre 69 et 133";
   if 133<anc_emp<=253 then anc_emp_cl1="entre 133 et 253";
   if anc_emp>253 then anc_emp_cl1="supérieur à 253";

  length nb_imp_an_0_cl1 $15.;
   if nb_imp_an_0=0 then nb_imp_an_0_cl1="égal à 0";
   if nb_imp_an_0>0 then nb_imp_an_0_cl1="supérieur à 0";
   if nb_imp_an_0=. then nb_imp_an_0_cl1="N/A";

run;

 /* On crée la table test avec les variables sélectionner */

proc sql;
create table work.test as(
select Duree_cl1, part_loyer_cl1, csp, etat_civil, mode_habi, nb_pers_chg_cl1, anc_emp_cl1, nb_imp_an_0_cl1, we18
from work.test);
quit;

								/* -------------------------------------------- 
												Modélisation 
								 --------------------------------------------*/


/* On modélise une régression logistique avec les variables sélectionner */

ods output Logistic.ScoreFitStat=AUC_test; 
proc logistic data=train outest=est ;
	class Duree_cl1 (ref="entre 37 et 49") part_loyer_cl1 (ref="inférieur à 0.0170") csp (ref="Professions libérales") etat_civil (ref="Marié") 
          mode_habi (ref="Propriétaire") nb_pers_chg_cl1 (ref="égal à 0") anc_emp_cl1 (ref="inférieur à 33") nb_imp_an_0_cl1 (ref="N/A") / param=ref; 			
	model we18(event='1') = Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1
	/ rsquare lackfit ctable outroc=testroc rsquare;
  	score data=test out=test0 outroc=roc0 fitstat;
run;


/* Résultat: Le critère de convergence est respecté
On choisis Constante avec covariables
Modèle globalement significatif
Toutes nos variables sont globalement significatives pour un niveau de risque de premiere espece de 5%
Hosmer et Lemeshow = 0.5229
AUC (train) = 0.8031 et AUC (test) = 0.7848
*/

									/* -------------------------------------------- 
													Choix du Cut-Off 
									 --------------------------------------------*/



/* Nous choisissons à l'aide d'un graphique notre cut-off */

data testroc;
  set testroc;
  specif=1-_1mspec_;
run;

goption reset=global;
        legend1 frame
        across=1
            mode=protect
            position=(top left)
        offset=(15 cm, -1.5 cm);
axis1 label=none order=(0 to 1 by 0.2) width=1 value=(h=1);
axis2 label=none order=(0 to 1 by 0.1) width=1 value=(h=1) label=("Seuil de probabilite");

proc gplot data=testroc;
  symbol1 value=none i=join color=blue;
  symbol2 value=none i=join color=red;
  plot (specif _sensit_)*_prob_ / overlay legend=legend1 haxis=axis2 vaxis=axis1 ;
run;
quit;          

/* Résultat: Cut-off = 8% */
				

										/* --------------------------------------------  
													Table de confusion 
										 --------------------------------------------*/



data test0;
	set test0;
	if P_1 < 0.08 then I_cible = 0;
	else I_cible = 1;
run;

/* Nous créeons une matrice de confusion */

proc freq data=test0;
	tables we18*I_cible / nocol nopercent;
run;

/* Résultat: 69.16% de "0" bien classé et 76.16% de "1" bien classés*/



										/* --------------------------------------------
												      Calcul de l'indice Gini 
										 --------------------------------------------*/



/* On utilise la table AUC_test crée plus tôt et on applique la formule de gini dans le cas d'une variable binaire */

data gini (Keep=gini);
 set AUC_test;
  Gini=AUC*2-1;
  if _n_=1;
run;

proc print data=gini noobs;run;

/* Résultat: Gini = 0.56968 */


										/* -------------------------------------------- 
													Calcul de l'Indice 10/X 
										 --------------------------------------------*/


data _null_;
 set test0;
	where we18=1;
	call symputx ("Total_defaut",_n_);
run;
%put &Total_defaut;


/* Nous classons par ordre decroissant les individus ayant fait défaut selon leur probabilités et nous stockons dans la table indice */

proc sort data=test0 out=indice;
by descending P_1;
run;


/* On récupère les 10% des individus les moins bien notée par le score */

ods output Means.Summary=percent_10;

proc means data=indice p90;
var P_1;
run;

data _null_;
 set percent_10;
	call symputx("val_select_10",P_1_P90);
run;

data indice2;
 set indice;
	where P_1 > &val_select_10.;
run;

data _null_;
 set indice2;
	where we18=1;
	call symputx ("Nb_defaut_Dix",_n_);
run;

%put &Nb_defaut_Dix;

data _null_;
	Indice_10X= &Nb_defaut_Dix./ &Total_defaut.;
	call symputx ("Indice_10X" ,Indice_10X);
run;

%put &Indice_10X;

/* Résultat : Indice 10/X  = 0.41059 */


				    /********************************************************************************/
				    /*******************************  Grille de score *******************************/
				    /********************************************************************************/


						          /* ----------------------------------------------- 
							           Répartition et Taux de défaut des modalités 
						             ----------------------------------------------*/

proc freq data=test0;
 tables (Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1)*we18 / nocol;
run;


								 /* -------------------------------------------- 
											 Estimation des modalités
									--------------------------------------------*/

proc transpose data=est out=est_t;run;

data est_t ;
 set est_t;
	where _label_ ne "Logarithme de la vraisemblance du modèle";
run;

proc print data=est_t;run;


								/* --------------------------------------------
											   Variable modalités 
							 	   --------------------------------------------*/


data ref;
 infile cards dlm="\" missover;
 input Variables :$15. Description :$50. Moda :$40. Repartition Taux_defaut Estimation;
 cards;
Intercept \ Intercept \ \ \ \ -3.47175 \
duree_cl1 \ Durée prévisionnelle du financement (Mois) \ Inférieur à 37 \ 30.15 \ 0.35 \ -0.63953 \
duree_cl1 \ Durée prévisionnelle du financement (Mois) \ Entre 37 et 49 \ 45.20 \ 1.73 \  0.00000 \
duree_cl1 \ Durée prévisionnelle du financement (Mois) \ Entre 49 et 60 \ 17.92 \ 2.77 \  0.02433 \
duree_cl1 \ Durée prévisionnelle du financement (Mois) \ Supérieur à 60 \  6.72 \ 3.14 \  0.59878 \
part_loyer_cl1 \ Part de l'échéance (%) \ Inférieur à 0.0170 \ 54.50 \ 1.12 \ 0.00000 \
part_loyer_cl1 \ Part de l'échéance (%) \ Supérieur à 0.0170 \ 45.50 \ 2.16 \ 0.81248 \
csp \ Classe socio-professionnelle \ Agriculteurs          \  5.68 \ 0.93 \ 0.83316 \
csp \ Classe socio-professionnelle \ Artisans              \ 22.93 \ 3.22 \ 1.15345 \
csp \ Classe socio-professionnelle \ Commerçants           \ 13.81 \ 2.45 \ 1.07408 \
csp \ Classe socio-professionnelle \ Professions libérales \ 57.57 \ 0.81 \ 0.00000 \
etat_civil \ Code état civil \ Célibataire, Libre                \ 23.65 \ 1.97 \ 0.69334 \
etat_civil \ Code état civil \ Divorcé                           \  9.50 \ 2.34 \ 0.73542 \
etat_civil \ Code état civil \ Marié                             \ 52.21 \ 1.17 \ 0.00000 \
etat_civil \ Code état civil \ Séparé                            \  5.40 \ 1.37 \ 0.97488 \
etat_civil \ Code état civil \ Union libre, concubinage ou Pacsé \  7.70 \ 2.74 \ 0.22912 \
etat_civil \ Code état civil \ Veuf                              \  1.55 \ 0.68 \ 0.95828 \
mode_habi \ Code mode d'habitation \ Logement de fonction \  0.40 \ 5.26 \ 0.94073 \
mode_habi \ Code mode d'habitation \ Hébergé              \  4.14 \ 1.53 \ 0.26988 \
mode_habi \ Code mode d'habitation \ Locataire            \ 15.06 \ 3.79 \ 0.78744 \
mode_habi \ Code mode d'habitation \ Propriétaire         \ 80.40 \ 1.17 \ 0.00000 \
nb_pers_chg_cl1 \ Nombre de personnes à charge \ Égal à 0      \ 50.56 \ 1.63 \  0.00000 \
nb_pers_chg_cl1 \ Nombre de personnes à charge \ Égal à 1      \ 19.44 \ 1.52 \ -0.32921 \
nb_pers_chg_cl1 \ Nombre de personnes à charge \ Égal à 2      \ 20.24 \ 1.57 \ -0.08887 \
nb_pers_chg_cl1 \ Nombre de personnes à charge \ Supérieur à 2 \  9.76 \ 1.62 \  0.40399 \
anc_emp_cl1 \ Ancienneté emploi (Mois) \ Inférieur à 33   \ 18.19 \ 2.38 \  0.00000 \
anc_emp_cl1 \ Ancienneté emploi (Mois) \ Entre 33 et 69   \ 18.08 \ 2.16 \ -0.33090 \
anc_emp_cl1 \ Ancienneté emploi (Mois) \ Entre 69 et 133  \ 21.32 \ 1.73 \ -0.10575 \
anc_emp_cl1 \ Ancienneté emploi (Mois) \ Entre 133 et 253 \ 21.46 \ 1.13 \ -0.75714 \
anc_emp_cl1 \ Ancienneté emploi (Mois) \ Supérieur à 253  \ 20.94 \ 0.76 \ -1.11461 \
nb_imp_an_0_cl1 \ Nombre d'impayés des 12 derniers mois \ Égal à 0      \ 37.16 \ 1.05 \ -0.45186 \
nb_imp_an_0_cl1 \ Nombre d'impayés des 12 derniers mois \ Supérieur à 0 \  3.75 \ 6.48 \  1.39735 \
nb_imp_an_0_cl1 \ Nombre d'impayés des 12 derniers mois \ N/A           \ 59.09 \ 1.63 \  0.00000 \
;run;


								/* ------------------------------------------
													Delta 
								   ------------------------------------------ */


/* Production des minimums des estimations */

proc means data=ref min noprint;
	class variables;
	var estimation;
	output out=mini min=minimum;
run;

proc sql;
create table ref2 as(
select Variables, Description, Moda, Repartition, Taux_defaut, Estimation, estimation-minimum as delta
from ref natural left join mini);
quit;

proc print data=ref2;run;


								/* --------------------------------------------
													Score 
							   	   --------------------------------------------*/

/* Production du delta total */

proc means data=ref2 max noprint;
	class variables;
	var delta;
	output out=maximum max=max;
run;

proc means data=maximum sum noprint;
	var max;
	where _Type_=1;
	output out= delta_tot sum=somme;
run;

data _null_;
	set delta_tot;
	call symputx ("delta_tot",somme);
run;

%put &delta_tot;

/* delta total = 8.81687 */

proc sql;
create table ref3 as(
select *, round(1000*(delta/&delta_tot.)) as score
from ref2);
quit;
proc print data=ref3;run;


/************************************************************************************************************************
*********************************************** Machine Learning ********************************************************
************************************************************************************************************************/



								/* -------------------------------------------- 
												Arbre de Décision
								  --------------------------------------------*/


data train_arbre (drop=we18);
 set train;
  if we18=1 then rep="Yes";
  else rep="No";
run;

data test_arbre (drop=we18);
 set test;
  if we18=1 then rep="Yes";
  else rep="No";
run;

ods graphics on;       

proc hpsplit data=train_arbre seed=15531 cvcc;
 class rep Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1; 
 model rep (event="Yes") = Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1;
 grow gini ;
 prune costcomplexity;  
run;
quit;


/* Estimation du modèle avec 66 feuilles terminales */

ods graphics on;       
ods output TreePerformance=Tree_perf;
proc hpsplit data=train_arbre seed=15531 cvcc;
 class rep Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1; 
 model rep (event="Yes") = Duree_cl1 part_loyer_cl1 csp etat_civil mode_habi nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1;       
 grow gini ;
 prune costcomplexity(leaves=66);  
 code file='titiscore.sas';
 rules file='rules.txt';
 output out = scorapp;
run;
quit;

/* AUC = 0.82 */

/* Scoring pour les exemples de l'échantillon test */

data tree;
 set test_arbre;
  %include 'titiscore.sas';
run;

data tree2;
 set tree;
  length yhat 3;
   if P_repYes<0.08 then yhat=0;
   else yhat=1;
run;

proc freq data=tree2;
table rep*yhat /nocol nopercent;
run;

/* 73.66% de 0 bien prédits et 64.90% de 1 bien prédits */


									/* -------------------------------------------- 
												 Calcul de l'indice Gini 	
									   -------------------------------------------- */


/* On utilise la table AUC_test crée plus tôt et on applique la formule de gini dans le cas d'une variable binaire */

data gini (Keep=gini);
 set Tree_perf;
  Gini=AUC*2-1;
  if _n_=1;
run;

proc print data=gini noobs;run;

/* Résultat: Gini = 0.6325 */


									/* --------------------------------------------
												Calcul de l'Indice 10/X 	
								       -------------------------------------------- */


data _null_;
 set tree;
  where rep="Yes";
  call symputx ("Total_defaut",_n_);
run;

%put &Total_defaut;

/* Nous classons par ordre decroissant les individus ayant fait défaut selon leur probabilités et nous stockons dans la table indice */

proc sort data=tree out=indice;
 by descending P_repYes;
run;

/* On récupère les 10% des individus les moins bien notée par le score*/

ods output Means.Summary=percent_10;

proc means data=indice p90;
 var P_repYes;
run;

data _null_;
 set percent_10;
  call symputx("val_select_10",P_repYes_P90);
run;

data indice2;
 set indice;
  where P_repYes > &val_select_10.;
run;

data _null_;
 set indice2;
  where rep="Yes";
  call symputx ("Nb_defaut_Dix",_n_);
run;

%put &Nb_defaut_Dix;

data _null_;
 Indice_10X= &Nb_defaut_Dix./ &Total_defaut.;
 call symputx ("Indice_10X" ,Indice_10X);
run;

%put &Indice_10X;

/* Résultat : 0.27814 */


								/* -------------------------------------------- 
												Forêts aléatoires 
 								   --------------------------------------------*/


data rf_train (drop=we18);
 set train;
  if we18=1 then rep="Yes";
  else rep="No";
run;

data rf_test (drop=we18);
 set test;
  if we18=1 then rep="Yes";
  else rep="No";
run;

proc hpforest data=rf_train seed=15531;
 target rep / level=binary;
 input csp etat_civil mode_habi / level=nominal;
 input Duree_cl1 part_loyer_cl1 nb_pers_chg_cl1 anc_emp_cl1 nb_imp_an_0_cl1 / level=ordinal;
 save file='rfscoring.bin';
run;
quit;

proc hp4score data=rf_test;
 score file='rfscoring.bin' out=rf_test2;
run;


data rf_test3;
 set rf_test2;
  if P_repYES>0.08 then y_hat="Yes";
  else y_hat="No";
run;

proc freq data=rf_test3;
 table rep*y_hat /nocol nopercent ;
run;

/* 65.55% de 0 bien prédits et 73.51% de 1 bien prédits */




									/* -------------------------------------------- 
												 Calcul de l'indice Gini 	
									   -------------------------------------------- */



/* On utilise l'AUC de l'échantillon train et on applique la formule de gini dans le cas d'une variable binaire */

data gini;
 AUC=0.8028;
 Gini=AUC*2-1;
run;

proc print data=gini noobs;run;

/* Résultat: Gini = 0.6056 */



									/* --------------------------------------------
												Calcul de l'Indice 10/X 	
								       -------------------------------------------- */


data _null_;
 set rf_test2;
  where rep="Yes";
  call symputx ("Total_defaut",_n_);
run;

%put &Total_defaut;

/* Nous classons par ordre decroissant les individus ayant fait défaut selon leur probabilités et nous stockons dans la table indice */

proc sort data=rf_test2 out=indice;
 by descending P_repYes ;
run;

/* On récupère les 10% des individus les moins bien notée par le score*/

ods output Means.Summary=percent_10;

proc means data=indice p90;
 var P_repYes;
run;

data _null_;
 set percent_10;
  call symputx("val_select_10",P_repYes_P90);
run;

data indice2;
 set indice;
  where P_repYes > &val_select_10.;
run;

data _null_;
 set indice2;
  where rep="Yes";
  call symputx ("Nb_defaut_Dix",_n_);
run;

%put &Nb_defaut_Dix;

data _null_;
 Indice_10X= &Nb_defaut_Dix./ &Total_defaut.;
 call symputx ("Indice_10X" ,Indice_10X);
run;

%put &Indice_10X;

/* Résultat : 0.37086 */

