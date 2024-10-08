--Interpretando os dados.

-- Analisando as categorias de produtos vendidos:
SELECT * from categorias;

--Analisando quantos produtos estão registrados (1000):
SELECT count(*) from produtos;

-- Analisando a quantidade de vendas registradas (50000):
SELECT count(*) as vendas_totais
from vendas;

--Visualizando a quantidade de registros de várias tabelas em uma única consulta:
SELECT COUNT(*) as Qtd, 'Categorias' as Tabela FROM categorias
UNION ALL
SELECT COUNT(*) as Qtd, 'Clientes' as Tabela FROM clientes
UNION ALL
SELECT COUNT(*) as Qtd, 'Fornecedores' as Tabela FROM fornecedores
UNION ALL
SELECT COUNT(*) as Qtd, 'ItensVenda' as Tabela FROM itens_venda
UNION ALL
SELECT COUNT(*) as Qtd, 'Marcas' as Tabela FROM marcas
UNION ALL
SELECT COUNT(*) as Qtd, 'Produtos' as Tabela FROM produtos
UNION ALL
SELECT COUNT(*) as Qtd, 'Vendas' as Tabela FROM vendas;

--Desafio do tratamento de dados.
--Há uma necessidade de verificar e ajustar os preços dos produtos na base de dados, já que alguns itens apresentam valores fora do intervalo considerado normal ou esperado.

SELECT * from produtos;

--Alterando o valor da bola de futebol:
UPDATE produtos 
set preco = 60
WHERE nome_produto = 'Bola de Futebol';

--Alterando o valor de chocolate:
UPDATE produtos 
set preco = 30
WHERE nome_produto = 'Chocolate';

--Alterando o valor de celular:
UPDATE produtos 
set preco = 2540
WHERE nome_produto = 'Celular';

--Alterando o valor de livro de Ficção:
UPDATE produtos 
set preco = 105
WHERE nome_produto = 'Livro de Ficção';

--Alterando o valor de camisa:
UPDATE produtos 
set preco = 140
WHERE nome_produto = 'Camisa';

--Obs: Carregamento da base de dados, conhecendo o schema das tabelas e foi realizado as primeiras consultas.