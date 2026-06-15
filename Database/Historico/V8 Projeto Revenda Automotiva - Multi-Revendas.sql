--===========================================
-- CRIANDO TABELA DE MULTI-REVENDAS UTILIZANDO UUID
--===========================================

CREATE TABLE revendas (
    codigo SERIAL PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    nome_fantasia VARCHAR(150) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(150),
    endereco VARCHAR(260),
    cidade VARCHAR(150),
    estado VARCHAR(2),
    cep VARCHAR(10),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativa BOOLEAN DEFAULT TRUE

);
--============================================
-- CRIANDO RELACIONAMENTO FORNECEDOR X REVENDA
-- TABELA INTERMEDIARIA POIS UM FORNECEDOR PODE COMPRAR DE MUITAS REVENDAS
-- E MUITAS REVENDAS PODE COMPRAR DE VARIOS FORNECEDORES OU SEJA N:N
--============================================

CREATE TABLE fornecedor_revenda (
    codigo SERIAL PRIMARY KEY,
    fornecedor_codigo INT NOT NULL,
    revenda_codigo INT NOT NULL,

    FOREIGN KEY (fornecedor_codigo)
    REFERENCES fornecedores(codigo),

    FOREIGN KEY (revenda_codigo)
    REFERENCES revendas(codigo)
);

--=============================================
-- CRIANDO FKS DE REVENDA, ADICIONANDO REVENDA AOS CLIENTES, FUNCIONARIOS, AUTOMOVEIS, VENDAS
--=============================================

ALTER TABLE clientes
ADD COLUMN revenda_codigo INT;

ALTER TABLE clientes
ADD CONSTRAINT fk_cliente_revenda
FOREIGN KEY (revenda_codigo)
REFERENCES revendas(codigo);

ALTER TABLE funcionarios
ADD COLUMN revenda_codigo INT;

ALTER TABLE funcionarios
ADD CONSTRAINT fk_funcionario_revenda
FOREIGN KEY (revenda_codigo)
REFERENCES revendas(codigo);

ALTER TABLE automoveis
ADD COLUMN revenda_codigo INT;

ALTER TABLE automoveis
ADD CONSTRAINT fk_automovel_revenda
FOREIGN KEY (revenda_codigo)
REFERENCES revendas(codigo);

ALTER TABLE vendas
ADD COLUMN revenda_codigo INT;

ALTER TABLE vendas
ADD CONSTRAINT fk_venda_revenda
FOREIGN KEY (revenda_codigo)
REFERENCES revendas(codigo);

--===============================================
-- INSERINDO REVENDAS
--===============================================

INSERT INTO revendas
(
    razao_social,
    nome_fantasia,
    cnpj,
    telefone,
    email,
    endereco,
    cidade,
    estado,
    cep
)
VALUES
(
    'revenda SUL LTDA',
    'Revenda SUL',
    '12.133.144/0002-80',
    '(51)98922-1314',
    'contato@revendasul.com',
    'Av. Assis Brasil, 1000',
    'Porto Alegra',
    'RS',
    '91000-000'
);

INSERT INTO revendas
(
    razao_social,
    nome_fantasia,
    cnpj,
    telefone,
    email,
    endereco,
    cidade,
    estado,
    cep
)
VALUES
(
    'Premium Motors LTDA',
    'Premium Motors',
    '34.551.890/0001-22',
    '(51) 9222-5454',
    'contato@premiummotors.com',
    'Rua Flores da Cunha, 500',
    'Canoas',
    'RS',
    '92000-000'
);

INSERT INTO revendas
(
razao_social,
nome_fantasia,
cnpj,
telefone,
email,
endereco,
cidade,
estado,
cep
)
VALUES
(
'Top Cars LTDA',
'Top Cars',
'33.333.333/0001-33',
'(51) 99999-3333',
'contato@topcars.com',
'Av. Presidente Vargas, 700',
'Novo Hamburgo',
'RS',
'93000-000'
);

SELECT * FROM revendas;

--=======================================
-- TESTE DO RELACIONAMENTOS
--=======================================

