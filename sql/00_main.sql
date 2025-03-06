-- 消费者全链路分析主文件
-- 按顺序执行各个分析步骤

-- 1. 初始化基础用户数据
:r ./sql/01_init_base_users.sql

-- 2. 分析用户注册行为
:r ./sql/02_user_registration.sql

-- 3. 分析营销活动数据
:r ./sql/03_marketing_activities.sql

-- 4. 分析妈妈班活动数据
:r ./sql/04_class_activities.sql

-- 5. 分析CRM活动数据
:r ./sql/05_crm_activities.sql

-- 6. 分析用户行为数据
:r ./sql/06_user_behavior.sql

-- 7. 分析应用行为数据
:r ./sql/07_app_behavior.sql

-- 8. 执行路径分析
:r ./sql/08_roadmap_analysis.sql

-- 9. 执行注册对齐分析
:r ./sql/09_registration_alignment.sql

-- 10. 执行统计分析
:r ./sql/10_statistics.sql 