-- ============================================================
-- SISTEMA DE GESTÃO DE REVENDA AUTOMOTIVA SAAS
-- Autor: Nicolas Guidugli
-- Descrição: Versão final consolidada do banco de dados.
--            Este arquivo representa o estado definitivo do schema,
--            sem histórico de alterações, testes ou dados fictícios.
-- ============================================================

-- ============================================================
-- EXTENSÕES
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- CONFIGURAÇÃO DE TIMEZONE
-- ============================================================

SET timezone = 'America/Sao_Paulo';

-- ============================================================
-- TABELA: revendas
-- Cada revenda é um tenant (cliente) do sistema SaaS.
-- uuid_revenda é usado no frontend para nunca expor o ID numérico.
-- ============================================================

CREATE TABLE revendas (
    codigo          SERIAL PRIMARY KEY,
    uuid_revenda    UUID NOT NULL DEFAULT gen_random_uuid(),
    razao_social    VARCHAR(150) NOT NULL,
    nome_fantasia   VARCHAR(150) NOT NULL,
    cnpj            VARCHAR(18) UNIQUE NOT NULL,
    telefone        VARCHAR(20),
    email           VARCHAR(150),
    endereco        VARCHAR(260),
    cidade          VARCHAR(150),
    estado          VARCHAR(2),
    cep             VARCHAR(10),
    status_revenda  VARCHAR(20) NOT NULL DEFAULT 'ATIVA',
    data_cadastro   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_status_revenda
    CHECK (status_revenda IN ('ATIVA', 'INATIVA', 'BLOQUEADA', 'ENCERRADA')),

    CONSTRAINT uk_uuid_revenda
    UNIQUE (uuid_revenda)
);

-- ============================================================
-- TABELA: assinaturas
-- Controla o plano SaaS de cada revenda.
-- ============================================================

CREATE TABLE assinaturas (
    codigo                  SERIAL PRIMARY KEY,
    revenda_codigo          INT NOT NULL,
    valor_mensal            NUMERIC(10,2) NOT NULL,
    status                  VARCHAR(20) NOT NULL,
    data_inicio             DATE NOT NULL,
    data_fim                DATE,
    data_vencimento         DATE NOT NULL,
    data_ultimo_pagamento   DATE,
    dias_tolerancia         INT DEFAULT 20,
    observacoes             TEXT,
    data_cadastro           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_assinatura_revenda
        FOREIGN KEY (revenda_codigo) REFERENCES revendas(codigo),

    CONSTRAINT chk_status_assinatura
        CHECK (status IN ('ATIVA', 'ATRASADA', 'SUSPENSA', 'CANCELADA')),

    CONSTRAINT chk_dias_tolerancia
        CHECK (dias_tolerancia >= 0),

    CONSTRAINT chk_periodo_assinatura
        CHECK (data_fim IS NULL OR data_fim >= data_inicio)
);

-- Garante que cada revenda tenha apenas uma assinatura ATIVA por vez
CREATE UNIQUE INDEX uk_assinatura_ativa
    ON assinaturas(revenda_codigo)
    WHERE status = 'ATIVA';

-- ============================================================
-- TABELA: marcas
-- Marcas de veículos disponíveis no sistema.
-- ============================================================

CREATE TABLE marcas (
    codigo  SERIAL PRIMARY KEY,
    nome    VARCHAR(100) NOT NULL UNIQUE,
    ativo   BOOLEAN DEFAULT TRUE
);

INSERT INTO marcas (nome) VALUES
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

-- ============================================================
-- TABELA: categoria
-- Categorias de veículos (Sedan, SUV, Hatch, etc).
-- ============================================================

