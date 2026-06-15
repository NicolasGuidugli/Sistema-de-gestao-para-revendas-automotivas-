-- ====================================
-- V1 CRIAÇÃO BANCO DE DADOS PROJETO REVENDA AUTOMOTIVA
-- ====================================

CREATE TABLE categoria (
    codigo SERIAL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

-- ====================================
-- TABELA  AUTOMOVEIS 
-- ====================================

CREATE TABLE automoveis (
    veiculos SERIAL PRIMARY KEY,

    carro VARCHAR(300) NOT NULL,

    moto VARCHAR(300),

    marca VARCHAR(300) NOT NULL,

    placa VARCHAR(30) UNIQUE NOT NULL,

    ano INT CHECK (ano >= 1900),

    fipe DECIMAL(10,2),

    data_cadastro DATE DEFAULT CURRENT_DATE,

    categoria_codigo INT,

    FOREIGN KEY (categoria_codigo)
    REFERENCES categoria(codigo)
);

-- ====================================
-- INSERIR CATEGORIAS
-- ====================================

INSERT INTO categoria (descricao)
VALUES ('Sedan');

INSERT INTO categoria (descricao)
VALUES ('SUV');

INSERT INTO categoria (descricao)
VALUES ('Hatch');

INSERT INTO categoria (descricao)
VALUES ('Moto');

INSERT INTO categoria (descricao)
VALUES ('Caminhonete');

-- ====================================
-- INSERIR AUTOMOVEIS
-- ====================================

INSERT INTO automoveis
(
carro,
moto,
marca,
placa,
ano,
fipe,
categoria_codigo
)

VALUES
(
'Civic',
NULL,
'Honda',
'EDN9F15',
2020,
95000.00,
1
);

INSERT INTO automoveis
(
carro,
moto,
marca,
placa,
ano,
fipe,
categoria_codigo
)

VALUES
(
'Corolla',
NULL,
'Toyota',
'DEF5678',
2021,
110000.00,
1
);

-- ====================================
-- CONSULTA COM JOIN
-- ====================================

SELECT
automoveis.veiculos,
automoveis.carro,
automoveis.marca,
categoria.descricao AS categoria

FROM automoveis

JOIN categoria
ON automoveis.categoria_codigo = categoria.codigo;

SELECT*FROM automoveis;

-- ====================================
-- V2 PROJETO REVENDA AUTOMOTIVA -MELHORIAS E EVOLUÇÕES
-- ====================================

ALTER TABLE automoveis
ADD modelo VARCHAR(300);

--=====================================
-- COPIAR DADOS PARA COLUNA MODELO
--======================================

UPDATE automoveis
SET modelo = carro;

--=====================================
-- REMOVER OBRIGATORIEDADE DA COLUNA CARRO (NOT NULL)
--=====================================

ALTER TABLE automoveis
ALTER COLUMN carro DROP NOT NULL;

--=====================================
-- INSERIR NOVO AUTOMÓVEL
--=====================================

INSERT INTO automoveis
( modelo, marca, placa, ano, fipe, categoria_codigo)
VALUES
('CG 160', 'Honda', 'XYZ7760', 2023, 18000.00, 4);

--=====================================
-- CRIAR VIEW PARA EXIBIR AUTOMÓVEIS COM CATEGORIA
--=====================================

CREATE VIEW vw_automoveis AS
SELECT
a.veiculos,
a.marca,
a.modelo,
a.placa,
a.ano,
a.fipe,
c.descricao AS categoria
FROM automoveis a
JOIN categoria c
ON a.categoria_codigo = c.codigo;

--=====================================
-- APAGAR COLUNAS DE CARRO E MOTO
--=====================================

ALTER TABLE automoveis
DROP COLUMN carro;

ALTER TABLE automoveis
DROP COLUMN moto;

--=====================================
-- CONSULTAR A VIEW DE AUTOMÓVEIS
--=====================================

SELECT * FROM vw_automoveis;

--=====================================
-- TORNAR CATEGORIA OBRIGATÓRIA
--=====================================

ALTER TABLE automoveis
ALTER COLUMN categoria_codigo SET NOT NULL;

--=====================================
-- ADICIONAR NOVA COLUNA PARA COR DO VEÍCULO
--=====================================

ALTER TABLE automoveis
ADD COLUMN cor VARCHAR(50);

--=====================================
-- ADICIONAR COLUNA QUILOMETRAGEM
--=====================================

ALTER TABLE automoveis
ADD COLUMN quilometragem INT;

--=====================================
-- ADICIONAR STATUS DO VEÍCULO
--=====================================

ALTER TABLE automoveis
ADD COLUMN status VARCHAR(20) DEFAULT 'Disponível';

--=====================================
-- UPDATE (APRENDENDO CRUD) ATUALIZANDO CORES DOS VEÍCULOS
--=====================================

UPDATE automoveis
SET cor = 'Prata',
    quilometragem = 45000,
    status = 'Disponível'
WHERE veiculos = 1;

UPDATE automoveis
SET cor = 'Branco',
    quilometragem = 30000,
    status = 'Disponível'
WHERE veiculos = 2;

UPDATE automoveis
SET cor = 'Vermelho',
    quilometragem = 5000,
    status = 'Disponível'
WHERE veiculos = 4;

--=====================================
-- CONCEITO: CHECK para QUILOMETRAGEM
--=====================================

ALTER TABLE automoveis
ADD CONSTRAINT chk_quilometragem CHECK (quilometragem >= 0);

--ISSO IMPEDIRÁ QUE SEJA INSERIDO UM VALOR NEGATIVO NA COLUNA QUILOMETRAGEM, GARANTINDO A INTEGRIDADE DOS DADOS.

--=====================================
-- CONCEITO NOVO: ORDER BY PARA ORDENAR OS RESULTADOS
--=====================================

SELECT*FROM automoveis
ORDER BY ano DESC; --DESC ORDENA DO MAIOR PARA O MENOR, OU SEJA, DO MAIS RECENTE PARA O MAIS ANTIGO. 

SELECT*FROM automoveis
ORDER BY ano ASC; --ASC ORDENA DO MENOR PARA O MAIOR, OU SEJA, DO MAIS ANTIGO PARA O MAIS RECENTE.

--=====================================
-- CONCEITO NOVO: FILTROS
--=====================================

SELECT*FROM automoveis
WHERE marca = 'Honda'; --EXIBE APENAS OS VEÍCULOS DA MARCA HONDA.

SELECT*FROM automoveis
WHERE ano >= 2020; --EXIBE APENAS OS VEÍCULOS DO ANO 2020 OU MAIS RECENTES.

--=====================================
-- CONCEITO NOVO: COUNT PARA CONTAR O NÚMERO DE VEÍCULOS EXISTEMTES
--=====================================

SELECT COUNT(*)
FROM automoveis
WHERE categoria_codigo = 1;

--=====================================
-- CONCEITO NOVO: SUM PARA SOMAR O VALOR DE TODOS OS VEÍCULOS
--=====================================

SELECT SUM(fipe)
FROM automoveis;

--=====================================
-- MELHORANDO A VIEW DE AUTOMÓVEIS PARA INCLUIR COR E STATUS
--=====================================

DROP VIEW vw_automoveis;

CREATE VIEW vw_automoveis AS
SELECT
a.veiculos,
a.modelo,
a.marca,
a.placa,
a.ano,
a.fipe,
a.cor,
a.quilometragem,
a.status,
a.data_cadastro,
a.valor_compra,
f.nome AS fornecedor,
c.descricao AS categoria
FROM automoveis a
JOIN categoria c
ON a.categoria_codigo = c.codigo
LEFT JOIN fornecedores f
ON a.fornecedor_codigo = f.codigo;

--=====================================
-- ATUALIZANDO VALORES QUE EU PAGUEI EM CADA VEICULO
--=====================================

ALTER TABLE automoveis
ADD COLUMN valor_compra NUMERIC(10,2);

UPDATE automoveis
SET valor_compra = 80000.00
WHERE veiculos = 1;

UPDATE automoveis
SET valor_compra = 90000.00
WHERE veiculos = 2;

UPDATE automoveis
SET valor_compra = 15000.00
WHERE veiculos = 4;

--=====================================
-- ADICIONANDO UMA RESTRIÇÃO PARA EVITAR VALORES INVÁLIDOS NO STATUS DO VEÍCULO
--=====================================

ALTER TABLE automoveis
ADD CONSTRAINT chk_status
CHECK (
    status IN (
        'Disponível',
        'Vendido',
        'Em manutenção'
    )
);









