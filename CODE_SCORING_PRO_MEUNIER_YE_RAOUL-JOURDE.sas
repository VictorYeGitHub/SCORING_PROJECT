								/* ---------------------------------------------
								 		 Création des tables temporaires          
								   --------------------------------------------- */


								/* --------------------------------------------- 
									Création de la table temporaire SCORING 
								  --------------------------------------------- */


LIBNAME scoring "insérez ici votre chemin d'accès à la base de données";



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
	6-7="Mauvais"
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


				/* -----------------------------------------------------------------------------------
					  Création de la table temporaire PRO
				   ----------------------------------------------------------------------------------- */


/* CRÉATION DE LA TABLE PRO */

PROC SQL;
CREATE TABLE work.pro AS
(SELECT No_cnt_crypte, No_par_crypte, DUREE, MT_DMD, PC_APPO, AGE_VEH, age, MT_REV, mt_charges, part_loyer, anc_emp, IND_IMP_REGU, 
		periode, dt_dmd_month, genre_veh, produit, QUAL_VEH, IND_CLI_RNVA, EVPM_COPOT_PAI_GLB, EVPA_PRTC, EVPM_COTE, COTE_BDF, CSP, ETAT_CIVIL, MODE_HABI, 
		ind_fch_fcc, copot_, pan_dir_, secteur_, we18
FROM scoring 
WHERE ty_pp="PRO");
QUIT;


										/* ----------------------------------------- 
   											   Description des tables temporaires   
										   ----------------------------------------- */


/* Description de la table PRO */

PROC CONTENTS data=train;RUN;


								/* ----------------------------------------------------- 
       								 	  Analyse descriptive simple de la base :     
      								    détection de valeurs manquantes, aberrantes  
 								   ----------------------------------------------------- */



								/* -------------------------------------------------------- 
 									Partitionnement de la base d'étude en 2 échantillons 
     									  -> 1 echantillon d'apprentissage (70%)              
     									  -> 1 échantillon de validation   (30%)               
 								   -------------------------------------------------------- */



									/* --------------------------------------------
	  												 La table PRO     
									   -------------------------------------------- */


PROC SORT data=pro;
  by we18;
RUN;

PROC SURVEYSELECT data=pro
				  outall
                  samprate=.70  				/* Proportion d'observation sélectionnée dans l'échantillon d'apprentissage */
                  out = pro(drop=selectionProb SamplingWeight)
                  method = srs  				/* Sélection équiprobable et sans remise  */
                  seed = 435 					/* Observation de départ puis sélection aléatoire */ 	
				  NOPRINT;	
  strata we18;                          		/* Echantillon stratifié par rapport à la REPONSE */
RUN;


data train test (drop=selected);
 set pro;
  if selected=1 then output train;
  else output test;
run;

data defaut1 defaut0;
 set train;
  if we18=1 then output defaut1;
  else output defaut0;
run;

proc sort data=defaut0;
 by csp;
run;

PROC SURVEYSELECT data=defaut0
				  outall
                  samprate=.2223 				/* Proportion d'observation sélectionnée dans l'échantillon d'apprentissage */
                  out = defaut0(drop=selectionProb SamplingWeight)
                  method = srs  				/* Sélection équiprobable et sans remise  */
                  seed = 435 					/* Observation de départ puis sélection aléatoire */ 
				  NOPRINT;	
  strata csp; 	
run;

data defaut0;
 set defaut0;
  if selected=1 then output;
run;

data train;
 set defaut1 defaut0;
run;

proc freq data=train;
 tables selected*we18 / missing;
run;

/* VARIABLE À EXPLIQUER (PRO) */

PROC FREQ data=train;
  table we18;
RUN;

/* VARIABLES EXPLICATIVES QUANTITATIVES (PRO) */

PROC MEANS data=train mean median mode var std p25 p50 p75 min max n nmiss;
  VAR No_cnt_crypte No_par_crypte DUREE MT_DMD PC_APPO AGE_VEH age MT_REV mt_charges part_loyer anc_emp IND_IMP_REGU;
RUN;


/* Pourcentage apport supérieur à 100% ?
   Part du loyer négatif ? 
   Ancienneté de l'emploie on va remplacer les valeurs manquantes par la mediane (113)*/


/* VARIABLES EXPLICATIVES QUALITATIVES */

PROC FREQ data=train;
  tables periode dt_dmd_month genre_veh produit QUAL_VEH IND_CLI_RNVA EVPM_COPOT_PAI_GLB EVPA_PRTC EVPM_COTE COTE_BDF CSP ETAT_CIVIL MODE_HABI 
		 ind_fch_fcc copot_ pan_dir_ secteur_;
RUN;

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

/* variables qualitatives : 

periode dt_dmd_month genre_veh produit QUAL_VEH IND_CLI_RNVA EVPM_COPOT_PAI_GLB
EVPA_PRTC EVPM_COTE COTE_BDF CSP ETAT_CIVIL MODE_HABI ind_fch_fcc copot_ pan_dir_ secteur_ */

%quali1(train, periode);				/* Khi-2 pas interprétable : recodage */    
%quali1(train, dt_dmd_month);			/* Non significatif */
%quali1(train, genre_veh);				/* Significatif */
%quali1(train, produit);				/* Significatif */
%quali1(train, qual_veh);				/* Significatif */
%quali1(train, ind_cli_rnva);		    /* Significatif */
%quali1(train, csp);					/* Khi-2 pas interprétable : recodage */
%quali1(train, etat_civil);				/* Significatif */
%quali1(train, mode_habi);				/* Significatif */
%quali1(train, ind_fch_fcc);		    /* Quasi-complete separetion ,on peut donc la supprimer */
%quali1(train, copot_);		    		/* Significatif */
%quali1(train, pan_dir_);				/* Significatif */
%quali1(train, secteur_);				/* Significatif */
%quali1(train, EVPM_COPOT_PAI_GLB);	    /* Significatif */
%quali1(train, evpa_prtc);				/* Quasi-complete separetion ,on peut donc la supprimer */
%quali1(train, evpm_cote);				/* Khi-2 pas interprétable : recodage */
%quali1(train, cote_bdf);				/* Khi-2 pas interprétable : recodage */

/* On peut donc déjà supprimer : dt_dmd_month ind_fch_fcc evpa_prtc */

/* Recodage */

proc freq data=train;
tables periode evpm_cote csp cote_bdf ;
run;