CREATE TABLE categoria (
    codigo    SERIAL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

INSERT INTO categoria (descricao) VALUES
('Sedan'),
('SUV'),
('Hatch'),
('Moto'),
('Caminhonete');

-- ============================================================
-- TABELA: funcionarios
-- Todos os funcionários de todas as revendas.
-- status_funcionario controla se o funcionário está ativo.
-- ============================================================

CREATE TABLE funcionarios (
    codigo              SERIAL PRIMARY KEY,
    nome                VARCHAR(100) NOT NULL,
    cpf                 VARCHAR(14) NOT NULL UNIQUE,
    telefone            VARCHAR(20),
    email               VARCHAR(100) UNIQUE,
    cargo               VARCHAR(100) NOT NULL,
    status_funcionario  VARCHAR(20) NOT NULL DEFAULT 'Ativo',
    revenda_codigo      INT NOT NULL,
    data_admissao       DATE DEFAULT CURRENT_DATE,

    CONSTRAINT fk_funcionario_revenda
        FOREIGN KEY (revenda_codigo) REFERENCES revendas(codigo),

    CONSTRAINT chk_status_funcionario
        CHECK (status_funcionario IN ('Ativo', 'Inativo', 'Afastado'))
);

-- ============================================================
-- TABELA: usuarios
-- Controla o acesso ao sistema.
-- Todo usuário é um funcionário (funcionario_codigo FK).
-- senha_hash: nunca armazenar senha pura — o BCrypt gera o hash no backend.
-- ultimo_login: registrado a cada autenticação bem-sucedida.
-- ============================================================

CREATE TABLE usuarios (
    codigo              SERIAL PRIMARY KEY,
    nome                VARCHAR(150) NOT NULL,
    email               VARCHAR(150) NOT NULL UNIQUE,
    senha_hash          VARCHAR(600) NOT NULL,
    ativo               BOOLEAN DEFAULT TRUE,
    ultimo_login        TIMESTAMP,
    funcionario_codigo  INT,
    revenda_codigo      INT NOT NULL,
    data_cadastro       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usuario_revenda
        FOREIGN KEY (revenda_codigo) REFERENCES revendas(codigo),

    CONSTRAINT fk_usuario_funcionario
        FOREIGN KEY (funcionario_codigo) REFERENCES funcionarios(codigo)
);

-- ============================================================
-- TABELA: perfis
-- Perfis de acesso: ADMINISTRADOR, GERENTE, VENDEDOR, etc.
-- ============================================================

CREATE TABLE perfis (
    codigo    SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255)
);

INSERT INTO perfis (nome, descricao) VALUES
('ADMINISTRADOR', 'Acesso total ao sistema'),
('PROPRIETARIO',  'Dono da revenda'),
('GERENTE',       'Gerencia a operação da revenda'),
('VENDEDOR',      'Realiza vendas'),
('FINANCEIRO',    'Controle financeiro');

-- ============================================================
-- TABELA: usuario_perfil
-- Relacionamento N:N entre usuários e perfis.
-- Um usuário pode ter mais de um perfil.
-- ============================================================

CREATE TABLE usuario_perfil (
    codigo          SERIAL PRIMARY KEY,
    usuario_codigo  INT NOT NULL,
    perfil_codigo   INT NOT NULL,

    CONSTRAINT fk_up_usuario
        FOREIGN KEY (usuario_codigo) REFERENCES usuarios(codigo),

    CONSTRAINT fk_up_perfil
        FOREIGN KEY (perfil_codigo) REFERENCES perfis(codigo),

    CONSTRAINT uk_usuario_perfil
        UNIQUE (usuario_codigo, perfil_codigo)
);

-- ============================================================
-- TABELA: permissoes
-- Permissões granulares do sistema.
-- ============================================================

CREATE TABLE permissoes (
    codigo    SERIAL PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL UNIQUE
);