INSERT INTO clientes
(
    nome,
    cpf,
    telefone,
    email,
    revenda_codigo
)
VALUES
(
'Alisson Silva',
'123.454.233-11',
'(11) 98205-4331',
'alissonsilva@email.com',
1
);
--===========================================
-- TESTE RELACIONAMENTO CLIENTES E REVENDAS
--===========================================

UPDATE clientes
SET revenda_codigo = 1
WHERE codigo IN (3);

UPDATE clientes
SET revenda_codigo = 2
WHERE codigo IN (2);

UPDATE clientes
SET revenda_codigo = 3
WHERE codigo IN (1);

UPDATE clientes
SET
endereco = 'Av. Osvaldo Aranha, 700',
cidade = 'Porto Alegre',
estado = 'RS'
WHERE codigo IN (6);
--================================================
-- TESTE RELACIONAMENTO FUNCIONARIOS E REVENDAS
--================================================

UPDATE funcionarios
SET revenda_codigo = 1
WHERE codigo IN (1);

UPDATE funcionarios
SET revenda_codigo = 2
WHERE codigo IN (2);

--===============================================
-- FORNECEDOR CODIGO 1 FORNECE TODAS AS REVENDAS
-- FORNECEDOR CODIGO 2 FORNECE APENAS 2 REVENDAS
--===============================================

INSERT INTO fornecedor_revenda
(fornecedor_codigo, revenda_codigo)
VALUES
(1,1);

INSERT INTO fornecedor_revenda
(fornecedor_codigo, revenda_codigo)
VALUES
(1,2);

INSERT INTO fornecedor_revenda
(fornecedor_codigo, revenda_codigo)
VALUES
(1,3);

INSERT INTO fornecedor_revenda
(fornecedor_codigo, revenda_codigo)
VALUES
(2,1);

INSERT INTO fornecedor_revenda
(fornecedor_codigo, revenda_codigo)
VALUES
(2,2);

--===========================================
-- TESTE RELACIONAMENTO AUTOMOVEIS E REVENDAS
--===========================================

UPDATE automoveis
SET revenda_codigo = 1
WHERE veiculos IN (1);

UPDATE automoveis
SET revenda_codigo = 2
WHERE veiculos IN (2);

UPDATE automoveis
SET revenda_codigo = 3
WHERE veiculos IN (4);


--===============================================
-- TESTE RELANCIONAMENTO DE VENDAS X REVENDAS
--===============================================

UPDATE vendas
SET revenda_codigo = 1
WHERE codigo IN (1);

UPDATE vendas
SET revenda_codigo = 2
WHERE codigo IN (2);

UPDATE vendas
SET revenda_codigo = 3
WHERE codigo IN (8);

--===================================================
-- TESTE DE RELATÓRIO MULTI-REVENDA
--===================================================

--ver quantidade total clientes revendas
SELECT
r.nome_fantasia,
COUNT(c.codigo) AS total_clientes
FROM revendas r
LEFT JOIN clientes c
ON c.revenda_codigo = r.codigo
GROUP BY r.nome_fantasia;

--ver quantidade total de funcionarios revendas
SELECT
r.nome_fantasia,
COUNT(f.codigo) AS total_funcionarios
FROM revendas r
LEFT JOIN funcionarios f
ON f.revenda_codigo = r.codigo
GROUP BY r.nome_fantasia;

--ver quantidade total de veiculos revendas
SELECT
r.nome_fantasia,
COUNT(a.veiculos) AS total_veiculos
FROM revendas r
LEFT JOIN automoveis a
ON a.revenda_codigo = r.codigo
GROUP BY r.nome_fantasia;

--ver estoque completo revendas
SELECT
a.veiculos,
a.modelo,
a.placa,
r.nome_fantasia
FROM automoveis a
INNER JOIN revendas r
ON r.codigo = a.revenda_codigo
ORDER BY r.nome_fantasia;

--teste de fornecedor atendendo várias revendas
SELECT
f.nome,
r.nome_fantasia
FROM fornecedor_revenda fr
INNER JOIN fornecedores f
ON f.codigo = fr.fornecedor_codigo
INNER JOIN revendas r
ON r.codigo = fr.revenda_codigo
ORDER BY f.nome;