data train;
 set train;

   length periodes $4.;
    if periode="0" then periodes="0";
    if periode="1" then periodes="1";
	if periode="2" then periodes="2";
	if periode="3" then periodes="3";
	if periode="4" then periodes="4";
	if periode="5" or periode="6" or periode="7" or periode="8" or periode="9" or periode="10" or periode="11" or periode="12" then periodes=">=5";

   length C_S_P $25.;
	if csp="11" then c_s_p="Artisans";
	if csp="12" then c_s_p="Commerçants";
	if csp="13" then c_s_p="Professions libérales";
	if csp="00" or csp="10" or csp="14" or csp="20" or csp="21" or csp="22" or csp="30" or csp="40"
	or csp="41" or csp="50" or c_s_p="51" or csp="62" then c_s_p="Autres";

   length evpm_cotes $10.;
	if evpm_cote="1" or evpm_cote="2" then evpm_cotes="Bon";
	if evpm_cote="4" then evpm_cotes="Moyen";
	if evpm_cote="6" or evpm_cote="7" then evpm_cotes="Mauvais";
	if evpm_cote="0" or evpm_cote="9999" then evpm_cotes=" ";

  length secteur $35.;
    if secteur_="AGR" then secteur="Agriculture";
	if secteur_="BTP" then secteur="Bâtiment et Travaux public";
	if secteur_="CDD" then secteur="Commerce de détail";
	if secteur_="CDG" then secteur="Commerce de groupe";
	if secteur_="EAE" then secteur="Enseignement et Auto-école";
	if secteur_="FBC" then secteur="Biens de consommation";
	if secteur_="FCP" then secteur="Fabrication de Chimie Pharmacie";
	if secteur_="FEM" then secteur="Industrie";
	if secteur_="HOP" then secteur="Hôpitaux";
	if secteur_="HRS" then secteur="Hôtellerie, Restauration";
	if secteur_="LIM" then secteur="Immobilier";
	if secteur_="MET" then secteur="Métallurgie";
	if secteur_="RPA" then secteur="Réparateur automobile";
	if secteur_="SCE" then secteur="Services";
	if secteur_="TRA" then secteur="Transport";
	if secteur_="LOA" or secteur_="ATR" then secteur="Autre";

run;

/* On n'a pas trouvé de regroupement cohérent pour cote_bdf */

%quali1(train, evpm_cotes);			/* Significatif */
%quali1(train, periodes);			/* Significatif */
%quali1(train, c_s_p);				/* Significatif */
%quali1(train, secteur);			/* Significatif */


/* On supprime donc les variables cote_bdf dt_dmd_month ind_fch_fcc evpa_prtc */

/* variables qualitatives :

periodes genre_veh produit QUAL_VEH IND_CLI_RNVA EVPM_COPOT_PAI_GLB
EVPM_COTES C_S_P ETAT_CIVIL MODE_HABI copot_ pan_dir_ secteur_ */


								/* --------------------------------------------
												   V de Cramer 
							   	   -------------------------------------------- */



/* Test sur la table train 
On regarde le degré de corrélation entre les variables qui sont significatives */

ods output ChiSq=ChiSq;

proc freq data=train;
  tables ( periodes genre_veh produit QUAL_VEH IND_CLI_RNVA EVPM_COPOT_PAI_GLB
		   EVPM_COTES C_S_P ETAT_CIVIL MODE_HABI copot_ pan_dir_ secteur)
	   *
		 ( periodes genre_veh produit QUAL_VEH IND_CLI_RNVA EVPM_COPOT_PAI_GLB
		   EVPM_COTES C_S_P ETAT_CIVIL MODE_HABI copot_ pan_dir_ secteur) / chisq;
run;

ods select all;

data ChiSq(keep=Table abs_V_Cramer);
  set ChiSq;
   where Statistic like '%Cramer%';
   abs_V_Cramer = ABS(Value);
run;

proc sort data=ChiSq; by descending abs_V_Cramer; run;
proc print data=ChiSq; run;

/* De nombreuses variables sont fortement corrélées :

evpm_cotes et pan_dir_ 				0.84053
genre_veh et secteur_ 				0.74706
secteur et C_S_P 					0.71006
C_S_P et genre_veh 					0.59621
pan_dir_ et evpm_copot_pai_glb 		0.53109
secteur et produit 					0.52626
copot_ et evpm_copot_pai_glb 		0.52490
produit_ et genre_veh 				0.43723
evpm_cotes et evpm_copot_pai_glb 	0.40179
pan_dir_ et copot_ 					0.38145
qual_veh et produit 				0.32189  */


data essaie;
 set train (keep=c_s_p secteur);
run; 

/* Comme dans pri, enseignement et auto-ecole est associée avec des csp incohérentes */

/* Regardons la corrélation avec we18 pour voir comment gérer nos corrélations */

ods output ChiSq=ChiSq2;

proc freq data=train;
  tables ( periodes genre_veh produit QUAL_VEH IND_CLI_RNVA EVPM_COPOT_PAI_GLB
		   EVPM_COTES C_S_P ETAT_CIVIL MODE_HABI copot_ pan_dir_ secteur)*we18 / chisq;
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


/* On peut donc déjà supprimer C_S_P pan_dir_ produit evpm_copot_pai_glb */

/* variables qualitatives :
   periodes (genre_veh) QUAL_VEH IND_CLI_RNVA
   EVPM_COTES ETAT_CIVIL MODE_HABI copot_ secteur_ */



						/* -------------------------------------------------------------------
							  Liaison entre la variable CIBLE et les variables explicatives   
						        quantitatives (test de Student + Test de Kruskall-Wallis)       
    					   ------------------------------------------------------------------- */


/*  Analyse des variables numériques :  
	No_cnt_crypte No_par_crypte DUREE MT_DMD PC_APPO AGE_VEH
	age MT_REV mt_charges part_loyer anc_emp IND_IMP_REGU */  


proc means data=train min max median n nmiss;
var No_cnt_crypte No_par_crypte DUREE MT_DMD PC_APPO AGE_VEH age MT_REV mt_charges part_loyer anc_emp IND_IMP_REGU;
run;


/* pourcentage apport supérieur à 100% ? (mediane 0)
   part du loyer négatif ? (mediane 0.0194)
   ancienneté de l'emploie on va remplacer les valeurs manquantes par la mediane (113)*/


data train;
 set train;

  if anc_emp=. then anc_emp=113;
  if part_loyer<0 then part_loyer=0.0194;
  if pc_appo>1 then pc_appo=0;

run;
 
						/* ---------------------------------------------------------
 						     Analyse des distribution (normalité) : PROC UNIVARIATE
 						   --------------------------------------------------------- */


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


/* No_cnt_crypte No_par_crypte DUREE MT_DMD PC_APPO AGE_VEH age MT_REV mt_charges part_loyer anc_emp IND_IMP_REGU */

%univ(train,no_cnt_crypte);
%univ(train,no_par_crypte);
%univ(train,duree);
%univ(train,mt_dmd);
%univ(train,pc_appo);
%univ(train,age_veh);
%univ(train,age);
%univ(train,mt_rev);
%univ(train,mt_charges);
%univ(train,part_loyer);
%univ(train,anc_emp);
%univ(train,ind_imp_regu);



