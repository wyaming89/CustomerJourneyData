-- 统计分析：注册与签到的关系
WITH first_sign_records AS (
    SELECT cellphone
          ,signdate
    FROM (
        SELECT cellphone
              ,signdate
              ,row_number() over(partition by cellphone order by signdate asc) as rowid
        FROM class_survey
    ) t1 
    WHERE rowid = 1 
    AND signdate >= '2022-01-01'
),
registration_analysis AS (
    SELECT t2.cellphone as sign_user
          ,t3.cellphone as reg_user
          ,datediff(day, t3.signdate, t3.createdate) as days_diff
    FROM first_sign_records t2
    LEFT JOIN member_info t3 ON t2.cellphone = t3.cellphone
)
SELECT count(distinct sign_user) as signcnt
      ,count(distinct reg_user) as regcnt
      ,min(days_diff) as mindiff
      ,max(days_diff) as maxdiff
FROM registration_analysis; 