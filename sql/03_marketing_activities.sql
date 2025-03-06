-- 企业微信添加记录
WITH wechat_contacts AS (
    SELECT t4.cellphone
          ,t3.createdate
          ,'添加企业微信' AS flag 
    FROM external_contact t3
    INNER JOIN #base t4 ON t3.unionid = t4.unionid
),
-- 体验包申领记录
package_applications AS (
    SELECT user_cellphone as cellphone
          ,create_time as createdate
          ,'体验包申领' as flag
    FROM campaign_qualification t1
    INNER JOIN #base t2 ON t1.user_cellphone = t2.cellphone
    WHERE campaign_id = 1292
),
-- 体验包核销记录
package_verifications AS (
    SELECT user_cellphone as cellphone
          ,create_time as createdate
          ,'体验包核销' as flag
    FROM campaign_history t1
    INNER JOIN #base t2 ON t1.user_cellphone = t2.cellphone
    WHERE campaign_id = 1292
),
-- 新客营销活动记录
new_customer_campaigns AS (
    SELECT t1.user_cellphone as cellphone
          ,t1.create_time as createdate
          ,CASE WHEN b.description like '%买大送大%' THEN '买大送大'
                WHEN b.description like '%红包%' THEN '红包'
                WHEN b.description like '%有礼%' THEN '礼品包'
                WHEN b.description like '%到店礼包%' THEN '到店礼包'
                WHEN b.description like '%指定体验包%' THEN '指定体验包' 
           END as flag
    FROM campaign_history t1
    INNER JOIN campaign b ON t1.campaign_id = b.id
    INNER JOIN #base t2 ON t1.user_cellphone = t2.cellphone
    WHERE t1.campaign_id in (1444,1442,1440,1472,1448,1446,1468,1452,1453,1456,1457,1454,1474)
)
-- 创建各类营销活动临时表
SELECT cellphone, createdate, flag INTO #qywechat FROM wechat_contacts;
SELECT cellphone, createdate, flag INTO #pnexm1 FROM package_applications;
SELECT cellphone, createdate, flag INTO #pnexm2 FROM package_verifications;
SELECT cellphone, createdate, flag INTO #newcamp FROM new_customer_campaigns; 