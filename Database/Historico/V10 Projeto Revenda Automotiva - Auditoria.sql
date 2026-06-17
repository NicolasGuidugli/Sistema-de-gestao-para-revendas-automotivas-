--=============================================
-- V11 CRIANDO TABELA DE AUDITORIA
--=============================================

CREATE TABLE auditoria (
    codigo SERIAL PRIMARY KEY,
    usuario_codigo INT,
    tabela_afetada VARCHAR(100) NOT NULL,
    operacao VARCHAR(50) NOT NULL,
    registro_codigo INT,
    data_evento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descricao TEXT,

    FOREIGN KEY (usuario_codigo)
    REFERENCES usuarios(codigo)
);

--=============================================
-- INSERINDO REGISTROS
--=============================================

INSERT INTO auditoria
(
    usuario_codigo,
    tabela_afetada,
    operacao,
    registro_codigo,
    descricao
)
VALUES
(
    1,
    'automoveis',
    'UPDATE',
    7,
    'Valor do veiculo alterado'
);

SELECT*FROM auditoria;

--=============================================
-- CRIANDO A FUNÇÃO DE AUDITORIA
--=============================================

CREATE OR REPLACE FUNCTION fn_auditoria_automoveis()
RETURNS TRIGGER
AS $$
BEGIN

INSERT INTO auditoria
(
    usuario_codigo,
    tabela_afetada,
    operacao,
    registro_codigo,
    descricao
)
VALUES
(
    1,
    'automoveis',
    TG_OP,
    NEW.veiculos,
    'Registro alterado na tabela automoveis'
);

RETURN NEW;
END;
$$
LANGUAGE plpgsql;

--=============================================
-- CRIANDO A TRIGGER
--=============================================

CREATE TRIGGER trg_auditoria_automoveis
AFTER UPDATE
ON automoveis
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_automoveis();

--=============================================
-- TESTE DE TRIGGER E FUNÇÃO
--=============================================

UPDATE automoveis
SET status = 'Vendido'
WHERE veiculos = 1;

--=============================================
-- ADICIONANDO NOVAS COLUNAS NA TABELA AUDITORIA
--=============================================

ALTER TABLE auditoria
ADD COLUMN campo_alterado VARCHAR(100);

ALTER TABLE auditoria
ADD COLUMN valor_antigo TEXT;

ALTER TABLE auditoria
ADD COLUMN valor_novo TEXT;

--=============================================
-- ADICIONANDO NOVA FUNÇÃO E UMA TRIGGER MELHORADA
--=============================================

DROP TRIGGER trg_auditoria_automoveis
ON automoveis;

CREATE OR REPLACE FUNCTION fn_auditoria_automoveis()
RETURNS TRIGGER
AS $$
DECLARE
v_usuario INT;
BEGIN
v_usuario := current_setting(
    'app.usuario_logado'
)::INT;

-- STATUS

IF OLD.status IS DISTINCT FROM NEW.status THEN
INSERT INTO auditoria
(
    usuario_codigo,
    tabela_afetada,
    operacao,
    registro_codigo,
    campo_alterado,
    valor_antigo,
    valor_novo,
    descricao
)
VALUES
(
    v_usuario,
    'automoveis',
    TG_OP,
    NEW.veiculos,
    'satus',
    OLD.status,
    NEW.status,
    'Alteração do status'
);

END IF;
-- QUILOMETRAGEM
IF OLD.quilometragem IS DISTINCT FROM NEW.quilometragem THEN
INSERT INTO auditoria
(
    usuario_codigo,
    tabela_afetada,
    operacao,
    registro_codigo,
    campo_alterado,
    valor_antigo,
    valor_novo,
    descricao
)
VALUES
(
    v_usuario,
    'automoveis',
    TG_OP,
    NEW.veiculos,
    'quilometragem',
    OLD.quilometragem::TEXT,
    NEW.quilometragem::TEXT,
    'Alteração da quilometragem'
);

END IF;
--COR
IF OLD.cor IS DISTINCT FROM NEW.cor THEN
INSERT INTO auditoria
(
    usuario_codigo,
    tabela_afetada,
    operacao,
    registro_codigo,
    campo_alterado,
    valor_antigo,
    valor_novo,
    descricao
)
VALUES
(
    v_usuario,
    'automoveis',
    TG_OP,
    NEW.veiculos,
    'cor',
    OLD.cor,
    NEW.cor,
    'Alteração da cor'
);

END IF;
--VALOR COMPRA
IF OLD.valor_compra IS DISTINCT FROM New.valor_compra THEN
INSERT INTO auditoria
(
    usuario_codigo,
    tabela_afetada,
    operacao,
    registro_codigo,
    campo_alterado,
    valor_antigo,
    valor_novo,
    descricao
)
VALUES
(
    v_usuario,
    'automoveis',
    TG_OP,
    NEW.veiculos,
    'valor_compra',
    OLD.valor_compra::TEXT,
    NEW.valor_compra::TEXT,
    'Alteração do valor de compra'
);

