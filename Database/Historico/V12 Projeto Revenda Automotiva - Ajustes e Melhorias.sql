--============================================
-- V13 CORREÇÕES E AJUSTES FINAIS
--============================================

--============================================
-- USUARIOS
--============================================

ALTER TABLE usuarios
RENAME COLUMN senha TO senha_hash;

ALTER TABLE usuarios
ADD COLUMN funcionario_codigo INT;

ALTER TABLE usuarios
ADD COLUMN ultimo_login TIMESTAMP;

ALTER TABLE usuarios
ADD CONSTRAINT fk_usuario_funcionario
FOREIGN KEY (funcionario_codigo)
REFERENCES funcionarios(codigo);

--================================================
-- FORNECEDORES
--================================================

ALTER TABLE fornecedores
DROP COLUMN cpf_cnpj;

ALTER TABLE fornecedores
ADD COLUMN tipo_pessoa VARCHAR(2)
CHECK (tipo_pessoa IN ('PF', 'PJ'));

ALTER TABLE fornecedores
ADD COLUMN cpf VARCHAR(14);

ALTER TABLE fornecedores
ADD COLUMN cnpj VARCHAR(18);

ALTER TABLE fornecedores
ADD CONSTRAINT uk_fornecedor_cpf UNIQUE (cpf);

ALTER TABLE fornecedores
ADD CONSTRAINT uk_fornecedor_cnpj UNIQUE (cnpj);

SELECT *
FROM fornecedores;

UPDATE fornecedores
SET tipo_pessoa = 'PF',
cpf = '22344590001',
cnpj = NULL
WHERE codigo = 1;

UPDATE fornecedores
SET tipo_pessoa = 'PJ',
cpf = NULL,
cnpj = '01223967832109'
WHERE codigo = 2;

ALTER TABLE fornecedores
ADD CONSTRAINT chk_fornecedor_documento
CHECK (
    (
        tipo_pessoa = 'PF'
        AND cpf IS NOT NULL
        AND cnpj IS NULL
    )
    OR
    (
        tipo_pessoa = 'PJ'
        AND cnpj IS NOT NULL
        AND cpf IS NULL
    )
);

--=================================================
-- AUDITORIA
--=================================================

ALTER TABLE auditoria
ADD COLUMN ip_origem VARCHAR(45);

ALTER TABLE auditoria
ADD COLUMN revenda_codigo INT;

ALTER TABLE auditoria
ADD CONSTRAINT fk_auditoria_revenda
FOREIGN KEY (revenda_codigo)
REFERENCES revendas(codigo);

--Garante existencia da coluna JSONB

ALTER TABLE auditoria
ADD COLUMN IF NOT EXISTS dados_registro JSONB;

CREATE EXTENSION IF NOT EXISTS "pgcrypto";



--==================================================
-- REVENDAS
--==================================================

ALTER TABLE revendas
ADD COLUMN uuid_revenda UUID
DEFAULT gen_random_uuid();

ALTER TABLE revendas
ADD COLUMN status_revenda VARCHAR(20);

UPDATE revendas
SET status_revenda = CASE 
    WHEN ativa = TRUE THEN 'ATIVA' 
    ELSE  'INATIVA'
END;

SELECT codigo, nome_fantasia, ativa, status_revenda
FROM revendas;

ALTER TABLE revendas
ALTER COLUMN status_revenda SET NOT NULL;

ALTER TABLE revendas
ADD CONSTRAINT chk_status_revenda
CHECK (
    status_revenda IN
    (
        'ATIVA',
        'INATIVA',
        'BLOQUEADA',
        'ENCERRADA'
    )
);

ALTER TABLE revendas
DROP COLUMN ativa;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'revendas';

--==================================================
-- FUNCIONARIOS
--==================================================

ALTER TABLE funcionarios
ADD COLUMN status_funcionario VARCHAR(20)
DEFAULT 'Ativo'
CHECK ( status_funcionario IN ( 'Ativo', 'Inativo', 'Afastado') );

--=================================================
-- MANUTENCAO_VEICULOS
--=================================================

ALTER TABLE manutencao_veiculos
ADD COLUMN oficina VARCHAR(200);

--=================================================
-- FOTOS
--=================================================

ALTER TABLE fotos
ADD COLUMN tipo_imagem VARCHAR(30);

ALTER TABLE fotos
ADD COLUMN ordem_exibicao INT DEFAULT 1;

--================================================
-- INDICES
--================================================

CREATE INDEX idx_clientes_revenda
ON clientes(revenda_codigo);

CREATE INDEX idx_funcionarios_revenda
ON funcionarios(revenda_codigo);

CREATE INDEX idx_usuarios_revenda
ON usuarios(revenda_codigo);

CREATE INDEX idx_automoveis_revenda
ON automoveis(revenda_codigo);

CREATE INDEX idx_vendas_revenda
ON vendas(revenda_codigo);

CREATE INDEX idx_automoveis_status
ON automoveis(status);

CREATE INDEX idx_vendas_data
ON vendas(data_venda);

CREATE INDEX idx_auditoria_data
ON auditoria(data_evento);