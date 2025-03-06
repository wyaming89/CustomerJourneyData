-- CRM营销触达记录
WITH crm_contacts AS (
    -- 短信触达
    SELECT cellphone 
          ,'短信' AS contact_type
          ,create_date
          ,market_id
          ,send_group_name
    FROM crm_sms_log t1
    INNER JOIN #base t2 ON t1.cellphone = t2.cellphone
    WHERE send_result = '200' 
    
    UNION ALL
    
    -- 微信海报触达
    SELECT cellphone 
          ,'微信' AS contact_type
          ,create_date
          ,market_id
          ,send_group_name
    FROM crm_poster_log t1
    INNER JOIN #base t2 ON t1.cellphone = t2.cellphone
    WHERE event_type = 'poster' 
    
    UNION ALL
    
    -- 微信H5触达
    SELECT cellphone 
          ,'微信' AS contact_type
          ,create_time as create_date
          ,null as market_id
          ,'null' send_group_name
    FROM crm_h5_behavior t1
    INNER JOIN #base t2 ON t1.cellphone = t2.cellphone
    WHERE event_name = '微信转发' 
    
    UNION ALL
    
    -- 企业微信触达
    SELECT cellphone 
          ,'企业微信' AS contact_type
          ,create_date
          ,market_id
          ,send_group_name
    FROM crm_work_msg_log t1
    INNER JOIN #base t2 ON t1.cellphone = t2.cellphone
    
    UNION ALL
    
    -- 电话问卷触达
    SELECT t1.cellphone 
          ,'致电' AS contact_type
          ,t1.create_date
          ,market_id
          ,send_group_name
    FROM crm_questionnaire t1
    INNER JOIN crm_answer_detail t2 ON t1.ID = t2.ANSWER_ID 
    INNER JOIN #base t3 ON t1.cellphone = t3.cellphone
    WHERE QUESTION_ID = '6' 
    AND ANSWER = '40'
),
crm_group_contacts AS (
    SELECT cellphone
          ,create_date AS createdate
          ,CASE WHEN send_group_name like '%Repeat%' THEN 'CRM_抓大单'
                WHEN send_group_name like '%NonReturnnewuser%' THEN 'CRM_抓复购'
                WHEN send_group_name in ('Trialuser','otherNewMember') THEN 'CRM_抓新客'
                WHEN send_group_name like '%VIP%' THEN 'CRM_抓升级'
                ELSE 'CRM_其他分组' 
           END as flag
    FROM crm_contacts
),
-- 通话记录
call_records AS (
    -- 虚拟电话记录
    SELECT telB as cellphone
          ,start_time as createdate
          ,'电话邀约触达' as flag
    FROM call_virtual_phone t1
    INNER JOIN #base t2 ON t1.telB = t2.cellphone
    WHERE call_status_type = '成功拨通'
    
    UNION ALL
    
    -- 短信通话记录
    SELECT cellphone
          ,create_date as createdate
          ,'电话邀约触达' as flag
    FROM call_sms_log t1 
    INNER JOIN #base t2 ON t1.cellphone = t2.cellphone
    WHERE send_result = 200 
)
-- 创建CRM相关临时表
SELECT cellphone, createdate, flag INTO #tempminicrm FROM crm_group_contacts;
SELECT cellphone, createdate, flag INTO #call_crm FROM call_records; 