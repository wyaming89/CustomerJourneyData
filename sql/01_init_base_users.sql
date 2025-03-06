-- 基础用户筛选：2022年1-5月注册的有效用户
DROP TABLE IF EXISTS #base;
SELECT  cellphone
       ,unionid 
INTO #base
FROM member_info
WHERE createdate >= '2022-01-01'
AND createdate < '2022-06-01'
AND cellphone <> 'null';

-- 创建基础用户表，用于后续分析
DROP TABLE IF EXISTS #baseuser;
SELECT cellphone, unionid
INTO #baseuser
FROM member_info 
WHERE createdate >= '2022-01-01' 
AND createdate < '2022-06-01'
AND cellphone <> 'null'; 