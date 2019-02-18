DROP DATABASE Hospital;
CREATE DATABASE Hospital;
USE Hospital;

create table Convenio(
	codigo_convenio int,
    nome varchar(20),
    primary key (codigo_convenio)
);

create table Doencas_CID(
	codigo int,
    descricao varchar(20),
    primary key (codigo)
);

create table Paciente(
	numero_paciente int,
    nome varchar(20),
    RG int,
    CPF int,
    endereco varchar(40),
    primary key (numero_paciente)
);

create table Paciente_doencas(
	numero_paciente int,
    codigo_doenca int,
    primary key (numero_paciente, codigo_doenca),
    foreign key (numero_paciente) references Paciente(numero_paciente),
    foreign key (codigo_doenca) references Doencas_CID(codigo)
);

create table Medico(
	CRM int,
    UF varchar(2),
    nome varchar(20),
    RG int,
    CPF int,
    endereco varchar(40),
    primary key(CRM, UF)
);

create table Paciente_convenio(
	codigo_convenio int,
    numero_paciente int,
    primary key (codigo_convenio,numero_paciente),
    foreign key (codigo_convenio) references Convenio(codigo_convenio),
    foreign key (numero_paciente) references Paciente(numero_paciente)
);

create table Medico_convenio(
	codigo_convenio int,
    CRM int,
    UF varchar(2),
    primary key (codigo_convenio, CRM, UF),
    foreign key (codigo_convenio) references Convenio(codigo_convenio),
    foreign key (CRM, UF) references Medico(CRM, UF)
);

create table Exames(
	codigo_exame int,
    descricao varchar(20),
    primary key (codigo_exame)
);

create table Medicamento(
	codigo_medicamento int,
    descricao varchar(20),
    primary key(codigo_medicamento)
);

create table Consulta(
	codigo_convenio int,
    numero_paciente int,
    CRM int,
    UF varchar(2),
    data_hora date,
    queixas varchar(40),
    primary key (codigo_convenio, numero_paciente, CRM, UF, data_hora),
    foreign key (codigo_convenio, numero_paciente) references Paciente_convenio(codigo_convenio, numero_paciente),
	foreign key (CRM, UF) references Medico(CRM,UF)
);

create table Consulta_diagnostico(
	codigo_convenio int,
    numero_paciente int,
    CRM int,
    UF varchar(2),
    data_hora date,
    codigo_diagnostico int,
    primary key (codigo_convenio, numero_paciente, CRM, UF, data_hora, codigo_diagnostico),
    foreign key (codigo_convenio, numero_paciente, CRM, UF, data_hora) references Consulta(codigo_convenio, numero_paciente, CRM, UF, data_hora),
    foreign key (codigo_diagnostico) references Doencas_CID(codigo)
);

create table Consulta_exames(
	codigo_convenio int,
    numero_paciente int,
    CRM int,
    UF varchar(2),
    data_hora date,
    codigo_exame int,
    resultado varchar(100),
    primary key (codigo_convenio, numero_paciente, CRM, UF, data_hora, codigo_exame),
    foreign key (codigo_convenio, numero_paciente, CRM, UF, data_hora) references Consulta(codigo_convenio, numero_paciente, CRM, UF, data_hora),
    foreign key (codigo_exame) references Exames (codigo_exame)
);

create table Consulta_medicamento(
	codigo_convenio int,
    numero_paciente int,
    CRM int,
    UF varchar(2),
    data_hora DATE,
    codigo_medicamento int,
    primary key (codigo_convenio, numero_paciente, CRM, UF, data_hora, codigo_medicamento),
    foreign key (codigo_convenio, numero_paciente, CRM, UF, data_hora) references Consulta(codigo_convenio, numero_paciente, CRM, UF, data_hora),
    foreign key (codigo_medicamento) references Medicamento (codigo_medicamento)
);

#Convenio(codigo_convenio int, nome varchar(20));
insert into Convenio values (1,'Convenio 1');
insert into Convenio values (2,'Convenio 2');

#Doencas_CID(codigo int, descricao varchar(20));
insert into Doencas_CID values (1,'diabetes');
insert into Doencas_CID values (2,'Dengue');
insert into Doencas_CID values (3,'Doencas 3');

# Paciente(numero_paciente int, nome varchar(20), RG int, CPF int,endereco varchar(40));
insert into Paciente values (1,'Paciente 1', 123, 321, 'rua das batatas');
insert into Paciente values (2,'Paciente 2', 234, 432, 'rua das batatas');
insert into Paciente values (3,'Paciente 3', 345, 543, 'rua dos tomates');
insert into Paciente values (4,'Paciente 4', 456, 654, 'rua das bananas');
insert into Paciente values (5,'Paciente 5', 567, 765, 'rua das bananas');

#Paciente_doencas(numero_paciente int, codigo_doenca int));
insert into Paciente_doencas values (1,1);
insert into Paciente_doencas values (1,2);
insert into Paciente_doencas values (2,3);
insert into Paciente_doencas values (2,1);
insert into Paciente_doencas values (3,2);
insert into Paciente_doencas values (3,3);
insert into Paciente_doencas values (4,3);
insert into Paciente_doencas values (5,2);

#Medico(CRM int, UF varchar(2), nome varchar(20), RG int, CPF int, endereco varchar(40));
insert into Medico values (1,'PR', 'Medico 1 PR', 123, 123, 'rua das bananas');
insert into Medico values (2,'PR', 'Medico 2 PR', 234, 234, 'rua das amoras');
insert into Medico values (1,'SP', 'Medico 1 SP', 345, 345, 'rua das maÃ§as');

