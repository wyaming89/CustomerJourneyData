# 数据库表及字段清单

## 会员信息相关表
### member_info（会员基础信息表）
| 字段名 | 字段说明 |
|--------|----------|
| cellphone | 手机号 |
| createdate | 创建日期 |
| channel | 注册渠道 |
| unionid | 微信唯一标识 |

### external_contact（外部联系人表）
| 字段名 | 字段说明 |
|--------|----------|
| unionid | 微信唯一标识 |
| createdate | 创建日期 |

## 活动相关表
### class_survey（课程签到表）
| 字段名 | 字段说明 |
|--------|----------|
| cellphone | 手机号 |
| signdate | 报名日期 |
| actcode | 活动代码 |

### class_info（活动信息表）
| 字段名 | 字段说明 |
|--------|----------|
| EVENTNUMBER | 活动编号 |
| class_type1 | 活动类型1 |
| class_type2 | 活动类型1（同上） |
| activity_type | 活动类型1（同上） |

### campaign（营销活动表）
| 字段名 | 字段说明 |
|--------|----------|
| id | 活动ID |
| description | 活动描述 |

### campaign_qualification（活动资格表）
| 字段名 | 字段说明 |
|--------|----------|
| user_cellphone | 用户手机号 |
| create_time | 创建时间 |
| campaign_id | 活动ID |

### campaign_history（活动历史记录表）
| 字段名 | 字段说明 |
|--------|----------|
| user_cellphone | 用户手机号 |
| create_time | 创建时间 |
| campaign_id | 活动ID |

## 订单相关表
### order_info（订单信息表）
| 字段名 | 字段说明 |
|--------|----------|
| cellphone | 手机号 |
| createdate | 创建日期 |
| d_enable | 是否有效 |
| enable | 是否启用 |
| is_scan_order | 是否扫码订单 |

### scan_history（扫码历史记录表）
| 字段名 | 字段说明 |
|--------|----------|
| cellphone | 手机号 |
| create_time | 创建时间 |

## CRM相关表
### crm_sms_log（短信发送日志表）
| 字段名 | 字段说明 |
|--------|----------|
| cellphone | 手机号 |
| create_date | 创建日期 |
| market_id | 营销ID |
| send_group_name | 发送组名称 |
| send_result | 发送结果 |

### crm_poster_log（海报发送日志表）
| 字段名 | 字段说明 |
|--------|----------|
| cellphone | 手机号 |
| create_date | 创建日期 |
| market_id | 营销ID |
| send_group_name | 发送组名称 |
| event_type | 事件类型 |

### crm_h5_behavior（H5行为日志表）
| 字段名 | 字段说明 |
|--------|----------|
| cellphone | 手机号 |
| create_time | 创建时间 |
| event_name | 事件名称 |

### crm_work_msg_log（企业微信发送日志表）
| 字段名 | 字段说明 |
|--------|----------|
| cellphone | 手机号 |
| create_date | 创建日期 |
| market_id | 营销ID |
| send_group_name | 发送组名称 |

### crm_questionnaire（问卷答案表）
| 字段名 | 字段说明 |
|--------|----------|
| ID | 答案ID |
| cellphone | 手机号 |
| create_date | 创建日期 |
| market_id | 营销ID |
| send_group_name | 发送组名称 |

### crm_answer_detail（问卷答案详情表）
| 字段名 | 字段说明 |
|--------|----------|
| ANSWER_ID | 答案ID |
| QUESTION_ID | 问题ID |
| ANSWER | 答案内容 |

## 通话相关表
### call_virtual_phone（虚拟电话表）
| 字段名 | 字段说明 |
|--------|----------|
| telB | 手机号B |
| start_time | 开始时间 |
| call_status_type | 通话状态类型 |

### call_sms_log（短信日志表）
| 字段名 | 字段说明 |
|--------|----------|
| cellphone | 手机号 |
| create_date | 创建日期 |
| send_result | 发送结果 |

## 用户行为日志表
### app_info（应用信息表）
| 字段名 | 字段说明 |
|--------|----------|
| app_key | 应用标识 |
| app_name | 应用名称 |

### entrance_log（总入口日志表）
| 字段名 | 字段说明 |
|--------|----------|
| APP_KEY | 应用标识 |
| DEVICE_ID | 设备ID |
| ID | 记录ID |
| OPEN_ID | 开放ID |
| L_DATE | 日志日期 |
| union_id | 微信唯一标识 |
| l_timestamp | 时间戳 |

### 各应用入口日志表
以下表具有相同的字段结构：
| 字段名 | 字段说明 |
|--------|----------|
| app_key | 应用标识 |
| union_id | 微信唯一标识 |
| l_timestamp | 时间戳 |

- app_bcard_log（电子名片入口日志）
- app_product_log（产品溯源入口日志）
- app_service_log（客服入口日志）
- app_service_h5_log（客服H5入口日志）
- app_mini_program1_log（小程序1入口日志）
- app_mini_program2_log（小程序2入口日志）
- app_mini_program3_log（小程序3入口日志）
- app_product1_log（产品1入口日志）
- app_product2_log（产品2入口日志）
- app_age_log（月龄入口日志）
- app_location_log（位置入口日志）
- app_community_log（社区入口日志）
- app_class_log（课程小程序入口日志）