INSERT INTO permissoes (descricao) VALUES
('CRIAR_VEICULO'),
('EDITAR_VEICULO'),
('EXCLUIR_VEICULO'),
('CRIAR_CLIENTE'),
('EDITAR_CLIENTE'),
('EXCLUIR_CLIENTE'),
('CRIAR_USUARIO'),
('EDITAR_USUARIO'),
('EXCLUIR_USUARIO'),
('REALIZAR_VENDA'),
('VISUALIZAR_RELATORIOS'),
('GERENCIAR_FINANCEIRO');

-- ============================================================
-- TABELA: perfil_permissao
-- Relacionamento N:N entre perfis e permissões.
-- ============================================================

CREATE TABLE perfil_permissao (
    codigo            SERIAL PRIMARY KEY,
    perfil_codigo     INT NOT NULL,
    permissao_codigo  INT NOT NULL,

    CONSTRAINT fk_pp_perfil
        FOREIGN KEY (perfil_codigo) REFERENCES perfis(codigo),

    CONSTRAINT fk_pp_permissao
        FOREIGN KEY (permissao_codigo) REFERENCES permissoes(codigo)
);

-- ADMINISTRADOR recebe todas as permissões
INSERT INTO perfil_permissao (perfil_codigo, permissao_codigo)
SELECT 1, codigo FROM permissoes;

-- GERENTE recebe tudo exceto gestão de usuários
INSERT INTO perfil_permissao (perfil_codigo, permissao_codigo)
SELECT 3, codigo FROM permissoes
WHERE descricao NOT IN ('CRIAR_USUARIO', 'EDITAR_USUARIO', 'EXCLUIR_USUARIO');

-- VENDEDOR pode criar/editar clientes e realizar vendas
INSERT INTO perfil_permissao (perfil_codigo, permissao_codigo)
VALUES (4, 4), (4, 5), (4, 10);

-- ============================================================
-- TABELA: clientes
-- Clientes de cada revenda.
-- ============================================================

CREATE TABLE clientes (
    codigo          SERIAL PRIMARY KEY,
    nome            VARCHAR(200) NOT NULL,
    cpf             VARCHAR(14) UNIQUE NOT NULL,
    telefone        VARCHAR(20),
    email           VARCHAR(150),
    endereco        VARCHAR(300),
    cidade          VARCHAR(100),
    estado          VARCHAR(2),
    revenda_codigo  INT,
    data_cadastro   DATE DEFAULT CURRENT_DATE,

    CONSTRAINT fk_cliente_revenda
        FOREIGN KEY (revenda_codigo) REFERENCES revendas(codigo)
);

CREATE INDEX idx_clientes_nome    ON clientes(nome);
CREATE INDEX idx_clientes_revenda ON clientes(revenda_codigo);

-- ============================================================
-- TABELA: fornecedores
-- Fornecedores podem ser PF (CPF) ou PJ (CNPJ).
-- A constraint chk_fornecedor_documento garante consistência.
-- ============================================================

CREATE TABLE fornecedores (
    codigo      SERIAL PRIMARY KEY,
    nome        VARCHAR(200) NOT NULL,
    tipo_pessoa VARCHAR(2) NOT NULL,
    cpf         VARCHAR(14),
    cnpj        VARCHAR(18),
    telefone    VARCHAR(20),
    email       VARCHAR(150) UNIQUE,
    cidade      VARCHAR(100),
    estado      VARCHAR(2),

    CONSTRAINT chk_tipo_pessoa
        CHECK (tipo_pessoa IN ('PF', 'PJ')),

    CONSTRAINT chk_fornecedor_documento
        CHECK (
            (tipo_pessoa = 'PF' AND cpf IS NOT NULL AND cnpj IS NULL)
            OR
            (tipo_pessoa = 'PJ' AND cnpj IS NOT NULL AND cpf IS NULL)
        ),

    CONSTRAINT uk_fornecedor_cpf  UNIQUE (cpf),
    CONSTRAINT uk_fornecedor_cnpj UNIQUE (cnpj)
);

