create database Prova2;

use Prova2;

-- Nota que tirei: 5.5
/*
	Otimizacoes:
	Normalizar codigo de tipo de usuario, telefone, emails, cidade, Area da publicacao, Afiliacao do autor,  Assim garante a qualidade dos dados e unicidade.
*/
-- 1)
-- (valia 2,5, me atribuo 2,3)
create table Cidade(cod_cidade INT, nome VARCHAR(50),
					 PRIMARY KEY(cod_cidade));

create table tipo_usuario(cod_tipo_usuario INT, descrição_tipo_usuario VARCHAR(50),
						   PRIMARY KEY(cod_tipo_usuario));

create table Usuario (matricula INT, nome VARCHAR(50), cod_tipo_usuario INT,
						PRIMARY KEY(matricula),
                        FOREIGN KEY(cod_tipo_usuario) references tipo_usuario(cod_tipo_usuario));

create table telefone(matricula INT, cod_telefone INT, telefone CHAR(11),
						PRIMARY KEY (matricula,cod_telefone),
                        FOREIGN KEY (matricula) references Usuario (matricula));

create table emailUsuario (matricula INT, email_usuario VARCHAR(100),
					PRIMARY KEY(matricula,email_usuario),
					FOREIGN KEY (matricula) REFERENCES Usuario(matricula));


create table Editora(cod_editora INT, nome VARCHAR(50), cod_cidade INT,
						PRIMARY KEY (cod_editora),
                        FOREIGN KEY(cod_cidade) references Cidade(cod_cidade));

create table Area(cod_area INT, descricao_area VARCHAR(100),
	PRIMARY KEY(cod_area));

create table Publicacao(isbn INT, título VARCHAR(50), data_publicacao DATE,
							cod_editora INT,cod_area INT,
							PRIMARY KEY (isbn),
                            FOREIGN KEY (cod_editora) references Editora(cod_editora),
                            FOREIGN KEY (cod_area) references Area(cod_area));

create table Periodico(isbn INT, serie INT, volume INT,
						PRIMARY KEY (isbn),
                        FOREIGN KEY (isbn) references Publicacao(isbn));

create table Exemplar(isbn INT, sequencial INT,
						PRIMARY KEY (isbn,sequencial),
                        FOREIGN KEY KET (isbn) references Publicacao(isbn));

create table Livro(isbn INT, resumo VARCHAR(100), edicao INT,
						PRIMARY KEY (isbn),
						FOREIGN KEY (isbn) references Publicacao(isbn));

create table Emprestimo(matricula INT, isbn INT, sequencial INT, data_emprestimo DATE,  dataLimiteDevolucao DATE,
							PRIMARY KEY(matricula,isbn,sequencial,data_emprestimo),
							FOREIGN KEY (matricula) references Usuario(matricula),
							FOREIGN KEY(isbn, sequencial) references Exemplar(isbn,sequencial));

create table Devolucao(matricula INT, isbn INT, sequencial INT, data_emprestimo DATE,  dataDevolucao DATE, vlrMulta FLOAT,
					PRIMARY KEY(matricula,isbn,sequencial,data_emprestimo),
					FOREIGN KEY(matricula, isbn, sequencial, data_emprestimo) references Emprestimo(matricula, isbn, sequencial, data_emprestimo));

create table Avaliacao(matricula INT, isbn INT, numEstrelas CHAR(5), comentario VARCHAR(25),
						PRIMARY KEY(matricula,isbn),
                        FOREIGN KEY(matricula) references Usuario(matricula),
                        FOREIGN KEY(isbn) references Livro(isbn));

create table PalavraChave(cod_palavrachave INT, nome_palavra_chave VARCHAR(100),
PRIMARY KEY(cod_palavrachave));

create table Artigo(cod_artigo INT, pagInicio INT, pagFim INT, resumo VARCHAR(100), titulo VARCHAR(25), isbn INT, cod_palavrachave INT,
					PRIMARY KEY(cod_artigo),
                    FOREIGN KEY(isbn) references Periodico(isbn),
                    FOREIGN KEY(cod_palavrachave) references PalavraChave(cod_palavrachave));

