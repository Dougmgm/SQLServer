USE DesafioSQL;
--ESTRANGEIRO ? QUANDO O O ITEM VEM DE UMA TABELA PARA A OUTRA
CREATE SCHEMA QUALIDADE;

CREATE TABLE QUALIDADE.DADOS_AVALIACAO(
	CD_AVALIACAO CHAR(2) PRIMARY KEY NOT NULL, --MUDAN?A DE PRIMARY KEY
	NM_AVALIACAO VARCHAR(50)		 NOT NULL,
);

SELECT * FROM QUALIDADE.DADOS_AVALIACAO

CREATE TABLE QUALIDADE.FUNCIONARIO(
	CD_MATRICULA   INT         PRIMARY KEY IDENTITY(1,1),
	NM_FUNCIONARIO VARCHAR(50) NOT NULL,
);

SELECT * FROM QUALIDADE.FUNCIONARIO

CREATE TABLE QUALIDADE.PRODUCAO(
	CD_LINHA_PRODUCAO INT PRIMARY KEY NOT NULL,
);

CREATE TABLE QUALIDADE.PRODUTO(
	CD_PRODUTO INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	NM_PRODUTO VARCHAR(50)					 NOT NULL,
);

CREATE TABLE QUALIDADE.DADOS_PRODUTO(
	CD_PRODUTO        INT  PRIMARY KEY IDENTITY (1,1),
	AA_FABRICACAO     DATE NOT NULL,
	CD_LINHA_PRODUCAO INT  NOT NULL

	FOREIGN KEY(CD_LINHA_PRODUCAO) REFERENCES QUALIDADE.PRODUCAO(CD_LINHA_PRODUCAO)
);


CREATE TABLE QUALIDADE.AVALIACAO(
	CD_FICHA       INT		    PRIMARY KEY IDENTITY (1,1),
	CD_AVALIACAO   CHAR (2),
	DT_AVALIACAO   DATE,
	NM_FUNCIONARIO VARCHAR (50) NOT NULL,
	HR_INICIO_AVAL DATETIME     NOT NULL,
	HR_FINAL_AVAL  DATETIME     NOT NULL,
	CD_MATRICULA   INT          NOT NULL,
	CD_PRODUTO     INT          NOT NULL

	FOREIGN KEY (CD_AVALIACAO) REFERENCES QUALIDADE.DADOS_AVALIACAO(CD_AVALIACAO),
	FOREIGN KEY (CD_MATRICULA) REFERENCES QUALIDADE.FUNCIONARIO(CD_MATRICULA),
	FOREIGN KEY (CD_PRODUTO)   REFERENCES QUALIDADE.PRODUTO(CD_PRODUTO)
	
);

INSERT INTO QUALIDADE.DADOS_AVALIACAO(CD_AVALIACAO, NM_AVALIACAO)
VALUES ('OK', 'LIBERADO'), ('EL', 'PROBLEMA EL?TRICO'), ('PT', 'PROBLEMA DE PINTURA'), 
	   ('PE', 'PROBLEMA NA ESTRUTURA'), ('TR', 'TODO REJEITADO')

SELECT * FROM QUALIDADE.DADOS_AVALIACAO


INSERT INTO QUALIDADE.FUNCIONARIO(NM_FUNCIONARIO)
     VALUES ('TRANCOSO'), ('DOUGLAS'), ('FELIPE'), ('JULIANA'), ('CARLOS')

SELECT * FROM QUALIDADE.FUNCIONARIO

INSERT INTO QUALIDADE.PRODUCAO(CD_LINHA_PRODUCAO)
VALUES ('1'), ('2'), ('3'), ('4')

SELECT * FROM QUALIDADE.PRODUCAO

INSERT INTO QUALIDADE.PRODUTO(NM_PRODUTO) ------
     VALUES ('GELADEIRA'), ('MAQUINA DE LAVAR'), ('FOGAO'), ('FREEZER'), ('FRIGOBAR')

SELECT * FROM QUALIDADE.PRODUTO

INSERT INTO QUALIDADE.DADOS_PRODUTO(AA_FABRICACAO,CD_LINHA_PRODUCAO)
     VALUES ('2022', 2), ('2022', 1), ('2022', 1), ('2022', 3), ('2022', 3)

SELECT * FROM QUALIDADE.DADOS_PRODUTO

INSERT INTO QUALIDADE.AVALIACAO(CD_AVALIACAO, DT_AVALIACAO, NM_FUNCIONARIO, HR_INICIO_AVAL, HR_FINAL_AVAL, CD_MATRICULA, CD_PRODUTO)
	 VALUES('OK', '2022-12-01', 'TRANCOSO', '08:53', '11:00', 1, 1)
	 	  ,('EL', '2022-12-16', 'TRANCOSO', '08:48', '10:11', 1, 2)
	      ,('TR', '2022-12-22', 'TRANCOSO', '08:30', '11:30', 1, 3)
	 	  ,('EL', '2022-12-21', 'TRANCOSO', '08:30', '09:57', 1, 4)
	 	  ,('PE', '2022-12-21', 'DOUGLAS',  '08:21', '12:00', 2, 5)
	 	  ,('PT', '2022-12-21', 'FELIPE',   '08:21', '12:00', 3, 2)
	 	  ,('OK', '2022-12-21', 'JULIANA',  '08:21', '12:00', 4, 4)


SELECT * FROM QUALIDADE.AVALIACAO

--Quantas horas de controle de qualidade o inspetor Trancoso da Silva fez no dia 16/12/2022?

SELECT DATEDIFF(MINUTE, HR_INICIO_AVAL, HR_FINAL_AVAL) AS DIFERENCA
  FROM QUALIDADE.AVALIACAO 
 WHERE DT_AVALIACAO = '2022-12-16' AND CD_MATRICULA = 1
--Foi de 83 minutos

--Quantas horas o inspetor Trancoso da Silvatrabalhou no per?odo de 01/12/2022 ? 22/12/2022?

SELECT SUM(DATEDIFF(MINUTE, HR_INICIO_AVAL, HR_FINAL_AVAL)) AS TEMPOTOTAL
  FROM QUALIDADE.AVALIACAO
 WHERE CD_MATRICULA = 1 AND DT_AVALIACAO BETWEEN '2022-12-01' AND '2022-12-22'
 --Foi de 477 minutos

--Quais os tipos de defeito mais recorrentes no per?odo de 01/12/2022 ? 22/12/2022?

  SELECT COUNT(CD_AVALIACAO), CD_AVALIACAO
    FROM QUALIDADE.AVALIACAO
   WHERE DT_AVALIACAO BETWEEN '2022-12-01' AND '2022-12-22'
GROUP BY CD_AVALIACAO 
--Erro mais recorrente foi o problema el?trico (EL)

--Quais inspetores atestam mais produtos com avalia??o TR, todo rejeitado.

	SELECT COUNT(CD_AVALIACAO), NM_FUNCIONARIO
	  FROM QUALIDADE.AVALIACAO
	 WHERE CD_AVALIACAO = 'TR'
  GROUP BY NM_FUNCIONARIO
--Trancoso foi o inspetor que mais atestou

--Quais produtos que s? foram liberados depois da detec??o de algum problema?

  SELECT COUNT(CD_AVALIACAO), CD_PRODUTO
    FROM QUALIDADE.AVALIACAO
   WHERE CD_AVALIACAO != 'OK' AND CD_AVALIACAO !='TR'
GROUP BY CD_PRODUTO
--Os produtos liberados foram o 2, 4 e 5