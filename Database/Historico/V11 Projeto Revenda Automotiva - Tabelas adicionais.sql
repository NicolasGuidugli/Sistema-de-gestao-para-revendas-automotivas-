--===================================
-- ADICIONANDO TABELA DE MARCAS VEICULOS
--===================================

CREATE TABLE marcas
(
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    ativo BOOLEAN DEFAULT TRUE
);

ALTER TABLE automoveis
ADD COLUMN marca_codigo INT;

ALTER TABLE automoveis
ADD CONSTRAINT fk_automoveis_marca
FOREIGN KEY (marca_codigo)
REFERENCES marcas(codigo);

INSERT INTO marcas (nome)
VALUES
('Volkswagen'),
('Chevrolet'),
('Fiat'),
('Ford'),
('Toyota'),
('Honda'),
('Hyundai'),
('BMW'),
('Mercedes-Benz'),
('Audi'),
('Dodge'),
('Yamaha');

--===============================================
-- CRIANDO TABELA DE ESPECIFICACOES DE VEICULOS
--===============================================

CREATE TABLE especificacoes_veiculos
(
    codigo SERIAL PRIMARY KEY,
    automovel_codigo  INT NOT NULL,
    potencia INT,
    cilindradas VARCHAR(20),
    combustivel VARCHAR(50),
    cambio VARCHAR(50),
    portas INT,
    observacoes TEXT,
    
    CONSTRAINT fk_especificacoes_automovel
    FOREIGN KEY (automovel_codigo)
    REFERENCES automoveis(veiculos)
);

--===============================================
-- CRIANDO TABELA FOTOS
--===============================================

CREATE TABLE fotos
(
    codigo SERIAL PRIMARY KEY,
    automovel_codigo INT NOT NULL,
    nome_arquivo VARCHAR(300),
    url_arquivo TEXT,
    principal BOOLEAN DEFAULT FALSE,
    data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fotos_automovel
    FOREIGN KEY (automovel_codigo)
    REFERENCES automoveis(veiculos)
);

--==================================================
-- CRIANDO TABELA DOCUMENTOS documentações de veiculos
--==================================================

CREATE TABLE documentos
(
    codigo SERIAL PRIMARY KEY,
    automovel_codigo INT NOT NULL,
    tipo_documento VARCHAR(100),
    numero_documento VARCHAR(100),
    arquivo_url TEXT,
    data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_documentos_automovel
    FOREIGN KEY (automovel_codigo)
    REFERENCES automoveis(veiculos)
);

--====================================================
-- CRIANDO TABELA NOTIFICAÇOES
--====================================================

CREATE TABLE notificacoes
(
    codigo SERIAL PRIMARY KEY,
    usuario_codigo INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    mensagem TEXT NOT NULL,
    lida BOOLEAN DEFAULT FALSE,
    data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_notificacao_usuario
    FOREIGN KEY (usuario_codigo)
    REFERENCES usuarios(codigo)
);

--atualizando as marcas dos automoveis

UPDATE automoveis a
SET marca_codigo = m.codigo
FROM marcas m
WHERE a.marca = m.nome;

ALTER TABLE automoveis
ALTER COLUMN marca_codigo SET NOT NULL;

ALTER TABLE automoveis
DROP COLUMN marca CASCADE;

--recriando a view_automoveis que foi apagada

CREATE VIEW view_automoveis AS
SELECT
    a.veiculos,
    m.nome AS marca,
    a.modelo,
    a.ano,
    a.placa,
    a.cor,
    a.quilometragem,
    a.status
FROM automoveis a
INNER JOIN marcas m
    ON a.marca_codigo = m.codigo;

--AlTERAR HORARIO PARA HORARIO DO BRASIL
SET timezone = 'America/Sao_Paulo';
--CONSULTAR HORARIO
SHOW timezone;

