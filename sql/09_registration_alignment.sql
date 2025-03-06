-- 对齐注册时间的用户行为
WITH member_registration_time AS (
    SELECT cellphone
          ,min(case when flag like '%会员%' then createdate end) as member_date
          ,min(case when flag like '%注册%' then createdate end) as reg_date
    FROM baseusermap
    GROUP BY cellphone
),
valid_registration_sequence AS (
    SELECT t1.*
    FROM baseusermap t1 
    INNER JOIN member_registration_time t2 
    ON t1.cellphone = t2.cellphone
    WHERE t2.member_date >= t2.reg_date
)
-- 创建注册对齐的用户行为表
SELECT *
INTO baseuser06
FROM valid_registration_sequence;

-- 创建注册对齐的路径结果表
DROP TABLE IF EXISTS roadmap_result_0624;
CREATE TABLE roadmap_result_0624 (
    source varchar(100),
    target varchar(100),
    depth int,
    value int
);

-- 注册对齐的路径分析
DECLARE @maxnum int;
DECLARE @start int = 1;
DECLARE @regnode int;

SELECT @maxnum = max(num) FROM baseuser06;
SELECT @regnode = max(num) FROM baseuser06 WHERE flag like '%注册%';

WHILE @start <= @maxnum
BEGIN 
    IF @start = 1
    BEGIN
        WITH registration_nodes AS (
            SELECT cellphone
                  ,max(num) as n 
            FROM baseuser06
            WHERE flag like '%注册%'
            GROUP BY cellphone
        ),
        initial_paths AS (
            SELECT a.*
                  ,b.n
            FROM baseuser06 a 
            LEFT JOIN registration_nodes b ON a.cellphone = b.cellphone
            WHERE num + @regnode - n = @start
        )
        INSERT INTO roadmap_result
        SELECT 'Begin'
              ,concat(flag,@start)
              ,@start-1
              ,count(distinct cellphone)
        FROM initial_paths
        GROUP BY flag;

        SET @start = @start + 1;
    END 
    ELSE
    BEGIN
        WITH registration_nodes AS (
            SELECT cellphone
                  ,max(num) as n 
            FROM baseuser06
            WHERE flag like '%注册%'
            GROUP BY cellphone
        ),
        path_transitions AS (
            SELECT a.*
                  ,b.n
            FROM baseuser06 a 
            LEFT JOIN registration_nodes b ON a.cellphone = b.cellphone
            WHERE num + @regnode - n = @start 
            OR num + @regnode - n = @start -1
        ),
        path_summary AS (
            SELECT cellphone
                  ,max(case when num = @start - 1 then flag end) as source 
                  ,max(case when num = @start then flag end) as target 
            FROM path_transitions
            GROUP BY cellphone
        ),
        path_counts AS (
            SELECT concat(source,@start-1) as source
                  ,concat(case when target is null then concat(source,'无后续') else target end,@start) as target
                  ,@start - 1 as depth
                  ,count(distinct cellphone) as value
            FROM path_summary
            GROUP BY source, target
        )
        INSERT INTO roadmap_result
        SELECT * FROM path_counts;

        SET @start = @start + 1;
    END;
END; 