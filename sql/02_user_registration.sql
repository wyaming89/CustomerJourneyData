-- 用户注册行为记录
WITH registered_users AS (
    SELECT t1.cellphone
          ,t1.createdate
          ,concat(t1.channel,'注册') AS flag 
    FROM member_info t1
    INNER JOIN #base t2 
    ON t1.cellphone = t2.cellphone
),
-- 会员状态记录
member_status AS (
    SELECT t1.cellphone
          ,t1.createdate
          ,concat('成为会员',t1.rid,'胎') as flag
    FROM member_info t1
    INNER JOIN #base t2 
    ON t1.cellphone = t2.cellphone
)
-- 创建注册行为临时表
SELECT cellphone, createdate, flag
INTO #temp_reg
FROM registered_users;

-- 创建会员状态临时表
SELECT cellphone, createdate, flag
INTO #nuainfo
FROM member_status; 