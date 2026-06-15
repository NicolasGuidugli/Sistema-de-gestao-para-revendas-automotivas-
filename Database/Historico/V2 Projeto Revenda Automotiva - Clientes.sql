--====================================
-- V3 PROJETO REVENDA AUTOMOTIVA -CLIENTES
--====================================

--====================================
-- CRIAÇÃO DA TABELA CLIENTES
--====================================

CREATE TABLE clientes (
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(150),
    endereco VARCHAR(300),
    data_cadastro DATE DEFAULT CURRENT_DATE
);

SELECT * FROM clientes;

--====================================
-- MELHORANDO TABELA CLIENTES
--====================================

ALTER TABLE clientes
ADD COLUMN cidade VARCHAR(100);

ALTER TABLE clientes
ADD COLUMN estado VARCHAR(2);

--====================================
-- CRIANDO ÍNDICES
--====================================

CREATE INDEX idx_clientes_nome ON clientes(nome);

--====================================
-- INSERINDO CLIENTES
--====================================

INSERT INTO clientes
(nome, cpf, telefone, email, endereco, cidade, estado)
VALUES
('João Silva', '123.456.789-00', '(11) 98765-4321',
'joao.silva@email.com', 'Rua Exemplo, 123', 'São Paulo', 'SP');

INSERT INTO clientes
(nome, cpf, telefone, email, endereco, cidade, estado)
VALUES
('Erica Vitoria', '987.654.321-00', '(21) 91234-5678',
'erica.vitoria@email.com', 'Avenida Exemplo, 456', 'Rio de Janeiro', 'RJ');

INSERT INTO clientes
(nome, cpf, telefone, email, endereco, cidade, estado)
VALUES
('Lucas Oliveira', '555.666.777-88', '(31) 99876-5432',
'lucas.oliveira@email.com', 'Travessa Exemplo, 789', 'Belo Horizonte', 'MG');







