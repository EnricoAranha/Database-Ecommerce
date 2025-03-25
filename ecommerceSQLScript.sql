-- criação de banco de dados para o cenário de Ecommerce
CREATE DATABASE ecommerce;
USE ecommerce;

-- criar tabela cliente
CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    Pnome VARCHAR(10) NOT NULL,
    Nome_do_meio VARCHAR(3),
    Sobrenome VARCHAR(20),
    CPF_CNPJ CHAR(20) UNIQUE NOT NULL,
    Endereco VARCHAR(45),
    Data_de_nascimento DATE,
    Dados_do_cartao_1 VARCHAR(45)
);

-- criar tabela produto
CREATE TABLE Produto (
    idProduto INT PRIMARY KEY AUTO_INCREMENT,
    Pnome VARCHAR(20) NOT NULL,
    Categoria VARCHAR(45) NOT NULL,
    Descrição VARCHAR(45),
    Valor FLOAT
);
-- criar tabela pedido
CREATE TABLE Pedido (
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    Status_do_pedido ENUM('Em Andamento', 'Processando', 'Enviado', 'Entregue', 'Cancelado') NOT NULL DEFAULT 'Processando',
    Descricao VARCHAR(45),
    Cliente_idCliente INT NOT NULL,
    Metodo_pagamento ENUM('Pix', 'Débito', 'Crédito', 'Boleto'),
    Valor_do_pedido FLOAT,
    Entrega_idEntrega INT NOT NULL,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (Entrega_idEntrega) REFERENCES Entrega(idEntrega)
    on update cascade
);

-- criar tabela fornecedor
CREATE TABLE Fornecedor(
	IdFornecedor INT PRIMARY KEY AUTO_INCREMENT,
    Razão_Social VARCHAR(45) NOT NULL UNIQUE,
    CNPJ CHAR(20) NOT NULL UNIQUE,
    Contato VARCHAR(15)
);

-- criar tabela vendedor (terceiros)
CREATE TABLE Vendedor_Terceiro(
	IdVendedor INT PRIMARY KEY AUTO_INCREMENT,
    Razão_Social VARCHAR(45) NOT NULL UNIQUE,
    Nome_Fantasia VARCHAR(45),
    Contato VARCHAR(15)
);

-- criar tabela estoque
CREATE TABLE Estoque(
	IdEstoque INT PRIMARY KEY AUTO_INCREMENT,
    Local_Estoque VARCHAR(45) NOT NULL
);

-- criar tabela entrega
CREATE TABLE Entrega(
	idEntrega INT PRIMARY KEY AUTO_INCREMENT,
    Código CHAR(45) UNIQUE,
    Status_Entrega ENUM('Preparando', 'Pronto', 'A caminho', 'Entregue', 'Cancelado') NOT NULL DEFAUlT 'Preparando',
    Frete FLOAT NOT NULL
);

-- criar tabela produtos por vendedor
CREATE TABLE Produtos_por_vendedor(
	IdVendedor INT NOT NULL,
    IdProduto INT NOT NULL,
	Quantidade INT NOT NULL,
    FOREIGN KEY (IdVendedor) REFERENCES Vendedor_Terceiro(IdVendedor),
    FOREIGN KEY (IdProduto) REFERENCES Produto(IdProduto)
);

-- criar tabela desponibiliza um produto
CREATE TABLE Disponibliza_Produto (
	IdProduto INT,
    IdFornecedor INT,
    PRIMARY KEY (IdProduto, IdFornecedor),
    FOREIGN KEY (IdProduto) REFERENCES Produto(IdProduto),
    FOREIGN KEY (IdFornecedor) REFERENCES Fornecedor(IdFornecedor)
);

-- criar tabela produto em estoque
CREATE TABLE Produto_em_estoque (
	IdProduto INT,
    IdEstoque INT,
    Quantidade INT NOT NULL DEFAULT 0,
    PRIMARY KEY (IdProduto, IdEstoque),
    FOREIGN KEY (IdProduto) REFERENCES Produto(IdProduto),
    FOREIGN KEY (IdEstoque) REFERENCES Estoque(IdEstoque)
);

-- criar tabela produto por pedido
CREATE TABLE Produto_por_Pedido (
	IdProduto INT,
    IdPedido INT,
    Quantidade INT NOT NULL DEFAULT 0,
    PRIMARY KEY (IdProduto, IdPedido)
);

SHOW TABLES;

