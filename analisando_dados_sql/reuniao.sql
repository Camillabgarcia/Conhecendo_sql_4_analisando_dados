--Preparando querys para a reunião trimestral.
--Temática da reunião: quais ações focar na Black Friday deste ano.

--Pauta da reunião: Papel dos fornecendores na black friday.
--Analisando os itens vendidos (visualizando a performace do fornecedor ao longo do tempo, com a informação da data da venda):
SELECT STRFTIME('%Y/%m', v.data_venda) AS "Ano/Mês", f.nome as Nome_fornecedor, COUNT(iv.produto_id) as Qtd_vendas
from itens_venda iv
JOIN vendas v
on v.id_venda = iv.venda_id
join produtos p
on iv.produto_id = p.id_produto
join fornecedores f
on p.fornecedor_id = f.id_fornecedor
GROUP by Nome_fornecedor, "Ano/Mês"
ORDER by Nome_fornecedor;

--Obs: Assim, quando surgirem perguntas sobre alguns fornecedores, sendo necessário fazer comparações entre os fornecedores, será muito fácil responder através dessa consulta.

--Pauta da reunião: desempenho de vendas de diferentes categorias de produtos na black friday.
SELECT strftime('%Y', v.data_venda) AS "Ano", c.nome_categoria AS Nome_Categoria, COUNT(iv.produto_id) AS Qtd_Vendas
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN produtos p ON p.id_produto = iv.produto_id
JOIN categorias c ON c.id_categoria = p.categoria_id
WHERE strftime('%m', v.data_venda) = '11'
GROUP BY Nome_Categoria, "Ano"
ORDER BY "Ano", Qtd_Vendas DESC;

--Respondendo dúvidas na reunião sobre a Black Friday:
--Fornecedores: Quais foram os fornecedores que mais venderam na última Black Friday?
--Verificar se foi o NebulaNetworks que menos vendeu.
--Quais categorias venderam mais.
--Quais categorias que menos venderam.
--Mostrando o desempenho de vendas da NebulaNetworks.
SELECT STRFTIME('%Y/%m', v.data_venda) AS "Ano/Mês", f.nome as Nome_fornecedor, COUNT(iv.produto_id) as Qtd_vendas
from itens_venda iv
JOIN vendas v
on v.id_venda = iv.venda_id
join produtos p
on iv.produto_id = p.id_produto
join fornecedores f
on p.fornecedor_id = f.id_fornecedor
WHERE strftime('%m', v.data_venda) = '11'
GROUP by Nome_fornecedor, "Ano/Mês"
ORDER by Nome_fornecedor;

--Verificando se os dados estão atualizados, pois sabemos que forma vendidos 1500 itens:
SELECT SUM(Qtd_Vendas)
from (
  SELECT STRFTIME('%Y/%m', v.data_venda) AS "Ano/Mês", f.nome as Nome_fornecedor, COUNT(iv.produto_id) as Qtd_vendas
  from itens_venda iv
  JOIN vendas v
  on v.id_venda = iv.venda_id
  join produtos p
  on iv.produto_id = p.id_produto
  join fornecedores f
  on p.fornecedor_id = f.id_fornecedor
  GROUP by Nome_fornecedor, "Ano/Mês"
  ORDER by "Ano/Mês", Qtd_Vendas);

--Trazendo informações do fornecedor (NebulaNetworks) que teve a pior performance na última Black Friday ao longo do tempo:
  SELECT STRFTIME('%Y/%m', v.data_venda) AS "Ano/Mês", COUNT(iv.produto_id) as Qtd_vendas
  from itens_venda iv
  JOIN vendas v
  on v.id_venda = iv.venda_id
  join produtos p
  on iv.produto_id = p.id_produto
  join fornecedores f
  on p.fornecedor_id = f.id_fornecedor
  WHERE f.nome = 'NebulaNetworks'
  GROUP by f.nome, "Ano/Mês"
  ORDER by "Ano/Mês", Qtd_Vendas;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  