/* Aucune de ces variables ne suivent une loi normale */

/*  Comme les distributions ne suivent pas une loi normale, on utilise 
 le test non paramétrique de Kruskal-Wallis                            */

ods output KruskalWallisTest = kruskal;

proc npar1way Wilcoxon data=train;
  class we18;
  var No_cnt_crypte No_par_crypte DUREE MT_DMD PC_APPO AGE_VEH age MT_REV mt_charges part_loyer anc_emp IND_IMP_REGU ;
run;

ods select all;

data kruskal/*(keep=Variable nValue1 rename=(nValue1=KWallis))*/;
 set kruskal;
  where name1='_KW_';
run;

proc sort data=kruskal; by descending KWallis; run;
proc print data=kruskal; run;

/*	No_cnt_crypte	Non significatif 
	No_par_crypte 	Significatif -> Arbitraire on ne gardera pas
	DUREE 			Significatif
	MT_DMD 			Non significatif
	PC_APPO 		Significatif
	AGE_VEH 		Significatif
	age 			Significatif
	MT_REV 			Significatif
	mt_charges 		Non significatif
	part_loyer 		Significatif
	anc_emp 		Significatif
	IND_IMP_REGU	Significatif	*/



							/* ------------------------------------------------------------- 
									 	 - Traitement des variables canditates :                     
									     - Discrétisation des variables continues                  
     									 - Recodage des variables qualitatives                     
 							   ------------------------------------------------------------- */


							/* -------------------------------------------------------------
										  Discrétisation des variables continues 
							   ------------------------------------------------------------- */



									/* Solution 1 : Discrétisation de la variable   
             										sans contrainte sur les déciles 
 									  ----------------------------------------------- */ 

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


%discret1(train,duree);
%discret1(train,mt_dmd);
%discret1(train,pc_appo);
%discret1(train,age_veh);
%discret1(train,age);
%discret1(train,mt_rev);
%discret1(train,mt_charges);
%discret1(train,part_loyer);
%discret1(train,anc_emp);
%discret1(train,ind_imp_regu);


/* On regroupe de manière à avoir des groupes comportant au moins 15% des observations */

data train;
 set train;

  length duree_cl1 $15.;
   if duree<=12 then duree_cl1="inférieur à 12";
   if 12<duree<=36 then duree_cl1="entre 12 et 36";
   if 36<duree<=48 then duree_cl1="entre 36 et 48";
   if 48<duree<=60 then duree_cl1="entre 48 et 60";
   if duree>60 then duree_cl1="supérieur à 60";

  length mt_dmd_cl1 $25.;
   if mt_dmd<=11314.7 then mt_dmd_cl1="inférieur à 11314.7";
   if 11314.7<mt_dmd<=14297.9 then mt_dmd_cl1="entre 11314.7 et 14297.9";
   if 14297.9<mt_dmd<=17818.1 then mt_dmd_cl1="entre 14297.9 et 17818.1";
   if 17818.1<mt_dmd<=22000 then mt_dmd_cl1="entre 17818.1 et 22000";
   if mt_dmd>22000 then mt_dmd_cl1="supérieur à 22000";

  length pc_appo_cl1 $18.;
   if pc_appo=0 then pc_appo_cl1="égal à 0";
   if 0<pc_appo<=0.2 then pc_appo_cl1="entre 0 et 0.2";
   if pc_appo>0.2 then pc_appo_cl1="supérieur à 0.2";

  length age_veh_cl1 $15.;
   if age_veh=0 then age_veh_cl1="égal à 0";
   if age_veh>0 then age_veh_cl1="supérieur à 0";

  length age_cl1 $15.;
   if age<=38 then age_cl1="inférieur à 38";
   if 38<age<=45 then age_cl1="entre 38 et 45";
   if 45<age<=50 then age_cl1="entre 45 et 50";
   if 50<age<=56 then age_cl1="entre 50 et 56";
   if age>56 then age_cl1="supérieur à 56";

  length mt_rev_cl1 $20.;
   if mt_rev<=1400 then mt_rev_cl1="inférieur à 1400";
   if 1400<mt_rev<=2000 then mt_rev_cl1="entre 1400 et 2000";
   if 2000<mt_rev<=2500 then mt_rev_cl1="entre 2000 et 2500";
   if 2500<mt_rev<=3900 then mt_rev_cl1="entre 2500 et 3900";
   if mt_rev>3900 then mt_rev_cl1="supérieur à 3900";

  length mt_charges_cl1 $20.;
   if mt_charges<=350 then mt_charges_cl1="inférieur à 350";
   if mt_charges>350 then mt_charges_cl1="supérieur à 350";

  length part_loyer_cl1 $20.;
   if part_loyer<=0.0194 then part_loyer_cl1="inférieur à 0.0194";
   if part_loyer>0.0194 then part_loyer_cl1="supérieur à 0.0194";

  length anc_emp_cl1 $20.;
   if anc_emp<=38 then anc_emp_cl1="inférieur à 38";
   if 38<anc_emp<=88 then anc_emp_cl1="entre 38 et 88";
   if 88<anc_emp<=144 then anc_emp_cl1="entre 88 et 144";
   if 144<anc_emp<=243 then anc_emp_cl1="entre 144 et 243";
   if anc_emp>243 then anc_emp_cl1="supérieur à 243";

  length ind_imp_regu_cl1 $15.;
   if ind_imp_regu=0 then ind_imp_regu_cl1="égal à 0";
   if ind_imp_regu>0 then ind_imp_regu_cl1="supérieur à 0";

run;

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

* Application de la macro VALID;
* -----------------------------;

%valid(train,duree_cl1);		/* Significatif */
%valid(train,mt_dmd_cl1);		/* Non Significatif */
%valid(train,pc_appo_cl1);		/* Significatif */
%valid(train,age_veh_cl1);		/* Significatif */
%valid(train,age_cl1);			/* Significatif */
%valid(train,mt_rev_cl1);		/* Significatif */
%valid(train,mt_charges_cl1);	/* Significatif */
%valid(train,part_loyer_cl1);	/* Non Significatif */
%valid(train,anc_emp_cl1);		/* Significatif */
%valid(train,ind_imp_regu_cl1);	/* Significatif */

/* On peut donc supprimer : mt_dmd_cl1 et part_loyer_cl1 */


* Solution 2 : Discrétisation de la variable sous  ;
*              contrainte de déciles sur CIBLE = 1 ;
* ------------------------------------------------ ;

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

* Application de la macro DISCRET2;
* --------------------------------;