create table Afiliacao(cod_afiliacao INT, nome_afiliacao VARCHAR(100),
					PRIMARY KEY(cod_afiliacao));

create table Autor(cod_autor INT, nome VARCHAR(50), cod_afiliacao INT,
					PRIMARY KEY(cod_autor),
					FOREIGN KEY (cod_afiliacao) REFERENCES Afiliacao(cod_afiliacao));

create table emailAutor (cod_autor INT, email_autor VARCHAR(100),
					PRIMARY KEY(cod_autor,email_autor),
					FOREIGN KEY (cod_autor) REFERENCES Autor(cod_autor));


create table AutorLivro(cod_autor INT, isbn INT,
						PRIMARY KEY (cod_autor,isbn),
						FOREIGN KEY (cod_autor) references Autor(cod_autor),
						FOREIGN KEY (isbn) references Livro(isbn));

create table AutorArtigo(cod_autor INT, cod_artigo INT,
						 PRIMARY KEY (cod_autor,cod_artigo),
						 FOREIGN KEY (cod_autor) references Autor(cod_autor),
						 FOREIGN KEY (cod_artigo) references Artigo(cod_artigo));

-- 2)
-- (valia 1,0, me atribuo 1,0)
-- a) Obter o nome do usuário e a respectivas descrição das áreas que emprestou publicações em 2017 (1 ponto).

Select Usuario.nome, Area.descricao_area from Usuario
INNER JOIN Emprestimo ON (Usuario.matricula = Emprestimo.matricula)
INNER JOIN Publicacao ON (Publicacao.isbn = Emprestimo.isbn)
INNER JOIN Area ON (Publicacao.cod_area = Area.cod_area);

-- correta
Select Usuario.nome, Area.descricao_area from Usuario
INNER JOIN Emprestimo ON (Usuario.matricula = Emprestimo.matricula)
INNER JOIN Publicacao ON (Publicacao.isbn = Emprestimo.isbn)
INNER JOIN Area ON (Publicacao.cod_area = Area.cod_area);


-- b) Obter o nome do usuário, filiado a UFPR, que não emprestou publicações em 2017 na área da computação (1,5 pontos).
-- (valia 1,5, me atribuo 0,0)
select Usuario.nome
from Usuario
where Usuario.matricula not in ( select matricula from Emprestimo INNER JOIN
Publicacao ON (Publicacao.isbn = Emprestimo.isbn) INNER JOIN Area
 ON (Publicacao.cod_area = Area.cod_area)  where year(data_emprestimo)=2017
 AND (descricao_area = "computacao"));

 -- c) Qual é o nome do usuário que mais emprestou publicações tendo como palavra-chave “Data Mining” (1 ponto).
-- (valia 1,0, me atribuo 0,0)
SELECT
	Usuario.nome,
	count(Usuario.nome) AS Cont
FROM Usuario  INNER JOIN Emprestimo  ON (Usuario.matricula = Emprestimo.matricula)
INNER JOIN Publicacao ON (Publicacao.isbn = Emprestimo.isbn)
INNER JOIN Periodico ON (Publicacao.isbn = Periodico.isbn)
INNER JOIN Artigo ON (Publicacao.isbn = Artigo.isbn)
WHERE (Artigo.`palavra_chave` = "Data Mining")
GROUP BY Usuario.matricula
ORDER BY Cont DESC
LIMIT 1;

-- corrigido
SELECT Usuario.nome, from Usuario
INNER join Emprestimo on Usuario.matricula =  Emprestimo.matricula
INNER JOIN Exemplar ON emprestimo.isbn = exemplar.isbn
inner join Publicacao on exemplar.isbn = Publicacao.isbn
inner join Area on Publicacao.cod_area =  Area.cod_area
where Area.descricao_area = 'Data Mining'
ORDER BY COUNT(usuario.nome) DESC
LIMIT 1;

