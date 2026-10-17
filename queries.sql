-- =====================================================================================
-- OLIST E-COMMERCE ANALYTICS: ZAPYTANIA BAZODANOWE (POSTGRESQL)
-- Projekt portfolio: Przetwarzanie i agregacja danych dla dashboardu Power BI
-- W tym pliku znajdują się wszystkie zapytania SQL, które użyto to sporządzenia wyników
-- =====================================================================================

-- 1. Audyt statusów zamówień (Identyfikacja wolumenu dla filtracji)
SELECT 
    order_status,
    count(order_status) AS order_amount
FROM orders
GROUP BY order_status
ORDER BY count(order_status) DESC;

-- 2. Główne wskaźniki KPI (Karty na dashboardzie)
-- Agregacja kluczowych metryk w jednym wierszu w celu odciążenia silnika Power BI
SELECT
    sum(oi.price) AS total_gmv,
    count(distinct o.order_id) AS total_orders,
    sum(oi.price) / count(distinct o.order_id) AS aov,
    avg(oi.freight_value) AS avg_freight
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- 3. Miesięczny trend sprzedaży (Szereg czasowy)
SELECT 
    date_trunc('month', o.order_purchase_timestamp) AS sales_month,
    sum(price) AS priceAmount
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE order_status = 'delivered'
GROUP BY sales_month
ORDER BY sales_month;

-- 4. Top 5 Najbardziej Dochodowych Kategorii
-- Transformacja surowych nazw portugalskich na kategorie biznesowe
SELECT 
    CASE p.product_category_name
        WHEN 'beleza_saude' THEN 'Zdrowie i Uroda'
        WHEN 'relogios_presentes' THEN 'Zegarki i Prezenty'
        WHEN 'cama_mesa_banho' THEN 'Dom i Sypialnia'
        WHEN 'esporte_lazer' THEN 'Sport i Rekreacja'
        WHEN 'informatica_acessorios' THEN 'Komputery i Akcesoria'
        ELSE p.product_category_name
    END AS kategoria, 
    sum(oi.price) AS total_revenue
FROM orders o
INNER JOIN order_items oi 
    ON o.order_id = oi.order_id
INNER JOIN products p 
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY kategoria
ORDER BY sum(oi.price) DESC
LIMIT 5;

-- 5. Analiza geograficzna i korelacja kosztów logistyki
-- Mapowanie kodów na pełne nazwy rynków lokalnych
SELECT 
    CASE c.customer_state 
        WHEN 'AC' THEN 'Acre'
        WHEN 'AL' THEN 'Alagoas'
        WHEN 'AP' THEN 'Amapá'
        WHEN 'AM' THEN 'Amazonas'
        WHEN 'BA' THEN 'Bahia'
        WHEN 'CE' THEN 'Ceará'
        WHEN 'DF' THEN 'Distrito Federal'
        WHEN 'ES' THEN 'Espírito Santo'
        WHEN 'GO' THEN 'Goiás'
        WHEN 'MA' THEN 'Maranhão'
        WHEN 'MT' THEN 'Mato Grosso'
        WHEN 'MS' THEN 'Mato Grosso do Sul'
        WHEN 'MG' THEN 'Minas Gerais'
        WHEN 'PA' THEN 'Pará'
        WHEN 'PB' THEN 'Paraíba'
        WHEN 'PR' THEN 'Paraná'
        WHEN 'PE' THEN 'Pernambuco'
        WHEN 'PI' THEN 'Piauí'
        WHEN 'RJ' THEN 'Rio de Janeiro'
        WHEN 'RN' THEN 'Rio Grande do Norte'
        WHEN 'RS' THEN 'Rio Grande do Sul'
        WHEN 'RO' THEN 'Rondônia'
        WHEN 'RR' THEN 'Roraima'
        WHEN 'SC' THEN 'Santa Catarina'
        WHEN 'SP' THEN 'São Paulo'
        WHEN 'SE' THEN 'Sergipe'
        WHEN 'TO' THEN 'Tocantins'
        ELSE c.customer_state 
    END AS state_name,
    sum(oi.price) AS priceAmount,
    avg(oi.freight_value) AS avgValue
FROM orders o
INNER JOIN order_items oi 
    ON o.order_id = oi.order_id
INNER JOIN customers c 
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY state_name
ORDER BY sum(oi.price) DESC;
