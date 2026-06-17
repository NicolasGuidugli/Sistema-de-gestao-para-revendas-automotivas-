--================================================
-- V14 CRIANDO TABELA DE ASSINATURAS
--================================================

CREATE TABLE assinaturas
( codigo SERIAL PRIMARY KEY,
revenda_codigo INT NOT NULL,
valor_mensal NUMERIC(10,2) NOT NULL,
status VARCHAR(20) NOT NULL
CHECK
(
    status IN
    ('ATIVA',
    'ATRASADA',
    'SUSPENSA',
    'CANCELADA')
),
data_inicio DATE NOT NULL,
data_fim DATE,
data_vencimento DATE NOT NULL,
data_ultimo_pagamento DATE,
dias_tolerancia INT DEFAULT 20,
observacoes TEXT,
data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fk_assinatura_revenda
FOREIGN KEY (revenda_codigo)
REFERENCES revendas(codigo)

);

CREATE UNIQUE INDEX uk_assinatura_ativa
ON assinaturas(revenda_codigo)
WHERE status = 'ATIVA';

SELECT*FROM assinaturas;

ALTER TABLE assinaturas
ADD CONSTRAINT chk_dias_tolerancia
CHECK (dias_tolerancia >= 0);

ALTER TABLE assinaturas
ADD CONSTRAINT chk_periodo_assinatura
CHECK (
    data_fim IS NULL
    OR data_fim >= data_inicio
);
