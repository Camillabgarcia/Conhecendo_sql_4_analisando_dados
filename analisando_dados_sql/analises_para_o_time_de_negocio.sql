--Consultando para ecnontrar quais são os dois fornecedores com maior quantidade de vendas.categorias

  SELECT STRFTIME('%Y/%m', v.data_venda) AS "Ano/Mês", f.nome AS Nome_Fornecedor, COUNT(iv.produto_id) as Qtd_vendas   --consulta utilizada na reunião para descobrir qual foi o fornecedor que menos vendeu na Black Friday.
  from itens_venda iv
  JOIN vendas v
  on v.id_venda = iv.venda_id
  join produtos p
  on iv.produto_id = p.id_produto
  join fornecedores f
  on p.fornecedor_id = f.id_fornecedor
  WHERE Nome_Fornecedor = 'NebulaNetworks' or Nome_Fornecedor = 'AstroSupply' OR Nome_Fornecedor = 'HorizonDistributors' --Filtra os três fornecedos com destaque, onde o primeiro teve a pior performace e os dois últimos as melhores.
  GROUP by Nome_Fornecedor, "Ano/Mês"
  ORDER by "Ano/Mês", Qtd_Vendas;
  
  
  
--Consulta para analisar a quantidade de vendas dos três fornecedores escolhidos, onde será criado um gráfico no Google Sheets para melhorar a análise.
SELECT "Ano/Mês",     -- Seleciona a coluna "Ano/Mês".
SUM(CASE                        --Separando as vendas de cada fornecedor
		when Nome_Fornecedor == 'NebulaNetworks' THEN Qtd_vendas  -- Soma a quantidade de vendas quando o fornecedor for 'NebulaNetworks'.
		else 0 -- Retorna 0 quando o fornecedor não for 'NebulaNetworks'.
	end) As Qtd_vendas_NebulaNetworks,
SUM(CASE                      
		when Nome_Fornecedor == 'HorizonDistributors' THEN Qtd_vendas  -- Soma a quantidade de vendas quando o fornecedor for 'HorizonDistributors'.
		else 0 -- Retorna 0 quando o fornecedor não for 'HorizonDistributors'.
	end) As Qtd_vendas_HorizonDistributors,
SUM(CASE                      
		when Nome_Fornecedor == 'AstroSupply' THEN Qtd_vendas  -- Soma a quantidade de vendas quando o fornecedor for 'AstroSupply'.
		else 0 -- Retorna 0 quando o fornecedor não for 'AstroSupply'.
	end) As Qtd_vendas_AstroSupply
FROM(                                                                       --Transformando a query em uma subconsulta.
    SELECT STRFTIME('%Y/%m', v.data_venda) AS "Ano/Mês", f.nome AS Nome_Fornecedor, COUNT(iv.produto_id) as Qtd_vendas   
    from itens_venda iv
    JOIN vendas v
    on v.id_venda = iv.venda_id
    join produtos p
    on iv.produto_id = p.id_produto
    join fornecedores f
    on p.fornecedor_id = f.id_fornecedor
    WHERE Nome_Fornecedor = 'NebulaNetworks' or Nome_Fornecedor = 'AstroSupply' OR Nome_Fornecedor = 'HorizonDistributors' --Filtra os três fornecedos com destaque, onde o primeiro teve a pior performace e os dois últimos as melhores.
    GROUP by Nome_Fornecedor, "Ano/Mês"
    ORDER by "Ano/Mês", Qtd_Vendas
   )
   GROUP by "Ano/Mês"        --Agrupa os resultados conforme o tempo.
   ;
 


 --Consulta sobre representação das vendas por categorias(%).

SELECT 
    Nome_Categoria,                              -- Seleciona o nome da categoria do produto.
    Qtd_Vendas,                                  -- Seleciona a quantidade de vendas da categoria.
    ROUND(100.0 * Qtd_Vendas / (SELECT COUNT(*) FROM itens_venda), 2) || '%' AS Porcentagem  -- Calcula a porcentagem, arredonda para 2 casas decimais e concatena o símbolo de porcentagem.
FROM (
    -- Subconsulta que agrupa e conta as vendas por categoria
    SELECT
        c.nome_categoria AS Nome_Categoria,      -- Seleciona o nome da categoria do produto.
        COUNT(iv.produto_id) AS Qtd_Vendas       -- Conta quantos produtos foram vendidos, agrupados por categoria.
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id    -- Faz o join entre a tabela de itens de venda e vendas com base no ID de venda.
    JOIN produtos p ON p.id_produto = iv.produto_id  -- Faz o join entre itens de venda e produtos com base no ID do produto.
    JOIN categorias c ON c.id_categoria = p.categoria_id  -- Faz o join entre produtos e categorias com base no ID da categoria.
    GROUP BY Nome_Categoria                      -- Agrupa os resultados por nome da categoria.
    ORDER BY Qtd_Vendas DESC                     -- Ordena os resultados por quantidade de vendas de forma decrescente.
);

--Consulta da representação das vendas por fornecedor(%).

SELECT Nome_Fornecedor, Qtd_Vendas, ROUND(100.0 * Qtd_Vendas / (SELECT COUNT(*) FROM itens_venda), 2) || '%' AS Porcentagem
FROM(
    SELECT f.nome AS Nome_Fornecedor, COUNT(iv.produto_id) AS Qtd_Vendas
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
    GROUP BY Nome_Fornecedor
    ORDER BY Qtd_Vendas DESC
    )
;

--Consulta da representação das vendas por marca(%).

SELECT Nome_Marca, Qtd_Vendas, ROUND(100.0 * Qtd_Vendas / (SELECT COUNT(*) FROM itens_venda), 2) || '%' AS Porcentagem
FROM(
    SELECT m.nome AS Nome_Marca, COUNT(iv.produto_id) AS Qtd_Vendas
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN marcas m ON m.id_marca = p.marca_id
    GROUP BY Nome_Marca
    ORDER BY Qtd_Vendas DESC
    )
;
