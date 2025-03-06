-- 扫码行为记录
WITH scan_activities AS (
    SELECT cellphone
          ,create_time as createdate
          ,'参与扫码' as flag
    FROM scan_history t1 
    INNER JOIN #base t2 ON t1.cellphone = t2.cellphone
),
-- 累计购买记录
purchase_history AS (
    SELECT cellphone
          ,createdate
          ,sum(cast(size as bigint)) over(partition by cellphone order by createdate asc) as ttlkg
    FROM member_info t1 
    INNER JOIN #base t2 ON t1.cellphone = t2.cellphone
),
purchase_tiers AS (
    SELECT cellphone
          ,createdate
          ,ttlkg
          ,CASE WHEN ttlkg >= 4800 and ttlkg < 5600 THEN 6 
                WHEN ttlkg >= 800*12 and ttlkg < 800*18 THEN 12
                WHEN ttlkg >= 800*18 THEN 18 
                ELSE 5 
           END as tin
          ,row_number() over(
              partition by cellphone
              ,CASE WHEN ttlkg >= 4800 and ttlkg < 5600 THEN 6 
                    WHEN ttlkg >= 800*12 and ttlkg < 800*18 THEN 12
                    WHEN ttlkg >= 800*18 THEN 18 
                    ELSE 5 
               END 
              order by createdate
           ) as rowid
    FROM purchase_history
    WHERE (ttlkg >= 4800 and ttlkg < 5600) 
    OR (ttlkg >= 800*12 and ttlkg < 800*18) 
    OR (ttlkg >= 800*18)
),
purchase_summary AS (
    SELECT cellphone
          ,createdate
          ,concat('累计',tin,'罐') as flag
    FROM purchase_tiers
    WHERE rowid = 1 
    AND tin in (6,12,18)
),
-- 复购行为分析(RN)
member_registration AS (
    SELECT cellphone, createdate
    FROM member_info e 
    INNER JOIN #base f ON e.cellphone = f.cellphone
),
repurchase_orders AS (
    SELECT a.cellphone, a.createdate
    FROM order_info a 
    INNER JOIN member_info b ON a.cellphone = b.cellphone 
    INNER JOIN #base c ON b.cellphone = c.cellphone
    WHERE d_enable = 1 
    AND enable = 1 
    AND is_scan_order = 0 
    AND datediff(day,b.createdate, a.createdate) between 1 and 90
),
repurchase_analysis AS (
    SELECT t1.cellphone
          ,t2.createdate
          ,CASE WHEN datediff(day,t1.createdate, t2.createdate) between 1 and 30 THEN 'RN30'
                WHEN datediff(day,t1.createdate, t2.createdate) between 1 and 90 THEN 'RN90' 
           END as flag
    FROM member_registration t1
    INNER JOIN repurchase_orders t2 
    ON t1.cellphone = t2.cellphone 
    AND datediff(day,t1.createdate, t2.createdate) between 1 and 90
)
-- 创建用户行为相关临时表
SELECT cellphone, createdate, flag INTO #scanorder FROM scan_activities;
SELECT cellphone, createdate, flag INTO #totalpurchase FROM purchase_summary;
SELECT cellphone, createdate, flag INTO #RN1 FROM repurchase_analysis; 