-- inserções
INSERT INTO Cliente (Pnome, Nome_do_meio, Sobrenome, CPF_CNPJ, Endereco, Data_de_nascimento, Dados_do_cartao_1)  
VALUES  
    ('Fabio', 'Com', 'F', '01313949802', 'Rua Eulalia Bastos, 23', '2005-05-05', ''),  
    ('Mariana', 'S.', 'Souza', '12345678900', 'Avenida Paulista, 500', '1998-08-12', 'Visa **** 1234'),  
    ('Carlos', 'A.', 'Mendes', '98765432100', 'Rua das Flores, 100', '1985-11-23', 'Mastercard **** 5678'),  
    ('Juliana', 'B.', 'Oliveira', '56473829100', 'Praça Central, 45', '2000-03-30', ''),  
    ('Pedro', 'C.', 'Santos', '15926348700', 'Rua do Sol, 75', '1993-06-17', 'Amex **** 9012');  

SELECT * FROM Cliente;

INSERT INTO Produto (Pnome, Categoria, Descrição, Valor)
VALUES
    ('Fone de ouvido', 'Eletrônicos', 'Fones de ouvido da Samsung', '39.99'),
    ('Teclado mecânico', 'Eletrônicos', 'Teclado mecânico RGB para gamers', '199.90'),
    ('Cadeira gamer', 'Móveis', 'Cadeira ergonômica para jogos e trabalho', '799.00'),
    ('Monitor 24"', 'Eletrônicos', 'Monitor Full HD com taxa de 144Hz', '999.99'),
    ('Mouse sem fio', 'Eletrônicos', 'Mouse óptico sem fio recarregável', '89.90'),
    ('Smartphone', 'Eletrônicos', 'Celular Android com 128GB de armazenamento', '1999.00'),
    ('Notebook', 'Eletrônicos', 'Notebook com processador Intel i7 e 16GB RAM', '4999.99'),
    ('Mesa para escritório', 'Móveis', 'Mesa de madeira para home office', '399.00'),
    ('Câmera de segurança', 'Segurança', 'Câmera Wi-Fi com visão noturna', '299.90'),
    ('Impressora', 'Eletrônicos', 'Impressora a laser com scanner e Wi-Fi', '699.99');

SELECT * FROM Produto;

INSERT INTO Pedido (Status_do_pedido, Descricao, Cliente_idCliente, Metodo_pagamento, Valor_do_pedido, Entrega_idEntrega)
VALUES
    ('Em Andamento', 'Pedido de aniversário', 6, 'Crédito', 159.90, 1),
    ('Processando', null, 10, 'Pix', 249.50, 2),
    ('Enviado', 'Entrega expressa', 9, 'Débito', 349.99, 3),
    ('Entregue', 'Pedido recebido sem avarias', 9, 'Boleto', 99.00, 4),
    ('Cancelado', 'Cliente desistiu da compra', 7, 'Pix', 189.75, 5),
    ('Processando', 'Pedido com desconto aplicado', 8, 'Crédito', 459.80, 6),
    ('Em Andamento', null, 8, 'Débito', 129.90, 7);

SELECT * FROM Pedido;

INSERT INTO Fornecedor (Razão_Social, CNPJ, Contato)
VALUES
    ('Tech Solutions LTDA', '12.345.678/0001-90', '(11) 98765-4321'),
    ('EletroBrasil SA', '98.765.432/0001-12', '(21) 99876-5432'),
    ('Gamer Zone Distribuidora', '34.567.890/0001-23', '(61) 95555-0000'),
    ('Digital Tech Comércio', '45.678.901/0001-34', '(31) 98888-7777'),
    ('Mega Eletrônicos LTDA', '23.456.789/0001-56', '(41) 97777-8888'),
    ('Smart Devices Import', '56.789.012/0001-78', '(51) 96666-9999'),
    ('Hardware Express', '67.890.123/0001-45', '(71) 94444-1111');

INSERT INTO Vendedor_Terceiro (Razão_Social, Nome_Fantasia, Contato)
VALUES
    ('Tech Distribuidora LTDA', 'Tech Distribuidora', '(11) 91234-5678'),
    ('EletroShop Comércio ME', 'EletroShop', '(21) 92345-6789'),
    ('Smart Solutions SA', 'Smart Solutions', '(31) 93456-7890'),
    ('Gadget Express LTDA', 'Gadget Express', '(41) 94567-8901'),
    ('Hardware Prime ME', 'Hardware Prime', '(51) 95678-9012'),
    ('Digital Center Comércio', 'Digital Center', '(61) 96789-0123'),
    ('Eletrônicos Fast LTDA', 'Eletrônicos Fast', '(71) 97890-1234');
    
INSERT INTO Estoque (Local_Estoque)
VALUES
    ('Centro de Distribuição - São Paulo'),
    ('Centro de Distribuição - Rio de Janeiro'),
    ('Centro de Distribuição - Belo Horizonte'),
    ('Centro de Distribuição - Curitiba'),
    ('Centro de Distribuição - Porto Alegre');

INSERT INTO Entrega (Código, Status_Entrega, Frete)
VALUES
    ('ENT-20240301-001', 'Preparando', 19.99),
    ('ENT-20240301-002', 'Pronto', 15.50),
    ('ENT-20240301-003', 'A caminho', 12.00),
    ('ENT-20240301-004', 'Entregue', 25.75),
    ('ENT-20240301-005', 'Cancelado', 0.00),
    ('ENT-20240301-006', 'Preparando', 20.90),
    ('ENT-20240301-007', 'A caminho', 18.50);

