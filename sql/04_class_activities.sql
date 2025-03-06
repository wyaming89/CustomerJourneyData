-- 参与记录
WITH class_participation AS (
    SELECT t5.cellphone
          ,t5.signdate
          ,CASE WHEN class_type1 like '%商场%' THEN '商场外展'
                WHEN class_type2 like '%小区%' THEN '小区地推'
                WHEN class_type1 like '%大型%' THEN '大型路演'
                WHEN activity_type like '%直播活动%' THEN '直播活动' 
           END AS flag 
    FROM class_survey t5
    INNER JOIN class_info a ON t5.actcode = a.EVENTNUMBER
    INNER JOIN #base t6 ON t5.cellphone = t6.cellphone
    WHERE t5.signdate is not null
)
-- 创建活动临时表
SELECT cellphone, signdate, flag
INTO #mmclass
FROM class_participation; 