-- ============================================================
-- TABELA: automoveis
-- Estoque de veículos de cada revenda.
-- marca_codigo FK referencia a tabela marcas.
-- valor_compra: quanto a revenda pagou pelo veículo.
-- fipe: valor de referência da tabela FIPE.
-- ============================================================

CREATE TABLE automoveis (
    veiculos          SERIAL PRIMARY KEY,
    modelo            VARCHAR(300) NOT NULL,
    placa             VARCHAR(30) UNIQUE NOT NULL,
    ano               INT CHECK (ano >= 1900),
    cor               VARCHAR(50),
    quilometragem     INT DEFAULT 0,
    fipe              DECIMAL(10,2),
    valor_compra      NUMERIC(10,2),
    status            VARCHAR(20) NOT NULL DEFAULT 'Disponível',
    marca_codigo      INT NOT NULL,
    categoria_codigo  INT NOT NULL,
    fornecedor_codigo INT,
    revenda_codigo    INT,
    data_cadastro     DATE DEFAULT CURRENT_DATE,

    CONSTRAINT fk_automoveis_marca
        FOREIGN KEY (marca_codigo) REFERENCES marcas(codigo),

    CONSTRAINT fk_automoveis_categoria
        FOREIGN KEY (categoria_codigo) REFERENCES categoria(codigo),

    CONSTRAINT fk_automoveis_fornecedor
        FOREIGN KEY (fornecedor_codigo) REFERENCES fornecedores(codigo),

    CONSTRAINT fk_automovel_revenda
        FOREIGN KEY (revenda_codigo) REFERENCES revendas(codigo),

    CONSTRAINT chk_quilometragem
        CHECK (quilometragem >= 0),

    CONSTRAINT chk_status_veiculo
        CHECK (status IN ('Disponível', 'Vendido', 'Em manutenção'))
);

CREATE INDEX idx_automoveis_revenda ON automoveis(revenda_codigo);
CREATE INDEX idx_automoveis_status  ON automoveis(status);

-- ============================================================
-- TABELA: especificacoes_veiculos
-- Detalhes técnicos de cada veículo (1:1 com automoveis).
-- ============================================================

CREATE TABLE especificacoes_veiculos (
    codigo          SERIAL PRIMARY KEY,
    automovel_codigo INT NOT NULL,
    potencia        INT,
    cilindradas     VARCHAR(20),
    combustivel     VARCHAR(50),
    cambio          VARCHAR(50),
    portas          INT,
    observacoes     TEXT,

    CONSTRAINT fk_especificacoes_automovel
        FOREIGN KEY (automovel_codigo) REFERENCES automoveis(veiculos)
);

-- ============================================================
-- TABELA: fotos
-- Fotos de cada veículo. principal indica a foto de capa.
-- ordem_exibicao define a ordem das fotos na galeria.
-- ============================================================

CREATE TABLE fotos (
    codigo          SERIAL PRIMARY KEY,
    automovel_codigo INT NOT NULL,
    nome_arquivo    VARCHAR(300),
    url_arquivo     TEXT,
    tipo_imagem     VARCHAR(30),
    principal       BOOLEAN DEFAULT FALSE,
    ordem_exibicao  INT DEFAULT 1,
    data_upload     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_fotos_automovel
        FOREIGN KEY (automovel_codigo) REFERENCES automoveis(veiculos)
);

-- ============================================================
-- TABELA: documentos
-- Documentos digitalizados de cada veículo (CRLV, NF, etc).
-- ============================================================

CREATE TABLE documentos (
    codigo            SERIAL PRIMARY KEY,
    automovel_codigo  INT NOT NULL,
    tipo_documento    VARCHAR(100),
    numero_documento  VARCHAR(100),
    arquivo_url       TEXT,
    data_upload       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_documentos_automovel
        FOREIGN KEY (automovel_codigo) REFERENCES automoveis(veiculos)
);

-- ============================================================
-- TABELA: manutencao_veiculos
-- Histórico de manutenções realizadas em cada veículo.
-- ============================================================

