drop database ReservaAerea;
create database ReservaAerea;
use ReservaAerea;

create table Aeroporto (codAero int,
nomeAero varchar(50),
primary key(codAero));

create table Cidade (codCidade int,
nomeCidade varchar(50),
primary key(codCidade));

create table RestricaoAlimentar (codRestricao int,
nomeRestricao varchar(50),
primary key(codRestricao));

create table Pais (codPais int,
nomePais varchar(50),
primary key(codPais));

create table CEP (cep int,
nomeRua varchar(50),
primary key(cep));

create table Passageiro (codPassa int,
nomePassa varchar(50),
cep int,
numeroRua int,
complemento varchar(50),
codCidade int,
codPais int,
codRestricao int,
primary key(codPassa),
foreign key(cep) references CEP(cep),
foreign key(codCidade) references Cidade(codCidade),
foreign key(codRestricao) references RestricaoAlimentar(codRestricao),
foreign key(codPais) references Pais(codPais));


create table Voo (codVoo int,
dataVoo date,
codAeroOrigem int,
codAeroDestino int,
primary key(codVoo, dataVoo),
foreign key(codAeroOrigem) references Aeroporto(codAero),
foreign key(codAeroDestino) references Aeroporto(codAero));

create table ClasseVoo (codClasse int,
nomeClasse varchar(30),
primary key(codClasse));

create table Reserva (codReserva int,
dataVoo date,
codVoo int,
codPassa int,
codClasse int,
valor float,
idAssento varchar(3),
primary key(codVoo, dataVoo,codReserva,codPassa,idAssento),
foreign key(codPassa) references Passageiro(codPassa),
foreign key(codVoo,dataVoo) references Voo(codVoo,dataVoo),
foreign key(codClasse) references ClasseVoo(codClasse));

insert into Aeroporto values (001,'Guarulhos');
insert into Aeroporto values (002,'Curitiba');
insert into Aeroporto values (003,'POA');

insert into Cidade values (001,'Jaragua do Sul');
insert into Cidade values (002,'Brasilia');
insert into Cidade values (003,'Floripa');

insert into RestricaoAlimentar values (001,'Siliaco');
insert into RestricaoAlimentar values (002,'Lactose');

insert into Pais values (001,'Brazil');
insert into Pais values (002,'Mexico');
insert into Pais values (003,'Portugal');


insert into CEP values (89253295,'Joao Januario');
insert into CEP values (89253296,'Marechal');
insert into CEP values (89253297,'Reinaldo Jose');

insert into Voo values (001,'2017/09/01',001,002);
insert into Voo values (002,'2017/09/04',003,002);

insert into ClasseVoo values (001,'Economica');
insert into ClasseVoo values (002,'Executiva');

insert into Passageiro values (001,'Johnny',89253295,1980,'casa',001,001,001);
insert into Passageiro values (002,'Mater',89253296,1981,'casa',002,002,001);
insert into Passageiro values (003,'Gabree',89253297,1983,'apto',002,003,002);


insert into Reserva values (001,'2017/09/01',001,001,001,154.20,'B6');
insert into Reserva values (001,'2017/09/01',001,002,001,154.20,'B6');
insert into Reserva values (001,'2017/09/04',002,003,001,154.20,'B6');




/*Quais são os países dos passageiros dos voos que saem do aeroporto de Guarulhos em primeiro de setembro de
2017?
*/

SELECT Pais.nomePais FROM Aeroporto INNER JOIN Voo
ON Voo.codAeroOrigem = Aeroporto.codAero
INNER JOIN Reserva ON Reserva.codVoo = Voo.codVoo
INNER JOIN Passageiro ON Passageiro.codPassa = Reserva.codPassa
INNER JOIN Pais
WHERE Aeroporto.nomeAero = "Guarulhos" AND Reserva.dataVoo = "2017/09/01";


/*Quais são as restrições alimentares de cada um dos passageiros?
Sendo que no result set deverá constar o nome do passageiro e seu respectivo código.
*/

SELECT RestricaoALimentar.codRestricao, RestricaoAlimentar.nomeRestricao FROM RestricaoAlimentar
INNER JOIN Passageiro ON RestricaoALimentar.codRestricao = Passageiro.codRestricao
WHERE Passageiro.codPassa = 001;
