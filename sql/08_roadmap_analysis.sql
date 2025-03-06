-- 创建用户行为路径表
WITH all_user_behaviors AS (
    SELECT cellphone, createdate, flag FROM #temp_reg
    UNION ALL SELECT cellphone, createdate, flag FROM #qywechat
    UNION ALL SELECT cellphone, createdate, flag FROM #class
    UNION ALL SELECT cellphone, createdate, flag FROM #xm1
    UNION ALL SELECT cellphone, createdate, flag FROM #xm2
    UNION ALL SELECT cellphone, createdate, flag FROM #newcamp
    UNION ALL SELECT cellphone, createdate, flag FROM #nuainfo
    UNION ALL SELECT cellphone, createdate, flag FROM #track
    UNION ALL SELECT cellphone, createdate, flag FROM #RN30
    UNION ALL SELECT cellphone, createdate, flag FROM #tempminicrm
    UNION ALL SELECT cellphone, createdate, flag FROM #call_crm
    UNION ALL SELECT cellphone, createdate, flag FROM #scanorder
    UNION ALL SELECT cellphone, createdate, flag FROM #totalpurchase
),
user_behavior_sequence AS (
    SELECT cellphone
          ,createdate
          ,flag
          ,row_number() over(partition by cellphone order by createdate) as rowid1
          ,row_number() over(partition by cellphone, flag order by createdate) as rowid2
    FROM all_user_behaviors
    WHERE cellphone <> 'null'
),
user_behavior_summary AS (
    SELECT cellphone
          ,flag
          ,min(createdate) as createdate
          ,row_number() over(partition by cellphone order by min(createdate) asc) as num
    FROM user_behavior_sequence
    GROUP BY cellphone, flag, rowid1 - rowid2
)
-- 创建用户行为路径表
SELECT *
INTO user_roadmap
FROM all_user_behaviors;

-- 创建基础用户路径表
SELECT * 
INTO baseusermap
FROM user_behavior_summary
WHERE num <= 10; -- 粗暴剔掉异常数据

-- 创建路径结果表
DROP TABLE IF EXISTS roadmap_result;
CREATE TABLE roadmap_result (
    source varchar(100),
    target varchar(100),
    depth int,
    value int
);

-- 路径分析存储过程
DECLARE @maxnum int;
DECLARE @start int = 1;

SELECT @maxnum = max(num) FROM baseusermap;

WHILE @start <= @maxnum
BEGIN 
    IF @start = 1
    BEGIN
        WITH initial_paths AS (
            SELECT flag
                  ,count(distinct cellphone) as user_count
            FROM baseusermap
            WHERE num = @start
            GROUP BY flag
        )
        INSERT INTO roadmap_result
        SELECT 'Begin'
              ,concat(flag,@start)
              ,@start-1
              ,user_count
        FROM initial_paths;

        SET @start = @start + 1;
    END 
    ELSE
    BEGIN
        WITH path_transitions AS (
            SELECT cellphone
                  ,max(case when num = @start - 1 then flag end) as source 
                  ,max(case when num = @start then flag end) as target 
            FROM baseusermap
            WHERE num = @start or num = @start - 1
            GROUP BY cellphone
        ),
        path_counts AS (
            SELECT concat(source,@start-1) as source
                  ,concat(case when target is null then concat(source,'无后续') else target end,@start) as target
                  ,@start - 1 as depth
                  ,count(distinct cellphone) as value
            FROM path_transitions 
            GROUP BY source, target
        )
        INSERT INTO roadmap_result
        SELECT * FROM path_counts;

        SET @start = @start + 1;
    END;
END;

-- 路径分析结果
WITH all_paths AS (
    SELECT source, depth, value 
    FROM roadmap_result 
    WHERE source <> 'Begin'
    UNION ALL 
    SELECT target, depth, value 
    FROM roadmap_result
),
ranked_paths AS (
    SELECT source
          ,depth
          ,value
          ,row_number() over(partition by source order by depth asc) as rowid
    FROM all_paths
)
SELECT source as name
      ,depth
      ,value
FROM ranked_paths
WHERE rowid = 1; 