-- d) Qual é o nome do usuário que não gerou multa em relação a data de devolução, em outubro de 2017 (1 ponto).
-- (valia 1,0, me atribuo 0,8)
--pois tem que lembrar de popular
-- botar NULL, senao o Where fica 0.0 se popular com float zero
SELECT Usuario.nome from Usuario
INNER JOIN Devolucao on Usuario.matricula = Devolucao.matricula
WHERE Devolucao.vlrMulta IS NULL
GROUP BY Devolucao.matricula
ORDER BY COUNT(Devolucao.vlrMulta)
BETWEEN '10/01/2017' AND '10/31/2017';

-- correta, somente na hora de popular tem que lembrar de por NULL,
--ou 0.0 e a comparacao no where ser igual

SELECT Usuario.nome from Usuario
INNER JOIN Devolucao on Usuario.matricula = Devolucao.matricula
WHERE Devolucao.vlrMulta = 0.0
GROUP BY Devolucao.matricula
ORDER BY COUNT(Devolucao.vlrMulta)
BETWEEN '10/01/2017' AND '10/31/2017';


/*
 3)
 -- (valia 1,5, me atribuo 0,0)
 D
a) Como a a transacao 3 foi feita corretamente com start e commit,
todos que aparecem o item V oi VI serao descartadas
b)Aparece o item VI
c) idem a b
d) CORRETA
e)idem a b e c

Correcao
3)
B – A transação II foi comitada antes do checkpoint entao não precisa ser desfeita
C - A transação I nao foi comitada,deve ser desfeita
D – A transação III não passou pelo checkpoint tambem deve ser desfeita
E - Na opcao III esta errada, ja pode ser descartado

Resposta certa A.


-4)
-- (valia 1,5, me atribuo 1,5)
B

a)Nao pode pois usaria somente se quisesse saber quem trabalha na mesma empresa,
interseccao ela une os que participam do mesmo conjunto

b) CORRETA

c)

d) Assim seria para solicitar unicamente uma pessoa ou alguma firma

e) Pode ser afirmado sim.

4)
correcao
A - as tabelas não são do mesmo tipo
C - as tabelas não são do mesmo tipo
D - não será necessário selecionar nada
E - para plano de consulta nao precisa dos dados no momento

Resposta B.
*/





/* Modelo reorganizado com Periodico Corrigido e
 Devolucao e Emprestimo otimizadas as PK
*/

create table Cidade(cod_cidade INT, nome VARCHAR(50),
					 PRIMARY KEY(cod_cidade));

create table tipo_usuario(cod_tipo_usuario INT, descrição_tipo_usuario VARCHAR(50),
						   PRIMARY KEY(cod_tipo_usuario));

create table Usuario (matricula INT, nome VARCHAR(50), cod_tipo_usuario INT,
						PRIMARY KEY(matricula),
                        FOREIGN KEY(cod_tipo_usuario) references tipo_usuario(cod_tipo_usuario));

create table telefone(matricula INT, cod_telefone INT, telefone CHAR(11),
						PRIMARY KEY (matricula,cod_telefone),
                        FOREIGN KEY (matricula) references Usuario (matricula));

create table emailUsuario (matricula INT, email_usuario VARCHAR(100),
					PRIMARY KEY(matricula,email_usuario),
					FOREIGN KEY (matricula) REFERENCES Usuario(matricula));


create table Editora(cod_editora INT, nome VARCHAR(50), cod_cidade INT,
						PRIMARY KEY (cod_editora),
                        FOREIGN KEY(cod_cidade) references Cidade(cod_cidade));

create table Area(cod_area INT, descricao_area VARCHAR(100),
	PRIMARY KEY(cod_area));

create table Publicacao(isbn INT, título VARCHAR(50), data_publicacao DATE,
							cod_editora INT,cod_area INT,
							PRIMARY KEY (isbn),
                            FOREIGN KEY (cod_editora) references Editora(cod_editora),
                            FOREIGN KEY (cod_area) references Area(cod_area));
-- novo modelo de periodico
create table Periodico(isbn INT, serie INT, volume INT,
						PRIMARY KEY (isbn,serie,volume),
                        FOREIGN KEY (isbn) references Publicacao(isbn));

