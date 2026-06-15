--=======================================
-- V4 CRIANDO TABELA DE FUNCIONARIOS - VENDEDORES
--=======================================

CREATE TABLE funcionarios (
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    cargo VARCHAR(100) NOT NULL,
    data_admissao DATE DEFAULT CURRENT_DATE
);

SELECT * FROM funcionarios;

--=======================================
-- INSERINDO FUNCIONÁRIOS
--=======================================

INSERT INTO funcionarios
(nome, cpf, telefone, email, cargo)
VALUES
('Carlos Pereira', '111.222.333-44', '(11) 91234-5678',
'carlos.pereira@revenda.com', 'Vendedor');

INSERT INTO funcionarios
(nome, cpf, telefone, email, cargo)
VALUES
('Felipe Santos', '555.666.777-88', '(21) 98765-4321',
'felipe.santos@revenda.com', 'Vendedor');

SELECT * FROM funcionarios;

SELECT * FROM vendas;

--=======================================
-- RELACIONANDO FUNCIONÁRIOS COM VENDAS
--=======================================

UPDATE vendas
SET funcionario_codigo = 1
WHERE codigo = 1;

UPDATE vendas
SET funcionario_codigo = 2
WHERE codigo = 2;

CREATE OR REPLACE VIEW vw_vendas_completas AS
SELECT
v.codigo AS venda_codigo,
c.nome AS cliente,
a.modelo AS veiculo,
f.nome AS vendedor,
v.valor_venda, v.data_venda, v.garantia_ate FROM vendas v

JOIN clientes c
ON v.cliente_codigo = c.codigo

JOIN automoveis a
ON v.veiculo_codigo = a.veiculos

JOIN funcionarios f
ON v.funcionario_codigo = f.codigo;

SELECT * FROM vw_vendas_completas;

--======================================
-- CONTANDO O NÚMERO DE VENDAS REALIZADAS POR CADA FUNCIONÁRIO
--======================================

SELECT COUNT (*)
FROM vendas;

SELECT SUM(valor_venda)
FROM vendas;

SELECT AVG(valor_venda)
FROM vendas;

SELECT MAX(valor_venda)
FROM vendas;

SELECT MIN(valor_venda)
FROM vendas;

--======================================
-- AGRUPANDO VENDAS POR FUNCIONÁRIO PARA VER O TOTAL VENDIDO POR CADA UM
--======================================

SELECT
f.nome,
SUM(v.valor_venda) AS total_vendido
FROM vendas v
JOIN funcionarios f
ON v.funcionario_codigo = f.codigo
GROUP BY f.nome;

--======================================
-- ORDENANDO O TOTAL VENDIDO POR CADA FUNCIONÁRIO DE FORMA DECRESCENTE DO MAIOR PARA O MENOR
--======================================

SELECT
f.nome,
SUM(v.valor_venda) AS total_vendido
FROM vendas v
JOIN funcionarios f
ON v.funcionario_codigo = f.codigo
GROUP BY f.nome
ORDER BY total_vendido DESC;


