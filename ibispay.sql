/*
 Navicat Premium Data Transfer

 Source Server         : postgreSQL local
 Source Server Type    : PostgreSQL
 Source Server Version : 110005
 Source Host           : localhost:5432
 Source Catalog        : ibispay
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 110005
 File Encoding         : 65001

 Date: 12/12/2019 23:15:33
*/


-- ----------------------------
-- Sequence structure for coin_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."coin_id_seq";
CREATE SEQUENCE "public"."coin_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."coin_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for fulfil_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."fulfil_id_seq";
CREATE SEQUENCE "public"."fulfil_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."fulfil_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for info_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."info_id_seq";
CREATE SEQUENCE "public"."info_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."info_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for news_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."news_id_seq";
CREATE SEQUENCE "public"."news_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."news_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for news_id_seq1
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."news_id_seq1";
CREATE SEQUENCE "public"."news_id_seq1" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;
ALTER SEQUENCE "public"."news_id_seq1" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for pay_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."pay_id_seq";
CREATE SEQUENCE "public"."pay_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."pay_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for pic_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."pic_id_seq";
CREATE SEQUENCE "public"."pic_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."pic_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for repay_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."repay_id_seq";
CREATE SEQUENCE "public"."repay_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."repay_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for req_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."req_id_seq";
CREATE SEQUENCE "public"."req_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."req_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for skill_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."skill_id_seq";
CREATE SEQUENCE "public"."skill_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."skill_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for snap_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."snap_id_seq";
CREATE SEQUENCE "public"."snap_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."snap_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for snap_set_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."snap_set_id_seq";
CREATE SEQUENCE "public"."snap_set_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."snap_set_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for sub_sum_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."sub_sum_id_seq";
CREATE SEQUENCE "public"."sub_sum_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;
ALTER SEQUENCE "public"."sub_sum_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for sum_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."sum_id_seq";
CREATE SEQUENCE "public"."sum_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."sum_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for trans_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."trans_id_seq";
CREATE SEQUENCE "public"."trans_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."trans_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for user_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."user_id_seq";
CREATE SEQUENCE "public"."user_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."user_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Table structure for coin
-- ----------------------------
DROP TABLE IF EXISTS "public"."coin";
CREATE TABLE "public"."coin" (
  "id" int8 NOT NULL DEFAULT nextval('coin_id_seq'::regclass),
  "name" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "pwd" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "phone" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "phone_cc" varchar(3) COLLATE "pg_catalog"."default" NOT NULL,
  "bio" text COLLATE "pg_catalog"."default",
  "email" varchar(30) COLLATE "pg_catalog"."default",
  "avatar" jsonb,
  "trans_in" int8 NOT NULL DEFAULT 0,
  "trans_out" int8 NOT NULL DEFAULT 0,
  "skill_num" int4 NOT NULL DEFAULT 0,
  "issued" int8 NOT NULL DEFAULT 0,
  "cashed" int8 NOT NULL DEFAULT 0,
  "denied" int8 NOT NULL DEFAULT 0,
  "credit" int2 NOT NULL DEFAULT 0,
  "qrc" jsonb,
  "created" timestamp(6) NOT NULL,
  "updated" timestamp(6),
  "break_num" int4 NOT NULL DEFAULT 0
)
;
ALTER TABLE "public"."coin" OWNER TO "postgres";
COMMENT ON COLUMN "public"."coin"."id" IS '鸟币id';
COMMENT ON COLUMN "public"."coin"."name" IS '鸟币号，不可重复、不可修改、少于28个字符，可用于登录。统一格式化为去除首尾空格的、以字母开头的、仅包含字母(Unicode)数字短横线的全小写格式，中间空格以短横线替换。';
COMMENT ON COLUMN "public"."coin"."pwd" IS '密码加密，不从服务器返回前端	';
COMMENT ON COLUMN "public"."coin"."phone" IS '绑定手机号，不可重复，可修改，主要用于登录和找回密码。统一格式为为E164，eg.+8618612345678';
COMMENT ON COLUMN "public"."coin"."phone_cc" IS 'Country Code';
COMMENT ON COLUMN "public"."coin"."bio" IS '技能简介，少于5000字符';
COMMENT ON COLUMN "public"."coin"."email" IS '邮箱';
COMMENT ON COLUMN "public"."coin"."avatar" IS '头像，大小参考config ';
COMMENT ON COLUMN "public"."coin"."trans_in" IS '总收入（包含收款+回收）';
COMMENT ON COLUMN "public"."coin"."trans_out" IS '总支出（包含发行+转手）   ';
COMMENT ON COLUMN "public"."coin"."skill_num" IS '当前可用的技能数  ';
COMMENT ON COLUMN "public"."coin"."issued" IS '发行量(承诺的鸟币总量)';
COMMENT ON COLUMN "public"."coin"."cashed" IS '回收量(兑现的鸟币总量) ';
COMMENT ON COLUMN "public"."coin"."denied" IS '拒绝量(拒绝兑现的鸟币总量)';
COMMENT ON COLUMN "public"."coin"."credit" IS '目前的鸟币信用，默认为0，范围0-1000';
COMMENT ON COLUMN "public"."coin"."qrc" IS '收款二维码（根据鸟币号生成），大小参考config';
COMMENT ON COLUMN "public"."coin"."break_num" IS '拒绝兑现的次数';
COMMENT ON TABLE "public"."coin" IS 'Coin 对应coin表，此表不可删除
鸟币号=鸟币名称=用户名';

