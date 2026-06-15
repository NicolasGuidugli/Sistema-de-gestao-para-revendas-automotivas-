--=======================================
-- V4 CRIANDO TABELA DE VENDAS
--=======================================

CREATE TABLE vendas (
    codigo SERIAL PRIMARY KEY,
    cliente_codigo INT NOT NULL,
    veiculo_codigo INT NOT NULL,
    data_venda DATE DEFAULT CURRENT_DATE,
    valor_venda DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (cliente_codigo) REFERENCES clientes(codigo),
    FOREIGN KEY (veiculo_codigo) REFERENCES automoveis(veiculos)
);

SELECT*FROM vendas;

--=====================================
-- ADICIONANDO COLUNA DE GARANTIA
--=====================================

ALTER TABLE vendas
ADD COLUMN garantia_ate DATE;

--=======================================
-- INSERINDO DADOS DE VENDAS
--=======================================

INSERT INTO vendas
(cliente_codigo, veiculo_codigo, valor_venda, garantia_ate)
VALUES
(1, 1, 95000.00, CURRENT_DATE + INTERVAL '90 days'),
(2, 2, 110000.00, CURRENT_DATE + INTERVAL '90 days');

--======================================
-- CONSULTANDO VENDAS COM DETALHES DE CLIENTE E VEÍCULO COM JOIN MULTIPLO
--======================================

CREATE VIEW vw_vendas AS
SELECT
v.codigo, c.nome AS cliente, 
a.modelo AS veiculo, 
v.data_venda, v.valor_venda, v.garantia_ate FROM vendas v
JOIN clientes c 
ON v.cliente_codigo = c.codigo
JOIN automoveis a 
ON v.veiculo_codigo = a.veiculos;

SELECT*FROM vw_vendas;

--======================================
-- APAGANDO VIEW vw_vendas PARA CRIAR UMA NOVA COM INFORMAÇÕES DE FUNCIONÁRIO
--======================================

DROP VIEW vw_vendas;

--======================================
-- QUANDO UM VEICULO FOR VENDIDO, ATUALIZAR O STATUS PARA VENDIDO
--======================================

UPDATE automoveis
SET status = 'Vendido'
WHERE veiculos = 1;

UPDATE automoveis
SET status = 'Vendido'
WHERE veiculos = 2;

--======================================
-- CONSULTANDO VEÍCULOS POR STATUS
--======================================

SELECT*FROM automoveis
WHERE status = 'Vendido';

SELECT*FROM automoveis
WHERE status = 'Disponível';   

SELECT COUNT(*)
FROM automoveis
WHERE status = 'Disponível';

--======================================
-- ADICIONANDO COLUNA DE FUNCIONARIO RESPONSÁVEL PELA VENDA
--======================================

ALTER TABLE vendas
ADD COLUMN funcionario_codigo INT;

ALTER TABLE vendas
ADD CONSTRAINT fk_vendas_funcionario
FOREIGN KEY (funcionario_codigo)
REFERENCES funcionarios(codigo);

--======================================
-- CONSULTANDO VENDAS COM DETALHES DE CLIENTE, VEÍCULO E FUNCIONÁRIO DASHBOARD DE VENDAS
--======================================

CREATE VIEW vw_dashboar_revenda AS
SELECT

(SELECT COUNT(*) FROM automoveis) AS total_veiculos,
(SELECT COUNT(*)
FROM automoveis
WHERE status = 'Disponível') AS veiculos_disponiveis,

(SELECT COUNT(*)
FROM automoveis
WHERE status = 'Vendido') AS veiculos_vendidos,

(SELECT COUNT(*) FROM clientes) AS total_clientes,
(SELECT COUNT(*) FROM funcionarios) AS total_funcionarios,
(SELECT COUNT(*) FROM vendas) AS total_vendas,

(SELECT COALESCE(SUM(valor_venda), 0)
FROM vendas) AS faturamento_total;

SELECT*FROM vw_dashboar_revenda;

--======================================
-- CRIANDO RANKING DE MELHORES VENDEDORES
--======================================

CREATE VIEW vw_ranking_vendedores AS
SELECT

f.codigo,
f.nome,

COUNT(v.codigo) AS quantidade_vendas,
SUM(v.valor_venda) AS faturamento
FROM funcionarios f
LEFT JOIN vendas v
ON f.codigo = v.funcionario_codigo
GROUP BY f.codigo, f.nome

ORDER BY faturamento DESC;

SELECT*FROM vw_ranking_vendedores;

--======================================
-- INSERINDO A PRIMEIRA VENDA COM AUTOMAÇÃO DE STATUS DE ESTOQUE
--======================================

INSERT INTO vendas
(cliente_codigo, veiculo_codigo, valor_venda,
garantia_ate, funcionario_codigo)
VALUES
(1, 4, 18000.00, CURRENT_DATE + INTERVAL '90 days', 1);

--======================================
-- INSERINDO INFORMAÇÕES DE PAGAMENTOS
--======================================

ALTER TABLE vendas
ADD COLUMN forma_pagamento VARCHAR(50);

ALTER TABLE vendas
ADD banco_financiador VARCHAR(100);

UPDATE vendas
SET forma_pagamento = 'Financiamento'
WHERE codigo = 1;

UPDATE vendas
SET forma_pagamento = 'À vista'
WHERE codigo = 2;

UPDATE vendas
SET banco_financiador = 'Bradesco'
WHERE codigo = 1;

UPDATE vendas
SET forma_pagamento = 'À vista'
WHERE codigo = 8;

--======================================
-- CRIANDO UMA VIEW DE LUCRO
--======================================

CREATE VIEW vw_lucro_vendas AS
SELECT
v.codigo AS venda,
a.modelo,
a.valor_compra,
v.valor_venda,
(v.valor_venda - a.valor_compra) AS lucro,
c.nome AS cliente,
f.nome AS vendedor
FROM vendas v
JOIN automoveis a
ON v.veiculo_codigo = a.veiculos
JOIN clientes c
ON v.cliente_codigo = c.codigo
LEFT JOIN funcionarios f
ON v.funcionario_codigo = f.codigo;

SELECT*FROM vw_lucro_vendas;