CREATE TABLE manutencao_veiculos (
    codigo          SERIAL PRIMARY KEY,
    veiculo_codigo  INT NOT NULL,
    descricao       VARCHAR(300) NOT NULL,
    valor           NUMERIC(10,2) NOT NULL,
    oficina         VARCHAR(200),
    data_manutencao DATE DEFAULT CURRENT_DATE,
    data_registro   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_manutencao_veiculo
        FOREIGN KEY (veiculo_codigo) REFERENCES automoveis(veiculos)
);

-- ============================================================
-- TABELA: vendas
-- Registro de todas as vendas realizadas.
-- forma_pagamento e banco_financiador registram como foi pago.
-- ============================================================

CREATE TABLE vendas (
    codigo              SERIAL PRIMARY KEY,
    cliente_codigo      INT NOT NULL,
    veiculo_codigo      INT NOT NULL,
    funcionario_codigo  INT,
    revenda_codigo      INT,
    valor_venda         DECIMAL(10,2) NOT NULL,
    forma_pagamento     VARCHAR(50),
    banco_financiador   VARCHAR(100),
    garantia_ate        DATE,
    data_venda          DATE DEFAULT CURRENT_DATE,

    CONSTRAINT fk_venda_cliente
        FOREIGN KEY (cliente_codigo) REFERENCES clientes(codigo),

    CONSTRAINT fk_venda_veiculo
        FOREIGN KEY (veiculo_codigo) REFERENCES automoveis(veiculos),

    CONSTRAINT fk_vendas_funcionario
        FOREIGN KEY (funcionario_codigo) REFERENCES funcionarios(codigo),

    CONSTRAINT fk_venda_revenda
        FOREIGN KEY (revenda_codigo) REFERENCES revendas(codigo)
);

CREATE INDEX idx_vendas_revenda ON vendas(revenda_codigo);
CREATE INDEX idx_vendas_data    ON vendas(data_venda);

-- ============================================================
-- TABELA: fornecedor_revenda
-- Tabela intermediária N:N entre fornecedores e revendas.
-- Um fornecedor pode atender várias revendas e vice-versa.
-- ============================================================

CREATE TABLE fornecedor_revenda (
    codigo              SERIAL PRIMARY KEY,
    fornecedor_codigo   INT NOT NULL,
    revenda_codigo      INT NOT NULL,

    CONSTRAINT fk_fr_fornecedor
        FOREIGN KEY (fornecedor_codigo) REFERENCES fornecedores(codigo),

    CONSTRAINT fk_fr_revenda
        FOREIGN KEY (revenda_codigo) REFERENCES revendas(codigo)
);

-- ============================================================
-- TABELA: auditoria
-- Registra todas as operações realizadas no sistema.
-- ip_origem: IP do usuário que realizou a operação.
-- dados_registro: snapshot JSONB do registro antes/depois.
-- ============================================================

CREATE TABLE auditoria (
    codigo          SERIAL PRIMARY KEY,
    usuario_codigo  INT,
    revenda_codigo  INT,
    tabela_afetada  VARCHAR(100) NOT NULL,
    operacao        VARCHAR(50) NOT NULL,
    registro_codigo INT,
    campo_alterado  VARCHAR(100),
    valor_antigo    TEXT,
    valor_novo      TEXT,
    dados_registro  JSONB,
    ip_origem       VARCHAR(45),
    descricao       TEXT,
    data_evento     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_auditoria_usuario
        FOREIGN KEY (usuario_codigo) REFERENCES usuarios(codigo),

    CONSTRAINT fk_auditoria_revenda
        FOREIGN KEY (revenda_codigo) REFERENCES revendas(codigo)
);

CREATE INDEX idx_auditoria_data ON auditoria(data_evento);

-- ============================================================
-- TABELA: notificacoes
-- Notificações enviadas aos usuários dentro do sistema.
-- ============================================================

