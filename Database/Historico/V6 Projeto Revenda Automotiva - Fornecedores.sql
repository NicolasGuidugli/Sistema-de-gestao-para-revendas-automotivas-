--=====================================
-- V7 CRIANDO TABELA DE FORNECEDORES
--=====================================

CREATE TABLE fornecedores (
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(150) UNIQUE,
    cidade VARCHAR(100),
    estado VARCHAR(2)
);

INSERT INTO fornecedores
(nome, cpf_cnpj, telefone, email, cidade, estado)
VALUES
('José da Silva', '123.456.799-00', '(11) 98765-4321',
'jose.silva@email.com', 'São Paulo', 'SP'),
('Auto Peças LTDA', '12.345.678/0001-00', '(21) 91234-5678',
'autopecas@email.com', 'Rio de Janeiro', 'RJ');

--=====================================
-- ADICIONANDO FORNECEDORES AOS AUTOMÓVEIS
--=====================================

ALTER TABLE automoveis
ADD fornecedor_codigo INT;

ALTER TABLE automoveis
ADD FOREIGN KEY (fornecedor_codigo) REFERENCES fornecedores(codigo);

UPDATE automoveis
SET fornecedor_codigo = 1
WHERE veiculos IN (1, 2);

UPDATE automoveis
SET fornecedor_codigo = 2
WHERE veiculos = 4;



