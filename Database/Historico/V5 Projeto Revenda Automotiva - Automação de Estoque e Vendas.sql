--=======================================
-- V6 CONTROLE DE ESTOQUE
--=======================================

--=======================================
-- CRIANDO A PRIMEIRA TRIGGER (AUTOMAÇÃO) PARA ATUALIZAR O ESTOQUE APÓS UMA VENDA
--=======================================

CREATE OR REPLACE FUNCTION atualizar_status_veiculo()
RETURNS TRIGGER AS
$$

BEGIN

    UPDATE automoveis
    SET status = 'Vendido'
    WHERE veiculos = NEW.veiculo_codigo;

    RETURN NEW;

END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_venda_automatica

AFTER INSERT ON vendas

FOR EACH ROW

EXECUTE FUNCTION atualizar_status_veiculo();

DROP TRIGGER trg_venda_automatica ON vendas; --APAGAR A TRIGGER EXISTENTE PARA RECRIAR UMA COM VALIDAÇÃO AUTOMATICA DE ESTOQUE

--=======================================
-- CRIANDO TRIGGER PARA IMPEDIR VENDAS DE VEÍCULOS JÁ VENDIDOS
--=======================================

CREATE OR REPLACE FUNCTION atualizar_status_veiculo()
RETURNS TRIGGER AS
$$

DECLARE
situacao VARCHAR(20);

BEGIN

SELECT status
INTO situacao
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

CREATE TRIGGER trg_venda_automatica
AFTER INSERT ON vendas
FOR EACH ROW
EXECUTE FUNCTION atualizar_status_veiculo();