CREATE TABLE notificacoes (
    codigo          SERIAL PRIMARY KEY,
    usuario_codigo  INT NOT NULL,
    titulo          VARCHAR(200) NOT NULL,
    mensagem        TEXT NOT NULL,
    lida            BOOLEAN DEFAULT FALSE,
    data_envio      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_notificacao_usuario
        FOREIGN KEY (usuario_codigo) REFERENCES usuarios(codigo)
);

-- ============================================================
-- FUNÇÃO GENÉRICA DE AUDITORIA
-- Usada por todas as triggers do sistema.
-- Detecta automaticamente qualquer campo alterado via JSONB.
-- TG_OP identifica se foi INSERT, UPDATE ou DELETE.
-- TG_TABLE_NAME captura o nome da tabela automaticamente.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_auditoria_generica()
RETURNS TRIGGER AS $$
DECLARE
    v_usuario       INTEGER;
    v_campo         TEXT;
    v_valor_antigo  TEXT;
    v_valor_novo    TEXT;
    v_registro      INTEGER;
BEGIN
    v_usuario := NULLIF(
        current_setting('app.usuario_logado', true), ''
    )::INTEGER;

    -- DELETE
    IF TG_OP = 'DELETE' THEN
        v_registro := CASE
            WHEN TG_TABLE_NAME = 'automoveis' THEN OLD.veiculos
            ELSE OLD.codigo
        END;

        INSERT INTO auditoria (
            usuario_codigo, tabela_afetada, operacao,
            registro_codigo, descricao, dados_registro
        ) VALUES (
            v_usuario, TG_TABLE_NAME, TG_OP,
            v_registro, 'Registro excluído', to_jsonb(OLD)
        );

        RETURN OLD;
    END IF;

    -- INSERT
    IF TG_OP = 'INSERT' THEN
        v_registro := CASE
            WHEN TG_TABLE_NAME = 'automoveis' THEN NEW.veiculos
            ELSE NEW.codigo
        END;

        INSERT INTO auditoria (
            usuario_codigo, tabela_afetada, operacao,
            registro_codigo, descricao, dados_registro
        ) VALUES (
            v_usuario, TG_TABLE_NAME, 'INSERT',
            v_registro, 'Registro criado', to_jsonb(NEW)
        );

        RETURN NEW;
    END IF;

    -- UPDATE — detecta campo por campo via JSONB
    v_registro := CASE
        WHEN TG_TABLE_NAME = 'automoveis' THEN NEW.veiculos
        ELSE NEW.codigo
    END;

    FOR v_campo IN
        SELECT jsonb_object_keys(to_jsonb(NEW))
    LOOP
        CONTINUE WHEN v_campo IN ('codigo', 'data_cadastro');

        v_valor_antigo := to_jsonb(OLD)->>v_campo;
        v_valor_novo   := to_jsonb(NEW)->>v_campo;

        IF v_valor_antigo IS DISTINCT FROM v_valor_novo THEN
            INSERT INTO auditoria (
                usuario_codigo, tabela_afetada, operacao,
                registro_codigo, campo_alterado,
                valor_antigo, valor_novo, descricao
            ) VALUES (
                v_usuario, TG_TABLE_NAME, TG_OP,
                v_registro, v_campo,
                v_valor_antigo, v_valor_novo,
                'Campo ' || v_campo || ' alterado'
            );
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- FUNÇÃO: atualizar_status_veiculo
-- Trigger de venda: impede venda de veículo já vendido
-- e atualiza o status automaticamente para 'Vendido'.
-- ============================================================

CREATE OR REPLACE FUNCTION atualizar_status_veiculo()
RETURNS TRIGGER AS $$
DECLARE
    situacao VARCHAR(20);