-- ----------------------------
-- Table structure for img
-- ----------------------------
DROP TABLE IF EXISTS "public"."img";
CREATE TABLE "public"."img" (
  "hash" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "owner" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "guid" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "thumb" jsonb NOT NULL
)
;
ALTER TABLE "public"."img" OWNER TO "postgres";
COMMENT ON COLUMN "public"."img"."hash" IS '客户端上传的原图的 md5 hash 值，注意是原图。';
COMMENT ON COLUMN "public"."img"."owner" IS '鸟币号';
COMMENT ON COLUMN "public"."img"."guid" IS '图片唯一id';
COMMENT ON COLUMN "public"."img"."thumb" IS '缩略图属性';
COMMENT ON TABLE "public"."img" IS 'Img 对应img表，所有新的原图都要生成一个hash保存，用来检查是否有相同的图片存在。此表只可新建，不可删改。
知道name和guid就可以拼接得到服务器存放图片的路径，如： ./files/udata/鸟币号/pic/鸟币号_guid-biggest.jpg';

-- ----------------------------
-- Table structure for info
-- ----------------------------
DROP TABLE IF EXISTS "public"."info";
CREATE TABLE "public"."info" (
  "owner" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "has_news" bool NOT NULL DEFAULT false,
  "has_req" bool NOT NULL DEFAULT false,
  "read_num" int4 NOT NULL DEFAULT 0,
  "done_num" int4 NOT NULL DEFAULT 0,
  "updated" timestamp(6)
)
;
ALTER TABLE "public"."info" OWNER TO "postgres";
COMMENT ON COLUMN "public"."info"."owner" IS '鸟币号';
COMMENT ON COLUMN "public"."info"."has_news" IS '是否有新消息';
COMMENT ON COLUMN "public"."info"."has_req" IS '是否有新的鸟币回收请求';
COMMENT ON COLUMN "public"."info"."read_num" IS '已读消息数量';
COMMENT ON COLUMN "public"."info"."done_num" IS '已完成鸟币回收的次数';
COMMENT ON TABLE "public"."info" IS '动态信息，对应info表';

-- ----------------------------
-- Table structure for news
-- ----------------------------
DROP TABLE IF EXISTS "public"."news";
CREATE TABLE "public"."news" (
  "id" int8 NOT NULL DEFAULT nextval('news_id_seq'::regclass),
  "created" timestamp(6) NOT NULL,
  "desc" text COLLATE "pg_catalog"."default" NOT NULL,
  "owner" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "amount" int8,
  "buddy" varchar(20) COLLATE "pg_catalog"."default",
  "table" varchar(20) COLLATE "pg_catalog"."default",
  "source_id" int8
)
;
ALTER TABLE "public"."news" OWNER TO "postgres";
COMMENT ON COLUMN "public"."news"."desc" IS '主要内容';
COMMENT ON COLUMN "public"."news"."owner" IS '接受消息的鸟币号';
COMMENT ON COLUMN "public"."news"."amount" IS '交易金额';
COMMENT ON COLUMN "public"."news"."buddy" IS '交易对象的鸟币号';
COMMENT ON COLUMN "public"."news"."table" IS '相关数据库表名';
COMMENT ON COLUMN "public"."news"."source_id" IS '相关记录ID';