%discret2(train,duree);
%discret2(train,mt_dmd);
%discret2(train,pc_appo);
%discret2(train,age_veh);
%discret2(train,age);
%discret2(train,mt_rev);
%discret2(train,mt_charges);
%discret2(train,part_loyer);
%discret2(train,anc_emp);
%discret2(train,ind_imp_regu);

/* Création des variables discrétisées 2 */

data train;
 set train;

  length duree_cl2 $15.;
   if duree<=12 then duree_cl2="inférieur à 12";
   if 12<duree<=37 then duree_cl2="entre 12 et 37";
   if 37<duree<=49 then duree_cl2="entre 37 et 49";
   if 49<duree<=60 then duree_cl2="entre 49 et 60";
   if duree>60 then duree_cl2="supérieur à 60";

  length mt_dmd_cl2 $25.;
   if mt_dmd<=11469.3 then mt_dmd_cl2="inférieur à 11469.3";
   if 11469.3<mt_dmd<=14330.7 then mt_dmd_cl2="entre 11469.3 et 14330.7";
   if 14330.7<mt_dmd<=18280.4 then mt_dmd_cl2="entre 14330.7 et 18280.4";
   if 18280.4<mt_dmd<=22188.1 then mt_dmd_cl2="entre 18280.4 et 22188.1";
   if mt_dmd>22188.1 then mt_dmd_cl2="supérieur à 22188.1";

  length pc_appo_cl2 $18.;
   if pc_appo=0 then pc_appo_cl2="égal à 0";
   if 0<pc_appo<=0.2 then pc_appo_cl2="entre 0 et 0.2";
   if pc_appo>0.2 then pc_appo_cl2="supérieur à 0.2";

  length age_veh_cl2 $15.;
   if age_veh=0 then age_veh_cl2="égal à 0";
   if age_veh>0 then age_veh_cl2="supérieur à 0";

  length age_cl2 $15.;
   if age<=38 then age_cl2="inférieur à 38";
   if 38<age<=43 then age_cl2="entre 38 et 43";
   if 43<age<=49 then age_cl2="entre 43 et 49";
   if 49<age<=57 then age_cl2="entre 49 et 57";
   if age>57 then age_cl2="supérieur à 57";

  length mt_rev_cl2 $20.; 
   if mt_rev<=1500 then mt_rev_cl2="inférieur à 1500";
   if 1500<mt_rev<=2000 then mt_rev_cl2="entre 1500 et 2000";
   if 2000<mt_rev<=2500 then mt_rev_cl2="entre 2000 et 2500";
   if 2500<mt_rev<=4000 then mt_rev_cl2="entre 2500 et 4000";
   if mt_rev>4000 then mt_rev_cl2="supérieur à 4000";

  length mt_charges_cl2 $20.;
   if mt_charges<=228 then mt_charges_cl2="inférieur à 228";
   if mt_charges>228 then mt_charges_cl2="supérieur à 228";

  length part_loyer_cl2 $20.;
   if part_loyer<=0.0194 then part_loyer_cl2="inférieur à 0.0194";
   if part_loyer>0.0194 then part_loyer_cl2="supérieur à 0.0194";

  length anc_emp_cl2 $20.;
   if anc_emp<=34 then anc_emp_cl2="inférieur à 34";
   if 34<anc_emp<=68 then anc_emp_cl2="entre 34 et 68";
   if 68<anc_emp<=113 then anc_emp_cl2="entre 68 et 113";
   if 113<anc_emp<=247 then anc_emp_cl2="entre 113 et 247";
   if anc_emp>247 then anc_emp_cl2="supérieur à 247";

  length ind_imp_regu_cl2 $15.;
   if ind_imp_regu=0 then ind_imp_regu_cl2="égal à 0";
   if ind_imp_regu>0 then ind_imp_regu_cl2="supérieur à 0";

run;

/* Application de la macro VALID */


%valid(train,duree_cl2);		/* Significatif */
%valid(train,mt_dmd_cl2);		/* Non Significatif */
%valid(train,pc_appo_cl2);		/* Significatif */
%valid(train,age_veh_cl2);		/* Significatif */
%valid(train,age_cl2);			/* Significatif */
%valid(train,mt_rev_cl2);		/* Significatif */
%valid(train,mt_charges_cl2);	/* Significatif */
%valid(train,part_loyer_cl2);	/* Non Significatif */
%valid(train,anc_emp_cl2);		/* Significatif */
%valid(train,ind_imp_regu_cl2);	/* Significatif */


/* On peut déjà supprimer mt_dmd_cl2 et part_loyer_cl2 */


/* On peut également supprimer les variables qui sont codées pareils dans cl1 et cl2 :
	pc_appo_cl2 age_veh_cl2 ind_imp_regu_cl2 */


/* On regarde la colinéarité entre les variables qualitatives en ajoutant les variables discrétisées */

/* Variables :

	periodes genre_veh QUAL_VEH IND_CLI_RNVA EVPM_COTES ETAT_CIVIL MODE_HABI copot_ secteur_

	duree_cl1 PC_APPO_cl1 AGE_VEH_cl1 age_cl1 MT_REV_cl1 mt_charges_cl1 IND_IMP_REGU_cl1

	duree_cl2 age_cl2 mt_rev_cl2  mt_charges_cl2 anc_emp_cl1 anc_emp_cl2 */


ods output ChiSq=ChiSq3;

proc freq data=train;
  tables ( periodes genre_veh QUAL_VEH IND_CLI_RNVA EVPM_COTES ETAT_CIVIL MODE_HABI copot_ secteur

		   duree_cl1 PC_APPO_cl1 AGE_VEH_cl1 age_cl1 MT_REV_cl1 mt_charges_cl1 IND_IMP_REGU_cl1

		   duree_cl2 age_cl2 mt_rev_cl2  mt_charges_cl2 anc_emp_cl1 anc_emp_cl2 )
    *	
		 ( periodes genre_veh QUAL_VEH IND_CLI_RNVA EVPM_COTES ETAT_CIVIL MODE_HABI copot_ secteur

		   duree_cl1 PC_APPO_cl1 AGE_VEH_cl1 age_cl1 MT_REV_cl1 mt_charges_cl1 IND_IMP_REGU_cl1

		   duree_cl2 age_cl2 mt_rev_cl2  mt_charges_cl2 anc_emp_cl1 anc_emp_cl2) / chisq;
run;

ods select all;

data ChiSq3(keep=Table abs_V_Cramer);
  set ChiSq3;
   where Statistic like '%Cramer%';
   abs_V_Cramer = ABS(Value);
run;

data Select_quali(keep=Variable1 Variable2 abs_V_Cramer);
  set ChiSq3;
   length Variable1 $32.;
   length Variable2 $32.;
   Variable1 = SCAN (Table,2) ; /* SCAN(Table,2) = 2e mot de la variable "Table" */
   Variable2 = SCAN (Table,3) ; /* SCAN(Table,4) = 4e mot de la variable "Table" */
