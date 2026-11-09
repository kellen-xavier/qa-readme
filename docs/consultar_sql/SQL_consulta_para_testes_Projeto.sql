-- SQL PARA TESTES PROJETO --

--deletar dado especifico de e-mails
DELETE FROM nome_tabela WHERE id

--Verificar estoque de produtos geral --
SELECT * FROM `name_companies`
WHERE product_id = 111
AND serial = 'ASDD666'


--- Exportar um relatório de contato Lading Page ---
-- Adicionado nomes 'AS' para cada coluna --
SELECT
    name AS 'Nome',
    company AS 'Revenda',
    phone AS 'Contato',
    email AS 'E-mail',
    document AS 'Documento',
    city AS 'Cidade',
    state AS 'Estado'
FROM landing_page
WHERE is_active = 1;
-- Active 1 são todos exemplos que chamei de ativos na consulta --


--- /consulta cadastrada por Marca / ----
SELECT  id,
  type_id,
  name AS 'Nome',
  start_validate,
  end_validate,
  gift_ratio,
  gift_quantity,
  name_quantity,
  category_quantity,
  max_category_quantity,
  category_discount,
  name_tabela,
  is_active AS 'Ativo',
  name_id AS 'Nome do ID',
  created,
  modified,
  last_modified,
  stack
FROM site_nome
  WHERE name_id IS NOT null;


  SELECT
  id,
  description AS 'Descrição',
  brand_id AS 'Marca',
  product_group_id,
  unity_value,
  is_serialized,
  customizable,
  icms_group_id,
  created,
  modified,
  is_active,
  last_modified
  FROM products
  WHERE id = 73
  AND brand_id IS NOT null;

----------------------------------------------------------------------
-------------- ** Verificar Item na NF e sua Empresa -----------------
-- abaixo seguei um modelo de pesquisa para consultar mais de uma tabela >relacionais
SELECT 
    receiver_id AS 'Revenda ID',
    dealers.name  AS 'Revenda Name'
FROM nomeprojeto.nfe_headers
INNER JOIN nomeprojeto.nfe_items ON nfe_items.nfe_header_id = nfe_headers.id 
INNER JOIN nomeprojeto.dealers ON dealers.id = nfe_headers.receiver_id 
INNER JOIN nomeprojeto.dealer_addresses ON dealer_addresses.dealer_id = dealers.id
INNER JOIN nomeprojeto.cities ON cities.id = dealer_addresses.city_id 
WHERE 
    emitter_id = 2 # Empresa
    AND nfe_items.product_id = 666
    AND cities.state_id != 66 # ID
-- Empresas contém duas ativas: 1 e 2 --

-- EXEMPLO PADRÃO DE CONSULTA REFERENTE ACIMA --
SELECT * 
FROM tabela1 
INNER JOIN tabela2
ON tabela1.coluna = tabela2.coluna;

-- Consultas Exportar relatórios Landing Page --
SELECT
    name AS 'Nome',
    company AS 'Revenda',
    phone AS 'Contato',
    email AS 'E-mail',
    document AS 'Documento',
    referer AS 'referencia',
    city AS 'Cidade',
    state AS 'Estado'
FROM landing_page
WHERE is_active = 1;


-- Todos os dados que contém neste doc são para exemplificar pesquisas em BD Relacional.
-- Apenas para exercitar manipulação de dados SQL --