-- ----------------------------
-- Table structure for pay
-- ----------------------------
DROP TABLE IF EXISTS "public"."pay";
CREATE TABLE "public"."pay" (
  "id" int8 NOT NULL DEFAULT nextval('pay_id_seq'::regclass),
  "receiver" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "payer" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "is_issue" bool NOT NULL,
  "is_marker" bool NOT NULL,
  "amount" int8 NOT NULL,
  "snap_set_id" int8,
  "created" timestamp(6) NOT NULL,
  "trans_coin" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "guid" varchar(36) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."pay" OWNER TO "postgres";
COMMENT ON COLUMN "public"."pay"."receiver" IS '收款方鸟币号';
COMMENT ON COLUMN "public"."pay"."payer" IS '付款方鸟币号';
COMMENT ON COLUMN "public"."pay"."is_issue" IS '标记是发行还是转手';
COMMENT ON COLUMN "public"."pay"."is_marker" IS '是否是血盟，血盟为true时，忽略技能快照组snap_set_id';
COMMENT ON COLUMN "public"."pay"."amount" IS '转账数，大于0的整数';
COMMENT ON COLUMN "public"."pay"."snap_set_id" IS '技能快照组id';
COMMENT ON COLUMN "public"."pay"."created" IS '交易时间';
COMMENT ON COLUMN "public"."pay"."trans_coin" IS '交易的鸟币名';
COMMENT ON COLUMN "public"."pay"."guid" IS '转手时可能用到多个版本的鸟币，每个版本都需要新建一个pay，但这些pay都共享同一个guid';
COMMENT ON TABLE "public"."pay" IS 'Pay 支付的鸟币记录，对应pay表。此表只可新建，不可删改。
注意：支付表=鸟币发行记录+鸟币转手记录，兑现表=鸟币兑现记录。所有交易=发行+转手+兑现。
marker血盟，歃血为盟之意，也称作超级鸟币，承诺为持有者(bearer)做任何一件事。';

-- ----------------------------
-- Table structure for repay
-- ----------------------------
DROP TABLE IF EXISTS "public"."repay";
CREATE TABLE "public"."repay" (
  "id" int8 NOT NULL DEFAULT nextval('repay_id_seq'::regclass),
  "snap_id" int8,
  "bearer" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "issuer" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "is_marker" bool NOT NULL,
  "amount" int8 NOT NULL,
  "created" timestamp(6) NOT NULL
)
;
ALTER TABLE "public"."repay" OWNER TO "postgres";
COMMENT ON COLUMN "public"."repay"."snap_id" IS '实际兑现的技能快照ID';
COMMENT ON COLUMN "public"."repay"."bearer" IS '持币者的鸟币号';
COMMENT ON COLUMN "public"."repay"."issuer" IS '发币者的鸟币号';
COMMENT ON COLUMN "public"."repay"."is_marker" IS '是否是血盟，血盟为true时，忽略技能ID';
COMMENT ON COLUMN "public"."repay"."amount" IS '兑现的数量';
COMMENT ON COLUMN "public"."repay"."created" IS '交易时间';
COMMENT ON TABLE "public"."repay" IS 'Repay 兑现的鸟币记录，对应repay表。此表只可新建，不可删改。持币者发起兑现请求，发币者以技能兑现承诺(repay)
注意：支付表=鸟币发行记录+鸟币转手记录，兑现表=鸟币兑现记录。所有交易=发行+转手+兑现。
marker血盟，歃血为盟之意，也称作超级鸟币，承诺为持有者(bearer)做任何一件事。';

-- ----------------------------
-- Table structure for req
-- ----------------------------
DROP TABLE IF EXISTS "public"."req";
CREATE TABLE "public"."req" (
  "id" int8 NOT NULL DEFAULT nextval('req_id_seq'::regclass),
  "snap_id" int8 NOT NULL,
  "bearer" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "issuer" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "is_marker" bool NOT NULL,
  "amount" int8 NOT NULL,
  "state" int2 NOT NULL DEFAULT 1,
  "created" timestamp(6) NOT NULL,
  "updated" timestamp(6),
  "closed" bool NOT NULL DEFAULT false
)
;
ALTER TABLE "public"."req" OWNER TO "postgres";
COMMENT ON COLUMN "public"."req"."snap_id" IS '具体要兑现的技能ID';
COMMENT ON COLUMN "public"."req"."bearer" IS '持有者的鸟币号';
COMMENT ON COLUMN "public"."req"."issuer" IS '发行者的鸟币号';
COMMENT ON COLUMN "public"."req"."is_marker" IS '是否是血盟，是则忽略skill_id';
COMMENT ON COLUMN "public"."req"."amount" IS '兑现的鸟币数量，大于0的整数';
COMMENT ON COLUMN "public"."req"."state" IS '兑现状态（兑现时需要发行者确认，默认2小时响应，超时自动视为拒绝)';
COMMENT ON COLUMN "public"."req"."closed" IS '是否已关闭交易';
COMMENT ON TABLE "public"."req" IS 'Req 兑现请求(request)，对应req表，2小时内只能向同一用户请求一次。此表不可删除
兑现状态 state：
10.	请求方提示：已发送兑现请求，等待对方确认（2小时内未接受将影响其鸟币信用）
   	执行方提示：收到新的兑现请求（请在2小时内确认，否则将影响鸟币信用）
11.    请求方提示—血盟：已发送血盟兑现请求，等待对方确认（2小时内未接受，将影响其血盟失败次数）
	执行方提示—血盟：收到新的血盟兑现请求（请在2小时内确认，否则将影响血盟失败次数）
20.	请求方提示：鸟币已被成功回收（成功回收后，请求方显示3种状态："已兑现"、"兑现中(默认选中)"、"未兑现"按钮）
   	执行方提示：鸟币已回收，尚未完成兑现
21.	请求方提示：对方拒绝了兑现请求(包括未及时处理系统自动拒绝)
   	执行方提示：已拒绝了对方的请求，鸟币信用受到影响
22.	请求方提示：鸟币不足
23.	请求方提示：兑现失败（其他原因）
24.	请求方提示：对方未兑现技能，已直接影响其鸟币信用(状态显示选中"未兑现")
   	执行方提示：未兑现已影响鸟币信用，"重新兑现"即可立即恢复鸟币信用(点击"重新兑现"按钮后状态改为20"兑现中")，"关闭交易"则执行方不可进行任何操作
31.	请求方提示：交易完成
	执行方提示：交易完成
32.	请求方提示：交易已关闭
	执行方提示：交易已关闭';

-- ----------------------------
-- Table structure for skill
-- ----------------------------
DROP TABLE IF EXISTS "public"."skill";
CREATE TABLE "public"."skill" (
  "id" int8 NOT NULL DEFAULT nextval('skill_id_seq'::regclass),
  "owner" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "title" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "desc" varchar(10000) COLLATE "pg_catalog"."default",
  "price" int8 NOT NULL DEFAULT 1,
  "pics" jsonb,
  "tags" jsonb,
  "created" timestamp(6) NOT NULL,
  "updated" timestamp(6),
  "deleted" timestamp(6)
)
;
ALTER TABLE "public"."skill" OWNER TO "postgres";
COMMENT ON COLUMN "public"."skill"."owner" IS '鸟币号，必填';
COMMENT ON COLUMN "public"."skill"."title" IS '技能名称，不可修改，同一用户下不能输入重复标题，不超过100个字符，必填';
COMMENT ON COLUMN "public"."skill"."desc" IS '技能描述，少于10000个字符';
COMMENT ON COLUMN "public"."skill"."price" IS '技能价格（鸟币数/单位），大于0的整数，必填';
COMMENT ON COLUMN "public"."skill"."pics" IS '技能图片大小参考config';
COMMENT ON COLUMN "public"."skill"."tags" IS '类型如：技能、实物、服务、数字商品等，或者其他自定义标签';
COMMENT ON TABLE "public"."skill" IS 'Skill 最新技能（指自身天赋和任何对他人有用的东西），此表不可删除
注意：发币是使用技能快照，而不是最新技能。';

-- ----------------------------
-- Table structure for snap
-- ----------------------------
DROP TABLE IF EXISTS "public"."snap";
CREATE TABLE "public"."snap" (
  "id" int8 NOT NULL DEFAULT nextval('snap_id_seq'::regclass),
  "owner" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "title" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "desc" varchar(10000) COLLATE "pg_catalog"."default",
  "price" int8 NOT NULL DEFAULT 1,
  "pics" jsonb,
  "created" timestamp(6) NOT NULL,
  "tags" jsonb,
  "skill_id" int8 NOT NULL
)
;
ALTER TABLE "public"."snap" OWNER TO "postgres";
COMMENT ON COLUMN "public"."snap"."owner" IS '鸟币号，必填';
COMMENT ON COLUMN "public"."snap"."title" IS '技能名称，不可修改，同一用户下不能输入重复标题，不超过100个字符，必填';
COMMENT ON COLUMN "public"."snap"."desc" IS '技能描述，少于10000个字符';
COMMENT ON COLUMN "public"."snap"."price" IS '技能价格（鸟币数/单位），大于0的整数，必填';
COMMENT ON COLUMN "public"."snap"."pics" IS '技能图片大小参考config';
COMMENT ON COLUMN "public"."snap"."tags" IS '类型如：技能、实物、服务、数字商品等，或者其他自定义标签';
COMMENT ON COLUMN "public"."snap"."skill_id" IS '不同备份版本的技能的共同ID';
COMMENT ON TABLE "public"."snap" IS '技能快照，对应snap表。此表只可新建，不可删改。';

-- ----------------------------
-- Table structure for snap_set
-- ----------------------------
DROP TABLE IF EXISTS "public"."snap_set";
CREATE TABLE "public"."snap_set" (
  "id" int8 NOT NULL DEFAULT nextval('snap_set_id_seq'::regclass),
  "owner" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "created" timestamp(6) NOT NULL,
  "count" int4 NOT NULL,
  "value" int8 NOT NULL,
  "snap_ids" jsonb NOT NULL,
  "md5" varchar(36) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."snap_set" OWNER TO "postgres";
COMMENT ON COLUMN "public"."snap_set"."owner" IS '鸟币号，必填';
COMMENT ON COLUMN "public"."snap_set"."count" IS '此set的技能总数量，正整数';
COMMENT ON COLUMN "public"."snap_set"."value" IS '此set的技能总价值，正整数 ';
COMMENT ON COLUMN "public"."snap_set"."snap_ids" IS '技能快照snap_id的集合，倒序排列(snap_id为自增id)，如：[{"snap_id":"xxxx"},{"snap_id":"xxxx"}]';
COMMENT ON COLUMN "public"."snap_set"."md5" IS 'snap_ids的snap按照version倒序排列后，生成的md5 hash。用于检查是否已经存在此技能快照组';
COMMENT ON TABLE "public"."snap_set" IS '技能快照组，对应snap_set表，标识了鸟币不同版本。此表只可新建，不可删改。';

-- ----------------------------
-- Table structure for sub_sum
-- ----------------------------
DROP TABLE IF EXISTS "public"."sub_sum";
CREATE TABLE "public"."sub_sum" (
  "id" int4 NOT NULL DEFAULT nextval('sub_sum_id_seq'::regclass),
  "bearer" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "coin" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "snap_set_id" int8 NOT NULL,
  "sum" int8 NOT NULL DEFAULT 0,
  "updated" timestamp(6) NOT NULL,
  "snap_ids" jsonb
)
;
ALTER TABLE "public"."sub_sum" OWNER TO "postgres";
COMMENT ON COLUMN "public"."sub_sum"."bearer" IS '持有者的鸟币号';
COMMENT ON COLUMN "public"."sub_sum"."coin" IS '持有的鸟币名称';
COMMENT ON COLUMN "public"."sub_sum"."snap_set_id" IS '鸟币版本号';
COMMENT ON COLUMN "public"."sub_sum"."sum" IS '收入sum+正数，支出sum+负数';
COMMENT ON COLUMN "public"."sub_sum"."snap_ids" IS 'SnapSetID下的技能快照snap_id的集合，倒序排列(snap_id为自增id)，如：[{"snap_id":"xxxx"},{"snap_id":"xxxx"}] 
冗余字段，方便查询';
COMMENT ON TABLE "public"."sub_sum" IS '不同版本的鸟币持有量(注意版本是以snap_set_id来划分的)，对应sub_sum表。此表不可删除';

-- ----------------------------
-- Table structure for sum
-- ----------------------------
DROP TABLE IF EXISTS "public"."sum";
CREATE TABLE "public"."sum" (
  "bearer" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "coin" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "is_marker" bool NOT NULL,
  "sum" int8 NOT NULL DEFAULT 0,
  "id" int8 NOT NULL DEFAULT nextval('sum_id_seq'::regclass),
  "updated" timestamp(6) NOT NULL
)
;
ALTER TABLE "public"."sum" OWNER TO "postgres";
COMMENT ON COLUMN "public"."sum"."bearer" IS '持有者的鸟币号';
COMMENT ON COLUMN "public"."sum"."coin" IS '持有的鸟币名称';
COMMENT ON COLUMN "public"."sum"."is_marker" IS '是否为血盟';
COMMENT ON COLUMN "public"."sum"."sum" IS '持有量，收入者sum+正数，支出者sum+负数';
COMMENT ON TABLE "public"."sum" IS '鸟币持有量，对应sum表。此表不可删除';

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
SELECT setval('"public"."coin_id_seq"', 36, true);
SELECT setval('"public"."fulfil_id_seq"', 3, false);
SELECT setval('"public"."info_id_seq"', 6, true);
SELECT setval('"public"."news_id_seq"', 315, true);
ALTER SEQUENCE "public"."news_id_seq1"
OWNED BY "public"."news"."id";
SELECT setval('"public"."news_id_seq1"', 2, false);
SELECT setval('"public"."pay_id_seq"', 137, true);
SELECT setval('"public"."pic_id_seq"', 2, false);
ALTER SEQUENCE "public"."repay_id_seq"
OWNED BY "public"."repay"."id";
SELECT setval('"public"."repay_id_seq"', 2, true);
SELECT setval('"public"."req_id_seq"', 38, true);
SELECT setval('"public"."skill_id_seq"', 111, true);
SELECT setval('"public"."snap_id_seq"', 23, true);
SELECT setval('"public"."snap_set_id_seq"', 22, true);
ALTER SEQUENCE "public"."sub_sum_id_seq"
OWNED BY "public"."sub_sum"."id";
SELECT setval('"public"."sub_sum_id_seq"', 42, true);
SELECT setval('"public"."sum_id_seq"', 14, true);
SELECT setval('"public"."trans_id_seq"', 3, false);
SELECT setval('"public"."user_id_seq"', 30, true);

-- ----------------------------
-- Indexes structure for table coin
-- ----------------------------
CREATE INDEX "coin_cashed_idx" ON "public"."coin" USING btree (
  "cashed" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "coin_credit_idx" ON "public"."coin" USING btree (
  "credit" "pg_catalog"."int2_ops" ASC NULLS LAST
);
CREATE INDEX "coin_denied_idx" ON "public"."coin" USING btree (
  "denied" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "coin_issued_idx" ON "public"."coin" USING btree (
  "issued" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "coin_name_pwd_idx" ON "public"."coin" USING btree (
  "name" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "pwd" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "coin_phone_pwd_idx" ON "public"."coin" USING btree (
  "phone" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "pwd" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "coin_trans_in_idx" ON "public"."coin" USING btree (
  "trans_in" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "coin_trans_out_idx" ON "public"."coin" USING btree (
  "trans_out" "pg_catalog"."int8_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table coin
-- ----------------------------
ALTER TABLE "public"."coin" ADD CONSTRAINT "coin_phone_key" UNIQUE ("phone");
ALTER TABLE "public"."coin" ADD CONSTRAINT "coin_name_key" UNIQUE ("name");

-- ----------------------------
-- Checks structure for table coin
-- ----------------------------
ALTER TABLE "public"."coin" ADD CONSTRAINT "user_credit_check" CHECK ((credit >= 0));
ALTER TABLE "public"."coin" ADD CONSTRAINT "user_issued_check" CHECK ((issued >= 0));
ALTER TABLE "public"."coin" ADD CONSTRAINT "user_skill_num_check" CHECK ((skill_num >= 0));
ALTER TABLE "public"."coin" ADD CONSTRAINT "user_credit_check1" CHECK ((credit < 1000));
ALTER TABLE "public"."coin" ADD CONSTRAINT "coin_trans_in_check" CHECK ((trans_in >= 0));
ALTER TABLE "public"."coin" ADD CONSTRAINT "coin_trans_out_check" CHECK ((trans_out >= 0));
ALTER TABLE "public"."coin" ADD CONSTRAINT "user_fulfiled_check" CHECK ((cashed >= 0));
ALTER TABLE "public"."coin" ADD CONSTRAINT "user_denied_check" CHECK ((denied >= 0));
ALTER TABLE "public"."coin" ADD CONSTRAINT "coin_break_num_check" CHECK ((break_num >= 0));

-- ----------------------------
-- Rules structure for table coin
-- ----------------------------
CREATE RULE "rule_coin_delete" AS ON DELETE TO "public"."coin" DO INSTEAD NOTHING;;
COMMENT ON RULE "rule_coin_delete" ON "public"."coin" IS '此表不可删除';

-- ----------------------------
-- Primary Key structure for table coin
-- ----------------------------
ALTER TABLE "public"."coin" ADD CONSTRAINT "coin_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table img
-- ----------------------------
CREATE UNIQUE INDEX "img_guid_idx" ON "public"."img" USING btree (
  "guid" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "img_owner_idx" ON "public"."img" USING btree (
  "owner" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table img
-- ----------------------------
ALTER TABLE "public"."img" ADD CONSTRAINT "img_thumb_check" CHECK ((thumb <> '{}'::jsonb));

-- ----------------------------
-- Rules structure for table img
-- ----------------------------
CREATE RULE "rule_img_update" AS ON UPDATE TO "public"."img" DO INSTEAD NOTHING;;
CREATE RULE "rule_img_delete" AS ON UPDATE TO "public"."img" DO INSTEAD NOTHING;;
COMMENT ON RULE "rule_img_update" ON "public"."img" IS '此表只可新增，不可删改';
COMMENT ON RULE "rule_img_delete" ON "public"."img" IS '此表只可新增，不可删改';

-- ----------------------------
-- Primary Key structure for table img
-- ----------------------------
ALTER TABLE "public"."img" ADD CONSTRAINT "img_pkey" PRIMARY KEY ("hash");

-- ----------------------------
-- Primary Key structure for table info
-- ----------------------------
ALTER TABLE "public"."info" ADD CONSTRAINT "info_pkey" PRIMARY KEY ("owner");

-- ----------------------------
-- Indexes structure for table news
-- ----------------------------
CREATE INDEX "IDX_news_table" ON "public"."news" USING btree (
  "table" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "news_amount_idx" ON "public"."news" USING btree (
  "amount" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "news_buddy_idx" ON "public"."news" USING btree (
  "buddy" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "news_owner_idx" ON "public"."news" USING btree (
  "owner" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table news
-- ----------------------------
ALTER TABLE "public"."news" ADD CONSTRAINT "news_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table pay
-- ----------------------------
CREATE INDEX "pay_guid_idx" ON "public"."pay" USING btree (
  "guid" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "pay_payer_idx" ON "public"."pay" USING btree (
  "payer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "pay_payer_trans_coin_idx" ON "public"."pay" USING btree (
  "payer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "trans_coin" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "pay_receiver_idx" ON "public"."pay" USING btree (
  "receiver" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "pay_receiver_payer_idx" ON "public"."pay" USING btree (
  "receiver" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "payer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "pay_receiver_trans_coin_idx" ON "public"."pay" USING btree (
  "receiver" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "trans_coin" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "pay_snap_set_id_idx" ON "public"."pay" USING btree (
  "snap_set_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "pay_trans_coin_idx" ON "public"."pay" USING btree (
  "trans_coin" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table pay
-- ----------------------------
ALTER TABLE "public"."pay" ADD CONSTRAINT "pay_amount_check" CHECK ((amount >= 1));

-- ----------------------------
-- Rules structure for table pay
-- ----------------------------
CREATE RULE "rule_trans_update" AS ON UPDATE TO "public"."pay" DO INSTEAD NOTHING;;
CREATE RULE "rule_trans_delete" AS ON DELETE TO "public"."pay" DO INSTEAD NOTHING;;
COMMENT ON RULE "rule_trans_update" ON "public"."pay" IS '此表只可新建，不可删改。';
COMMENT ON RULE "rule_trans_delete" ON "public"."pay" IS '此表只可新建，不可删改。';

-- ----------------------------
-- Primary Key structure for table pay
-- ----------------------------
ALTER TABLE "public"."pay" ADD CONSTRAINT "pay_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table repay
-- ----------------------------
CREATE INDEX "repay_bearer_idx" ON "public"."repay" USING btree (
  "bearer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "repay_bearer_issuer_idx" ON "public"."repay" USING btree (
  "bearer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "issuer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "repay_issuer_idx" ON "public"."repay" USING btree (
  "issuer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "repay_skill_id_idx" ON "public"."repay" USING btree (
  "snap_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table repay
-- ----------------------------
ALTER TABLE "public"."repay" ADD CONSTRAINT "repay_amount_check" CHECK ((amount >= 1));

-- ----------------------------
-- Rules structure for table repay
-- ----------------------------
CREATE RULE "rule_repay_update" AS ON UPDATE TO "public"."repay" DO INSTEAD NOTHING;;
CREATE RULE "rule_repay_delete" AS ON DELETE TO "public"."repay" DO INSTEAD NOTHING;;
COMMENT ON RULE "rule_repay_update" ON "public"."repay" IS '此表只可新建，不可删改。';
COMMENT ON RULE "rule_repay_delete" ON "public"."repay" IS '此表只可新建，不可删改。';

-- ----------------------------
-- Primary Key structure for table repay
-- ----------------------------
ALTER TABLE "public"."repay" ADD CONSTRAINT "repay_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table req
-- ----------------------------
CREATE INDEX "req_bearer_idx" ON "public"."req" USING btree (
  "bearer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "req_bearer_issuer_idx" ON "public"."req" USING btree (
  "bearer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "issuer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "req_bearer_issuer_state_idx" ON "public"."req" USING btree (
  "bearer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "issuer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "state" "pg_catalog"."int2_ops" ASC NULLS LAST
);
CREATE INDEX "req_bearer_state_idx" ON "public"."req" USING btree (
  "bearer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "state" "pg_catalog"."int2_ops" ASC NULLS LAST
);
CREATE INDEX "req_issuer_idx" ON "public"."req" USING btree (
  "issuer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "req_issuer_state_idx" ON "public"."req" USING btree (
  "issuer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "state" "pg_catalog"."int2_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table req
-- ----------------------------
ALTER TABLE "public"."req" ADD CONSTRAINT "req_amount_check" CHECK ((amount >= 1));

-- ----------------------------
-- Rules structure for table req
-- ----------------------------
CREATE RULE "rule_req_delete" AS ON DELETE TO "public"."req" DO INSTEAD NOTHING;;
COMMENT ON RULE "rule_req_delete" ON "public"."req" IS '此表不可删除';

-- ----------------------------
-- Primary Key structure for table req
-- ----------------------------
ALTER TABLE "public"."req" ADD CONSTRAINT "req_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table skill
-- ----------------------------
CREATE INDEX "skill_created_idx" ON "public"."skill" USING btree (
  "created" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "skill_desc_idx" ON "public"."skill" USING btree (
  "desc" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "skill_owner_idx" ON "public"."skill" USING btree (
  "owner" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE UNIQUE INDEX "skill_owner_title_idx" ON "public"."skill" USING btree (
  "owner" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "title" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "skill_pics_idx" ON "public"."skill" USING btree (
  "pics" "pg_catalog"."jsonb_ops" ASC NULLS LAST
);
CREATE INDEX "skill_price_idx" ON "public"."skill" USING btree (
  "price" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "skill_tags_idx" ON "public"."skill" USING btree (
  "tags" "pg_catalog"."jsonb_ops" ASC NULLS LAST
);
CREATE INDEX "skill_title_idx" ON "public"."skill" USING btree (
  "title" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "skill_updated_idx" ON "public"."skill" USING btree (
  "updated" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table skill
-- ----------------------------
ALTER TABLE "public"."skill" ADD CONSTRAINT "skill_price_check" CHECK ((price >= 1));

-- ----------------------------
-- Rules structure for table skill
-- ----------------------------
CREATE RULE "skill_sum_delete" AS ON DELETE TO "public"."skill" DO INSTEAD NOTHING;;
COMMENT ON RULE "skill_sum_delete" ON "public"."skill" IS '此表不可删除';

-- ----------------------------
-- Primary Key structure for table skill
-- ----------------------------
ALTER TABLE "public"."skill" ADD CONSTRAINT "skill_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table snap
-- ----------------------------
CREATE INDEX "snap_desc_idx" ON "public"."snap" USING btree (
  "desc" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "snap_owner_idx" ON "public"."snap" USING btree (
  "owner" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "snap_pics_idx" ON "public"."snap" USING btree (
  "pics" "pg_catalog"."jsonb_ops" ASC NULLS LAST
);
CREATE INDEX "snap_price_idx" ON "public"."snap" USING btree (
  "price" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "snap_skill_id_idx" ON "public"."snap" USING btree (
  "skill_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "snap_tags_idx" ON "public"."snap" USING btree (
  "tags" "pg_catalog"."jsonb_ops" ASC NULLS LAST
);
CREATE INDEX "snap_title_idx" ON "public"."snap" USING btree (
  "title" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table snap
-- ----------------------------
ALTER TABLE "public"."snap" ADD CONSTRAINT "snap_price_check" CHECK ((price >= 1));

-- ----------------------------
-- Rules structure for table snap
-- ----------------------------
CREATE RULE "rule_snap_update" AS ON UPDATE TO "public"."snap" DO INSTEAD NOTHING;;
CREATE RULE "rule_snap_delete" AS ON DELETE TO "public"."snap" DO INSTEAD NOTHING;;
COMMENT ON RULE "rule_snap_update" ON "public"."snap" IS '此表只可新建，不可删改。';
COMMENT ON RULE "rule_snap_delete" ON "public"."snap" IS '此表只可新建，不可删改。';

-- ----------------------------
-- Primary Key structure for table snap
-- ----------------------------
ALTER TABLE "public"."snap" ADD CONSTRAINT "snap_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table snap_set
-- ----------------------------
CREATE INDEX "snap_set_owner_idx" ON "public"."snap_set" USING btree (
  "owner" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table snap_set
-- ----------------------------
ALTER TABLE "public"."snap_set" ADD CONSTRAINT "snap_set_md5_key" UNIQUE ("md5");

-- ----------------------------
-- Checks structure for table snap_set
-- ----------------------------
ALTER TABLE "public"."snap_set" ADD CONSTRAINT "skill_set_skill_num_check" CHECK ((count >= 1));
ALTER TABLE "public"."snap_set" ADD CONSTRAINT "skill_set_price_check" CHECK ((price >= 1));

-- ----------------------------
-- Rules structure for table snap_set
-- ----------------------------
CREATE RULE "rule_ss_update" AS ON UPDATE TO "public"."snap_set" DO INSTEAD NOTHING;;
CREATE RULE "rule_ss_delete" AS ON DELETE TO "public"."snap_set" DO INSTEAD NOTHING;;
COMMENT ON RULE "rule_ss_update" ON "public"."snap_set" IS '此表只可新建，不可删改。';
COMMENT ON RULE "rule_ss_delete" ON "public"."snap_set" IS '此表只可新建，不可删改。';

-- ----------------------------
-- Primary Key structure for table snap_set
-- ----------------------------
ALTER TABLE "public"."snap_set" ADD CONSTRAINT "snap_set_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table sub_sum
-- ----------------------------
CREATE UNIQUE INDEX "sub_sum_bearer_coin_snap_set_id_idx" ON "public"."sub_sum" USING btree (
  "bearer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "coin" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "snap_set_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "sub_sum_bearer_idx" ON "public"."sub_sum" USING btree (
  "bearer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "sub_sum_coin_idx" ON "public"."sub_sum" USING btree (
  "coin" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table sub_sum
-- ----------------------------
ALTER TABLE "public"."sub_sum" ADD CONSTRAINT "sub_sum_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table sum
-- ----------------------------
CREATE UNIQUE INDEX "sum_bearer_coin_is_marker_idx" ON "public"."sum" USING btree (
  "bearer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "coin" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "is_marker" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "sum_bearer_idx" ON "public"."sum" USING btree (
  "bearer" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "sum_coin_idx" ON "public"."sum" USING btree (
  "coin" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "sum_is_marker_idx" ON "public"."sum" USING btree (
  "is_marker" "pg_catalog"."bool_ops" ASC NULLS LAST
);
CREATE INDEX "sum_sum_idx" ON "public"."sum" USING btree (
  "sum" "pg_catalog"."int8_ops" ASC NULLS LAST
);

-- ----------------------------
-- Rules structure for table sum
-- ----------------------------
CREATE RULE "rule_sum_delete" AS ON DELETE TO "public"."sum" DO INSTEAD NOTHING;;
COMMENT ON RULE "rule_sum_delete" ON "public"."sum" IS '此表不可删除';

-- ----------------------------
-- Primary Key structure for table sum
-- ----------------------------
ALTER TABLE "public"."sum" ADD CONSTRAINT "sum_pkey" PRIMARY KEY ("id");