run;


* Elimination des paires redondantes;
* ----------------------------------;

data Select_quali;
  set Select_quali;
   where variable1 < variable2;
run;

proc sort data=Select_quali;
  by descending abs_V_Cramer;
run;

proc print data=Select_quali;
  var variable1 variable2 abs_V_Cramer;
run;


ods output ChiSq=ChiSq4;

proc freq data=train;
  tables ( periodes genre_veh QUAL_VEH IND_CLI_RNVA EVPM_COTES ETAT_CIVIL MODE_HABI copot_ secteur

		  duree_cl1 PC_APPO_cl1 AGE_VEH_cl1 age_cl1 MT_REV_cl1 mt_charges_cl1 IND_IMP_REGU_cl1 anc_emp_cl1

		  duree_cl2 age_cl2 mt_rev_cl2  mt_charges_cl2 anc_emp_cl2 )*we18 / chisq;
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

/* On va dans un 1er temps regarder quelles variables nous gardons entre les cl1 et les cl2 */

/* On retire : anc_emp_cl2 mt_charges_cl1 mt_rev_cl2 age_cl1 duree_cl1 */



/* Regardons à présent la colinéarité */


ods output ChiSq=ChiSq5;

proc freq data=train;
  tables ( periodes genre_veh QUAL_VEH IND_CLI_RNVA EVPM_COTES ETAT_CIVIL MODE_HABI copot_ secteur

		   PC_APPO_cl1 AGE_VEH_cl1 MT_REV_cl1 IND_IMP_REGU_cl1 anc_emp_cl1

		   duree_cl2 age_cl2 mt_rev_cl2  mt_charges_cl2 )
    *	
		 ( periodes genre_veh QUAL_VEH IND_CLI_RNVA EVPM_COTES ETAT_CIVIL MODE_HABI copot_ secteur

		   PC_APPO_cl1 AGE_VEH_cl1 MT_REV_cl1 IND_IMP_REGU_cl1 anc_emp_cl1

		   duree_cl2 age_cl2 mt_charges_cl2 ) / chisq;
run;

ods select all;

data ChiSq5(keep=Table abs_V_Cramer);
  set ChiSq5;
   where Statistic like '%Cramer%';
   abs_V_Cramer = ABS(Value);
run;

data Select_quali3(keep=Variable1 Variable2 abs_V_Cramer);
  set ChiSq5;
   length Variable1 $32.;
   length Variable2 $32.;
   Variable1 = SCAN (Table,2) ; /* SCAN(Table,2) = 2e mot de la variable "Table" */
   Variable2 = SCAN (Table,3) ; /* SCAN(Table,4) = 4e mot de la variable "Table" */
run;


/* Elimination des paires redondantes
  ---------------------------------- */

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


/*	qual_veh et age_veh_cl1 			0.92472
	copot_ et ind_imp_regu_cl1 			0.82536
	genre_veh et secteur 				0.74686
	duree_cl2 et genre_veh 				0.56433
	duree_cl2 et secteur 				0.49012
	modee_habi et mt_charges_cl2 		0.47331
	genre_veh et pc_appo_cl1 			0.30049  */


proc freq data=train;
 tables qual_veh*age_veh_cl1;
run;

proc freq data=train;
 table mode_habi*mt_charges_cl2;
run;

/* Croisement de variables pour éviter la corrélation */

data train;
 set train;

  length qual_age_veh $ 16;
   if qual_veh="VN" and age_veh_cl1="supérieur à 0" then qual_age_veh="VN supérieur à 0";
   if qual_veh="VN" and age_veh_cl1="égal à 0" then qual_age_veh="VN égal à 0";
   if qual_veh="VO" and age_veh_cl1="supérieur à 0" then qual_age_veh="VO supérieur à 0";
   if qual_veh="VO" and age_veh_cl1="égal à 0" then qual_age_veh="VO égal à 0";

   if mode_habi="F" and mt_charges_cl2="inférieur à 228" then habi_charges="Logement de fonction et inférieur à 228";
   if mode_habi="F" and mt_charges_cl2="supérieur à 228" then habi_charges="Logement de fonction et supérieur à 228";
   if mode_habi="H" and mt_charges_cl2="inférieur à 228" then habi_charges="Hébergé et inférieur à 228";
   if mode_habi="H" and mt_charges_cl2="supérieur à 228" then habi_charges="Hébergé et supérieur à 228";
   if mode_habi="L" and mt_charges_cl2="inférieur à 228" then habi_charges="Locataire et inférieur à 228";
   if mode_habi="L" and mt_charges_cl2="supérieur à 228" then habi_charges="Locataire et supérieur à 228";
   if mode_habi="P" and mt_charges_cl2="inférieur à 228" then habi_charges="Propriétaire et inférieur à 228";
   if mode_habi="P" and mt_charges_cl2="supérieur à 228" then habi_charges="Propriétaire et supérieur à 228";

run;


/* Importance des variables restantes pour supprimer les corrélations */


ods output ChiSq=ChiSq6;

proc freq data=train;
  tables ( periodes genre_veh qual_veh mode_habi IND_CLI_RNVA EVPM_COTES ETAT_CIVIL copot_ secteur qual_age_veh
  		   habi_charges

		  duree_cl1 PC_APPO_cl1 MT_REV_cl1 IND_IMP_REGU_cl1 age_veh_cl1 anc_emp_cl1

		  duree_cl2 age_cl2 mt_charges_cl2)*we18 / chisq;
run;

ods select all;

data ChiSq6(keep=Table abs_V_Cramer);
  set ChiSq6;
   where Statistic like '%Cramer%';
   abs_V_Cramer = ABS(Value);
run;

proc sort data=ChiSq6; by descending abs_V_Cramer; run;
proc print data=ChiSq6; run;

data Select_quali4(keep=Variable abs_V_Cramer Value);
  set ChiSq6;
   length Variable $32.;
   Variable = SCAN (Table,2) ; /* SCAN(Table,2) = 2e mot de la variable "Table" */
run;

proc print data=Select_quali4; run;


/* On teste les variables : 
	periodes genre_veh mode_habi IND_CLI_RNVA EVPM_COTES ETAT_CIVIL copot_ secteur_ qual_age_veh
  	habi_charges

	PC_APPO_cl1 MT_REV_cl1 IND_IMP_REGU_cl1 anc_emp_cl1

	duree_cl2 age_cl2 mt_charges_cl2    */




								/* ------------------------------------------ 
   									 Modélisation : régression logistique 
      								   sur choix des variables définies 
								   ------------------------------------------ */



/* Fin du choix des variables */