END IF;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

--=============================================
-- CRIANDO NOVAMENTE A TRIGGER
--=============================================

CREATE TRIGGER trg_auditoria_automoveis
AFTER UPDATE
ON automoveis
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_automoveis();

--teste definindo usuario
SELECT set_config(
    'app.usuario_logado',
    '2',
    false
);

--alterando atualizações tabela auditoria
UPDATE automoveis
SET status = 'Vendido'
WHERE veiculos = 1;

--consultando
SELECT
usuario_codigo,
campo_alterado,
valor_antigo,
valor_novo
FROM auditoria
ORDER BY codigo DESC;

UPDATE automoveis
SET cor = 'Preto'
WHERE veiculos = 1;


--=============================================
-- CRIANDO UMA TRIGGER DE AUDITORIA DINAMICA COM JSONB
--=============================================

CREATE OR REPLACE FUNCTION fn_auditoria_automoveis_dinamica()
RETURNS TRIGGER
AS $$
DECLARE

v_usuario INT;
v_campo TEXT;
v_valor_antigo TEXT;
v_valor_novo TEXT;

BEGIN
v_usuario :=
current_setting(
    'app.usuario_logado'
)::INT;

FOR v_campo IN
SELECT jsonb_object_keys(
    to_jsonb(NEW)
)

LOOP

v_valor_antigo :=
to_jsonb(OLD)->>v_campo;

v_valor_novo :=
to_jsonb(NEW)->>v_campo;

IF v_valor_antigo
IS DISTINCT FROM
v_valor_novo THEN

INSERT INTO auditoria
(
    usuario_codigo,
    tabela_afetada,
    operacao,
    registro_codigo,
    campo_alterado,
    valor_antigo,
    valor_novo,
    descricao
)
VALUES
(
    v_usuario,
    'automoveis',
    TG_OP,
    NEW.veiculos,
    v_campo,
    v_valor_antigo,
    v_valor_novo,
    'Alteração automática'
);

END IF;
END LOOP;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

--=============================================
-- CRIANDO A NOVA TRIGGER DINAMICA
--=============================================

DROP TRIGGER trg_auditoria_automoveis
ON automoveis;

CREATE TRIGGER trg_auditoria_automoveis
AFTER UPDATE
ON automoveis
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_automoveis_dinamica();

--definir um usuario
SELECT set_config(
    'app.usuario_logado',
    '1',
    false
);

--alterando campos
UPDATE automoveis
SET
cor = 'Azul',
quilometragem = quilometragem + 500,
valor_compra = valor_compra + 1000
WHERE veiculos = 1;

--consultando
SELECT
    codigo,
    usuario_codigo,
    campo_alterado,
    valor_antigo,
    valor_novo
FROM auditoria
ORDER BY codigo DESC
LIMIT 20;

--=========================================
-- CRIANDO FUNÇÃO GENÉRICA FINAL, ESSA FUNÇÃO SERÁ UTILIZADA POR TODAS AS TRIGGERS QUE SERÃO CRIADAS PARA AUDITORIA
--=========================================

CREATE OR REPLACE FUNCTION fn_auditoria_generica()
RETURNS TRIGGER
AS $$
DECLARE

    v_usuario INTEGER;

    v_campo TEXT;

    v_valor_antigo TEXT;

    v_valor_novo TEXT;

    v_registro INTEGER;

BEGIN

 v_usuario :=
NULLIF(
    current_setting(
        'app.usuario_logado',
        true
    ),
    ''
)::INTEGER;

IF TG_OP = 'DELETE' THEN

    IF TG_TABLE_NAME = 'automoveis' THEN

        v_registro := OLD.veiculos;

    ELSE

        v_registro := OLD.codigo;

    END IF;

INSERT INTO auditoria
(
    usuario_codigo,
    tabela_afetada,
    operacao,
    registro_codigo,
    descricao,
    dados_registro
)
VALUES
(
    v_usuario,
    TG_TABLE_NAME,
    TG_OP,
    v_registro,
    'Registro excluído',
    to_jsonb(OLD)
);

    RETURN OLD;

END IF;

IF TG_OP = 'INSERT' THEN

    IF TG_TABLE_NAME = 'automoveis' THEN
        v_registro := NEW.veiculos;
    ELSE
        v_registro := NEW.codigo;
    END IF;

    INSERT INTO auditoria
    (
        usuario_codigo,
        tabela_afetada,
        operacao,
        registro_codigo,
        descricao,
        dados_registro
    )
    VALUES
    (
        v_usuario,
        TG_TABLE_NAME,
        'INSERT',
        v_registro,
        'Registro criado',
        to_jsonb(NEW)
    );

    RETURN NEW;

