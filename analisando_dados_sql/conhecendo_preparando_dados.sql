--Entendendo os dados.
SELECT * from categorias;

SELECT * from fornecedores;

SELECT * from marcas;

--Visualizando apenas a amostra da tabela, devido a grande quantidade de linhas:
SELECT * from vendas limit 5;

--Análise temporal: cliclos de vendas.
--Analisando o período dos dados (ano), pois sabemos que tivemos 50 mil vendas. Trazendo os valores únicos e ordenados pelo ano:
SELECT DISTINCT(STRFTIME('%Y', data_venda)) as Ano from vendas
ORDER by Ano;

--Vendas aos longos dos anos (por ano - 4 anos):
SELECT STRFTIME('%Y', data_venda) as Ano , COUNT(id_venda) as Total_Vendas
from vendas
GROUP by Ano
ORDER by Ano;

--Visualizando as vendas dos meses (agrupamento por mês e ano):
SELECT STRFTIME('%Y', data_venda) as Ano , STRFTIME('%m', data_venda) as Mês, COUNT(id_venda) as Total_Vendas
from vendas
GROUP by Ano, Mês
ORDER by Ano;

--Obs: os registros acabam em outubro 2023, então esse projeto é para a black friday de novembro.

--Separando dados da Black Friday.
--A equipe de negócios informou que os meses de interesse não são apenas o da Black Friday. O time quer uma análise mais completa, incluindo os meses que acreditam ser os que mais vendem.
--Esses meses seriam: janeiro, novembro da Black Friday e dezembro, o período do Natal.
--Filtrando os meses que mai vendem:
SELECT STRFTIME('%Y', data_venda) as Ano , STRFTIME('%m', data_venda) as Mês, COUNT(id_venda) as Total_Vendas
from vendas
WHERE Mês = '01' or Mês = '11' or Mês = '12'
GROUP by Ano, Mês
ORDER by Ano;

--Obs: Fazendo uma análise rápida, descobrimos que em novembro de 2020, tivemos 1.600 vendas. Em 2021, tivemos 2.400 vendas nesse mesmo mês. E em 2022, tivemos 3.200 vendas também no 
--décimo primeiro mês. Isso significa que as vendas na Black Friday estão aumentando ao longo do tempo. É uma análise que já conseguimos fazer utilizando apenas a tabela.