proc logistic data=train;
 class     periodes genre_veh mode_habi IND_CLI_RNVA EVPM_COTES ETAT_CIVIL copot_ secteur qual_age_veh
  		   habi_charges

		   PC_APPO_cl1 MT_REV_cl1 IND_IMP_REGU_cl1 anc_emp_cl1

		  duree_cl2 age_cl2 mt_charges_cl2  / param=ref ;

  model we18(event='1') = periodes genre_veh mode_habi IND_CLI_RNVA EVPM_COTES ETAT_CIVIL copot_ secteur qual_age_veh
  		  				  habi_charges

		   				  PC_APPO_cl1 MT_REV_cl1 IND_IMP_REGU_cl1 anc_emp_cl1

		  			      duree_cl2 age_cl2 mt_charges_cl2  / selection=stepwise;
run;


/* 	Le Stepwise nous dit de garder les varaibles : 
 	ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 duree_cl2 age_cl2 */



proc logistic data=train;
  class ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 duree_cl2 age_cl2  / param=ref ;
  model we18(event='1') = ind_cli_rnva etat_civil mode_habi copot_ secteur_ pc_appo_cl1 anc_emp_cl1 duree_cl2 age_cl2 ;
run;


/* Corrélation */


ods output chisq=chisq7;

proc freq data=train;
tables (ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 duree_cl2 age_cl2)
*(ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 duree_cl2 age_cl2) / chisq;
run;

ods select all;

data ChiSq7(keep=Table abs_V_Cramer);
  set ChiSq7;
   where Statistic like '%Cramer%';
   abs_V_Cramer = ABS(Value);
run;

data Select_quali5(keep=Variable1 Variable2 abs_V_Cramer);
  set ChiSq7;
   length Variable1 $32.;
   length Variable2 $32.;
   Variable1 = SCAN (Table,2) ; /* SCAN(Table,2) = 2e mot de la variable "Table" */
   Variable2 = SCAN (Table,3) ; /* SCAN(Table,4) = 4e mot de la variable "Table" */
run;

/* Elimination des paires redondantes
   ---------------------------------- */

data Select_quali5;
  set Select_quali5;
   where variable1 < variable2;
run;

proc sort data=Select_quali5;
  by descending abs_V_Cramer;
run;

proc print data=Select_quali5;
  var variable1 variable2 abs_V_Cramer;
run;

/* Corrélation entre duree_cl2 et secteur_ */

/* On test les modèles */
/* Avec duree_cl2 */

proc logistic data=train;
  class ind_cli_rnva etat_civil mode_habi copot_ pc_appo_cl1 anc_emp_cl1 duree_cl2 age_cl2  / param=ref ;
  model we18(event='1') = ind_cli_rnva etat_civil mode_habi copot_ pc_appo_cl1 anc_emp_cl1 duree_cl2 age_cl2 ;
run;

/* stat c = 0.767 */

/* Avec secteur */

proc logistic data=train;
  class ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 age_cl2  / param=ref ;
  model we18(event='1') = ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 age_cl2 ;
run;

/* stat c = 0.794 */

/* 	On garde donc les variables :
	ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 age_cl2  */



**************************************************************************************************************************************
**************************************************************************************************************************************
**************************************************************************************************************************************
**************************************************************************************************************************************
**************************************************************************************************************************************;


data train;
 set train;

  length age_cl2 $15.;
   if age<=38 then age_cl2="inférieur à 38";
   if 38<age<=43 then age_cl2="entre 38 et 43";
   if 43<age<=49 then age_cl2="entre 43 et 49";
   if 49<age<=57 then age_cl2="entre 49 et 57";
   if age>57 then age_cl2="supérieur à 57";

  length pc_appo_cl1 $18.;
   if pc_appo=0 then pc_appo_cl1="égal à 0";
   if 0<pc_appo<=0.2 then pc_appo_cl1="entre 0 et 0.2";
   if pc_appo>0.2 then pc_appo_cl1="supérieur à 0.2";

  length anc_emp_cl1 $20.;
   if anc_emp<=38 then anc_emp_cl1="inférieur à 38";
   if 38<anc_emp<=88 then anc_emp_cl1="entre 38 et 88";
   if 88<anc_emp<=144 then anc_emp_cl1="entre 88 et 144";
   if 144<anc_emp<=243 then anc_emp_cl1="entre 144 et 243";
   if anc_emp>243 then anc_emp_cl1="supérieur à 243";

     length secteur $35.;
    if secteur_="AGR" then secteur="Agriculture";
	if secteur_="BTP" then secteur="Bâtiment et Travaux public";
	if secteur_="CDD" then secteur="Commerce de détail";
	if secteur_="CDG" then secteur="Commerce de groupe";
	if secteur_="EAE" then secteur="Enseignement et Auto-école";
	if secteur_="FBC" then secteur="Biens de consommation";
	if secteur_="FCP" then secteur="Fabrication de Chimie Pharmacie";
	if secteur_="FEM" then secteur="Industrie";
	if secteur_="HOP" then secteur="Hôpitaux";
	if secteur_="HRS" then secteur="Hôtellerie, Restauration";
	if secteur_="LIM" then secteur="Immobilier";
	if secteur_="MET" then secteur="Métallurgie";
	if secteur_="RPA" then secteur="Réparateur automobile";
	if secteur_="SCE" then secteur="Services";
	if secteur_="TRA" then secteur="Transport";
	if secteur_="LOA" or secteur_="ATR" then secteur="Autre";

run;

/* On crée la table train avec les variables sélectionnées */

proc sql;
create table work.train as(
select ind_cli_rnva, etat_civil, mode_habi, copot_, secteur, pc_appo_cl1, anc_emp_cl1, age_cl2, we18
from work.train);
quit;

/* On discrétise les variables selectionnées dans test */

