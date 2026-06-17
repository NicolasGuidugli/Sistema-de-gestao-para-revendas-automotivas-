--=============================================
-- V15 ATIVANDO RLS (Row Level Security)
--=============================================

--clientes RLS

ALTER TABLE clientes
ENABLE ROW LEVEL SECURITY;

CREATE POLICY clientes_revenda_policy
ON clientes
FOR ALL
USING (
    revenda_codigo =
    current_setting(
        'app.revenda_logada'
    )::INTEGER
);

SET app.revenda_logada = '1';

SELECT*FROM clientes;

ALTER TABLE clientes
FORCE ROW LEVEL SECURITY;

SELECT *
FROM pg_policies
WHERE tablename = 'clientes';

--funcionarios RLS

ALTER TABLE funcionarios
ENABLE ROW LEVEL SECURITY;

CREATE POLICY funcionarios_revenda_policy
ON funcionarios
FOR ALL
USING (
    revenda_codigo =
    current_setting(
        'app.revenda_logada'
    )::INTEGER
);

ALTER TABLE funcionarios
FORCE ROW LEVEL SECURITY;

--usuarios RLS

ALTER TABLE usuarios
ENABLE ROW LEVEL SECURITY;

CREATE POLICY usuarios_revenda_policy
ON usuarios
FOR ALL
USING (
    revenda_codigo =
    current_setting(
        'app.revenda_logada'
    )::INTEGER
);

ALTER TABLE usuarios
FORCE ROW LEVEL SECURITY;

--automoveis RLS

ALTER TABLE automoveis
ENABLE ROW LEVEL SECURITY;

CREATE POLICY automoveis_revenda_policy
ON automoveis
FOR ALL
USING (
    revenda_codigo =
    current_setting(
        'app.revenda_logada'
    )::INTEGER
);

ALTER TABLE automoveis
FORCE ROW LEVEL SECURITY;

--vendas RLS

ALTER TABLE vendas
ENABLE ROW LEVEL SECURITY;

CREATE POLICY vendas_revenda_policy
ON vendas
FOR ALL
USING (
    revenda_codigo =
    current_setting(
        'app.revenda_logada'
    )::INTEGER
);

ALTER TABLE vendas
FORCE ROW LEVEL SECURITY;

--fornecedor_revenda

ALTER TABLE fornecedor_revenda
ENABLE ROW LEVEL SECURITY;

CREATE POLICY fornecedor_revenda_policy
ON fornecedor_revenda
FOR ALL
USING (
    revenda_codigo =
    current_setting(
        'app.revenda_logada'
    )::INTEGER
);

ALTER TABLE fornecedor_revenda
FORCE ROW LEVEL SECURITY;