-- 用户应用行为日志
WITH app_logs AS (
    -- 入口日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM entrance_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- 名片日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_bcard_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- 产品日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_product_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- 服务日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_service_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- H5服务日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_service_h5_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- 小程序1日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_mini_program1_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- 小程序2日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_mini_program2_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- 小程序3日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_mini_program3_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- 产品1日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_product1_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- 产品2日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_product2_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- 年龄日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_age_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- 位置日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_location_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid AND t2.unionid is not null
    GROUP BY app_key, union_id
    
    UNION ALL
    
    -- 社区日志
    SELECT app_key, union_id, min(l_timestamp) as minstampe 
    FROM app_community_log t1 
    INNER JOIN #baseuser t2 ON t1.union_id = t2.unionid
    GROUP BY app_key, union_id
),
user_behavior_track AS (
    SELECT t16.cellphone
          ,t15.minstampe as createdate
          ,t17.app_name as flag
    FROM app_logs t15 
    INNER JOIN #base t16 ON t15.union_id = t16.unionid AND t16.unionid is not null
    INNER JOIN app_info t17 ON t15.app_key = t17.app_key
)
-- 创建应用行为相关临时表
SELECT app_key, union_id, minstamp INTO userlog0623 FROM app_logs;
SELECT cellphone, createdate, flag INTO #track FROM user_behavior_track; 