data test;
 set test;

  length age_cl2 $15.;
   if age<=38 then age_cl2="inférieur à 38";
   if 38<age<=43 then age_cl2="entre 38 et 43";
   if 43<age<=49 then age_cl2="entre 43 et 49";
   if 49<age<=57 then age_cl2="entre 49 et 57";
   if age>57 then age_cl2="supérieur à 57";

  length pc_appo_cl1 $18.;
   if pc_appo=0 then pc_appo_cl1="égal à 0";
   if 0<pc_appo<=0.2 then pc_appo_cl1="entre 0 et 0.2";
   if pc_appo>0.2 then pc_appo_cl1="supérieur à 0.2";

  length anc_emp_cl1 $20.;
   if anc_emp<=38 then anc_emp_cl1="inférieur à 38";
   if 38<anc_emp<=88 then anc_emp_cl1="entre 38 et 88";
   if 88<anc_emp<=144 then anc_emp_cl1="entre 88 et 144";
   if 144<anc_emp<=243 then anc_emp_cl1="entre 144 et 243";
   if anc_emp>243 then anc_emp_cl1="supérieur à 243";

  length secteur $35.;
    if secteur_="AGR" then secteur="Agriculture";
	if secteur_="BTP" then secteur="Bâtiment et Travaux public";
	if secteur_="CDD" then secteur="Commerce de détail";
	if secteur_="CDG" then secteur="Commerce de groupe";
	if secteur_="EAE" then secteur="Enseignement et Auto-école";
	if secteur_="FBC" then secteur="Biens de consommation";
	if secteur_="FCP" then secteur="Fabrication de Chimie Pharmacie";
	if secteur_="FEM" then secteur="Industrie";
	if secteur_="HOP" then secteur="Hôpitaux";
	if secteur_="HRS" then secteur="Hôtellerie, Restauration";
	if secteur_="LIM" then secteur="Immobilier";
	if secteur_="MET" then secteur="Métallurgie";
	if secteur_="RPA" then secteur="Réparateur automobile";
	if secteur_="SCE" then secteur="Services";
	if secteur_="TRA" then secteur="Transport";
	if secteur_="LOA" or secteur_="ATR" then secteur="Autre";

	  length secteur $35.;
    if secteur_="AGR" then secteur="Agriculture";
	if secteur_="BTP" then secteur="Bâtiment et Travaux public";
	if secteur_="CDD" then secteur="Commerce de détail";
	if secteur_="CDG" then secteur="Commerce de groupe";
	if secteur_="EAE" then secteur="Enseignement et Auto-école";
	if secteur_="FBC" then secteur="Biens de consommation";
	if secteur_="FCP" then secteur="Fabrication de Chimie Pharmacie";
	if secteur_="FEM" then secteur="Industrie";
	if secteur_="HOP" then secteur="Hôpitaux";
	if secteur_="HRS" then secteur="Hôtellerie, Restauration";
	if secteur_="LIM" then secteur="Immobilier";
	if secteur_="MET" then secteur="Métallurgie";
	if secteur_="RPA" then secteur="Réparateur automobile";
	if secteur_="SCE" then secteur="Services";
	if secteur_="TRA" then secteur="Transport";
	if secteur_="LOA" or secteur_="ATR" then secteur="Autre";

run;

/* On crée la table test avec les variables sélectionner */

proc sql;
create table work.test as(
select ind_cli_rnva, etat_civil, mode_habi, copot_, secteur, pc_appo_cl1, anc_emp_cl1, age_cl2, we18
from work.test);
quit;

proc freq data=train;
tables ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 age_cl2;
run;



								/* ------------------------------------------ 
												Modélisation 	
								   ------------------------------------------ */



/* On modélise une régression logistique avec les variables sélectionner */
ods output Logistic.ScoreFitStat=AUC_test; 
proc logistic data=train outest=est ;
	class ind_cli_rnva (ref="Non") etat_civil (ref="Marié") mode_habi (ref="Propriétaire") copot_ (ref="Bon") secteur (ref="Hôpitaux")
          pc_appo_cl1 (ref="égal à 0") anc_emp_cl1 (ref="inférieur à 38") age_cl2 (ref="inférieur à 38") / param=ref; 			
	model we18(event='1') = ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 age_cl2
	/ rsquare lackfit ctable outroc=testroc rsquare;
  	score data=test out=test0 outroc=roc0 fitstat;
run;

/*  Résultat: Le critère de convergence est respecté
	On choisis Constante avec covariables
	Modèle globalement significatif
	Toutes nos variables sont globalement significatives pour un niveau de risque de premiere espece de 5%
	Hosmer et Lemeshow = 0.3399
	AUC (train) = 0.7937 et AUC (test) = 0.7927     */



								/* ------------------------------------------  
											  Choix du Cut-Off 	 
								   ------------------------------------------ */ 


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

/* Résultat: Cut-off = 9% */

	

									/* ------------------------------------------ 
											      Table de confusion 	
									   ------------------------------------------ */


data test0;
 set test0;
  if P_1 < 0.09 then I_cible = 0;
  else I_cible = 1;
run;

/* Nous créeons une matrice de confusion */

proc freq data=test0;
	tables we18*I_cible / nocol nopercent;
run;

/* Résultat: 71.91% de "0" bien classé et 69.58% de "1" bien classés*/



									 /* ------------------------------------------  
											     Calcul de l'indice Gini 	
									    ------------------------------------------ */



/* On utilise la table AUC_test crée plus tôt et on applique la formule de gini dans le cas d'une variable binaire */

data gini (Keep=gini);
 set AUC_test;
  Gini=AUC*2-1;
  if _n_=1;
run;

proc print data=gini noobs;run;

/* Résultat: Gini = 0.58540 */



									/* ------------------------------------------ 
												 Calcul de l'Indice 10/X 	
									   ------------------------------------------ */


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

/* On récupère les 10% des individus les moins bien notée par le score*/

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

/* Résultat : Indice 10/X  = 0.40833 */


					   /********************************************************************************/
					   /*******************************  Grille de score *******************************/
					   /********************************************************************************/


									/* ----------------------------------------------- 
										 Répartition et Taux de défaut des modalités 
						  			   ---------------------------------------------- */


