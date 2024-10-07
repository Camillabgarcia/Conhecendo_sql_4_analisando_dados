-- Consulta de performance de vendas no quadro geral (Sazonalidade).
SELECT 
    STRFTIME('%Y/%m', v.data_venda) AS "Ano/Mês",   -- Seleciona o ano e mês da data de venda no formato "YYYY/MM".
    COUNT(*) AS Qtd_Vendas                          -- Conta quantos produtos foram vendidos no período.
FROM vendas v                                       -- Consulta na tabela de vendas.
GROUP BY "Ano/Mês"                                  -- Agrupa os resultados por ano e mês.
ORDER BY "Ano/Mês";                                 -- Ordena os resultados por ano e mês.

-- Consulta para análise de sazonalidade, comparando vendas entre os anos.
SELECT 
    STRFTIME('%m', data_venda) AS Mes,              -- Seleciona o mês da data de venda no formato "MM".
    STRFTIME('%Y', data_venda) as Ano,              -- Seleciona o ano da data de venda no formato "YYYY".
    COUNT(*) AS Qtd_Vendas                          -- Conta quantos produtos foram vendidos no período.
FROM vendas                                         -- Consulta na tabela de vendas.
GROUP BY Ano, Mes                                   -- Agrupa os resultados por ano e mês.
ORDER BY Mes, Ano;                                  -- Ordena os resultados por mês e ano.

-- Subconsulta para organizar os dados de diferentes anos em colunas.
SELECT 
    Mes,                                            -- Seleciona a coluna Mês.
    SUM(CASE WHEN Ano = '2020' THEN Qtd_Vendas ELSE 0 END) AS "2020",  -- Soma a quantidade de vendas de 2020.
    SUM(CASE WHEN Ano = '2021' THEN Qtd_Vendas ELSE 0 END) AS "2021",  -- Soma a quantidade de vendas de 2021.
    SUM(CASE WHEN Ano = '2022' THEN Qtd_Vendas ELSE 0 END) AS "2022",  -- Soma a quantidade de vendas de 2022.
    SUM(CASE WHEN Ano = '2023' THEN Qtd_Vendas ELSE 0 END) AS "2023"   -- Soma a quantidade de vendas de 2023.
FROM (
    -- Subconsulta que organiza as vendas por ano e mês.
    SELECT 
        STRFTIME('%m', data_venda) AS Mes,          -- Seleciona o mês da data de venda no formato "MM".
        STRFTIME('%Y', data_venda) AS Ano,          -- Seleciona o ano da data de venda no formato "YYYY".
        COUNT(*) AS Qtd_Vendas                      -- Conta quantos produtos foram vendidos no período.
    FROM vendas                                     -- Consulta na tabela de vendas.
    GROUP BY Mes, Ano                               -- Agrupa os resultados por e mês.
    ORDER BY Mes                                    -- Ordena os resultados por mês.
) 
GROUP BY Mes;                                       -- Agrupa os resultados por mês para comparação entre os anos.


--Medindo o resultado das ações que estão sendo tomadas,  para que os gestores possam monitorar o impacto delas na Black Friday do ano de 2023.
--Acompanhar as métricas de vendas.

--Métricas de BI para acompanhar o desenvolvimento da Black Friday:

--Consulta para encontrar a média de quanto vendeu nas últimas Black Fridays, a quantidade de vendas atuais e a porcentagem indicando se superou ou não as médias anteriores.

--Consulta para obter a média dos anos anteiores.
SELECT AVG(Qtd_Vendas) as Media_Qtd_Vendas           -- Calcula a média da quantidade de vendas por ano.
from(
    SELECT 
      COUNT(*) AS Qtd_Vendas,                        -- Conta o total de registros (vendas) que atendem aos filtros especificados.
      STRFTIME('%Y', v.data_venda) AS Ano            -- Extrai o ano da data de venda e o nomeia como "Ano".
  FROM vendas v                                      -- Consulta a tabela de vendas.
  WHERE STRFTIME('%m', v.data_venda) = '11'          -- Filtra as vendas que ocorreram no mês de novembro.
    AND STRFTIME('%Y', v.data_venda) != '2022'       -- Exclui as vendas que ocorreram no ano de 2022.
  GROUP BY Ano                                       -- Agrupa os resultados por ano para obter as vendas por ano.
);

--Consulta para a quantidade de vendas que está acontecendo na Black Friday de 2022.
SELECT Qtd_Vendas as Qtd_Vendas_Atual
from(
    SELECT 
      COUNT(*) AS Qtd_Vendas,                        -- Conta o total de registros (vendas) que atendem aos filtros especificados.
      STRFTIME('%Y', v.data_venda) AS Ano            -- Extrai o ano da data de venda e o nomeia como "Ano".
  FROM vendas v                                      -- Consulta a tabela de vendas.
  WHERE STRFTIME('%m', v.data_venda) = '11'          -- Filtra as vendas que ocorreram no mês de novembro.
    AND STRFTIME('%Y', v.data_venda) = '2022'       --  Vendas que ocorreram no ano de 2022.
  GROUP BY Ano                                       -- Agrupa os resultados por ano para obter as vendas por ano.
);

--Combinando as duas subconsultas e fazendo o cálculo de porcentagem para descobrir o quão superior ou inferior à média das Black Fridays anteriores está a Black Friday atual.

WITH Media_Vendas_Anteriores AS (
    SELECT AVG(Qtd_Vendas) AS Media_Qtd_Vendas           -- Calcula a média da quantidade de vendas por ano.
    FROM (
        SELECT 
            COUNT(*) AS Qtd_Vendas,                        -- Conta o total de registros (vendas) que atendem aos filtros especificados.
            STRFTIME('%Y', v.data_venda) AS Ano           -- Extrai o ano da data de venda e o nomeia como "Ano".
        FROM vendas v                                      -- Consulta a tabela de vendas.
        WHERE STRFTIME('%m', v.data_venda) = '11'          -- Filtra as vendas que ocorreram no mês de novembro.
          AND STRFTIME('%Y', v.data_venda) != '2022'       -- Exclui as vendas que ocorreram no ano de 2022.
        GROUP BY Ano                                       -- Agrupa os resultados por ano para obter as vendas por ano.
    )
), Vendas_Atual AS (
    SELECT Qtd_Vendas AS Qtd_Vendas_Atual
    FROM (
        SELECT 
            COUNT(*) AS Qtd_Vendas,                        -- Conta o total de registros (vendas) que atendem aos filtros especificados.
            STRFTIME('%Y', v.data_venda) AS Ano           -- Extrai o ano da data de venda e o nomeia como "Ano".
        FROM vendas v                                      -- Consulta a tabela de vendas.
        WHERE STRFTIME('%m', v.data_venda) = '11'          -- Filtra as vendas que ocorreram no mês de novembro.
          AND STRFTIME('%Y', v.data_venda) = '2022'       -- Vendas que ocorreram no ano de 2022.
        GROUP BY Ano                                       -- Agrupa os resultados por ano para obter as vendas por ano.
    )
)
SELECT 
    mva.Media_Qtd_Vendas,                               -- Média das vendas dos anos anteriores.
    va.Qtd_Vendas_Atual,                                -- Quantidade de vendas atual de 2022.
    ROUND((va.Qtd_Vendas_Atual - mva.Media_Qtd_Vendas) / mva.Media_Qtd_Vendas * 100.0, 2) || '%' AS Porcentagem -- Cálculo da variação percentual em relação à média.
FROM Vendas_Atual va, Media_Vendas_Anteriores mva;    -- Junta as CTEs para obter os resultados finais.

  
  
  
  
  