create table Exemplar(isbn INT, sequencial INT,
						PRIMARY KEY (isbn,sequencial),
                        FOREIGN KEY KET (isbn) references Publicacao(isbn));

create table Livro(isbn INT, resumo VARCHAR(100), edicao INT,
						PRIMARY KEY (isbn),
						FOREIGN KEY (isbn) references Publicacao(isbn));

/*create table Emprestimo(matricula INT, isbn INT, sequencial INT, data_emprestimo DATE,  dataLimiteDevolucao DATE,
							PRIMARY KEY(matricula,isbn,sequencial,data_emprestimo),
							FOREIGN KEY (matricula) references Usuario(matricula),
							FOREIGN KEY(isbn, sequencial) references Exemplar(isbn,sequencial));

create table Devolucao(matricula INT, isbn INT, sequencial INT, data_emprestimo DATE,  dataDevolucao DATE, vlrMulta FLOAT,
					PRIMARY KEY(matricula,isbn,sequencial,data_emprestimo),
					FOREIGN KEY(matricula, isbn, sequencial, data_emprestimo) references Emprestimo(matricula, isbn, sequencial, data_emprestimo));
*/
-- Antigas tabelas acima e novas abaixo
create table Emprestimo(cod_circulacao INT,matricula INT, isbn INT, sequencial INT, data_emprestimo DATE,  dataLimiteDevolucao DATE,
							PRIMARY KEY(cod_circulacao),
							FOREIGN KEY (matricula) references Usuario(matricula),
							FOREIGN KEY(isbn, sequencial) references Exemplar(isbn,sequencial));
create table Devolucao(cod_circulacao INT,matricula INT, isbn INT, sequencial INT, data_emprestimo DATE,  dataDevolucao DATE, vlrMulta FLOAT,
							PRIMARY KEY(cod_circulacao),
							FOREIGN KEY(cod_circulacao) references Emprestimo(cod_circulacao));

create table Avaliacao(cod_circulacao INT,matricula INT, isbn INT, numEstrelas CHAR(5), comentario VARCHAR(25),
						PRIMARY KEY(cod_circulacao),
                        FOREIGN KEY(matricula) references Usuario(matricula),
                        FOREIGN KEY(isbn) references Livro(isbn));

create table PalavraChave(cod_palavrachave INT, nome_palavra_chave VARCHAR(100),
PRIMARY KEY(cod_palavrachave));

create table Artigo(cod_artigo INT, pagInicio INT, pagFim INT, resumo VARCHAR(100), titulo VARCHAR(25), isbn INT, cod_palavrachave INT,
					PRIMARY KEY(cod_artigo),
                    FOREIGN KEY(isbn) references Periodico(isbn),
                    FOREIGN KEY(cod_palavrachave) references PalavraChave(cod_palavrachave));

create table Afiliacao(cod_afiliacao INT, nome_afiliacao VARCHAR(100),
					PRIMARY KEY(cod_afiliacao));

create table Autor(cod_autor INT, nome VARCHAR(50), cod_afiliacao INT,
					PRIMARY KEY(cod_autor),
					FOREIGN KEY (cod_afiliacao) REFERENCES Afiliacao(cod_afiliacao));

create table emailAutor (cod_autor INT, email_autor VARCHAR(100),
					PRIMARY KEY(cod_autor,email_autor),
					FOREIGN KEY (cod_autor) REFERENCES Autor(cod_autor));


create table AutorLivro(cod_autor INT, isbn INT,
						PRIMARY KEY (cod_autor,isbn),
						FOREIGN KEY (cod_autor) references Autor(cod_autor),
						FOREIGN KEY (isbn) references Livro(isbn));

create table AutorArtigo(cod_autor INT, cod_artigo INT,
						 PRIMARY KEY (cod_autor,cod_artigo),
						 FOREIGN KEY (cod_autor) references Autor(cod_autor),
						 FOREIGN KEY (cod_artigo) references Artigo(cod_artigo));