proc freq data=test0;
 tables (ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 age_cl2)*we18 / nocol;
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
Intercept \ Intercept \ \ \ \ -3.41790 \
IND_CLI_RNVA \ Indicateur client renouvelant \ Non \ 99.05 \ 2.14 \ 0.00000 \
IND_CLI_RNVA \ Indicateur client renouvelant \ Oui \  0.95 \ 4.76 \ 0.94333 \
ETAT_CIVIL \ Code état civil \ Célibataire, Libre                \ 39.02 \ 2.72 \  0.32297 \
ETAT_CIVIL \ Code état civil \ Divorcé                           \  8.97 \ 2.06 \  0.31183 \
ETAT_CIVIL \ Code état civil \ Marié                             \ 40.38 \ 1.60 \  0.00000 \
ETAT_CIVIL \ Code état civil \ Séparé                            \  7.65 \ 1.69 \  0.37058 \
ETAT_CIVIL \ Code état civil \ Union libre, Concubinage ou Pacsé \  2.62 \ 1.76 \ -0.16010 \
ETAT_CIVIL \ Code état civil \ Veuf                              \  1.36 \ 2.04 \ -0.28607 \
MODE_HABI  \ Code mode d'habitation \ Logement de fonction \  0.21 \ 0.00 \ 0.50241 \
MODE_HABI  \ Code mode d'habitation \ Hébergé              \  2.48 \ 6.04 \ 0.32238 \
MODE_HABI  \ Code mode d'habitation \ Locataire            \ 12.06 \ 4.66 \ 0.92380 \
MODE_HABI  \ Code mode d'habitation \ Propriétaire         \ 85.26 \ 1.60 \ 0.00000 \
copot_ \ Comportement de paiement \ Bon     \ 92.63 \  1.72 \ 0.0000 \
copot_ \ Comportement de paiement \ Moyen   \  5.17 \  5.41 \ 0.88512 \
copot_ \ Comportement de paiement \ Mauvais \  2.20 \ 13.11 \ 2.33682 \
secteur_ \ Secteur d'activité \ Agriculture                  \  4.21 \ 1.07 \ 2.09787 \
secteur_ \ Secteur d'activité \ Autres                       \  5.39 \ 2.01 \ 1.92284 \
secteur_ \ Secteur d'activité \ Bâtiment et Travaux public   \ 15.51 \ 3.84 \ 1.93509 \
secteur_ \ Secteur d'activité \ Commerce de détail           \  5.98 \ 1.81 \ 1.93576 \
secteur_ \ Secteur d'activité \ Commerce de groupe           \  1.46 \ 2.47 \ 2.22961 \
secteur_ \ Secteur d'activité \ Enseignement et Auto-école   \ 22.77 \ 2.10 \ 1.38520 \
secteur_ \ Secteur d'activité \ Biens de consommation        \  2.29 \ 5.51 \ 1.77951 \
secteur_ \ Secteur d'activité \ Fabrication Chimie Pharmacie \  0.17 \ 0.00 \ 2.86145 \
secteur_ \ Secteur d'activité \ Industrie                    \  0.78 \ 2.30 \ 1.87155 \
secteur_ \ Secteur d'activité \ Hôpitaux                     \ 26.13 \ 0.55 \ 0.0000 \
secteur_ \ Secteur d'activité \ Hôtellerie, Restauration     \  2.60 \ 4.51 \ 2.05388 \
secteur_ \ Secteur d'activité \ Immobilier                   \  2.02 \ 1.79 \ 1.43408 \
secteur_ \ Secteur d'activité \ Métallurgie                  \  0.17 \ 0.00 \ 1.12465 \
secteur_ \ Secteur d'activité \ Réparateur automobile        \  1.22 \ 2.22 \ 1.34567 \
secteur_ \ Secteur d'activité \ Services                     \  6.21 \ 2.32 \ 1.68833 \
secteur_ \ Secteur d'activité \ Transport                    \  3.08 \ 5.85 \ 2.10839 \
pc_appo_cl1 \ Pourcentage d'apport (%) \ égal à 0        \ 67.02 \ 2.30 \ 0.0000 \
pc_appo_cl1 \ Pourcentage d'apport (%) \ entre 0 et 0.2  \ 17.44 \ 2.79 \ -0.30535 \
pc_appo_cl1 \ Pourcentage d'apport (%) \ supérieur à 0.2 \ 15.55 \ 0.87 \ -1.03645 \
anc_emp_cl1 \ Ancienneté emploi (Mois) \ inférieur à 38   \ 22.08 \ 3.43 \ 0.00000 \
anc_emp_cl1 \ Ancienneté emploi (Mois) \ entre 38 et 88   \ 21.23 \ 2.97 \ -0.45443 \
anc_emp_cl1 \ Ancienneté emploi (Mois) \ entre 88 et 144  \ 17.00 \ 1.86 \ -0.77871 \
anc_emp_cl1 \ Ancienneté emploi (Mois) \ entre 144 et 243 \ 19.68 \ 1.47 \ -1.17633 \
anc_emp_cl1 \ Ancienneté emploi (Mois) \ supérieur à 243  \ 20.01 \ 0.86 \ -1.03097 \
age_cl2 \ Age Client (Années) \ inférieur à 38 \ 21.51 \ 3.10 \ 0.0000 \
age_cl2 \ Age Client (Années) \ entre 38 et 43 \ 14.56 \ 2.66 \ -0.13176 \
age_cl2 \ Age Client (Années) \ entre 43 et 49 \ 20.16 \ 2.15 \ -0.27250 \
age_cl2 \ Age Client (Années) \ entre 49 et 57 \ 26.68 \ 1.76 \ -0.42667 \
age_cl2 \ Age Client (Années) \ supérieur à 57 \ 17.09 \ 1.21 \ -0.63266 \
;
run;



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


proc sql;
create table ref3 as(
select *, round(1000*(delta/10.55749)) as score
from ref2);
quit;

proc print data=ref3;run;


					  /********************************************************************************/
					  /*******************************  Machine Learning *******************************/
					  /********************************************************************************/


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
 class rep ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 age_cl2; 
 model rep (event="Yes") = ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 age_cl2;
 grow gini ;
 prune costcomplexity;  
run;
quit;


/* Estimation du modèle avec 58 feuilles terminales */

ods graphics on;
ods output TreePerformance=Tree_perf;

proc hpsplit data=train_arbre seed=15531 cvcc;
 class rep ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 age_cl2; 
 model rep (event="Yes") = ind_cli_rnva etat_civil mode_habi copot_ secteur pc_appo_cl1 anc_emp_cl1 age_cl2;       
 grow gini ;
 prune costcomplexity(leaves=58);  
 code file='titiscore.sas';
 rules file='rules.txt';
 output out = scorapp;
run;
quit;

/* AUC = 0.78 */

/* Scoring pour les exemples de l'échantillon test */

data tree;
set test_arbre;
%include 'titiscore.sas';
run;

data tree2;
 set tree;
 length yhat 3;
  if P_repYes<0.09 then yhat=0;
  else yhat=1;
run;

proc freq data=tree2;
 table rep*yhat /nocol nopercent;
run;

/* 74.3% de 0 bien prédits et 63.33% de 1 bien prédits */


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

/* Résultat: Gini = 0.5577 */


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

/* Résultat : 0.3083 */

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
 input secteur etat_civil mode_habi/ level=nominal;
 input anc_emp_cl1 pc_appo_cl1 age_cl2 copot_/ level=ordinal;
 input ind_cli_rnva /level=binary;
 save file='rfscoring.bin';
run;
quit;

proc hp4score data=rf_test;
 score file='rfscoring.bin' out=rf_test2;
run;


data rf_test3;
 set rf_test2;
  if P_repYES>0.09 then y_hat="Yes";
  else y_hat="No";
run;

proc freq data=rf_test3;
 table rep*y_hat /nocol nopercent ;
run;





									/* -------------------------------------------- 
												 Calcul de l'indice Gini 	
									   -------------------------------------------- */



/* On utilise l'AUC de l'échantillon train et on applique la formule de gini dans le cas d'une variable binaire */

data gini;
AUC=0.7828;
   Gini=AUC*2-1;
 run;

proc print data=gini noobs;run;

/* Résultat: Gini = 0.5656 */



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

/* On récupère les 10% des individus les moins bien notés par le score */

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

/* Résultat : 0.42916 */


