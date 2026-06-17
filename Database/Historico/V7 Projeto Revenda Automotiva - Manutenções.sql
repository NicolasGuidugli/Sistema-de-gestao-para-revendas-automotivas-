--======================================
-- V8 TABELA DE MANUTENÇÃO DE VEÍCULOS
--======================================

CREATE TABLE manutencao_veiculos (
    codigo SERIAL PRIMARY KEY,
    veiculo_codigo INT NOT NULL,
    descricao VARCHAR(300) NOT NULL,
    valor NUMERIC(10, 2) NOT NULL,
    data_manutencao DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (veiculo_codigo) REFERENCES automoveis(veiculos)    
);

---======================================
-- INSERINDO EXEMPLOS DE MANUTENÇÃO DE VEÍCULOS
--======================================

INSERT INTO manutencao_veiculos
(veiculo_codigo, descricao, valor)
VALUES
(1, 'Troca de óleo e filtro', 150.00),
(1, 'Alinhamento e balanceamento', 200.00),
(2, 'Substituição de pastilhas de freio', 300.00),
(2, 'Revisão geral', 500.00),
(4, 'Troca de pneus', 800.00);

SELECT * FROM manutencao_veiculos;

--========================================
-- AT

ALTER TABLE manutencao_veiculos
ADD data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

UPDATE manutencao_veiculos
SET data_manutencao = '2024-06-01'
WHERE codigo = 1;

UPDATE manutencao_veiculos
SET data_manutencao = '2024-06-05'
WHERE codigo = 2;

UPDATE manutencao_veiculos
SET data_registro = '2024-06-05 10:00:00'
WHERE codigo = 1;

UPDATE manutencao_veiculos
SET data_registro = '2024-06-08 12:00:00'
WHERE codigo = 2;


