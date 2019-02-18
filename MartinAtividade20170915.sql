drop database VendaCarro;
create database VendaCarro;

use VendaCarro;

create table Cor (codCor int,
nomeCor varchar(50),
primary key(codCor));

create table Transmissao (codTrans int,
nomeTrans varchar(50),
primary key(codTrans));

create table Carro (chassi int,
modelo varchar(50),
lugares int,
codCor int,
codTrans int,
primary key(chassi),
foreign key(codCor) references Cor(codCor),
foreign key(codTrans) references Transmissao(codTrans));

create table Pessoa (CPF int,
nomePessoa varchar(50),
endereco varchar(50),
primary key(CPF));

create table Venda (NF int,
CPF int,
chassi int,
dataVenda date,
primary key(NF),
foreign key(CPF) references Pessoa(CPF),
foreign key(chassi) references Carro(chassi));


insert into Cor values (001,'Verde');
insert into Cor values (002,'Azul');
insert into Cor values (003,'Preto');

insert into Transmissao values (001,'Automatico');
insert into Transmissao values (002,'Manual');


insert into Carro values (001,'Toyota Hilux', 5, 001, 002);
insert into Carro values (002,'Ford Ranger', 5, 001, 002);
insert into Carro values (003,'Toyota Hilux', 6, 002, 002);
insert into Carro values (004,'Toyota Hilux', 6, 002, 002);
insert into Carro values (005,'Toyota Hilux', 4, 003, 001);
insert into Carro values (006,'Ford Mustang', 4, 003, 001);

insert into Pessoa values (1234,'Gabriel Johnny', 'Sao Paulo');
insert into Pessoa values (4321,'Alfred Barkley', 'Arizona');
insert into Pessoa values (7890,'Martin Spikes', 'Curitiba');

insert into Venda values (001,1234, 001, '2016/07/04');
insert into Venda values (002,4321, 002, '2016/08/06');
insert into Venda values (003,1234, 003, '2016/12/06');
insert into Venda values (103,7890, 004, '2017/08/02');
insert into Venda values (104,1234, 005, '2014/10/25');
insert into Venda values (105,4321, 006, '2015/10/25');

-- create index idxPessoaNome on  Pessoa (nomePessoa);

-- 1) Encontre a e o codigo da pessoa cujo nome "Gabriel Johnny"
SELECT Pessoa.nomePessoa, Pessoa.CPF FROM Pessoa WHERE nomePessoa = "Gabriel Johnny";

-- 2) Encontre o nome de todos compradores que comprar o carro "Toyota Hilux"
SELECT Pessoa.nomePessoa FROM Pessoa
INNER JOIN Venda
ON Venda.CPF = Pessoa.CPF
INNER JOIN Carro
ON Carro.chassi = Venda.chassi
WHERE Carro.modelo = "Toyota Hilux";

-- 3) Para cada venda realizda, o nome do compradores e o nome do modelo do veiculo
SELECT Pessoa.nomePessoa, Carro.modelo, Venda.dataVenda FROM Pessoa INNER JOIN Venda ON
Venda.CPF = Pessoa.CPF
INNER JOIN Carro
ON Carro.chassi = Venda.chassi;


-- 4) Mostre todos os modelos de carro que determninando CPF comprou
select Carro.modelo
from Pessoa
inner join Venda
on Venda.CPF = Pessoa.CPF
inner join Carro
on Carro.chassi = Venda.chassi
where Pessoa.CPF = 4321;
