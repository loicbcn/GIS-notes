```sql
SET search_path = public;

-------------------- Gestionnaire
CREATE TABLE sups.GESTIONNAIRE_SUP (
	IdGest varchar(9) PRIMARY KEY,
	nomGest varchar(80) NOT NULL,
	nomCorres varchar(80),
	numTel varchar(10),
	courriel varchar(80),
	adresse varchar(254)
);

-------------------- Servitude
CREATE TYPE sups.typmodeprod AS ENUM ('import', 'numérisation', 'reconstitution');

CREATE TABLE sups.SERVITUDE_SUP (
	IdSup varchar(40) PRIMARY KEY,
	IdGest varchar(9) NOT NULL,
	nomSup varchar(100) NOT NULL,
	nomSupLitt varchar(100),
	categorie varchar(10) NOT NULL,
	idIntGest varchar(25),
	descriptio varchar(254),
	dateMaj date NOT NULL,
	echNum INTEGER,
	valideGest boolean NOT NULL,
	obsValidat varchar(254),
	modeProd typmodeprod NOT NULL,
	quiProd varchar(80),
		check(modeProd = 'numérisation' AND quiProd IS NOT NULL ),
	docSource varchar(80),
		check(modeProd = 'numérisation' AND docSource IS NOT NULL )
);

-------------------- Acte
CREATE TYPE sups.typdecision AS ENUM ('Création', 'Modification', 'Substitution');
CREATE TYPE sups.typtypeacte AS ENUM ('Texte de loi', 'Décret en Conseil d''État', 'Décret Premier Ministre', 'Décret', 'Arrêté ministériel', 'Arrêté Préfet de Région', 'Arrêté préfectoral', 'Arrêté de SUP', 'Arrêté municipal', 'Autre', 'Non renseigné');

CREATE TABLE sups.ACTE_SUP (
	IdActe varchar(40) PRIMARY KEY,
	nomActe varchar(100) NOT NULL,
	reference varchar(50) NOT NULL DEFAULT 'inconnu',
	typeActe  typtypeacte NOT NULL DEFAULT 'Non renseigné',
	fichier varchar(254) NOT NULL,
	decision typdecision NOT NULL DEFAULT 'Création',
	dateDecis date NOT NULL,
	datePub date,
	aPlan boolean
);

-------------------- Servitude_Acte
CREATE TABLE sups.SERVITUDE_ACTE_SUP (
	IdSup varchar(40),
	IdActe varchar(40),
	PRIMARY KEY(IdSup, IdActe)
);

-------------------- Générateur
CREATE TABLE sups.GENERATEUR_SUP(
	geom_s geometry,
	geom_l geometry,
	geom_p geometry,
	IdGen varchar(40) PRIMARY KEY,
	IdSup varchar(40) NOT NULL,
	nomGen varchar(100) NOT NULL,
	typeGen varchar(40) NOT NULL,
	modeGenere varchar(50),
	srcGeoGen varchar(30),
	dateSrcGen date,
	refBDExt varchar(50),
	idBDExt varchar(50)
);


-------------------- Assiette
CREATE TYPE sups.typdmodegeoass AS ENUM ('Egal au générateur', 'Zone tampon', 'Digitalisation', 'Duplication', 'Liste de coordonnées', 
									'Secteur angulaire', 'Calculée', 'Liste de parcelles', 'Fictive');
CREATE TABLE sups.ASSIETTE_SUP(
	geom_s geometry,
	geom_l geometry,
	geom_p geometry,
	IdAss varchar(40) PRIMARY KEY,
	IdGen varchar(40),
	nomAss varchar(100) NOT NULL,
	typeAss varchar(40) NOT NULL,
	modeGeoAss typdmodegeoass NOT NULL,
	paramCalc integer,
	srcGeoAss varchar(30),
	dateSrcAss date
);
```
