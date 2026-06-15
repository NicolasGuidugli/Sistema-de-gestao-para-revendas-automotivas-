--=========================================
-- CRIANDO TABELA DE PERFIS
--=========================================

CREATE TABLE perfis
(
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255)
);

--==========================================
-- INSERINDO PERFIS INICIAIS
--==========================================

INSERT INTO perfis (nome, descricao)
VALUES
('ADMINISTRADOR', 'Acesso total ao sistema');

INSERT INTO perfis (nome, descricao)
VALUES
('PROPRIETARIOS', 'Dono da revenda');

INSERT INTO perfis (nome, descricao)
VALUES
('GERENTE', 'Gerencia a operação da revenda');

INSERT INTO perfis (nome, descricao)
VALUES
('VENDEDOR', 'Realiza vendas');

INSERT INTO perfis (nome, descricao)
VALUES
('FINANCEIRO', 'Controle financeiro');

--================================================
-- CRIANDO TABELA USUARIOS
--================================================

CREATE TABLE usuarios
(
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(600) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    revenda_codigo INT NOT NULL,
    FOREIGN KEY (revenda_codigo)
    REFERENCES revendas(codigo)
);

--=====================================================
--CRIANDO TABELA USUARIO_PERFIl
--=====================================================

CREATE TABLE usuario_perfil
(
    codigo SERIAL PRIMARY KEY,
    usuario_codigo INT NOT NULL,
    perfil_codigo INT NOT NULL,

    FOREIGN KEY (usuario_codigo)
    REFERENCES usuarios(codigo),

    FOREIGN KEY (perfil_codigo)
    REFERENCES perfis(codigo),

    CONSTRAINT uk_usuario_perfil
    UNIQUE(usuario_codigo, perfil_codigo)
);

--=========================================================
-- INSERINDO USUARIOS
--=========================================================

INSERT INTO usuarios
(
    nome,
    email,
    senha,
    revenda_codigo
)
VALUES
(
    'Administrador Sistema',
    'admin@revendasul.com',
    '123456',
    1
);

INSERT INTO usuarios
(
    nome,
    email,
    senha,
    revenda_codigo
)
VALUES
(
    'Gerente Premium',
    'gerente@premium.com',
    '123456',
    2
);

--====================================================
-- ASSOCIANDO PERFIS E USUARIOS
--====================================================

INSERT INTO usuario_perfil
(
    usuario_codigo,
    perfil_codigo
)
VALUES
(
    1,
    1
);

INSERT INTO usuario_perfil
(
    usuario_codigo,
    perfil_codigo
)
VALUES
(
    2,
    3
);

--===================================================
-- CONSULTA DE USUARIOS
--===================================================
SELECT
u.nome,
u.email,
p.nome AS perfil,
r.nome_fantasia
FROM usuarios u
INNER JOIN usuario_perfil up
ON up.usuario_codigo = u.codigo
INNER JOIN perfis p
ON p.codigo = up.perfil_codigo
INNER JOIN revendas r
ON r.codigo = u.revenda_codigo;

--====================================================
-- CRIANDO TABELA DE PERMISSÕES
--====================================================

CREATE TABLE permissoes
(
    codigo SERIAL PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL UNIQUE
);

INSERT INTO permissoes (descricao)
VALUES
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

('VISUALIZAR_RELATORIOS');

INSERT INTO permissoes (descricao)
VALUES
('GERENCIAR_FINANCEIRO');

--relacionando perfil x permissão

CREATE TABLE perfil_permissao
(
    codigo SERIAL PRIMARY KEY,
    perfil_codigo INT NOT NULL,
    permissao_codigo INT NOT NULL,

    CONSTRAINT fk_pp_perfil
    FOREIGN KEY (perfil_codigo)
    REFERENCES perfis(codigo),

    CONSTRAINT fk_pp_permissao
    FOREIGN KEY (permissao_codigo)
    REFERENCES permissoes(codigo)
);

--consultando permissão

SELECT p.descricao
FROM usuarios u
JOIN usuario_perfil up
ON u.codigo = up.usuario_codigo
JOIN perfil_permissao pp
ON up.perfil_codigo = pp.perfil_codigo
JOIN permissoes p
ON pp.permissao_codigo = p.codigo
WHERE u.codigo = 2;

--distribuir permissões por perfil

--ADMINISTRADOR recebe tudo

INSERT INTO perfil_permissao
(perfil_codigo, permissao_codigo)
SELECT
1, codigo
FROM permissoes;

--VENDEDOR pode: criar clientes, editar clientes, realizar vendas

INSERT INTO perfil_permissao
(perfil_codigo, permissao_codigo)
VALUES
(4,4),
(4,5),
(4,10);

--GERENTE pode quase tudo, exceto administrar usuarios

INSERT INTO perfil_permissao
(perfil_codigo, permissao_codigo)
SELECT
3, codigo
FROM permissoes
WHERE descricao NOT IN
('CRIAR_USUARIO',
'EDITAR_USUARIO',
'EXCLUIR_USUARIO');


