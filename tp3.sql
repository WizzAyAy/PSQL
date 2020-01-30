drop table if exists matiere CASCADE;
drop table if exists formation CASCADE;
drop table if exists etudiant CASCADE;
drop table if exists enseignant CASCADE;
drop table if exists tabnote CASCADE;
drop table if exists stat_resultat CASCADE;

CREATE TABLE etudiant
(
    numet INT PRIMARY KEY NOT NULL,
    nom VARCHAR(100),
    prenom VARCHAR(100)
);
--\d etudiant;

CREATE TABLE enseignant
(
    numens INT PRIMARY KEY NOT NULL,
    nomens VARCHAR(100),
    prenomens VARCHAR(100)
);
--\d enseignant;

CREATE TABLE formation
(
    nomform VARCHAR(100) PRIMARY KEY NOT NULL,
    nbretud int,
    enseignantresponsable int
);
--\d formation;

CREATE TABLE matiere
(
    nommat VARCHAR(100),
    nomform VARCHAR(100),
    numens int,
    coef int,
    primary key (nommat,nomform),
    FOREIGN KEY (numens) REFERENCES enseignant (numens)
);
--\d matiere;

CREATE TABLE tabnote
(
    numetud int,
    nommat varchar(100),
    nomform varchar(100),
    note int,
    primary key (numetud, nommat, nomform)   
);
--\d tabnote;

CREATE TABLE stat_resultat
(
    nomformation VARCHAR(100),
    moygeneral int,
    nbrrecu int,
    nbretdpres int,
    notemax int,
    notemin int
);
\d stat_resultat;

insert into etudiant values 
	(1,'quentin',	'maignan'),
	(2,'christophe','lafargue'),
	(3,'guillaume',	'trem');
--select * from etudiant;

insert into enseignant values
	(1,'davido','davide'),
	(2,'erico','eric'),
	(3,'igoat','stephen');
--select * from enseignant;

insert into formation values
	('L1',150,1),
	('L2',100,2),
	('L3',70,3);
--select * from formation;

insert into matiere values
	('cours de c++',	'L1',1,6),
	('fondement',		'L2',2,5),
	('systeme d image',	'L3',3,3);
--select * from matiere;
	
insert into tabnote values
	(1,'cours de c++',		'L1', 20),
	(1,'fondement',	  		'L2', 12),
	(1,'systeme d image',	'L3', 10),
	(2,'cours de c++',		'L1', 12),
	(2,'fondement',			'L2', 18),
	(2,'systeme d image',	'L3', 5),
	(3,'cours de c++',		'L1', 8.5),
	(3,'fondement',			'L2', 20),
	(3,'systeme d image',	'L3', 17);
--select * from tabnote;




DROP FUNCTION moyNote();
CREATE FUNCTION moyNote() RETURNS float AS
$$
DECLARE
	NoteCurs CURSOR for SELECT note, coef FROM tabnote as t natural join matiere as m;
	totnote int;
	nbnote int;	
	moy float;
BEGIN

		totnote := 0;
		nbnote := 0;
		for i in NoteCurs
		LOOP
			totnote = i.note * i.coef + totnote;
			nbnote = i.coef + nbnote; 
		END LOOP; 
			moy = totnote / nbnote;
			return moy;	

END;
$$ LANGUAGE 'plpgsql';


select e.nom, e.prenom, t.nommat, t.note 
from etudiant as e join tabnote t on e.numet = t.numetud 
where t.note > moyNote();


DROP FUNCTION moyNote_formation(forma VARCHAR(100));
CREATE FUNCTION moyNote_formation(forma VARCHAR(100)) RETURNS float AS
$$
DECLARE
	NoteCurs CURSOR for SELECT * FROM tabnote as t 
	natural join formation as f 
	natural join matiere as m 
	where nomform=forma;
	
	totnote int;
	nbnote int;	
	moy float;
BEGIN
		totnote := 0;
		nbnote := 0;
		for i in NoteCurs
		LOOP
			totnote = i.note * i.coef + totnote;
			nbnote = i.coef + nbnote; 
		END LOOP; 
			moy = totnote / nbnote;
			return moy;		

END;
$$ LANGUAGE 'plpgsql';


select moyNote_formation('L3');


DROP FUNCTION stat_form();
CREATE FUNCTION stat_form() RETURNS void AS
$$
DECLARE
	
	
BEGIN
	insert into stat_resultat values
		('L1', moyNote_formation('L1')),
		('L2', moyNote_formation('L2')),
		('L3', moyNote_formation('L3'));
	

END;
$$ LANGUAGE 'plpgsql';

select stat_form();
select * from stat_resultat;


DROP FUNCTION suivipar(int num);
CREATE FUNCTION suivipar(int num) RETURNS void AS
$$
DECLARE
	curs CURSOR for SELECT * FROM etudiant 
	natural join formation as f 
	natural join matiere as m 
	where numet=num;
	
BEGIN

	for i in curs
	LOOP
	
	END LOOP;

END;
$$ LANGUAGE 'plpgsql';