BEGIN
    SELECT status INTO situacao
    FROM automoveis
    WHERE veiculos = NEW.veiculo_codigo;

    IF situacao = 'Vendido' THEN
        RAISE EXCEPTION 'Este veículo já foi vendido. Escolha outro.';
    END IF;

    UPDATE automoveis
    SET status = 'Vendido'
    WHERE veiculos = NEW.veiculo_codigo;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- TRIGGERS DE AUDITORIA
-- Todas as tabelas críticas são monitoradas automaticamente.
-- ============================================================

CREATE TRIGGER trg_auditoria_automoveis
    AFTER INSERT OR UPDATE OR DELETE ON automoveis
    FOR EACH ROW EXECUTE FUNCTION fn_auditoria_generica();

CREATE TRIGGER trg_auditoria_clientes
    AFTER INSERT OR UPDATE OR DELETE ON clientes
    FOR EACH ROW EXECUTE FUNCTION fn_auditoria_generica();

CREATE TRIGGER trg_auditoria_funcionarios
    AFTER INSERT OR UPDATE OR DELETE ON funcionarios
    FOR EACH ROW EXECUTE FUNCTION fn_auditoria_generica();

CREATE TRIGGER trg_auditoria_vendas
    AFTER INSERT OR UPDATE OR DELETE ON vendas
    FOR EACH ROW EXECUTE FUNCTION fn_auditoria_generica();

CREATE TRIGGER trg_auditoria_usuarios
    AFTER INSERT OR UPDATE OR DELETE ON usuarios
    FOR EACH ROW EXECUTE FUNCTION fn_auditoria_generica();

CREATE TRIGGER trg_auditoria_fornecedores
    AFTER INSERT OR UPDATE OR DELETE ON fornecedores
    FOR EACH ROW EXECUTE FUNCTION fn_auditoria_generica();

CREATE TRIGGER trg_auditoria_marcas
    AFTER INSERT OR UPDATE OR DELETE ON marcas
    FOR EACH ROW EXECUTE FUNCTION fn_auditoria_generica();

-- ============================================================
-- TRIGGER DE VENDA
-- Dispara após cada INSERT em vendas.
-- ============================================================

CREATE TRIGGER trg_venda_automatica
    AFTER INSERT ON vendas
    FOR EACH ROW EXECUTE FUNCTION atualizar_status_veiculo();

-- ============================================================
-- VIEWS
-- ============================================================

-- Estoque completo de veículos com marca e categoria

CREATE VIEW vw_automoveis AS
SELECT
    a.veiculos,
    m.nome          AS marca,
    a.modelo,
    a.placa,
    a.ano,
    a.cor,
    a.quilometragem,
    a.fipe,
    a.valor_compra,
    a.status,
    a.data_cadastro,
    c.descricao     AS categoria,
    f.nome          AS fornecedor,
    r.nome_fantasia AS revenda
FROM automoveis a
INNER JOIN marcas m       ON a.marca_codigo      = m.codigo
INNER JOIN categoria c    ON a.categoria_codigo  = c.codigo
LEFT  JOIN fornecedores f ON a.fornecedor_codigo = f.codigo
LEFT  JOIN revendas r     ON a.revenda_codigo    = r.codigo;

-- Vendas completas com cliente, veículo e vendedor

CREATE VIEW vw_vendas_completas AS
SELECT
    v.codigo        AS venda_codigo,
    c.nome          AS cliente,
    a.modelo        AS veiculo,
    f.nome          AS vendedor,
    v.valor_venda,
    v.forma_pagamento,
    v.banco_financiador,
    v.data_venda,
    v.garantia_ate,
    r.nome_fantasia AS revenda
FROM vendas v
JOIN  clientes c      ON v.cliente_codigo     = c.codigo
JOIN  automoveis a    ON v.veiculo_codigo      = a.veiculos
LEFT  JOIN funcionarios f ON v.funcionario_codigo = f.codigo
LEFT  JOIN revendas r     ON v.revenda_codigo     = r.codigo;

-- Lucro por venda (valor_venda - valor_compra)