END IF;

   v_usuario :=
NULLIF(
    current_setting(
        'app.usuario_logado',
        true
    ),
    ''
)::INTEGER;

    IF TG_TABLE_NAME = 'automoveis' THEN

        v_registro := NEW.veiculos;

    ELSE

        v_registro := NEW.codigo;

    END IF;

    FOR v_campo IN

        SELECT jsonb_object_keys(
            to_jsonb(NEW)
        )

    LOOP

        IF v_campo IN
        (
            'codigo',
            'data_cadastro',
            'data_cadastro'
        )
        THEN

            CONTINUE;

        END IF;

        v_valor_antigo :=
            to_jsonb(OLD)->>v_campo;

        v_valor_novo :=
            to_jsonb(NEW)->>v_campo;

        IF v_valor_antigo
           IS DISTINCT FROM
           v_valor_novo THEN

            INSERT INTO auditoria
            (
                usuario_codigo,
                tabela_afetada,
                operacao,
                registro_codigo,
                campo_alterado,
                valor_antigo,
                valor_novo,
                descricao
            )
            VALUES
            (
                v_usuario,
                TG_TABLE_NAME,
                TG_OP,
                v_registro,
                v_campo,
                v_valor_antigo,
                v_valor_novo,
                'Campo ' ||
                v_campo ||
                ' alterado'
            );

        END IF;

    END LOOP;

    RETURN NEW;

END;
$$
LANGUAGE plpgsql;

--============================================
-- CRIANDO NOVA TRIGGER AUTOMOVEIS
--============================================

DROP TRIGGER trg_auditoria_automoveis
ON automoveis;

CREATE TRIGGER trg_auditoria_automoveis
AFTER UPDATE
ON automoveis
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_generica();

--selecionando usuario
SELECT set_config(
    'app.usuario_logado',
    '2',
    false
);

--fazendo alterações
UPDATE automoveis
SET cor = 'Prata'
WHERE veiculos = 1

--conferindo os dados
SELECT
    usuario_codigo,
    tabela_afetada,
    campo_alterado,
    valor_antigo,
    valor_novo,
    descricao
FROM auditoria
ORDER BY codigo DESC
LIMIT 5;

--=========================================
-- CRIANDO NOVAS TRIGGERS DE AUTOMOVEIS, CLIENTES, FUNCIONARIOS, VENDAS, USUARIOS e FORNECEDORES
--=========================================
DROP TRIGGER trg_auditoria_automoveis
ON automoveis;
DROP TRIGGER trg_auditoria_clientes
ON clientes;
DROP TRIGGER trg_auditoria_vendas
ON vendas;
DROP TRIGGER trg_auditoria_usuarios
ON usuarios;
DROP TRIGGER trg_auditoria_funcionarios
ON funcionarios;
DROP TRIGGER trg_auditoria_fornecedores
ON fornecedores;

--automoveis
CREATE TRIGGER trg_auditoria_automoveis
AFTER INSERT OR UPDATE OR DELETE
ON automoveis
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_generica();


--clientes
CREATE TRIGGER trg_auditoria_clientes
AFTER INSERT OR UPDATE OR DELETE
ON clientes
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_generica();

--funcionarios
CREATE TRIGGER trg_auditoria_funcionarios
AFTER INSERT OR UPDATE OR DELETE
ON funcionarios
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_generica();

--vendas
CREATE TRIGGER trg_auditoria_vendas
AFTER INSERT OR UPDATE OR DELETE
ON vendas
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_generica();

--usuarios
CREATE TRIGGER trg_auditoria_usuarios
AFTER INSERT OR UPDATE OR DELETE
ON usuarios
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_generica();

--fornecedores
CREATE TRIGGER trg_auditoria_fornecedores
AFTER INSERT OR UPDATE OR DELETE
ON fornecedores
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_generica();

--marcas
CREATE TRIGGER trg_auditoria_marcas
AFTER INSERT OR UPDATE OR DELETE
ON marcas
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_generica();

--==============================================
-- EVOLUINDO A TABELA AUDITORIA COM DADOS DE REGISTROS
--==============================================

ALTER TABLE auditoria
ADD COLUMN dados_registro JSONB;

--consultando histórico
SELECT *
FROM auditoria
ORDER BY data_evento DESC;

SELECT *
FROM auditoria
WHERE tabela_afetada = 'automoveis'
AND registro_codigo = 1
ORDER BY data_evento;

--TESTES DA TRIGGER COM INSERTS E DELETES 
INSERT INTO marcas (nome)
VALUES ('Jeep');

DELETE FROM marcas
WHERE nome = 'Jeep';