SELECT * FROM Entrega;

INSERT INTO Produtos_por_vendedor (IdVendedor, IdProduto, Quantidade)
VALUES
    (1, 21, 50),  -- Tech Distribuidora vendendo Fone de Ouvido
    (2, 22, 30),  -- EletroShop vendendo Teclado Mecânico
    (3, 23, 20),  -- Smart Solutions vendendo Cadeira Gamer
    (4, 24, 40),  -- Gadget Express vendendo Monitor
    (5, 25, 35),  -- Hardware Prime vendendo Mouse sem fio
    (6, 26, 25),  -- Digital Center vendendo Smartphone
    (7, 27, 15);  -- Eletrônicos Fast vendendo Notebook
    
SELECT * FROM Produto;
SELECT * FROM Vendedor_Terceiro;

INSERT INTO Disponibliza_Produto (IdProduto, IdFornecedor)
VALUES
    (21, 1),  -- Tech Solutions fornece Fone de Ouvido
    (22, 2),  -- EletroBrasil fornece Teclado Mecânico
    (23, 3),  -- Gamer Zone fornece Cadeira Gamer
    (24, 4),  -- Digital Tech fornece Monitor
    (25, 5),  -- Mega Eletrônicos fornece Mouse sem fio
    (26, 6),  -- Smart Devices fornece Smartphone
    (27, 7);  -- Hardware Express fornece Notebook

INSERT INTO Produto_por_Pedido (IdProduto, IdPedido, Quantidade)
VALUES
    (21, 29, 2),  -- Pedido 1 comprou 2 Fones de Ouvido
    (22, 30, 1),  -- Pedido 2 comprou 1 Teclado Mecânico
    (23, 31, 1),  -- Pedido 3 comprou 1 Cadeira Gamer
    (24, 32, 1),  -- Pedido 4 comprou 1 Monitor
    (25, 33, 3),  -- Pedido 5 comprou 3 Mouses sem fio
    (26, 34, 2),  -- Pedido 6 comprou 2 Smartphones
    (27, 35, 1);  -- Pedido 7 comprou 1 Notebook
    
SELECT * FROM Pedido;

-- Queries

-- Simples com SELECT: Quais são os produtos e seus valores?
SELECT Pnome, Valor FROM Produto;

-- Simples com SELECT: Quais são nossos clientes cadastrados?
SELECT idCliente, Pnome, Nome_do_meio, Sobrenome FROM Cliente;

-- Filtros com WHERE: Pedidos em processamento
SELECT * 
FROM Pedido 
WHERE Status_do_pedido = 'Processando';

-- Filtros com WHERE: Entregas com frete maior que 15
SELECT * 
FROM Entrega 
WHERE Frete > 15;

-- Atributos derivados: Pedidos e o valor total (pedido + frete)
SELECT p.idPedido, p.Valor_do_pedido, e.Frete, 
       ROUND(p.Valor_do_pedido + e.Frete, 2) AS Total_com_Frete
FROM Pedido p JOIN Entrega e ON p.Entrega_idEntrega = e.idEntrega;

-- Atributos derivados: Nome e idade dos clientes (considerando o ano)
SELECT Pnome, Sobrenome, 
       YEAR(CURDATE()) - YEAR(Data_de_nascimento) AS Idade 
FROM Cliente;

-- Order by: Produto mais caro ao mais barato
SELECT Pnome, Valor 
FROM Produto 
ORDER BY Valor DESC;

-- Having statement: Número de pedidos por cliente com mais de 2 pedidos
SELECT Cliente_idCliente, COUNT(*) AS Total_Pedidos 
FROM Pedido 
GROUP BY Cliente_idCliente 
HAVING COUNT(*) >= 2;

-- Join: Produtos vendidos por cada vendedor
SELECT v.Razão_Social, pr.Pnome, pv.Quantidade 
FROM Produtos_por_vendedor pv
JOIN Vendedor_Terceiro v ON pv.IdVendedor = v.IdVendedor
JOIN Produto pr ON pv.IdProduto = pr.IdProduto;

SELECT * FROM Vendedor_Terceiro;
SELECT * FROM Produtos_por_vendedor;

-- Join: Pedidos com nome do cliente, status, valor total
SELECT p.idPedido, c.Pnome, c.Sobrenome, p.Status_do_pedido, 
       ROUND(p.Valor_do_pedido + e.Frete, 2) AS Total_com_Frete
FROM Pedido p
JOIN Cliente c ON p.Cliente_idCliente = c.idCliente
JOIN Entrega e ON p.Entrega_idEntrega = e.idEntrega
ORDER BY Total_com_Frete DESC;