CREATE VIEW vw_lucro_vendas AS
SELECT
    v.codigo    AS venda,
    a.modelo,
    a.valor_compra,
    v.valor_venda,
    (v.valor_venda - a.valor_compra) AS lucro,
    c.nome      AS cliente,
    f.nome      AS vendedor
FROM vendas v
JOIN  automoveis a    ON v.veiculo_codigo      = a.veiculos
JOIN  clientes c      ON v.cliente_codigo      = c.codigo
LEFT  JOIN funcionarios f ON v.funcionario_codigo = f.codigo;

-- Dashboard geral da revenda

CREATE VIEW vw_dashboard_revenda AS
SELECT
    (SELECT COUNT(*)                          FROM automoveis)              AS total_veiculos,
    (SELECT COUNT(*) FROM automoveis          WHERE status = 'Disponível')  AS veiculos_disponiveis,
    (SELECT COUNT(*) FROM automoveis          WHERE status = 'Vendido')     AS veiculos_vendidos,
    (SELECT COUNT(*)                          FROM clientes)                AS total_clientes,
    (SELECT COUNT(*)                          FROM funcionarios)            AS total_funcionarios,
    (SELECT COUNT(*)                          FROM vendas)                  AS total_vendas,
    (SELECT COALESCE(SUM(valor_venda), 0)     FROM vendas)                  AS faturamento_total;

-- Ranking de melhores vendedores

CREATE VIEW vw_ranking_vendedores AS
SELECT
    f.codigo,
    f.nome,
    COUNT(v.codigo)     AS quantidade_vendas,
    SUM(v.valor_venda)  AS faturamento
FROM funcionarios f
LEFT JOIN vendas v ON f.codigo = v.funcionario_codigo
GROUP BY f.codigo, f.nome
ORDER BY faturamento DESC;

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- Garante que cada revenda veja APENAS seus próprios dados.
-- O backend define app.revenda_logada a cada requisição.
-- ============================================================

ALTER TABLE clientes          ENABLE ROW LEVEL SECURITY;
ALTER TABLE clientes          FORCE  ROW LEVEL SECURITY;

ALTER TABLE funcionarios      ENABLE ROW LEVEL SECURITY;
ALTER TABLE funcionarios      FORCE  ROW LEVEL SECURITY;

ALTER TABLE usuarios          ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios          FORCE  ROW LEVEL SECURITY;

ALTER TABLE automoveis        ENABLE ROW LEVEL SECURITY;
ALTER TABLE automoveis        FORCE  ROW LEVEL SECURITY;

ALTER TABLE vendas            ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendas            FORCE  ROW LEVEL SECURITY;

ALTER TABLE fornecedor_revenda ENABLE ROW LEVEL SECURITY;
ALTER TABLE fornecedor_revenda FORCE  ROW LEVEL SECURITY;

CREATE POLICY clientes_revenda_policy
    ON clientes FOR ALL
    USING (revenda_codigo = current_setting('app.revenda_logada')::INTEGER);

CREATE POLICY funcionarios_revenda_policy
    ON funcionarios FOR ALL
    USING (revenda_codigo = current_setting('app.revenda_logada')::INTEGER);

CREATE POLICY usuarios_revenda_policy
    ON usuarios FOR ALL
    USING (revenda_codigo = current_setting('app.revenda_logada')::INTEGER);

CREATE POLICY automoveis_revenda_policy
    ON automoveis FOR ALL
    USING (revenda_codigo = current_setting('app.revenda_logada')::INTEGER);

CREATE POLICY vendas_revenda_policy
    ON vendas FOR ALL
    USING (revenda_codigo = current_setting('app.revenda_logada')::INTEGER);

CREATE POLICY fornecedor_revenda_policy
    ON fornecedor_revenda FOR ALL
    USING (revenda_codigo = current_setting('app.revenda_logada')::INTEGER);