#Paciente_convenio(codigo_convenio int, numero_paciente int);
insert into Paciente_convenio values (1,1);
insert into Paciente_convenio values (2,2);
insert into Paciente_convenio values (1,3);
insert into Paciente_convenio values (2,4);
insert into Paciente_convenio values (1,5);

#Medico_convenio(codigo_convenio int, CRM int, UF varchar(2));
insert into Medico_convenio values (1,1,'PR');
insert into Medico_convenio values (2,2,'PR');
insert into Medico_convenio values (1,1,'SP');

#Exames(codigo_exame int, descricao varchar(20));
insert into Exames values (1,'Exame 1');
insert into Exames values (2,'Exame 2');
insert into Exames values (3,'Exame 3');
insert into Exames values (4,'Exame 4');

#Medicamento(codigo_medicamento int, descricao varchar(20));
insert into Medicamento values (1,'Medicamento 1');
insert into Medicamento values (2,'Aspirina Prevent');
insert into Medicamento values (3,'Medicamento 3');
insert into Medicamento values (4,'Medicamento 4');
insert into Medicamento values (5,'Medicamento 1');
insert into Medicamento values (6,'Medicamento 1');

#create table Consulta(codigo_convenio int, numero_paciente int, CRM int, UF varchar(2), data_hora date, queixas varchar(40));
insert into Consulta values (1, 1, 1, 'PR', '2015-01-07','queixa 1');
insert into Consulta values (2, 2, 2, 'PR', '2015-02-06','queixa 2');
insert into Consulta values (1, 3, 1, 'PR', '2015-03-05','queixa 3');
insert into Consulta values (2, 4, 2, 'PR', '2015-04-04','queixa 4');
insert into Consulta values (1, 5, 1, 'SP', '2015-05-03','queixa 5');
insert into Consulta values (2, 4, 1, 'SP', '2015-06-02','queixa 6');
insert into Consulta values (1, 3, 1, 'PR', '2015-07-01','queixa 7');

#create table Consulta_diagnostico(codigo_convenio int, numero_paciente int, CRM int, UF varchar(2),  data_hora date,  codigo_diagnostico int));
insert into Consulta_diagnostico values (1, 1, 1, 'PR', '2015-01-07',1);
insert into Consulta_diagnostico values (2, 2, 2, 'PR', '2015-02-06',2);
insert into Consulta_diagnostico values (1, 3, 1, 'PR', '2015-03-05',3);
insert into Consulta_diagnostico values (2, 4, 2, 'PR', '2015-04-04',1);
insert into Consulta_diagnostico values (1, 5, 1, 'SP', '2015-05-03',2);
insert into Consulta_diagnostico values (2, 4, 1, 'SP', '2015-06-02',3);
insert into Consulta_diagnostico values (1, 3, 1, 'PR', '2015-07-01',1);

#create table Consulta_exames(codigo_convenio int, numero_paciente int, CRM int, UF varchar(2), data_hora date, codigo_exame int,  resultado varchar(100));
insert into Consulta_exames values (1, 1, 1, 'PR', '2015-01-07',1,"resultado 1");
insert into Consulta_exames values (2, 2, 2, 'PR', '2015-02-06',2,"resultado 2");
insert into Consulta_exames values (1, 3, 1, 'PR', '2015-03-05',3,"resultado 3");
insert into Consulta_exames values (2, 4, 2, 'PR', '2015-04-04',4,"resultado 4");
insert into Consulta_exames values (1, 5, 1, 'SP', '2015-05-03',1,"resultado 5");
insert into Consulta_exames values (2, 4, 1, 'SP', '2015-06-02',2,"resultado 6");
insert into Consulta_exames values (1, 3, 1, 'PR', '2015-07-01',3,"resultado 7");

#create table Consulta_medicamento(codigo_convenio int, numero_paciente int, CRM int, UF varchar(2), data_hora DATE, codigo_medicamento int));
insert into Consulta_medicamento values (1, 1, 1, 'PR', '2015-01-07',1);
insert into Consulta_medicamento values (2, 2, 2, 'PR', '2015-02-06',2);
insert into Consulta_medicamento values (1, 3, 1, 'PR', '2015-03-05',3);
insert into Consulta_medicamento values (2, 4, 2, 'PR', '2015-04-04',4);
insert into Consulta_medicamento values (1, 5, 1, 'SP', '2015-05-03',5);
insert into Consulta_medicamento values (2, 4, 1, 'SP', '2015-06-02',6);
insert into Consulta_medicamento values (1, 3, 1, 'PR', '2015-07-01',1);



#Construir as instrucoes Select que permitam extrair as seguintes informacoes. 
#Quais sao os pacientes que apresentam â€œDiabetesâ€ como uma das doencas anteriores? (2.0) 
-- Paciente, Doencas, ConsultaDiagnostico, Diabete cod= 1;

Select  Paciente.nome FROM Paciente INNER JOIN Consulta_diagnostico 
on Paciente.numero_paciente = Consulta_diagnostico.numero_paciente WHERE Consulta_diagnostico.codigo_diagnostico = 1;


#Quais sao os medicos que ja¡ receitaram pelo menos uma vez Aspirina Prevente? (2.0)



#Quais sao os medicos que atenderam pacientes com diagnostico diferencial para Dengue? (2.0)

#Crie duas situacoes distintas que para a primeira seja recomendado o uso da clausula WHERE e na segunda seja recomendado o uso da clausula HAVING. No formato de comentario, justificar o motivo pelo qual vc indica o uso do WHERE na primeira e o uso do HAVING na segunda

